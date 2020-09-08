unit DebuggerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ToolWin, ExtCtrls, Menus, IniFiles, TypInfo,
  ShellApi, Buttons, math, typesUnit, PropertyEditUnit, SynEdit,
  FreeBasicRTTI, ELSuperEdit, PageSheetUnit;

type
   TDebugger=class(TStringList)
   private
     fEdit:TELSuperEdit;
     fFiles:TStrings;
   public
     constructor create;
     destructor destroy; override;
     procedure AddFile(v:string);
     function FileDebugExists(v:string):integer;
     function isFileOpen(v:string):TPageSheet;
     procedure Scan;
     procedure Reset;
     property Edit:TELSuperEdit read fEdit write fEdit;
     property Files:TStrings read ffiles;
   end;

implementation

uses LauncherUnit, MainUnit, CodeUnit;

{ TDebugger }
constructor TDebugger.create;
begin
   fFiles:=TStringList.Create;
end;

destructor TDebugger.destroy;
begin
   fFiles.Free;
   inherited;
end;

procedure TDebugger.AddFile(v:string);
begin
       if ffiles.IndexOf(v)=-1 then
          ffiles.Add(v);
end;

function TDebugger.FileDebugExists(v:string):integer;
var
   i:integer;
begin
    result:=-1;
    if v='' then exit;
    i:=IndexOf(v);
    result:=i;
end;

procedure TDebugger.Scan;
var
   i,fd,ln,e,eNumber:integer;
   s,p,v,en:string;
   Ps:TPageSheet;
   eKind:TErrorKind;
   Error:TError;
label
   Skip;
   function Number(v:string):string;
   var
      i:integer;
   begin
      result:='';
      if v='' then exit;
      for i:=1 to length(v) do
          if v[i] in ['0'..'9'] then
             result:=result+v[i];
   end;
begin
   if Count=0 then exit;
   i:=0;
   repeat
         s:=trim(Self[i]); eKind:=erkNone;
         if s='' then goto skip;
         if Count>0 then begin
            p:='';
            v:='';
            if pos(' error ',lowercase(s))>0 then begin
               en:=trim(copy(s,pos(' error ',lowercase(s))+6,length(s)));
               en:=trim(copy(en,1,pos(':',en)-1));
               eKind:=erkError;
               p:=copy(s,1,pos('(',s)-1);
               v:=copy(s,pos('(',s)+1,pos(')',s)-pos('(',s)-1);
            end ;

            if pos(' warning ',lowercase(s))>0 then begin
               en:=trim(copy(s,pos(' warning ',lowercase(s))+8,length(s)));
               en:=trim(copy(en,1,pos(':',en)-1));
               eKind:=erkWarning;
               p:=copy(s,1,pos('(',s)-1);
               v:=copy(s,pos('(',s)+1,pos(')',s)-pos('(',s)-1);
            end ;

            if fileexists(p) then begin
               ps:=Launcher.isOpen(p);
               if ps=nil then
                  ps:=Launcher.NewEditor(p);
               fd:=FileDebugExists(p);
               if fd>-1 then AddFile(p);
               v:=number(v);
               en:=number(en);
               val(v,ln,e);
               if e=0 then begin
                  val(en,eNumber,e);
                  Error:=TError.Create;
                  ps.Frame.Edit.AddError(Error);
                  Error.Kind:=eKind;
                  Error.Number:=eNumber;
                  Error.Line:=ln;
                  Error.Kind:=eKind;
                  ps.Frame.Edit.Repaint;
               end
            end;
         end;
         skip:
         inc(i);
   until i>Count-1;
end;

function TDebugger.isFileOpen(v:string):TPageSheet;
var
   i:integer;
begin
   result:=nil;
   if v='' then exit;
   for i:=0 to Code.PageControl.PageCount-1 do begin
       if comparetext(TPageSheet(Code.PageControl.Pages[i]).FileName,v)=0 then begin
          result:=TPageSheet(Code.PageControl.Pages[i]);
          Code.PageControl.ActivePage:=result;
          if not Launcher.AllowMultipleFileInstances then break ;
       end
   end
end;

procedure TDebugger.Reset;
var
   i:integer;
begin
    for i:=0 to Code.PageControl.PageCount-1 do
        TPageSheet(Code.PageControl.Pages[i]).Frame.Edit.Reset;
    ffiles.Clear;
end;

end.
