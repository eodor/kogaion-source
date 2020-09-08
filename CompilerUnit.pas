unit CompilerUnit;

interface

uses
    SysUtils, Classes, Controls, Windows, Messages, Forms, Dialogs, ShellApi,
    TlHelp32, ExtCtrls, iniFiles;

type
   TCompiler=class;

   TCompiler = class
   private
     fExitCode:cardinal;
     fEvent,fonHang,fBeforeRun, fAfterRun, fCompiling,fAssembling,fLinking :TNotifyEvent;
     fIsRunning,finError,fisStuck,fThreaded,fVerbose :boolean;
     fRedirect,fTerminated,fRun,fError :TNotifyEvent;
     fOutExt, fFileName, fParams, fSwitch, fOutFile, fDirectory, fTarget :string;
     fOutPuts, fExclusions :TStrings;
     fRunThread:cardinal;
     fNewWorkingMemory, fOldWorkingMemory:longint;
   protected
     procedure ReadExclusions;
     procedure StoreExclusions;
     function CheckIfIsHang: longint;
     procedure ComputeOutFile;
     procedure CaptureConsoleOutput; overload;
     procedure CompilerOffEvent(Sender :TObject);
     function ExecAndWait(const FileName: string; CmdShow: Integer=sw_show): Longword;
   public
     Main: hwnd;
     Status,TotalMemory,FreeMemory,ProcessMemory,LeakMemory:string;
     function Execute(AFileName :string = '') :integer;
     constructor Create;
     destructor Destroy; override;
     function KillTask(ExeFileName: string=''): Integer;
     procedure KillProcess(hWindowHandle: HWND);
     procedure Compile;
     procedure Run;
     procedure CompileRun;
     procedure Reset;
     procedure Clear;
     procedure Help;
     procedure DebugProcessStatus(s: string='');
     property Target:string read ftarget write ftarget;
     property Verbose:boolean read fVerbose write fVerbose;
     property ExitCode:cardinal read fExitCode;
     property Exclusions :TStrings read fExclusions write fExclusions;
     property InError:boolean read fInError;
     property isRunning:boolean read fisRunning;
     property Outfile:string read fOutfile write fOutFile;
     property Outputs :TStrings read fOutputs;
     property FileName :string read fFileName write fFileName;
     property Params :string read fParams write fParams;
     property Switch :string read fSwitch write fSwitch;
     property onError:TNotifyEvent read fError write fError;
     property OnRedirect:TNotifyEvent read fredirect write fredirect;
     property OnTerminate:TNotifyEvent read fterminated write fterminated;
     property onBeforeRun:TNotifyEvent read fBeforeRun write fBeforeRun;
     property OnAfterRun:TNotifyEvent read fAfterRun write fAfterRun;
     property OnRun:TNotifyEvent read frun write frun;
     property OutExtension: string read fOutExt;
     property isStuck :boolean read fisStuck;
     property Threaded:boolean read fThreaded write fThreaded;
     property onHang :TNotifyEvent read fonHang write fonHang;
     property RunThread:cardinal read fRunThread;
     property onCompiling:TNotifyEvent read fCompiling write fCompiling;
     property OnAssembling:TNotifyEvent read fAssembling write fAssembling;
     property OnLinking:TNotifyEvent read fAssembling write fAssembling;
  end;


const
   file_not_exists=10000;
   compiler_in_error=10001;
   compiler_is_hang=10002;

var
   CriticalSection: TRtlCriticalSection;

implementation

uses psApi, mainUnit, CodeUnit, HelperUnit, LauncherUnit;

procedure TCompiler.DebugProcessStatus(s: string='');
var 
  pmc: PPROCESS_MEMORY_COUNTERS;
  cb: Integer;
  MemStat: tMemoryStatus;
begin
  MemStat.dwLength := SizeOf(MemStat);
  GlobalMemoryStatus(MemStat);

  // Get the total and available system memory
  TotalMemory := 'Total system memory: ' +
    FormatFloat('###,###', MemStat.dwTotalPhys / 1024) + ' KByte';
  FreeMemory := 'Free physical memory: ' +
    FormatFloat('###,###', MemStat.dwAvailPhys / 1024) + ' KByte';

  // Get the used memory for the current process
  cb := SizeOf(TProcessMemoryCounters);
  GetMem(pmc, cb);
  pmc^.cb := cb;
  if GetProcessMemoryInfo(GetCurrentProcessId(), pmc, cb) then
  begin
    fNewWorkingMemory           := Longint(pmc^.WorkingSetSize);
    ProcessMemory := 'Process-Memory: ' +
      FormatFloat('###,###', fNewWorkingMemory / 1024) + ' KByte';
    LeakMemory    := 'Memory Loss: ' +
      FormatFloat('###,###', (fNewWorkingMemory - fOldWorkingMemory) / 1024) + ' KByte';
    fOldWorkingMemory           := fNewWorkingMemory;
  end;
  FreeMem(pmc);

  Status := 'Status: ' + s;
end;

function TCompiler.ExecAndWait(const FileName: string; CmdShow: Integer=sw_show): Longword;
var 
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppIsRunning: DWORD;
begin
  if Assigned(fBeforeRun) then
     fBeforeRun(self);
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
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
    then begin
       Result := WAIT_FAILED ;
       fRunThread:=0;
       if Assigned(fError) then fError(Self);
       //MessageDlg(Format(StringReplace(strMsg(24),'\n',#10,[rfReplaceAll]),[ExtractFileName(fOutFile)]),mtError,[mbok],0) ;
    end
  else
  begin

    repeat
      AppIsRunning := WaitForSingleObject(ProcessInfo.hProcess, 100);
      Application.ProcessMessages;
      Sleep(50);
      FIsRunning := true;
      if Assigned(fRun) then
         fRun(self);
    until (AppIsRunning <> WAIT_TIMEOUT) or (Application.Terminated){};
    FIsRunning := false;
    if assigned(fAfterRun) then
       fAfterRun(self);

    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;

constructor TCompiler.Create;
begin
    inherited;
    fOutputs := TStringList.Create;
    fExclusions := TStringList.Create;
    fThreaded:=true;
    ReadExclusions;
    fverbose:=true;
end;

destructor TCompiler.Destroy;
begin
    fOutputs.Free;
    StoreExclusions;
    fExclusions.Free;
    inherited;
end;

function TCompiler.Execute(AFileName :string = '') :integer;
var
   SEInfo: TShellExecuteInfo;
begin
   if AFileName = '' then
      if FileExists(fOutfile) then
         AFileName := fOutFile
      else begin
         result:=file_not_exists;
         if Assigned(fError) then fError(Self);
         exit;
      end;
   FillChar(SEInfo, SizeOf(SEInfo), 0) ;
   SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
   with SEInfo do begin
     fMask := SEE_MASK_NOCLOSEPROCESS;
     //Wnd := Application.Handle;
     lpFile := PChar(AFileName) ;
     lpParameters := PChar(FParams) ;
     lpDirectory := PChar(FDirectory) ;
     nShow := SW_SHOW;
   end;
   try
   if ShellExecuteEx(@SEInfo) then begin
     fRunThread:=GetCurrentThreadID;
     repeat
       GetExitCodeProcess(SEInfo.hProcess, fExitCode) ;
       FIsRunning := true;
       fOutFile:=AFileName;
       if Assigned(FRun) then FRun(Self);
       if fThreaded then
          Application.ProcessMessages;
     until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
     FIsRunning := false;
     if assigned(fAfterRun) then
        fAfterRun(self);
   end else begin
       fRunThread:=0;
       if Assigned(fError) then fError(Self);
       //MessageDlg(Format(StringReplace(strMsg(24),'\n',#10,[rfReplaceAll]),[ExtractFileName(AFileName)]),mtError,[mbok],0) ;
       end;
   except
        fRunThread:=0;
        fExitCode:=STATUS_TIMEOUT;
        if Assigned(fError) then fError(Self);
   end;
   Result := fExitCode ;
end;

function TCompiler.CheckIfIsHang: longint;
var
  H: THandle;
  DWResult: DWORD;
begin
  H :=Application.Handle; result:=0;
  if H > 0 then
  begin
    result := SendMessageTimeout(H, WM_NULL, 0, 0, SMTO_ABORTIFHUNG and SMTO_BLOCK, 1000, DWResult);
    if result > 0 then
      fisStuck :=true
    else begin
      fIsStuck :=false;
      KillTask(ExtractFileName(fFileName));
      KillTask(ExtractFileName(fOutFile));
      if Assigned(fonHang) then fonHang(self);
    end
  end
  else
    MessageDlg('Application not found.',mtInformation,[mbok],0);
end;

procedure TCompiler.CaptureConsoleOutput;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of Char;
  BytesRead: Cardinal;
  outStr: string;
  Handle: Boolean;
  s:string;
  //isHang :integer;
  //dwResult :DWord;
begin
  fOutputs.Text := '';
  outStr:='';
  //isHang:=0;
  fExitCode:=0;
  with SA do begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow :=SW_HIDE;// SW_SHOW;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    if fParams<>'-help' then
       if not FileExists(fParams) then begin
          fExitCode:=file_not_exists;
          if Assigned(fError) then begin
             fError(self);
             KillTask(fFileName);
             exit
          end;
       end ;
    if fParams='-help' then
       s :=Format('"%s" %s',[ffilename,fparams])
    else
       if fverbose then begin
          if ftarget<>'' then
             s :=Format('"%s" -v -target %s %s "%s"',[ffilename,ftarget,fswitch,fparams])
          else
             s :=Format('"%s" -v %s "%s"',[ffilename,fswitch,fparams])
       end else
          if ftarget<>'' then
             s :=Format('"%s" %s %s "%s"',[ffilename,ftarget,fswitch,fparams])
          else
             s :=Format('"%s" %s "%s"',[ffilename,fswitch,fparams]);



    Handle := CreateProcessA(nil, PChar(s),
                             nil, nil, True, 0, nil,
                             nil, SI, PI);
    CloseHandle(StdOutPipeWrite);
    {if Handle then
       isHang:=SendMessageTimeout(Main, WM_NULL, 0, 0, SMTO_ABORTIFHUNG and SMTO_BLOCK, 1000, DWResult);
       if isHang = 0 then begin
          KillTask(ExtractFileName(fFileName));
          KillTask(ExtractFileName(fOutFile));
          fExitCode:=compiler_is_hang;
          if Assigned(fError) then
             fError(Self);
          KillTask(fFileName);
          exit;
       end ;}
       if Handle=false then begin
          messageDlg('Internal error $cc - Can''t compile.',mterror,[mbok],0);
          exit
       end;
       try
        if Assigned(fRedirect) then fRedirect(Self);
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            outStr := outStr+(Buffer);
            if pos('compiling:',lowercase(outStr))>0 then
               if Assigned(fCompiling) then
                  fCompiling(Self);
            if pos('assembling:',lowercase(outStr))>0 then
               if Assigned(fAssembling) then
                  fAssembling(Self);
            if pos('linking:',lowercase(outStr))>0 then
               if Assigned(flinking) then
                  flinking(Self);
          end;
          fOutputs.Text:=OutStr;
          fInError :=pos('error',lowercase(outStr))>0;
          if fInError then begin
             fExitCode:=compiler_in_error;
             if Assigned(fError) then
                fError(Self);
             KillTask(fFileName);
          end;
          //Application.ProcessMessages;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
      finally
           CloseHandle(PI.hThread);
           CloseHandle(PI.hProcess);
           if not inError then
              if Assigned(fTerminated) then
                 fTerminated(Self);
      end;
  finally
      CloseHandle(StdOutPipeRead);
  end;
  if finerror then
     if Assigned(fError) then
        fError(Self);
end;

function TCompiler.KillTask(ExeFileName: string=''): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0; if ExeFileName='' then ExeFileName:=fOutfile;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  fExitCode:=cardinal(result);
  if Assigned(fTerminated) then
     fTerminated(self);
end;

procedure TCompiler.KillProcess(hWindowHandle: HWND);
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);

  if isWindow(hWindowHandle) then
  begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);

    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then
    begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
        False, hprocessID);
      if processHandle <> 0 then
      begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
        fExitCode:=0;
      end;
    end;
  end;
end;

procedure TCompiler.ComputeOutFile;
begin
   if not inError then begin
      if pos('-dll',fSwitch)>0 then
         fOutFile:=ChangeFileExt(fParams, '.dll')
      else
      if pos('-lib',fSwitch)>0 then
         fOutFile:=ChangeFileExt(fParams, '.lib')
      else
         fOutFile:=ChangeFileExt(fParams, '.exe')
   end;
   fOutExt :=ExtractFileExt(fOutFile);
   if (comparetext(foutext,'.dll')=0) or
      (comparetext(foutext,'.exe')=0) or
      (comparetext(foutext,'.exe')=0) then
      if ActiveResult<>nil then
         ListDLLExports(foutfile,ActiveResult.Edit.Lines)
end;

procedure TCompiler.CompilerOffEvent(Sender :TObject);
begin
    //if CheckIfIsHang=0 then fCompilerOff.Enabled:=false;
    if Assigned(fEvent) then fEvent(Self);
end;

procedure TCompiler.Compile;
begin
   KillTask(ExtractFileName(fOutFile));
   fOutFile:='';
   fInError:=false;
   fOutputs.Clear;
   fIsRunning:=false;
   if FileExists(fOutfile) then DeleteFile(PChar(fOutfile));
   try
      CaptureConsoleOutput;
   except
      CheckIfIsHang;
      KillTask(ExtractFileName(fFileName));
   end;
   ComputeOutFile;
end;

procedure TCompiler.Run;
//var
   //isHang:integer;
   //dwResult :DWord;
begin
   //isHang:=0;
   if not inError then begin
       {isHang:=SendMessageTimeout(Main, WM_NULL, 0, 0, SMTO_ABORTIFHUNG and SMTO_BLOCK, 1000, DWResult);
       if isHang > 0 then begin
          KillTask(ExtractFileName(fFileName));
          KillTask(ExtractFileName(fOutFile));
       end ; }
      if fileexists(foutfile) then
         try
            //Execute(fOutFile);
            ExecAndWait(fOutFile);
         finally
            KillTask(ExtractFileName(fOutFile));
         end;
    end
end;

procedure TCompiler.CompileRun;
begin
   fisStuck :=false;
   try
      Compile;
   except messageDlg('Internal error: $c-can''t compile.',mtInformation,[mbok],0);{} exit; end;

      ComputeOutFile;
      try
         if Assigned(fBeforeRun) then fBeforeRun(self);
         if fThreaded then begin
            EnterCriticalSection(CriticalSection);
            try
               Run;
            finally
               LeaveCriticalSection(CriticalSection);
            end
         end else Run;
      except KillTask(ExtractFileName(fOutFile)); end;
end;

procedure TCompiler.Clear;
begin
    fParams:='';
    fSwitch:='';
end;

procedure TCompiler.Reset;
begin
   KillTask(ExtractFileName(fFileName));
   //if FileExists(fOutfile) then
      KillTask(ExtractFileName(fOutfile));
end;

procedure TCompiler.ReadExclusions;
begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini')) do begin
         ReadSection('Exclusions',fExclusions);
         Free;
    end;
end;

procedure TCompiler.StoreExclusions;
var
  i :integer;
begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini')) do begin
         for i:=0 to fExclusions.Count-1 do
             WriteString('Exclusions',fExclusions[i],format('Exclusion%d',[i]));
         Free;
    end;
end;

procedure TCompiler.Help;
var
   se:TNotifyEvent;
begin
    se:=fError;
    fError:=nil;
    fParams:='-help';
    CompileRun; 
    fError:=se;
end;


initialization
  InitializeCriticalSection(CriticalSection);

finalization
  DeleteCriticalSection(CriticalSection);

end.
