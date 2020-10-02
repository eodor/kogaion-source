unit newClassUnit;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Menus, StrUtils, TypesUnit, FreeBasicRTTI;

type
  TNewClass = class(TForm)
    LabelClassOrDLL: TLabel;
    EditClassName: TEdit;
    btnDLLFile: TButton;
    ListBox: TListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    PopupMenu: TPopupMenu;
    menuDelete: TMenuItem;
    N1: TMenuItem;
    menuInfo: TMenuItem;
    LabelPalette: TLabel;
    ComboBoxPalette: TComboBox;
    LabelAncestor: TLabel;
    cbxAncestor: TComboBox;
    procedure btnDLLFileClick(Sender: TObject);
    procedure menuDeleteClick(Sender: TObject);
    procedure menuInfoClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxPaletteCloseUp(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxAncestorCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadClasses(v:string;tab:boolean); overload;
    procedure LoadClasses(v:string); overload;
    procedure BuildWrapperClass(p,c,e:string);
  end;

var
  NewClass: TNewClass;
  ClassId:integer;
  isDll:string;
  rcl:TStrings;
  F:function(id :integer=-1):PChar; stdcall;

implementation

{$R *.dfm}

uses MainUnit, ContainerUnit, LauncherUnit, HelperUnit;

procedure TNewClass.BuildWrapperClass(p,c,e:string);
var
   L:TStrings;
   d:string;
begin
   if c='' then exit;
   L:=TStringList.Create;
   if p<>'' then begin
      L.Add('/''');
      L.Add(format(' %s-was builded with rqwork7(kogaion)',[c]));
      L.Add(' dll class wrapper for freebasic');
      L.Add('''/');
      L.Add('');
      L.Add(format('#define %s_VirtualClass true',[c]));
      L.Add('');
      L.Add(format('#define Q_%s(__ptr__) *cast(%s ptr,__ptr__)',[copy(c,2,length(c)),c]));
      L.Add('');
      L.Add(format('common shared as hmodule %s_Dll',[c]));
      L.Add('');
      L.Add(format('type %s as %s ptr',['P'+copy(c,2,length(c)),c])) ;
      L.Add(format('type %s extends %s',[c,e])) ;
      L.Add('    private:');
      L.Add('      as any ptr obj');
      L.Add('    protected:');
      L.Add('      declare static function DlgProc(as hwnd,as uint,as wparam,as lparam) as lresult');
      L.Add('      Create as function stdcall(as zstring ptr,byref as hwnd,as integer,as integer,as integer,as integer,byref as any ptr) as hwnd');
      L.Add('      declare virtual sub CreateHandle');
      L.Add('      declare virtual sub Dispatch(byref as QMessage)');
      L.Add('    public:');
      L.Add('      declare virtual sub Free');
      L.Add('      declare operator cast as any ptr');
      L.Add('      declare constructor');
      L.Add('      declare destructor');
      L.Add('end type');
      L.Add('');
      L.Add(format('function %s.DlgProc(dlg as hwnd,msg as uint,wparam as wparam,lparam as lparam) as lresult',[c]));
      L.Add('    dim as PClassObject obj=cast(PClassObject,GetWindowLong(dlg,gwl_userdata))');
      L.Add('    dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)');
      L.Add('    if obj then');
      L.Add('       obj->fHandle=dlg');
      L.Add('       obj->Dispatch(m)');
      L.Add('       return CallWindowProc(cast(wndproc,GetProp(dlg,"@@@_proc")),dlg,msg,wparam,lparam)');
      L.Add('    else');
      L.Add(format('       obj=new %s',[c]));
      L.Add('       if obj then');
      L.Add('          obj->fHandle=dlg');
      L.Add('          obj->Dispatch(m)');
      L.Add('          return CallWindowProc(cast(wndproc,GetProp(dlg,"@@@_proc")),dlg,msg,wparam,lparam)');
      L.Add('       end if');
      L.Add('    end if');
      L.Add('    return CallWindowProc(cast(wndproc,GetProp(dlg,"@@@_proc")),dlg,msg,wparam,lparam)');
      L.Add('end function');
      L.Add('');
      L.Add(format('sub %s.CreateHandle',[c]));
      L.Add('    dim as any ptr obj=0');
      L.Add('    if Dll then');
      L.Add('       Create=dylibsymbol(dll,"Create")');
      L.Add('       if Create then');
      L.Add('          fHandle=ParentWindow');
      L.Add(format('          Create(strptr("%s"),fHandle,fx,fy,fcx,fcy,obj)',[c]));
      L.Add('          if IsWindow(fHandle) then');
      L.Add('             SetProp(fHandle,"@@@_proc",cast(wndproc,SetWindowLong(fHandle,gwl_wndproc,cint(@DlgProc))))');
      L.Add('             SetWindowLong(fHandle,gwl_userdata,cint(@this))');
      L.Add('          end if');
      L.Add('       end if');
      L.Add('    end if');
      L.Add('end sub');
      L.Add('');
      L.Add(format('sub %s.Dispatch(byref m as QMessage)',[c]));
      L.Add('    Base.Dispatch(m)');
      L.Add('end sub');
      L.Add('');
      L.Add(format('sub %s.Free',[c]));
      L.Add('    if Dll then');
      L.Add('       dim as sub stdcall(w as hwnd) FreeInstance');
      L.Add('       FreeInstance=dylibsymbol(Dll,"DestroyInstance")');
      L.Add('       if @FreeInstance then');
      L.Add('          FreeInstance(fHandle)');
      L.Add('          obj=0');
      L.Add('       end if');
      L.Add('    end if');
      L.Add('end sub');
      L.Add('');
      L.Add(format('operator %s.cast as any ptr',[c]));
      L.Add('    return @this');
      L.Add('end operator');
      L.Add('');
      L.Add(format('constructor %s',[c]));
      L.Add(format('   classname="%s"',[c]));
      L.Add(format('   classancestor="%s"',[c]));
      L.Add('end constructor');
      L.Add('');
      L.Add('#ifdef LocalInitialization');
      L.Add('');
      L.Add(format('sub %s_initialization constructor',[c]));
      L.Add(format('   dll=dylibload("%s")',[isDll]));
      L.Add('end sub');
      L.Add('');
      L.Add(format('sub %s_finalization destructor',[c]));
      L.Add('    dim as sub stdcall() FreeInstances');
      L.Add('    FreeInstances=dylibsymbol(Dll,"DestroyInstances")');
      L.Add('    if @FreeInstances then FreeInstances()');
      L.Add('    if dll>0 then');
      L.Add('       dylibfree(dll)');
      L.Add('       dll=0');
      L.Add('    end if');   
      L.Add('end sub');
      L.Add('');
      L.Add('#endif');
      L.Add('');
      Launcher.NewEditor(L.Text).Caption:=c;
      L.Free;
      d:=ideDir+format('fcl\%s\',[p]);
      if not DirectoryExists(d) then
         CreateDir(d);
      ActiveEditor.FileName:=d+c+'.bas';
      ActiveEditor.SilentSave(ActiveEditor.FileName);
   end
end;

procedure TNewClass.LoadClasses(v:string);
var
   s,t:string;
   i:integer;
begin
   if FileExists(v) then begin
       module:=LoadLibrary(PChar(v));
       if module>0 then begin
          @F:=GetProcAddress(module,'GetClasses');
          if not Assigned(F) then
             @F:=GetProcAddress(module,'GETCLASSES@4');
          if Assigned(F) then begin
             Launcher.AddPage(ExtractFileName(v)).DLLModule := module;
             Launcher.Modules.AddObject(format('%s-%d',[ComboBoxPalette.Text,module]),TObject(module));
             s:=StrPas(F());
             t:='';
             for i:=1 to length(s) do begin
                 t:=t+s[i];
                 if (s[i]=',') or (i=length(s)) then begin
                     if i<length(s) then t:=trim(copy(t,1,length(t)-1));
                     Launcher.AddClass(ExtractFileName(v),t);
                     t:='';
                 end;
             end;
          end;
       end;
    end else begin
       if Launcher.isClass(v)<>nil then begin
          messageDlg(format('Class %s already exists.' ,[v]),mtInformation,[mbok],0);
       end else ListBox.Items.Add(v);
    end;
end;

procedure TNewClass.LoadClasses(v:string;tab:boolean);
var
   s,t:string;
   i:integer;
begin
   if FileExists(v) then begin
       module:=LoadLibrary(PChar(v));
       if module>0 then begin
          @F:=GetProcAddress(module,'GetClasses');
          if not Assigned(F) then
             @F:=GetProcAddress(module,'GETCLASSES@4');
          if Assigned(F) then begin
             if tab then begin
                Launcher.AddPage(ExtractFileName(v)).DLLModule := module;
                Launcher.Modules.AddObject(format('%s-%d',[ComboBoxPalette.Text,module]),TObject(module));
             end;
             s:=StrPas(F());
             t:='';
             for i:=1 to length(s) do begin
                 t:=t+s[i];
                 if (s[i]=',') or (i=length(s)) then begin
                     if i<length(s) then t:=trim(copy(t,1,length(t)-1));
                     ListBox.Items.Add(t);
                     t:='';
                 end;
             end;
          end;
       end;
    end else begin
       if Launcher.isClass(v)<>nil then begin
          messageDlg(format('Class %s already exists.',[v]),mtInformation,[mbok],0);
       end else ListBox.Items.Add(v);
    end;
end;

procedure TNewClass.btnDLLFileClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter :='DLL File (*.dll)|*.dll';
         if Execute then begin
            EditClassName.Text := FileName;
            isDll:=FileName
         end;   
         Free;
    end;
    LoadClasses(EditClassName.Text,false);
end;

procedure TNewClass.menuDeleteClick(Sender: TObject);
begin
    ListBox.Items.Delete(Listbox.ItemIndex);
end;

procedure TNewClass.menuInfoClick(Sender: TObject);
var
  s,u :string; t :PAnsiChar;
begin
    t:=StrAlloc(256);
    Windows.GetModuleFileName(module,t,255);
    u:=t;
    u:=trimright(u);
    s :=format('AliasClass: %s'#10'Module: %s',[ListBox.Items[ListBox.ItemIndex],u]);
    messageDlg(s,mtInformation,[mbok],0);
end;

procedure TNewClass.PopupMenuPopup(Sender: TObject);
begin
   menuDelete.Enabled := ListBox.ItemIndex>-1;
   menuInfo.Enabled := menuDelete.Enabled;
end;

procedure TNewClass.FormShow(Sender: TObject);
var
   i :integer;
begin
   isDll:='';
   ComboBoxPalette.Clear;
   for i := 0 to Launcher.PaletteClasses.PageCount-1 do
       ComboBoxPalette.AddItem(Launcher.PaletteClasses.Pages[i].Caption,Launcher.PaletteClasses.Pages[i]);
   cbxAncestor.Clear;
   cbxAncestor.Items.Assign(Launcher.Lib.Types);    
end;

procedure TNewClass.ComboBoxPaletteCloseUp(Sender: TObject);
begin
    Launcher.PaletteClasses.ActivePageIndex :=ComboBoxPalette.ItemIndex;
end;

procedure TNewClass.btnOKClick(Sender: TObject);
var
  i,j :integer;
  P :TPalettePage;
  s,cn :string;
  escape:boolean;
  T:TType;
  B:TPaletteButton;
  function isClassExists(v:string):boolean;
  var
     w :TWndClassEx;
  begin
     w.cbSize:=sizeof(w);
     result:=GetClassInfoEx(0,PChar(v),w) or GetClassInfoEx(hinstance,PChar(v),w) or GetClassInfoEx(hinstance,PChar(module),w);
  end;
  function BuildClassFile :TType;
  var
     L:TStrings;
  begin
     L:=TStringList.Create;
     L.Add(format('#define %s_RegisterClasses "%s"',[ComboBoxPalette.Text,EditClassName.Text])) ;
     L.Add('') ;
     L.Add(format('type P%s as %s ptr',[copy(EditClassName.Text,2,length(EditClassName.Text)),EditClassName.Text]));
     L.Add(format('type %s extends %s',[EditClassName.Text,cbxAncestor.Items[cbxAncestor.ItemIndex]]));
     L.Add('   public:');
     L.Add('   declare virtual operator cast as any ptr');
     L.Add('   declare constructor');
     L.Add('   declare destructor');
     L.Add('end type');
     L.Add('');
     L.Add(format('operator %s.cast as any ptr',[EditClassName.Text]));
     L.Add('    return @this ');
     L.Add('end operator');
     L.Add('');
     L.Add(format('constructor %s',[EditClassName.Text]));
     L.Add(format('    ClassName="%s"',[EditClassName.Text]));
     L.Add('end constructor');
     L.Add('');
     L.Add(format('destructor %s',[EditClassName.Text]));
     L.Add('    ''your code here');
     L.Add('end destructor');
     L.Add('');
     T:=RTTIInheritFrom(EditClassName.Text,'QFrame');
     if T<>nil then begin
        L.Add(format('sub %s_initialization',[EditClassName.Text]));
        L.Add(format('    ''Register procedure if is case',[EditClassName.Text,cbxAncestor.Text]));
        L.Add('end sub');
        L.Add('');
     end;
     s:=NewEditor().Caption;
     i:=NamesList.IndexOf(s);
     if i>-1 then NamesList.Delete(i);
     ActiveEditor.Caption:=EditClassName.Text;
     ActiveEditor.Frame.Edit.Lines.AddStrings(L);
     result:=ActiveEditor.Scanner.TypExists(EditClassName.Text);
     L.Free;
  end;
begin
    if ComboBoxPalette.Text='' then ComboBoxPalette.Text:='User';
    escape:=false;
    if ListBox.Items.Count>0 then begin
       for i:=0 to ListBox.Items.Count-1 do begin
           if escape=false then begin
              if not isClassExists(ListBox.Items[i]) then
                 case messageDlg(format('The %s class not registered.'#10'Load it anyway?',[ListBox.Items[i]]),mtConfirmation,[mbyes,mbno,mbabort,mbyestoall],0) of
                      mryes:begin
                            BuildClassFile;
                            T:=Launcher.AddClass(ComboBoxPalette.Text,ListBox.Items[i]).Typ;
                            //if T<>nil then
                            //   Launcher.Classes.AddObject(ListBox.Items[i],T);
                            end;
                      mrAbort:Abort;
                      mrYesToAll:escape:=true;
                 end;
            end else begin
                Launcher.AddClass(ComboBoxPalette.Text,ListBox.Items[i]);
                BuildWrapperClass(ComboBoxPalette.Text,ListBox.Items[i],'QFrame');
                rcl.Add(ListBox.Items[i])
            end ;
       end;
            for j:=0 to rcl.Count-1 do
                if (j=0) then cn:=cn+rcl[j] else cn:=cn+','+rcl[j] ;
            RCL.Text:=format('#define %s_RegisterClasses "%s"',[ComboBoxPalette.Text,cn]);
            RCL.SaveToFile(changeFileExt(isDll,'.fpk'));
    end;
    if EditClassName.Text<>'' then
       s:= GetFileNameFromOLEClass(EditClassName.Text);
       if FileExists(s) then begin
          NewEditor(s);
          messageDlg(format('The ''%s'' class look like a ActiveX class.',[EditClassName.Text]),mtInformation,[mbok],0);
          exit
       end;
       if not FileExists(EditClassName.Text) then
          if not isClassExists(EditClassName.Text) then
              case messageDlg(format('The %s class not registered.'#10'Load it anyway?',[EditClassName.Text]),mtConfirmation,[mbyes,mbno,mbabort],0) of
                  mryes: begin
                         BuildClassFile;
                         B:=Launcher.AddClass(ComboBoxPalette.Text,EditClassName.Text);
                         T:=B.Typ;
                         //if T<>nil then
                         //   Launcher.Classes.AddObject(ListBox.Items[i],T);
                         end;
                  mrabort:Abort;
              end;
    P := Launcher.isPage(ComboBoxPalette.Text);
    if (P<>nil) and FileExists(EditClassName.Text) then begin
        P.DLLModule:=LoadLibrary(PChar(EditClassName.Text));
        Launcher.Modules.AddObject(format('%s-%s',[P.Caption,P.Module]),TObject(P.DLLModule));
    end;
    Launcher.UpdateItems;
end;

procedure TNewClass.cbxAncestorCloseUp(Sender: TObject);
var
   c:string;
begin
    if EditClassName.Text='' then begin
       inc(ClassId);
       c:=cbxAncestor.Items[cbxAncestor.ItemIndex];
       if c='' then begin c:='TNewClass';cbxAncestor.Text:=c; end;
       EditClassName.Text:=format('%s%d',[c,ClassId]);
    end
end;

initialization
   ClassId:=0;
   rcl:=TStringList.Create;
finalization
   rcl.Free;   
end.
