program Kogaion;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  MainUnit in 'MainUnit.pas' {Main},
  CodeUnit in 'CodeUnit.pas' {Code},
  InspectorUnit in 'InspectorUnit.pas' {Inspector},
  ObjectsTreeUnit in 'ObjectsTreeUnit.pas' {ObjectsTree},
  PageSheetUnit in 'PageSheetUnit.pas',
  DialogUnit in 'DialogUnit.pas' {Dialog},
  EditFrame in 'EditFrame.pas' {Editor: TFrame},
  DialogsListUnit in 'DialogsListUnit.pas' {DialogList},
  LibraryBrowserUnit in 'LibraryBrowserUnit.pas' {LibraryBrowser},
  ProjectsUnit in 'ProjectsUnit.pas' {Projects},
  CompilerSettingsUnit in 'CompilerSettingsUnit.pas' {CompilerSettings},
  FrameNewItems in 'FrameNewItems.pas' {FrameNewI: TFrame},
  MenuEditorUnit in 'MenuEditorUnit.pas' {MenuEditorDlg},
  newItemUnit in 'newItemUnit.pas' {newItems},
  InstallClassUnit in 'InstallClassUnit.pas' {InstallClass},
  AlignmentInWindowUnit in 'AlignmentInWindowUnit.pas' {AlignmentInWindow},
  CreationOrderUnit in 'CreationOrderUnit.pas' {CreationOrder},
  CustomizeClassesFrame in 'CustomizeClassesFrame.pas' {CustClassesFrame: TFrame},
  CustomizeClassesUnit in 'CustomizeClassesUnit.pas' {CustomizeClasses},
  TabOrderUnit in 'TabOrderUnit.pas' {TabOrders},
  NewClassUnit in 'newClassUnit.pas' {NewClass},
  SettingsUnit in 'SettingsUnit.pas' {Settings},
  SplashUnit in 'SplashUnit.pas' {Splash},
  ToolsUnit in 'ToolsUnit.pas' {Tools},
  FindDialogUnit in 'FindDialogUnit.pas' {FindDialog},
  ReplaceDialogunit in 'ReplaceDialogunit.pas' {ReplaceDialog},
  ResourceDialogUnit in 'ResourceDialogUnit.pas' {ResourcesDialog},
  SearchFileUnit in 'SearchFileUnit.pas' {SearchFile},
  SearchInFilesUnit in 'SearchInFilesUnit.pas' {SearchInFiles},
  OccurenciesUnit in 'OccurenciesUnit.pas' {Occurences},
  GoToLineUnit in 'GoToLineUnit.pas' {GoLine},
  LanguagesUnit in 'LanguagesUnit.pas' {LanguagesDlg},
  ActiveXUnit in 'ActiveXUnit.pas' {ActiveX},
  CompletionDataBase in 'CompletionDataBase.pas',
  ComponentContainerUnit in 'ComponentContainerUnit.pas',
  ProjectPropertiesUnit in 'ProjectPropertiesUnit.pas' {ProjectProperties},
  CloseSelectionUnit in 'CloseSelectionUnit.pas' {CloseSelection},
  ColorButton in '..\..\..\..\Program Files\Delphi7SE\Lib\ColorButton.pas',
  unSystemInformation in 'unSystemInformation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TCode, Code);
  Application.CreateForm(TInspector, Inspector);
  Application.CreateForm(TObjectsTree, ObjectsTree);
  Application.CreateForm(TDialogList, DialogList);
  Application.CreateForm(TLibraryBrowser, LibraryBrowser);
  Application.CreateForm(TProjects, Projects);
  Application.CreateForm(TCompilerSettings, CompilerSettings);
  Application.CreateForm(TMenuEditorDlg, MenuEditorDlg);
  Application.CreateForm(TnewItems, newItems);
  Application.CreateForm(TInstallClass, InstallClass);
  Application.CreateForm(TAlignmentInWindow, AlignmentInWindow);
  Application.CreateForm(TCreationOrder, CreationOrder);
  Application.CreateForm(TCustomizeClasses, CustomizeClasses);
  Application.CreateForm(TTabOrders, TabOrders);
  Application.CreateForm(TNewClass, NewClass);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TSplash, Splash);
  Application.CreateForm(TTools, Tools);
  Application.CreateForm(TFindDialog, FindDialog);
  Application.CreateForm(TReplaceDialog, ReplaceDialog);
  Application.CreateForm(TResourcesDialog, ResourcesDialog);
  Application.CreateForm(TSearchFile, SearchFile);
  Application.CreateForm(TSearchInFiles, SearchInFiles);
  Application.CreateForm(TOccurences, Occurences);
  Application.CreateForm(TGoLine, GoLine);
  Application.CreateForm(TLanguagesDlg, LanguagesDlg);
  Application.CreateForm(TActiveX, ActiveX);
  Application.CreateForm(TProjectProperties, ProjectProperties);
  Application.CreateForm(TCloseSelection, CloseSelection);
  Splash.Show;
  Application.Run;
end.
