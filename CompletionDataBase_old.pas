unit CompletionDataBase_old;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, SynHighlighterAny, TypesUnit, iniFiles, HelperUnit,
  StrUtils, CompilerUnit, ComCtrls, CodeUnit, PageSheetUnit;

type
   TCompletionDataBaseEvent=procedure(Sender:TObject;F:string) of object; //stdcall;

   TFileStruct=class(TStringList)
   public
      Constants, Variables, Types, Functions, Procedures :TStrings;
      function FindW(v:string):TField;
      constructor Create;
      destructor Destroy; override;
   end;

   TCompletionDataBase=class(TStringList)
   private
      fCompiler:TCompiler;
      fInsertList, fConstants:TStringList;
      fBuffer,fFiles :TStrings;
      fPaths:TStringList;
      fFileName, fMask:string;
      fEdit:TSynEdit;
      fEditor:TPageSheet;
      fEvent:TCompletionDataBaseEvent;
      procedure SetFileName(v:string);
      procedure SetCompiler(v:TCompiler);
      procedure SetEdit(v:TSynEdit);
      procedure SetEditor(v:TPageSheet);
      procedure SetPaths(v:TStringList);
      procedure SetMask(v:string);
      function GetConstants:TStrings;
      procedure SetConstants(v:TStrings);
   protected
      fCommentsStr:string;
      procedure ListChange(Sender:TObject);
      procedure GetFiles;
      procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
   public
      Tree :TTreeView;
      constructor Create;
      destructor Destroy; override;
      procedure Scan;
      function ScanLine(v:string=''):string;
      procedure Save;
      function FindW(v:string):TField;
      property Editor:TPageSheet read fEditor write SetEditor;
      property Files:TStrings read fFiles;
   published
      property Constants:TStrings read GetConstants write SetConstants;
      property Mask:string read fmask write SetMask;
      property SearchingPaths:TStringList read fPaths write SetPaths;
      property InsertList:TStringList read fInsertList write fInsertList;
      property FileName:string read fFileName write SetFileName;
      property Edit:TSynEdit read fEdit write SetEdit;
      property Compiler:TCompiler read fCompiler write SetCompiler;
      property onFileEvent:TCompletionDataBaseEvent read fEvent write fEvent;
   end;

implementation

uses MainUnit;

{ TFileStruct }
constructor TFileStruct.Create;
begin
    Constants:=TStringList.Create;
    Variables:=TStringList.Create;
    Types:=TStringList.Create;
    Functions:=TStringList.Create;
    Procedures:=TStringList.Create;
end;

destructor TFileStruct.Destroy;
begin
    Constants.Free;
    Variables.Free;
    Types.Free;
    Functions.Free;
    Procedures.Free;
    inherited;
end;

function TFileStruct.FindW(v:string):TField;
var
   i:integer;
   F:TField;
begin
    result:=nil;
    if v='' then exit;
    i:=0;
    if Constants.Count>0 then
    repeat
         F:=TField(Constants.Objects[i]);
         if CompareText(v,F.Name)=0 then begin
            Result:=F;
            exit;
         end;
         inc(i);
    until i>Constants.Count-1;
    i:=0;
    if Variables.Count>0 then
    repeat
         F:=TField(Variables.Objects[i]);
         if CompareText(v,F.Name)=0 then begin
            Result:=F;
            exit;
         end;
         inc(i);
    until i>Variables.Count-1;
    i:=0;
    if Types.Count>0 then
    repeat
         F:=TField(Types.Objects[i]);
         if CompareText(v,F.Name)=0 then begin
            Result:=F;
            exit;
         end;
         inc(i);
    until i>Types.Count-1;
    i:=0;
    if Functions.Count>0 then
    repeat
        F:=TField(Functions.Objects[i]);
         if CompareText(v,F.Name)=0 then begin
            Result:=F;
            exit;
         end;
         inc(i);
    until i>Functions.Count-1;
    i:=0;
    if Procedures.Count>0 then
    repeat
        F:=TField(Procedures.Objects[i]);
         if CompareText(v,F.Name)=0 then begin
            Result:=F;
            exit;
         end;
         inc(i);
    until i>Procedures.Count-1;
end;

{ TCompletionDataBase }
constructor TCompletionDataBase.Create;
begin
   fConstants:=TStringList.Create;
   fInsertList:=TStringList.Create;
   fBuffer:=TStringList.Create;
   fPaths:=TStringList.Create;
   fPaths.OnChange:=ListChange;
   fFiles:=TStringList.Create;
   fMask:='*.*';
   fEvent:=Main.Scan;
   fCompiler:=Launcher.Compiler;
   GetFiles;
   Scan
end;

destructor TCompletionDataBase.Destroy;
begin
    fConstants.Free;
    fInsertList.Free;
    fBuffer.Free;
    fPaths.Free;
    fFiles.Free;
    inherited;
end;

function TCompletionDataBase.GetConstants:TStrings;
var
   i:integer;
   B:TFileStruct;
begin
    fConstants.Clear;
    for i:=0 to Count-1 do begin
        B:=TFileStruct(Objects[i]);
        if B<>nil then
           fConstants.AddStrings(B.Constants);
    end ;
    result:=fConstants
end;

procedure TCompletionDataBase.SetConstants(v:TStrings);
begin
    if v<>nil then
       fConstants.Assign(v);
end;

procedure TCompletionDataBase.SetMask(v:string);
begin
    fMask:=v;
end;

procedure TCompletionDataBase.SetCompiler(v:TCompiler);
begin
    fCompiler:=v;
    if v<>nil then begin
       fFileName:=ideDir+ChangeFileExt(ExtractFileName(v.FileName),'.txt');
       fPaths.Text:=(ExtractFilePath(v.FileName));
       if fPaths.IndexOf(fPaths.Text)=-1 then begin
          fPaths.Add(fPaths.Text);
          GetFiles;
       end
    end
end;

procedure TCompletionDataBase.ListChange(Sender:TObject);
begin

end;

procedure TCompletionDataBase.SetPaths(v:TStringList);
begin
    if v<>nil then
       fPaths.Assign(v)
    else
       fPaths.Clear;
    if fPaths.Count>0 then begin
       GetFiles;
       Scan;
    end;
end;

procedure TCompletionDataBase.GetFiles;
var
   i :integer;
begin
    fFiles.Clear;
    for i:=0 to fPaths.Count-1 do
        FindFiles(fFiles,ExtractFilePath(fPaths[i]),fMask);
end;

procedure TCompletionDataBase.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    inherited;
    if key=vk_return then begin
       ScanLine;
       if fEditor<>nil then
       with fEditor,Scanner do begin
            //CreateDialog:=false;
            Tree :=Tree;
            Edit:=Self.Edit;
       end
    end;
end;

function TCompletionDataBase.FindW(v:string):TField;
var
   i:integer;
   B:TFileStruct;
begin
    result:=nil;
    if v='' then exit;
    if fFiles.Count=0 then exit;
    i:=0;
    repeat
        B:=TFileStruct(Objects[i]);
        if B<>nil then begin
           result:=B.FindW(v);
           if result<>nil then break;
        end;
        inc(i);
    until i>Count-1;
end;

function TCompletionDataBase.ScanLine(v:string=''):string;
var
   i,x:integer;
   s:string;
begin
    if v='' then
       if fEdit<>nil then
          v:=fEdit.LineText;
    if (v<>'') and (fPaths.Count>0) then begin
       i:=fEdit.CaretX;
       x:=1;
       if i>x then
       repeat
           Application.ProcessMessages;
           s:=s+v[x];   
           if (v[x] in [' ','.','=','(','[','{',#10]) or (x=length(v)) then begin
              if x<length(v) then s:=copy(s,1,length(s)-1);  
              if FindW(s)<>nil then begin //IDebug('found: '+FindW(s).Name);
                 
              end;
              s:='';
           end;
           inc(x);
           dec(i);
       until i<1;
    end;
end;

procedure TCompletionDataBase.Scan;
var
   i,j,x:integer;
   s,w,pw,ext:string;
   F:TField;
   B:TFileStruct;
   Skiped:boolean;
   function isComment(v:string):integer;
   var
      i,was:integer;
   begin
       result:=-1;
       was:=0;
       for i:=1 to length(v) do begin
           if pos('/',v)>0 then begin
              inc(was);
              if was>1 then was:=0;
           end;
           if was>0 then begin
              result:=i;
              exit;
           end;
           if pos(v[i],fCommentsStr)>0 then result:=i;
       end;
   end;
   function isExclusionFile(v:string):integer;
   var
      E:TStrings;
   begin
      result:=-1;
      if v='' then exit;
      E:=TStringList.Create;
      E.Text:='.exe'#10'.dll'#10'.a'#10'.o'#10'.obj'#10'.lib'#10'.hex'#10'.html'#10'.raw'#10'.txt'#10'.log'#10'.ico'#10'.bmp'#10'.jpg'#10'.jpeg'#10'.png'#10'.gif';
      Result:=E.IndexOf(v)
   end;
begin
    if fMask='' then fMask:='*.*';
    if fFiles.Count=0 then GetFiles;
    if fFiles.Count=0 then exit;  Skiped:=false;
    fInsertList.Clear;
    Clear;
    F:=nil;
    i:=0;
    try
      repeat
        Application.ProcessMessages;
        if not FileExists(fFiles[i]) then exit;
        B:=TFileStruct.Create;
        ext:=ExtractFileExt(fFiles[i]); //idebug(ext);
        if isExclusionFile(ext)=-1 then begin(**)
           B.LoadFromFile(fFiles[i]);
           if Assigned(fEvent) then fEvent(self,ffiles[i]);
           end;
        if B.Count>0 then begin
           j:=0;
           try
             repeat
             Application.ProcessMessages;
             s:=trim(B[j]);
             if (s<>'') and (length(s)>=2) and (isComment(s)>-1) then
                Skiped:=true;
             if (s<>'') and (length(s)>=2) and (isComment(s)>-1) then
                Skiped:=false;
             if s<>'' then
                if isComment(s[1])>-1 then
                   Skiped:=true;
             if Skiped=false then begin
                w:='';
                for x:=1 to length(s) do begin
                    w:=w+lowercase(s[x]);
                    if (s[x] in [' ','.','=','(','[','{']) or (x=length(s)) then begin
                       if x<length(s) then
                          w:=copy(w,1,length(w)-1)
                       else
                          pw:='';
                       if (CompareText(w,'function')=0) and (pos('end',lowercase(s))=0) and (pos('=',s)=0) then begin
                             F:=TField.Create;
                             F.Where.X:=x+length(w);
                             F.Where.Y:=j;
                             F.Special:=s;
                             F.Kind:='function';
                             B.Functions.AddObject(F.Special,F); //ide.Results.Lines.Add(F.Special)
                       end;
                       if (CompareText(w,'type')=0) and (pos('end',lowercase(s))=0) and (pos('=',s)=0) then begin
                             F:=TField.Create;
                             F.Where.X:=x+length(w);
                             F.Where.Y:=j;
                             F.Special:=s;
                             F.Kind:='type';
                             B.Types.AddObject(F.Special,F); //ide.Results.Lines.Add(F.Special)
                       end;
                       if (CompareText(w,'const')=0) and (pos(':',lowercase(s))>0) or (pos('=',s)>0) then begin
                             F:=TField.Create;
                             F.Where.X:=x+length(w);
                             F.Where.Y:=j;
                             F.Special:=s;
                             F.Kind:='constant';
                             B.Constants.AddObject(F.Special,F); //ide.Results.Lines.Add(F.Special)
                       end;
                       if (CompareText(w,'var')=0) and (pos(':',lowercase(s))>0) or (pos('=',s)>0) then begin
                             F:=TField.Create;
                             F.Where.X:=x+length(w);
                             F.Where.Y:=j;
                             F.Special:=s;
                             F.Kind:='variable';
                             B.Variables.AddObject(F.Special,F); //ide.Results.Lines.Add(F.Special)
                       end;
                       if (CompareText(pw,'function')=0) or
                          (CompareText(pw,'type')=0) or
                          (CompareText(pw,'const')=0) or
                          (CompareText(pw,'dim')=0) or
                          (CompareText(pw,'common')=0) or
                          (CompareText(pw,'var')=0) then
                          if F<>nil then
                             F.Name:=w;
                       pw:=w;
                       w:='';
                    end
                end;
             end;
             inc(j);
           until j>B.Count-1;
        finally
        end;
        end;
        AddObject(fFiles[i],B);
        inc(i);
      until i>fFiles.Count-1;
    finally

    end;
    Save;
end;

procedure TCompletionDataBase.Save;
var
   i :integer;
   s :string;
   B :TFileStruct;
   L :TStrings;
begin
    s:=ExtractFilePath(ParamStr(0))+'DataBase';
    if not DirectoryExists(s) then
       CreateDir(s);
    s:=s+'\'+ChangeFileExt(ExtractFileName(fCompiler.FileName),'.txt');
    if FileExists(s) then DeleteFile(s);
    L :=TStringList.Create;

         for i:=0 to Count-1 do begin
             B:=TFileStruct(Objects[i]);
             if B<>nil then begin
                L.AddStrings(B.Constants);
                L.AddStrings(B.Variables);
                L.AddStrings(B.Types);
                L.AddStrings(B.Functions);
                L.AddStrings(B.Procedures);
             end;
         end;
         L.SaveToFile(s);
         L.Free;

end;

procedure TCompletionDataBase.SetFileName(v:string);
begin
    fFileName:=v;
    if FileExists(v) then begin
       Scan
    end;
end;

procedure TCompletionDataBase.SetEdit(v:TSynEdit);
begin
   fEdit:=v;
   if v<>nil then begin
      v.OnKeyDown:=EditKeyDown;
      try
         Scan
      finally
      end
   end
end;

procedure TCompletionDataBase.SetEditor(v:TPageSheet);
begin
   fEditor:=v;
   if v<>nil then Edit:=v.Frame.Edit;
end;

end.
