unit SettingsUnit;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ELDsgnr, ComCtrls, ExtCtrls, IniFiles,
  CompletionDataBase, LauncherUnit, TypesUnit, Clipbrd, HelperUnit,
  Menus, ShellApi;

type
  TDllModule=class
  public
    Handle:hmodule;
    FileName:string;
  end;
  TSettings = class(TForm)
    PageControl: TPageControl;
    TabGeneral: TTabSheet;
    LabelFilter: TLabel;
    LabelDBMaskFiles: TLabel;
    cbMinimizeOnRun: TCheckBox;
    cbDisableOnRun: TCheckBox;
    cbEditOptionsGlobal: TCheckBox;
    cbDesignerOptionsGlobal: TCheckBox;
    btClearMRUFiles: TBitBtn;
    btClearMRUExe: TBitBtn;
    cbxFilters: TComboBox;
    cbResourcesEmbed: TCheckBox;
    cbConjoin: TCheckBox;
    cbAlowMultipleFileInstances: TCheckBox;
    cbDataBaseOnLoad: TCheckBox;
    cbxDBMaskFile: TComboBox;
    cbTerminateOnExit: TCheckBox;
    cbAlowCompletion: TCheckBox;
    cbxReadScriptFolder: TCheckBox;
    TabDesigner: TTabSheet;
    LabelXStep: TLabel;
    LabelYStep: TLabel;
    LabelColor: TLabel;
    EditX: TEdit;
    EditY: TEdit;
    UpDownX: TUpDown;
    UpDownY: TUpDown;
    PanelColor: TPanel;
    cbGridVisible: TCheckBox;
    TabCompiler: TTabSheet;
    LabelPzth: TLabel;
    LabelSwitch: TLabel;
    LabelFileInfo: TLabel;
    cbxCompilers: TComboBox;
    btCompiler: TBitBtn;
    cbxSwitches: TComboBox;
    cbRunWithDebug: TCheckBox;
    btnAddExclusion: TBitBtn;
    TabApplication: TTabSheet;
    LabelAppHelpFile: TLabel;
    btnIcon: TBitBtn;
    PanelImage: TPanel;
    Image: TImage;
    cbxAppHelpFile: TComboBox;
    btCancel: TBitBtn;
    btOK: TBitBtn;
    cbxShowOnlyOneError: TCheckBox;
    TabSheet1: TTabSheet;
    ListBoxDirs: TListBox;
    btnAddPath: TBitBtn;
    LabelDirs: TLabel;
    btnLibrary: TBitBtn;
    edLibrary: TEdit;
    cbxReadUnregisterClass: TCheckBox;
    btnRemovePath: TBitBtn;
    PopupMenuDirs: TPopupMenu;
    menuAddPath: TMenuItem;
    menuRemovePath: TMenuItem;
    TabModules: TTabSheet;
    ListBoxDLLs: TListBox;
    btnAddDLL: TBitBtn;
    btnRemoveDLLs: TBitBtn;
    N1: TMenuItem;
    menuCopyDir: TMenuItem;
    PopupMenuDLLs: TPopupMenu;
    menuCopyDLLs: TMenuItem;
    ListBoxClasses: TListBox;
    cbxAlowPlugins: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btClearMRUFilesClick(Sender: TObject);
    procedure btClearMRUExeClick(Sender: TObject);
    procedure btCompilerClick(Sender: TObject);
    procedure cbxSwitchesCloseUp(Sender: TObject);
    procedure cbxFiltersCloseUp(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btnIconClick(Sender: TObject);
    procedure btnAddExclusionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxDBMaskFileKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxCompilersChange(Sender: TObject);
    procedure PanelColorClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddPathClick(Sender: TObject);
    procedure btnLibraryClick(Sender: TObject);
    procedure btnRemovePathClick(Sender: TObject);
    procedure ListBoxDirsClick(Sender: TObject);
    procedure menuAddPathClick(Sender: TObject);
    procedure menuRemovePathClick(Sender: TObject);
    procedure ListBoxDirsDblClick(Sender: TObject);
    procedure menuCopyDirClick(Sender: TObject);
    procedure btnAddDLLClick(Sender: TObject);
    procedure btnRemoveDLLsClick(Sender: TObject);
    procedure menuCopyDLLsClick(Sender: TObject);
    procedure ListBoxDLLsClick(Sender: TObject);
    procedure ListBoxDLLsDblClick(Sender: TObject);
  private
    { Private declarations }
    EraseFiles, EraseExes :boolean;
    procedure FileEvent(Sender:TObject;v:string);
  public
    { Public declarations }
    function Execute(v:integer=0):boolean;
    procedure LoadDirectories;
    procedure UpdateDirectories;
    function BuildIncludePaths:string;
  end;

var
  Settings: TSettings;
  ActiveModule:TDllModule;
  GetClasses:function :PChar; stdcall;

implementation

{$R *.dfm}

uses MainUnit, CodeUnit,ResourceDialogUnit;

function TSettings.Execute(v:integer=0):boolean;
begin
    PageControl.ActivePageIndex:=v;
    //FormStyle:=fsStayOnTop;
    ShowModal;
    result:=ModalResult=mrok;
end;

procedure TSettings.FormShow(Sender: TObject);
var
   L :TStrings;
   ifl:string;
begin
   ListBoxDlls.Items.Assign(DLLModules);
   ifl:=ChangeFileExt(ParamStr(0),'.ini');
   with TIniFile.Create(ifl) do begin
        ReadSection('IncPaths',ListBoxDirs.Items);
   end;
   EraseFiles:=false;
   EraseExes:=false;
   cbxCompilers.Items.Assign(Launcher.Compilers);
   cbxSwitches.Text:=Launcher.Switch;
   if Launcher.Compilers.Text<>'' then
      cbxCompilers.Items.Assign( Launcher.Compilers);
   cbxCompilers.Text:=Launcher.Compiler.FileName;
   if cbxCompilers.Items.IndexOf(cbxCompilers.Text)=-1 then
      cbxCompilers.Items.Add(cbxCompilers.Text);
   cbxReadUnregisterClass.Checked:=Launcher.ReadUnregisterClass;
   cbxShowOnlyOneError.Checked:=Launcher.onlyOneError;
   cbxReadScriptFolder.Checked:=Launcher.ReadScripts;
   cbAlowCompletion.Checked:=Launcher.AlowCompletion;
   cbxDBMaskFile.Items.Assign(Launcher.DBMasks);
   cbTerminateOnExit.Checked:=Launcher.TerminateOnExit;
   cbAlowMultipleFileInstances.Checked:=Launcher.AllowMultipleFileInstances;
   cbDataBaseOnLoad.Checked:=Launcher.DataBaseOnLoad;
   cbConjoin.Checked:=Launcher.Conjoin;
   cbMinimizeOnRun.Checked:=Launcher.MinimizeOnRun;
   cbDisableOnRun.Checked:=Launcher.DisableOnRun;
   cbEditOptionsGlobal.Checked:=Launcher.EditIsGlobal;
   cbDesignerOptionsGlobal.Checked:=Launcher.DesignerIsGlobal;
   cbResourcesEmbed.Checked:=Launcher.ResourcesEmbed;
   cbGridVisible.Checked:=Launcher.Designer.Grid.Visible;
   UpDownX.Position:=Launcher.Designer.Grid.XStep;
   UpDownY.Position:=Launcher.Designer.Grid.YStep;
   PanelColor.Color:=Launcher.Designer.Grid.Color;
   cbxFilters.Text :=Launcher.Filter;
   Image.Hint:=Launcher.App.IconPath;
   Image.Picture.LoadFromFile(Image.Hint);
   cbxAppHelpFile.Text:=Launcher.App.Help;
   cbxAlowPlugins.Checked:=Launcher.AlowPlugins;
   
   //RadioGroup.ItemIndex:=integer(Launcher.App.Kind);
   L:=TStringList.Create;
   with TIniFile.Create(ifl) do begin
        ReadSection('Compilers',Launcher.Compilers);
        cbxCompilers.items.Assign(Launcher.Compilers);
        cbxCompilers.ItemIndex:=cbxCompilers.Items.IndexOf(Launcher.Compiler.FileName);
        ReadSection('Switches',L);
        cbxSwitches.items.Assign(L);
        ReadSection('Filters',L);
        cbxFilters.items.Assign(L);
        Free;
   end;
   L.Free
end;

procedure TSettings.FileEvent(Sender:TObject;v:string);
begin
    LabelFileInfo.Caption:=format('scanning: %s',[v]);
end;

procedure TSettings.btOKClick(Sender: TObject);
var
   i :integer;
begin
   ActiveResult.Edit.ClearAll;
   PageControl.ActivePageIndex:=2;
   Launcher.Compiler.FileName:=cbxCompilers.Text;
   Compiler.FileName:=Launcher.Compiler.FileName;

   Launcher.AlowPlugins:=cbxAlowPlugins.Checked;
   Launcher.ReadUnregisterClass:=cbxReadUnregisterClass.Checked;
   Launcher.onlyOneError:=cbxShowOnlyOneError.Checked;
   Launcher.ReadScripts:=cbxReadScriptFolder.Checked;
   Launcher.AlowCompletion:=cbAlowCompletion.Checked;
   Launcher.TerminateOnExit:=cbTerminateOnExit.Checked;
   Launcher.AllowMultipleFileInstances:=cbAlowMultipleFileInstances.Checked;
   Launcher.DataBaseOnLoad:=cbDataBaseOnLoad.Checked;
   Launcher.Switch:=cbxSwitches.Text;
   Launcher.Filter:=cbxFilters.Text;
   Launcher.Conjoin:=cbConjoin.Checked;
   Launcher.MinimizeOnRun:=cbMinimizeOnRun.Checked;
   Launcher.DisableOnRun:=cbDisableOnRun.Checked;
   Launcher.EditIsGlobal:=cbEditOptionsGlobal.Checked;
   Launcher.DesignerIsGlobal:=cbDesignerOptionsGlobal.Checked;
   Launcher.ResourcesEmbed:=cbResourcesEmbed.Checked;
   Launcher.Designer.Grid.Visible:=cbGridVisible.Checked;
   Launcher.Designer.Grid.XStep:=UpDownX.Position;
   Launcher.Designer.Grid.YStep:=UpDownY.Position;
   Launcher.Designer.Grid.Color:=PanelColor.Color;
   Launcher.App.IconPath:=Image.Hint;
   Launcher.App.Help:=cbxAppHelpFile.Text;
   cbxSwitchesCloseUp(cbxSwitches);
   BuildIncludePaths;
   with TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini')) do begin;
        if EraseFiles then begin
           EraseSection('MRUFiles');
           Launcher.MRUFilesMenu.Items.Clear;
           Launcher.MRUFiles.Clear;
        end;
        if EraseExes then begin
           EraseSection('MRUExes');
           Launcher.MRUExesMenu.Items.Clear;
           Launcher.MRUExes.Clear;
        end;
        EraseSection('IncPaths');
        for i:=0 to ListBoxDirs.Items.Count-1 do
            WriteString('IncPaths',ListBoxDirs.Items[i],inttostr(i));
        for i :=0 to cbxCompilers.Items.Count-1 do
            WriteString('Compilers',cbxCompilers.Items[i],cbxCompilers.Items[i]);
        for i :=0 to cbxSwitches.Items.Count-1 do
            WriteString('Switches',cbxSwitches.Items[i],cbxSwitches.Items[i]);
        for i :=0 to cbxFilters.Items.Count-1 do
            WriteString('Filters',cbxFilters.Items[i],cbxFilters.Items[i]);
        EraseSection('Compilers');
        EraseSection('DBMasks');
        for i :=0 to cbxCompilers.Items.Count-1 do
            WriteString('Compilers',cbxCompilers.Items[i],cbxCompilers.Items[i]);
        for i :=0 to cbxDBMaskFile.Items.Count-1 do
            WriteString('DBMasks',cbxDBMaskFile.Items[i],cbxDBMaskFile.Items[i]);
        WriteString('DBMask',cbxDBMaskFile.Text,cbxDBMaskFile.Text);    
        Free;
   end;

   ModalResult:=mrok;
   Close;
end;

procedure TSettings.btClearMRUFilesClick(Sender: TObject);
begin
   EraseFiles:=true;
end;

procedure TSettings.btClearMRUExeClick(Sender: TObject);
begin
   EraseExes:=true;
end;

procedure TSettings.btCompilerClick(Sender: TObject);
begin
   with TOpenDialog.Create(nil) do begin
        Filter :='Executable Files (*.exe)|*.exe';
        if Execute then begin
           cbxCompilers.Text:=FileName;
           if cbxCompilers.Items.IndexOf(FileName)=-1 then begin
              cbxCompilers.Items.Add(FileName);
              cbxCompilers.ItemIndex:= cbxCompilers.Items.IndexOf(FileName);
              Launcher.Compiler.FileName:=FileName;
              Compiler.FileName:=Launcher.Compiler.FileName;
           end;
        Free;
        end;
   end;
end;

procedure TSettings.cbxSwitchesCloseUp(Sender: TObject);
var
   s:string;
begin
    s:= cbxSwitches.Text;//Items[cbxSwitches.ItemIndex];
    if s='' then exit;
    if cbxSwitches.Items.IndexOf(s)=-1 then begin
       cbxSwitches.Items.Add(s);
    end;
    Launcher.Switch:=s;
end;

procedure TSettings.cbxFiltersCloseUp(Sender: TObject);
var
   s:string;
begin
    s:= cbxFilters.Text;//Items[cbxFilters.ItemIndex];
    if s='' then exit;
    if cbxFilters.Items.IndexOf(s)=-1 then begin
       cbxFilters.Items.Add(s);
       Launcher.DBMask:=s;
    end;
end;

procedure TSettings.btCancelClick(Sender: TObject);
begin
   ModalResult:=mrcancel;
   Close;
end;

procedure TSettings.btnIconClick(Sender: TObject);
var
   RI:TResourceItem;
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='Icon file (*.ico)|*.ico';
         if Execute then begin
            Image.Picture.LoadFromFile(FileName);
            Image.Hint:=FileName;
            RI:=TResourceItem.Create;
            RI.FileName:=FileName;
            RI.Buffer.LoadFromFile(FileName);
            if Resources.ResourceExists(FileName)=nil then
               Resources.Items.AddObject(RI.Name,RI);
         end;
         Free;
    end
end;

procedure TSettings.btnAddExclusionClick(Sender: TObject);
begin
    if Compiler.Exclusions.IndexOf(cbxCompilers.Text)=-1 then
       Compiler.Exclusions.Add(cbxCompilers.Text)
    else
       messageDlg('',mtInformation,[mbok],0);
end;

procedure TSettings.FormDestroy(Sender: TObject);
var
   i:integer;
begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini')) do begin
        EraseSection('Compilers');
        EraseSection('Masks');
        for i :=0 to cbxCompilers.Items.Count-1 do
            WriteString('Compilers',cbxCompilers.Items[i],cbxCompilers.Items[i]);
        for i :=0 to cbxDBMaskFile.Items.Count-1 do
            WriteString('DBMasks',cbxDBMaskFile.Items[i],cbxDBMaskFile.Items[i]);
        WriteString('DBMask',cbxDBMaskFile.Text,cbxDBMaskFile.Text);
        Free;
    end;
end;

procedure TSettings.cbxDBMaskFileKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   s:string;
begin
    if key=vk_insert then begin
       s:=cbxDBMaskFile.Text;
       if s<>'' then begin
          if s[1]<>'*' then begin
             messageDlg('',mtInformation,[mbok],0);
             cbxDBMaskFile.Text:='*.<your mask>';
             cbxDBMaskFile.SelStart:=2;
             cbxDBMaskFile.SelLength:=11;
             exit;
          end;
       end
    end
end;

procedure TSettings.cbxCompilersChange(Sender: TObject);
var
   s:string;
begin
    s:= cbxCompilers.Text;//Items[cbxCompilers.ItemIndex];
    if s='' then exit;
    cbxCompilers.Tag:=integer(cbxCompilers.Text=cbxCompilers.Items[cbxCompilers.ItemIndex]);
    if FileExists(s) then
       if cbxCompilers.Items.IndexOf(s)=-1 then begin
          cbxCompilers.Items.Add(s);
       end;
end;

procedure TSettings.PanelColorClick(Sender: TObject);
begin
    with TColorDialog.Create(nil) do begin
         Color:=PanelColor.Color;
         if execute then
            PanelColor.Color:=Color;
         free   
    end;
end;

procedure TSettings.ImageClick(Sender: TObject);
begin
   Clipboard.Open;
   ClipBoard.SetTextBuf(PChar(Image.Hint));
   Clipboard.Close;
end;

procedure TSettings.LoadDirectories;
begin
end;

procedure TSettings.UpdateDirectories;
begin
end;

function TSettings.BuildIncludePaths:string;
var
  i:integer;

begin
    result:='';
    for i:=0 to ListBoxDirs.Items.Count-1 do
        result:=result+format(' -i "%s"',[ListBoxDirs.Items[i]]);
end;

procedure TSettings.FormCreate(Sender: TObject);
begin
    if FileExists(Launcher.Lib.MainFile) then
       edLibrary.Text:=Launcher.Lib.MainFile;
end;

procedure TSettings.btnAddPathClick(Sender: TObject);
var
   Dir :string;
begin
    if BrowseForFolder(Dir,'Add new searching path:') then
       if ListBoxDirs.Items.IndexOf(Dir)=-1 then
          ListBoxDirs.Items.Add(Dir)
       else
          messageDlg('Exists.',mtInformation,[mbok],0) ;
end;

procedure TSettings.btnLibraryClick(Sender: TObject);
begin
   case messageDlg('The actual library file will be change it.'#10'All of your work can be changed also.'#10'Do you still want to procced?',mtConfirmation,[mbyes,mbno],0) of
   mryes :with TOpenDialog.Create(nil) do begin
               Filter:='FreeBasic files (*.bas,*.bi,*.fpk)|*.bas;*.bi;*.fpk}|All files (*.*)|*.*';
               if Execute then begin
                  Launcher.Lib.MainFile:=FileName;
               end

          end;
   mrno  :exit;
   end
end;

procedure TSettings.btnRemovePathClick(Sender: TObject);
begin
    if ListBoxDirs.ItemIndex>-1 then begin
       ListBoxDirs.Items.Delete(ListBoxDirs.ItemIndex);
    end
end;

procedure TSettings.ListBoxDirsClick(Sender: TObject);
begin
    btnRemovePath.Enabled:=ListBoxDirs.ItemIndex>-1;
end;

procedure TSettings.menuAddPathClick(Sender: TObject);
begin
    btnAddPath.Click
end;

procedure TSettings.menuRemovePathClick(Sender: TObject);
begin
    btnRemovePath.Click
end;

procedure TSettings.ListBoxDirsDblClick(Sender: TObject);
begin
    if ListBoxDirs.ItemIndex>-1 then begin
       ShellExecute(0,'open',PChar(ListBoxDirs.Items[ListBoxDirs.ItemIndex]),'','',sw_show);
    end
end;

procedure TSettings.menuCopyDirClick(Sender: TObject);
begin
   if ListBoxDirs.ItemIndex>-1 then begin
      ClipBoard.Open;
      ClipBoard.AsText:=ListBoxDirs.Items[ListBoxDirs.ItemIndex];
      ClipBoard.Close
   end;
end;

procedure TSettings.btnAddDLLClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='Module files (*.dll,*.ocx,*.fbm)|*.dll;*.ocx;*.fbm';
         if Execute then
            if DLLModules.IndexOf(FileName)=-1 then begin
               ActiveModule:=TDllModule.Create;
               ActiveModule.Handle:=LoadLibrary(PChar(FileName));
               ActiveModule.FileName:=FileName;
               DLLModules.AddObject(ChangeFileExt(ExtractFileName(FileName),''),ActiveModule);
               if ActiveModule.Handle=0 then messageDlg('Loading of module failed.',mtError,[mbok],0);
            end;
         Free
    end;
    ListBoxDlls.Items.Assign(DLLModules);
end;

procedure TSettings.btnRemoveDLLsClick(Sender: TObject);
var
   i:integer;
begin
    i:=ListBoxDLLs.ItemIndex;
    if i>-1 then begin
       ListBoxDLLs.Items.Delete(i);
       DLLModules.Delete(i);
    end
end;

procedure TSettings.menuCopyDLLsClick(Sender: TObject);
begin
   if ListBoxDlls.ItemIndex>-1 then begin
      ClipBoard.Open;
      ClipBoard.AsText:=ListBoxDlls.Items[ListBoxDlls.ItemIndex];
      ClipBoard.Close
   end;
end;

procedure TSettings.ListBoxDLLsClick(Sender: TObject);
var
   MDll:TDllModule;
   i:integer;
begin
    btnRemoveDlls.Enabled:=ListBoxDlls.ItemIndex>-1;
    i:=ListBoxDlls.ItemIndex;
    if i>-1 then begin
       MDll:=TDllModule(ListBoxDLLs.Items.Objects[i]);
       if MDll<>nil then begin
          GetClasses:=GetProcAddress(MDll.Handle,'GetClasses');
          if @GetClasses=nil then
             GetClasses:=GetProcAddress(MDll.Handle,'GETCLASSES@0');
          if @GetClasses<>nil then begin
             ListBoxClasses.Items.Text:=GetClasses();;
             ListBoxClasses.Items.Text:=StringReplace(ListBoxClasses.Items.Text,',',#10,[rfreplaceall]);
          end   
       end
    end
end;

procedure TSettings.ListBoxDLLsDblClick(Sender: TObject);
var
   MDll:TDllModule;
begin
    if ListBoxDlls.ItemIndex>-1 then begin
       MDll:=TDllModule(ListBoxDlls.Items.Objects[ListBoxDlls.ItemIndex]);
       if Launcher.isPage(ListBoxDlls.Items[ListBoxDlls.ItemIndex])=nil then
          Launcher.NewEditor(MDll.FileName)

    end
end;

end.
