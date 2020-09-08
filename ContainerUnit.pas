unit ContainerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, XPMan, ComCtrls, ToolWin, ExtCtrls, TypesUnit,
  IniFiles, FreeBasicRTTI;

const
    wm_controlstyle = wm_app+99;
    wm_acceptchilds = wm_app+98;
type
   TContainer=class(TWinControl)
   private
     fAcceptChilds:boolean;
     fCanvas:TControlCanvas;
     fAssignedProperties:TStrings;
     fAssignedEvents:TStrings;
     fHostedHandle:hwnd;
     fHosted:string;
     fTyp:TType;
     fwndProcedure, fid :integer;
     fChangeName:TNotifyEvent;
     procedure SetTyp(v:TType);
     function GetHosted:string;
     procedure SetHosted(v:string);
     procedure SetAcceptChilds(v:boolean);
   protected
     procedure CreateHosted;
     procedure Resize; override;
     procedure SetName(const v:TComponentName);override;
     procedure WMSetText(var m:TWMSetText); message wm_settext;
     procedure WMControlStyle(var m:TMessage); message wm_controlstyle;
     procedure WMAcceptChilds(var m:TMessage); message wm_acceptchilds;
   public
     Node:TTreeNode;
     AssignedItems:TStrings;
     constructor create(aowner:tcomponent);override;
     destructor destroy;override;
     procedure FreeHosted;
     property AcceptChilds:boolean read fAcceptChilds write SetAcceptChilds;
     property AssignedProperties:TStrings read fAssignedProperties ;
     property AssignedEvents:TStrings read fAssignedEvents;
     property Typ:TType read ftyp write settyp;
     property HostedHandle:hwnd read fHostedHandle;
     property Hosted:string read getHosted write sethosted;
   published
     property Canvas:TControlCanvas read fCanvas write fCanvas;
     property Color;
     property Text;
     property Align;
     property onChangeName:TNotifyEvent read fchangename write fchangename;
   end;

implementation

uses LauncherUnit, MainUnit, inspectorUnit;

function ContainerProc(dlg,msg,wparam,lparam:integer):integer; stdcall;
begin
    case msg of
    wm_nchittest : begin
                   result:=httransparent;
                   exit
                   end;
    wm_mousefirst ..wm_mouselast : begin
                   result:=1;
                   exit
                   end;
    end;
    result:=CallWindowProc(Pointer(GetWindowLong(dlg,gwl_userdata)),dlg,msg,wparam,lparam);
end;

function EnumChildProc(dlg,lparam :integer):boolean; stdcall;
var
   P, WndProc :integer;
begin
   P := GetWindowLong(Dlg, GWL_WNDPROC);
   if P <> integer(@ContainerProc) then begin
      WndProc := SetWindowLong(Dlg,GWL_WNDPROC,longint(@ContainerProc));
      SetWindowLong(Dlg,gwl_userdata, integer(WndProc));
   end;
   Result := true;
end;

constructor TContainer.create(aowner:tcomponent);
begin
    inherited;
    fAssignedProperties:=TStringList.Create;
    fAssignedEvents:=TStringList.Create;
    AssignedItems:=TStringList.Create;
    fCanvas:=TControlCanvas.Create;
    fCanvas.Control:=self;
    ControlStyle:=ControlStyle+[csAcceptsControls];
end;

destructor TContainer.destroy;
begin
   fAssignedProperties.Free;
   fAssignedEvents.Free;
   AssignedItems.Free;
   fCanvas.Free;
   inherited;
end;

procedure TContainer.SetTyp(v:TType);
begin
   fTyp:=v;
   if v<>nil then begin
      Tag:=integer(ftyp);
      Hosted:=v.Hosted;
      if width=0 then width:=v.cx; 
      if height=0 then height:=v.cy;
      RTTIGetProperties(v.Extends,inspector.Filter,'public');
   end   
end;

function TContainer.GetHosted:string;
begin
   if self<>nil then
      result:=fHosted
   else
      result:='' ;
end;

procedure TContainer.SetHosted(v:string);
var
   x:integer;
begin
   fHosted:=v;
   if v<>'' then begin
      x:=NamesList.IndexOf(v) ;
      if x=-1 then
         Name:=NamesList.AddName(v);
      RTTIGetProperties(v,inspector.Filter,'public');
      CreateHosted;
   end
end;

procedure TContainer.SetAcceptChilds(v:boolean);
begin
    fAcceptChilds:=v;
    if v then
       if (csAcceptsControls in controlStyle) then controlStyle:=controlStyle+[csAcceptsControls];
    if not v then
       if not(csAcceptsControls in controlStyle) then controlStyle:=controlStyle-[csAcceptsControls];
end;

procedure TContainer.Resize;
begin
    if isWindow(fHostedHandle) then
       MoveWindow(fHostedHandle,0,0,width,height,true);
end;

procedure TContainer.SetName(const v:TComponentName);
var
   s:string;
begin
    inherited ;
    s:=v;
    if v<>'' then
       if v[1] in ['Q','q'] then begin
          s:=copy(v,2,length(v)); 
          Name:=s; 
       end ; 
    
end;

procedure TContainer.WMSetText(var m:TWMSetText);
begin
    inherited;
    if isWindow(fHostedHandle) then SetWindowText(fHostedHandle,m.Text);
end;

procedure TContainer.WMControlStyle(var m:TMessage);
begin
    inherited;
    controlStyle:=TControlStyle(m.WParam);
end;

procedure TContainer.WMAcceptChilds(var m:TMessage);
begin
    inherited; 
    SetAcceptChilds(boolean(m.WParam));
end;

procedure TContainer.FreeHosted;
begin
   if isWindow(fHostedHandle) then begin
      DestroyWindow(fHostedHandle);
      fHostedHandle:=0;
   end
end;

procedure TContainer.CreateHosted;
var
   L:TStrings;
   F,CF:TField;
   v:pointer;
begin
    FreeHosted;
    if ftyp=nil then begin
       MessageDlg(format('Internal error $tm: RTTI bad information,'#10'type %s is missing.',[Hosted]),mtError,[mbok],0);
       exit;
    end;
    if ftyp<>nil then begin
       L:=TStringList.Create;
       if fTyp.Hosted='' then begin
          fTyp.Hosted:=Launcher.SelClass;
          fTyp.Style:=ws_child;
       end;
       RTTIGetFields(ftyp.Hosted,L);
       f:=ftyp.FieldExists('constructor '+ftyp.Hosted);
       if f<>nil then begin  
          CF:=f.FieldExists('fstyle');
          if CF<>nil then
             ftyp.Style:=computestyle(CF.Value);
          CF:=f.FieldExists('fexstyle');
          if CF<>nil then
             ftyp.Styleex:=computestyle(CF.Value);
          CF:=f.FieldExists('fcx');    
          if CF<>nil then
             ftyp.cx:=strtoint(CF.Value);
          CF:=f.FieldExists('fcy');
          if CF<>nil then
             ftyp.cy:=strtoint(CF.Value);
          if width=0 then width:=ftyp.cx;
          if height=0 then height:=ftyp.cy;
       end;
       try
          fHostedHandle:=CreateWindowEx(fTyp.StyleEx,PChar(fHosted),PChar(Text),fTyp.Style or ws_child,0,0,width,height,Handle,0,hinstance,nil);
       except
          messageDlg('External eception.'#10'Can''t create '+fHosted+'.',mtInformation,[mbok],0);
       end;
          If IsWindow(fHostedHandle) then begin
             fWndProcedure := SetWindowLong(fHostedHandle,gwl_wndproc,longint(@ContainerProc));
             SetWindowLong(fHostedHandle,gwl_userdata, integer(fWndProcedure));
             SetWindowLong(fHostedHandle,gwl_id,fid);
             EnumChildWindows(fHostedHandle, @EnumChildProc, 0);
             SendMessage(fHostedHandle,wm_setfont, Font.Handle, 1);
             SetWindowText(fHostedHandle,PChar(Text));
             ShowWindow(fHostedHandle,sw_shownormal);
          end;
       
    end;
end;

initialization
   RegisterClasses([TContainer]);
finalization
   unRegisterClasses([TContainer]);

end.
