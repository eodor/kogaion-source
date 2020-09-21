unit MainUnit;

{$SetPEFlags $0100}

interface

uses
  ShellApi, Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ResourceExport, Menus, ImgList, XPMan, ComCtrls, ToolWin,
  ExtCtrls, LauncherUnit, DialogUnit, TypesUnit, PageSheetUnit, DebuggerUnit,
  CompilerUnit, HelperUnit, CompletionDataBase, ScripterUnit,
  PropEditorsUnit;

type
  TMain = class(TForm)
    PanelMain: TPanel;
    PanelTools: TPanel;
    ToolBarFiles: TToolBar;
    s0: TToolButton;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    s1: TToolButton;
    tbSaveAs: TToolButton;
    s10: TToolButton;
    tbSaveAll: TToolButton;
    s2: TToolButton;
    tbSettings: TToolButton;
    s3: TToolButton;
    tbHelp: TToolButton;
    s8: TToolButton;
    ToolBarActions: TToolBar;
    s4: TToolButton;
    tbDialog: TToolButton;
    tbEditor: TToolButton;
    s5: TToolButton;
    tbResources: TToolButton;
    s6: TToolButton;
    tbUnits: TToolButton;
    s11: TToolButton;
    tbDialogs: TToolButton;
    s7: TToolButton;
    tbCompileRun: TToolButton;
    tbResetProgram: TToolButton;
    s9: TToolButton;
    PanelPalette: TPageControl;
    XPManifest: TXPManifest;
    ImageList: TImageList;
    PopupMenuCompile: TPopupMenu;
    menuExecutable: TMenuItem;
    menuGUI: TMenuItem;
    menuConsole: TMenuItem;
    menuDLL: TMenuItem;
    menuLibrary: TMenuItem;
    menuObject: TMenuItem;
    N7: TMenuItem;
    menuCompilerSettings: TMenuItem;
    PopupMenuPaletteClasses: TPopupMenu;
    pmenuNewClass: TMenuItem;
    pmenuCustomizeClasses: TMenuItem;
    N21: TMenuItem;
    pmenuExportClass: TMenuItem;
    N32: TMenuItem;
    pmenuSetModule: TMenuItem;
    MainMenu: TMainMenu;
    menuFile: TMenuItem;
    menuNew: TMenuItem;
    menuApplication: TMenuItem;
    N31: TMenuItem;
    menuDialog: TMenuItem;
    menuFrame: TMenuItem;
    menuCode: TMenuItem;
    N15: TMenuItem;
    menuOthers: TMenuItem;
    menuOpen: TMenuItem;
    N16: TMenuItem;
    menuSave: TMenuItem;
    menuSaveAs: TMenuItem;
    menuSaveAll: TMenuItem;
    N17: TMenuItem;
    menuExport: TMenuItem;
    menuHTML: TMenuItem;
    menuRTF: TMenuItem;
    menuPrint: TMenuItem;
    N18: TMenuItem;
    menuClose: TMenuItem;
    menuCloseAll: TMenuItem;
    N41: TMenuItem;
    menuCloseSelection: TMenuItem;
    N19: TMenuItem;
    menuExit: TMenuItem;
    menuEdit: TMenuItem;
    menuUndo: TMenuItem;
    menuRedo: TMenuItem;
    N11: TMenuItem;
    menuPaste: TMenuItem;
    menuCut: TMenuItem;
    menuCopy: TMenuItem;
    menuDelete: TMenuItem;
    N12: TMenuItem;
    menuSelectAll: TMenuItem;
    N13: TMenuItem;
    menuBlock: TMenuItem;
    menuComment: TMenuItem;
    menuUncomment: TMenuItem;
    N14: TMenuItem;
    menuProperties: TMenuItem;
    menuView: TMenuItem;
    menuLibraryBrowser: TMenuItem;
    N9: TMenuItem;
    menuObjectTree: TMenuItem;
    menuResultWindow: TMenuItem;
    menuInspectorWindow: TMenuItem;
    menuCodeExplorer: TMenuItem;
    menuCodeEditor: TMenuItem;
    N10: TMenuItem;
    menuSettings: TMenuItem;
    N20: TMenuItem;
    menuTools: TMenuItem;
    menuUseTools: TMenuItem;
    N37: TMenuItem;
    N23: TMenuItem;
    pmenuWindows: TMenuItem;
    pmenuCascade: TMenuItem;
    pmenuTile: TMenuItem;
    pmenuVertical: TMenuItem;
    pmenuHorizontal: TMenuItem;
    pmenuArrangeIcons: TMenuItem;
    N29: TMenuItem;
    menuActiveXClass: TMenuItem;
    menuSearch: TMenuItem;
    menuFind: TMenuItem;
    menuFindAgain: TMenuItem;
    menuFindinFiles: TMenuItem;
    N24: TMenuItem;
    menuReplace: TMenuItem;
    N25: TMenuItem;
    menuGotoLine: TMenuItem;
    N26: TMenuItem;
    menuFindFile: TMenuItem;
    menuProject: TMenuItem;
    menuProjects: TMenuItem;
    N22: TMenuItem;
    menuAddtoProject: TMenuItem;
    menuRemovefromProject: TMenuItem;
    N36: TMenuItem;
    menuSaveProject: TMenuItem;
    menuSaveAsProject: TMenuItem;
    N6: TMenuItem;
    menuViewSource: TMenuItem;
    MenuItem1: TMenuItem;
    menuCompileAllProjects: TMenuItem;
    N8: TMenuItem;
    menuGroup: TMenuItem;
    menuAction: TMenuItem;
    menuCompile: TMenuItem;
    menuRun: TMenuItem;
    menuCompileandRun: TMenuItem;
    N5: TMenuItem;
    menuResetProgram: TMenuItem;
    menuClass: TMenuItem;
    menuNewClass: TMenuItem;
    menuCustomizeClasses: TMenuItem;
    N4: TMenuItem;
    menuInstallClass: TMenuItem;
    menuInstallClassPackage: TMenuItem;
    N39: TMenuItem;
    menuExportClass: TMenuItem;
    menuAbout: TMenuItem;
    menuHelp: TMenuItem;
    menuOnlineHelp: TMenuItem;
    N1: TMenuItem;
    menuRqWork: TMenuItem;
    N2: TMenuItem;
    menuHomePage: TMenuItem;
    N3: TMenuItem;
    menuLanguage: TMenuItem;
    N38: TMenuItem;
    menuIDEMode: TMenuItem;
    menuVB: TMenuItem;
    menuDelphi: TMenuItem;
    menuClassic: TMenuItem;
    menuWindows: TMenuItem;
    menuCascade: TMenuItem;
    menuTile: TMenuItem;
    menuVertical: TMenuItem;
    menuHorizontal: TMenuItem;
    menuArrangeIcons: TMenuItem;
    N28: TMenuItem;
    menuState: TMenuItem;
    menuMinimizeallDialogwindows: TMenuItem;
    N27: TMenuItem;
    menuRestoreallDialogWindows: TMenuItem;
    N30: TMenuItem;
    PopupMenuDesigner: TPopupMenu;
    menuEditDsgnr: TMenuItem;
    pdmenuUndo: TMenuItem;
    N33: TMenuItem;
    pdmenuPaste: TMenuItem;
    pdmenuCut: TMenuItem;
    pdmenuCopy: TMenuItem;
    pdmenuDelete: TMenuItem;
    N34: TMenuItem;
    pdmenuSelectAll: TMenuItem;
    menuAlign: TMenuItem;
    menuToGrid: TMenuItem;
    pdmenuPosition: TMenuItem;
    menuTaborder: TMenuItem;
    menuCreationorder: TMenuItem;
    menuAcceptChilds: TMenuItem;
    N40: TMenuItem;
    menuMenuEditor: TMenuItem;
    N35: TMenuItem;
    pdmenuViewasResourceScript: TMenuItem;
    PopupMenuHelps: TPopupMenu;
    N42: TMenuItem;
    menuFileType: TMenuItem;
    N43: TMenuItem;
    menuOptions: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure tbDialogClick(Sender: TObject);
    procedure tbUnitsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbEditorClick(Sender: TObject);
    procedure menuLibraryBrowserClick(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menuProjectsClick(Sender: TObject);
    procedure tbCompileRunClick(Sender: TObject);
    procedure tbResetProgramClick(Sender: TObject);
    procedure menuCompilerSettingsClick(Sender: TObject);
    procedure menuSaveAsProjectClick(Sender: TObject);
    procedure menuSaveProjectClick(Sender: TObject);
    procedure menuAddtoProjectClick(Sender: TObject);
    procedure menuRemovefromProjectClick(Sender: TObject);
    procedure menuViewSourceClick(Sender: TObject);
    procedure menuCompileAllProjectsClick(Sender: TObject);
    procedure menuGroupClick(Sender: TObject);
    procedure tbNewClick(Sender: TObject);
    procedure menuApplicationClick(Sender: TObject);
    procedure menuDialogClick(Sender: TObject);
    procedure menuCodeClick(Sender: TObject);
    procedure menuFrameClick(Sender: TObject);
    procedure menuInstallClassClick(Sender: TObject);
    procedure menuInstallClassPackageClick(Sender: TObject);
    procedure pdmenuUndoClick(Sender: TObject);
    procedure pdmenuPasteClick(Sender: TObject);
    procedure pdmenuCutClick(Sender: TObject);
    procedure pdmenuCopyClick(Sender: TObject);
    procedure pdmenuDeleteClick(Sender: TObject);
    procedure menuToGridClick(Sender: TObject);
    procedure pdmenuPositionClick(Sender: TObject);
    procedure menuTaborderClick(Sender: TObject);
    procedure menuCreationorderClick(Sender: TObject);
    procedure pdmenuSelectAllClick(Sender: TObject);
    procedure menuEditDsgnrClick(Sender: TObject);
    procedure pmenuNewClassClick(Sender: TObject);
    procedure pmenuCustomizeClassesClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure menuSaveAsClick(Sender: TObject);
    procedure menuSaveAllClick(Sender: TObject);
    procedure menuHTMLClick(Sender: TObject);
    procedure menuPrintClick(Sender: TObject);
    procedure menuCloseClick(Sender: TObject);
    procedure menuCloseAllClick(Sender: TObject);
    procedure menuExitClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure tbSaveAsClick(Sender: TObject);
    procedure tbSaveAllClick(Sender: TObject);
    procedure tbSettingsClick(Sender: TObject);
    procedure menuSettingsClick(Sender: TObject);
    procedure menuEditClick(Sender: TObject);
    procedure menuViewClick(Sender: TObject);
    procedure menuObjectTreeClick(Sender: TObject);
    procedure menuResultWindowClick(Sender: TObject);
    procedure menuInspectorWindowClick(Sender: TObject);
    procedure menuCodeExplorerClick(Sender: TObject);
    procedure menuUseToolsClick(Sender: TObject);
    procedure menuSearchClick(Sender: TObject);
    procedure menuFindClick(Sender: TObject);
    procedure menuFindAgainClick(Sender: TObject);
    procedure menuFindinFilesClick(Sender: TObject);
    procedure menuReplaceClick(Sender: TObject);
    procedure menuGotoLineClick(Sender: TObject);
    procedure menuFindFileClick(Sender: TObject);
    procedure menuActionClick(Sender: TObject);
    procedure menuRunClick(Sender: TObject);
    procedure menuCompileandRunClick(Sender: TObject);
    procedure menuResetProgramClick(Sender: TObject);
    procedure menuClassClick(Sender: TObject);
    procedure menuCompileClick(Sender: TObject);
    procedure menuNewClassClick(Sender: TObject);
    procedure menuCustomizeClassesClick(Sender: TObject);
    procedure menuHelpClick(Sender: TObject);
    procedure menuRqWorkClick(Sender: TObject);
    procedure menuHomePageClick(Sender: TObject);
    procedure menuLanguageClick(Sender: TObject);
    procedure menuWindowsClick(Sender: TObject);
    procedure menuMinimizeallDialogwindowsClick(Sender: TObject);
    procedure menuRestoreallDialogWindowsClick(Sender: TObject);
    procedure tbHelpClick(Sender: TObject);
    procedure tbDialogsClick(Sender: TObject);
    procedure menuProjectClick(Sender: TObject);
    procedure menuActiveXClassClick(Sender: TObject);
    procedure menuFileClick(Sender: TObject);
    procedure tbResourcesClick(Sender: TObject);
    procedure menuMenuEditorClick(Sender: TObject);
    procedure PopupMenuDesignerPopup(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure ResourceExportWriteFileError(Sender: TObject);
    procedure menuOthersClick(Sender: TObject);
    procedure ResourceExportLoadResourceError(Sender: TObject);
    procedure ResourceExportResourceNotFound(Sender: TObject);
    procedure ResourceExportSuccess(Sender: TObject;
      BytesWritten: Integer);
    procedure menuCloseSelectionClick(Sender: TObject);
    procedure menuAcceptChildsClick(Sender: TObject);
    procedure menuOnlineHelpClick(Sender: TObject);
    procedure menuOpenClick(Sender: TObject);
    procedure menuCodeEditorClick(Sender: TObject);
    procedure menuClassicClick(Sender: TObject);
    procedure menuFileTypeClick(Sender: TObject);
    procedure menuOptionsClick(Sender: TObject);
  private
    { Private declarations }
    fversion,fuser,fosversion,fcomputer:string;
    procedure HelpClick(Sender :TObject);
    procedure CompilerCompile(Sender:TObject);
    procedure CompilerError(Sender:TObject);
    procedure CompilerRun(Sender:TObject);
    procedure CompilerTerminate(Sender:TObject);
    procedure CompilerCompiling(Sender:TObject);
    procedure CompilerAssembling(Sender:TObject);
    procedure CompilerLinking(Sender:TObject);
    procedure PaletteClick(Sender:TObject);
  public
    { Public declarations }
    procedure ReadHelps;
    procedure DialogsListChange(Sender:TObject);
    procedure PagesListChange(Sender:TObject);
    procedure ScanLine(Sende:TObject;i:integer;v:string);
    procedure ScanCstr(Sender:TObject;c,f:TField;v:string) ;
    procedure Scan(Sende:TObject;v:string);
    procedure SearchCompiler;
    procedure ReadPage(v:TPageSheet);
    procedure BuildBridge;
    procedure LoadBridge;
    procedure LinkBridge;
    function CheckFiles:integer;
    procedure CheckProjects;
    procedure CheckRunning;
    procedure NewApplication;
    procedure Open;
    procedure Save;
    procedure SaveAs;
    procedure SaveAll;
    procedure ClosePage;
    procedure CloseAllPages;
    procedure ExitProgram;
    procedure Compile;
    procedure Run;
    procedure LoadExtensions;
    procedure UnloadExtensions;
    procedure UpdateToolBars;
    procedure CopyObjects;
    procedure CutObjects;
    procedure PasteObjects;
    procedure UndoObjects;
    procedure DeleteObjects;
    procedure SelectAllObjects;
    procedure FreePacks;
    procedure MinimizeOnRun;
    procedure RestoreAfterRun;
    procedure DisableOnRun;
    procedure EnableOnRun;
    procedure CopyLibRTTi;
    procedure ReadScripts;
    procedure AnimateNewDialog;
  published
    property User :string read fuser;
    property Computer:string read fcomputer;
    property OsVersion:string read fosversion;
    property Version:string read fversion;
  end;

  function newEditor(v:string=''):TPageSheet;
  function newDialog(v:string=''):TDialog;
  function newProject(v:string=''):TProject;

  function PnewEditor(v:PChar=nil):TPageSheet;stdcall;
  function PnewDialog(v:PChar=nil):TDialog;stdcall;
  function PnewProject(v:PChar=nil):TProject;stdcall;

  procedure DiscardBridge;stdcall;
  function LoadBridge:PChar;stdcall;

  procedure ExtractGUI;stdcall;
  procedure BuildMode(v:TIDEMode=mdDelphi);

  type
   TDataRecord=record
   Menu:TMenuItem;
   PageControl:TPageControl;
   NewEditor:function(v:PChar=nil):TObject;stdcall;
   NewDialog:function(v:PChar=nil):TObject;stdcall;
  end;
  

var
  Main: TMain;
  Mode:TIdeMode;
  ResourceExport: TResourceExport;
  ideDir, workDir:string;
  Launcher:TLauncher;
  ActiveLang:TLanguage;
  ActiveDialog:TDialog;
  ActiveEditor:TPageSheet;
  ActiveObject:TObject;
  ActiveProject:TProject;
  Resources:TResources;
  NeedRebuildBridge, ExitApplication:boolean;
  BridgeFile:string;
  Debugger:TDebugger;
  Compiler:TCompiler;
  Bridge,user,Module:hmodule;
  Extensions:array of hmodule;
  ExtensionsList:TStrings;
  ShowAbout:procedure ; stdcall;
  SendData:function(var DR :TDataRecord):boolean; stdcall;
  AboutGUI:function:PChar;stdcall;
  LoadPack:function:integer;stdcall;
  iUser:function(v:TWinControl):boolean;stdcall;
  UnloadPack:function:integer;stdcall;

const
    IMAGE_DLLCHARACTERISTICS_NX_COMPAT = $0100;
    IMAGE_FILE_32BIT_MACHINE = $0100;

implementation

uses CodeUnit, ObjectsTreeUnit, InspectorUnit, DialogsListUnit,
     LibraryBrowserUnit, ScannerUnit, ProjectsUnit, CompilerSettingsUnit,
     InstallClassUnit, TabOrderUnit, CreationOrderUnit, AlignmentInWindowUnit,
     ContainerUnit, newClassUnit, CustomizeClassesUnit, ExportUnit, PrintUnit,
     SettingsUnit, ToolsUnit, FindDialogUnit, SearchInFilesUnit,
     ReplaceDialogunit, SearchFileUnit, GoToLineUnit, SplashUnit,
     LanguagesUnit, ProjectPropertiesUnit, ActiveXUnit, ResourceDialogUnit,
     MenuEditorUnit, newItemUnit, CloseSelectionUnit, test_eleframe,
  AssociationsUnit;

{$R *.dfm}
{$R 'gui_files.res'}
{$R 'icons.res'}

procedure BuildMode(v:TIDEMode=mdDelphi);
var
   P:TPanel;
   Ls,Ts:TSplitter;
begin
    case v of
       mdVB:begin
          main.Constraints.MaxHeight:=0;
          P:=TPanel.Create(nil);
          with P do begin
               Align:=alLeft;
               
               ObjectsTree.Parent:=P;
               Inspector.Parent:=P;
               ObjectsTree.BorderStyle:=Forms.bsNone;
               ObjectsTree.Align:=alTop;
               Ts:=TSplitter.Create(P);
               with Ts do begin
                    Align:=alTop;
                    Top:=Inspector.Height;
                    Parent:=P;
               end;
               Inspector.BorderStyle:=Forms.bsNone;
               Inspector.Align:=alClient;
               Parent:=main;
               Ls:=TSplitter.Create(P);
               with Ls do begin
                    Align:=alLeft;
                    Left:=P.Width;
                    Parent:=Main;
               end;
               Code.Parent:=Main;
               Code.Align:=alClient;
               Code.BorderStyle:=Forms.bsNone;
               main.Height:=screen.WorkAreaHeight-12;
          end
       end;
       mdDelphi:begin
          main.Constraints.MaxHeight:=130;
          ObjectsTree.Parent:=nil;
          ObjectsTree.Align:=alNone;
          ObjectsTree.BorderStyle:=bsSizeToolWin;
          Inspector.Parent:=nil;
          Inspector.Align:=alNone;
          Inspector.BorderStyle:=bsSizeToolWin;
          Code.Parent:=nil;
          Code.Align:=alNone;
          Code.BorderStyle:=Forms.bsSizeable;
          main.Top:=0;
          main.Left:=0;
          main.Width:=screen.DesktopWidth;
          ObjectsTree.Top:=main.Height+2;
          ObjectsTree.Height:=150;
          ObjectsTree.Width:=200;
          Inspector.Width:=200;
          Inspector.Top:=ObjectsTree.Top+ObjectsTree.Height+2;
          Inspector.Height:=screen.WorkAreaHeight-main.Height-objectsTree.Height-4;
          Code.Left:=inspector.Width;
          Code.Width:=screen.WorkAreaWidth-Inspector.Width-2;
          Code.Top:=main.Height+2;
          Code.Height:=screen.WorkAreaHeight-main.Height-2;
          if Ls<>nil then Ls.Free;
          if Ts<>nil then Ts.Free;
          if P<>nil then P.Free;
       end;
       mdClassic:begin
       end
    end
end;

procedure TMain.menuClassicClick(Sender: TObject);
begin
    if TMenuItem(Sender)=menuVB then BuildMode(mdVB);
    if TMenuItem(Sender)=menuDelphi then BuildMode(mdDelphi);
end;

procedure DiscardBridge;
begin
    if Bridge>0 then
       FreeLibrary(Bridge);
    Bridge:=0
end;

function LoadBridge:PChar;
var
   dllFile:string;
begin
    result:=nil;
    dllFile:=ChangeFileExt(BridgeFile,'.dll');
    if FileExists(dllFile) then begin
       Bridge:=LoadLibrary(PChar(dllFile));
       if Bridge>0 then begin
          AboutGUI:=GetProcAddress(Bridge,'VERSION@0');
          if  @AboutGUI<>nil then result:=AboutGUI();
       end
    end
end;

procedure TMain.LoadExtensions;
var
   i:integer;
   DR:TDataRecord;
begin
    FindFiles(ExtensionsList,ideDir+'extensions\','*.dll');
    SetLength(Extensions,length(Extensions)+1);
    for i:=0 to ExtensionsList.Count-1 do begin
        Extensions[i]:=LoadLibrary(PChar(ExtensionsList[i]));
        ShowAbout:=GetProcAddress(Extensions[i],'ShowAbout');
        if Assigned(@ShowAbout) then showabout();
        SendData:=GetProcAddress(Extensions[i],'SendData');
        DR.PageControl:=Code.PageControl;
        DR.Menu:=menuAbout;
        DR.NewEditor:=@pnewEditor;
        DR.NewDialog:=@pnewDialog;
        if Assigned(@SendData) then SendData(DR);
    end

end;

procedure TMain.AnimateNewDialog;
type
    PCtrlRect=^TCtrlRect;
    TCtrlRect=record
    Control:TControl;
    R:TRect;
   
    end;
var
   i:integer;
   L:TStringList;
   CR:PCtrlRect;
   eu: array [0..1] of TInput;

   function GetControlCoor(v:string):TRect;
   var
      i:integer;
   begin
      i:=L.IndexOf(v) ; 
      if i>-1 then begin
         CR:=PCtrlRect(L.Objects[i]);
         result:=CR^.R;
      end
   end;
begin
   L:=TStringList.Create;
   for i:=0 to ControlCount-1 do begin
          New(CR);
          CR^.Control:=Controls[i];
          if GetWindowRect(TWinControl(Controls[i]).Handle,CR^.R) then
             L.AddObject(CR^.Control.Name,TObject(CR));
   end;
   SetCursorPos(GetControlCoor('PanelTools').Left+4,GetControlCoor('PanelTools').Right+4);
   L.Free;
   SetCursorPos(20, Screen.Height-20); //set cursor to Start menu coordinates
   ZeroMemory(@eu,sizeof(eu));
   eu[0].Itype := INPUT_MOUSE;
   eu[0].mi.dwFlags :=MOUSEEVENTF_LEFTDOWN;
   //eu[1].Itype := INPUT_MOUSE;
   //eu[1].mi.dwFlags :=MOUSEEVENTF_LEFTUP;
   eu[1].Itype := INPUT_KEYBOARD;
   eu[1].ki.dwFlags:=KEYEVENTF_EXTENDEDKEY;
   eu[1].ki.wVK:=vk_lWIN;
   SendInput(2,eu[0],sizeof(TInput));
end;

procedure TMain.ReadScripts;
var
   L:TStrings;
   i:integer;
begin
    if Launcher.ReadScripts then begin
       L:=TStringList.Create;
       FindFiles(L,ideDir+'scripts','*.ksm');
       for i:=0 to L.Count-1 do begin
           try
             Scripter.FileName:=L[i];
             ActiveResult.Edit.Lines.Text:=Scripter.Execute;
           except end
       end;
       L.Free;
    end
end;

procedure TMain.FreePacks;
begin
    if Bridge>0 then begin
       FreeLibrary(Bridge);
       Bridge:=0;
    end   
end;

procedure TMain.UnloadExtensions;
var
   i:integer;
begin
   for i:=low(extensions) to high(extensions) do
       if extensions[i]>0 then FreeLibrary(extensions[i]);
end;

type
   PHelpStruct = ^THelpStruct;
   THelpStruct=record
      Name,FileName :string;
   end;
procedure TMain.HelpClick(Sender :TObject);

var
   s :PHelpStruct;
   pid :cardinal;
begin
    s := PHelpStruct(TMenuItem(Sender).tag);
    if FileExists(s^.FileName) then begin
       Launcher.HelpFile:=s^.FileName;
       pid:= ShellExecute(0,'open',PChar(s^.FileName),'','',sw_show); { *Converted from ShellExecute* }
       if pid<=32 then messageDlg(format(StringReplace('','\n',#10,[rfReplaceAll]),[s^.FileName]),mtInformation,[mbok],0);
    end else messageDlg(format('The %s file not found.',[s^.FileName]),mtInformation,[mbok],0);;
end;

procedure TMain.ReadHelps;

var
   i :integer;
   L :TStrings;
   it :TMenuItem;
   t :PHelpStruct;
begin
   L :=TStringList.Create;
   FindFiles(L,ideDir+'Helps','.chm');
   for i :=0 to L.Count-1 do begin
       it := TMenuItem.Create(PopupMenuHelps);
       system.New(t) ;
       t^.FileName:=L[i];
       it.Tag:=integer(t);
       it.Caption:= ChangeFileExt(ExtractFileName(L[i]),'');
       it.OnClick := HelpClick;
       it.AutoCheck:=true;
       it.RadioItem:=true;
       PopupMenuHelps.items.add(it);
       Application.ProcessMessages;
   end;
   L.Clear;
   FindFiles(L,ideDir+'Helps','*.hlp');
   if L.Count>0 then begin
      it := TMenuItem.Create(PopupMenuHelps);
      it.Caption:= '-';
      PopupMenuHelps.items.add(it);
   end;
   for i :=0 to L.Count-1 do begin
       it := TMenuItem.Create(PopupMenuHelps);
       system.New(t) ;
       t^.FileName:=L[i];
       it.Tag:=integer(t);
       it.Caption:= ChangeFileExt(ExtractFileName(L[i]),'');
       it.OnClick := HelpClick;
       PopupMenuHelps.items.add(it);
       Application.ProcessMessages;
   end;
   L.Clear;
   FindFiles(L,ideDir+'Helps','*.pdf');
   if L.Count>0 then begin
      it := TMenuItem.Create(PopupMenuHelps);
      it.Caption:= '-';
      PopupMenuHelps.items.add(it);
   end;
   for i :=0 to L.Count-1 do begin
       it := TMenuItem.Create(PopupMenuHelps);
       system.New(t) ;
       t^.FileName:=L[i];
       it.Tag:=integer(t);
       it.Caption:= ChangeFileExt(ExtractFileName(L[i]),'');
       it.OnClick := HelpClick;
       PopupMenuHelps.items.add(it);
       Application.ProcessMessages;
   end;
   L.Free;
end;

function newEditor(v:string=''):TPageSheet;
begin
   result:=Launcher.NewEditor(v)
end;

function newDialog(v:string=''):TDialog;
begin
   result:=Launcher.NewDialog(v)
end;

function newProject(v:string=''):TProject;
begin
    result:=Launcher.NewProject(v);
end;

function PnewProject(v:PChar=nil):TProject;
begin
    result:=Launcher.NewProject(StrPas(v));
end;{}

function PnewEditor(v:PChar=nil):TPageSheet;
begin
   result:=Launcher.NewEditor(StrPas(v))
end;

function PnewDialog(v:PChar=nil):TDialog;
begin
   result:=Launcher.NewDialog(StrPas(v))
end;

procedure TMain.DialogsListChange(Sender:TObject);
begin
   DialogList.ListBox.Items.Assign(DialogsList);
end;

procedure TMain.PagesListChange(Sender:TObject);
begin
end;

procedure TMain.SearchCompiler;
var
   c:string;
begin
    if DirectoryExists(GetSpecialFolderPath(CSIDL_PROGRAM_FILESX86)) then
       c:=GetSpecialFolderPath(CSIDL_PROGRAM_FILESX86);
    if c='' then
       if DirectoryExists(GetSpecialFolderPath(CSIDL_PROGRAM_FILES)) then
          c:=GetSpecialFolderPath(CSIDL_PROGRAM_FILES);
    c:=c+'\freebasic\fbc.exe';
    if FileExists(c) then
       Compiler.FileName:=c
    else
       if messageDlg('The compiler are not set.'#10'Do you want to set it now?',mtConfirmation,[mbyes,mbno],0)=mryes then
          with TOpenDialog.Create(nil) do begin
               Filter:='Executable file (*.exe)|*.exe';
               FileName:='fbc.exe';
               if Execute then
                  Compiler.FileName:=FileName;
               free;
          end;
end;

procedure TMain.MinimizeOnRun;
begin
   Main.WindowState:=wsMinimized;
   ObjectsTree.WindowState:=wsMinimized;
   Inspector.WindowState:=wsMinimized;
   Code.WindowState:=wsMinimized;
end;

procedure TMain.RestoreAfterRun;
begin
   Main.WindowState:=wsNormal;
   ObjectsTree.WindowState:=wsNormal;
   Inspector.WindowState:=wsNormal;
   Code.WindowState:=wsNormal;
end;

procedure TMain.DisableOnRun;
var
   i:integer;
begin
    for i:=0 to ToolBarActions.ButtonCount-1 do
        if (ToolBarActions.Buttons[i]<>tbCompileRun) and (ToolBarActions.Buttons[i]<>tbResetProgram) then
           ToolBarActions.Buttons[i].Enabled:=false;
    for i:=0 to ToolBarFiles.ButtonCount-1 do
        if (ToolBarFiles.Buttons[i]<>tbSettings) and (ToolBarFiles.Buttons[i]<>tbHelp) then
           ToolBarFiles.Buttons[i].Enabled:=false;
    for i:=0 to Main.Menu.Items.Count-1 do
        Main.Menu.Items[i].Enabled:=false;
    Launcher.PaletteClasses.Enabled:=false;
    Code.Enabled:=false;
    Inspector.Enabled:=false;
    ObjectsTree.Enabled:=false;
end;

procedure TMain.EnableOnRun;
var
   i:integer;
begin
    for i:=0 to ToolBarActions.ButtonCount-1 do
        ToolBarActions.Buttons[i].Enabled:=true;
    for i:=0 to ToolBarFiles.ButtonCount-1 do
        ToolBarFiles.Buttons[i].Enabled:=true;
    Launcher.PaletteClasses.Enabled:=true;
    for i:=0 to Main.Menu.Items.Count-1 do
        Main.Menu.Items[i].Enabled:=true;
    Code.Enabled:=true;
    Inspector.Enabled:=true;
    ObjectsTree.Enabled:=true;
end;

procedure TMain.CompilerCompile(Sender:TObject);
begin
   Caption:=format('Kogaion -Compiling [%s]',[Compiler.Params]);
   tbCompileRun.Enabled:=false;
   tbResetProgram.Enabled:=true;
end;

procedure TMain.CompilerError(Sender:TObject);
begin
    if Compiler.ExitCode=file_not_exists then
       Caption:='Kogaion -File in ERROR [file not exists. save it first]'
    else
       Caption:=format('Kogaion -File in ERROR [%s]',[Compiler.Params]);
    tbCompileRun.Enabled:=false;
    tbResetProgram.Enabled:=false;
    if ActiveResult<>nil then begin
       ActiveResult.Edit.Lines.Assign(Compiler.Outputs);
       Debugger.Text:=Compiler.Outputs.Text;
       Debugger.Scan
    end ;
    RestoreAfterRun;
    EnableOnRun;
end;

procedure TMain.CompilerRun(Sender:TObject);
begin
    Caption:=format('Kogaion -Running [%s]',[Compiler.Outfile]);
    tbCompileRun.Enabled:=false;
    tbResetProgram.Enabled:=true;
    if Launcher.MinimizeOnRun then MinimizeOnRun;
    if Launcher.DisableOnRun then DisableOnRun;
end;

procedure TMain.CompilerTerminate(Sender:TObject);
begin
    Caption:=('Kogaion ***');
    tbCompileRun.Enabled:=true;
    tbResetProgram.Enabled:=false;
    if ActiveResult<>nil then ActiveResult.Edit.Lines.Assign(Compiler.Outputs);
    if Launcher.MinimizeOnRun then RestoreAfterRun;
    if Launcher.DisableOnRun then EnableOnRun;
end;

procedure TMain.CompilerCompiling(Sender:TObject);
begin
    if ActiveResult<>nil then ActiveResult.Edit.Lines.Add('compiling...');
end;

procedure TMain.CompilerAssembling(Sender:TObject);
begin
    if ActiveResult<>nil then ActiveResult.Edit.Lines.Add('assembling...');
end;

procedure TMain.CompilerLinking(Sender:TObject);
begin
    if ActiveResult<>nil then ActiveResult.Edit.Lines.Add('linking...');
end;

procedure TMain.PaletteClick(Sender:TObject);
begin  
   if Launcher.SelType<>nil then
      Code.StatusBar.Panels[2].Text:=Launcher.SelType.Hosted
end;

procedure TMain.ReadPage(v:TPageSheet);
var
   s:TScanner;
   i,j,lx,ly,lcx,lcy,e :integer;
   t, bt:TType;
   f,cstr,fs:TField;
   canCreate:boolean;
   tk,prms,ext:string;
   L:TStrings;
   canRead:boolean;
   function GetNameId(v:string):string;
   var
      i:integer;
      f:TField;
   begin
       result:=v;
       if v='' then exit;  
       for i:=0 to s.Variables.Count-1 do begin
           f:=TField(s.Variables.Objects[i]);
           if f<>nil then
              if comparetext(f.Return,v)=0 then begin
                 result:=f.Hosted;
                 break
              end

       end
   end;
begin
    if (v=nil) and (self=nil) then exit;
    if Launcher.Lib.MainType=nil then begin
       messageDlg('The MainType in library are not set.'#10'No form will be loaded.',mtInformation,[mbok],0);
       exit
    end;

    if v<>nil then begin
       ext:=ExtractFileExt(v.FileName);
       if (compareText(ext,'.bas')<>0) and (compareText(ext,'.bi')<>0) then exit;
       s:=TPageSheet(v).Scanner
    end else
       s:=nil;
    if (self<>nil) and (s<>nil) then begin
       if v<>nil then s.FileName:=v.FileName;
       if s.Count>0 then
          if FileExists(ideDir+'gui\core.bi') then
             s.Scan;
    end;
    canCreate:=false;
    canRead:=false;
    if s<>nil then
       if s.Variables.Count>0 then
          for i:=0 to s.Variables.Count-1 do begin
              fs:=TField(s.Variables.Objects[i]);
              bt:=ActiveEditor.Scanner.TypExists(fs.Return);
              if bt<>nil then cancreate:=true;;
              break
          end;
    t:=Launcher.Lib.MainType;
    if t<>nil then begin
       Cstr:=t.FieldExists('constructor '+t.Hosted);
       f:=Cstr.FieldExists('fstyle');
       if f=nil then begin
          t:=Launcher.Lib.TypExists(t.extends) ;
          if t<>nil then begin
             Cstr:=t.FieldExists('constructor '+t.Hosted);
             if Cstr<>nil then begin
                f:=Cstr.FieldExists('fstyle');

             end
          end
       end;
       if canCreate then //auto create forms
          for i:=0 to s.Types.Count-1 do begin 
              bt:=s.Typ[i];
              if bt<>nil then begin
                 if comparetext(bt.Extends,t.Hosted)=0 then begin
                    if v.Dialog=nil then  
                       v.HasDialog:=true;

                    v.Dialog.Typ.Extends:=s.Typ[i].Extends;
                    v.Dialog.Typ.Hosted:=s.Typ[i].Hosted;
                    NamesList.RemoveName(v.Dialog.Name);

                    v.Dialog.Caption:=v.Dialog.Name;
                    if v.Dialog.Page<>nil then begin
                       v.Dialog.Page.Caption:=ExtractFileName(v.FileName);
                       for j:=0 to v.Frame.Edit.Lines.Count-1 do begin
                           if pos('this.',lowercase(v.Frame.Edit.Lines[j]))>0 then begin
                              v.Frame.Edit.Lines.Objects[j]:=v.Dialog;
                              if pos('this.name',lowercase(v.Frame.Edit.Lines[j]))>0 then begin
                                 tk:=trim(v.Frame.Edit.Lines[j]);
                                 v.Dialog.Name:=trim(copy(tk,pos('"',tk)+1,lastdelimiter('"',tk)-pos('"',tk)-1));
                              end;
                              if pos('this.text',lowercase(v.Frame.Edit.Lines[j]))>0 then begin
                                 tk:=trim(v.Frame.Edit.Lines[j]);
                                 v.Dialog.Caption:=trim(copy(tk,pos('"',tk)+1,lastdelimiter('"',tk)-pos('"',tk)-1));
                              end;
                              if (pos('this.setbounds(',lowercase(v.Frame.Edit.Lines[j]))>0) or (pos('setbounds(',lowercase(v.Frame.Edit.Lines[j]))>0) then begin
                                 tk:=trim(v.Frame.Edit.Lines[j]);
                                 prms:=copy(tk,pos('(',tk)+1,pos(')',tk)-pos('(',tk)-1);
                                 L:=TStringList.Create;
                                 L.Text:=StringReplace(SkipBlank(prms),',',#10,[rfreplaceall]);
                                 if L.Count>0 then begin
                                    val(L[0],lx,e);
                                    val(L[1],ly,e);
                                    val(L[2],lcx,e);
                                    val(L[3],lcy,e);
                                    if e=0 then begin
                                       v.Dialog.Left:=lx;
                                       v.Dialog.Top:=ly;
                                       v.Dialog.Width:=lcx;
                                       v.Dialog.Height:=lcy;
                                    end
                                  end;
                                  L.Free;
                               end
                            end;
                            if (pos('type ',lowercase(v.Frame.Edit.Lines[j]))>0) and
                               (pos(lowercase(v.Dialog.Typ.Hosted),lowercase(v.Frame.Edit.Lines[j]))>0)then
                               canread:=true;
                            if (pos('end ',lowercase(v.Frame.Edit.Lines[j]))>0) and
                               (pos(' type',lowercase(v.Frame.Edit.Lines[j]))>0)then begin
                               v.Frame.Edit.Lines.Objects[j]:=v.Dialog;
                               canread:=false
                            end;
                            if pos(lowercase(v.Dialog.Name),lowercase(v.Frame.Edit.Lines[j]))>0 then
                               v.Frame.Edit.Lines.Objects[j]:=v.Dialog;
                            if ((pos('function ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('sub ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('constructor ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('destructor ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('operator ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('property ',lowercase(v.Frame.Edit.Lines[j]))>0) ) and
                               (pos(lowercase(v.Dialog.Typ.Hosted),lowercase(v.Frame.Edit.Lines[j]))>0)then
                               canread:=true;
                            if (pos('end ',lowercase(v.Frame.Edit.Lines[j]))>0) and
                               ((pos('function ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('sub ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('constructor ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('destructor ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('operator ',lowercase(v.Frame.Edit.Lines[j]))>0) or
                               (pos('property ',lowercase(v.Frame.Edit.Lines[j]))>0)) then
                               canread:=false;
                            if canRead then
                               v.Frame.Edit.Lines.Objects[j]:=v.Dialog;
                       end;
                    end;
                    break;
                 end
              end
          end
       end;
       if v.Dialog<>nil then v.Dialog.ReadPage;
end;

procedure TMain.Scan(Sende:TObject;v:string);
begin
   Splash.LabelFile.Caption:=format('scanning: %s',[v]);
end;

procedure TMain.ScanLine(Sende:TObject;i:integer;v:string);
begin
    Code.StatusBar.Panels[3].Text:=format('scanning line: %s, pos: %d, ',[v,i]);
end;

procedure TMain.ScanCstr(Sender:TObject;c,f:TField;v:string) ;
begin
     if f<>nil then begin
     end;
end;

function TMain.CheckFiles:integer;
var
   i:integer;
begin
    for i:=PagesList.Count-1 downto 0 do
        try
           result:=TPageSheet(PagesList.Objects[i]).Dispose;
        except
           messageDlg(format('Interal error $d: can''t free memory.[%d]',[integer(PagesList.Objects[i])]),mtError,[mbok],0)
        end;
end;

procedure TMain.LinkBridge;
var
   L,F:TStrings;
   i,j:integer;
   s,rf:string;
   Wcls:TWndClassEx;
begin
    rf:=ideDir+'gui\res\gui.rc' ;
    if FileExists(rf) then
       Compiler.Switch:='-dll '+rf
    else
       Compiler.Switch:='-dll';
    Compiler.Params:=ideDir+'gui\core.bas';
    Compiler.Compile;
    try
       Bridge:=LoadLibrary(PChar(ideDir+'gui\core.dll'));
       if Bridge=0 then MessageDlg('Can''t load bridge.'#10'Fatal error.',mtError,[mbok],0);
    except end;

    wcls.cbSize:=sizeof(wcls);
    for i:=1 to Launcher.Classes.Count-1 do begin
        if GetClassInfoEx(hinstance,PChar(Launcher.Classes[i]),wcls)=false then
           MessageDlg(format('The ''%s'' class are not registered.',[Launcher.Classes[i]]),mtError,[mbok],0)
    end;
    
   for i:=0 to Launcher.PaletteClasses.PageCount-1 do begin
       for j:=1 to Launcher.PaletteClasses.Pages[i].ControlCount-1 do begin
           if FindResource(Bridge,PChar(Launcher.PaletteClasses.Pages[i].Controls[j].Hint),rt_bitmap)>0 then
              TPaletteButton(Launcher.PaletteClasses.Pages[i].Controls[j]).Glyph.LoadFromResourceName(Bridge,Launcher.PaletteClasses.Pages[i].Controls[j].Hint)
           else
           if FindResource(hinstance,PChar('QControl'),rt_bitmap)>0 then
              TPaletteButton(Launcher.PaletteClasses.Pages[i].Controls[j]).Glyph.LoadFromResourceName(hinstance,PChar('QControl'));
       end
   end ;
   if not Compiler.InError then begin
      ActiveResult.Edit.Clear;
      ActiveResult.Edit.Lines.Add('Link bridge was ok...');
      if Bridge>0 then begin
         AboutGUI:=GetProcAddress(Bridge,'VERSION@0');
         if @AboutGUI<>nil then ActiveResult.Edit.Lines.Add(AboutGUI);
      end;
   end ;
   Compiler.Switch:='';
   Compiler.Params:='';
   Compiler.Target:='';
end;

procedure TMain.LoadBridge;
begin
   {}if FileExists(ideDir+'gui\core.dll') then begin
      try
         Bridge:=LoadLibrary(PChar(Compiler.Outfile));
         AboutGUI:=GetProcAddress(Bridge,'VERSION@0');
         if @AboutGUI<>nil then
            if not Compiler.InError then begin
               ActiveResult.Edit.Clear;
               ActiveResult.Edit.Lines.Add(AboutGUI());
            end ;
      except
         messageDlg('Internal error - $reg bad arguments.',mtError,[mbok],0);
      end;
   end;
   CopyLibRTTi;
   ActiveResult.Edit.Lines.Add('Load bridge was ok...');
end;

procedure TMain.CopyLibRTTi;
var
  i:integer;
  B:TPaletteButton;
  T:TType;
begin
   for i:=0 to Launcher.Classes.Count-1 do begin
       B:=Launcher.isButton(Launcher.Classes[i]) ;
       T:=Launcher.TypeExists(Launcher.Classes[i]);
       if (B<>nil) and (T<>nil) then begin  
           B.Typ.Hosted:=T.Hosted;
           B.Hint:=B.Typ.Hosted;
           B.Typ.Extends:=T.Extends;
           B.Typ.ExtendsType:=T.ExtendsType;
           B.Typ.Forwarder:=T.Forwarder;
           B.Typ.ForwarderType:=T.ForwarderType;
           B.Typ.Style:=T.Style;
           B.Typ.StyleEx:=T.StyleEx;
           B.Typ.cx:=T.cx;
           B.Typ.cy:=T.cy;
           B.Typ.Ancestor:=T.Ancestor;
           B.Typ.Special:=t.Special;
           B.Typ.Subs.Assign(T.Subs);
           B.Typ.Funcs.Assign(T.Funcs);
           B.Typ.Enums.Assign(T.Enums);
           B.Typ.Operators.Assign(T.Operators);
           B.Typ.Fields.Assign(T.Fields);
           B.Typ.Where:=T.Where;
           B.Typ.Implemented:=T.Implemented;
           B.Typ.Module:=T.Module;
           if FindResource(Bridge,PChar(Launcher.Classes[i]),rt_bitmap)>0 then
              B.Glyph.LoadFromResourceName(Bridge,Launcher.Classes[i])
           else
               if FindResource(hinstance,PChar('qcontrol'),rt_bitmap)>0 then
                 B.Glyph.LoadFromResourceName(hinstance,'qcontrol')
       end;
   end;{}

   ActiveResult.Edit.Lines.Add('OK - Build bridge...');
end;

procedure TMain.BuildBridge;
var
  L:TStrings;
  rf,ifl:string;
  i:integer;
  B:TPaletteButton;
  None:hbitmap;
begin
   L:=TStringList.Create;
    L.Add('/'' the freebasic to delphi bridge');
    L.Add('this file is part of Kogaion RAD-IDE');
    L.Add('COPYRIGHT (C)2020 VASILE EODOR NASTASA');
    L.Add('LICENCE: FREEWARE');
    L.Add('''/');
    ifl:=format('%sgui\core.bi',[ideDir]);
    if FileExists(ifl) then
       L.Add(format('#include once "%s"',[ifl]))
    else
       messageDlg(format('The ''%s'' file was not found.'#10'Abort.',[ifl]),mtInformation,[mbok],0);
    L.Add('');
    L.Add('function Version stdcall() as zstring ptr export');
    L.Add('    return strptr("Kogaion(RqWork7)-GUI Version 1")');
    L.Add('end function');
    L.Add('');
    if L.Count>0 then
       if DirectoryExists(ideDir+'gui') then
          try
             L.SaveToFile(ideDir+'gui\core.fpk')
          except end
       else begin
          CreateDir(ideDir+'gui');
          L.SaveToFile(ideDir+'gui\core.fpk');
          ExtractGUI;
       end;
   L.Free;
   Code.StatusBar.Panels[0].Text:=('Build bridge was ok...');
end;

procedure TMain.Open;
begin
    with TOpenDialog.Create(nil) do begin
         options:=options+[ofallowmultiselect];
         Filter:=Launcher.Filter;
         if Filter='' then
            Filter:='FreeBasic Files (*.bas,*.bi,*.fpk)|*.bas;*.bi;*.fpk|FreeBasic code (*.bas)|*.bas|FreeBasic include (*.bi)|*.bi|FreeBac package (*.fpk)|*.fpk|Resourcescript file (*.rc)|*.rc|All files (*.*)|*.*';
         FilterIndex:=7;
         if Execute then
            Launcher.Load(Files);
         Free
    end;
end;

procedure TMain.Save;
begin
   if ActiveObject.InheritsFrom(TDialog) then
      TPageSheet(TDialog(ActiveObject).Page).Save
   else
   if ActiveObject.InheritsFrom(TPageSheet) then
      TPageSheet(ActiveObject).Save
end;

procedure TMain.SaveAs;
begin
   if ActiveObject.InheritsFrom(TDialog) then
      TPageSheet(TDialog(ActiveObject).Page).SaveAs
   else
   if ActiveObject.InheritsFrom(TPageSheet) then
      TPageSheet(ActiveObject).SaveAs
end;

procedure TMain.SaveAll;
var
   i:integer;
begin
    for i:=0 to PagesList.Count-1 do
        if not TPageSheet(PagesList.Objects[i]).Saved then
           if FileExists(TPageSheet(PagesList.Objects[i]).FileName) then
              TPageSheet(PagesList.Objects[i]).Save
           else
              TPageSheet(PagesList.Objects[i]).SaveAs;
    for i:=0 to ProjectsList.Count-1 do
        if FileExists(TProject(ProjectsList.Objects[i]).FileName) then
           TProject(ProjectsList.Objects[i]).Save
        else
           TProject(ProjectsList.Objects[i]).SaveAs{}
end;

procedure TMain.ClosePage;
begin
   if ActiveEditor<>nil then ActiveEditor.Dispose;
end;

procedure TMain.CloseAllPages;
var
   i:integer;
begin
    if ActiveProject<>nil then begin
       ActiveProject.Dispose;
       ActiveProject:=nil;
    end;
    Code.TreeView.Items.Clear;
    CanFreeDialog:=true;
    for i:=PagesList.Count-1 downto 0 do
        TPageSheet(PagesList.Objects[i]).Dispose;
    CanFreeDialog:=false;
    ActiveEditor:=nil;
    ActiveObject:=nil;
    ActiveDialog:=nil;
    UpdateToolBars;
end;

procedure TMain.ExitProgram;
begin
    if Launcher.TerminateOnExit then
       Application.Terminate
    else
       Close
end;

procedure TMain.Compile;
begin
   Launcher.Compile;
   UpdateToolBars;
end;

procedure TMain.Run;
begin
    Launcher.Run;
end;

procedure TMain.CheckProjects;
var
   i:integer;
begin
   for i:=0 to ProjectsList.Count-1 do
       TProject(ProjectsList.Objects[i]).Dispose;
end;

procedure TMain.NewApplication;
begin
    NamesList.Clear;
    CheckProjects;
    CanFreeDialog:=true;
    CheckFiles;
    CanFreeDialog:=false;
    ActiveProject:=NewProject;
    ActiveProject.AddPage(NewDialog.Page);
end;

procedure ExtractGUI;
begin
    if FileExists(ideDir+'resources.exe') then
        ShellExecute(0,'open',PChar(ideDir+'resources.exe /e'),'','',sw_show) { *Converted from ShellExecute* }
    else
       messageDlg('Error, can find one ore more GUI files.',mtError,[mbok],0);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Validator:HMODULE;
  vs:string;
begin
   SearchCompiler;

   Compiler.OnRedirect:=CompilerCompile;
   Compiler.onError:=CompilerError;
   Compiler.OnRun:=CompilerRun;
   Compiler.OnTerminate:=CompilerTerminate;
   Compiler.onCompiling:=CompilerCompiling;
   Compiler.OnAssembling:=CompilerAssembling;
   Compiler.OnLinking:=CompilerLinking;
   Compiler.Main:=Handle;

   Scripter:=TScripter.Create;
   Scripter.Launcher:=Launcher;
   
   ReadHelps;
end;

procedure TMain.FormShow(Sender: TObject);
var
   i:integer;
   silent,compile,run:boolean;
   filename:string;
begin
    Launcher.Compiler.Main:=Handle;
    Launcher.Lib.OnScan:=Scan;
    Launcher.PaletteClasses:=PanelPalette;
    Launcher.Lib.Dir:=ideDir+'GUI';
    Launcher.Lib.MainFile:=Launcher.Lib.Dir+'\core.bi';

    Launcher.Read;

    tbOpen.DropdownMenu:=Launcher.MRUFilesMenu;
    tbCompileRun.DropdownMenu:=Launcher.MRUExesMenu;

    //LoadExtensions;

    ActiveResult.Edit.Lines.Add('OK - IDE show...');

    

    Splash.Close ;

    if ParamCount>0 then begin
       for i:=0 to ParamCount-1 do begin
           try
              if fileExists(ParamStr(i+1)) then begin
                 filename:=ParamStr(i+1);
                 Launcher.Load(filename)
              end else begin
                 silent:=compareText(ParamStr(i+1),'/silent')=0;
                 compile:=compareText(ParamStr(i+1),'/compile')=0;
                 run:=compareText(ParamStr(i+1),'/run')=0;
              end;
           except end;
        end;
        if Compile then begin
           Compiler.FileName:=filename;
           Compiler.Compile;
           if run then Compiler.Run;
           if Silent then ExitProcess(10);
        end   
    end else
    NewApplication;

    ExtractGUI;

    ReadScripts;

    UpdateToolBars;

    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'Compiler',TCompilerPropEdit);
    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'ResourceFileName',TFileNamePropEdit);
    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'FileName',TFileNamePropEdit);
    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'ScannerDLL',TDLLPropEdit);
    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'LibDir',TDirectoryPropEdit);
    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'Dir',TDirectoryPropEdit);
    Inspector.Properties.RegisterPropEditor(TypeInfo(string),nil,'CodeFile',TCodeFilePropEdit);

    Launcher.Lib.MainType:=Launcher.TypeExists(Launcher.Lib.MainTypeName);

end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CheckRunning;
   Launcher.Write ;
   UnloadExtensions;
   if CheckFiles=mrCancel then Abort;
   Scripter.Free;
end;

procedure TMain.CheckRunning;
begin
   if Compiler.isRunning then
      case messageDlg(format('The %s runnig.'#10'Debug session on progress?',[Compiler.outfile]),mtConfirmation,[mbyes,mbno,mbabort],0) of
         mrno: ExitProcess(0);
         mryes: Compiler.Reset;
         mrabort:abort;
      end ;
end;

procedure TMain.tbDialogClick(Sender: TObject);
begin
    newDialog;
    if FindDialog.Visible then FindDialog.SynEdit:=ActiveEditor.Frame.Edit;
    if ReplaceDialog.Visible then ReplaceDialog.SynEdit:=ActiveEditor.Frame.Edit;
end;

procedure TMain.tbUnitsClick(Sender: TObject);
begin
    DialogList.show
end;

procedure TMain.tbEditorClick(Sender: TObject);
begin
      NewEditor ;
      if FindDialog.Visible then FindDialog.SynEdit:=ActiveEditor.Frame.Edit;
      if ReplaceDialog.Visible then ReplaceDialog.SynEdit:=ActiveEditor.Frame.Edit;
end;

procedure TMain.menuLibraryBrowserClick(Sender: TObject);
begin
    LibraryBrowser.Lib:=Launcher.Lib;
    LibraryBrowser.show
end;

procedure TMain.tbOpenClick(Sender: TObject);
begin
   Open;
end;

procedure TMain.UpdateToolBars;
begin
    tbSave.Enabled:=(ActiveEditor<>nil) and FileExists(ActiveEditor.FileName);
    tbSaveAs.Enabled:=(ActiveEditor<>nil);
    tbSaveAll.Enabled:=Code.PageControl.PageCount>1;
    tbCompileRun.Enabled:=(Compiler<>nil) and ((ActiveEditor<>nil) or (ActiveProject<>nil));
    tbResetProgram.Enabled:=(Compiler<>nil) and Compiler.isRunning
end;

procedure TMain.menuProjectsClick(Sender: TObject);
begin
    Projects.PanelProjects.BringToFront;
    Projects.Show
end;

procedure TMain.tbCompileRunClick(Sender: TObject);
begin
    Launcher.CompileRun;
    UpdateToolBars;
end;

procedure TMain.tbResetProgramClick(Sender: TObject);
begin
    Compiler.Reset;
end;

procedure TMain.menuCompilerSettingsClick(Sender: TObject);
begin
    with TCompilerSettings.Create(nil) do begin
         cbxCompilers.Text:=Compiler.FileName;
         cbxSwitches.Text:=Compiler.Switch;
         if ShowModal=mrok then begin
            Compiler.FileName:=cbxCompilers.Text;
            Compiler.Switch:=cbxSwitches.Text;
         end;
         Free;
    end;
end;

procedure TMain.menuSaveAsProjectClick(Sender: TObject);
begin
    ActiveProject.SaveAs
end;

procedure TMain.menuSaveProjectClick(Sender: TObject);
begin
    ActiveProject.Save
end;

procedure TMain.menuAddtoProjectClick(Sender: TObject);
begin
    Projects.AddInProject
end;

procedure TMain.menuRemovefromProjectClick(Sender: TObject);
begin
    Projects.RemoveFromProject
end;

procedure TMain.menuViewSourceClick(Sender: TObject);
begin
    Projects.ViewSource
end;

procedure TMain.menuCompileAllProjectsClick(Sender: TObject);
var
   i:integer;
   P:TProject;
begin 
    for i:=0 to ProjectsList.Count-1 do begin
        P:=TProject(ProjectsList.Objects[i]);
        P.Compiler:=Launcher.Compiler;
        if P<>nil then begin
           if FileExists(P.FileName) then
              P.Save
           else
              P.SaveAs;
           Compiler.Params:=P.FileName; 
           Compiler.Switch:=P.Compiler.Switch;
           Compiler.FileName:=P.Compiler.FileName;
           Compiler.Compile
        end
    end {}
end;

procedure TMain.menuGroupClick(Sender: TObject);
begin
    Projects.CheckListBox.Items.Assign(ProjectsList);
    Projects.PanelGroups.BringToFront;
    Projects.Show
end;

procedure TMain.tbNewClick(Sender: TObject);
begin
    NewApplication
end;

procedure TMain.menuApplicationClick(Sender: TObject);
begin
   newApplication;
end;

procedure TMain.menuDialogClick(Sender: TObject);
begin
    newDialog
end;

procedure TMain.menuCodeClick(Sender: TObject);
begin
    newEditor
end;

procedure TMain.menuFrameClick(Sender: TObject);
var
   i:integer;
begin
    newDialog;
    if ActiveDialog.Page<>nil then begin
       i:=NamesList.IndexOf(ActiveDialog.Name);
       if i>-1 then NamesList.Delete(i);
       ActiveDialog.Name:=NamesList.AddName('Frame');
       TPageSheet(ActiveDialog.Page).Frame.Edit.Lines.Insert(0,format('#define Register%s "%s"',[ActiveDialog.Name,ActiveDialog.Typ.Hosted]));
    end
end;

procedure TMain.menuInstallClassClick(Sender: TObject);
begin
    with TInstallClass.Create(nil) do begin
         if ShowModal=mrok then begin
            installCls(edClassFile.Text);
         end;
         Free ;
   end ;
end;

procedure TMain.menuInstallClassPackageClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='FreeBasic package file (*.fpk)|*.fpk';
         if Execute then
            installClass.installPack(FileName);
         Free
    end;
end;

procedure TMain.CopyObjects;
begin
   ActiveDialog.ELDesigner.Copy;
end;

procedure TMain.CutObjects;
var
   i:integer;
   C:TContainer;
begin
    if ActiveObject.InheritsFrom(TDialog) then begin
       if TDialog(ActiveObject).Page<>nil then
          for i:=TDialog(ActiveObject).ELDesigner.SelectedControls.Count-1 downto 0 do begin
              C:=TContainer(TDialog(ActiveObject).ELDesigner.SelectedControls.Items[i]);
              if C<>nil then
                 TPageSheet(TDialog(ActiveObject).Page).DeleteControl(C);
          end;
          TDialog(ActiveObject).ELDesigner.Cut ;
          TPageSheet(TDialog(ActiveObject).Page).Scanner.Execute;
          //ObjectsTree.UpdateItems;
    end
end;

procedure TMain.PasteObjects;
var
  i:integer;
  C:TContainer;
begin
       TDialog(ActiveObject).ELDesigner.Paste;
       if TDialog(ActiveObject).Page<>nil then
          for i:=0 to TDialog(ActiveObject).ELDesigner.SelectedControls.Count-1 do begin
              C:=TContainer(TDialog(ActiveObject).ELDesigner.SelectedControls.Items[i]);
              if C<>nil then begin
                 C.Typ:=TType(C.Tag);
                 TPageSheet(TDialog(ActiveObject).Page).InsertControl(C);
              end
          end;
       TPageSheet(TDialog(ActiveObject).Page).Scanner.Execute;
       //ObjectsTree.UpdateItems;
end;

procedure TMain.UndoObjects;
begin
end;

procedure TMain.DeleteObjects;
begin
   ActiveDialog.ELDesigner.DeleteSelectedControls;
end;

procedure TMain.SelectAllObjects;
begin
    ActiveDialog.ELDesigner.SelectedControls.SelectAll
end;

procedure TMain.pdmenuPositionClick(Sender: TObject);
begin
   with TAlignmentInWindow.Create(nil) do begin
        ShowModal;
        Free
   end;
end;

procedure TMain.menuTaborderClick(Sender: TObject);
begin
    TabOrders.Show
end;

procedure TMain.menuCreationorderClick(Sender: TObject);
begin
    CreationOrder.Show
end;

procedure TMain.menuToGridClick(Sender: TObject);
begin
    ActiveDialog.ELDesigner.SelectedControls.AlignToGrid
end;

procedure TMain.pdmenuUndoClick(Sender: TObject);
begin
    UndoObjects
end;

procedure TMain.pdmenuPasteClick(Sender: TObject);
begin
   PasteObjects
end;

procedure TMain.pdmenuCutClick(Sender: TObject);
begin
   CutObjects
end;

procedure TMain.pdmenuCopyClick(Sender: TObject);
begin
    CopyObjects
end;

procedure TMain.pdmenuDeleteClick(Sender: TObject);
var
   i:integer;
begin
   if PopupMenuDesigner.Tag>0 then
      if TDialog(PopupMenuDesigner.Tag).Page<>nil then begin
         for i:=TDialog(PopupMenuDesigner.Tag).ELDesigner.SelectedControls.Count-1 downto 0 do
             TPageSheet(TDialog(PopupMenuDesigner.Tag).Page).DeleteControl(TDialog(PopupMenuDesigner.Tag).ELDesigner.SelectedControls.Items[i]);
         TPageSheet(TDialog(PopupMenuDesigner.Tag).Page).Scanner.Execute;
      end;
   DeleteObjects;
   //ObjectsTree.UpdateItems;
   //Inspector.UpdateItems;
end;

procedure TMain.pdmenuSelectAllClick(Sender: TObject);
begin
   SelectAllObjects
end;

procedure TMain.menuEditDsgnrClick(Sender: TObject);
begin
    pdmenuPaste.Enabled:=( ActiveDialog<>nil) and (ActiveDialog.ELDesigner.CanPaste);
    pdmenuCopy.Enabled:=( ActiveDialog<>nil) and (ActiveDialog.ELDesigner.CanCopy);
    pdmenuCut.Enabled:=( ActiveDialog<>nil) and (ActiveDialog.ELDesigner.CanCut);
    pdmenuDelete.Enabled:=( ActiveDialog<>nil) and (ActiveDialog.ELDesigner.SelectedControls.Count>0);
    pdmenuSelectAll.Enabled:=( ActiveDialog<>nil) and (ActiveDialog.ControlCount>0);
end;

procedure TMain.pmenuNewClassClick(Sender: TObject);
begin
   with TNewClass.Create(nil) do begin
         ShowModal;
         Free
    end;
end;

procedure TMain.pmenuCustomizeClassesClick(Sender: TObject);
begin
    CustomizeClasses:=TCustomizeClasses.Create(nil);
    with CustomizeClasses do begin
         ShowModal;
         Free
    end;
end;

procedure TMain.menuSaveClick(Sender: TObject);
begin
    if ActiveObject.InheritsFrom(TPageSheet) then
       TPageSheet(ActiveObject).Save
    else
    if ActiveObject.InheritsFrom(TDialog) then
       if TDialog(ActiveObject).Page<>nil then
          TPageSheet(TDialog(ActiveObject).Page).Save ;
    UpdateToolBars;
end;

procedure TMain.menuSaveAsClick(Sender: TObject);
begin
    if ActiveObject.InheritsFrom(TPageSheet) then
       TPageSheet(ActiveObject).SaveAs
    else
    if ActiveObject.InheritsFrom(TDialog) then
       if TDialog(ActiveObject).Page<>nil then
          TPageSheet(TDialog(ActiveObject).Page).SaveAs;
    UpdateToolBars;
end;

procedure TMain.menuSaveAllClick(Sender: TObject);
var
   i:integer;
begin
    for i:=0 to Code.PageControl.PageCount-1 do
        if FileExists(TPageSheet(Code.PageControl.Pages[i]).FileName) then
           TPageSheet(Code.PageControl.Pages[i]).Save
        else
           TPageSheet(Code.PageControl.Pages[i]).SaveAs;
    UpdateToolBars;

end;

procedure TMain.menuHTMLClick(Sender: TObject);
begin
       with TExportFiles.Create(nil) do begin
         Project:=ActiveProject;
         if ShowModal=mrok then begin
            ExportAll;
         end;
         Free
    end;
end;

procedure TMain.menuPrintClick(Sender: TObject);
begin
        with TPrintAll.Create(nil) do begin
         Pages:=Code.PageControl;
         if ShowModal=mrok then begin
            PrintDocs; 
         end;
         free
    end;
end;

procedure TMain.menuCloseClick(Sender: TObject);
begin
   ActiveEditor.Dispose
end;

procedure TMain.menuCloseAllClick(Sender: TObject);
begin
     CloseAllPages
end;

procedure TMain.menuExitClick(Sender: TObject);
begin
    if Launcher.TerminateOnExit then
        ExitProcess(0) //Application.Terminate
    else
       Close ;
    UpdateToolBars;
end;

procedure TMain.tbSaveClick(Sender: TObject);
begin
   menuSave.Click
end;

procedure TMain.tbSaveAsClick(Sender: TObject);
begin
    menuSaveAs.Click
end;

procedure TMain.tbSaveAllClick(Sender: TObject);
begin
   menuSaveAll.Click
end;

procedure TMain.tbSettingsClick(Sender: TObject);
begin
    menuSettings.Click
end;

procedure TMain.menuSettingsClick(Sender: TObject);
begin
   with TSettings.create(nil) do begin
        if ShowModal=mrok then begin
        end;
        Free;
   end
end;

procedure TMain.menuEditClick(Sender: TObject);
begin
      if ActiveObject=nil then exit;
      if ActiveObject.InheritsFrom(TDialog) then begin
        menuUndo.Enabled:=false;
        menuRedo.Enabled:=false;
        menuPaste.Enabled:=ActiveDialog.ELDesigner.CanPaste;
        menuCut.Enabled:=ActiveDialog.ELDesigner.CanCut;
        menuCopy.Enabled:=ActiveDialog.ELDesigner.CanCopy;
        menuDelete.Enabled:=ActiveDialog.ELDesigner.SelectedControls.Count>0;
        menuSelectAll.Enabled:=ActiveDialog.ControlCount>0;
        menuBlock.Enabled:=true;
        menuComment.Enabled:=ActiveDialog.ELDesigner.CanCopy;
        menuUncomment.Enabled:=menuComment.Enabled;
        menuProperties.Enabled:=ActiveDialog<>nil;
    end else
    if ActiveObject.InheritsFrom(TPageSheet) then begin
        menuUndo.Enabled:=ActiveEditor.Frame.Edit.CanUndo;
        menuRedo.Enabled:=ActiveEditor.Frame.Edit.CanRedo;
        menuPaste.Enabled:=ActiveEditor.Frame.Edit.CanPaste;
        menuCut.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
        menuCopy.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
        menuDelete.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
        menuSelectAll.Enabled:=ActiveEditor.Frame.Edit.Text<>'';
        menuBlock.Enabled:=true;
        menuComment.Enabled:=pos('''',ActiveEditor.Frame.Edit.SelText)=0;
        menuUncomment.Enabled:=pos('''',ActiveEditor.Frame.Edit.SelText)>0;
        menuProperties.Enabled:=ActiveEditor<>nil;
    end
end;

procedure TMain.menuViewClick(Sender: TObject);
begin
    menuResultWindow.Checked:=Code.PanelResults.Visible;
    menuInspectorWindow.Checked:=Inspector.Visible;
    menuCodeExplorer.Checked:=Code.TreeView.Visible;
    menuObjectTree.Checked:=ObjectsTree.Visible;
    menuCodeEditor.Checked:=Code.Visible
end;

procedure TMain.menuObjectTreeClick(Sender: TObject);
begin
   ObjectsTree.Visible:=TMenuItem(Sender).Checked;
end;

procedure TMain.menuResultWindowClick(Sender: TObject);
begin
   Code.panelResults.Visible:=TMenuItem(Sender).Checked;
end;

procedure TMain.menuInspectorWindowClick(Sender: TObject);
begin
    Inspector.Visible:=TMenuItem(Sender).Checked;
end;

procedure TMain.menuCodeExplorerClick(Sender: TObject);
begin
       Code.TreeView.Visible:=TMenuItem(Sender).Checked;
end;

procedure TMain.menuUseToolsClick(Sender: TObject);
begin
   Tools.show
end;

procedure TMain.menuSearchClick(Sender: TObject);
begin
    menuFind.Enabled:=ActiveEditor<>nil;
    menuFindAgain.Enabled:=(ActiveEditor<>nil) and FindDialog.nextCan;
    menuReplace.Enabled:=ActiveEditor<>nil;
    menuGoToLine.Enabled:=ActiveEditor<>nil;
end;

procedure TMain.menuFindClick(Sender: TObject);
begin
   FindDialog.SynEdit:=ActiveEditor.Frame.Edit;
   FindDialog.Visible:=true
end;

procedure TMain.menuFindAgainClick(Sender: TObject);
begin
   FindDialog.FindNext;
end;

procedure TMain.menuFindinFilesClick(Sender: TObject);
begin
   SearchInFiles.Visible:=true;
end;

procedure TMain.menuReplaceClick(Sender: TObject);
begin
   ReplaceDialog.SynEdit:=ActiveEditor.Frame.Edit;
   ReplaceDialog.Visible:= true;
end;

procedure TMain.menuGotoLineClick(Sender: TObject);
begin
    GoLine.Visible:=true;
end;

procedure TMain.menuFindFileClick(Sender: TObject);
begin
    SearchFile.Show
end;

procedure TMain.menuActionClick(Sender: TObject);
begin
   menuCompile.Enabled:=ActiveProject<>nil;
   menuRun.Enabled:=FileExists(Compiler.Outfile);
   menuCompileAndRun.Enabled:=ActiveProject<>nil;
   menuResetProgram.Enabled:=Compiler.isRunning;
end;

procedure TMain.menuRunClick(Sender: TObject);
begin
    Launcher.Run
end;

procedure TMain.menuCompileandRunClick(Sender: TObject);
begin
   Launcher.CompileRun
end;

procedure TMain.menuResetProgramClick(Sender: TObject);
begin
   Launcher.Compiler.Reset
end;

procedure TMain.menuClassClick(Sender: TObject);
begin
    menuCustomizeClasses.Enabled:=(Launcher.PaletteClasses.PageCount>0) and (Launcher.PaletteClasses.Pages[0].ControlCount>1);
end;

procedure TMain.menuCompileClick(Sender: TObject);
begin
    Launcher.Compile
end;

procedure TMain.menuNewClassClick(Sender: TObject);
begin
      pmenuNewClass.Click
end;

procedure TMain.menuCustomizeClassesClick(Sender: TObject);
begin
   pmenuCustomizeClasses.Click
end;

procedure TMain.menuHelpClick(Sender: TObject);
begin
   if fileexists(Launcher.HelpFile) then
       ShellExecute(0,'open',PChar(Launcher.HelpFile),'','',sw_show) { *Converted from ShellExecute* }
   else
      MessageDlg('The Help file was not set.'#10'Set them from DropDown menu.',mtInformation,[mbok],0);
end;

procedure TMain.menuRqWorkClick(Sender: TObject);
begin
    Splash.ShowModal
end;

procedure TMain.menuHomePageClick(Sender: TObject);
var
  pid:cardinal;
begin
    pid:=ShellExecute(0,'open',PChar('http://www.rqwork.de'),'','',sw_show); { *Converted from ShellExecute* }
    if pid<=32 then
       ShellExecute(0,'open',PChar('http://www.koganion.eu'),'','',sw_show); { *Converted from ShellExecute* }
end;

procedure TMain.menuLanguageClick(Sender: TObject);
begin
    LanguagesDlg.show
end;

procedure TMain.menuWindowsClick(Sender: TObject);
var
   i:integer;
   function canRestore:boolean;
   var
      i:integer;
   begin
      result:=false;
      for i:=0 to DialogsList.Count-1 do
          if isIconic(TDialog(DialogsList.Objects[i]).Handle) then begin
             result:=true;
             break
          end
   end;
   function canMinimize:boolean;
   var
      i:integer;
   begin
      result:=false;
      for i:=0 to DialogsList.Count-1 do
          if not isIconic(TDialog(DialogsList.Objects[i]).Handle) then begin
             result:=true;
             break
          end
   end;
begin
   menuCascade.Enabled:=DialogsList.Count>1;
   menuTile.Enabled:=menuCascade.Enabled;
   menuArrangeIcons.Enabled:=menuCascade.Enabled;
   menuMinimizeallDialogwindows.Enabled:=canMinimize;
   menuRestoreallDialogWindows.Enabled:=canRestore;

    for i:=0 to menuWindows.Count-1 do
        if TMenuItem(menuWindows.Items[i]).Tag>0 then
        if TObject(TMenuItem(menuWindows.Items[i]).Tag).InheritsFrom(TDialog) then
           if TDialog(TMenuItem(menuWindows.Items[i]).Tag)=ActiveDialog then
              menuWindows.Items[i].Checked:=true
end;

procedure TMain.menuMinimizeallDialogwindowsClick(Sender: TObject);
var
   i:integer;
begin
   for i:=0 to DialogsList.Count-1 do
       ShowWindow(TDialog(DialogsList.Objects[i]).Handle,sw_minimize);
end;

procedure TMain.menuRestoreallDialogWindowsClick(Sender: TObject);
var
   i:integer;
begin
   for i:=0 to DialogsList.Count-1 do
       ShowWindow(TDialog(DialogsList.Objects[i]).Handle,sw_normal);

end;

procedure TMain.tbHelpClick(Sender: TObject);
begin
   menuHelp.Click
end;

procedure TMain.tbDialogsClick(Sender: TObject);
begin
    ProjectProperties.show
end;

procedure TMain.menuProjectClick(Sender: TObject);
begin
   menuViewSource.Enabled:=(ActiveProject<>nil) and not (ActiveProject.Page<>nil);
end;

procedure TMain.menuActiveXClassClick(Sender: TObject);
begin
   ActiveX.show
end;

procedure TMain.menuFileClick(Sender: TObject);
begin
   menuSave.Enabled:=(ActiveEditor<>nil) and FileExists((ActiveEditor.FileName));
   menuSaveAs.Enabled:=(ActiveEditor<>nil);
   menuSaveAll.Enabled:=(Code.PageControl.PageCount>1);
   menuExport.Enabled:=ActiveProject<>nil;
   menuClose.Enabled:=(ActiveEditor<>nil);
   menuCloseAll.Enabled:=(Code.PageControl.PageCount>1) or (ActiveProject<>nil);
   menuPrint.Enabled:=(ActiveEditor<>nil);
end;

procedure TMain.tbResourcesClick(Sender: TObject);
begin
   ResourcesDialog.show
end;

procedure TMain.menuMenuEditorClick(Sender: TObject);
begin
    MenuEditorDlg.Dialog:=ActiveDialog;
end;

procedure TMain.PopupMenuDesignerPopup(Sender: TObject);
begin
    menuMenuEditor.Enabled:=(ActiveDialog<>nil) and (ActiveDialog.ELDesigner.SelectedControls.DefaultControl.InheritsFrom(TDialog));
    menuEditDsgnr.Enabled:=(ActiveDialog<>nil) and (ActiveDialog.ELDesigner.SelectedControls.DefaultControl.InheritsFrom(TContainer));
    menuAlign.Enabled:=(ActiveDialog<>nil) and (ActiveDialog.ELDesigner.DesignControl.InheritsFrom(TContainer));
    menuTabOrder.Enabled:=(ActiveDialog<>nil) and (ActiveDialog.ELDesigner.SelectedControls.DefaultControl.InheritsFrom(TDialog));
    menuCreationOrder.Enabled:=(ActiveDialog<>nil) and (ActiveDialog.ELDesigner.SelectedControls.DefaultControl.InheritsFrom(TDialog));
    menuAcceptChilds.Checked:=TContainer(ActiveDialog.ELDesigner.SelectedControls.DefaultControl).AcceptChilds
end;

procedure TMain.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
     
     if Msg.CharCode=vk_f10 then begin
        if FileExists(ideDir+'gui\core.dll') then begin
           if Bridge>0 then begin//already loaded
              FreeLibrary(Bridge);
              Bridge:=0;
           end;
           Bridge:=LoadLibrary(PChar(ideDir+'gui\core.dll'));
           ActiveResult.Edit.Lines.Add('OK - Bridge was reloaded...')
        end;
        Handled:=true;
     end ;
     
     //KeyPreview:=true;
     if (GetKeyState(VK_LWIN)<0) and (GetKeyState(VK_MENU)<0) then begin
       if Msg.CharCode = ord('S') then begin
         case messageDlg('You are out of application space.'#10'Do you want to close it?',mtConfirmation,[mbok,mbno],0) of
              mrno:Handled := True;
         end     
       end;
     end;
     //KeyPreview:=false;

     if msg.CharCode=vk_f2 then begin
        Themes[1].Apply;
        Handled:=true;
     end;   
end;

procedure TMain.ResourceExportWriteFileError(Sender: TObject);
begin
    if messageDlg('File exists. Overwite it?',mtConfirmation,[mbyes,mbno],0) =mryes then
       ResourceExport.Overwrite:=true
end;

procedure TMain.menuOthersClick(Sender: TObject);
begin
    newItems.show
end;

procedure TMain.ResourceExportLoadResourceError(Sender: TObject);
begin
    messageDlg('Can''t load resources.',mtError,[mbok],0);
end;

procedure TMain.ResourceExportResourceNotFound(Sender: TObject);
begin
    messageDlg(format('Resource not found.[%s]',[ResourceExport.ResourceName]),mtError,[mbok],0)
end;

procedure TMain.ResourceExportSuccess(Sender: TObject;
  BytesWritten: Integer);
begin
    messageDlg(format('Success bytes writen %d KB.',[BytesWritten div 1024]),mtInformation,[mbok],0)
end;

procedure TMain.menuCloseSelectionClick(Sender: TObject);
begin
    CloseSelection.showmodal ;
end;

procedure TMain.menuAcceptChildsClick(Sender: TObject);
begin
    if ActiveDialog.ELDesigner.SelectedControls.DefaultControl.InheritsFrom(TContainer) then
       TContainer(ActiveDialog.ELDesigner.SelectedControls.DefaultControl).AcceptChilds:=TMenuItem(Sender).Checked
end;

procedure TMain.menuOnlineHelpClick(Sender: TObject);
var
   pid:cardinal;
begin
   pid:=ShellExecute(0,'open','http://www.rqwork.de/rqwork_pages/kogaion_help.html','','',sw_show); { *Converted from ShellExecute* }
   if pid<=32 then
      messageDlg('Can''t run kogaion online help.',mtInformation,[mbok],0);
end;

procedure TMain.menuOpenClick(Sender: TObject);
begin
   tbOpen.Click
end;

procedure TMain.menuCodeEditorClick(Sender: TObject);
begin
   Code.Visible:=TMenuItem(sender).Checked
end;

procedure TMain.menuFileTypeClick(Sender: TObject);
begin
    Associations.ShowModal
end;

procedure TMain.menuOptionsClick(Sender: TObject);
begin
   if ProjectProperties.ShowModal=mrok then
   ;
end;

initialization
   registerClasses([TResourceExport]);
   ideDir:=ExtractFilePath(ParamStr(0));
   workDir:=ideDir;
   BridgeFile:=ideDir+'gui\gui.bas';
   Resources:=TResources.create;
   Debugger:=TDebugger.create;
   Launcher:=TLauncher.Create;
   Launcher.OnButtonClick:=Main.PaletteClick;
   Compiler:=Launcher.Compiler;
   Debugger:=TDebugger.Create;
   ExtensionsList:=TStringList.Create;
   ResourceExport:=TResourceExport.Create(nil);
   if not DirectoryExists(ideDir+'gui') then
      ExtractGUI;
finalization
   Launcher.Free;
   Resources.Free;
   Debugger.Free;
   ExtensionsList.Free;
   ResourceExport.Free;
end.
