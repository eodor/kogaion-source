unit InstallClassUnit;

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
  Dialogs, StdCtrls, Buttons, TypesUnit, IniFiles, StrUtils ;

type
  TInstallClass = class(TForm)
    Label1: TLabel;
    edClassFile: TEdit;
    btnClassfile: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnClassfileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InstallCls(v:string;silent:boolean=true);
    procedure installPack(v:string);
  end;

var
  InstallClass: TInstallClass;

implementation

{$R *.dfm}

uses MainUnit, ScannerUnit, LauncherUnit, CodeUnit, ResourceDialogUnit;

procedure TInstallClass.btnClassfileClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='FreeBasic Files (*.bas,*.bi)|*.bas;*.bi|FreeBasic Pack File (*.dll,*.fpk)|*.dll;*.fpk|All Files (*.*)|*.*';
         if Execute then begin
            edClassFile.Text:=FileName;
         end;
         Free
    end;
end;

procedure TInstallClass.installPack(v:string);
var
   i:integer;
   s,cls,pal,ifl:string;
   L,F:TStrings;
   runtimedsgn:boolean;
label
   skip;
begin
   if not FileExists(v) then exit;
   runtimedsgn:=false;
   i:=0;
   L:=TStringList.Create;
   F:=TStringList.Create;
   L.LoadFromFile(v);
   repeat
         s:=trim(L[i]);
         if pos('/''',s)=1 then
            repeat
                inc(i);
                s:=trim(L[i]);
                if pos('''/',s)>0 then break;
            until i>L.Count-1;
         if pos('/''',s)>1 then s:=copy(s,1,pos('/''',s)-1);
         if pos('''',s)=1 then goto skip;
         if pos('''',s)>1 then s:=copy(s,1,pos('''',s)-1);
         if pos('#define ',lowercase(s))>0 then
            if pos ('_registerclasses',lowercase(s))>0 then begin
               pal:=copy(s,pos('#define ',lowercase(s))+6,pos('_',s)-pos('#define ',lowercase(s))+6);
               cls:=trim(copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1));
               F.Text:=StringReplace(cls,',',#10,[rfreplaceall]);
               runtimedsgn:=true;
            end;
         if pos('#include ',lowercase(s))>0 then begin
            ifl:=copy(s,pos('"',s)+1,lastdelimiter('"',s)-pos('"',s)-1);
            if fileExists(ifl) then
               if F.IndexOf(ifl)=-1 then
                  F.Add(ifl);
         end;
         skip:
         inc(i);
   until i>L.Count-1;
   L.Free;
   
   if F.Text='' then
      installCls(v)
   {else
      for i:=0 to F.Count-1 do
          installCls(F[i])};

   F.Free;
   if not runtimedsgn then
      messageDlg(format('The %s package is not runtime design package.'#10'Was not installed.',[v]),mtInformation,[mbok],0);
end;

procedure TInstallClass.InstallCls(v:string;silent:boolean=true);
var

   Sc:TScanner;
   s,ifl,p:string;
   L,C:TStrings;
   i,J,x,y,z:integer;
   function FindInclude(v:string):string;
   var
      i:integer;
   begin
       result:='';
       for i:=0 to L.Count-1 do
           if pos(lowercase(v),lowercase(L[i]))>0 then begin
              result:=trim(copy(L[i],pos('"',L[i])+1,lastdelimiter('"',L[i])-pos('"',L[i])-1));
              break
           end
   end;
begin
   if not FileExists(v) then exit;
   Sc:=TScanner.create;
   Sc.FileName:=v;
   Sc.Scan;

   C:=TStringList.Create;
   L:=TStringList.Create;
   L.LoadFromFile(v);
   if (pos('type ',lowercase(L.text))=0) and
      (pos('_registerclasses',lowercase(L.text))=0) then begin
      if silent=false then
         messageDlg(format('The %s file is not a class file.'#10'Abort.',[v]),mtInformation,[mbok],0);
      exit
   end;
   if Launcher.ClassFiles.indexOf(v)=-1 then
      Launcher.ClassFiles.Add(v)
   else begin
      if silent=false then
         messageDlg(format('The %s class file'#10'already in register path.',[v]),mtInformation,[mbok],0);
      exit
   end;

      if FileExists(v) then begin
         C.LoadFromFile(ideDir+'gui\core.bi');
         s:=format('#include once "%s"',[v]);
         if C.IndexOf(s)=-1 then begin
            C.Add(s);
            C.SaveToFile(ideDir+'gui\core.bi');
         end;
      end;

   if FileExists(v) then begin
      L.LoadFromFile(v);
      y:=pos('#define ',lowercase(L.text));
      if y>-1 then
         p:=trim(copy(L.text,pos('#define ',lowercase(L.text))+8,pos('_',L.Text)-pos('#define ',lowercase(L.text))-1));
      x:=pos('_registerclasses',lowercase(L.text));
      if x>0 then begin
         y:=posex('"',L.Text,x+1);
         z:=posex('"',L.Text,y+1);
         s:=copy(L.Text,y+1,z-y-1);
         C.Text:=stringReplace(s,',',#10,[rfreplaceall]);
         for j:=0 to C.Count-1 do begin
             ifl:=FindInclude(C[j]);
             for i:=0 to L.Count-1 do begin
                if FileExists(ifl) then begin
                   Sc.FileName:=ifl;
                   Sc.Scan; 
                end;
                x:=Sc.Types.IndexOf(L[i]);
                if x>-1 then begin
                   y:=Launcher.Classes.IndexOf(L[i]);
                   if y>-1 then
                      Launcher.Classes.Objects[y]:=Sc.Types.Objects[x];
                end
             end
         end
         
      end;
   end;

   L.Free;

   s:=ChangeFileExt(v,'.bmp');
   if FileExists(s) then begin
      L:=TStringList.Create;
      if FileExists(ideDir+'gui\res\gui.rc') then begin
         L.LoadFromFile(ideDir+'gui\res\gui.rc');
         s:=format('%s BITMAP "%s"',[ChangeFileExt(ExtractFileName(s),''),s]);
         if L.IndexOf(s)=-1 then begin
            L.Add(s);
            L.SaveToFile(ideDir+'gui\res\gui.rc');
         end
      end;

   end;
   Sc.Free;
   L.Free;
   C.Free;

   Main.CopyLibRTTi;
end;

end.
