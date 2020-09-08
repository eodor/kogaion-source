unit HelperUnit;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls, ComCtrls, ShellApi, psAPI, WinInet, Tlhelp32, registry,
   shlobj, axCtrls, ActiveX, ImageHlp, Mapi, Winsock, TypInfo, Clipbrd, jpeg;


type

  TTypeLib=class
     Win32, FileName, Name :string;
     GUID :TGUID;
  end;
  TFindWindowRec=record
     ModuleToFind :string;
     FoundHWnd :hwnd;
  end;
  PRegistryEntryStruct=^TRegistryEntryStruct;
  TRegistryEntryStruct=record
     Name,Server,TypName,DisplayName,Info:string;
  end;
  FLASHWINFO = record
    cbSize: UINT;
    hWnd: HWND;
    dwFlags: DWORD;
    uCount: UINT;
    dwTimeOut: DWORD;
  end;
  TFlashWInfo = FLASHWINFO;
  PComPort=^TComPort;
  TComPort = record
  ID:integer;
  Name:string;
  Info:Pointer;
  end;
  TComPorts=array of TComport;
  
  PHICON = ^HICON;

  PIMAGE_NT_HEADERS = ^IMAGE_NT_HEADERS;
  PIMAGE_EXPORT_DIRECTORY = ^IMAGE_EXPORT_DIRECTORY;

  TSearchEvent = procedure(var FileName :string);
  TSearchInFileEvent = function (var AFile :string) :integer of object;stdcall;

  TBorder = (bsNone, bsDialog, bsSingle, bsSizeable, bsSizeToolWindow, bsToolWindow);

  TCliping=(clChild,clSiblings);

  TStyle=(stNormal,stStayOnTop);

  TPoints=array of TPoint;
  
  TDllRegisterServer = function: HResult; stdcall;

  procedure FindFilesEx(FilesList: TStrings; StartDir, FileMask: string);
  procedure FindFiles(FilesList: TStrings; StartDir, FileMask: string);
  function GetCPUSpeed: Double;
  function GetCPUVendor: string;
  function GetCurrentUserName: string;
  function GetMemory :string;
  procedure GetOSVersion(var APlatform: string ; var AMajorVersion,AMinorVersion,ABuild: DWORD);
  function GetProcessMemorySize(_sProcessName: string; var _nMemSize: Cardinal): Boolean;
  function IsAdmin: Boolean;
  procedure ListDLLExports(const FileName: string; List: TStrings; complete:boolean=false);
  function GetClassName(Handle: THandle): String;
  function IsFileTypeRegistered(ProgId :string): boolean;
  function RegisterFileTypeCommand(fileExtension, menuItemText, target: string) : boolean;
  function UnRegisterFileTypeCommand(fileExtension, menuItemText: string) : boolean;
  procedure ImageLoad(AFile :string; Image :TImage);
  procedure ListFileDir(Path: string; Proc :TSearchInFileEvent; Filter :string='*.*');overload;
  procedure ListFileDir(Path: string; FileList: TStrings; Filter :string='*.*'); overload;
  procedure ListFileInDir(const AStartDir : string; AList :TStrings;  Filter :string = '*.*'; ARecurse :boolean = true);
  function BrowseForFolder(var Foldr: string; Title:string): Boolean;
  function GetFileNameFromOLEClass(const OLEClassName: string): string;
  function GetWin32TypeLibList(Lines: TStrings): Boolean;
  function GetSpecialDir(v:string):string;
  function GetSpecialFolderPath(CSIDLFolder: Integer): string;
  procedure Bmp2Jpeg(const BmpFileName, JpgFileName: string); // helloacm.com
  procedure Jpeg2Bmp(const BmpFileName, JpgFileName: string); // helloacm.com
  function GetCapture(Image :TImage; fDlg :TForm=nil; Jpg :boolean = false):string;

  function SearchTree(const AStartDir, AFileToFind : string; ARecurse :boolean = true) : string;
  procedure ExtractResourceIDToFile(Instance:THandle; ResID:Integer; ResType, FileName:String; Overriden :boolean = true);
  procedure ExtractResourceNameToFile(Instance:THandle; ResName, ResType, FileName:String; Overriden :boolean = true);
  procedure ExtractResource(Module :HMODULE; ResName, ResType, ResFile :string);
  procedure LoadResourceName(instance :HMODULe; ResName, ResFile, ResType :string; ALines :TStrings);

  procedure  GetPropertyList(value :TObject; Results :TStrings);

  procedure DUI2PIX(FWindow :hwnd; var P :TPoint);
  procedure PIX2DUI(FWindow :hwnd; var P :TPoint) ;

  procedure Win2DUI(Dlg :integer; var lx, ly, cx, cy :integer);
  procedure DUI2Win(Dlg :integer; var lx, ly, cx, cy :integer);

  function twips2pix(v :integer):integer;
  function pix2twips(v :integer):integer;

  function CurrentProcessMemory: Cardinal;

  function ReplaceString(s, swhat, swith :string; all :boolean=true):string;

  function ClassExists(v :string):boolean;

  function tally(s,v :string):integer;

  function IsWindowOpen(v:string): Boolean;
  function IsWindowHandleOpen(v:string): hwnd;

  function NormalizeName(value :string) :string;

  function GetFilterByIndex(id:integer;filter:string):string;

  function GetWindowsFromThread(ti:cardinal;var L:TStrings):integer;
  procedure LoadImage(v:string; img:TImage);
  function ExecuteProcess(FileName: string; Visibility: Integer; BitMask: Integer; Synch: Boolean): Longword;
  function LastInput: DWord;
  procedure EnumExtensions(Lines:TStrings);
  function SetGlobalEnvironment(const Name, Value: string; const User: Boolean = True): Boolean;

  function FlashWindowEx(var pfwi: FLASHWINFO): BOOL; stdcall;
  procedure FlashsWindow(dlg:hwnd;longflash:integer=5);

  procedure ExtractIcons(limg:TImage=nil;simg:TImage=nil);
  procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);

  function ComPortAvailable(Port: PChar): Boolean;
  function GetOpenComPort(searchfor:integer=30):tcomports;

  procedure RegisterFileType(ext: string; exe: string);
  function GetSerialPortNames: string;

  procedure  EnumComPorts(const   Ports:  TStringList);

  function GetUserName: String;
  function ComputerName:String;

const
    RT_HTML = MAKEINTRESOURCE(23);
    RT_MANIFEST = MAKEINTRESOURCE(24);
    SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =  (Value: (0, 0, 0, 0, 0, 5));
    SECURITY_BUILTIN_DOMAIN_RID = $00000020;
    DOMAIN_ALIAS_RID_ADMINS = $00000220;
    FLASHW_STOP = 0;
    FLASHW_CAPTION = 1;
    FLASHW_TRAY = 2;
    FLASHW_ALL = FLASHW_CAPTION or FLASHW_TRAY;
    FLASHW_TIMER = 4;
    FLASHW_TIMERNOFG = 12;

  CSIDL_DESKTOP                   = $0000; { <desktop> }
  CSIDL_INTERNET                  = $0001; { Internet Explorer (icon on desktop) }
  CSIDL_PROGRAMS                = $0002; { Start Menu\Programs }
  CSIDL_CONTROLS                 = $0003; { My Computer\Control Panel }
  CSIDL_PRINTERS                  = $0004; { My Computer\Printers }
  CSIDL_PERSONAL                 = $0005; { My Documents.  This is equivalent to 
                                                                       CSIDL_MYDOCUMENTS in XP and above }
  CSIDL_FAVORITES                 = $0006; { <user name>\Favorites }
  CSIDL_STARTUP                    = $0007; { Start Menu\Programs\Startup }
  CSIDL_RECENT                      = $0008; { <user name>\Recent }
  CSIDL_SENDTO                     = $0009; { <user name>\SendTo }
  CSIDL_BITBUCKET                 = $000a; { <desktop>\Recycle Bin }
  CSIDL_STARTMENU                = $000b; { <user name>\Start Menu }
  CSIDL_MYDOCUMENTS           = $000c; { logical "My Documents" desktop icon }
  CSIDL_MYMUSIC                    = $000d; { "My Music" folder }
  CSIDL_MYVIDEO                    = $000e; { "My Video" folder }
  CSIDL_DESKTOPDIRECTORY   = $0010; { <user name>\Desktop }
  CSIDL_DRIVES                       = $0011; { My Computer }
  CSIDL_NETWORK                   = $0012; { Network Neighborhood (My Network Places) }
  CSIDL_NETHOOD                   = $0013; { <user name>\nethood }
  CSIDL_FONTS                        = $0014; { windows\fonts }
  CSIDL_TEMPLATES                 = $0015; { <user name>\appdata\roaming\template folder }
  CSIDL_COMMON_STARTMENU = $0016; { All Users\Start Menu }
  CSIDL_COMMON_PROGRAMS  = $0017; { All Users\Start Menu\Programs }
  CSIDL_COMMON_STARTUP     = $0018; { All Users\Startup }
  CSIDL_COMMON_DESKTOPDIRECTORY  = $0019; { All Users\Desktop }
  CSIDL_APPDATA                    = $001a; { <user name>\Application Data }
  CSIDL_PRINTHOOD                = $001b; { <user name>\PrintHood }
  CSIDL_LOCAL_APPDATA         = $001c; { <user name>\Local Settings\Application Data 
                                                                                (non roaming) }
  CSIDL_ALTSTARTUP               = $001d; { non localized startup }
  CSIDL_COMMON_ALTSTARTUP= $001e; { non localized common startup }
  CSIDL_COMMON_FAVORITES  = $001f; { User favourites }
  CSIDL_INTERNET_CACHE       = $0020; { temporary inter files }
  CSIDL_COOKIES                    = $0021; { <user name>\Local Settings\Application Data\
                                                                    ..\cookies }
  CSIDL_HISTORY                    = $0022; { <user name>\Local Settings\
                                                                       Application Data\..\history}
  CSIDL_COMMON_APPDATA     = $0023; { All Users\Application Data }
  CSIDL_WINDOWS                  = $0024; { GetWindowsDirectory() }
  CSIDL_SYSTEM                      = $0025; { GetSystemDirectory() }
  CSIDL_PROGRAM_FILES         = $0026; { C:\Program Files }
  CSIDL_MYPICTURES               = $0027; { C:\Program Files\My Pictures }
  CSIDL_PROFILE                      = $0028; { USERPROFILE }
  CSIDL_SYSTEMX86                 = $0029; { x86 system directory on RISC }
  CSIDL_PROGRAM_FILESX86    = $002a; { x86 C:\Program Files on RISC }
  CSIDL_PROGRAM_FILES_COMMON   = $002b; { C:\Program Files\Common }
  CSIDL_PROGRAM_FILES_COMMONX86 = $002c; { x86 C:\Program Files\Common on RISC }
  CSIDL_COMMON_TEMPLATES              = $002d; { All Users\Templates }
  CSIDL_COMMON_DOCUMENTS            = $002e; { All Users\Documents }
  CSIDL_COMMON_ADMINTOOLS           = $002f; { All Users\Start Menu\Programs\
                                                                            Administrative Tools }
  CSIDL_ADMINTOOLS                          = $0030; { <user name>\Start Menu\Programs\
                                                                              Administrative Tools }
  CSIDL_CONNECTIONS                        = $0031; { Network and Dial-up Connections }
  CSIDL_COMMON_MUSIC                     = $0035; { All Users\My Music }
  CSIDL_COMMON_PICTURES                = $0036; { All Users\My Pictures }
  CSIDL_COMMON_VIDEO                     = $0037; { All Users\My Video }
  CSIDL_RESOURCES                            = $0038; { Resource Directory }
  CSIDL_RESOURCES_LOCALIZED          = $0039; { Localized Resource Directory }
  CSIDL_CDBURN_AREA                        = $003b; { USERPROFILE\Local Settings\
                                                                       Application Data\Microsoft\CD Burning }
  CS_DROPSHADOW = $00020000;

function SHGetFolderPath(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWORD; pszPath: PChar): HResult; stdcall; external 'shfolder.dll' name 'SHGetFolderPathA';

var
  FindWindowRec: TFindWindowRec;
  FWInfo: TFlashWInfo;
  PLargeIcon, PSmallIcon: phicon;

implementation

function FlashWindowEx; external user32 Name 'FlashWindowEx';

function getUserName: String;
const
  UNLEN = 256;
var
  BufSize: DWord;
  Buffer: array[0..UNLEN] of Char;
begin
  BufSize := Length(Buffer);
  if Windows.GetUserName(Buffer, BufSize) then
    SetString(Result, Buffer, BufSize-1)
  else
    RaiseLastOSError;
end;

procedure FlashsWindow(dlg:hwnd;longflash:integer=5);
begin
    with FWInfo do begin
      cbSize    := SizeOf(FWInfo);
      hWnd      := dlg;
      dwFlags   := FLASHW_ALL;
      uCount    := longflash;
      dwTimeOut := 100;
    end;
    FlashWindowEx(FWInfo)
end;

procedure LoadImage(v:string; img:TImage);
var
  OleGraphic: TOleGraphic;
  fs: TFileStream;
begin
  if not FileExists(v) then exit;
  if img=nil then exit;
  OleGraphic:= TOleGraphic.Create;
  fs:= TFileStream.Create(v, fmOpenRead or fmSharedenyNone);
  try
    OleGraphic.LoadFromStream(fs);
    img.Picture.Assign(OleGraphic);
  finally
    fs.Free;
    OleGraphic.Free
  end;
end;

function EnumThreadWndProc(dlg,lparam :integer):boolean;stdcall;
begin
    if lparam>0 then
       TStrings(lparam).AddObject(GetClassName(dlg),TObject(Dlg));
    result:=true;
end;

function GetWindowsFromThread(ti:cardinal;var L:TStrings):integer;
begin
    if ti=0 then ti:=GetCurrentThreadId;
    EnumThreadWindows(ti,@EnumThreadWndProc,integer(L));
    result:=L.Count;
end;

function GetFilterByIndex(id:integer;filter:string):string;
var
   i,x,y :integer;
   s :string;
begin
    result:=filter;
    if id=0 then exit;
    if filter='' then begin result:=filter; exit; end; x:=0; y:=0;
    for i:=1 to length(filter) do begin
        s :=s+filter[i];
        if (filter[i]='|') or (i=length(filter)) then begin
            inc(x);
            if x=2 then begin
               inc(y);
               if i<length(filter) then s:=copy(s,1,length(s)-1);
               if y=id then
                  if pos('*.*',s)=0 then result:=s else result:='';
               x:=0;
               s:='';
            end;
        end;
    end;
end;

function NormalizeName(value :string) :string;
var
       i :integer;
       s :string;
begin
    result:=value;
    if value='' then exit;
    s:='';
    for i:=1 to length(value) do begin
        if value[i]in ['a'..'z','A'..'Z','0'..'9','-','_'] then s :=s + value[i];
    Result:=s;
    end;
 end;

function EnumWindowsCallBack(Handle: hWnd; var FindWindowRec: TFindWindowRec): BOOL; stdcall;
const
  C_FileNameLength = 256;
var
  WinFileName: string;
  PID, hProcess: DWORD;
  Len: Byte;
begin
  Result := True;
  SetLength(WinFileName, C_FileNameLength);
  GetWindowThreadProcessId(Handle, PID);
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  Len := GetModuleFileNameEx(hProcess, 0, PChar(WinFileName), C_FileNameLength);
  if Len > 0 then
  begin
    SetLength(WinFileName, Len);
    if SameText(WinFileName, FindWindowRec.ModuleToFind) then
    begin
      Result := False;
      FindWindowRec.FoundHWnd := Handle;
    end;
  end;
end;

function IsWindowOpen(v:string): Boolean;
begin
  FindWindowRec.ModuleToFind := v;
  FindWindowRec.FoundHWnd := 0;
  EnumWindows(@EnumWindowsCallback, integer(@FindWindowRec));
  Result := FindWindowRec.FoundHWnd <> 0;
end;

function IsWindowHandleOpen(v:string): hwnd;
begin
  FindWindowRec.ModuleToFind := v;
  FindWindowRec.FoundHWnd := 0;
  EnumWindows(@EnumWindowsCallback, integer(@FindWindowRec));
  Result := FindWindowRec.FoundHWnd;
end;

function tally(s,v :string):integer;
label
   reload;
begin
    result:=0;
    if (v='') or (s='') then exit;
    if pos(v,s)>0 then begin
       reload:
       s := copy(s,pos(v,s)+length(v),length(s));
       if pos(v,s)>0 then goto reload;
    end

end;

function ClassExists(v :string):boolean;
var
   cls :TWndClassEx;
begin
    cls.cbSize:=Sizeof(cls);
    result :=(GetClassInfoEx(0,PChar(v),cls)) or (GetClassInfoEx(hinstance,PChar(v),cls));
end;

function ReplaceString(s, swhat, swith :string; all :boolean=true):string; overload;
var
   i,x :integer;
   t :string;
begin
    result:=s; t:='';
    if (s='') or (swhat='') then exit;
    for i :=1 to length(s) do begin
        x :=pos(s[i],swhat);
        if x=0 then
           t :=t +s[i];
        end;
    result:=t;
end;

function twips2pix(v :integer):integer;
begin
    result:=v div 15;
end;

function pix2twips(v :integer):integer;
begin
    result:=v * 15;
end;

procedure DUI2Win(Dlg:integer; var lx, ly, cx, cy  :integer) ;
var
   avgWidth, avgHeight  :integer;
   size :TSize;
   tm : TTextMetric;
   {Font,} FontOld, SysFont :hfont;
   dc :hdc;
   LF :TLogFont;
begin
    dc := GetDC(Dlg);
    SysFont := GetStockObject(DEFAULT_GUI_FONT);
    GetObject(SysFont, SizeOf( LF), @LF);
    //Font := SendMessage( Dlg, WM_GETFONT, 0,0);
    FontOld := SelectObject(dc, SysFont);
    GetTextMetrics(dc,tm);
    GetTextExtentPoint32(dc,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',52,size);
    avgWidth := ((size.cx div 26)+1) div 2;
    avgHeight := tm.tmHeight;
    lx := (lx * avgWidth) div 4;
    cx := (cx * avgWidth) div 4;
    ly := (ly * avgHeight) div 8;
    cy := (cy * avgHeight) div 8;
    ReleaseDC(Dlg, dc);
    DeleteObject(FontOld);
end;

procedure Win2DUI(Dlg :integer; var lx, ly, cx, cy :integer);
var
   avgWidth, avgHeight  :integer;
   size :TSize;
   tm : TTextMetric;
   {Font,} FontOld, SysFont :hfont;
   dc :hdc;
   LF :TLogFont;
begin
    dc := GetDC(Dlg);
    SysFont := GetStockObject(DEFAULT_GUI_FONT);
    GetObject(SysFont, SizeOf( LF), @LF);
    //Font := SendMessage( Dlg, WM_GETFONT, 0,0);
    FontOld := SelectObject(dc, SysFont);
    GetTextMetrics(dc,tm);
    GetTextExtentPoint32(dc,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',52,size);
    avgWidth := ((size.cx div 26)+1) div 2;
    avgHeight := tm.tmHeight;
    lx := (4 * lx) div avgWidth;
    cx := (4 * cx) div avgWidth;
    ly := (8 * ly) div avgHeight;
    cy := (8 * cy) div avgHeight;
    ReleaseDC(Dlg, dc);
    DeleteObject(FontOld);
end;


procedure  GetPropertyList(value :TObject; Results :TStrings);
var
    plist: PPropList;
    i, n: integer;
    v :string;
    d :double;
begin
  if value=nil then exit;
  n:= GetPropList (value, plist);
  try
    for i:= 0 to n-1 do begin
      if plist^[i]^.PropType^.Kind<>tkFloat then
         v := GetPropValue(value,plist^[i]^.Name)
      else begin
         d :=GetPropValue(value,plist^[i]^.Name,false);
         v := floattostr(d);
      end;
      Results.AddObject(plist^[i]^.Name+'='+v,TObject(plist^[i]));
      //AddLog (plist^[i]^.Name+'='+v);
    end;
  finally
    FreeMem (plist);
  end ;
end;

procedure DUI2PIX(FWindow :hwnd; var P :TPoint);
var
   Dc: hdc ;
   AWidth,AHeight :integer;
   Font, FontOld :hfont;
   s :string;
   TM :TEXTMETRIC;
   Sz : SIZE;
begin
    Dc := GetDC(FWindow);
    Font := SendMessage(FWindow,wm_getfont,0,0);
    FontOld := SelectObject(Dc,Font);
    s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
    GetTextMetrics(Dc,TM);
    GetTextExtentPoint32(Dc,PChar(s),Length(s),Sz);
    SelectObject(DC,FontOld);
    ReleaseDc(FWindow,Dc) ;
    AWidth  := sz.cx div Length(s) ;
    AHeight := TM.tmHeight ;
    P.x := (P.x*AWidth) div 4;
    P.y := (P.y*AHeight) div 8;
end;

procedure PIX2DUI(FWindow :hwnd; var P :TPoint) ;
var
   Dc: hdc ;
   AWidth,AHeight :integer;
   Font, FontOld :hfont;
   s :string;
   TM :TEXTMETRIC;
   Sz : SIZE;
begin
    Dc := GetDC(FWindow) ;
    Font := SendMessage(FWindow,wm_getfont,0,0);
    FontOld := SelectObject(Dc,Font);
    s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
    GetTextMetrics(Dc,TM);
    GetTextExtentPoint32(Dc,PChar(s),Length(s),Sz);
    SelectObject(DC,FontOld);
    ReleaseDc(FWindow,Dc) ;
    AWidth  := sz.cx div Length(s) ;
    AHeight := TM.tmHeight ;
    P.x := (P.x*4) div AWidth  ;
    P.y := (P.y*8) div AHeight ;
end;

function BrowseForFolder(var Foldr: string; Title:string): Boolean;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  DisplayName: array[0..MAX_PATH] of Char;
begin
  Result := False;
  CopyMemory(@BrowseInfo.pidlRoot,@Foldr,Length(Foldr));
  CopyMemory(@DisplayName[0],@Foldr,Length(Foldr));
  FillChar(BrowseInfo, SizeOf(BrowseInfo), #0);
  with BrowseInfo do begin
    hwndOwner := Application.Handle;
    pszDisplayName := @DisplayName[0];
    lpszTitle := PChar(Title);
    ulFlags := BIF_RETURNONLYFSDIRS;
  end;
  ItemIDList := SHBrowseForFolder(BrowseInfo);
  if Assigned(ItemIDList) then
    if SHGetPathFromIDList(ItemIDList, DisplayName) then begin
      Foldr := DisplayName;
      Result := True;
    end;
end;


function SearchTree(const AStartDir, AFileToFind : string; ARecurse :boolean = true) : string;
var
   sResult : string;

    // Recursive Dir Search
    procedure _SearchDir(const ADirPath : string);
    var rDirInfo : TSearchRec;
        sDirPath : string;
    begin
      sDirPath := IncludeTrailingPathDelimiter(ADirPath);

      if FindFirst(sDirPath + '*.*',faAnyFile,rDirInfo) = 0 then begin
        // First find is a match ?
        if SameText(rDirInfo.Name,AFileToFind) then
           sResult := sDirPath + rDirInfo.Name;

        // Traverse Starting Path
        while {}(sResult = '') and (FindNext(rDirInfo) = 0) do begin
          if SameText(rDirInfo.Name,AFileToFind) then
             sResult := sDirPath + rDirInfo.Name
          else
            // Recurse Directorty ?
            if ARecurse then
              if (rDirInfo.Name  = '.') or (rDirInfo.Name = '..') and
                 ((rDirInfo.Attr and faDirectory) = faDirectory) then
                  _SearchDir(sDirPath + rDirInfo.Name);
        end;

        FindClose(rDirInfo);
      end;
    end;

// SearchTree
begin
  Result := '';
  Screen.Cursor := crHourGlass;
  sResult := '';
  _SearchDir(AStartDir);
  Screen.Cursor := crDefault;
  Result := sResult;
end;


procedure ListFileinDir(const AStartDir : string; AList :TStrings; Filter :string = '*.*'; ARecurse :boolean = true) ;
var
   sResult : string;

    // Recursive Dir Search
    procedure _SearchDir(const ADirPath : string);
    var rDirInfo : TSearchRec;
        sDirPath : string;
    begin
      Application.ProcessMessages;
      sDirPath := IncludeTrailingPathDelimiter(ADirPath);

      if FindFirst(sDirPath + '\'+Filter,faAnyFile,rDirInfo) = 0 then begin
        // First find is a match ?
           sResult := sDirPath + rDirInfo.Name;
           Alist.Add(sResult) ;
        // Traverse Starting Path
        while (sResult = '') and (FindNext(rDirInfo) = 0) do begin

             sResult := sDirPath + rDirInfo.Name;
             Alist.Add(sResult) ;

            // Recurse Directorty ?
            if ARecurse then
              if (rDirInfo.Name  = '.') or (rDirInfo.Name = '..') and
                 ((rDirInfo.Attr and faDirectory) = faDirectory) then
                  _SearchDir(sDirPath + rDirInfo.Name);
        end;

        FindClose(rDirInfo);
      end;
    end;

// SearchTree
begin
  Screen.Cursor := crHourGlass;
  sResult := '';
  _SearchDir(AStartDir);
  Screen.Cursor := crDefault;
end;

procedure ListFileDir(Path: string; FileList: TStrings; Filter :string='*.*');
var
  DOSerr: Integer;
  fsrch: TsearchRec;
begin
  Doserr := FindFirst(Path+'\'+Filter, faAnyFile, fsrch);
  if (DOSerr = 0) then
  begin
    while (DOSerr = 0) do
    begin
      if (fsrch.attr and faDirectory) = 0 then
          FileList.Add(Path+'\'+fsrch.Name);
      Doserr := findnext(fsrch);
    end;
    findClose(fsrch);
  end;
end;

procedure ListFileDir(Path: string; Proc :TSearchInFileEvent; Filter :string='*.*');
var
  DOSerr: Integer;
  fsrch: TsearchRec;
  s :string;
begin
  s:=Path+fsrch.Name;
  if Proc(s)=-1 then exit;
  doserr := FindFirst(Path+'\'+Filter, faAnyFile, fsrch);
  if (DOSerr = 0) then
  begin
    while (DOSerr = 0) do
    begin
    Application.ProcessMessages;
      if (fsrch.attr and faDirectory) = 0 then
          if Assigned(Proc) then begin
             s := Path+fsrch.Name;
             Proc(s);
          end ;
      DOSerr := findnext(fsrch);
    end;
    findClose(fsrch);
  end;
end;

function IsAdmin: Boolean;
var
  hAccessToken: THandle; 
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID; 
  x: Integer; 
  bSuccess: BOOL; 
begin 
  Result   := False; 
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, 
    hAccessToken); 
  if not bSuccess then 
  begin 
    if GetLastError = ERROR_NO_TOKEN then 
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, 
        hAccessToken); 
  end; 
  if bSuccess then 
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, 
      ptgGroups, 1024, dwInfoBufferSize); 
    CloseHandle(hAccessToken); 
    if bSuccess then 
    begin 
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 
        0, 0, 0, 0, 0, 0, psidAdministrators); 
      {$R-} 
      for x := 0 to ptgGroups.GroupCount - 1 do 
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then 
        begin 
          Result := True; 
          Break; 
        end; 
      {$R+} 
      FreeSid(psidAdministrators); 
    end; 
    FreeMem(ptgGroups); 
  end; 
end;

function GetProcessMemorySize(_sProcessName: string; var _nMemSize: Cardinal): Boolean;
var
  l_nWndHandle, l_nProcID, l_nTmpHandle: HWND; 
  l_pPMC: PPROCESS_MEMORY_COUNTERS;
  l_pPMCSize: Cardinal;
begin 
  l_nWndHandle := FindWindow(nil, PChar(_sProcessName)); 
  if l_nWndHandle = 0 then 
  begin
    Result := False;
    Exit; 
  end; 
  l_pPMCSize := SizeOf(PROCESS_MEMORY_COUNTERS); 
  GetMem(l_pPMC, l_pPMCSize);
  l_pPMC^.cb := l_pPMCSize;
  GetWindowThreadProcessId(l_nWndHandle, @l_nProcID); 
  l_nTmpHandle := OpenProcess(PROCESS_ALL_ACCESS, False, l_nProcID); 
  if (GetProcessMemoryInfo(l_nTmpHandle, l_pPMC, l_pPMCSize)) then 
    _nMemSize := l_pPMC^.WorkingSetSize 
  else 
    _nMemSize := 0; 
  FreeMem(l_pPMC); 
  Result := True; 
end;

procedure GetOSVersion(var APlatform: string ; var AMajorVersion,AMinorVersion,ABuild: DWORD);
var
    VersionInfo: TOSVersionInfo;
begin
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo); 
  with VersionInfo do
  begin 
  case dwPlatformId of
   VER_PLATFORM_WIN32s:        APlatform := 'Windows 3x';
   VER_PLATFORM_WIN32_WINDOWS: APlatform := 'Windows 95';
   VER_PLATFORM_WIN32_NT:      APlatform := 'Windows NT';
  end;
  AMajorVersion := dwMajorVersion;
  AMinorVersion := dwMinorVersion;
  ABuild := dwBuildNumber;
  end; 
end;

function GetMemory :string;
var
  memory: TMemoryStatus; 
begin 
  memory.dwLength := SizeOf(memory);
  GlobalMemoryStatus(memory); 
  Result := ('Total memory: ' +
              IntToStr(memory.dwTotalPhys) + ' Bytes')+chr(10)+
             ('Available memory: ' +
              IntToStr(memory.dwAvailPhys) + ' Bytes');
end;

function CurrentProcessMemory: Cardinal;
var
  MemCounters: TProcessMemoryCounters;
begin
  Result := 0;
  MemCounters.cb := SizeOf(MemCounters);
  if GetProcessMemoryInfo(GetCurrentProcess,
      @MemCounters,
      SizeOf(MemCounters)) then
    Result := MemCounters.WorkingSetSize
  else
    RaiseLastOSError;
end;

function GetCurrentUserName: string;
const
  cnMaxUserNameLen = 254; 
var 
  sUserName: string; 
  dwUserNameLen: DWORD; 
begin
  dwUserNameLen := cnMaxUserNameLen - 1;
  SetLength(sUserName, cnMaxUserNameLen);
  Windows.GetUserName(PChar(sUserName), dwUserNameLen);
  SetLength(sUserName, dwUserNameLen); 
  Result := sUserName; 
end;

function ComputerName:String;
var
  ComputerName: Array [0 .. 256] of char;
  Size: DWORD;
begin
  Size := 256;
  GetComputerName(ComputerName, Size);
  Result := ComputerName;
end;

function GetCPUVendor: string;
var
  aVendor: array [0 .. 2] of LongWord;
  iI, iJ: Integer;
begin
  asm
    push  ebx
    xor   eax, eax
    dw    $A20F // CPUID instruction
    mov   LongWord ptr aVendor, ebx
    mov   LongWord ptr aVendor[+4], edx
    mov   LongWord ptr aVendor[+8], ecx
    pop   ebx
  end;
  for iI := 0 to 2 do
    for iJ := 0 to 3 do
      Result := Result +  
        Chr((aVendor[iI] and ($000000ff shl(iJ * 8))) shr(iJ * 8));
end;

function GetCPUSpeed: Double;
const
  DelayTime = 500; 
var 
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin 
  PriorityClass := GetPriorityClass(GetCurrentProcess); 
  Priority      := GetThreadPriority(GetCurrentThread); 
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS); 
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL); 
  Sleep(10); 
  asm 
    dw 310Fh 
    mov TimerLo, eax 
    mov TimerHi, edx 
  end; 
  Sleep(DelayTime); 
  asm 
    dw 310Fh 
    sub eax, TimerLo 
    sbb edx, TimerHi 
    mov TimerLo, eax 
    mov TimerHi, edx 
  end; 
  SetThreadPriority(GetCurrentThread, Priority); 
  SetPriorityClass(GetCurrentProcess, PriorityClass); 
  Result := TimerLo / (1000 * DelayTime); 
end;

procedure FindFilesEx(FilesList: TStrings; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList, Masks: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir='' then exit;//avoid rangecheck error , StartDir:='c:\';
  if StartDir[length(StartDir)] <> '\' then
     StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!) }
  Masks:=TStringList.Create;
  Masks.Text:=StringReplace(FileMask,',',#10,[rfreplaceall]);
  Application.ProcessMessages;
  IsFound :=FindFirst(StartDir+'*.*', faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    if Masks.IndexOf(ExtractFileExt(SR.Name))>-1 then
       FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
      DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFiles(FilesList, DirList[i], FileMask);

  DirList.Free;
  Masks.Free;
end;

procedure FindFiles(FilesList: TStrings; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList, Masks: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir='' then exit;//avoid rangecheck error , StartDir:='c:\';
  if StartDir[length(StartDir)] <> '\' then
     StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!) }
  Masks:=TStringList.Create;
  Masks.Text:=StringReplace(FileMask,',',#10,[rfreplaceall]);
  Application.ProcessMessages;
  IsFound :=FindFirst(StartDir+'*.*', faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    if Masks.IndexOf(ExtractFileExt(SR.Name))>-1 then
       FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
      DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFiles(FilesList, DirList[i], FileMask);

  DirList.Free;
  Masks.Free;
end;

function GetClassName(Handle: THandle): String;
var
   Buffer: array[0..MAX_PATH] of Char;
begin
   Windows.GetClassName(Handle, @Buffer, MAX_PATH);
   Result := String(Buffer);
end;

procedure ListDLLExports(const FileName: string; List: TStrings; complete:boolean=false);
type
  TDWordArray = array [0..$FFFFF] of DWORD;
var
  imageinfo: LoadedImage;
  pExportDirectory: PImageExportDirectory;
  dirsize: Cardinal;
  pDummy: PImageSectionHeader;
  i: Cardinal;
  pNameRVAs: ^TDWordArray;
  Name: string;
begin
  List.Clear; pDummy:= nil;
  if MapAndLoad(PChar(FileName), nil, @imageinfo, True, True) then
  begin
    try
      pExportDirectory := ImageDirectoryEntryToData(imageinfo.MappedAddress,
        False, IMAGE_DIRECTORY_ENTRY_EXPORT, dirsize);
      if (pExportDirectory <> nil) then
      begin
        pNameRVAs := ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,
          DWORD(pExportDirectory^.AddressOfNames), pDummy);
        for i := 0 to pExportDirectory^.NumberOfNames - 1 do
        begin
          Name := PChar(ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,
            pNameRVAs^[i], pDummy));
          if complete then
             List.AddObject(Name,TObject(integer(pExportDirectory)))
          else
             List.Add(Name);
        end;
      end;
    finally
      UnMapAndLoad(@imageinfo);
    end;
  end;
end;

function GetCapture(Image :TImage; fDlg :TForm=nil; Jpg :boolean = false):string;
var
   B :TBitmap;
   R :TRect;
   P :TPoint;
   cx, cy :integer;
   c:string;
   Dlg :hwnd;
begin
   result:='';
   if fdlg=nil then begin
      dlg:=0;
      c:='deskop';
   end else begin
      dlg:=fdlg.Handle;
      SetWindowLong(dlg,gwl_style,GetWindowLong(dlg,gwl_style) and not  CS_DROPSHADOW);
      c:=fdlg.Name;
   end;
   Screen.Cursor := crHandPoint;
   if not IsWindow(Dlg) then begin
      GetCursorPos(P);
      Dlg := WindowFromPoint(P);
   end;
   GetWindowRect(Dlg, R);
   cx := R.Right - R.Left;
   cy := R.Bottom -R.Top;
   Image.Width := cx;
   Image.Height := cy;
   B := TBitmap.Create;
   B.Canvas.Handle := GetDCEx(Dlg,0,dcx_parentclip or dcx_window or dcx_cache or dcx_clipsiblings or DCX_LOCKWINDOWUPDATE);
   BitBlt(Image.Canvas.Handle, 0, 0, cx, cy, B.Canvas.Handle, 0, 0, srccopy);
   ReleaseDC(Dlg, B.Canvas.Handle);
   Screen.Cursor:=crArrow;
   if pos('*',c)>0 then c:=stringreplace(c,'*','',[]);
   if jpg then begin  
      image.Picture.SaveToFile(ExtractFilePath(ParamStr(0))+c+'.bmp');
      bmp2jpeg(ExtractFilePath(ParamStr(0))+c+'.bmp',ExtractFilePath(ParamStr(0))+c+'.jpg');
      result:=ExtractFilePath(ParamStr(0))+c+'.jpg'
   end else begin
      image.Picture.SaveToFile(ExtractFilePath(ParamStr(0))+c+'.bmp');
      result:=ExtractFilePath(ParamStr(0))+c+'.bmp'
   end
end;


procedure Jpeg2Bmp(const BmpFileName, JpgFileName: string); // helloacm.com
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf32bit;
  Jpg := TJPEGImage.Create;
  try
    Jpg.LoadFromFile(JpgFileName);
    Bmp.Assign(Jpg);
    Bmp.SaveToFile(BmpFileName);
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end;

procedure Bmp2Jpeg(const BmpFileName, JpgFileName: string); // helloacm.com
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf32bit;
  Jpg := TJPEGImage.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpg.Assign(Bmp);
    Jpg.SaveToFile(JpgFileName); 
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end;

function IsFileTypeRegistered(ProgId :string): boolean;
var
 hkeyProgid : HKEY;
begin
  Result := false;
  if (SUCCEEDED(HResultFromWin32(RegOpenKey(HKEY_CLASSES_ROOT, PChar(ProgID), hkeyProgid)))) then
  begin
    Result := true;
    RegCloseKey(hkeyProgid);
  end;
end;

function RegisterFileTypeCommand(fileExtension, menuItemText, target: string) : boolean;
var
   reg: TRegistry;
   fileType: string;
begin
   result := false;
   reg := TRegistry.Create;
   with reg do
   try
     RootKey := HKEY_CLASSES_ROOT;
     if OpenKey('.' + fileExtension, True) then
     begin
       fileType := ReadString('') ;
       if fileType = '' then
       begin
         fileType := fileExtension + 'file';
         WriteString('', fileType) ;
       end;
       CloseKey;
       if OpenKey(fileType + '\shell\' + menuItemText + '\command', True) then
       begin
         WriteString('', target + ' "%1"') ;
         CloseKey;
         result := true;
       end;
     end;
   finally
     Free;
   end;
end;

function UnRegisterFileTypeCommand(fileExtension, menuItemText: string) : boolean;
var
   reg: TRegistry;
   fileType: string;
begin
   result := false;
   reg := TRegistry.Create;
   with reg do
   try
     RootKey := HKEY_CLASSES_ROOT;
     if OpenKey('.' + fileExtension, True) then
     begin
       fileType := ReadString('') ;
       CloseKey;
     end;
     if OpenKey(fileType + '\shell', True) then
     begin
       DeleteKey(menuItemText) ;
       CloseKey;
       result := true;
     end;
   finally
     Free;
   end;
end;

procedure ImageLoad(AFile :string; Image :TImage);
var
  OleGraphic: TOleGraphic;
  fs: TFileStream; 
begin
  OleGraphic := TOleGraphic.Create;
  fs         := TFileStream.Create(AFile, fmOpenRead or fmSharedenyNone);
  try
    OleGraphic.LoadFromStream(fs);
    Image.Picture.Assign(OleGraphic);
  finally 
    fs.Free;
    OleGraphic.Free
  end; 
end;

function GetFileNameFromOLEClass(const OLEClassName: string): string;
var
  strCLSID: string;
  IsFound: Boolean;
begin
  with TRegistry.Create do
    try
      RootKey := HKEY_CLASSES_ROOT;
      if KeyExists(OLEClassName + '\CLSID') then
      begin
        if OpenKeyReadOnly(OLEClassName + '\CLSID') then begin
           strCLSID := ReadString('');
           CloseKey;
        end;
        if OpenKey('CLSID\' + strCLSID + '\InprocServer32', False) then
          IsFound := True
        else
        if OpenKey('CLSID\' + strCLSID + '\LocalServer32', False) then
          IsFound := True
        else
          IsFound := False;

        if IsFound then
        begin
          Result := ReadString('');
          CloseKey;
        end

        else
          Result := '';
      end {else messageDlg('Not found.',mtInformation,[mbok],0)};
    finally
      Free
    end
end;

function RecurseWin32(const R: TRegistry; const ThePath: string;
  const TheKey: string): string;
var
  TheList: TStringList;
  i: Integer;
  LP: string;
  OnceUponATime: string;
begin
  Result  := '-';
  TheList := TStringList.Create;
  try
    R.OpenKey(ThePath, False);
    R.GetKeyNames(TheList);
    R.CloseKey;
    if TheList.Count = 0 then Exit;
    for i := 0 to TheList.Count - 1 do with TheList do 
      begin
        LP := ThePath + '\' + TheList[i];
        if CompareText(Strings[i], TheKey) = 0 then 
        begin
          Result := LP;
          Break;
        end;
        OnceUponATime := RecurseWin32(R, LP, TheKey);
        if OnceUponATime <> '-' then 
        begin
          Result := OnceUponATime;
          Break;
        end;
      end;
  finally
    TheList.Clear;
    TheList.Free;
  end;
end;

function GetWin32TypeLibList(Lines: TStrings): Boolean;
var
  R: TRegistry;
  W32: string;
  i, j, TheIntValue, TheSizeOfTheIntValue{}: Integer;
  TheSearchedValue, TheSearchedValueString: string;
  TheVersionList, TheKeyList: TStringList;
  TheBasisKey: string;
  TL:TTypeLib;
begin
  Result := True; TheVersionList := nil; TheKeyList := nil;
  try
    try
      R          := TRegistry.Create;
      TheVersionList := TStringList.Create;
      TheKeyList := TStringList.Create;

      R.RootKey := HKEY_CLASSES_ROOT;
      R.OpenKey('TypeLib', False);
      TheBasisKey := R.CurrentPath;

      (* Basis Informations *)
      case R.GetDataType('') of
        rdUnknown: ShowMessage('Nothing ???');
        rdExpandString, rdString: TheSearchedValueString := R.ReadString('');
        rdInteger: TheIntValue         := R.ReadInteger('');
        rdBinary: TheSizeOfTheIntValue := R.GetDataSize('');{}
      end;
      (* Build the List of Keys *)
      R.GetKeyNames(TheKeyList);
      R.CloseKey;
      for i := 0 to TheKeyList.Count - 1 do
         (* Loop around the typelib entries)
         (* Schleife um die TypeLib Einträge *)
        with TheKeyList do
          if Length(Strings[i]) > 0 then 
          begin
            R.OpenKey(TheBasisKey + '\' + Strings[i], False);
            TheVersionList.Clear;
            R.GetKeyNames(TheVersionList);
            R.CloseKey;
            (* Find "Win32" for each version *)
            (* Finde der "win32" für jede VersionVersion:*)
            for j := 0 to TheVersionList.Count - 1 do
              if Length(TheVersionList.Strings[j]) > 0 then
              begin 
                W32 := RecurseWin32(R, TheBasisKey + '\' +
                  Strings[i] + '\' +
                  TheVersionList.Strings[j],
                  'Win32');
                if W32 <> '-' then
                begin
                  TL :=TTypeLib.Create;
                  TL.Win32:= W32;
                  //TL.GUID:=StringToGUID(Copy(W32,pos('[',W32),pos(']',W32)-pos('[',W32)));
                  //Lines.Add(W32);
                  R.OpenKey(W32, False);
                  case R.GetDataType('') of
                    rdExpandString,
                    rdString: TheSearchedValue := R.ReadString('');
                    else
                      TheSearchedValue := 'Nothing !!!';
                  end;
                  R.CloseKey;
                  TL.FileName:=TheSearchedValue;
                  TL.Name:=ChangeFileExt(ExtractFileName(TL.FileName),'');
                  //Lines.Add('-----> ' + TheSearchedValue);
                  Lines.AddObject(TL.Name,TL);
                end;
              end;
          end;
    finally
      TheVersionList.Free;
      TheKeyList.Free;
    end;
  except
    Result := False;
  end;
end;

function GetSpecialDir(v:string):string;
(*
ALLUSERSPROFILE
APPDATA
CLIENTNAME
COMMONPROGRAMFILES
COMPUTERNAME
COMSPEC
HOMEDRIVE
HOMEPATH
LOGONSERVER
NUMBER_OF_PROCESSORS
OS
PATH
PATHEXT
PCTOOLSDIR
PROCESSOR_ARCHITECTURE
PROCESSOR_IDENTIFIER
PROCESSOR_LEVEL
PROCESSOR_REVISION
PROGRAMFILES
SESSIONNAME
SYSTEMDRIVE
SYSTEMROOT
TEMP
TMP
USERDOMAIN
USERNAME
USERPROFILE
WINDIR
*)
begin
    result:=GetEnvironmentVariable(v);
end;

function GetSpecialFolderPath(CSIDLFolder: Integer): string;
var
   FilePath: array [0..MAX_PATH] of char;
begin
  SHGetFolderPath(0, CSIDLFolder, 0, 0, FilePath);
  Result := FilePath;
end;

procedure ExtractResourceIDToFile(Instance:THandle; ResID:Integer; ResType, FileName:String; Overriden :boolean = true);
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
begin
  try
    ResStream := TResourceStream.CreateFromID(Instance, ResID, pChar(ResType));
    try
      if Overriden then
         if FileExists(FileName) then
            DeleteFile(pChar(FileName));
      FileStream := TFileStream.Create(FileName, fmCreate);
      try
        FileStream.CopyFrom(ResStream, 0);
      finally
        FileStream.Free;
      end;
    finally
      ResStream.Free;
    end;
  except
    on E:Exception do
    begin
      DeleteFile(FileName);
      raise;
    end;
  end;
end;

procedure ExtractResourceNameToFile(Instance:THandle; ResName, ResType, FileName:String; Overriden :boolean = true);
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
begin
  try
    ResStream := TResourceStream.Create(Instance, ResName, pChar(ResType));
    try
      if Overriden then
         if FileExists(FileName) then
            DeleteFile(pChar(FileName));
      FileStream := TFileStream.Create(FileName, fmCreate);
      try
        FileStream.CopyFrom(ResStream, 0);
      finally
        FileStream.Free;
      end;
    finally
      ResStream.Free;
    end;
  except
    on E:Exception do
    begin
      DeleteFile(FileName);
      raise;
    end;
  end;
end;

procedure ExtractResource(Module :HMODULE; ResName, ResType, ResFile :string);
var
   i, Size :integer;
   F :TextFile;
   A :array of Char;
   hLock :Pointer;
   hRes, hGlb :Cardinal;
begin
   hRes := findResource(Module,PChar(ResName),PChar(ResType));
   if hRes <> 0 then begin
      hGlb := LoadResource(Module,hRes);
      if hGlb <> 0 then begin
         hLock := LockResource(hRes);
         if hLock <> nil then begin
            size := SizeofResource(Module, hRes); 
            SetLength(A, size);
            CopyMemory(@A[0], hLock, Size);
            AssignFile(F,ResFile);
            Rewrite(F);
            for i := Low(A) to High(A) do
                Write(F,A[i]);
            CloseFile(F);
         end;
      end;
   end;
end;

procedure LoadResourceName(instance :HMODULe; ResName, ResFile, ResType :string; ALines :TStrings);
var
  tmpStream: TResourceStream;
begin
  tmpStream := TResourceStream.Create( Instance, PChar(ResName), PChar(ResType) );
  try
   ALines.LoadFromStream( tmpStream );
   ALines.SaveToFile(ResFile);
  finally
    tmpStream.Free;
  end;
end;

function ExecuteProcess(FileName: string; Visibility: Integer; BitMask: Integer; Synch: Boolean): Longword;
//valori di Visibility:
{
Value                Meaning
SW_HIDE            :Hides the window and activates another window.
SW_MAXIMIZE        :Maximizes the specified window.
SW_MINIMIZE        :Minimizes the specified window and activates the next top-level window in the Z order.
SW_RESTORE        :Activates and displays the window. If the window is minimized or maximized,
                    Windows restores it to its original size and position. An application should
                    specify this flag when restoring a minimized window.
SW_SHOW                :Activates the window and displays it in its current size and position.
SW_SHOWDEFAULT        :Sets the show state based on the SW_ flag specified in the STARTUPINFO
                        structure passed to the CreateProcess function by the program that started the application.
SW_SHOWMAXIMIZED       :Activates the window and displays it as a maximized window.
SW_SHOWMINIMIZED       :Activates the window and displays it as a minimized window.
SW_SHOWMINNOACTIVE     :Displays the window as a minimized window. The active window remains active.
SW_SHOWNA              :Displays the window in its current state. The active window remains active.
SW_SHOWNOACTIVATE      :Displays a window in its most recent size and position. The active window remains active.
SW_SHOWNORMAL          :Activates and displays a window. If the window is minimized or maximized,
                      Windows restores it to its original size and position. An application should specify this
                      flag when displaying the window for the first time.
}
//FileName: the name of the program I want to launch
//Bitmask:   specifies the set of CPUs on wich I want to run the program
    //the BitMask is built in the following manner:
    //I have a bit sequence: every bit is associated to a CPU (from right to left)
    //I set the bit to 1 if I want to use the corrisponding CPU, 0 otherwise
    //for example: I have 4 processor and I want to run the specified process on the CPU 2 and 4:
    //the corresponding bitmask will be     1010 -->2^0 * 0 + 2^1 * 1 + 2^2 * 0 + 2^3 * 1 = 2 + 8 = 10
    //hence BitMask = 10
//Synch: Boolean --> True if I want a Synchronous Execution (I cannot close
//my application before the launched process is terminated)

var
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Closed: Boolean;
begin
  //Closed := True;
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    //running the process on the set of CPUs specified by BitMask
    SetProcessAffinityMask(ProcessInfo.hProcess, BitMask);
    /////
    if (Synch = True) then //if I want a Synchronous execution (I cannot close my
    // application before this process is terminated)
      begin
        Closed:= False;
        repeat
          case WaitForSingleObject(
            ProcessInfo.hProcess, 100) of
              WAIT_OBJECT_0 : Closed:= True;
              WAIT_FAILED : RaiseLastWin32Error;
          end;
          Application.ProcessMessages;
        until (Closed);
        GetExitCodeProcess(ProcessInfo.hProcess, Result);
        //exit code of the launched process (0 if the process returned no error  )
        CloseHandle(ProcessInfo.hProcess);
        CloseHandle(ProcessInfo.hThread);
      end
    else
      begin
        Result := 0;
      end;
  end;
end; {ExecuteProcess}

// Open Taskmanager, select the launched process, right click,
// "Set affinity", you will see a check on the CPUs you selected

function LastInput: DWord;
var
  LInput: TLastInputInfo;
begin
  LInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LInput);
  Result := GetTickCount - LInput.dwTime;
end;

 (*Example:
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Label1.Caption := Format('System Idle since %d ms', [LastInput]);
end;*)

procedure EnumExtensions(Lines:TStrings);
var
  reg: TRegistry;
  keys: TStringList;
  i: Integer;
  typename, displayname, server: string;
  rii:PRegistryEntryStruct;
begin
  lines.Clear;
  reg := TRegistry.Create;
  try
    reg.rootkey := HKEY_CLASSES_ROOT;
    if reg.OpenKey('', False) then
    begin
      keys := TStringList.Create;
      try
        reg.GetKeyNames(keys);
        reg.CloseKey;
        //lines.addstrings(keys);
        for i := 0 to keys.Count - 1 do
        begin
          if keys[i][1] = '.' then
          begin
            {this is an extension, get its typename}
            if reg.OpenKey(keys[i], False) then
            begin
              typename := reg.ReadString('');
              reg.CloseKey;
              if typename <> '' then
              begin
                if reg.OpenKey(typename, False) then
                begin
                  displayname := reg.ReadString('');
                  reg.CloseKey;
                end;
                if reg.OpenKey(typename + '\shell\open\command', False) then
                begin
                  server := reg.ReadString('');
                  New(rii);
                  rii^.Name:=keys[i];
                  rii^.Server:=server;
                  rii^.TypName:=typename;
                  rii^.DisplayName:=displayname;
                  rii^.Info:=Format('Extension: "%s", Typename: "%s", Displayname:"%s"' +
                                         #13#10'  Server: %s',
                                         [keys[i], typename, displayname, server]);
                  Lines.AddObject(rii^.Name,TObject(rii));
                  reg.CloseKey;
                end;
              end;
            end;
          end;
        end;
      finally
        keys.Free;
      end;
    end;
  finally
    reg.Free
  end;
end;

function SetGlobalEnvironment(const Name, Value: string; const User: Boolean = True): Boolean;
resourcestring
  REG_MACHINE_LOCATION = 'System\CurrentControlSet\Control\Session Manager\Environment';
  REG_USER_LOCATION = 'Environment';
begin
  with TRegistry.Create do
    try
      if User then { User Environment Variable }
        Result := OpenKey(REG_USER_LOCATION, True)
      else { System Environment Variable }
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        Result  := OpenKey(REG_MACHINE_LOCATION, True);
      end;
      if Result then
      begin
        WriteString(Name, Value); { Write Registry for Global Environment }
        { Update Current Process Environment Variable }
        SetEnvironmentVariable(PChar(Name), PChar(Value));
        { Send Message To All Top Window for Refresh }
        SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(PChar('Environment')));
      end;
    finally
      Free;
    end;
end;

procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
var
  IconIndex: SmallInt;  // Position of the icon in the file
  Icono: PHICON;       // The LargeIcon parameter of ExtractIconEx
  FileExt, FileType: string;
  Reg: TRegistry;
  p: Integer;
  p1, p2: PChar;
  buffer: array [0..255] of Char;

Label
  noassoc, NoSHELL; // ugly! but I use it, to not modify to much the original code :(
begin
  IconIndex := 0;
  Icono := nil;
  // ;Get the extension of the file
  FileExt := UpperCase(ExtractFileExt(FileName));
  if ((FileExt ='.EXE') and (FileExt ='.ICO')) or not FileExists(FileName) then
  begin
    // If the file is an EXE or ICO and exists, then we can
    // extract the icon from that file. Otherwise here we try
    // to find the icon in the Windows Registry.
    Reg := nil;
    try
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_CLASSES_ROOT;
      if FileExt = '.EXE' then FileExt := '.COM';
      if Reg.OpenKeyReadOnly(FileExt) then
        try
          FileType := Reg.ReadString('');
        finally
          Reg.CloseKey;
        end;
      if (FileType <> '') and Reg.OpenKeyReadOnly(FileType + '\DefaultIcon') then
        try
          FileName := Reg.ReadString('');
        finally
          Reg.CloseKey;
        end;
    finally
      Reg.Free;
    end;

    // If there is not association then lets try to
    // get the default icon
    if FileName = '' then goto noassoc;

    // Get file name and icon index from the association
    // ('"File\Name",IconIndex')
    p1 := PChar(FileName);
    p2 := StrRScan(p1, ',');
    if p2<>nil then
    begin
      p         := p2 - p1 + 1; // Position de la coma
      IconIndex := StrToInt(Copy(FileName, p + 1, Length(FileName) - p));
      SetLength(FileName, p - 1);
    end;
  end; //if ((FileExt  '.EX ...

  // Try to extract the small icon
  if ExtractIconEx(PChar(FileName), IconIndex, Icono^, PSmallIcon^, 1) <> 1 then
  begin
    noassoc:
    // That code is executed only if the ExtractIconEx return a value but 1
    // There is not associated icon
    // try to get the default icon from SHELL32.DLL

    FileName := 'C:\Windows\System\SHELL32.DLL';
    if not FileExists(FileName) then
    begin  //If SHELL32.DLL is not in Windows\System then
      GetWindowsDirectory(buffer, SizeOf(buffer));
      //Search in the current directory and in the windows directory
      FileName := FileSearch('SHELL32.DLL', GetCurrentDir + ';' + buffer);
      if FileName = '' then
        goto NoSHELL; //the file SHELL32.DLL is not in the system
    end;

    // Determine the default icon for the file extension
    if (FileExt = '.DOC') then IconIndex := 1
    else if (FileExt = '.EXE') or (FileExt = '.COM') then IconIndex := 2
    else if (FileExt = '.HLP') then IconIndex := 23
    else if (FileExt = '.INI') or (FileExt = '.INF') then IconIndex := 63
    else if (FileExt = '.TXT') then IconIndex := 64
    else if (FileExt = '.BAT') then IconIndex := 65
    else if (FileExt = '.DLL') or (FileExt = '.SYS') or (FileExt = '.VBX') or
      (FileExt = '.OCX') or (FileExt = '.VXD') then IconIndex := 66
    else if (FileExt = '.FON') then IconIndex := 67
    else if (FileExt = '.TTF') then IconIndex := 68
    else if (FileExt = '.FOT') then IconIndex := 69
    else
      IconIndex := 0;
    // Try to extract the small icon
    if ExtractIconEx(PChar(FileName), IconIndex, Icono^, PSmallIcon^, 1) <> 1 then
    begin
      //That code is executed only if the ExtractIconEx return a value but 1
      // Fallo encontrar el icono. Solo "regresar" ceros.
      NoSHELL:
      if PLargeIcon=nil then PLargeIcon^ := 0;
      if PSmallIcon=nil then PSmallIcon^ := 0;
    end;
  end; //if ExtractIconEx

  if PSmallIcon^>0 then
  begin //If there is an small icon then extract the large icon.
    PLargeIcon^ := ExtractIcon(Application.Handle, PChar(FileName), IconIndex);
    if PLargeIcon^ = Null then
      PLargeIcon^ := 0;
  end;
end;

procedure ExtractIcons(limg:TImage=nil;simg:TImage=nil);
var
  SmallIcon, LargeIcon: HIcon;
  Icon: TIcon;
begin
  with (TOpenDialog.Create(nil)) do begin
  Icon := TIcon.Create;
  try
    GetAssociatedIcon(FileName, @LargeIcon, @SmallIcon);
    if LargeIcon <> 0 then
    begin
      Icon.Handle := LargeIcon;
      Icon.SaveToFile(ChangeFileExt(FileName,'')+'-large.ico');
      if limg<>nil then
         limg.Picture.Icon:=icon;
    end;
    if SmallIcon <> 0 then
    begin
      Icon.Handle := SmallIcon;
      Icon.SaveToFile(ChangeFileExt(FileName,'')+'-small.ico');
      if simg<>nil then
         simg.Picture.Icon:=icon;
    end;
  finally
    Icon.Destroy;
  end;
  end;
end;

function ComPortAvailable(Port: PChar): Boolean;
var
  DeviceName: array[0..80] of Char;
  ComFile: THandle;
begin
  StrPCopy(DeviceName, Port);

  ComFile := CreateFile(DeviceName, GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);

  Result := ComFile <> INVALID_HANDLE_VALUE;
  CloseHandle(ComFile);
end;

function GetOpenComPort(searchfor:integer=30):tcomports;
var
   i:integer;
begin
    SetLength(result,0);
    for i:=0 to searchfor-1  do begin
        if ComPortAvailable(PChar(format('COM%d:',[i]))) then begin
           SetLength(result,i+1);
           result[i].name:=format('COM%d:',[i]);
           result[i].id:=i;
        end
    end
end;

procedure RegisterFileType(ext: string; exe: string);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    //create a new key  --> .pci
    reg.OpenKey('.' + ext, True);
    try
      //create a new value for this key --> pcifile
      reg.Writestring('', ext + 'file');
    finally
      reg.CloseKey;
    end;
    //create a new key --> pcifile
    reg.CreateKey(ext + 'file');
    //create a new key pcifile\DefaultIcon
    reg.OpenKey(ext + 'file\DefaultIcon', True);
    //and create a value where the icon is stored --> c:\project1.exe,0
    try
      reg.Writestring('', exe + ',0');
    finally
      reg.CloseKey;
    end;
    reg.OpenKey(ext + 'file\shell\open\command', True);
    //create value where exefile is stored --> c:\project1.exe "%1"
    try
      reg.Writestring('', exe + ' "%1"');
    finally
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

{procedure TForm1.Button1Click(Sender: TObject);
begin
  RegisterFileType('pci', 'c:\project1.exe');
end;}

function GetSerialPortNames: string;
var
  Index: Integer;
  Data: string;
  TmpPorts: String;
  sr : TSearchRec;
begin
  try
    TmpPorts := '';
    if FindFirst('/dev/ttyS*', $FFFFFF{FF}, sr) = 0 then
    begin
      repeat
        if (sr.Attr and $FFFFFF{FF}) = Sr.Attr then
        begin
          data := sr.Name;
          index := length(data);
          while (index > 1) and (data[index] <> '/') do
            index := index - 1;
          TmpPorts := TmpPorts + ' ' + copy(data, 1, index + 1);
        end;
      until FindNext(sr) <> 0;
    end;
    FindClose(sr);
  finally
    Result:=TmpPorts;
  end;
end;

function RegisterOCX(FileName: string): Boolean;
var
  OCXHand: THandle;
  RegFunc: TDllRegisterServer;
begin
  OCXHand := LoadLibrary(PChar(FileName));
  RegFunc := GetProcAddress(OCXHand, 'DllRegisterServer');
  if @RegFunc <> nil then
    Result := RegFunc = S_OK
  else
    Result := False;
  FreeLibrary(OCXHand);
end;

function UnRegisterOCX(FileName: string): Boolean;
var
  OCXHand: THandle;
  RegFunc: TDllRegisterServer;
begin
  OCXHand := LoadLibrary(PChar(FileName));
  RegFunc := GetProcAddress(OCXHand, 'DllUnregisterServer');
  if @RegFunc <> nil then
    Result := RegFunc = S_OK
  else
    Result := False;
  FreeLibrary(OCXHand);
end;

procedure  EnumComPorts(const   Ports:  TStringList);

var
  nInd:  Integer;

begin  { EnumComPorts }
  with  TRegistry.Create(KEY_READ)  do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if  OpenKey('hardware\devicemap\serialcomm', False)  then
        try
          Ports.BeginUpdate();
          try
            GetValueNames(Ports);
            for  nInd := Ports.Count - 1  downto  0  do
              Ports.Strings[nInd] := ReadString(Ports.Strings[nInd]);
            Ports.Sort()
          finally
            Ports.EndUpdate()
          end { try-finally }
        finally
          CloseKey()
        end { try-finally }
      else
        Ports.Clear()
    finally
      Free()
    end { try-finally }
end { EnumComPorts };

end.
