unit FreeBasicRTTI;

interface

uses
    SysUtils, Windows, Classes, Controls, TypesUnit, HelperUnit, Dialogs;

type
    TFieldTypeKind=(ftkUnknown,ftkByte,ftkShort,ftkLong,ftkInteger,ftkSingle,ftkDouble,ftkZString,ftkString,ftkType,ftkEvent);
    TFieldKind=(fkUnknown,fkFunction,fkSub,fkOperator,fkProperty);

    function RTTIGetProperties(n:string;L:TStrings;visibility:string='public'):integer;
    function RTTIGetEvents(n:string;L:TStrings;visibility:string='public'):integer;
    function RTTIGetFields(n:string;L:TStrings):integer;
    function RTTIGetFieldValue(Typ:TType; v:string):Pointer;
    function RTTIGetFieldType(Typ:TType; v:string):TFieldKind;
    function RTTIGetFieldKind(Typ:TType; v:string):TFieldTypeKind;
    function RTTIInheritFrom(t,v:string):TType;

implementation

uses MainUnit, LauncherUnit;

function RTTIGetFieldType(Typ:TType; v:string):TFieldKind;
var
   F:TField;
   i:integer;
   L:TStrings;
begin
    result:=fkUnknown;
    if (typ=nil) or (v='') then exit;
    L:=TStringList.Create;
    RTTIGetFields(typ.Name,L);
    i:=L.IndexOf(v);
    if i=-1 then begin
       messageDlg(format('The ''%s'' not exists in base class.',[v]),mtError,[mbok],0);
       exit;
    end else begin
       F:=TField(L.Objects[i]);
       if F<>nil then
       if CompareText(F.Kind,'function')=0 then
          result:=fkFunction
       else if CompareText(F.Kind,'sub')=0 then
          result:=fkSub
       else if CompareText(F.Kind,'operator')=0 then
          result:=fkOperator
       else if CompareText(F.Kind,'property')=0 then
          result:=fkProperty
       else
          result:=fkUnknown
    end;
    L.Free
end;

function RTTIGetFieldKind(Typ:TType; v:string):TFieldTypeKind;
var
   F:TField;
   i:integer;
   L:TStrings;
begin
    result:=ftkUnknown;
    if (typ=nil) or (v='') then exit;
    L:=TStringList.Create;
    RTTIGetFields(typ.Name,L);  
    i:=L.IndexOf(v);
    if i=-1 then begin
       messageDlg(format('The ''%s'' not exists in base class.',[v]),mtError,[mbok],0);
       exit;
    end else begin
       F:=TField(L.Objects[i]);
       if F<>nil then
       if CompareText(F.Return,'byte')=0 then
          result:=ftkByte
       else if CompareText(F.Return,'integer')=0 then
          result:=ftkInteger
       else if CompareText(F.Return,'long')=0 then
          result:=ftkLong
       else if CompareText(F.Return,'short')=0 then
          result:=ftkShort
       else if CompareText(F.Return,'single')=0 then
          result:=ftkSingle
       else if CompareText(F.Return,'double')=0 then
          result:=ftkDouble
       else if CompareText(F.Return,'zstring ptr')=0 then
          result:=ftkZString
       else if CompareText(F.Return,'string')=0 then
          result:=ftkString
       else if CompareText(F.Return,'type')=0 then
          result:=ftkType
       else if CompareText(F.Return,'event')=0 then
          result:=ftkEvent
       else
          result:=ftkUnknown
    end;
    L.Free
end;

function RTTIGetFieldValue(Typ:TType; v:string):pointer;
var
   x,i,j,vl,e:integer;
   F:TField;
   L:TStrings;
   Tk:TFieldTypeKind;
begin
    result:=nil;
    if (typ=nil) or (v='') then exit;
    L:=TStringList.Create;
    RTTIGetFields(Typ.Name,L);
    if L.Count=0 then
       RTTIGetFields(Typ.Hosted,L);
    x:=L.IndexOf(v);
    if x=-1 then begin
       messageDlg(format('The ''%s'' field not exists.',[v]),mtError,[mbok],0);
       exit;
    end else begin
        for i:=0 to L.Count-1 do begin
             F:=TField(L.Objects[i]);
             if F<>nil then begin
                if pos('::',F.Name)>0 then begin
                   for j:=0 to F.FieldCount-1 do begin
                       if CompareText(F.Field[j].Name,v)=0 then begin
                          Tk:=RTTIGetFieldKind(Typ,F.Field[j].Name);
                          case Tk of
                          ftkByte,ftkShort,ftkInteger,ftkLong:begin
                              val(F.Field[j].Value,vl,e);
                              if e=0 then
                                 result:=Pointer(vl)
                              else
                                 result:=nil;
                              end;
                          ftkZString,ftkString:begin
                              result:=PChar(F.Field[j].Value);
                              end
                          end;
                          break
                       end
                   end
                end
             end
        end
    end;
    L.Free;
end;

function RTTIGetProperties(n:string;L:TStrings;visibility:string='public'):integer;
   var
      typ:TType;
      j:integer;
      F:TField;
   begin
       result:=0;
       if (n='') or (L=nil) then exit;
       typ:=Launcher.Lib.TypExists(n);
       if typ<>nil then begin
          for j:=0 to typ.FieldCount-1 do begin
              F:=typ.Field[j];
              if CompareText(F.Kind,'property')=0 then begin
                 if visibility<>'' then begin
                    if comparetext(f.Visibility,visibility)=0 then
                       L.AddObject(F.Hosted,F);
                 end else L.AddObject(F.Hosted,F);
              end
          end;
          RTTIGetProperties(typ.Extends,L);
       end ;
       result:=L.Count ;
end;

function RTTIGetEvents(n:string;L:TStrings;visibility:string='public'):integer;
   var
      typ:TType;
      j:integer;
      F:TField;
      B:TStrings;
   begin
       result:=0;
       if (n='') or (L=nil) then exit;
       if L.Count>0 then L.Clear;
       B:=TStringList.create;
       typ:=Launcher.TypeExists(n);
       if typ=nil then exit;
       RTTIGetFields(n,B);
       if B.Count>0 then begin
          for j:=0 to B.Count-1 do begin
              F:=TField(B.Objects[j]);
              if F<>nil then begin
                 if (pos('event',lowercase(F.Return))>0) or
                    (comparetext('sub',lowercase(F.Return))=0) or
                    (comparetext('function',lowercase(F.Return))=0) then begin
                    L.AddObject(F.Hosted,F);
                 end
              end
          end;
          try
             if typ<>nil then
                RTTIGetEvents(typ.Extends,B);
          except
             messageDlg('Internal error $rev: can''t read events',mtError,[mbok],0);
          end;
       end;
       result:=B.Count ;
       B.Free
end;

function RTTIGetFields(n:string;L:TStrings):integer;
   var
      typ:TType;
      j:integer;
      F:TField;
   begin
       result:=0;
       if (n='') or (L=nil) then exit;
       typ:=Launcher.Lib.TypExists(n);
       if typ<>nil then begin
          for j:=0 to typ.Fields.Count-1 do begin
              F:=typ.Field[j];
              if F<>nil then
                 L.AddObject(F.Hosted,F)
          end;
          RTTIGetFields(typ.Extends,L);
       end ;
       result:=L.Count;
end;

function RTTIInheritFrom(t,v:string):TType;
var
   typ,ityp:TType;
begin
    typ:=Launcher.TypeExists(t);
    ityp:=Launcher.TypeExists(v);
    if iTyp=nil then exit;
    if t=ityp.Extends then begin
       result:=ityp;
       exit
    end else result:=RTTIInheritFrom(t,ityp.Extends)
end;

end.
