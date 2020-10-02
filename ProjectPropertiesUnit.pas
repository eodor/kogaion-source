unit ProjectPropertiesUnit;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, CheckLst, TypesUnit;

type
  TProjectProperties = class(TForm)
    PageControl: TPageControl;
    TabGeneral: TTabSheet;
    LabelHelpFile: TLabel;
    PanelIcon: TPanel;
    ImageIcon: TImage;
    btnIcon: TBitBtn;
    TabDirectories: TTabSheet;
    CheckListBox: TCheckListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbxHelpFiles: TComboBox;
    btnBrowseHelp: TBitBtn;
    btnAdd: TBitBtn;
    btnAddPath: TBitBtn;
    TabCompiler: TTabSheet;
    cbxDebugInfo: TCheckBox;
    cbxCompileOnly: TCheckBox;
    cbxPreserveO: TCheckBox;
    cbxGlobalDef: TCheckBox;
    gdefName: TEdit;
    gdefValue: TEdit;
    cbxErrorCheck: TCheckBox;
    cbxFBDebug: TCheckBox;
    cbxNullPtr: TCheckBox;
    cbxAddDebug: TCheckBox;
    cbxResumeError: TCheckBox;
    cbxPrefixPath: TCheckBox;
    LabelOutExt: TLabel;
    edOutExt: TEdit;
    cbxArrayCheck: TCheckBox;
    LabelDefInfo: TLabel;
    procedure btnBrowseHelpClick(Sender: TObject);
    procedure btnIconClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAddPathClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProjectProperties: TProjectProperties;

implementation

{$R *.dfm}

uses MainUnit, HelperUnit;

procedure TProjectProperties.btnBrowseHelpClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='Help files (*.chm,*.hlp)|*.chm;*.hlp|All files (*.*)|*.*';
         if Execute then begin
            cbxHelpFiles.Text:=FileName;
            if cbxHelpFiles.Items.IndexOf(FileName)=-1 then
               cbxHelpFiles.Items.Add( FileName );
         end;      
         Free
    end;
end;

procedure TProjectProperties.btnIconClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='Icon File (*.ico)|*.ico';
         if Execute then begin
            ImageIcon.Hint:=FileName;
            ImageIcon.Picture.LoadFromFile( FileName );
         end;
         Free
    end;
end;

procedure TProjectProperties.FormShow(Sender: TObject);
var
  D:TDependencie;
  i:integer;
  L:TStrings;
  s:string;
begin
   cbxDebugInfo.Checked:=ActiveProject.DebugInfo;
   cbxAddDebug.Checked    :=ActiveProject.Debug;
   cbxCompileOnly.Checked:=    ActiveProject.CompileOnly;
   cbxPreserveO.Checked:=    ActiveProject.PreserveO;
   cbxGlobalDef.Checked    :=ActiveProject.AddGlobalDef;
   cbxErrorCheck.Checked    :=ActiveProject.ErrorCheck;
   cbxFBDebug.Checked  :=  ActiveProject.FBDebug;
   cbxResumeError.Checked  :=  ActiveProject.ResumeError;
   cbxNullPtr.Checked :=   ActiveProject.NullPtrCheck;
   cbxArrayCheck.Checked  :=  ActiveProject.ArrayCheck;
   edOutExt.Text:=ActiveProject.ExeExt;
   gDefName.Text:=ActiveProject.DefName;
   gDefValue.Text:=ActiveProject.DefValue;
   CheckListBox.Clear;
   if (ActiveProject<>nil) and (ActiveProject.Dependencies.Count>0) then
      CheckListBox.Items.Assign(ActiveProject.Dependencies)
   else begin
      L:=TStringList.Create;
      L.Text:=StringReplace(Compiler.Switch,'-i',#10'-i',[rfreplaceall]);;
      if L.Count>0 then begin
         for i:=0 to L.Count-1 do begin
             s:=trim(L[i]);
             if pos('-i',s)>0 then begin
                D:=TDependencie.Create;
                D.kind:=dkPath;
                D.item:=trim(copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1));
                if CheckListBox.Items.IndexOf(D.item)=-1 then
                   CheckListBox.Items.AddObject(D.item,D);
             end;
             if pos('-include',s)>0 then begin
                D:=TDependencie.Create;
                D.kind:=dkFile;
                D.item:=trim(copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1));
                if CheckListBox.Items.IndexOf(D.item)=-1 then
                   CheckListBox.Items.AddObject(D.item,D);
             end;
         end;
      end;
      if DirectoryExists(ExtractFilePath(ActiveProject.FileName)) then begin
         FindFiles(CheckListBox.Items,ExtractFilePath(ActiveProject.FileName),'*.bi');
         for i:=0 to CheckListBox.Items.Count-1 do begin
             D:=TDependencie.Create;
             D.kind:=dkFile;
             D.item:=CheckListBox.Items[i] ;
             CheckListBox.Items.Objects[i]:=D;
          end
      end
   end
end;

procedure TProjectProperties.btnAddClick(Sender: TObject);
var
  D:TDependencie;
begin
    with TOpenDialog.Create(nil) do begin
         Caption:='Add include file for each compiled file';
         Filter:='FreeBasic Files (*.bas,*.bi,*.fpk)|*.bas;*.bi;*.fpk|All files (*.*)|*.*';
         if Execute then
            if CheckListBox.Items.IndexOf(Filename)=-1 then begin
               D:=TDependencie.Create;
               D.kind:=dkFile;
               D.item:=Filename;
               CheckListBox.Items.AddObject(FileName,D);
            end else CheckListBox.ItemIndex:=CheckListBox.Items.IndexOf(Filename);
         Free
    end;
end;

procedure TProjectProperties.btnOKClick(Sender: TObject);
   function BuildProjectSwitch: string;
   var
      i:integer;
   begin
   result:='';
   for i:=0 to CheckListBox.Items.Count-1 do begin
       if DirectoryExists(CheckListBox.Items[i]) then
          result:=result+format(' -i "%s"',[CheckListBox.Items[i]])
       else
          result:=result+format(' -include "%s"',[CheckListBox.Items[i]])
   end ;
   if ActiveProject.AddGlobalDef then
      if ActiveProject.DefName<>'' then
         if ActiveProject.DefValue<>'' then
            result:=result+format(' -d #%s %s',[ActiveProject.DefName,ActiveProject.DefValue]);
      if ActiveProject.DebugInfo then result:=result+' -edebuginfo';
      if ActiveProject.Debug then result:=result+' -g';
      if ActiveProject.CompileOnly then result:=result+' -c';
      if ActiveProject.PreserveO then result:=result+' -C';

      if ActiveProject.ErrorCheck then result:=result+' -e';
      if ActiveProject.FBDebug then result:=result+' -edebug';
      if ActiveProject.ResumeError then result:=result+' -ex';
      if ActiveProject.NullPtrCheck then result:=result+' -exx';
   end;
begin
    if ActiveProject<>nil then begin
       ActiveProject.Icon:=ImageIcon.Hint;
       ActiveProject.Dependencies.Assign(CheckListBox.Items);
       
       ActiveProject.DebugInfo:=cbxDebugInfo.Checked;
       ActiveProject.Debug:=cbxAddDebug.Checked;
       ActiveProject.CompileOnly:=cbxCompileOnly.Checked;
       ActiveProject.PreserveO:=cbxPreserveO.Checked;
       ActiveProject.AddGlobalDef:=cbxGlobalDef.Checked;
       ActiveProject.ErrorCheck:=cbxErrorCheck.Checked;
       ActiveProject.FBDebug:=cbxFBDebug.Checked;
       ActiveProject.ResumeError:=cbxResumeError.Checked;
       ActiveProject.NullPtrCheck:=cbxNullPtr.Checked;
       ActiveProject.ArrayCheck:=cbxArrayCheck.Checked;
       ActiveProject.ExeExt:=edOutExt.Text;
       ActiveProject.DefName:=gDefName.Text;
       ActiveProject.DefValue:=gDefValue.Text;

       ActiveProject.Switch:=BuildProjectSwitch ;
    end;

end;

procedure TProjectProperties.btnAddPathClick(Sender: TObject);
var
   s:string;
   D:TDependencie;
begin
    if HelperUnit.BrowseForFolder(s,'Add dependecie path...') then begin
       if CheckListBox.Items.IndexOf(s)=-1 then begin
               D:=TDependencie.Create;
               D.kind:=dkPath;
               D.item:=s;
               CheckListBox.Items.AddObject(s,D);
            end else CheckListBox.ItemIndex:=CheckListBox.Items.IndexOf(s);
    end;

end;

end.
