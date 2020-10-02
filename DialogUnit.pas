unit DialogUnit;
interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Menus,
  Dialogs, ELDsgnr, ComCtrls, TypInfo, TypesUnit, FreeBasicRTTI;

type
  TDialog = class(TForm)
    ELDesigner: TELDesigner;
    procedure FormShow(Sender: TObject);
    procedure ELDesignerChangeSelection(Sender: TObject);
    procedure ELDesignerControlHint(Sender: TObject; AControl: TControl;
      var AHint: String);
    procedure ELDesignerControlInserted(Sender: TObject);
    procedure ELDesignerControlInserting(Sender: TObject;
      var AControlClass: TControlClass);
    procedure ELDesignerModified(Sender: TObject);
    procedure ELDesignerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ELDesignerDesignFormClose(Sender: TObject;
      var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
    fTyp:TType;
    fNode:TTreeNode;
    fMenuItem, fDropdownMenu:TMenuItem;
    fPage:TTabSheet;
    fNameChanged:TNotifyEvent;
    procedure SetPage(v:TTabSheet);
    procedure SetDropDownMenu(v:TMenuItem);
    procedure SetTyp(v:TType);
  protected
    procedure MenuItemClick(Sender:TObject);
    procedure SetName(const v:TComponentName);override;
    procedure WMMoved(var m:TWMMove);message wm_move;
    procedure WMActivate(var m:TWMActivate);message wm_activate;
  public
    { Public declarations }
    AssignedItems,AssignedEvents:TStrings;
    Sheet:TTabSheet;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure BuildMenu;
    procedure ActivateDialog;
    procedure ReadPage;
    procedure DeleteObjects;
    procedure Comment(C:TControl);
    procedure UnComment(C:TControl);
    property Typ:TType read ftyp write SetTyp;
    property Page:TTabSheet read fPage write SetPage;
    property Node:TTreeNode read fNode write fNode;
    property MenuItem:TMenuItem read fMenuItem;
    property DropdownMenu:TMenuItem read fDropdownMenu write SetDropDownMenu;
    property OnNameChanged:TNotifyEvent read fNameChanged write fNameChanged;
  end;

var
  Dialog: TDialog;
  Loked,DialogsList:TStringList;
  CanUpdate:boolean;

implementation

{$R *.dfm}

uses PageSheetUnit, MainUnit, ObjectsTreeUnit, ScannerUnit, ContainerUnit,
     LauncherUnit, InspectorUnit, MenuEditorUnit;

constructor TDialog.Create(AOwner:TComponent);
begin
    inherited;
    AssignedItems:=TStringList.Create;
    AssignedEvents:=TStringList.Create;
    fTyp:=TType.create;
    fTyp.Extends:=Launcher.Lib.MainTypeName;
    
    if fTyp.Extends='' then fTyp.Extends:='QForm';
    fTyp.ExtendsType:=Launcher.TypeExists(fTyp.Extends);

    fTyp.Hosted:=NamesList.AddName(fTyp.Extends);
    
    ActiveDialog:=Self;
    ActiveObject:=ActiveDialog;
    fMenuItem:=TMenuItem.Create(Self);
    fMenuItem.RadioItem:=true;
    fMenuItem.AutoCheck:=true;
    fMenuItem.OnClick:=MenuItemClick;
    fMenuItem.Tag:=integer(self);
    try
      Name:='';
    except end;
    oldName:=Name;
    Inspector.Properties.Designer:=ELDesigner;
    RTTIGetProperties(Typ.Extends,Inspector.Filter,'public');
    fMenuItem.Tag:=integer(Self);
    if DialogsList.IndexOfObject(self)=-1 then
       DialogsList.AddObject(Name,Self);
    if fPage<>nil then
       if TPageSheet(fPage).Scanner.TypExists(Typ.Hosted)<>nil then
          Typ:=TPageSheet(fPage).Scanner.TypExists(Typ.Hosted);
    ObjectsTree.Dialog:=self;      
end;

destructor TDialog.Destroy;
begin
    AssignedItems.Free;
    AssignedEvents.Free;
    fMenuItem.Free;
    if fPage<>nil then fPage:=nil;
    if DialogsList.IndexOfObject(self)>-1 then
       DialogsList.Delete(DialogsList.IndexOfObject(self));
    if fNode<>nil then fNode.Free;
    if fPage<>nil then TPageSheet(fPage).Dialog:=nil;
    if ActiveObject=Self then ActiveObject:=nil;
    if ActiveDialog=Self then ActiveDialog:=nil;  
    inherited;
end;

procedure TDialog.WMActivate(var m:TWMActivate);
begin
   inherited;
   if m.ActiveWindow=Handle then ActivateDialog;
end;

procedure TDialog.SetPage(v:TTabSheet);
begin
    fPage:=v;
    if v<>nil then
       v.Caption:=Name;
end;

procedure TDialog.SetName(const v:TComponentName);
var
   SaveState:boolean;
   i:integer;
begin
   inherited;
   if fPage<>nil then begin
      SaveState:=TPageSheet(fPage).Saved;
      fPage.Name:=Name;
      fPage.Caption:=Name;
      TPageSheet(fPage).Saved:=SaveState;
      if Sheet<>nil then Sheet.Caption:=Caption;
   end;
   if fMenuItem<>nil then fMenuItem.Caption:=Name;
   if fNode<>nil then fNode.Text:=Name;
   i:=DialogsList.IndexOfObject(self);
   if i>-1 then DialogsList[i]:=Name;
   Caption:=Name;
   if assigned(fNameChanged) then
      fNameChanged(self);
end;

procedure TDialog.SetDropDownMenu(v:TMenuItem);
begin
    fDropDownMenu:=v;
    if v<>nil then begin
       fMenuItem.Caption:=Name;
       v.Add(fMenuItem);
    end
end;

procedure TDialog.SetTyp(v:TType);
begin
    ftyp:=v;
    if v<>nil then begin
      Tag:=integer(ftyp);
      Typ.Hosted:=v.Hosted;
      Typ.Extends:=v.Extends;
      if width=0 then width:=v.cx;
      if height=0 then height:=v.cy;
      RTTIGetProperties(v.Hosted,inspector.Filter,'public');
   end
end;

procedure TDialog.WMMoved(var m:TWMMove);
begin
    inherited;
    if fPage<>nil then begin
       TPageSheet(fPage).Saved:=false;
       TPageSheet(fPage).UpdateControl(self);
    end
end;

procedure TDialog.BuildMenu;
var
  i,v,e:integer;
  s,ident,kind:string;
  m:TMenu;
  mi:TMenuItem;
  L:TList;
begin
    i:=0; L:=TList.Create;
    repeat
          s:=trim(Resources.Menus[i]);
          if pos(' ',s)>0 then begin
             ident:=copy(s,1,pos(' ',s)-1);
             kind:=trim(copy(s,pos(' ',s)+1,length(s)));
          end else begin
             ident:=s;
             kind:='';
          end;
          if compareText(ident,'begin')=0 then
             L.Add(m);
          if compareText(ident,'end')=0 then
             L.Delete(L.Count-1);
          if (CompareText(kind,'menu')=0) or
             (CompareText(kind,'menuex')=0) then begin
             menu:=TMainMenu.Create(self);
             m:=menu;
          end;
          if (CompareText(ident,'popup')=0)then begin
             M:=TMenu(L[L.Count-1]);
             if m<>nil then begin
                mi:=TmenuItem.Create(m);
                mi.Caption:=StringReplace(kind,'"','',[rfreplaceall]);
                TMainMenu(m).Items.Add(mi);
                m:=TMenu(mi);

             end;
          end;
          if (CompareText(ident,'menuitem')=0)then begin
             M:=TMenu(L[L.Count-1]);
             if m<>nil then begin
                mi:=TmenuItem.Create(m);
                if compareText(kind,'separator')=0 then
                   mi.Caption:='-'
                else begin
                   mi.Caption:=StringReplace(trim(copy(kind,1,pos(',',kind)-1)),'"','',[rfreplaceall]);
                   val(trim(copy(kind,pos(',',kind)+1,length(kind))),v,e);
                   if e=0 then mi.MenuIndex:=v;
                end;
                if m.InheritsFrom(TMainMenu) then
                   TMainMenu(m).Items.Add(mi)
                else
                   TMenuItem(m).Add(mi);
             end
          end;
          inc(i);
    until i>Resources.Menus.Count-1;L.Free;
    Resources.Menus.Clear;
end;

procedure TDialog.ReadPage;
var
   wc:TWndClassEx;
   s:TScanner;
   i,j,z,x,e,vl,lx,ly,lcx,lcy,addr:integer;
   t,cls:TType;
   v,f:TField;
   C:array of TContainer;
   tk,p,u,sv:string;
   L,Types{}:TStrings;
   pif:PPropInfo;
   function GetContainer(v:string):TContainer;
   var
     i:integer;
   begin
       result:=nil;
       for i:=low(c) to high(c) do
           if comparetext(c[i].Name,v)=0 then begin
              result:=c[i];
              exit
           end
   end;
begin
    Types:=nil;
    if fPage=nil then exit;
    s:=TPageSheet(fPage).Scanner;
    if s<>nil then s.Scan;
    if s.Types=nil then exit;
    if s.Types.Count>0 then
    for i:=0 to s.Types.Count-1 do begin
        t:=s.Typ[i];
        if Typ.Hosted=t.Hosted then begin  
           typ:=T;
           for j:=0 to typ.FieldCount-1 do begin
               v:=typ.Field[j];
               x:=Launcher.Lib.Types.IndexOf(v.Return);
               
               if x=-1 then begin
                  if Launcher.ReadUnregisterClass then begin
                     x:=Launcher.Types.IndexOf(v.Return);
                     Types:=Launcher.Types
                  end   
               end else Types:=Launcher.Lib.Types;

               if x>-1 then begin
                  if Types<>nil then cls:=TType(Types.Objects[x]);
                  f:=cls.FieldExists('constructor '+cls.Hosted);

                  if f<>nil then begin
                     SetLength(C,length(C)+1);
                     C[High(C)]:=TContainer.Create(Self);
                     C[High(C)].Parent:=self;
                     C[High(C)].Typ:=cls;
                     try
                        C[High(C)].Hosted:=v.Return;
                        if C[High(C)].Name<>'' then
                           NamesList.RemoveName(C[High(C)].Name);
                        C[High(C)].Name:=v.Hosted;
                     except
                     wc.cbSize:=sizeof(wc);
                     if GetClassInfoEx(hinstance,PChar(C[High(C)].Hosted),wc)=false then begin
                        messageDlg(format('The %s class not exists.'#10'Check on FreeBasic gui library, if that was registered.',[]),mtError,[mbok],0);
                        exit;
                     end else messageDlg('Internal error $3-TContainer: can''t create class.',mtError,[mbok],0);
                     end;

                     for x:=0 to TPageSheet(fPage).Frame.Edit.Lines.Count-1 do begin
                         tk:=TPageSheet(fPage).Frame.Edit.Lines[x];
                         if pos(lowercase(v.Hosted),lowercase(tk))>0 then
                            TPageSheet(fPage).Frame.Edit.Lines.Objects[x]:=C[High(C)];
                         if (pos(lowercase(C[High(C)].Name),lowercase(tk))>0) and{}
                            (pos('.setbounds(',lowercase(tk))>0) then begin
                             p:=trim(copy(tk,pos('(',tk)+1,pos(')',tk)-pos('(',tk)-1));
                             u:='';
                             for z:=1 to length(p) do
                                 if p[z]<>#32 then u:=u+p[z];
                                 L:=TStringList.Create;
                                 L.Text:=stringreplace(u,',',#10,[rfreplaceall]);
                                 val(L[0],lx,e);
                                 val(L[1],ly,e);
                                 val(L[2],lcx,e);
                                 val(L[3],lcy,e);
                                 if e=0 then begin
                                    C[High(C)].Left:=lx;
                                    C[High(C)].Top:=ly;
                                    C[High(C)].Width:=lcx;
                                    C[High(C)].Height:=lcy;
                                 end;
                                 L.Free;
                             end;
                             if (pos(lowercase(C[High(C)].Name),lowercase(tk))>0) and
                                 (pos('=',lowercase(tk))>0) then begin
                                 u:='';
                                 sv:='';
                                 p:=trim(copy(tk,1,pos('=',tk)-1));
                                 if pos('.',p)>0 then begin
                                    u:=trim(copy(p,pos('.',p)+1,length(p)));
                                    p:=trim(copy(p,1,pos('.',p)-1));
                                 end;
                                 sv:=trim(copy(tk,pos('=',tk)+1,length(tk)));
                                 if comparetext(p,C[High(C)].Name)=0 then begin
                                    pif:=GetPropInfo(C[High(C)],u);
                                    if pif<>nil then begin
                                      if comparetext(u,'parent')=0 then begin
                                        if comparetext(sv,'this')=0 then
                                           C[High(C)].Parent:=self
                                        else
                                           C[High(C)].Parent:=TWinControl(FindComponent(sv));
                                    end else
                                    if comparetext(u,'align')=0 then begin
                                       val(sv,vl,e);
                                       if e=0 then
                                          SetPropValue(C[High(C)],u,TAlign(strtoint(sv)))
                                       else
                                          if GetPropInfo(C[High(C)],u)<>nil then
                                             try
                                                typinfo.SetEnumProp(C[High(C)],u,sv);
                                             except
                                                messageDlg(format('No such kind , wrong property %s.',[u]),mtError,[mbok],0);
                                             end
                                    end else
                                    if comparetext(u,'canvas.color')=0 then begin
                                       SetPropValue(C[High(C)],'color',StringToColor(sv){integer()});
                                    end else
                                    if comparetext(u,'canvas.textcolor')=0 then begin
                                       addr:=GetPropValue(C[High(C)],'font');
                                       if addr>0 then
                                          TFont(Addr).Color:=StringToColor(sv);
                                    end;
                                end;
                            end;
                        end;
                    end;
                 end;
             end;
          end;
       end;
    end;

    for i:=0 to TPageSheet(fPage).Frame.Edit.Lines.Count-1 do begin
        tk:=TPageSheet(fPage).Frame.Edit.Lines[i];
        if pos('.',tk)>0 then begin
           tk:=trim(copy(tk,1,pos('.',tk)-1));
           TPageSheet(fpage).Frame.Edit.Lines.Objects[i]:=GetContainer(tk);
        end
    end ; {}

    for i:=0 to TPageSheet(fPage).Frame.Edit.Lines.Count-1 do begin
        tk:=TPageSheet(fPage).Frame.Edit.Lines[i];
        for x:=low(C) to high(C) do begin
            if (pos(lowercase(c[x].Name),lowercase(tk))>0) and (pos('setbounds',lowercase(tk))>0) then begin
                u:=trim(copy(tk,pos('(',tk)+1,pos(')',tk)-pos('(',tk)-1));
                p:='';
                j:=0;lx:=0;ly:=0;lcx:=0;lcy:=0;
                for z:=1 to length(u) do begin
                    p:=p+u[z];
                    if (u[z]=',') or (z=length(u)) then begin
                       if z<length(u) then p:=trim(copy(p,1,length(p)-1));
                       inc(j);
                       val(p,vl,e);
                       if (j=1) and (e=0) then lx:=vl;
                       if (j=2) and (e=0) then ly:=vl;
                       if (j=3) and (e=0) then lcx:=vl;
                       if (j=4) and (e=0) then lcy:=vl;
                       if j=4 then begin
                          c[x].Left:=lx;
                          c[x].Top:=ly;
                          c[x].Width:=lcx;
                          c[x].Height:=lcy;
                       end;
                       p:='';
                   end
               end
           end;

           if (pos('this.',lowercase(tk))>0) and (pos('setbounds',lowercase(tk))>0) then begin
               u:=trim(copy(tk,pos('(',tk)+1,pos(')',tk)-pos('(',tk)-1));
               p:='';
               j:=0; lx:=0;ly:=0;lcx:=0;lcy:=0;
               for z:=1 to length(u) do begin
                   p:=p+u[z];
                   if (u[z]=',') or (z=length(u)) then begin
                      if z<length(u) then p:=trim(copy(p,1,length(p)-1));
                      inc(j);
                      val(p,vl,e);
                      if (j=1) and (e=0) then lx:=vl;
                      if (j=2) and (e=0) then ly:=vl;
                      if (j=3) and (e=0) then lcx:=vl;
                      if (j=4) and (e=0) then lcy:=vl;
                      if j=4 then begin
                         Left:=lx;
                         Top:=ly;
                         Width:=lcx;
                         Height:=lcy;
                      end;
                      p:='';
                   end
               end
           end;

       end ;
    end;
    Inspector.Dialog:=self;
end;

procedure TDialog.MenuItemClick(Sender:TObject);
begin
    if not IsWindowVisible(Handle) then
       ShowWindow(Handle,sw_show);
    BringToFront;
end;

procedure TDialog.ActivateDialog;
begin
    ObjectsTree.AddObject(Self);
    Inspector.Dialog:=self;
    if typ<>nil then
       Inspector.ReadEvents(Typ);   {}
    Main.UpdateToolBars;
    ActiveDialog:=self;
    ActiveObject:=ActiveDialog
end;

procedure TDialog.FormShow(Sender: TObject);
begin
    ELDesigner.DesignControl:=self;
    ELDesigner.Active:=true
end;

procedure TDialog.ELDesignerChangeSelection(Sender: TObject);
var
  i,j:integer;
  T:TType;
  L:TStrings;
begin
    L:=nil;
    T:=nil;
    Inspector.Properties.Clear;
    if ELDesigner.SelectedControls.Count=1 then
       oldName:=ELDesigner.SelectedControls.DefaultControl.Name
    else
       oldName:='';
    for i:=0 to ELDesigner.SelectedControls.Count-1 do begin
        if ELDesigner.SelectedControls.Items[i].InheritsFrom(TDialog) then
           L:=TDialog(ELDesigner.SelectedControls.Items[i]).AssignedItems
        else
        if ELDesigner.SelectedControls.Items[i].InheritsFrom(TContainer) then
           L:=TContainer(ELDesigner.SelectedControls.Items[i]).AssignedItems;
        Inspector.Properties.Add(ELDesigner.SelectedControls.Items[i]);
        Inspector.ObjectsBox.ItemIndex:=Inspector.ObjectsBox.Items.IndexOfObject(ELDesigner.SelectedControls.Items[i]);
        ObjectsTree.TreeView.Selected:=ObjectsTree.Find(ELDesigner.SelectedControls.Items[i]);
        ELDesigner.SelectedControls.Items[i].Refresh;
        if ELDesigner.SelectedControls.Items[i].InheritsFrom(TDialog) then
           T:=TDialog(ELDesigner.SelectedControls.Items[i]).Typ else
        if ELDesigner.SelectedControls.Items[i].InheritsFrom(TContainer) then
           T:=TContainer(ELDesigner.SelectedControls.Items[i]).Typ;  if t<>nil then 
        if T<>nil then begin
           Inspector.ReadEvents(T);
           for j:=0 to Inspector.ListView.Items.Count-1 do begin
               if L.IndexOf(Inspector.ListView.Items[j].Caption)<>-1 then
               ;
           end {}
        end
    end;

end;

procedure TDialog.ELDesignerControlHint(Sender: TObject;
  AControl: TControl; var AHint: String);
begin
   if AControl.InheritsFrom(TContainer) then
      AHint:=Format('Origin: Left: %d, Top: %d'#10'Size: Width: %d, Height: %d'#10'Name: %s, ClassName: %s'#10'Module: %s',[Acontrol.Left,AControl.Top,AControl.Width,AControl.Height,AControl.Name,TContainer(AControl).Hosted,GetModuleName(hinstance)])
end;

procedure TDialog.ELDesignerControlInserted(Sender: TObject);
begin
    try
      TContainer(ELDesigner.SelectedControls.DefaultControl).Typ:=Launcher.SelType;
      if Launcher.SelType.Hosted='' then
         TContainer(ELDesigner.SelectedControls.DefaultControl).Hosted:=Launcher.SelClass;
      Launcher.ResetPalette;
      CanUpdate:=false;
      if fPage<>nil then
         TPageSheet(fPage).InsertControl(ELDesigner.SelectedControls.DefaultControl);
      ObjectsTree.UpdateDialog;
      Inspector.ReadObject(ELDesigner.SelectedControls.DefaultControl);
      Inspector.UpdateItems;
      oldName:=ELDesigner.SelectedControls.DefaultControl.Name;
    except
      Launcher.ResetPalette
    end;
    if ELDesigner.SelectedControls.Count>0 then  ELDesigner.SelectedControls.DefaultControl.Invalidate;
    ELDesigner.DesignControl.Invalidate;
    if fPage<>nil then begin
       ActiveEditor:=TPageSheet(fPage);
       TPageSheet(fPage).Scanner.Execute;
    end
end;

procedure TDialog.ELDesignerControlInserting(Sender: TObject;
  var AControlClass: TControlClass);
begin
    if Launcher.SelType<>nil then
       AControlClass:=TContainer
    else
       AControlClass:=nil;
end;

procedure TDialog.ELDesignerModified(Sender: TObject);
var
   i:integer;
begin
    Inspector.ReadObjects(self);
    Inspector.UpdateItems;
    if Page<>nil then begin
       for i:=0 to ELDesigner.SelectedControls.Count-1 do
           with TPageSheet(Page) do begin
                UpdateControl(ELDesigner.SelectedControls.Items[i]);
           end;
       TPageSheet(fPage).Saved:=false;
    end
end;

procedure TDialog.DeleteObjects;
var
   i:integer;
begin
    if fPage<>nil then begin
       for i:=ELDesigner.SelectedControls.Count-1 downto 0 do
           TPageSheet(fPage).DeleteControl(ELDesigner.SelectedControls.Items[i]);
       TPageSheet(fPage).Scanner.Execute;
    end ;
    ELDesigner.DeleteSelectedControls;
end;

procedure TDialog.ELDesignerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   i:integer;
begin
    if ssCtrl in shift then
       if key=ord('M') then begin
          MenuEditorDlg.EditMenu:=Menu;
          Menu:=nil;
          MenuEditorDlg.Menu:=MenuEditorDlg.EditMenu;
          MenuEditorDlg.Show
        end;

    if key=vk_delete then begin
       if fPage<>nil then begin
          for i:=ELDesigner.SelectedControls.Count-1 downto 0 do begin
              TPageSheet(fPage).DeleteControl(ELDesigner.SelectedControls.Items[i]);
              ObjectsTree.DeleteObject(ELDesigner.SelectedControls.Items[i]);
          end;
          TPageSheet(fPage).Scanner.Execute;
       end
    end;

end;

procedure TDialog.Comment(C:TControl);
begin
    if C=nil then exit;
    if ELDesigner.SelectedControls.IndexOf(C)>-1 then begin
       ELDesigner.LockControl(C,[lmNoReSize]+[lmNoMove]);
       Update;
       Loked.AddObject(C.Name,C)
    end

end;

procedure TDialog.UnComment(C:TControl);
var
  i:integer;
begin
    if C=nil then exit;
    if ELDesigner.SelectedControls.IndexOf(C)>-1 then begin
       ELDesigner.LockControl(C,[]);
       Update ;
       i:=Loked.IndexOfObject(C);
       if i>-1 then
          Loked.Delete(i);
    end
end;

procedure TDialog.ELDesignerDesignFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:=caHide;
end;

procedure TDialog.FormResize(Sender: TObject);
begin
    if fPage<>nil then begin
       TPageSheet(fPage).Saved:=false;
       TPageSheet(fPage).UpdateControl(self);
    end
end;

procedure TDialog.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
    if Visible then Resize:=true else Resize:=false;
end;

initialization
   Loked:=TStringList.Create;
   DialogsList:=TStringList.Create;
   DialogsList.OnChange:=Main.DialogsListChange;
finalization
   DialogsList.Free;
   Loked.Free;

end.
