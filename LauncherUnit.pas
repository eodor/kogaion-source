unit LauncherUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, XPMan, ComCtrls, ToolWin, ExtCtrls, PageSheetUnit,
  DialogUnit, TypesUnit, CompilerUnit, IniFiles, ELDsgnr, SynEdit, SynEditTypes,
  SynEditMiscClasses, SynEditOptionsDialog, TypInfo, DesignIntf, Buttons, StrUtils ;

type
   TLauncher=class;

   TLauncherThemeColor=class
   public
      FontName:string;
      FontSize:integer;
      FontColor:TColor;
      ChildFG, ColorFG, SelFG, SelBG :TColor;
      procedure Apply;
   end;
   TLauncherTmemeColors=array of TLauncherThemeColor;

   TPaletteButton=class(TSpeedButton)
   private
     fType:TType;
     procedure SetType(v:TType);
   public
     ModuleName:string;
     constructor create(aowner:tcomponent);override;
     destructor destroy;override;
     property Typ:TType read fType write SetType;
   end;

   TPalettePage=class(TTabSheet)
   private
      fNull:TPaletteButton;
      fModule,fDLL:string;
      procedure SetDLL(v:string);
   protected
      procedure Resize;override;
      procedure ButtonClick(Sender:TObject);
   public
     Launcher:TLauncher;
     DLLModule:hmodule;
     constructor create(aowner:tcomponent);override;
     destructor destroy;override;
     procedure UpdateItems;
     property Null:TPaletteButton read fNull;
     property Module:string read fmodule write fModule;
     property DLL:string read fDLL write setDLL;
   end;


   TLauncher=class(TStringList)
   private
     fIdeMode:TIdeMode;
     fTheme:integer;
     fApplication:TApp;
     fMRUFilesMenu,fMRUExesMenu:TPopupMenu;
     fClassPalettes:TClassRegPages;
     fIni:string;
     fFilter,fDBMask,fTarget, fSelClass:string;
     fClasses,fDBMasks,fMRUFiles,fMRUExes,fModules,fTypes,fClassFiles:TStrings;
     fLib:TLibrary;
     fCompiler:TCompiler;
     fCompilers:TStrings;
     fSwitch:string;
     fMainWindow:hwnd;
     fDialogsMenu:TMenuItem;
     fDesigner :TELDesigner;
     fEditOptions :TSynEditorOptionsContainer;
     fOptions:TLauncherOptions;
     fPaletteClasses:TPageControl;
     fButtonClick,fMRUFileClick,fMRUExeClick:TNotifyEvent;
     fSelType:TType;
     fMarkImages:TImageList;
     fLanguage:string;
     function GetLanguage:string;
     procedure SetLanguage(v:string);
     procedure SetLib(v:TLibrary);
     procedure SetClassPalettes(v:TClassRegPages);
     procedure SetTarget(v:string);
   protected
     procedure SetMode(v:TIdeMode);
     procedure SetTheme(v:integer);
     procedure ButtonClick(Sender:TObject);
     procedure MRUExeClick(Sender:TObject);
     procedure MRUFileClick(Sender:TObject);
     procedure ChangeDialogName(Sender: TObject);
   public
     HelpFile:string;
     AlowCompletion, EditIsGlobal, DesignerIsGlobal,
     MinimizeOnRun,DisableOnRun, ResourcesEmbed,
     RunSeparateThread, RunDebugger, Conjoin,
     AllowMultipleFileInstances ,DataBaseOnLoad,
     TerminateOnExit,ReadScripts, onlyOneError :boolean;
     procedure LoadOptionsContainer;
     procedure SaveOptionsContainer;
     procedure LoadClasses;
     function isPage(v:string):TPalettePage;
     function isClass(v:string):TType;
     function isRegisteredClass(v:string):TType;
     function isButton(v:TType):TPaletteButton;overload;
     function isButton(v:string):TPaletteButton;overload;
     function AddPage(v:string;L:TStrings=nil):TPalettePage;
     function AddClass(pl, v:string):TPaletteButton;
     procedure RemoveClass(v:string);
     procedure ClearClasses;
     procedure ResetPalette;
     procedure UpdateItems;
     function isOpen(v:string):TPageSheet; overload;
     function isOpen(v:TObject):TPageSheet; overload;
     procedure AddForm(v:TForm);
     procedure AddMRUExe(v:string);
     procedure AddMRUFile(v:string);
     procedure Load(v:string); overload;
     procedure Load(v:TStrings);overload;
     procedure Compile;
     procedure CompileRun;
     procedure Run;
     function NewEditor(v:string=''):TPageSheet;
     function NewDialog(v:string=''):TDialog;
     function NewProject(v:string=''):TProject;
     procedure Read(f:string='');
     procedure Write;
     procedure GroupProject;
     procedure CompileAllProjects;
     procedure SetClassTypes;
     function isFileRegistered(v:string):integer;
     function ModuleByClass(v:string):string;
     function ModuleByPalette(v:string;var L:TStringList):string;
     function ClassesByModule(v:string;var L:TStringList):boolean;
     function RegisteredClassesByModule(v:string; var L:TStringList):boolean;
     function TypeExists(v:string):TType;
     procedure SaveClasses;
     constructor create;
     destructor destroy;override;
     property Mode:TIDEMode read fideMode write SetMode;
     property Theme:integer read fTheme write SetTheme;
     property Types:TStrings read fTypes;
     property ClassFiles:TStrings read fClassFiles;
     property SelClass:string read fSelClass;
     property Target:string read ftarget write settarget;
     property Language:string read GetLanguage write SetLanguage;
     property Modules:TStrings read fModules;
     property MRUFilesMenu:TPopupMenu read fMRUFilesMenu;
     property MRUExesMenu:TPopupMenu read fMRUExesMenu;
     property MRUFiles:TStrings read fMRUFiles;
     property MRUExes:TStrings read fMRUExes;
     property App:TApp read fApplication write fApplication;
     property DBMask:string read fdbmask write fdbmask;
     property ClassPalettes:TClassRegPages read fClassPalettes write SetClassPalettes;
     property SelType:TType read fSeltype write fSeltype;
     property Classes:TStrings read fClasses;
     property DBMasks:TStrings read fDBMasks write fDBMasks;
     property MainWindow:hwnd read fmainwindow write fmainwindow;
     property Switch:string read fSwitch write fSwitch;
     property DialogsMenu:TMenuItem read fDialogsMenu write fDialogsMenu;
     property Compilers:TStrings read fCompilers write fCompilers;
     property Lib:TLibrary read fLib write SetLib;
     property Compiler:TCompiler read fCompiler write fCompiler;
     property Filter:string read fFilter write fFilter;
     property Ini:string read fini write fini;
     property Designer :TELDesigner read fDesigner write fDesigner;
     property PaletteClasses:TPageControl read fPaletteClasses write fPaletteClasses;
     property EditOptions :TSynEditorOptionsContainer read fEditOptions write fEditOptions;
     property MarkImages:TImageList read fMarkImages;
     property Options:TLauncherOptions read fOptions write fOptions;
     property OnButtonClick:TNotifyEvent read fButtonClick write fButtonClick;
     property OnMRUFileClick:TNotifyEvent read fMRUFileClick write fMRUFileClick;
     property OnMRUExeClick:TNotifyEvent read fMRUExeClick write fMRUExeClick;
   end;

{   procedure ClearIdx;
    function GetIdx(v :string):string;

var
   NamesList:TStrings;}

var
   Themes:TLauncherTmemeColors;

implementation

uses MainUnit, CodeUnit, HelperUnit, ToolsUnit, LanguagesUnit, ObjectsTreeUnit,
     InspectorUnit, ResourceDialogUnit, ProjectsUnit, installClassUnit, ScannerUnit,
     SettingsUnit;

{$R 'class.res'}

{procedure ClearIdx;
begin
    NamesList.Clear;
end;

function GetIdx(v :string):string;
var
      i,j :integer;
label
    reload;
begin
       result:= '';
       j := 0;
       for i := 0 to NamesList.Count-1 do
           if Pos(lowercase(v),lowercase(NamesList[i]))>0 then
              inc(j);
       Result:=format('%s%d',[v,j+1]);
       reload:
       if NamesList.IndexOf(result)=-1 then
          NamesList.Add(Result)
       else begin
          inc(j);
          Result:=format('%s%d',[v,j+1]);
          if NamesList.IndexOf(result)<>-1 then goto reload;
       end;;
end; }

{ TLauncherThemeColor }
procedure TLauncherThemeColor.Apply;
var
   i,Addr:integer;
   Pif:PPropInfo;
begin
    for i:=0 to Application.ComponentCount-1 do begin
        Pif:=GetPropInfo(Application.Components[i],'Color');
        if Pif<>nil then begin
           if Application.Components[i].InheritsFrom(TWinControl) then
              if TWinControl(Application.Components[i]).Parent<>nil then
                 SetPropValue(Application.Components[i],'Color',ChildFG)
              else
                 SetPropValue(Application.Components[i],'Color',ChildFG);
        end;
        Pif:=GetPropInfo(Application.Components[i],'Font');
        if Pif<>nil then begin
           Addr:=GetPropValue(Application.Components[i],'Font');
           if Addr>0 then begin
              TFont(Addr).Color:=FontColor;
              TFont(Addr).Name:=FontName;
              TFont(Addr).Size:=FontSize;
           end
        end ;
        Pif:=GetPropInfo(Application.Components[i],'SelectedColor');
        if Pif<>nil then begin
           Addr:=GetPropValue(Application.Components[i],'SelectedColor');
           if Addr>0 then begin
              TSynSelectedColor(Addr).Background:=SelBG;
              TSynSelectedColor(Addr).Foreground:=SelFG;
           end
        end ;
    end
end;

{ TPaletteButton }
constructor TPaletteButton.create(aowner:tcomponent);
begin
   inherited;
   fType:=TType.create;
end;

destructor TPaletteButton.destroy;
begin
   fType.Free;
   inherited;
end;

procedure TPaletteButton.SetType(v:TType);
begin
   if v<>nil then begin
      try
         Hint:=v.Hosted;
         Tag:=integer(PChar(v.Alias));
         Typ.Hosted:=v.Hosted;
         Typ.Alias:=v.Alias;
         Typ.ExtendsType:=v.ExtendsType;
         Typ.ForwarderType:=v.ForwarderType;
         Typ.Forwarder:=v.Forwarder;
         Typ.cx:=v.cx;
         Typ.cy:=v.cy;
         Typ.Style:=v.Style;
         Typ.StyleEx:=v.StyleEx;
         Typ.Module:=v.Module;
         Typ.ID:=v.ID;
         Typ.Enums.Assign(v.Enums);
         Typ.Unions.Assign(v.Unions);
         Typ.Subs.Assign(v.Subs);
         Typ.Funcs.Assign(v.Funcs);
         Typ.Operators.Assign(v.Operators);
         Typ.Visibility:=v.Visibility;
         Typ.Fields.Assign(v.Fields);
         Typ.Properties.Assign(v.Properties);
         Typ.PropertyEditor:=v.PropertyEditor;
         Typ.Params:=v.Params;
         Typ.Return:=v.Return;
         Typ.Special:=v.Special
      except
      end
   end
end;

{ TPalettePage }
constructor TPalettePage.create(aowner:tcomponent);
begin
   inherited;
   fNull:=TPaletteButton.create(self);
   fNull.Left:=4;
   fNull.Top:=4;
   fNull.OnClick:=ButtonClick;
   fNull.GroupIndex:=1;
   fNull.Down:=true;
   fNull.Hint:='NULL';
   fNull.ShowHint:=true;
   fNull.Parent:=self;
   if FindResource(hinstance,'null',rt_bitmap)>0 then
      fNull.Glyph.LoadFromResourceName(hinstance,'null');
end;

destructor TPalettePage.destroy;
begin
   inherited;
end;

procedure TPalettePage.SetDLL(v:string);
begin
   fDLL:=v;
   if FileExists(v) then begin
   end
end;

procedure TPalettePage.UpdateItems;
begin
   Resize;
end;

procedure TPalettePage.Resize;
var
   i,x:integer;
begin
    inherited;
    x:=4;
    for i:=1 to ControlCount-1 do begin
        inc(x,28);
        Controls[i].Left:=x;
        Controls[i].Top:=4;
        Controls[i].ShowHint:=true
    end
end;

procedure TPalettePage.ButtonClick(Sender:TObject);
begin
    if Launcher<>nil then
       with Launcher do begin
         fSelType:=nil;
         fSelClass:='';
         if Assigned(fButtonClick) then
            fButtonClick(Sender);
       end
end;


{ TLauncher }
constructor TLauncher.create;
var
   Bitmap:TBitmap;
   i:integer;
begin
   fMarkImages:=TImageList.Create(nil);
   for i:=0 to 7 do begin
       Bitmap:=TBitmap.Create;
       Bitmap.LoadFromResourceName(hinstance,format('bmp%d',[i+1]));
       fMarkImages.AddMasked(Bitmap,Bitmap.Canvas.Pixels[0,0]);
       Bitmap.Free;
   end;
   fini:=ChangeFileExt(ParamStr(0),'.ini');
   fApplication:=TApp.create;
   fDesigner :=TELDesigner.Create(nil);
   fEditOptions :=TSynEditorOptionsContainer.Create(nil);
   fCompiler:=TCompiler.Create;

   fCompilers:=TStringList.Create;
   fClasses:=TStringList.Create;
   fDBMasks:=TStringList.Create;
   fModules:=TStringList.Create;
   fMRUFiles:=TStringList.Create;
   fMRUExes:=TStringList.Create;
   fClassFiles:=TStringList.Create;
   fMRUFilesMenu:=TPopupMenu.Create(nil);
   fMRUExesMenu:=TPopupMenu.Create(nil);
   fTypes:=TStringList.Create;
   fLib:=TLibrary.create;
   fLib.Launcher:=self;
   fFilter:='FreeBasic code file (*.bas)|*.bas|FreeBasic include file (*.bi)|*.bi|Text file (*.txt)|*.txt|HTML files (*.html)|*.html;*.htm|RTF File (*.rtf)|*.rtf|All files (*.*)|*.*';
end;

destructor TLauncher.destroy;
begin
   fMRUFilesMenu.Free;
   fMRUExesMenu.Free;
   fCompiler.Free;
   fDesigner.Free;
   fEditOptions.Free;
   fClasses.Free;
   fDBMasks.Free;
   fMRUFiles.Free;
   fMRUExes.Free;
   fApplication.Free;
   fModules.Free;
   fClassFiles.Free;
   fMarkImages.Free;
   fTypes.Free;
   inherited;
end;

procedure TLauncher.SetTheme(v:integer);
begin
    fTheme:=v;
    if fTheme>5 then fTheme:=0;
end;

procedure TLauncher.SetLib(v:TLibrary);
begin
   fLib:=v;
   if not FileExists(v.FileName) then
      v.FileName:=ideDir+'gui\gui.bi';
end;

procedure TLauncher.SetClassPalettes(v:TClassRegPages);
var
   i,j:integer;
   B:TPaletteButton;
   T:TType;
begin
    fClassPalettes:=nil;
    if (v<>nil) and (length(v)>0) then begin
       SetLength(fClassPalettes,length(v));
       for i:=0 to length(v)-1 do begin
           fClassPalettes[i]:=TClassRegPage.create;
           fClassPalettes[i].Page:=v[i].Page;
           fClassPalettes[i].Assign(v[i]);
           AddPage(fClassPalettes[i].Page,fClassPalettes[i]).Module:=v[i].FileName;
           fClasses.AddStrings(v[i]);
           for j:=0 to v[i].Count-1 do begin
               if v[i].Objects[j]<>nil then begin
                  T:=TType(v[i].Objects[j]);
                  B:=isButton(T.Hosted);
                  if B=nil then exit;
                  B.Typ.Hosted:=T.Hosted; 
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
                  if FindResource(Bridge,PChar(T.Hosted),rt_bitmap)>0 then
                     B.Glyph.LoadFromResourceName(Bridge,T.Hosted) else
                     if FindResource(hinstance,'qcontrol',rt_bitmap)>0 then
                       B.Glyph.LoadFromResourceName(hinstance,'qcontrol');
               end
           end;
       end
    end  ;
end;

procedure TLauncher.SetTarget(v:string);
begin
   ftarget:=v;
   if v='' then begin
      ftarget:='windows';
      exit;
   end else if comparetext(v,'windows')=0 then exit;   
   if fLib.isMultiplatform=false then
      messageDlg(format('The %s library are not Multiplatform one.',[flib.FileName]),mtInformation,[mbok],0);
end;

procedure TLauncher.SetMode(v:TIdeMode);
begin
    fideMode:=v;
    BuildMode(v);
end;

function TLauncher.TypeExists(v:string):TType;
var
   i:integer;
begin
    result:=nil;
    if v='' then exit;
    for i:=0 to fTypes.Count-1 do
        if compareText(v,fTypes[i])=0 then begin
           result:=TType(fTypes.Objects[i]);
           break
        end
end;

function TLauncher.isFileRegistered(v:string):integer;
var
   i:integer;
begin
    result:=-1;
    if v='' then exit;
    for i:=0 to fLib.FileCount-1 do
        if comparetext(fLib.Files[i],v)=0 then begin
           result:=i;
           exit;
        end
end;

procedure TLauncher.AddForm(v:TForm);
begin
    if v<>nil then
       if IndexOfObject(v)=-1 then
          AddObject(v.Name,v);
end;

procedure TLauncher.ChangeDialogName(Sender:TObject);
begin
   Inspector.Properties.UpdateItems;
end;

function TLauncher.NewEditor(v:string=''):TPageSheet;
begin
    result:=TPageSheet.create(nil);//Code.PageControl);
    result.Align:=alClient;
    result.PageControl:=Code.PageControl;
    result.ScanTree:=Code.TreeView;
    result.FileName:=v;
    ActiveEditor:=result;
    if EditIsGlobal then
       fEditOptions.AssignTo(ActiveEditor.Frame.Edit);
    if v='' then result.Name:=NamesList.AddName('Code');
    Code.PageControl.ActivePage:=result ;
    if FileExists(v) then
       Main.ReadPage(result);

    if result.Dialog<>nil then
       ActiveObject:=result.Dialog
    else begin
       ActiveObject:=ActiveEditor;
       TPageSheet(result).Scanner.OnScanConstructor:=Main.ScanCstr;
       Code.TreeView.Items.Clear;
       if FileExists(v) then begin
          TPageSheet(result).Scanner.FileName:=v;
          TPageSheet(result).Scanner.Scan
       end   
    end;
end;


function TLauncher.NewDialog(v:string=''):TDialog;
var
   i:integer;
   P:TPageSheet;
begin
   P:=NewEditor(v);
   P.HasDialog:=true;
   result:=P.Dialog;
   result.Page:=P;
   result.OnNameChanged:=ChangeDialogName;
   if result.Page<>nil then begin
      i:=NamesList.IndexOf(result.Page.Name);
      if i>-1 then NamesList.Delete(i);
      result.Page.Caption:=result.Caption;
      TPageSheet(result.Page).Scanner.OnScanConstructor:=Main.ScanCstr;
      TPageSheet(result.Page).InsertDialog;
   end ;
   result.Page.Name:=result.name;
   result.Page.Caption:=result.name;
   //result.Caption:=result.Name;
   ActiveDialog:=result;
   ActiveObject:=ActiveDialog  ;
   ObjectsTree.Dialog:=result
end;

function TLauncher.NewProject(v:string=''):TProject;
begin
    result:=TProject.Create;
    result.Tree:=Projects.TreeView;
    result.Compiler:=Launcher.Compiler;
    if FileExists(v) then
       result.FileName:=v
    else
       result.Name:=NamesList.AddName('Project');
    ActiveProject:=result;
end;{}

procedure TLauncher.Load(v:string);
var
   L:TStrings;
   Ps:TPageSheet;
   s,ext,rif:string;
   i,x:integer;
begin
   if v='' then exit;
   Ps:=isOpen(v);
   if Ps<>nil then begin
      Code.PageControl.ActivePage:=Ps;
      exit;
   end;
   
   L:=TStringList.Create;
   L.LoadFromFile(v);
   i:=pos('isproject',lowercase(L.Text));
   if i>0 then begin
      x:=posex(' ',L.Text,i+9);
      s:=copy(L.Text,i+9,x-(i+9));
      newProject.Load(v);
      ActiveProject.Name:=s;
   end else newEditor(v);
   L.Free;

   rif:=ChangeFileExt(v,'.rc');
   if FileExists(rif) then
      Resources.FileName:=rif;

   if NeedRebuildBridge then begin
      Main.BuildBridge;
      NeedRebuildBridge:=false;
   end;

   ListDLLExports(v,ActiveEditor.Exported,true);
   ext:=ExtractFileExt(ActiveEditor.FileName);
   if (compareText(ext,'.dll')=0) or
      (compareText(ext,'.ocx')=0) or
      (compareText(ext,'.exe')=0) then
      ActiveResult.Edit.Lines.AddStrings(ActiveEditor.Exported);
   if (compareText(ext,'.rc')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.RC
   else if (compareText(ext,'.bas')=0) or (compareText(ext,'.bi')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.FreeBasic
   else if (compareText(ext,'.html')=0) or (compareText(ext,'.htm')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.HTML
   else if (compareText(ext,'.css')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.css
   else if (compareText(ext,'.py')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.Python
   else if (compareText(ext,'.php')=0) or (compareText(ext,'.bi')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.PHP
   else if (compareText(ext,'.vb')=0) or (compareText(ext,'.vba')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.VBScript
   else if (compareText(ext,'.js')=0) then
      ActiveEditor.Frame.Edit.Highlighter:=ActiveEditor.Frame.JScript;
   AddMRUFile(v);
end;

procedure TLauncher.Load(v:TStrings);
var
   i:integer;
begin
   for i:=0 to v.Count-1 do
       Load(v[i])
end;

procedure TLauncher.LoadClasses;
var
   i:integer;
   rf:string;
   wcls:TWndClassEx;
   L:TStrings;
   s:string;
begin
   try
      for i:=0 to fClassFiles.Count-1 do
          installClass.InstallCls(fClassFiles[i]);
   except end;
   SetClassTypes;

   L:=TStringList.Create;
   L.LoadFromFile(ideDir+'gui\core.fpk');
   L.Add('');
   s:='';
   for i:=0 to fClasses.Count-1 do
       if i<fClasses.Count-1 then
          s:=s+fClasses[i]+','
       else
          s:=s+fClasses[i];
   if s<>'' then begin      
      if pos('exportclasses',lowercase(L.Text))=0 then begin
         L.Add('function ExportClasses stdcall() as zstring ptr export');
         L.Add(format('    return @"%s"',[s]));
         L.Add('end function');
      end
   end;
   L.SaveToFile(ideDir+'gui\core.fpk');
   L.Free;
end;

procedure TLauncher.Read(f:string='');
var
   i,j,vl,er:integer;
   L,B:TStrings;
   P,V:string;
   Fm:TForm;
   Pif:PPropInfo;
   s:string;
   Ri:TResourceItem;
begin
    if FileExists(f) then
       fini:=f
    else
       fini:=ChangeFileExt(ParamStr(0),'.ini');
    L:=TStringList.Create;
    B:=TStringList.Create;
    with TIniFile.Create(fini) do begin
         L.Text:=stringReplace(ReadString('Launcher','forms',''),',',#10,[rfreplaceall]);
         for i:=0 to L.Count-1 do begin
             Fm:=TForm(Application.FindComponent(L[i]));
             if Fm<> nil then begin
                ReadSectionValues(L[i],B); 
                for j:=0 to B.Count-1 do begin
                    P:=trim(copy(B[j],1,pos('=',B[j])-1));
                    V:=trim(copy(B[j],pos('=',B[j])+1,length(B[j])));
                    if v<>'0' then begin
                       Pif:=GetPropInfo(Fm,P);
                       if (Pif<>nil) and (Pif^.PropType^.Kind=tkInteger) then begin
                          val(V,vl,er);
                          if er=0 then typinfo.SetPropValue(Fm,P,vl);
                       end;
                    end
                end
             end
         end;

         s:=StringReplace(ReadString('Launcher','Classes',''),',',#10,[rfreplaceall]);
         L.Text:=s;
         if L.Count>0 then
            for i:=PaletteClasses.PageCount-1 downto 0 do
                if PaletteClasses.Pages[i].ControlCount>1 then
                   for j:=PaletteClasses.Pages[i].ControlCount-1 downto 1 do
                       if L.IndexOf(PaletteClasses.Pages[i].Controls[j].Hint)=-1 then
                          PaletteClasses.Pages[i].Controls[j].Free;
         ReadSection('ClassFiles',fClassFiles);

         ReadSection('IncPaths',Settings.ListBoxDirs.Items);
         Compiler.Switch:='-i ';
         for i:=0 to Settings.ListBoxDirs.Items.Count-1 do
             Compiler.Switch:=Compiler.Switch+format(' "%s"',[Settings.ListBoxDirs.Items[i]]);

         ReadSection('MRUFiles',L);
         for i:=0 to L.Count-1 do
             AddMRUFile(L[i]);

         ReadSection('MRUExes',L);
         for i:=0 to L.Count-1 do
             AddMRUExe(L[i]);
         Language:=ReadString('Launcher','Language','Base.txt');
         v:=ReadString('Launcher','Compiler','');
         if FileExists(v) then Compiler.FileName:=v;

         fEditOptions.Font.Name:=ReadString('Edit','Font.Name','Lucida Console');
         fEditOptions.Font.Size:=ReadInteger('Edit','Font.Size',10);

         onlyOneError:=ReadBool('Launcher','onlyOneError',false);
         ReadScripts:=ReadBool('Launcher','ReadScripts',false);
         AlowCompletion:=ReadBool('Launcher','Completion',true);
         TerminateOnExit:=ReadBool('Launcher','TerminateOnExit',false);
         AllowMultipleFileInstances:=ReadBool('Launcher','AlowMultipleFileInstances',false);
         DataBaseOnLoad:=ReadBool('Launcher','DataBaseOnLoad',false);
         fSwitch:=ReadString('Launcher','Switch','');
         fFilter:=ReadString('Launcher','Filter','');
         Conjoin:=ReadBool('Launcher','Conjoin',false);
         MinimizeOnRun:=ReadBool('Launcher','MinimizeOnRun',false);
         DisableOnRun:=ReadBool('Launcher','DisableOnRun',false);
         EditIsGlobal:=ReadBool('Launcher','EditIsGlobal',false);
         DesignerIsGlobal:=ReadBool('Launcher','DesignerIsGlobal',false);
         ResourcesEmbed:=ReadBool('Launcher','ResourceEmbed',false);
         fDesigner.Grid.Visible:=ReadBool('Designer','GridVisible',true);
         fDesigner.Grid.XStep:=ReadInteger('Designer','GridXStep',4);
         fDesigner.Grid.YStep:=ReadInteger('Designer','GridYStep',4);
         fDesigner.Grid.Color:=TColor(ReadInteger('Designer','GridColor',0));

         App.IconPath:=ReadString('Launcher','AppIconPath','');
         if FileExists(App.IconPath) then begin
            App.Icon:=TIcon.Create;
            App.Icon.LoadFromFile(App.IconPath);
            Ri:=TResourceItem.Create;
            Ri.kind:='ICON';
            Ri.FileName:=App.IconPath;
            Ri.Name:=ChangeFileExt(ExtractFileName(App.IconPath),'');
            Resources.Items.AddObject(Ri.Name,Ri);
         end;
         App.Help:=ReadString('Launcher','AppHelp','');
         p:=ReadString('Tools','List','');
         L.Text:=StringReplace(p,',',#10,[rfreplaceall]);
         for i:=0 to L.Count-1 do begin
             ActiveTool:=TTool.Create;
             ActiveTool.Name:=L[i];
             ToolsList.AddObject(ActiveTool.Name,ActiveTool);
             ReadSectionValues(L[i],B);
             for j:=0 to B.Count-1 do begin
                 p:=copy(B[j],1,pos('=',B[j])-1);
                 v:=copy(B[j],pos('=',B[j])+1,length(B[j]));
                 if comparetext('name',p)=0 then
                    ActiveTool.Name:=v;
                 if comparetext('filename',p)=0 then
                    ActiveTool.FileName:=v;
                 if comparetext('inmenu',p)=0 then
                    ActiveTool.InMenu:=boolean(strtoint(v));
             end
         end;
         Free
    end;
    L.Free;
    B.Free; if EditIsGlobal then LoadOptionsContainer;
end;

procedure TLauncher.Write;
var
   i,j:integer;
   s:string;
   Fm:TForm;
   L:TStrings;
begin
    fini:=ChangeFileExt(ParamStr(0),'.ini');
    with TIniFile.Create(fini) do begin
         L:=TStringList.Create;
         L.Text:=StringReplace(ReadString('Launcher','Forms',''),',',#10,[rfreplaceall]);
         if L.Count>0 then
            for i:=0 to L.Count-1 do
                if L[i]<>'' then
                   if SectionExists(L[i]) then
                      EraseSection(L[i]);
         DeleteKey('Launcher','Forms');
         for i:=Application.ComponentCount-1 downto 0 do begin
             Fm:=nil;
             if Application.Components[i].InheritsFrom(TForm) then
                Fm:=TForm(Application.Components[i]);
             if Fm<>nil then begin
                s:= s+ Fm.Name + ',';
                try
                WriteInteger(Fm.Name,'left',Fm.Left);
                WriteInteger(Fm.Name,'top',Fm.Top);
                WriteInteger(Fm.Name,'width',Fm.Width);
                WriteInteger(Fm.Name,'height',Fm.height);
                except end;
             end

         end;
         WriteString('Launcher','Forms',copy(s,1,length(s)-1));
         SaveClasses;
             DeleteKey('Launcher','Classes'); s:='';
             for j:=0 to fClasses.Count-1 do begin
                 if j<fClasses.Count-1 then
                    s:=s+fClasses[j]+','
                 else
                    s:=s+fClasses[j];
             end;
             WriteString('Launcher','Classes',s);
         EraseSection('ClassFiles');
         for i:=0 to fClassFiles.Count-1 do
             WriteString('ClassFiles',fClassFiles[i],inttostr(i));
         WriteString('Edit','Font.Name', fEditOptions.Font.Name);
         WriteInteger('Edit','Font.Size',fEditOptions.Font.Size);

         WriteBool('Launcher','Completion',AlowCompletion);
         WriteBool('Launcher','OnlyOneError',OnlyOneError);
         WriteBool('Launcher','ReadaScripts',ReadScripts);
         WriteBool('Launcher','TerminateOnExit',TerminateOnExit);
         WriteBool('Launcher','AlowMultipleFileInstances',AllowMultipleFileInstances);
         WriteBool('Launcher','DataBaseOnLoad',DataBaseOnLoad);
         WriteString('Launcher','Switch',fSwitch);
         WriteString('Launcher','Filter',fFilter);
         WriteBool('Launcher','Completion',AlowCompletion);
         WriteBool('Launcher','Conjoin',Conjoin);
         WriteBool('Launcher','MinimizeOnRun',MinimizeOnRun);
         WriteBool('Launcher','DisableOnRun',DisableOnRun);
         WriteBool('Launcher','EditIsGlobal',EditIsGlobal);
         WriteBool('Launcher','DesignerIsGlobal',DesignerIsGlobal);
         WriteBool('Launcher','ResourceEmbed',ResourcesEmbed);
         if ActiveLang<>nil then
            WriteString('Launcher','Language',ActiveLang.FileName);
         WriteBool('Designer','GridVisible',fDesigner.Grid.Visible);
         WriteInteger('Designer','GridXStep',fDesigner.Grid.XStep);
         WriteInteger('Designer','GridYStep',fDesigner.Grid.YStep);
         WriteInteger('Designer','GridColor',integer(fDesigner.Grid.Color));
         WriteString('Launcher','AppIconPath',App.IconPath);
         WriteString('Launcher','AppHelp',App.Help);
         WriteString('Launcher','Filter',fFilter);
         WriteString('Launcher','Compiler',fCompiler.FileName);
         DeleteKey('Tools','List');
         for i:=0 to ToolsList.Count-1 do
             EraseSection(ToolsList[i]);
         s:='';
         for i:=0 to ToolsList.Count-1 do begin
             if i<ToolsList.Count-1 then
                s:=s+ToolsList[i]+','
             else
                s:=s+ToolsList[i];
             ActiveTool:=TTool(ToolsList.Objects[i]);
             if ActiveTool<>nil then begin
                WriteString(ToolsList[i],'Name',ActiveTool.Name);
                WriteString(ToolsList[i],'FileName',ActiveTool.FileName);
                WriteBool(ToolsList[i],'inMenu',ActiveTool.InMenu);
             end
         end;
         WriteString('Tools','List',s);
         for i:=0 to  fClassFiles.Count-1 do
             WriteString('ClassFiles',fClassFiles[i],format('%d',[i]));
         for i:=0 to  fMRUFiles.Count-1 do
             WriteString('MRUFiles',fMRUFiles[i],format('%d',[i]));
         for i:=0 to  fMRUExes.Count-1 do
             WriteString('MRUExes',fMRUExes[i],format('%d',[i]));
         Free;
    end; SaveOptionsContainer;
end;

procedure TLauncher.LoadOptionsContainer;
var
   i:integer;
begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini')) do begin
         fEditOptions.Font.Name:=ReadString('EditOptionsContainer','Font.Name','Lucida Console');
         fEditOptions.Font.Size:=ReadInteger('EditOptionsContainer','Font.Size',9);
         fEditOptions.BookmarkOptions.GlyphsVisible:=ReadBool('EditOptionsContainer','BookmarkOptions.GlyphsVisible',true);
         fEditOptions.Gutter.Visible:=ReadBool('EditOptionsContainer','Gutter.Visible',true);
         fEditOptions.Gutter.ShowLineNumbers:=ReadBool('EditOptionsContainer','Gutter.LineNumbers',false);
         fEditOptions.Gutter.Width:=ReadInteger('EditOptionsContainer','Gutter.Width',30);
         fEditOptions.Gutter.Color:=TColor(ReadInteger('EditOptionsContainer','Gutter.Color',clBtnFace));

         for i:=0 to fEditOptions.Keystrokes.Count-1 do begin
             if fEditOptions.KeyStrokes.Items[i]=nil then fEditOptions.KeyStrokes.Items[i]:=fEditOptions.KeyStrokes.Add;
             fEditOptions.Keystrokes.Items[i].DisplayName:=ReadString('EditOptionsContainer','keystroke'+inttostr(i),'');
         end;
         fEditOptions.SelectedColor.Background:=TColor(ReadInteger('EditOptionsContainer','SelectedColor.Background',clNone));
         fEditOptions.SelectedColor.Foreground:=TColor(ReadInteger('EditOptionsContainer','SelectedColor.Foreground',clNavy));

         fEditOptions.Color:=TColor(ReadInteger('EditOptionsContainer','Color',clWindow));
         fEditOptions.Options:=TSynEditorOptions(ReadInteger('EditOptionsContainer','Options',1024));
         fEditOptions.ExtraLineSpacing:=ReadInteger('EditOptionsContainer','ExtraLineSpacing',0);
         fEditOptions.HideSelection:=ReadBool('EditOptionsContainer','HideSelection',false);
         fEditOptions.InsertCaret:=TSynEditCaretType(ReadInteger('EditOptionsContainer','InsertCaret',0));
         fEditOptions.OverwriteCaret:=TSynEditCaretType(ReadInteger('EditOptionsContainer','OverwriteCaret',0));
         fEditOptions.MaxScrollWidth:=ReadInteger('EditOptionsContainer','MaxScrollWidth',0);
         fEditOptions.MaxUndo:=ReadInteger('EditOptionsContainer','MaxUndo',1024);
         fEditOptions.RightEdge:=ReadInteger('EditOptionsContainer','RightEdge',220);
         fEditOptions.RightEdgeColor:=TColor(ReadInteger('EditOptionsContainer','RightEdgeColor',clGray));
         fEditOptions.TabWidth:=ReadInteger('EditOptionsContainer','TabWidth',8);
         fEditOptions.WantTabs:=ReadBool('EditOptionsContainer','WantTabs',true);

         Free
    end;
end;

procedure TLauncher.SaveOptionsContainer;
var
   i:integer;
begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini')) do begin
         WriteString('EditOptionsContainer','Font.Name',fEditOptions.Font.Name);
         WriteInteger('EditOptionsContainer','Font.Size',fEditOptions.Font.Size);
         WriteBool('EditOptionsContainer','BookmarkOptions.GlyphsVisible',fEditOptions.BookmarkOptions.GlyphsVisible);
         WriteBool('EditOptionsContainer','Gutter.Visible',fEditOptions.Gutter.Visible);
         WriteBool('EditOptionsContainer','Gutter.LineNumbers',fEditOptions.Gutter.ShowLineNumbers);
         WriteInteger('EditOptionsContainer','Gutter.Width',fEditOptions.Gutter.Width);
         WriteInteger('EditOptionsContainer','Gutter.Color',integer(fEditOptions.Gutter.Color));
         for i:=0 to fEditOptions.Keystrokes.Count-1 do
             WriteString('EditOptionsContainer','keystroke'+inttostr(i),fEditOptions.Keystrokes.Items[i].DisplayName);

         WriteInteger('EditOptionsContainer','SelectedColor.Background',integer(fEditOptions.SelectedColor.Background));
         WriteInteger('EditOptionsContainer','SelectedColor.Foreground',integer(fEditOptions.SelectedColor.Foreground));

         WriteInteger('EditOptionsContainer','Color',integer(fEditOptions.Color));
         WriteInteger('EditOptionsContainer','Options',integer(fEditOptions.Options));
         WriteInteger('EditOptionsContainer','ExtraLineSpacing',fEditOptions.ExtraLineSpacing);
         WriteBool('EditOptionsContainer','HideSelection',fEditOptions.HideSelection);
         WriteInteger('EditOptionsContainer','InsertCaret',integer(fEditOptions.InsertCaret));
         WriteInteger('EditOptionsContainer','OverwriteCaret',integer(fEditOptions.OverwriteCaret));
         WriteInteger('EditOptionsContainer','MaxScrollWidth',fEditOptions.MaxScrollWidth);
         WriteInteger('EditOptionsContainer','MaxUndo',fEditOptions.MaxUndo);
         WriteInteger('EditOptionsContainer','RightEdge',fEditOptions.RightEdge);
         WriteInteger('EditOptionsContainer','RightEdgeColor',integer(fEditOptions.RightEdgeColor));
         WriteInteger('EditOptionsContainer','TabWidth',fEditOptions.TabWidth);
         WriteBool('EditOptionsContainer','WantTabs',fEditOptions.WantTabs);
         Free
    end;
end;

procedure TLauncher.Compile;
var
   ext,c,incPaths:string;
   i:integer;
begin
    Compiler.Clear;
    Debugger.Reset;

    if ActiveProject<>nil then begin
       if ActiveProject.Page=nil then
          ActiveProject.BuildSource
       else
          ActiveProject.Assign(TPageSheet(ActiveProject.Page).Frame.Edit.Lines);
       if not ActiveProject.Saved then
          if FileExists(ActiveProject.FileName) then
             ActiveProject.Save
          else
             ActiveProject.SaveAs;
       for i:=0 to ActiveProject.Files.Count-1 do begin
           if ActiveProject.Files.Objects[i]<>nil then
              if not TPageSheet(ActiveProject.Files.Objects[i]).Saved then begin
                 c:=TPageSheet(ActiveProject.Files.Objects[i]).FileName;
                 if c='' then c:=TPageSheet(ActiveProject.Files.Objects[i]).Caption;
                 case messageDlg(format('The %s page was modified.'#10'Do you want to save?',[c]),mtConfirmation,[mbyes,mbno,mbabort],0) of
                   mryes: if FileExists(c) then
                             TPageSheet(ActiveProject.Files.Objects[i]).Save
                          else
                             TPageSheet(ActiveProject.Files.Objects[i]).SaveAs;
                   mrno,mrabort: abort;
               end
            end;
       end;
       if ActiveProject.ModalResult=2 then exit;
       Compiler.Params:=ActiveProject.FileName;
   end else if ActiveEditor<>nil then Compiler.Params:=ActiveEditor.FileName;

   if ResourcesEmbed then
      if (Resources.Items.Count>0) or
         (Resources.Menus.Count>0) or
         (Resources.PopupMenus.Count>0) then begin
         Resources.FileName:=ChangeFileExt(Compiler.Params,'.rc');
         Resources.Save;
         ResourcesDialog.RCSource.Lines.LoadFromFile(Resources.FileName);
      end else Resources.FileName:='';
   if ActiveProject<>nil then Compiler:=ActiveProject.Compiler;
   Compiler.Main:=MainWindow;
   if Settings.ListBoxDirs.Items.Count>0 then begin
       incPaths:='';
       for i:=0 to Settings.ListBoxDirs.Items.Count-1 do
           incPaths:=incPaths+format(' -i "%s"',[Settings.ListBoxDirs.Items[i]]);
   end else incPaths:='';

   Launcher.Compiler.Switch:=Launcher.Switch+' '+incPaths+' '+Resources.FileName+' '+Compiler.Switch+format(' -include "%s"',[Launcher.Lib.MainFile]);

   Compiler.Switch:=Launcher.Compiler.Switch;
   Compiler.Compile;//Run;
   if FileExists(Compiler.Outfile) then
      AddMRUExe(Compiler.Outfile);
end;

procedure TLauncher.CompileRun;
begin
    Compile;
    if ActiveProject<>nil then
       if ActiveProject.ModalResult=mrok then{} Run;
end;

procedure TLauncher.Run;
begin
   if FileExists(Compiler.Outfile) then
      Compiler.Run
   else
      if not Compiler.InError then
         messageDlg('Can''t run.',mtError,[mbok],0);
end;

procedure TLauncher.MRUExeClick(Sender:TObject);
begin
   Compiler.Outfile:=StringReplace(TMenuItem(Sender).Caption,'&','',[rfreplaceall]);
   Compiler.Run;
   if assigned(fMRUExeclick) then fMRUFileClick(Sender)
end;

procedure TLauncher.MRUFileClick(Sender:TObject);
begin
   if assigned(fMRUFileclick) then fMRUExeClick(Sender)
end;

procedure TLauncher.AddMRUExe(v:string);
var
   Mi:TMenuItem;
begin
    if fMRUExes.IndexOf(v)=-1 then begin
       fMRUExes.Add(v) ;
       Mi:=TMenuItem.Create(fMRUExesMenu);
       Mi.OnClick:=MRUExeClick;
       Mi.Caption:=v;
       fMRUExesMenu.Items.Add(Mi);
    end ;
    
end;

procedure TLauncher.AddMRUFile(v:string);
var
   Mi:TMenuItem;
begin
    if fMRUFiles.IndexOf(v)=-1 then begin
       fMRUFiles.Add(v) ;
       Mi:=TMenuItem.Create(fMRUFilesMenu);
       Mi.OnClick:=MRUFileClick;
       Mi.Caption:=v;
       fMRUFilesMenu.Items.Add(Mi); 
    end
end;

//palette classes
procedure TLauncher.ButtonClick(Sender:TObject);
begin
    fSelType:=TPaletteButton(Sender).Typ;
    fSelClass:=TPaletteButton(Sender).Hint;
    if Assigned(fButtonClick) then
       fButtonClick(Sender);
end;

function TLauncher.isClass(v:string):TType;
var
   i:integer;
   T:TType;
begin
    result:=nil;
    if (v='') or (self=nil) then exit;
    for i:=0 to fClasses.Count-1 do begin
        T:=TType(fClasses.Objects[i]);
        if T<>nil then begin
           if comparetext(T.Name,v)=0 then begin
              result:=T;
              break
           end ;end
    end
end;

function TLauncher.isRegisteredClass(v:string):TType;
var
   i,j:integer;
   B:TPaletteButton;
begin
    result:=nil;
    if v='' then exit;
    for i:=0 to fPaletteClasses.PageCount-1 do
        for j:=1 to fPaletteClasses.Pages[i].ControlCount-1 do begin
            B:=TPaletteButton(fPaletteClasses.Pages[i].Controls[j]);
            if (comparetext(B.Hint,v)=0) or (comparetext(PChar(B.Tag),v)=0) then begin
               result:=B.Typ;
               exit
            end
        end
end;

function TLauncher.isOpen(v:string):TPageSheet;
var
   i:integer;
   P:TPageSheet;
begin
    result:=nil;
    if v='' then exit;

    for i:=0 to Code.PageControl.PageCount-1 do begin
        P:=TPageSheet(Code.PageControl.Pages[i]);
        if P<>nil then
           if (comparetext(P.FileName,v)=0) then begin
              result:=P;
              if not AllowMultipleFileInstances then exit;
           end
    end
end;

function TLauncher.isOpen(v:TObject):TPageSheet;
var
   i:integer;
   P:TPageSheet;
begin
    result:=nil;
    if v=nil then exit;

    for i:=0 to Code.PageControl.PageCount-1 do begin
        P:=TPageSheet(Code.PageControl.Pages[i]);
        if P<>nil then
           if P=v then begin
              result:=P;
              if not AllowMultipleFileInstances then exit;
           end
    end
end;

function TLauncher.isButton(v:TType):TPaletteButton;
var
   i,j:integer;

   B:TPaletteButton;
begin

    result:=nil;
    if v=nil then exit;
    for i:=0 to fPaletteClasses.PageCount-1 do
        for j:=1 to fPaletteClasses.Pages[i].ControlCount-1 do begin
            B:=TPaletteButton(fPaletteClasses.Pages[i].Controls[j]);
            if (B<>nil) and ((comparetext(B.Typ.Hosted,v.Hosted)=0) or (comparetext(PChar(B.Typ.Alias),v.Alias)=0)) then begin
               result:=B;
               exit
            end
        end
end;

function TLauncher.isButton(v:string):TPaletteButton;
var
   i,j:integer;
   B:TPaletteButton;
begin
    result:=nil;
    if v='' then exit;
    for i:=0 to fPaletteClasses.PageCount-1 do
        for j:=1 to fPaletteClasses.Pages[i].ControlCount-1 do begin
            B:=TPaletteButton(fPaletteClasses.Pages[i].Controls[j]);
            if (comparetext(B.Hint,v)=0) or (comparetext(PChar(B.Tag),v)=0) then begin
               result:=B;
               exit
            end
        end
end;

function TLauncher.isPage(v:string):TPalettePage;
var
   i:integer;
begin
    result:=nil;
    if v='' then exit;
    for i:=0 to fPaletteClasses.PageCount-1 do
        if comparetext(fPaletteClasses.Pages[i].Caption,v)=0 then begin
           result:=TPalettePage(fPaletteClasses.Pages[i]);
           exit
        end
end;

function TLauncher.AddPage(v:string;L:TStrings=nil):TPalettePage;
var
   i:integer;
   B:TPaletteButton;
begin
    result:=isPage(v);
    if result=nil then begin
       result:=TPalettePage.create(fPaletteClasses);
       result.Caption:=v;
       result.PageControl:=PaletteClasses;
       result.Launcher:=self;
    end;    

       if L<>nil then
          if L.Count>0 then
             for i:=0 to L.Count-1 do begin
                 if isClass(L[i])=nil then begin
                       B:=TPaletteButton.create(result);
                       B.Typ:=fLib.TypExists(L[i]);
                       B.OnClick:=ButtonClick;
                       B.GroupIndex:=1;
                       B.Hint:=L[i];
                       B.ShowHint:=true;
                       B.Parent:=result ;
                 end      
             end ;
    if result<>nil then result.Resize; 
end;

function TLauncher.AddClass(pl,v:string):TPaletteButton;
var
   T:TType;
   B:TPaletteButton;
   P:TPalettePage;
begin
    result:=isButton(v);
    if result=nil then begin
       P:=isPage(pl);
       if P=nil then begin
          P:=TPalettePage.Create(fPaletteClasses);
          P.Caption:=pl;
          P.PageControl:=fPaletteClasses;
          if result<>nil then P.Module:=Result.Typ.Module;
       end;
       T:=isClass(v);
       if T=nil then begin
          B:=TPaletteButton.create(result);
          B.Typ:=fLib.TypExists(v);
          B.Tag:=integer(PChar(v));
          B.OnClick:=ButtonClick;
          B.GroupIndex:=1;
          B.ShowHint:=true;
          B.Hint:=v;
          B.Parent:=P;
          result:=B
       end
    end
end;

procedure TLauncher.RemoveClass(v:string);
var
   B:TPaletteButton;
   i:integer;
begin
   B:=isButton(v);
   if B<>nil then begin
      i:=fClasses.IndexOf(v);
      if i>-1 then fClasses.Delete(i);
      B.Free;
      UpdateItems;
   end
end;

procedure TLauncher.ClearClasses;
var
   i:integer;
begin
   for i:=fClasses.Count-1 downto 0 do
       RemoveClass(fClasses[i])
end;

procedure TLauncher.SetClassTypes;
var
   i,j:integer;
   B:TPaletteButton;
   T:TType;
begin
   for i:=0 to high(fClassPalettes) do
       for j:=0 to fClassPalettes[i].Count-1 do begin
           if fClassPalettes[i].Objects[j]<>nil then begin //
               T:=TType(fClassPalettes[i].Objects[j]) ;
               if T<>nil then begin
                  B:=Launcher.isButton(T.Hosted);
                  if B=nil then exit;
                  B.Typ.Hosted:=T.Hosted;
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
                  if FindResource(Bridge,PChar(T.Hosted),rt_bitmap)>0 then
                     B.Glyph.LoadFromResourceName(Bridge,T.Hosted) else
                     if FindResource(hinstance,'qcontrol',rt_bitmap)>0 then
                       B.Glyph.LoadFromResourceName(hinstance,'qcontrol');
               end
           end
        end

end;

function TLauncher.ModuleByClass(v:string):string;
var
   L:TStrings;
   i:integer;
   Sc:TScanner;
   T:TType;
begin
    result:='';
    L:=TStringList.Create;
    FindFiles(L,ideDir+'GUI\','*.bi');
    for i:=0 to L.Count-1 do begin
        Sc:=TScanner.Create;
        Sc.FileName:=L[i];
        if Sc.Types.IndexOf(v)>-1 then begin
           T:=Sc.TypExists(v);
           if T<>nil then begin
              result:=T.Module;
              exit
           end
        end
    end;
    L.Free
end;

function TLauncher.ModuleByPalette(v:string;var L:TStringList):string;
var
   P:TPalettePage;
   i:integer;
   T:TType;
begin
   P:=isPage(v);
   if P<>nil then begin
      for i:=1 to P.ControlCount-1 do begin
          T:=TPaletteButton(P.Controls[i]).Typ;
          if T<>nil then
             if L.IndexOf(T.Module)=-1 then L.AddObject(T.Module,T);
      end ;
      if L.Count>0 then
         result:=L[0]
      else
         result:='';
   end
end;

function TLauncher.ClassesByModule(v:string;var L:TStringList):boolean;
var
   Sc:TScanner;
begin
    if FileExists(v) then begin
       Sc:=TScanner.create;
       Sc.FileName:=v;
       Sc.Scan;  
       L.Assign(Sc.Types);
       Sc.Free;
       result:=L.Count>0;
    end
end;

function TLauncher.RegisteredClassesByModule(v:string; var L:TStringList):boolean;
var
   B:TStrings;
   x,y,z,i:integer;
   s:string;
begin
    if FileExists(v) then begin
       B:=TStringList.Create;
       B.LoadFromFile(v);
       x:=pos(' register',lowercase(B.Text));
       if x>0 then begin
          y:=posex('"',B.Text,x+1);
          z:=posex('"',B.Text,y+1);
          s:=copy(B.Text,y+1,z-y-1); 
          L.Text:=StringReplace(s,',',#10,[rfreplaceall]);
          result:=L.Count>0;
       end;
       B.Free;
    end
end;

procedure TLauncher.ResetPalette;
var
  i:integer;
begin
    for i:=0 to fPaletteClasses.PageCount-1 do begin
        TPaletteButton(fPaletteClasses.Pages[i].Controls[0]).Down:=true;
        fSelType:=nil;
        fSelClass:='';
    end
end;

procedure TLauncher.UpdateItems;
var
   i:integer;
begin
    for i:=0 to fPaletteClasses.PageCount-1 do
        TPalettePage(fPaletteClasses.Pages[i]).Resize
end;

procedure TLauncher.SaveClasses;
var
   i,j:integer;
   Pg:TPalettePage;
   L:TStringList;
begin
    for i:=0 to self.PaletteClasses.PageCount-1 do begin
        Pg:=TPalettePage(PaletteClasses.Pages[i]);
        for j:=1 to Pg.ControlCount-1 do begin
            Launcher.Classes.Add(TPaletteButton(Pg.Controls[j]).Hint);
        end{}
    end
end;

function TLauncher.GetLanguage:string;
begin
   result:=fLanguage;
end;

procedure TLauncher.SetLanguage(v:string);
begin
    if FileExists(v) then begin
       fLanguage:=v;
       LanguagesDlg.GetLanguages;
       ActiveLang:=LanguagesDlg.LanguageExists(v);
       if ActiveLang<>nil then begin
          ActiveLang.SetLanguage;
          LanguagesDlg.ListBox.ItemIndex:=LanguagesDlg.ListBox.Items.IndexOfObject(ActiveLang)
       end
    end 
end;

procedure TLauncher.GroupProject;
var
   i:integer;
   B:TStrings;
   P:TProject;
   s:TStrings;
begin
   B:=TStringList.Create; s:=TStringList.Create;
   B.Add('');
   B.Add('''Project Group File');
   B.Add('''Koganion(RqWork7) file');
   B.Add('');
   for i:=0 to ProjectsList.Count-1 do begin
       P:=TProject(ProjectsList.Objects[i]);
       if P<>nil then begin
          B.AddObject(format('''%s',[P.Name]),P);
          if not P.Saved then
             if FileExists(P.FileName) then P.Save else P.SaveAs;
          s.AddObject(format('#include once "%s"',[P.FileName]),P);
          B.AddObject(format('#define Project_%s "%s"',[P.Name,P.FileName]),P);
          B.AddObject(format('#define Project_%s_Compiler "%s"',[P.Name,P.CompilerPath]),P);
          B.AddObject(format('#define Project_%s_Compiler_Switch "%s"',[P.Name,P.Switch]),P);
       end
   end ;
   for i:=0 to s.Count-1 do
       B.InsertObject(i+3,s[i],s.Objects[i]);
   with TSaveDialog.Create(nil) do begin
        FileName:='Group.bas';
        Filter:='Project Group File (*.bas)|*.bas|All Files (*.*)|*.*' ;
        options:=options+[ofoverwriteprompt];
        if execute then begin
           if FilterIndex=1 then
              FileName:=ChangeFileExt(FileName,'.bas');
           B.SaveToFile(FileName);
        end;
        Free;
   end;
   B.Free;{}
end;

procedure TLauncher.CompileAllProjects;
var
   i:integer;
   P:TProject;
   R:TStrings;
   s:string;
begin
   R:=TStringList.Create;
   s:='';
   for i:=0 to ProjectsList.Count-1 do begin
       P:=TProject(ProjectsList.Objects[i]);
       if P<>nil then begin
          if FileExists(P.CompilerPath) then Launcher.Compiler.FileName:=P.CompilerPath;
          if P.Switch<>''then Launcher.Compiler.Switch:=P.Switch;
          if FileExists(P.ResourcesFile) then begin
             Resources.FileName:=P.ResourcesFile;
             Resources.Load;
          end ;
          Launcher.Compile;
          if i<ProjectsList.Count then
             s:=s+P.Name+','
          else
             s:=s+P.Name;
          R.Add('');
          R.AddStrings(Launcher.Compiler.Outputs);
       end
   end;
   if s<>'' then
      messageDlg(format('The %s was compiled',[s]),mtInformation,[mbok],0);
   R.Free;{}
end;

initialization
   SetLength(Themes,5);
   Themes[1]:=TLauncherThemeColor.Create;
   Themes[1].ChildFG:=$00FFBE7D;
   Themes[1].ColorFG:=$00EE7700;
   Themes[1].FontName:='Courier New';
   Themes[1].FontSize:=10;
   Themes[1].FontColor:=$005B2E00;
finalization

{initialization
   NamesList:=TStringList.Create;
finalization
   NamesList.Free;}

end.
