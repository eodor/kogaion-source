unit newClassUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
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
  end;

var
  NewClass: TNewClass;
  ClassId:integer;
  F:function(id :integer=-1):PChar; stdcall;

implementation

{$R *.dfm}

uses MainUnit, ContainerUnit, LauncherUnit, HelperUnit;

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
  i :integer;
  P :TPalettePage;
  s :string;
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
        L.Add(format('    Reister("%s","%s",DialogProc',[EditClassName.Text,cbxAncestor.Text]));
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
    if ComboBoxPalette.Text='' then ComboBoxPalette.Text:='User Classes';
    escape:=false;
    if ListBox.Items.Count>0 then
       for i:=0 to ListBox.Items.Count-1 do begin
           if escape=false then begin
              if not isClassExists(ListBox.Items[i]) then
                 case messageDlg(format('The %s class not exists.'#10'Load it anyway?',[ListBox.Items[i]]),mtConfirmation,[mbyes,mbno,mbabort,mbyestoall],0) of
                      mryes:begin
                            BuildClassFile;
                            T:=Launcher.AddClass(ComboBoxPalette.Text,ListBox.Items[i]).Typ;
                            //if T<>nil then
                            //   Launcher.Classes.AddObject(ListBox.Items[i],T);
                            end;
                      mrAbort:Abort;
                      mrYesToAll:escape:=true;
                 end;
            end else Launcher.AddClass(ComboBoxPalette.Text,ListBox.Items[i]);
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
              case messageDlg(format('The %s class not exists.'#10'Load it anyway?',[EditClassName.Text]),mtConfirmation,[mbyes,mbno,mbabort],0) of
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
begin
    if EditClassName.Text='' then begin
       inc(ClassId);
       EditClassName.Text:=format('%s%d',[cbxAncestor.Items[cbxAncestor.ItemIndex],ClassId]);
    end
end;

initialization
   ClassId:=0;

end.
