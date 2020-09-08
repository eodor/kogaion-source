unit ScannerUnit;

interface

uses
   SysUtils, Windows, Messages, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Buttons, Forms, Menus,
   SynEdit, TypesUnit, StrUtils, Dialogs;

type
   TScanner=class;

   TScanner=class(TStringList)
   private
     fIncludes, fClasses, fTypes, fConstants,
     fNamespaces,fVariables, fFuncs, fSubs,
     fUnions, fEnums, fOperators, fProperties :TStrings;
     fEdit:TSynEdit;
     fTree:TTreeView;
     ffilename :string;
     fScan:TScannerEvent;
     fScanLine:TScanLineEvent;
     fScanConstructor:TScanCstrEvent;
     fScanRegister:TScanRegisterEvent;
     procedure SetTree(v:TTreeView);
     procedure SetEdit(v:TSynEdit);
     function GetTypCount:integer;
     function GetTyp(i:integer):TType;
     procedure SetFileName(v:string);
   public
     isMultiPlatform:boolean;
     constructor create;overload;
     destructor destroy;override;
     function TypExists(v:string):TType;
     function FieldExists(v:string;intype:boolean=false):TField;
     procedure Reset;
     procedure Scan;
     procedure FillTree;
     procedure Execute;
     property Includes:TStrings read fIncludes;
     property Classes:TStrings read fClasses;
     property Tree:TTreeView read ftree write settree;
     property Edit:TSynEdit read fedit write setedit;
     property Types:TStrings read fTypes;
     property Enums:TStrings read fEnums ;
     property Unions:TStrings read fUnions ;
     property Constants:TStrings read fConstants;
     property Variables:TStrings read fVariables;
     property Subs:TStrings read fSubs ;
     property Funcs:TStrings read fFuncs ;
     property Operators:TStrings read fOperators ;
     property Properties:TStrings read fProperties ;
     property TypCount:integer read gettypcount;
     property Typ[index:integer]:TType read gettyp;
     property FileName:string read ffilename write setfilename;
     property OnScan:TScannerEvent read fScan write fScan;
     property OnScanLine:TScanLineEvent read fScanLine write fScanLine;
     property OnScanConstructor:TScanCstrEvent read fScanConstructor write fScanConstructor;
     property OnScanRegister:TScanRegisterEvent read fScanRegister write fScanRegister;
   end;

   function SkipBlank(v:string):string;
   function isClassRegistered(v:string):integer;

implementation

uses MainUnit,LauncherUnit;

constructor TScanner.create;
begin
   inherited Create;
   fTypes:=TStringList.Create;
   fConstants:=TStringList.Create;
   fVariables:=TStringList.Create;
   fFuncs:=TStringList.Create;
   fSubs:=TStringList.Create;
   fUnions:=TStringList.Create;
   fEnums:=TStringList.Create;
   fOperators:=TStringList.Create;
   fProperties:=TStringList.Create;
   fClasses:=TStringList.Create;
   fNamespaces:=TStringList.Create;
   fIncludes:=TStringList.Create;
end;

destructor TScanner.destroy;
begin
    fTypes.Free;
    fConstants.Free;
    fVariables.Free;
    fFuncs.Free;
    fSubs.Free;
    fUnions.Free;
    fEnums.Free;
    fOperators.Free;
    fProperties.Free;
    fClasses.Free;
    fNamespaces.Free;
    fIncludes.Free;
    inherited;
end;

procedure TScanner.Reset;
var
   i:integer;
begin
    for i:=fnamespaces.Count-1 downto 0 do
        fnamespaces.Objects[i].Free;
    for i:=ftypes.Count-1 downto 0 do
        ftypes.Objects[i].Free;
    for i:=fvariables.Count-1 downto 0 do
        fvariables.Objects[i].Free;
    for i:=fconstants.Count-1 downto 0 do
        fconstants.Objects[i].Free;
    for i:=fenums.Count-1 downto 0 do
        fenums.Objects[i].Free;
    for i:=funions.Count-1 downto 0 do
        funions.Objects[i].Free;
    for i:=ffuncs.Count-1 downto 0 do
        ffuncs.Objects[i].Free;
    for i:=fsubs.Count-1 downto 0 do
        fsubs.Objects[i].Free;
    for i:=foperators.Count-1 downto 0 do
        foperators.Objects[i].Free;
    fTypes.Clear;
    fConstants.Clear;
    fVariables.Clear;
    fFuncs.Clear;
    fSubs.Clear;
    fUnions.Clear;
    fEnums.Clear;
    fOperators.Clear;
    fProperties.Clear;
    fNamespaces.Clear;
end;

procedure TScanner.SetTree(v:TTreeView);
begin
   fTree:=v;
end;

procedure TScanner.SetEdit(v:TSynEdit);
begin
    fEdit:=v;
end;

function TScanner.GetTypCount:integer;
begin
    if fTypes<>nil then
       result:=ftypes.Count
    else
       result:=0;
end;

function TScanner.GetTyp(i:integer):TType;
begin
    if (i>-1) and (i<typcount) then
       result:=TType(fTypes.Objects[i])
    else
       result:=nil   
end;

procedure TScanner.SetFileName(v:string);
begin
    ffilename:=v;
    if FileExists(v) then
       LoadFromFile(v)
    else
       Clear;  
end;

   function SkipBlank(v:string):string;
   var
      i:integer;
      s:string;
   begin
       result:=v;
       if v='' then exit;
       s:='';
       for i:=1 to Length(v) do
           if (v[i]<>#32) or (v[i]=#9) then
              s:=s+v[i];
       result:=s;
   end;

   function isClassRegistered(v:string):integer;
   var
      x:integer;
      w:TStrings;
   begin
       result:=-1;
       if v='' then exit;
       w:=TStringList.Create;
       w.Text:=stringreplace(v,',',#10,[rfreplaceall]);
       for x:=0 to w.Count-1 do
           if Launcher.classes.IndexOf(w[x])>-1 then begin
              result:=x;
              break
           end;
       w.Free;
   end;

procedure TScanner.Scan;
var
   i,j,k,x,wc:integer;
   Ln,lz,s,tk,p,v,c,prm,ifl:string;
   tk1,tk2,tk3,tk4,tk5,tk6,tk7,tk8,tk9,tk10,tk11,tk12,tk13,tk14,tk15,visibility:string;
   l,b,w:tstrings;
   t,o:ttype;
   intype,inenum, local:boolean;
   f,cstr,dstr,fs:tfield;
   nms,onms:TNamespace;
   regclasses:TClassRegPages;
   function tokenCount(v:string):integer;
   var
      i:integer;
   begin
      result:=0;
      if (v='') or (l.Count=0) then exit;
      i:=0;
      repeat
            if comparetext(l[i],v)=0 then inc(result);
            inc(i);
      until i>l.Count-1;
   end;
   function Normalize(v:string):string;
   var
      i:integer;
      L:TStrings;
   begin
       result:=v;
       if v='' then exit;
       L:=TStringList.Create;
       L.Text:=stringreplace(v,#32,#10,[rfreplaceall]);
       result:='';
       for i:=0 to L.Count-1 do
           if L[i]<>'' then
              result:=trim(result+#32+L[i]);
       L.Free
   end;

   function GetX(v:string):integer;
   var
      a:integer;
      s:string;
   begin
      result:=1;
      if v='' then exit;
      s:='';
      for a:=result to length(v) do begin
          s:=s+v[a];
          if (v[a]=' ') or (a=length(v)) then begin
             if a<length(s) then s:=copy(s,1,length(s)-1);
             if comparetext(s,v)=0 then begin
                result:=a-length(v);
                break
             end;
             s:='';
          end;
      end;
   end;

   procedure Concatenate(v:string);
   var
      cf,ext:string;
      cfb:TStrings;
   begin
      ext:=ExtractFileExt(v);
      if compareText(ext,'.bi')=0 then begin
         cf:=ChangeFileExt(v,'.bas');
         if FileExists(cf) then begin
            cfb:=TStringList.Create;
            cfb.LoadFromFile(cf);
            AddStrings(cfb);
            cfb.Free;
         end
      end
   end;

label
    skip,skp,skptyp,reload,recharge;
begin
    if self=nil then exit;
    if Count=0 then
       if fEdit<>nil then
          Assign(fEdit.Lines);

    if Count=0 then exit;

    Reset;

    Concatenate(fFileName);

    l:=tstringlist.create;
    b:=tstringlist.create;
    w:=tstringlist.create;
    local:=false;

    types.Clear;
    visibility:='public';
    intype:=false;
    inenum:=false;
    t:=nil;
    Cstr:=nil;
    onms:=nil;
    i:=0;
    repeat
          ln:=trim(Normalize(self[i]));
          if ln='' then goto skip;

          if Assigned(fScan) then fScan(self,ffilename);
          Application.ProcessMessages;

          recharge:
          tk1:='';
          tk2:='';
          tk3:='';
          tk4:='';
          tk5:='';
          tk6:='';
          tk7:='';
          tk8:='';
          tk9:='';
          tk10:='';
          tk11:='';
          tk12:='';
          tk13:='';
          tk14:='';
          tk15:='';

          l.Clear;
          j:=1;
          s:='';
          lz:='';

          repeat
                s:=s+ln[j];
                if (length(s)>1) and (ln[j]=#9) and  (ln[j]=#32) and (ln[j-1]=',') then goto skp;

                if (ln[j]=#32) or (j=length(ln)) then begin
                   if j<length(ln) then begin
                      tk:=copy(s,1,length(s)-1);
                      if (tk<>'') or (tk<>' ') then begin
                         lz:=lz+tk+#32;
                         l.Add(trim(tk))
                      end
                   end else begin
                      tk:=s;
                      if (tk<>'') or (tk<>' ') then begin
                         lz:=lz+tk;
                         l.Add(trim(tk));
                      end
                   end;
                    s:='';
                end;

                skp:
                inc(j);
          until j>length(ln);

          wc:=l.Count;
          if wc=0 then goto skip;  

          if l.count=1 then tk1:=l[0];
          if l.Count=2 then begin tk1:=l[0];tk2:=l[1];end;
          if l.Count=3 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];end;
          if l.Count=4 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];end;
          if l.Count=5 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];end;
          if l.Count=6 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];end;
          if l.Count=7 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];end;
          if l.Count=8 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];end;
          if l.Count=9 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];end;
          if l.Count=10 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];tk10:=l[9];end;
          if l.Count=11 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];tk10:=l[9];tk11:=l[10];end;
          if l.Count=12 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];tk10:=l[9];tk11:=l[10];tk12:=l[11];end;
          if l.Count=13 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];tk10:=l[9];tk11:=l[10];tk12:=l[11];tk13:=l[12];end;
          if l.Count=14 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];tk10:=l[9];tk11:=l[10];tk12:=l[11];tk13:=l[12];tk14:=l[13];end;
          if l.Count=15 then begin tk1:=l[0];tk2:=l[1];tk3:=l[2];tk4:=l[3];tk5:=l[4];tk6:=l[5];tk7:=l[6];tk8:=l[7];tk9:=l[8];tk10:=l[9];tk11:=l[10];tk12:=l[11];tk13:=l[12];tk14:=l[13];tk15:=l[14];end;

          b.text:=stringreplace(lz,':',#10,[rfreplaceall]);
          j:=0;
          repeat
                lz:=trim(Normalize(b[j]));
                if lz='' then goto skip;

                if assigned(fscanline) then fscanline(self,i,lz);
                Application.ProcessMessages;

                if (lz<>'') and (pos('#define ',lowercase(lz))=0) and (pos('type ',lowercase(lz))>0) then begin
                   tk:=copy(lz,1,pos(' ',lz));
                   if (comparetext('public ',lowercase(tk))>0) or
                      (comparetext('private ',lowercase(tk))>0) then begin
                    visibility:=tk;
                    ln:=trim(copy(lz,pos(' ',lz)+1,length(lz)));
                    goto recharge;
                   end;
                end;

                if (comparetext(tk1,'#include')=0) then begin
                   if comparetext(tk2,'once')=0 then begin
                      ifl:=StringReplace(tk3,'"','',[rfreplaceall]);
                      if fIncludes.IndexOf(ifl)=-1 then fIncludes.Add(ifl)
                   end else begin
                      ifl:=StringReplace(tk2,'"','',[rfreplaceall]);
                      if fIncludes.IndexOf(ifl)=-1 then fIncludes.Add(ifl)
                   end
                end;

                if (comparetext(tk1,'#define')=0) then begin

                   if pos('_registerclasses',lowercase(tk2))>0 then begin
                      tk2:=copy(tk2,1,pos('_',tk2)-1);
                      tk3:=SkipBlank(stringreplace(tk3,'"','',[rfreplaceall]));
                      if isClassRegistered(tk3)=-1 then begin
                         SetLength(regclasses,length(regclasses)+1);
                         regclasses[high(regclasses)]:=TClassRegPage.create;
                         regclasses[high(regclasses)].Page:=tk2;
                         regclasses[high(regclasses)].FileName:=fFileName;
                         regclasses[high(regclasses)].Text:=stringreplace(tk3,',',#10,[rfreplaceall]);
                         fClasses.AddStrings(regclasses[high(regclasses)]);

                         tk:=Format('#include once "%s"',[ffilename]);
                         if Launcher.Lib.incFile.indexof(tk)=-1 then begin
                            Launcher.Lib.incFile.Add(tk);
                         end ;
                         if assigned(fscanregister) then
                            fscanregister(self,i,l,regclasses[high(regclasses)]);
                      end;
                   end;
                   if comparetext('maintype',lowercase(tk2))=0 then begin
                      Launcher.Lib.MainTypeName:=stringreplace(tk3,'"','',[rfreplaceall]);
                   end;
                   if comparetext('mainfile',lowercase(tk2))=0 then begin
                      if comparetext(tk3,'self')=0 then
                         Launcher.Lib.MainFile:=ffilename
                      else
                         if FileExists(stringreplace(tk3,'"','',[rfreplaceall])) then
                            Launcher.Lib.MainFile:=stringreplace(tk3,'"','',[rfreplaceall]);

                      if not fileexists(Launcher.Lib.MainFile) then
                        case messageDlg(format('The %s main file not exists.'#10'You must set one.'#10'Do you want to set them, now?',[Launcher.Lib.MainFile]),mtconfirmation,[mbyes,mbno],0) of
                             mryes:begin
                             Launcher.Lib.MainFile:=inputbox('Set MainFile','Name one:',Launcher.Lib.MainFile);
                             if not fileexists(Launcher.Lib.MainFile) then
                                messageDlg('Error.',mterror,[mbok],0);
                             end   
                        end;
                   end;
                end;

                if (comparetext(tk1,'end')=0) and (comparetext(tk2,'namespace')=0) then intype:=false;
                if comparetext(tk1,'namespace')=0 then begin
                   nms:=TNamespace.create;
                   nms.Hosted:=tk2;
                   nms.Where.Y:=i;
                   nms.Owner:=onms;
                   onms:=nms;
                end;
                if (comparetext(tk1,'end')=0) and (comparetext(tk2,'constructor')=0) then cstr:=nil;
                if (comparetext(tk1,'end')=0) and (comparetext(tk2,'destructor')=0) then dstr:=nil;


                if (comparetext(tk1,'end')=0) and (comparetext(tk2,'type')=0) then intype:=false;
                if comparetext(tk1,'type')=0 then begin

                   if (wc>1) and (intype=false) then begin

                      if comparetext('as',tk2)=0 then begin
                         f:=TField.create;
                         f.Where.Y:=I;
                         f.Hosted:=tk1;
                         f.Return:=tk3;
                         f.Typ:='field';
                         f.Visibility:=visibility;
                         if t<>nil then t.Fields.AddObject(f.Hosted,f);
                         goto skptyp;
                      end ;

                      if comparetext('extends',tk3)=0 then begin
                         t:=ttype.create;
                         t.where.Y:=i;
                         t.Extends:=tk4;
                         t.ExtendsType:=typexists(t.Extends);
                         t.Hosted:=tk2; 
                         t.Typ:=tk3;
                         t.Kind:=tk1;
                         t.Module:=ffilename;
                         x:=types.IndexOf(t.Hosted);
                         if x=-1 then begin
                            types.AddObject(t.Hosted,t) ;
                            Launcher.Types.AddObject(t.Hosted,t) ;
                         end;
                         intype:=true;
                         if comparetext(Launcher.Lib.MainTypeName,t.Hosted)=0 then
                            Launcher.Lib.MainType:=T;
                      end;
                      if comparetext('as',tk3)=0 then begin
                         t:=ttype.create;
                         t.where.Y:=i;
                         t.Typ:='forwarder';
                         t.Kind:=tk1;
                         t.Return:=tk4;  
                         if pos('(',tk4)>0 then begin
                            t.Return:=copy(tk4,1,pos('(',tk4)-1);
                            t.Forwarder:=t.Return;
                            t.ForwarderType:=TypExists(t.Forwarder);
                            t.Params:=copy(lz,pos('(',lz)+1,pos(')',lz)-pos('(',lz)-1);
                         end else begin
                            t.forwarder:=tk4;
                            t.ForwarderType:=TypExists(t.Forwarder);
                            t.Return:='Forwarder';
                            t.Params:='';
                         end;
                         if (comparetext(t.forwarder,'sub')=0) or
                            (comparetext(t.forwarder,'function')=0) then t.kind:='event';
                         if (comparetext(tk5,'ptr')=0) or
                            (comparetext(tk5,'pointer')=0) then t.kind:='pointer';
                         t.Hosted:=tk2;
                         t.Module:=ffilename;
                         x:=types.IndexOf(t.Hosted);
                         if x=-1 then begin
                            types.AddObject(t.Hosted,t) ;
                            Launcher.Types.AddObject(t.Hosted,t) ;
                         end;
                         intype:=false;
                      end ;
                      if (tk3='') or (comparetext(tk3,'extends')<>0) and (comparetext(tk3,'as')<>0) then begin
                         t:=ttype.create;
                         t.where.Y:=i;
                         t.Hosted:=tk2;
                         t.Typ:='struct';
                         t.Kind:=tk1;
                         t.Module:=ffilename;
                         x:=types.IndexOf(t.Hosted);
                         if x=-1 then begin
                            types.AddObject(t.Hosted,t) ;
                            Launcher.Types.AddObject(t.Hosted,t) ;
                         end;
                         intype:=true;
                      end ;

                   end ; { extends, forwarder}
                   skptyp:
                end; { end type }

                if intype and (wc=1) then begin
                   if comparetext(lz,'public')=0 then visibility:='public';
                   if comparetext(lz,'private')=0 then visibility:='private';
                   if comparetext(lz,'protected')=0 then visibility:='protected';
                end; { visibilitty }

                if intype and (wc>=1) then begin

                   if tokenCount('as')=1 then begin
                      if wc=3 then begin
                         if comparetext(tk1,'as')=0 then begin
                            if pos(',',tk3)>0 then begin
                               w.Text:=trim(stringreplace(tk3,',',#10,[rfreplaceall]));
                               x:=0;
                               repeat
                                     f:=tfield.create;
                                     f.where.Y:=i;
                                     f.kind:=tk2;
                                     f.typ:='field';
                                     f.return:=tk2;
                                     f.Hosted:=trim(w[x]);
                                     f.Visibility:=visibility;
                                     if t<>nil then begin
                                        t.Fields.AddObject(f.Hosted,f);
                                        f.Owner:=t;
                                     end ;
                                     inc(x);
                               until x>w.Count-1;
                            end else begin { no comma }
                               f:=tfield.create;
                               f.where.Y:=i;
                               f.kind:=tk2;
                               f.typ:='field';
                               f.return:=tk2;
                               f.Hosted:=tk3;
                               f.Visibility:=visibility;
                               if t<>nil then begin
                                  t.Fields.AddObject(f.Hosted,f);
                                  f.Owner:=t;
                               end
                            end
                         end;
                         if comparetext(tk2,'as')=0 then begin
                            f:=tfield.create;
                            f.where.Y:=i;
                            f.kind:=tk3;
                            f.typ:='field';
                            if pos('(',tk3)>0 then begin
                               f.return:=copy(tk3,1,pos('(',tk3)-1);
                               f.Params:=trim(copy(tk3,pos('(',tk3)+1,pos(')',tk3)-pos('(',tk3)+1))
                            end else
                            f.return:=tk3;
                            f.Hosted:=tk1;
                            f.Visibility:=visibility;
                            if t<>nil then begin
                               t.Fields.AddObject(f.Hosted,f);
                               f.Owner:=t;
                            end
                         end;
                      end;
                   end; { 'as' count=1 }

                   if comparetext(tk1,'declare')=0 then begin
                      //if (wc=5) then begin
                      if (comparetext(tk2,'static')=0) or
                         (comparetext(tk2,'abstract')=0) or
                         (comparetext(tk2,'virtual')=0) then begin
                         f:=tfield.create;
                         f.where.Y:=i;
                         f.kind:=tk3;
                         f.typ:='field';
                         f.Visibility:=visibility;
                         if pos('(',tk4)>0 then begin
                           f.Hosted:=copy(tk4,1,pos('(',tk4)-1);
                           f.Params:=copy(tk3,pos('(',tk4),pos(tk4,')')-pos('(',tk4)-1)
                         end else
                           f.Hosted:=tk4;
                         if comparetext(tk5,'as')=0 then
                            f.Return:=tk6+'-'+'let';
                         if t<>nil then begin
                            t.Fields.AddObject(f.Hosted,f);
                            f.Owner:=t;
                         end
                      end else begin
                         f:=tfield.create;
                         f.where.Y:=i;
                         f.kind:=tk2;
                         f.typ:='field';
                         if pos('(',tk3)>0 then begin
                            f.Params:=copy(tk3,pos('(',tk3),pos(')',tk3)-pos('(',tk3)-1);
                            if comparetext(tk4,'as')=0 then
                               f.Return:=tk5+'-'+'let';
                            f.Hosted:=copy(tk3,1,pos('(',tk3)-1)
                         end else
                         f.Hosted:=tk3;
                         f.Visibility:=visibility;
                         //if t<>nil then begin
                            if (comparetext(tk2,'constructor')=0) and (f.Hosted='') then begin
                               f.Hosted:='constructor '+t.Hosted;
                               f.Owner:=t;
                            end;
                            if (comparetext(tk2,'destructor')=0) and (f.Hosted='') then begin
                               f.Hosted:='destructor '+t.Hosted;
                               f.Owner:=t;
                            end;
                            f.Owner:=t;
                            t.Fields.AddObject(f.Hosted,f);
                         //end;
                      //end;
                   end

                end;

             end; { field }  (**)

             if not intype then begin
                f:=nil;
                
                if (comparetext(tk1,'end')=0) and (comparetext(tk2,'enum')=0) then inEnum:=false;

                if comparetext(tk1,'enum')=0 then begin
                   f:=TField.create;
                   f.Where.Y:=i;
                   f.Hosted:=tk2;
                   f.Kind:='enum';
                   if intype then begin
                      f.Owner:=t;
                      t.Enums.AddObject(f.Hosted,f) ;
                   end else fEnums.AddObject(f.Hosted,f);
                   inEnum:=true;
                end;

                if inenum then begin
                   if pos('enum',lowercase(lz))=0 then begin
                      if pos(',',lz)>0 then begin
                         w.Text:=stringreplace(SkipBlank(lz),',',#10,[rfreplaceall]);
                         for x:=0 to w.Count-1 do begin
                             fs:=TField.create;
                             fs.Where.Y:=i;
                             fs.Where.X:=GetX(w[x]);
                             fs.Kind:='enum-field';
                             fs.Hosted:=w[x];
                             if f<>nil then begin
                                fs.Typ:=f.Hosted;
                                f.Fields.AddObject(fs.Hosted,fs)
                             end
                         end
                      end
                   end
                end;

                if comparetext(tk1,'constructor')=0 then begin
                   if pos('(',tk2)>0 then tk2:=copy(tk2,1,pos('(',tk2)-1);
                   t:=TypExists(tk2);
                   if t<>nil then begin
                      f:=t.FieldExists('constructor '+t.Hosted);
                      if f<>nil then begin
                         Cstr:=f;
                         if t<>nil then Cstr.Owner:=t;
                      end;
                   end
                end;

                if comparetext(tk1,'destructor')=0 then begin
                   if pos('(',tk2)>0 then tk2:=copy(tk2,1,pos('(',tk2)-1);
                   t:=TypExists(tk2);
                   if t<>nil then begin
                      f:=t.FieldExists('destructor '+t.Hosted);
                      if f<>nil then begin
                         Dstr:=f;
                         if t<>nil then Dstr.Owner:=t;
                      end;
                   end
                end;

                if Cstr<>nil then begin 
                   f:=nil;
                   v:='';
                   p:='';
                   c:='';
                   if pos('''',v)>0 then v:=trim(copy(v,1,pos('''',v)-1));
                   if pos('(',lz)>0 then
                      prm:=trim(copy(lz,pos('(',lz)+1,pos(')',lz)-pos('(',lz)-1));
                   if pos('=',lz)>0 then begin
                      p:=trim(copy(lz,1,pos('=',lz)-1));
                      v:=trim(copy(lz,pos('=',lz)+1,length(lz)));
                      if pos('.',p)>0 then begin
                         c:=trim(copy(p,pos('.',p)+1,length(p)));
                         p:=trim(copy(p,1,pos('.',p)-1));
                      end
                   end else
                   if pos('(',lz)>0 then begin
                      p:=trim(copy(lz,1,pos('(',lz)-1));
                      prm:=trim(copy(lz,pos('(',lz)+1,pos(')',lz)-pos('(',lz)-1));
                      if pos('.',p)>0 then begin
                         c:=trim(copy(p,pos('.',p)+1,length(p)));
                         p:=trim(copy(p,1,pos('.',p)-1));
                      end
                   end ; 

                   if p<>'' then begin 
                      f:=TField.create;
                      f.Where.Y:=i;
                      f.Hosted:=p;
                      f.Value:=v;
                      f.Return:=c;
                      f.Params:=prm;
                      f.Owner:=Cstr;
                      f.Kind:='constructor-field';
                      Cstr.Fields.AddObject(f.Hosted,f);
                      if Cstr.Owner<>nil then begin  
                         fs:=Cstr.FieldExists(p);
                         if fs<>nil then begin 
                            fs.Value:=v;       
                         end ;
                      end;
                           
                   end;

                   if assigned(fscanconstructor) then fscanconstructor(self,cstr,f,lz);
                end;

                if (comparetext(tk1,'var')=0) and not Local then begin
                   if pos('=',lz)>0 then begin
                      p:=trim(copy(lz,1,pos('=',lz)-1));
                      p:=trim(copy(p,pos('var ',lowercase(lz))+3,length(p)));
                      v:=trim(copy(lz,pos('=',lz)+1,length(lz)));
                      if pos('''',v)>0 then v:=trim(copy(v,1,pos('''',v)-1));

                      f:=TField.create;
                      f.Where.Y:=i;
                      f.Hosted:=p;
                      f.Kind:='variable';
                      f.Typ:=v;
                      f.Value:=v;
                      f.Return:=v;
                      t:=typexists(v);
                      if t<>nil then
                         f.Owner:=t ;
                      fvariables.AddObject(f.Hosted,f)
                    end
                end;

                if (inType=false) and (comparetext(tk1,'declare')<>0) then begin
                   if comparetext(tk1,'function')=0 then begin
                      Local:=true;
                      if pos('.',tk2)>0 then begin
                         p:=copy(tk2,1,pos('.',tk2)-1);
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,pos('.',tk2)+1,pos('(',tk2)-pos('.',tk2)-1)
                         else
                            v:=copy(tk2,pos('.',tk2)+1,length(tk2));
                         F:=TField.create;
                         F.Hosted:=p+'.'+v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='function';
                         F.Return:=copy(lz,lastdelimiter(' as ',lowercase(lz))+4,length(lz));
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fFuncs.AddObject(F.Hosted,F)
                      end else begin
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,1,pos('(',tk2)-1)
                         else
                            v:=tk2;
                         F:=TField.create;
                         F.Hosted:=v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='function';
                         F.Return:='';
                         F.Return:=copy(lz,lastdelimiter(' as ',lowercase(lz))+4,length(lz));
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fFuncs.AddObject(F.Hosted,F)
                      end;
                   end;
                   if comparetext(tk1,'sub')=0 then begin
                      Local:=true;
                      if pos('.',tk2)>0 then begin
                         p:=copy(tk2,1,pos('.',tk2)-1);
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,pos('.',tk2)+1,pos('(',tk2)-pos('.',tk2)-1)
                         else
                            v:=copy(tk2,pos('.',tk2)+1,length(tk2));
                         F:=TField.create;
                         F.Hosted:=p+'.'+v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='sub';
                         F.Return:='';
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fsubs.AddObject(F.Hosted,F)
                      end else begin
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,1,pos('(',tk2)-1)
                         else
                           v:=tk2;
                         F:=TField.create;
                         F.Hosted:=v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='sub';
                         F.Return:='';
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fsubs.AddObject(F.Hosted,F)
                      end;
                   end;
                   if comparetext(tk1,'operator')=0 then begin
                      Local:=true;
                      if pos('.',tk2)>0 then begin
                         p:=copy(tk2,1,pos('.',tk2)-1);
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,pos('.',tk2)+1,pos('(',tk2)-pos('.',tk2)-1)
                         else
                            v:=copy(tk2,pos('.',tk2)+1,length(tk2));
                         F:=TField.create;
                         F.Hosted:=p+'.'+v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='operator';
                         if comparetext(tk3,'as')=0 then
                            F.Return:=copy(lz,lastdelimiter(' as ',lowercase(lz))+4,length(lz));
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fOperators.AddObject(F.Hosted,F)
                      end else begin
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,1,pos('(',tk2)-1)
                         else
                            v:=tk2;
                         F:=TField.create;
                         F.Hosted:=v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='operator';
                         F.Return:='';
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fOperators.AddObject(F.Hosted,F)
                      end;
                   end;
                   if comparetext(tk1,'property')=0 then begin
                      Local:=true;
                      if pos('.',tk2)>0 then begin
                         p:=copy(tk2,1,pos('.',tk2)-1);
                         if pos('(',tk2)>0 then
                            v:=copy(tk2,pos('.',tk2)+1,pos('(',tk2)-pos('.',tk2)-1)
                         else
                            v:=copy(tk2,pos('.',tk2)+1,length(tk2));
                         F:=TField.create;
                         F.Hosted:=p+'.'+v;
                         F.Where.X:=GetX(tk2);
                         F.Where.Y:=i;
                         F.Kind:='property';
                         if comparetext(tk3,'as')=0 then
                            F.Return:=copy(lz,lastdelimiter(' as ',lowercase(lz))+4,length(lz));
                         F.Params:=copy(lz,pos('(',lz)+1,lastdelimiter(')',lz)-1);
                         fProperties.AddObject(F.Hosted,F)
                      end;
                   end;
                end ;

                if Local=false then
                if (comparetext(tk1,'dim')=0)  and not inType then begin
                   if comparetext(tk2,'shared')=0 then begin
                      if comparetext(tk3,'as')=0 then begin
                         if compareText(tk5,'ptr')=0 then tk5:=tk6;
                         if (pos(',',tk5)=0) then begin
                            F:=TField.create;
                            F.Kind:='variable';
                            F.Typ:='shared';
                            F.Where.Y:=i;
                            F.Return:=tk4;
                            F.Hosted:=TK5;
                            fVariables.AddObject(F.Hosted,F);
                         end else begin
                            L:=TStringList.Create;
                            L.Text:=StringReplace(tk5,',',#10,[rfreplaceall]);
                            for x:=0 to L.Count-1 do begin
                                F:=TField.create;
                                F.Kind:='variable';
                                F.Typ:='shared';
                                F.Where.Y:=i;
                                F.Return:=tk4;
                                F.Hosted:=L[x];
                                fVariables.AddObject(F.Hosted,F);
                            end
                         end
                      end else begin
                          F:=TField.create;
                          F.Kind:='variable';
                          F.Typ:='shared';
                          F.Where.Y:=i;
                          F.Return:=tk5;
                          F.Hosted:=TK3;
                          fVariables.AddObject(F.Hosted,F);
                      end
                   end else begin
                      if comparetext(tk2,'as')=0 then begin
                         if pos(',',tk4)=0 then begin
                            F:=TField.create;
                            F.Kind:='variable';
                            F.Typ:='local';
                            F.Where.Y:=i;
                            F.Return:=tk3;
                            F.Hosted:=TK4;
                            fVariables.AddObject(F.Hosted,F);
                         end else begin
                            L:=TStringList.Create;
                            L.Text:=StringReplace(tk5,',',#10,[rfreplaceall]);
                            for x:=0 to L.Count-1 do begin
                                F:=TField.create;
                                F.Kind:='variable';
                                F.Typ:='local';
                                F.Where.Y:=i;
                                F.Return:=tk3;
                                F.Hosted:=L[x];
                                fVariables.AddObject(F.Hosted,F);
                            end
                         end
                      end else begin
                          F:=TField.create;
                          F.Kind:='variable';
                          F.Typ:='shared';
                          F.Where.Y:=i;
                          F.Return:=tk4;
                          F.Hosted:=TK2;
                          fVariables.AddObject(F.Hosted,F);
                      end
                   end
                end
             end;
             inc(j);
          until j>b.count-1;

          skip:
          inc(i);
    until i>count-1;
    l.free;
    b.free;
    w.free;
    try
      filltree;
    except end;

    for k:=0 to high(regclasses) do
        for i:=0 to regclasses[k].Count-1 do begin
            x:=Launcher.Types.IndexOf(regclasses[k][i]);
            if x>-1 then
               regclasses[k].Objects[i]:=TType(Launcher.Types.Objects[x]);
        end;

    Launcher.Lib.MainFile:=ideDir+'gui\core.bi';
    Launcher.ClassPalettes:=regclasses;
    Launcher.SetClassTypes;

end;

procedure TScanner.FillTree;
var
   i,j:integer;
   P:TTreeNode;
   F:TField;
   T:TType;
   function Find(v:string):TTreeNode;
   var
      i:integer;
   begin
      result:=nil;
      if v='' then exit;
      for i:=0 to fTree.Items.Count-1 do
          if CompareText(ftree.Items[i].Text,v)=0 then begin
             result:=ftree.Items[i];
             break
          end
   end;
begin
   if ftree=nil then exit;
   ftree.Items.Clear;

   if fEnums.Count>0 then begin
      ftree.Items.AddObject(nil,'Enums',ftypes);
      P:=find('enums');
      for i:=0 to fenums.Count-1 do begin
          F:=TField(fenums.Objects[i]);
          if F<>nil then begin
             ftree.Items.AddChildObject(P,F.Hosted,F);
          end
      end
   end;

   if ftypes.Count>0 then begin
      ftree.Items.AddObject(nil,'Types',ftypes);
      P:=find('types');
      for i:=0 to ftypes.Count-1 do begin
          T:=TType(ftypes.Objects[i]);
          if T<>nil then begin
             if T.Extends<>'' then begin
                if Find(T.EXtends)<>nil then
                   ftree.Items.AddChildObject(Find(T.EXtends),T.Hosted,T)
                else
                   ftree.Items.AddChildObject(Find('types'),T.Hosted,T);
             end else
             if T.Forwarder<>'' then
                ftree.Items.AddChildObject(Find(T.forwarder),T.Hosted,T)
             else
                ftree.Items.AddChildObject(P,T.Hosted,T);

          end else tree.Items.AddChildObject(P,ftypes[i],nil);
      end;
   end;

   for i:=0 to ftypes.Count-1 do begin
       T:=TType(ftypes.Objects[i]);
       if T<>nil then begin
          P:=Find(T.Hosted);
          for j:=0 to T.FieldCount-1 do
              ftree.Items.AddChildObject(P,T.Field[j].Hosted,t.Field[j])
       end
   end;

   if fVariables.Count>0 then begin
      ftree.Items.AddObject(nil,'Variables',fvariables);
      P:=find('variables');
      for i:=0 to fvariables.Count-1 do begin
          F:=TField(fvariables.Objects[i]);
          if F<>nil then ftree.Items.AddChildObject(P,F.Hosted,F);
      end;
   end;

   if fFuncs.Count>0 then begin
      ftree.Items.AddObject(nil,'Functions',ffuncs);
      P:=find('functions');
      for i:=0 to fFuncs.Count-1 do begin
          F:=TField(fFuncs.Objects[i]);
          if F<>nil then ftree.Items.AddChildObject(P,F.Hosted,F);
      end;
   end;

   if fSubs.Count>0 then begin
      ftree.Items.AddObject(nil,'Subroutines',fsubs);
      P:=find('subroutines');
      for i:=0 to fsubs.Count-1 do begin
          F:=TField(fsubs.Objects[i]);
          if F<>nil then ftree.Items.AddChildObject(P,F.Hosted,F);
      end;
   end;

   if fProperties.Count>0 then begin
      ftree.Items.AddObject(nil,'Properties',fProperties);
      P:=find('properties');
      for i:=0 to fproperties.Count-1 do begin
          F:=TField(fproperties.Objects[i]);
          if F<>nil then ftree.Items.AddChildObject(P,F.Hosted,F);
      end;
   end;

   if fOperators.Count>0 then begin
      ftree.Items.AddObject(nil,'Operators',fOperators);
      P:=find('Operators');
      for i:=0 to fOperators.Count-1 do begin
          F:=TField(fOperators.Objects[i]);
          if F<>nil then ftree.Items.AddChildObject(P,F.Hosted,F);
      end;
   end;

   ftree.FullExpand ;
end;

procedure TScanner.Execute;
begin
   if fEdit<>nil then
      Assign(fEdit.Lines);
   Scan;
   FillTree
end;

function TScanner.TypExists(v:string):TType;
var
   i:integer;
begin
   result:=nil;
   for i:=0 to typcount-1 do
       if (comparetext(typ[i].Hosted,v)=0) or (comparetext(typ[i].Alias,v)=0) then begin
           result:=typ[i];
           break
       end
end;

function TScanner.FieldExists(v:string;intype:boolean=false):TField;
var
   i,j:integer;
   F:TField;
begin
    result:=nil;
    for i:=0 to typcount-1 do begin
        result:=typ[i].FieldExists(v);
        if intype then exit;
    end;
    for i:=0 to fvariables.Count-1 do begin
        F:=TField(fvariables.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
    for i:=0 to fconstants.Count-1 do begin
        F:=TField(fconstants.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
    for i:=0 to fenums.Count-1 do begin
        F:=TField(fenums.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
    for i:=0 to funions.Count-1 do begin
        F:=TField(funions.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
    for i:=0 to fsubs.Count-1 do begin
        F:=TField(fsubs.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
    for i:=0 to ffuncs.Count-1 do begin
        F:=TField(ffuncs.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
    for i:=0 to foperators.Count-1 do begin
        F:=TField(foperators.Objects[i]);
        if F<>nil then begin
           if comparetext(v,F.Name)=0 then begin
              result:=F;
              break
           end ;
           for j:=0 to F.FieldCount-1 do begin
               if comparetext(F.Field[j].Name,v)=0 then begin
                  result:=F.Field[J];
                  break
               end
           end
        end
    end ;
end;

end.
