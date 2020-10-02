unit TypesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, XPMan, ComCtrls, ToolWin, ExtCtrls, HelperUnit,PropertyEditUnit,
  IniFiles, CompilerUnit, TypInfo, SynEditTypes, StrUtils;
  

type
   TField=class;
   TType=class;
   TClassRegPage=class;
   TClassRegPages=array of TClassRegPage;

   TLauncherOption=(loDisableOnRun,loMinimizeOnRun,loEmbedResources,loEditAreGlobal,loDesignerAreGolbal,loConjoin,loMultipleFilesInstance,loDBScanOnLoad,loTerminateOnExit,loAlowPlugins,loIDEMode);
   TLauncherOptions=set of TLauncherOption;

   TScannerEvent=procedure(Sender:TObject;v:string) of object;
   TScanLineEvent=procedure(Sender:TObject;i:integer;v:string) of object;
   TScanCstrEvent=procedure(Sender:TObject;cf,f:TField;v:string) of object;
   TScanRegisterEvent=procedure(Sender:TObject;Line:integer; Tokens:TStrings; page:TClassRegPage) of object;

   TAppKind=(atSpecific,atApi,atRC);

   TIDEMode=(mdDelphi,mdVB);

   TResources=class;

   TNamesList=class(TStringList)
   public
     function AddName(v:string):string;
     procedure RemoveName(v:string);
     function NameExists(v:string):integer;
   end;

   TApp=class
   public
     Icon:TIcon;
     Kind:TAppKind;
     IconPath,DefaultExt,Help:string;
   end;

   PInfo = ^TInfo;
   TInfo= {packed} record
    Text:PChar;
    Tree:hwnd;
    Edit:hwnd;
   end;

   TAssignedProperty=class
   public
   Name,Value :string;
   Assigned :boolean;
   end;

   TAssignedEvent=class(TAssignedProperty)
   private
   fParams:string;
   fParamsList:TStrings;
   procedure SetParams(v:string);
   public
   constructor Create;
   destructor Destroy; override;
   property Params :string read fParams write SetParams;
   property ParamsList:TStrings read fParamsList;
   end;

   TWindowStyle = class(TPersistent)
   public
    Value :uint;
    strValue:string;
    Name :string;
   end;

   TDependecieKind=(dkFile,dkPath);
   TDependencie=class
     kind:TDependecieKind;
     item:string;
   end;

   TClassRegPage=class(TStringList)
   public
      Page, FileName:string;
      Module:hmodule;
      constructor create;
      destructor destroy;override;
   end;

   TTool=class
   private
     fName,fFileName,fParams :string;
     fInMenu :boolean;
   public
     MenuItem:TMenuItem;  
   published
     property Name :string read fName write fName;
     property FileName :string read fFileName write fFileName;
     property Params :string read fParams write fParams;
     property InMenu :boolean read finmenu write finmenu;
   end;

   TLanguage=class
   private
     fName,fFileName :string;
     fMessages :TStrings;
   public
     Launcher :Pointer;//TLauncher;
     constructor Create; overload;
     destructor Destroy; override;
     procedure SetLanguage;
   published
     property Name :string read fName write fName;
     property FileName :string read fFileName write fFileName;
     property Messages :TStrings read fMessages write fMessages;
   end;

   TNewItem=class(TPersistent)
   private
     fCodeFile,fName :string;
     fCode :TStrings;
     procedure SetCodeFile(v :string);
   protected
     procedure SetName(const v :string);
   public
     Owner :TListItem;
     constructor Create; reintroduce; overload;
     destructor Destroy; override;
     property Code :TStrings read fCode;
   published
     property CodeFile :string read fCodeFile write SetCodeFile;
     property Name:string read fName write SetName;
   end;

   TField=class(TPersistent)
   private
     fOwner:TField;
     fFields:TStrings;
     fModule,fHosted,fAncestor,fAlias,fName,fReturn,fParams,fSpecial,fKind,fTyp,fvisibility:string;
     fValue :string;//variant;
     fStyle,fStyleEx,fCx,fCy:integer;
     fAbsolutePosKw,fAbsolutePosIdent,fAbsoluteLine:integer;
     fPropertyEditor:TPropertyEditor;
     function GetFieldCount:integer;
     function GetField(i:integer):TField;
   public
     Where,Implemented:TPoint;
     constructor create;
     destructor destroy; override;
     function FieldExists(v:string):TField;
     property Fields:TStrings read fFields;
     property FieldCount:integer read GetFieldCount;
     property Field[index:integer]:TField read GetField;
     property Module:string read fModule write fModule;
     property Owner:TField read fOwner write fOwner;
     property PropertyEditor:TPropertyEditor read fPropertyEditor write fPropertyEditor;
   published
     property Visibility:string read fvisibility write fvisibility;
     property Typ:string read ftyp write ftyp;
     property Name:string read fName write fName;
     property Hosted:string read fHosted write fHosted;
     property Ancestor:string read fAncestor write fAncestor;
     property Alias:string read fAlias write fAlias;
     property Style:integer read fStyle write fStyle;
     property StyleEx:integer read fStyleEx write fStyleEx;
     property Cx:integer read fCx write fCx;
     property Cy:integer read fCy write fCy;
     property Return:string read freturn write freturn;
     property Params:string read fparams write fparams;
     property Special:string read fspecial write fspecial;
     property Kind:string read fkind write fkind;
     property Value:string {variant} read fvalue write fvalue;
     property AbsolutePosKw:integer read fabsoluteposKw write fabsoluteposKw;
     property AbsolutePosIdent:integer read fabsoluteposIdent write fabsoluteposIdent;
     property AbsolutePosLine:integer read fAbsoluteLine write fAbsoluteLine;
   end;

   TType=class(TField)
   private
      fEnums,fUnions,fSubs,fFuncs,fOperators,fProperties:TStrings;
      fExtendsType ,fForwarderType :TType;
      fExtends,fForwarder, fFieldAlign, funit :string;
      fx,fy,fcx,fcy,fid,fHandle:integer;
      fcontrol:TWinControl;
   public
      constructor create;
      destructor destroy; override;
      function CstrExists(v:string):TField;
      property Module:string read funit write funit;
      property Handle:integer read fhandle write fhandle;
      property Control:TWinControl read fcontrol write fcontrol;
      property ID :integer read fid write fid;
      property x:integer read fx write fx;
      property y:integer read fy write fy;
      property cx:integer read fcx write fcx;
      property cy:integer read fcy write fcy;
      property Enums:TStrings read fEnums ;
      property Unions:TStrings read fUnions ;
      property Subs:TStrings read fSubs ;
      property Funcs:TStrings read fFuncs ;
      property Operators:TStrings read fOperators ;
      property Properties:TStrings read fProperties ;
      property ExtendsType:TType read fExtendsType write fExtendsType;
      property ForwarderType:TType read fForwarderType write fForwarderType;
      property Extends:string read fExtends write fExtends;
      property Forwarder:string read fForwarder write fForwarder;
      property FieldAlign:string read ffieldalign write ffieldalign;
   end;

   TNamespace=class(TType)
   end;

   TLibrary=class(TPersistent)
   private
     fFiles, fClasses, fBiFiles:TStrings;
     fMask:string;
     fMainType:TType;
     fMainFile,fFileName,fDir, fMainTypeName:string;
     fTypes:TStrings;
     fScan:TScannerEvent;
     fScanLine:TSCanLineEvent;
     fLauncher:TObject;
     fFields,fIncludes:TStrings;
     fisMultiplatform:boolean;
     procedure SetMask(v:string);
     procedure SetDir(v:string);
     procedure SetMainTypeName(v:string);
     procedure SetFileName(v:string);
     procedure SetLauncher(v:TObject);
     procedure SetMainFile(v:string);
     function GetFileCount:integer;
     function GetFile(i:integer):string;
     procedure SetFile(i:integer;v:string);
     function GetTypeCount:integer;
     function GetType(i:integer):TType;
     procedure SetType(i:integer;v:TType);
     function GetFieldCount:integer;
     function GetField(i:integer):TField;
     procedure SetField(i:integer;v:TField);
     function GetIncludeCount:integer;
     function GetInclude(i:integer):string;
     procedure SetInclude(i:integer;v:string);
     procedure SetMainType(v:TType);
   public
     incFile:TStrings;
     constructor create;
     destructor destroy;override;
     function IndexOfType(v:string):integer;
     function IndexOfProperty(t,v:string;var ancestor:TType; all:boolean=true):integer;
     function IndexOfField(v:string):integer;
     function IndexOfInclude(v:string):integer;
     function IndexOfFile(v:string):integer;
     function TypExists(v:string):TType;
     function PropertyExists(t,v:string;all:boolean=true):TField;
     property BiFiles:TStrings read fBiFiles;
     property Launcher:TObject read flauncher write setlauncher;
     property IncludeCount:integer read GetIncludeCount;
     property TypeCount:integer read GetTypeCount;
     property FileCount:integer read GetFileCount;
     property FieldCount:integer read GetFieldCount;
     property Include[index:integer]:string read GetInclude write SetInclude;
     property FileIn[index:integer]:string read GetFile write SetFile;
     property Typ[index:integer]:TType read GetType write SetType;
     property Field[index:integer]:TField read GetField write SetField;
     property isMultiplatform:boolean read fisMultiplatform;
   published
     property Types:TStrings read ftypes;
     property Classes:TStrings read fClasses;
     property Files:TStrings read fFiles;
     property Mask:string read fMask write setmask;
     property MainType:TType read fMainType write setMainType;
     property MainFile:string read fMainFile write setMainFile;
     property Dir:string read fDir write setdir;
     property MainTypeName:string read fmaintypename write setmaintypename;
     property FileName:string read ffilename write setfilename;
     property OnScan:TScannerEvent read fscan write fscan;
     property OnScanLine:TScanLineEvent read fscanline write fscanline;
   end;

   TProject=class(TStringList)
   private
     fDependiences:TStrings;
     fNode:TTreeNode;
     fTree:TTreeView;
     fCompiler:TCompiler;
     fPage:TObject;
     fFiles:TStrings;
     fName,fFileName:string;
     fSaved:boolean; fModalResult:integer;
     fNameChanged:TNotifyEvent;
     fCompilerFile,fSwitch,fResourcesFile:string;
     procedure SetName(v:string);
     procedure SetFileName(v:string);
     procedure SetSaved(v:boolean);
     procedure SetCompiler(v:TCompiler);
     procedure SetCompilerFile(v:string);
     procedure SetSwitch(v:string);
     procedure SetTree(v:TTreeView);
   public
     Icon,ExeExt,DefName,DefValue:string;
     Debug,DebugInfo,CompileOnly,PreserveO,AddGlobalDef,
     ErrorCheck,FBDebug,ResumeError,NullPtrCheck,ArrayCheck:boolean;
     constructor create;
     destructor destroy;override;
     function AddPage(v:string):string;overload;
     function AddPage(v:TTabSheet):string;overload;
     procedure Load(v:string='');
     procedure Save;
     procedure SaveAs;
     procedure Dispose;
     procedure BuildSource;
     procedure Read(display:boolean=true);
     function FindFile(v:string):TTabSheet;
     procedure UpdatePage(v,n:string);
     property Dependencies:TStrings read fDependiences;
     property Page:TObject read fPage write fPage;
     property Files:TStrings read fFiles;
     property ModalResult:integer read fModalResult;
     property Compiler:TCompiler read fCompiler write SetCompiler;
     property Node:TTreeNode read fNode write fNode;
   published
     property CompilerPath:string read fCompilerFile write setcompilerfile;
     property Switch:string read fSwitch write SetSwitch;
     property ResourcesFile:string read fResourcesfile write fresourcesfile;
     property Saved:boolean read fSaved write SetSaved;
     property Name:string read fName write SetName;
     property FileName:string read fFileName write SetFileName;
     property Tree:TTreeView read fTree write SetTree;
     property onNameChanged:TNotifyEvent read fNameChanged write fNameChanged;
   end;{}

   TResourceItem=class
   private
     fResources:TResources;
     fBuffer:TStrings;
     fName,fKind,fFileName:string;
     procedure SetFileName(v:string);
   protected
     procedure SetName(v:string);
   public
     constructor create;
     destructor destroy;override;
     property Resources:TResources read fResources write fResources;
     property Name:string read fname write setname;
     property Kind:string read fkind write fkind;
     property FileName:string read ffilename write setfilename;
     property Buffer:TStrings read fbuffer;
   end;

   TResources=class(TStringList)
   private
     fList:TListView;
     fItems, fPopupMenus, fMenus:TStrings;
     fFileName:string;
     procedure SetFileName(v:string);
     function GetItemCount:integer;
     function GetItem(index:integer):TResourceItem;
     procedure SetItem(index:integer;v:TResourceItem);
   public
    constructor create;
    destructor destroy;override;
    function ResourceExists(v:string):TResourceItem;
    function AddItem(v:string; index:integer=-1):TResourceItem;overload;
    procedure AddItem(v:TResourceItem; index:integer=-1);overload;
    procedure RemoveItem(v:string);
    procedure ClearItems;
    procedure ClearMenus;
    procedure ClearPopupMenus;
    procedure ClearAll;
    procedure Load;
    procedure Save;
    procedure Build;
    procedure Read;
    property PopupMenus:TStrings read fPopupMenus;
    property Menus:TStrings read fMenus;
    property List:TListView read fList write fList;
    property Items:TStrings read fItems;
    property FileName:string read ffilename write setfilename;
    property ItemCount:integer read GetItemCount;
    property Item[index:integer]:TResourceItem read GetItem write SetItem;
   end;

   function ResToStr(v:PChar):string;
   function StrToResStr(v:string):string;

   procedure BuildStyles;
   procedure BuildSpecificStyle(nc:string='');

   function ComputeStyle(v:string):uint; overload;
   function ComputeStyle(v:uint):string; overload;

var
   ProjectsList,StylesList:TStrings;
   NamesList:TNamesList;

implementation

uses CodeUnit, DialogUnit, LauncherUnit, PageSheetUnit, MainUnit, ScannerUnit,
     FreeBasicRTTI, MenuEditorUnit;

{ TAssignedEvent }
procedure TAssignedEvent.SetParams(v:string);
var
   L:TStrings;
   c,k:string;
   F:TField;
   i:integer;
begin
    fParams:=v;
    L:=TStringList.Create;
    L.Text:=StringReplace(v,',',#10,[rfreplaceall]);
    if L.Count>0 then
       for i:=0 to L.Count-1 do begin
           c:=trim(copy(L[i],1,pos(' as ',lowercase(L[i]))-1));
           k:=trim(copy(L[i],pos(' as ',lowercase(L[i]))+4,length(L[i])));
           F:=TField.create;
           F.Hosted:=c;
           F.Return:=k;
           fParamsList.AddObject(F.Hosted,F)
       end
end;

constructor TAssignedEvent.Create;
begin
    fParamsList:=TStringList.Create;
end;

destructor TAssignedEvent.Destroy;
begin
    fParamsList.Free;
    inherited
end;

{ TRegisterClasses }
constructor TClassRegPage.create;
begin
end;

destructor TClassRegPage.destroy;
begin
   inherited;
end;

{ TField }
constructor TField.create;
begin
   fFields:=TStringList.Create;
end;

destructor TField.destroy;
begin
   fFields.Free;
   inherited;
end;

function TField.GetFieldCount:integer;
begin
   result:=0;
   if self=nil then exit;
   if fFields<>nil then
      result:=fFields.Count
   else
      result:=0;
end;

function TField.GetField(i:integer):TField;
begin
   if (i>-1) and (i<FieldCount) then
      result:=TField(fFields.Objects[i])
   else
      result:=nil;
end;

function TField.FieldExists(v:string):TField;
var
   i:integer;
begin
    result:=nil;
    if v='' then exit;
    v:=trim(v);
    if self=nil then exit;
    for i:=0 to fFields.Count-1 do
        if (comparetext(v,TField(fFields.Objects[i]).Hosted)=0) or
           (comparetext(v,TField(fFields.Objects[i]).Alias)=0) then begin
           result:=TField(fFields.Objects[i]);
           break;
        end
end;

{ TType }
constructor TType.create;
begin
    inherited;
    fEnums:=TStringList.Create;
    Funions:=TStringList.Create;
    fSubs:=TStringList.Create;
    fFuncs:=TStringList.Create;
    fOperators:=TStringList.Create;
    fProperties:=TStringList.Create;
end;

destructor TType.destroy;
begin
    fEnums.Free;
    Funions.Free;
    fSubs.Free;
    fFuncs.Free;
    fOperators.Free;
    fProperties.Free;
    inherited;
end;

function TType.CstrExists(v:string):TField;
begin
    result:=FieldExists(v);
end;


{ TLibrary }
constructor TLibrary.create;
begin
   fFiles:=TStringList.Create;
   fTypes:=TStringList.Create;
   fClasses:=TStringList.Create;
   fFields:=TStringList.Create;
   fIncludes:=TStringList.Create;
   incFile:=TStringList.Create;
   fBiFiles:=TStringList.Create;
   fMask:='.bi';
end;

destructor TLibrary.destroy;
begin
   fFiles.Free;
   fTypes.Free;
   fClasses.Free;
   fFields.Free;
   fIncludes.Free;
   incFile.Free;
   fBiFiles.Free;
   inherited;
end;

procedure TLibrary.SetMask(v:string);
var
   o:string;
   Scanner:TScanner;
   i:integer;
begin
    o:=fMask;
    if o<>v then begin
       fMask:=v;
       Scanner:=TScanner.create;
       for i:=0 to fFiles.Count-1 do begin
           Scanner.LoadFromFile(fFiles[i]);
           Scanner.Scan;
           fTypes.AddStrings(Scanner.Types);
       end
    end
end;

procedure TLibrary.SetDir(v:string);
var
   i:integer;
   skiped,ifl:string;
   Scanner:TScanner;
begin
   fDir:=v;
   skiped:=changefileext(bridgefile,'.bi');
   if DirectoryExists(v) then begin
      //FindFiles(fFiles,v,fmask);
      FindFiles(fFiles,v,'.bi,.bas');
      if fFiles.Count>0 then begin
         for i:=0 to ffiles.Count-1 do begin
             ifl:=format('#include once "%s"',[ffiles[i]]);
             if comparetext(ExtractFileName(skiped),ExtractFileName(ffiles[i]))<>0 then
                incFile.Add(ifl);
             Scanner:=TScanner.create;
             Scanner.OnScan:=fScan;
             Scanner.OnScanLine:=fScanLine;
             Scanner.FileName:=fFiles[i];
             try
                Scanner.Scan;
             except end;

                fTypes.AddStrings(Scanner.Types);
                fClasses.AddStrings(Scanner.Classes);
                if fLauncher<>nil then
                   TLauncher(fLauncher).Classes.Assign(fClasses);

             fisMultiplatform:=Scanner.isMultiPlatform;
             Scanner.Free;
         end ;
      end;
      if incFile.Count>0 then
         incFile.SaveToFile(changefileext(bridgefile,'.bi'));
   end; 
end;

function TLibrary.GetFileCount:integer;
begin
   if fFiles<>nil then
      result:=fFiles.Count
   else
      result:=0
end;

function TLibrary.GetFile(i:integer):string;
begin
    if (i>-1) and (i<FileCount) then
       result:=fFiles[i]
    else
       result:='';
end;

procedure TLibrary.SetFile(i:integer;v:string);
begin
    if (i>-1) and (i<FileCount) then
       fFiles[i]:=v;
end;

function TLibrary.GetTypeCount:integer;
begin
    if fTypes<>nil then
      result:=fTypes.Count
   else
      result:=0
end;

function TLibrary.GetType(i:integer):TType;
begin
    if (i>-1) and (i<TypeCount) then
       result:=TType(fTypes.Objects[i])
    else
       result:=nil;
end;

procedure TLibrary.SetType(i:integer;v:TType);
begin
    if (i>-1) and (i<TypeCount) then
       fTypes.Objects[i]:=v;
end;

function TLibrary.GetFieldCount:integer;
begin
    if fFields<>nil then
      result:=fFields.Count
   else
      result:=0
end;

function TLibrary.GetField(i:integer):TField;
begin
    if (i>-1) and (i<FieldCount) then
       result:=TField(fFields.Objects[i])
    else
       result:=nil;
end;

procedure TLibrary.SetField(i:integer;v:TField);
begin
    if (i>-1) and (i<FieldCount) then
       fFields.Objects[i]:=v;
end;

function TLibrary.GetIncludeCount:integer;
begin
    if fIncludes<>nil then
      result:=fIncludes.Count
   else
      result:=0
end;

function TLibrary.GetInclude(i:integer):string;
begin
    if (i>-1) and (i<IncludeCount) then
       result:=fIncludes[i]
    else
       result:='';
end;

procedure TLibrary.SetInclude(i:integer;v:string);
begin
    if (i>-1) and (i<IncludeCount) then
        fIncludes[i]:=v;
end;

function TLibrary.IndexOfType(v:string):integer;
begin
    result:=fTypes.IndexOf(v)
end;

function TLibrary.IndexOfProperty(t,v:string;var ancestor:TType; all:boolean=true):integer;
var
   Tp:TType;
begin
    result:=-1;
    Tp:=TypExists(t);
    if Tp=nil then exit;
    if Tp<>nil then begin
    end
end;

function TLibrary.IndexOfField(v:string):integer;
begin
    result:=fFields.IndexOf(v)
end;

function TLibrary.IndexOfInclude(v:string):integer;
begin
    result:=fIncludes.IndexOf(v)
end;

function TLibrary.IndexOfFile(v:string):integer;
begin
    result:=fFiles.IndexOf(v)
end;

function TLibrary.TypExists(v:string):TType;
var

   i:integer;
begin
    result:=nil;
    if (v='') or (self=nil) then exit;
    for i:=0 to fTypes.Count-1 do
        if (comparetext(fTypes[i],v)=0) then begin
            result:=TType(ftypes.Objects[i]);
            break
        end
end;

function TLibrary.PropertyExists(t,v:string;all:boolean=true):TField;
var
   i:integer;
   Tp:TType;
   L:TStrings;
begin
    result:=nil;
    if (t='') or (v='') then exit;
    i:=indexOfType(t);
    if i>-1 then begin
       Tp:=Typ[i] ;
       if all=false then begin
          if Tp<>nil then begin
             i:=Tp.Fields.IndexOf(v);
             if i>-1 then
                result:=TField(Tp.Fields.Objects[i])
             else
                result:=nil
          end else result:=nil;      
       end else begin
           L:=TStringList.Create;
           RTTIGetFields(Tp.Name,L);
           i:=L.IndexOf(v);
           if i>-1 then
              result:=TField(L.Objects[i])
           else
              result:=nil;
       end
    end else
       result:=nil
end;

procedure TLibrary.SetMainTypeName(v:string);
var
   i:integer;
begin
    fMainTypeName:=v;
    if v<>'' then begin
       i:=ftypes.IndexOf(v); 
       if i>-1 then
          fMainType:=TType(ftypes.Objects[i]);
    end      
end;

procedure TLibrary.SetFileName(v:string);
begin
    ffilename:=v;
    if fileexists(v) then begin
    end
end;

procedure TLibrary.SetLauncher(v:TObject);
begin
    flauncher:=v;
    if v<>nil then begin
       TLauncher(v).Classes.Assign(fClasses);
    end
end;

procedure TLibrary.SetMainFile(v:string);
var
    L:TStrings;
    i:integer;
    s,f:string;
    Sc:TScanner;
    procedure ReadInc(ic:string);
    var
      i:integer;
      B:TStrings;
    begin
       B:=TStringList.Create;
       B.LoadFromFile(ic);
       i:=0;
       repeat
             s:=trim(B[i]);
             if pos('#include ',lowercase(s))>0 then begin
                f:=copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1);
                if FileExists(f) then L.Add(f);
             end;
             inc(i);
       until i>B.Count-1;
       B.Free;
    end;
begin
    fMainFile:=v;
    if FileExists(v) then begin
       L:=TStringList.Create;
       L.LoadFromFile(v);
       if L.Count=0 then exit;
       i:=0;
       repeat
             s:=trim(L[i]);
             if pos('#include ',lowercase(s))>0 then begin
                f:=copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1);
                if FileExists(f) then begin
                   L.Add(f);
                   ReadInc(f);
                end
             end;
             inc(i);
       until i>L.Count-1;
       {TLauncher(Launcher).Classes.Clear;
       TLauncher(Launcher).Types.Clear;
       for i:=0 to L.Count-1 do begin
           Sc:=TScanner.create;
           Sc.FileName:=L[i];
           Sc.Scan;
           //TLauncher(Launcher).Classes.AddStrings(Sc.Classes);
           ///TLauncher(Launcher).Types.AddStrings(Sc.Types);
           Sc.Free;
       end;}
       L.Free;
    end
end;

procedure TLibrary.SetMainType(v:TType);
begin
   fMainType:=v;
   if v<>nil then
      fMainTypeName:=v.Hosted;
end;


{ TProject }
constructor TProject.create;
begin
   fFiles:=TStringList.Create;
   ActiveProject:=self;
   ActiveObject:=ActiveProject;
   ProjectsList.AddObject(fName,self);
   fDependiences:=TStringList.Create;
end;

destructor TProject.destroy;
var
   i:integer;
begin
   if fPage<>nil then begin
      TPageSheet(fPage).Project:=nil;
      fPage:=nil;
   end;
   for i:=Code.PageControl.PageCount-1 downto 0 do
       if TPageSheet(Code.PageControl.Pages[i]).Project=self then
          TPageSheet(Code.PageControl.Pages[i]).Project:=nil;
   fFiles.Free;
   if ActiveProject=self then ActiveProject:=nil;
   if ActiveObject=self then ActiveObject:=nil;
   for i:=fDependiences.Count-1 downto 0 do

   inherited;
end;

procedure TProject.SetName(v:string);
var
    i:integer;
begin
    fName:=v;
    i:=ProjectsList.IndexOfObject(self);
    if i>-1 then ProjectsList[i]:=v;
    if fNode<>nil then fNode.Text:=fName; 
    if Assigned(fNameChanged) then
       fNameChanged(self);
end;

procedure TProject.SetFileName(v:string);
  function GetName:string;
  var
     i,x:integer;
     s:string;
  begin
     result:='';
     i:=pos('isproject',lowercase(Text));
     if i>0 then begin
        x:=posex(' ',Text,i+9);
        s:=copy(Text,i+9,x-(i+9));
        Name:=s;
     end ;
     result:=s;
  end;
begin
    fFileName:=v;
    if FileExists(v) then begin
       LoadFromFile(v);
       Name:=GetName; 
       if fPage<>nil then
          TPageSheet(fPage).Caption:=ExtractFileName(v)
       else begin
            fPage:=newEditor(v);
            TPageSheet(fPage).Project:=Self;
            end;
       if fNode<>nil then fNode.Text:=fName;
       Saved:=true ;
    end;
end;

procedure TProject.SetSaved(v:boolean);
begin
    fSaved:=v;
    if fPage<>nil then
       TPageSheet(fPage).Saved:=v;
end;

procedure TProject.SetCompiler(v:TCompiler);
begin
   fcompiler:=v;
   if v<>nil then begin
      fCompilerFile:=v.FileName;
      fSwitch:=v.Switch;
   end

end;

procedure TProject.SetCompilerFile(v:string);
begin
    fCompilerFile:=v;
    if FileExists(v) then begin
       if fCompiler<>nil then fCompiler.FileName:=v
    end else
       messageDlg(format('Can''t set %s compiler.',[v]),mtInformation,[mbok],0);
end;

procedure TProject.SetSwitch(v:string);
begin
   fSwitch:=v;
   if fCompiler<>nil then fCompiler.Switch:=v;
end;

procedure TProject.SetTree(v:TTreeView);
begin
    fTree:=v;
    if v<>nil then begin
       fNode:=v.Items.AddObject(nil,Name,self);
    end ;
end;

function TProject.FindFile(v:string):TTabSheet;
var
   i:integer;
begin
    result:=nil;
    if v='' then exit;
    for i:=0 to fFiles.Count-1 do begin
        if comparetext(fFiles[i],v)=0 then begin
           result:=TPageSheet(fFiles.Objects[i]);
           break
        end
    end
end;

function TProject.AddPage(v:TTabSheet):string;
var
  vt:TTabSheet;
  Ps:TPageSheet;
begin
    result:='';
    if v=nil then exit;
    vt:=FindFile(TPageSheet(v).FileName);
    if vt=nil then begin
       Ps:=TPageSheet(v);
       Ps.Project:=self;
       if fNode<>nil then
          if fTree<>nil then
             Ps.Node:=fTree.Items.AddChildObject(fNode,Ps.Name,Ps);
       fFiles.AddObject(Ps.FileName,Ps)
    end else
        Code.PageControl.ActivePage:=TPageSheet(vt);
end;

function TProject.AddPage(v:string):string;
var
  vt:TTabSheet;
  Ps:TPageSheet;
begin
    result:='';
    if v='' then exit;
    vt:=FindFile(v);
    if vt=nil then begin
       if fNode<>nil then
          if fTree<>nil then begin
             Ps:=newEditor(v);
             Ps.Project:=self;
             Ps.Node:=fTree.Items.AddChildObject(fNode,Ps.Caption,Ps);
          end;
       fFiles.AddObject(Ps.FileName,Ps)
    end
end;

procedure TProject.Load(v:string='');
begin
    if FileExists(v) then begin
       FileName:=v;
       Read;
    end
end;

procedure TProject.Read;
var
   i,x,y:integer;
   s,n,icf:string;
label
   skip;
begin
    if Count=0 then exit;
    i:=0;
    s:='';
    repeat
          s:=trim(self[i]);
         if pos('''',s)=1 then goto skip;
          if s='' then goto skip;
          if (pos('/''',s)>0) and (pos('''/',s)=0) then begin
             s:=copy(s,1,pos('/''',s)-1);
             repeat
                  if pos('''/',s)>0 then begin
                     inc(i);
                     s:=trim(self[i]);
                     break;
                  end;
                  s:=trim(self[i]);
                  inc(i);
             until (i>Count-1);
          end;  

          if pos('#define ',lowercase(s))>0 then begin
             y:=pos('isproject',lowercase(Text));
             if y>0 then begin
                x:=posex(' ',Text,y+9);
                s:=copy(Text,y+9,x-(y+9));
                Name:=s;
             end ;
             y:=pos('compyler',lowercase(Text));
             if y>0 then begin
                x:=posex(' ',Text,y+9);
                s:=copy(Text,y+9,x-(y+9));
                Compiler.FileName:=s;
             end ;
             y:=pos('swytch',lowercase(Text));
             if y>0 then begin
                x:=posex(' ',Text,y+6);
                s:=copy(Text,y+6,x-(y+6));
                Compiler.Switch:=s;
             end ;
             y:=pos('target',lowercase(Text));
             if y>0 then begin
                x:=posex(' ',Text,y+6);
                s:=copy(Text,y+6,x-(y+6));
                Compiler.Target:=s;
             end ;
          end;

          if pos('#include ',lowercase(self[i]))>0 then begin   
             icf:=copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1);
             if FileExists(icf) then
                AddPage( icf);
          end;
          skip:
          inc(i);
    until i>Count-1; 
end;

procedure TProject.BuildSource;
var
   i:integer;
   s:string;
begin
    if fPage<>nil then begin
       Assign(TPageSheet(fPage).Frame.Edit.Lines) ;
    end else
    with self do begin
         Clear;
         AddObject('/''',self);
         AddObject('   was builded with Kogaion(RqWork7)',self);
         AddObject('''/',self);
         AddObject('',self);
         AddObject(format('#define isProject%s true',[fName]),self);
         AddObject(format('#define %sCompiler "%s"',[fName,Launcher.Compiler.FileName]),self);
         if Launcher.Compiler.Switch<>'' then AddObject(format('#define %sSwitch %s',[Name,Launcher.Switch]),self);
         if Launcher.Compiler.Target<>'' then AddObject(format('#define %sTarget %s',[Name,Launcher.Compiler.Target]),self);
         AddObject('',self);
         if FileExists(Launcher.Lib.MainFile) then begin
            AddObject(format('#include once "%s"',[Launcher.Lib.MainFile]),Launcher.Lib);
            AddObject('',Launcher.Lib);
         end;
         AddObject('#if defined(module)=0',self);
         AddObject('    common shared as hmodule module',self);
         AddObject('#endif',self);
         Add('');
         if fFiles.Count>0 then begin   
         for i:=0 to fFiles.Count-1 do
             if fFiles.Objects[i]<>nil then begin
                if fFiles.Objects[i].InheritsFrom(TPageSheet) then begin
                   if not FileExists(TPageSheet(fFiles.Objects[i]).FileName) then
                      TPageSheet(fFiles.Objects[i]).SaveAs;
                   if TPageSheet(fFiles.Objects[i]).Dialog<>nil then
                      s:=format(' /''%s''/ #include once "%s"',[TPageSheet(fFiles.Objects[i]).Dialog.Name,TPageSheet(fFiles.Objects[i]).FileName])
                   else
                      s:=format('#include once "%s"',[TPageSheet(fFiles.Objects[i]).FileName]);
                   AddObject(s,fFiles.Objects[i]);
                   AddObject('',self);
                end;
             end else begin
                s:=format('#include once "%s"',[fFiles[i]]);
                AddObject(s,nil);
             end;
          end;
          if pos('application.run',lowercase(Text))=0 then
             AddObject('Application.Run',self); 
    end ;
end;

procedure TProject.Save;
begin
   if fPage=nil then
      BuildSource
   else
      Assign(TPageSheet(fPage).Frame.Edit.Lines);
   if FileExists(fFileName) then begin
      SaveToFile(fFileName);
      fSaved:=true;
      if Launcher.ResourcesEmbed then begin
         Resources.FileName:=changeFileExt(fFileName,'.rc');
         if (Resources.Items.Count>0) or
            (Resources.Menus.Count>0) or
            (Resources.PopupMenus.Count>0) then
            if Resources.FileName<>'' then Resources.Save;
      end
   end else SaveAs;
end;

procedure TProject.SaveAs;
begin
    with TSaveDialog.Create(nil) do begin
         Filter:='FreeBasic project file (*.bas)|*.bas|All files (*.*)|*.*';
         options:=options +[ofoverwriteprompt];
         FileName:=ffilename;
         if FileName='' then FileName:=fName;
         fmodalresult:=mrcancel;
         if execute then begin
            fModalResult:=mrok;
            case FilterIndex of
            1:fFileName:=ChangeFileExt(FileName,'.bas');
            2:fFileName:=FileName;
            end;
            if fPage=nil then
               BuildSource
            else
               Self.Assign(TPageSheet(fPage).Frame.Edit.Lines);
            SaveToFile(fFileName);
            fSaved:=true;
            if Launcher.ResourcesEmbed then begin
               Resources.FileName:=changeFileExt(fFileName,'.rc');
               if (Resources.Items.Count>0) or
                  (Resources.Menus.Count>0) or
                  (Resources.PopupMenus.Count>0) then
                  if Resources.FileName<>'' then Resources.Save;
            end
         end;
         Free
    end
end;

procedure TProject.Dispose;
var
   s:string;
   i:integer;
begin
    if self=nil then exit;
    s:=fFileName;
    if s='' then s:=fName;
    if not fSaved then
       case messageDlg(format('The %s project was modified.'#10'Do you want to save?',[s]),mtConfirmation,[mbyes,mbno,mbabort],0) of
       mryes: if FileExists(fFileName) then
                 Save
              else
                 SaveAs;
       mrabort:abort;
       end;
    if ActiveProject=self then ActiveProject:=nil;
    i:=ProjectsList.IndexOfObject(self);
    if i>-1 then ProjectsList.Delete(i);
    Free; 
end;

procedure TProject.UpdatePage(v,n:string);
var
  o:TSynSearchOptions;
begin
   o:=[ssoEntireScope,ssoReplaceAll];
   if fPage<>nil then begin
      TPageSheet(fPage).Frame.Edit.SearchReplace(v,n,o)
   end
end;

{ TResourceItem }
function StrToResStr(v:string):string;
var
   ext:string;
begin
    if not FileExists(v) then exit;
    ext:=ExtractFileExt(v);
    if comparetext(ext,'.bmp')=0 then
       result:='BITMAP'
    else if comparetext(ext,'.ico')=0 then
       result:='ICON'
    else if comparetext(ext,'.cur')=0 then
       result:='CURSOR'
    else if (comparetext(ext,'.html')=0) or (comparetext(ext,'.htm')=0) then
       result:='HTML'
    else if comparetext(ext,'.gif')=0 then
       result:='GIF'
    else if (comparetext(ext,'.jpg')=0) or (comparetext(ext,'.jpeg')=0) then
       result:='JPG'
    else if comparetext(ext,'.avi')=0 then
       result:='AVI'
    else if comparetext(ext,'.mp4')=0 then
       result:='MP4'
    else if comparetext(ext,'mp3')=0 then
       result:='.MP3'
    else if comparetext(ext,'.wav')=0 then
       result:='WAV'
    else if comparetext(ext,'.vxd')=0 then
       result:='VXD'
    else
       result:='RCDATA';
end;

function ResToStr(v:PChar):string;
begin
    result:='RCDATA';
    if v=rt_icon then
       result:='ICON'
    else if v=rt_bitmap then
       result:='BITMAP'
    else if v=rt_cursor then
       result:='CURSOR'
    else if v=MAKEINTRESOURCE(23) then
       result:='HTML'
    else if v=rt_VXD then
       result:='VXD'
    else if v=rt_version then
       result:='16'
    else if v=MAKEINTRESOURCE(24) then
       result:='24'
end;

constructor TResourceItem.create;
begin
   fBuffer:=TStringList.Create;
   
end;

destructor TResourceItem.destroy;
begin
   fBuffer.Free;
   inherited;
end;

procedure TResourceItem.SetFileName(v:string);
var
   i:integer;
begin
    ffilename:=v;
    if FileExists(v) then begin
       fBuffer.LoadFromFile(v);
       fName:=ChangeFileExt(ExtractFileName(v),'');
       fkind:=StrToResStr(v);
    end
end;

procedure TResourceItem.SetName(v:string);
var
   i:integer;
begin
    fName:=v;
    if fResources<>nil then begin
       i:=fResources.Items.IndexOfObject(self);
       if i>-1 then fResources.Item[i].Name:=fName;
       if fResources.List<>nil then begin
          fResources.List.Items[i].Caption:=fName;
       end
    end
end;

{ TResources }
constructor TResources.create;
begin
   fItems:=TStringList.Create;
   fPopupMenus:=TStringList.Create;
   fMenus:=TStringList.Create;
end;

destructor TResources.destroy;
begin
   fItems.Free;
   fPopupMenus.Free;
   fMenus.Free;
   inherited;
end;

procedure TResources.SetFileName(v:string);
begin
   ffilename:=v;
   Load;
end;

function TResources.GetItemCount:integer;
begin
   result:=fItems.count;
end;

function TResources.GetItem(index:integer):TResourceItem;
begin
    if (index>-1) and (index<fItems.Count) then
       result:=TResourceItem(fItems.Objects[index])
    else
       result:=nil;
end;

procedure TResources.SetItem(index:integer;v:TResourceItem);
begin
    if (index>-1) and (index<fItems.Count) then
       fItems.Objects[index]:=v
end;

procedure TResources.Read;
var
   i:integer;
begin
   i:=0;
   repeat
         inc(i);
   until i>Count-1;
end;

procedure TResources.Load;
var
   i,needEnd:integer;
   s,ident,kind:string;
   L:TStrings;
label
   return;
begin
   if self=nil then exit;
   if FileExists(fFileName) then begin
      LoadFromFile(fFileName);
      if Count=0 then exit;
      i:=0; needEnd:=0;
      repeat
            return:
            s:=trim(self[i]);
            if pos('//',s)=1 then begin inc(i); goto return; end;
            if pos('//',s)>0 then s:=copy(s,1,pos('//',s)-1);
            if pos(' ',s)>0 then begin
               ident:=copy(s,1,pos(' ',s)-1);
               kind:=trim(copy(s,pos(' ',s)+1,length(s))); 
            end else begin
               ident:=s;
               Kind:='';
            end;

                  if compareText(ident,'begin')=0 then begin
                     inc(needend);
                     if L<>nil then L.Add(self[i]);
                  end;
                  
                  if (compareText(kind,'menu')=0) or (compareText(kind,'menuex')=0) then begin
                     L:=fMenus;
                     if L<>nil then L.Add(self[i]);
                  end;

                  if (compareText(ident,'popup')=0) then begin
                     if L<>nil then L.Add(self[i]);
                  end;

                  if (compareText(ident,'menuitem')=0) then begin
                     if L<>nil then L.Add(self[i]);
                  end;

                  if compareText(ident,'end')=0 then begin
                     fMenus.Add(self[i]);
                     dec(needEnd);
                  end;


            inc(i);
      until i>Count-1;
      if needEnd=0 then
         if ActiveDialog<>nil then
            if Resources.Menus.Count>0 then
               ActiveDialog.BuildMenu;
   end;
end;

procedure TResources.Save;
begin
    if (fItems.Count>0) or
       (fMenus.Count>0) or
       (fPopupMenus.Count>0) then begin
       Build;
       if ffilename<>'' then
          SaveToFile(fFileName)
       else
          messageDlg('Can''t save resource file.',mtInformation,[mbok],0)   ;
    end
end;

procedure TResources.Build;
var
   i:integer;
   Ri:TResourceItem;
   s:string;
begin
   Clear;
   for i:=0 to fItems.Count-1 do begin
       Ri:=TResourceItem(fItems.Objects[i]);
       s:=format('%s %s "%s"',[Ri.Name,Ri.Kind,Ri.FileName]);
       AddObject(s,Ri);
   end ;
   Add('');
   AddStrings(fMenus);
   Add('');
   AddStrings(fPopupMenus); 
end;

function TResources.ResourceExists(v:string):TResourceItem;
var
  i:integer;
  s:string;
  Ri:TResourceItem;
begin
    result:=nil;
    if v='' then exit;
    if FileExists(v) then
       s:=ChangeFileExt(ExtractFileName(v),'')
    else
       s:=v;
    for i:=0 to fItems.Count-1 do begin
        Ri:=TResourceItem(fItems.Objects[i]);
        if Ri<>nil then
           if comparetext(Ri.Name,s)=0 then begin
              result:=TResourceItem(fItems.Objects[i]);
              break
           end
    end
end;

function TResources.AddItem(v:string; index:integer=-1):TResourceItem;
begin
   if ResourceExists(v)=nil then begin
      result:=TResourceItem.Create;
      result.FileName:=v;
      if index=-1 then fitems.AddObject(result.Name,result) else fitems.InsertObject(index,result.Name,result) ;
   end else messageDlg(format('Resource file %s not exists.',[v]),mtInformation,[mbok],0);
end;

procedure TResources.AddItem(v:TResourceItem; index:integer=-1);
begin
   if v=nil then begin
      messageDlg(format('Resource file %s not exists.',[v]),mtInformation,[mbok],0);
      exit;
   end;
   if ResourceExists(v.Name)=nil then
      if index=-1 then fitems.AddObject(v.Name,v) else fitems.InsertObject(index,v.Name,v)
   else
      messageDlg(format('Resource %s exists.',[v]),mtInformation,[mbok],0);
end;

procedure TResources.RemoveItem(v:string);
var
   Ri:TResourceItem;
   i:integer;
begin
    Ri:=ResourceExists(v);
    if Ri<>nil then begin
       i:=fItems.IndexOfObject(Ri);
       if i>-1 then begin
          fItems.Delete(i);
          Ri.Free
       end;
    end
end;

procedure TResources.ClearItems;
var
  i:integer;
begin
   for i:=fItems.Count-1 downto 0 do
       TResourceItem(fItems.Objects[i]).Free;
   fitems.Clear;
   inherited;
end;

procedure TResources.ClearMenus;
var
  i:integer;
begin
   for i:=fMenus.Count-1 downto 0 do
       if fMenus.Objects[i]<>nil then
          fMenus.Objects[i].Free;
   fMenus.Clear;
end;

procedure TResources.ClearPopupMenus;
var
  i:integer;
begin
   for i:=fPopupMenus.Count-1 downto 0 do
       if fPopupMenus.Objects[i]<>nil then
          fPopupMenus.Objects[i].Free;
   fPopupMenus.Clear;
end;

procedure TResources.ClearAll;
begin
   Clear;
   ClearItems;
   ClearMenus;
   ClearPopupMenus;
end;

{ TLanguage }
constructor TLanguage.Create;
begin
    inherited Create;
    fMessages:=TStringList.Create;
end;

destructor TLanguage.Destroy;
begin
    fMessages.Free;
end;

procedure TLanguage.SetLanguage;
var
   L,B:TStrings;
   i,j:integer;
   c,o:TComponent;
   p,s,v:string;
begin
    L:=TStringList.Create;
    B:=TStringList.Create;
    if FileExists(fFileName) then
       with TIniFile.Create(fFileName) do begin
            ReadSections(L);
            for i:=0 to L.Count-1 do begin
                ReadSectionValues(L[i],B);
                c:=Application.FindComponent(L[i]);
                if c<>nil then
                   for j:=0 to B.Count-1 do begin
                       p:=copy(B[j],1,pos('=',B[j])-1);
                       v:=copy(B[j],pos('=',B[j])+1,length(B[j]));
                       if pos('.',p)>0 then begin
                          s:=copy(p,pos('.',p)+1,length(p));
                          p:=copy(p,1,pos('.',p)-1);
                          o:=c.FindComponent(p);
                          if o<>nil then
                             if GetPropInfo(o,s)<>nil then
                                SetPropValue(o,s,v);
                       end else begin
                       o:=c;
                       if o<>nil then
                          if GetPropInfo(o,p)<>nil then
                             SetPropValue(o,p,v);
                       end
                   end
            end
       end;
    L.Free;
    B.Free;
end;

{ TNewItem }
constructor TNewItem.Create;
begin
   inherited;
   fCode :=TStringList.Create;
end;

destructor TNewItem.Destroy;
begin
    fCode.Free;
    inherited;
end;

procedure TNewItem.SetName(const v :string);
begin
   fName:=v;
   if Owner<>nil then
      Owner.Caption := v;
end;

procedure TNewItem.SetCodeFile(v :string);
begin
   fCodeFile:=v;
   if FileExists(v) then begin
      fCodeFile := ExtractFilePath(ParamStr(0))+'newitems\'+ExtractFileName(v);
      CopyFile(PChar(v),PChar(fCodeFile),true);
      fCode.LoadFromFile(fCodeFile);
   end;   
end;

{ TNamesList }
function TNamesList.AddName(v:string):string;
var
   i,j,vl,e:integer;
   s,n,t:string;
begin
    result:='';
    if v='' then exit;
    for i:=0 to Count-1 do begin
        s:='';
        n:='';
        t:=self[i];
        for j:=1 to length(t) do
            if t[j] in ['a'..'z','A'..'Z','_'] then
               s:=s+t[j]
            else
               if t[j] in ['0'..'9'] then
                  n:=n+t[j];
        if comparetext(s,v)=0 then begin
           val(n,vl,e);
           if e=0 then inc(vl);
           result:=format('%s%d',[s,vl]);
           self[i]:=result;
           exit
        end
    end ;
    result:=format('%s%d',[v,1]); 
    Add(result);
end;

procedure TNamesList.RemoveName(v:string);
var
   i:integer;
begin  
    i:=indexof(v);
    if i>-1 then Delete(i)
end;

function TNamesList.NameExists(v:string):integer;
begin
    result:=indexof(v);
end;

{ Globals }
procedure BuildStyles;
var
   fWindowStyle:TWindowStyle;
begin
    if StylesList=nil then exit;
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_OVERLAPPED';
    fWindowStyle.Value := WS_OVERLAPPED ;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_POPUP';
    fWindowStyle.Value := WS_POPUP ;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_CHILD';
    fWindowStyle.Value := WS_CHILD ;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_MINIMIZE';
    fWindowStyle.Value := WS_MINIMIZE ;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_VISIBLE';
    fWindowStyle.Value := WS_VISIBLE ;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_DISABLED';
    fWindowStyle.Value := WS_DISABLED;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_CLIPSIBLINGS';
    fWindowStyle.Value := WS_CLIPSIBLINGS;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_CLIPCHILDREN';
    fWindowStyle.Value := WS_CLIPCHILDREN;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_MAXIMIZE';
    fWindowStyle.Value := WS_MAXIMIZE;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_CAPTION';
    fWindowStyle.Value := WS_CAPTION;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_BORDER';
    fWindowStyle.Value := WS_BORDER;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_DLGFRAME';
    fWindowStyle.Value := WS_DLGFRAME;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_VSCROLL';
    fWindowStyle.Value := WS_VSCROLL;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_HSCROLL';
    fWindowStyle.Value := WS_HSCROLL;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_SYSMENU';
    fWindowStyle.Value := WS_SYSMENU;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_THICKFRAME';
    fWindowStyle.Value := WS_THICKFRAME;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_GROUP';
    fWindowStyle.Value := WS_GROUP;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_TABSTOP';
    fWindowStyle.Value := WS_TABSTOP;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_MINIMIZEBOX';
    fWindowStyle.Value := WS_MINIMIZEBOX;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_MAXIMIZEBOX';
    fWindowStyle.Value := WS_MAXIMIZEBOX;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_TILED';
    fWindowStyle.Value := WS_TILED;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_ICONIC';
    fWindowStyle.Value := WS_ICONIC;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_SIZEBOX';
    fWindowStyle.Value := WS_SIZEBOX;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_OVERLAPPEDWINDOW';
    fWindowStyle.Value := WS_OVERLAPPEDWINDOW;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_TILEDWINDOW';
    fWindowStyle.Value := WS_TILEDWINDOW;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_POPUPWINDOW';
    fWindowStyle.Value := WS_POPUPWINDOW;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
    fWindowStyle := TWindowStyle.Create;
    fWindowStyle.Name := 'WS_CHILDWINDOW';
    fWindowStyle.Value := WS_CHILDWINDOW;
    StylesList.AddObject(fWindowStyle.Name, fWindowStyle);
end;

procedure BuildSpecificStyle(nc:string='');
var
   L,BF :TStrings;
   i,j :integer;
   S,V :string;
   St :TWindowStyle;
   Vl, E :integer;
begin
    if StylesList=nil then  exit;
    for i:=StylesList.Count-1 downto 0 do
         StylesList.Objects[i].Free;
    StylesList.Clear;
    L:= TStringList.Create;
    BF:= TStringList.Create;
    if not FileExists(IDEDir + 'styles.ini') then exit;
    with TIniFile.Create(IDEDir + 'styles.ini') do begin 
         if nc<>'' then begin
            ReadSectionValues(nc, L);
            for i := 0 to L.Count-1 do begin
                s := Trim(Copy(L[i],Pos('const',LowerCase(L[i]))+6,Length(L[i])));
                s := Trim(Copy(s,1,Pos('=',s)-1));
                v := Trim(Copy(L[i],Pos('=',L[i])+1,Length(L[i])));
                Val(V, Vl, E);
                if E = 0 then
                   if StylesList.IndexOf(s)=-1 then begin
                      St := TWindowStyle.Create;
                      St.Value := Vl;
                      St.strValue:=v;
                      St.Name := s;
                      StylesList.AddObject(s, St);
                   end;
             end;
         end else begin
             ReadSections(BF);
             for j:=0 to BF.Count-1 do begin
                 ReadSectionValues(BF[j], L);
                 for i:=0 to L.Count-1 do begin
                     s:=Trim(Copy(L[i],Pos('const',LowerCase(L[i]))+6,Length(L[i])));
                     v:=Trim(Copy(s,Pos('=',s)+1,Length(s)));
                     s:=Trim(Copy(s,1,Pos('=',s)-1));
                     Val(V, Vl, E);
                     if E=0 then
                        if StylesList.IndexOf(s)=-1 then begin
                           St:=TWindowStyle.Create;
                           St.Value:=Vl;
                           St.strValue:=v;
                           St.Name:=s;
                           StylesList.AddObject(s, St);
                        end
                 end;
              end
         end;
         Free;
    end;
    L.Free;
    BF.Free;
end;

function ComputeStyle(v:string):uint;
var
   i,j:integer;
   s:TStrings;
   ws:TWindowStyle;
begin
    result:=0;
    if v='' then exit;
    BuildStyles;
    BuildSpecificStyle; 
    s:=TStringList.Create;
    if (pos(' or ',lowercase(v))>0) or (pos('|',lowercase(v))>0) then begin
       s.Text:=trim(StringReplace(v,' or ',#10,[rfReplaceAll]));
       for j:=0 to s.Count-1 do begin
           for i:=0 to StylesList.Count-1 do begin
               Ws:=TWindowStyle(StylesList.Objects[i]);
               if ws<>nil then
               if CompareText(trim(Ws.Name),trim(s[j]))=0 then begin
                 if result and Ws.Value = 0 then
                    result:=result or Ws.Value; 
               end
           end
       end ;
    end
end;

function ComputeStyle(v:uint):string;
var
   i:integer;
   ws:TWindowStyle;
begin
    result:='';
    if v=0 then exit;
    for i:=0 to StylesList.Count-1 do begin
        Ws:=TWindowStyle(StylesList.Objects[i]);
        if ws.value and v=ws.value then
           if result='' then
              result:=result +ws.name
          else
              result:=result+' or '+ws.name;
    end ;
end;


initialization
   NamesList:=TNamesList.Create;
   ProjectsList:=TStringList.Create;
   StylesList:=TStringList.Create;
   BuildStyles;
   BuildSpecificStyle;
finalization
   NamesList.Free;
   ProjectsList.Free;
   StylesList.Free;
end.
