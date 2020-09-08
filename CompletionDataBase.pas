unit CompletionDataBase;

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
  Dialogs, SynEdit, SynHighlighterAny, TypesUnit, iniFiles, HelperUnit,
  StrUtils, CompilerUnit, ComCtrls, CodeUnit, PageSheetUnit;

type
   TCompletionDataBaseEvent=procedure(Sender:TObject;F:string) of object;

   TCompletionDataBase=class(TStringList)
   private
      fOnFileEvent:TCompletionDataBaseEvent;
      fMask:string;
      fCompiler:TCompiler;
      fEditor:TPageSheet;
      fTypes,fVariables,fFuncs,fSubs,fUnions,fEnums,fOperators:TStrings;
      fInsertList,fItemList:TStringList;
      fWord:string;
      procedure SetCompiler(v:TCompiler);
      procedure SetEditor(v:TPageSheet);
      procedure SetMask(v:string);
   protected
   public
      constructor Create;overload;
      destructor Destroy;override;
      procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure Scan;
      property Mask:string read fMask write SetMask;
      property Compiler:TCompiler read fCompiler write SetCompiler;
      property Editor:TPageSheet read fEditor write SetEditor;
      property OnFileEvent:TCompletionDataBaseEvent read fonFileEvent write fOnFileEvent;
   end;

implementation

uses MainUnit, ScannerUnit, FreeBasicRTTI;

constructor TCompletionDataBase.Create;
begin
    inherited;
    fInsertList:=TStringList.Create;
    fItemList:=TStringList.Create;
    fTypes:=TStringList.Create;
    fVariables:=TStringList.Create;
    fFuncs:=TStringList.Create;
    fSubs:=TStringList.Create;
    fUnions:=TStringList.Create;
    fEnums:=TStringList.Create;
    fOperators:=TStringList.Create;
end;

destructor TCompletionDataBase.Destroy;
begin
    fInsertList.Free;
    fItemList.Free;
    fTypes.Free;
    fVariables.Free;
    fFuncs.Free;
    fSubs.Free;
    fUnions.Free;
    fEnums.Free;
    fOperators.Free;
    inherited
end;

procedure TCompletionDataBase.SetMask(v:string);
begin
    fMask:=v;
end;

procedure TCompletionDataBase.SetCompiler(v:TCompiler);
begin
    fCompiler:=v;
end;

procedure TCompletionDataBase.SetEditor(v:TPageSheet);
var
   i:integer;
   Sc:TScanner;
begin
    fEditor:=v;
    if (main<>nil) and (v<>nil) then begin
       if v.Scanner<>nil then v.Scanner.Scan;

       fTypes.AddStrings(v.Scanner.Types);
       fVariables.AddStrings(v.Scanner.Variables);
       fFuncs.AddStrings(v.Scanner.Funcs);
       fSubs.AddStrings(v.Scanner.Subs);

       fUnions.AddStrings(v.Scanner.Unions);
       fEnums.AddStrings(v.Scanner.Enums);
       fOperators.AddStrings(v.Scanner.Operators);

       if v.Scanner.Includes.Count>0 then
          for i:=0 to v.Scanner.Includes.Count-1 do begin
              Sc:=TScanner.Create;
              Sc.FileName:=v.Scanner.Includes[i];
              Sc.Scan;
              fTypes.AddStrings(Sc.Types);
              fVariables.AddStrings(Sc.Variables);
              fFuncs.AddStrings(Sc.Funcs);
              fSubs.AddStrings(Sc.Subs);
              fUnions.AddStrings(Sc.Unions);
              fEnums.AddStrings(Sc.Enums);
              fOperators.AddStrings(Sc.Operators);
              Sc.Free;
              
          end
      end

end;

procedure TCompletionDataBase.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   Line,s:string;
   i,x,Cx:integer;
   F:TField;
   T:TType;
begin  //$BC=','
    if not Launcher.AlowCompletion then begin inherited; exit; end;
    if key=$BE {'.'} then begin
       fInsertList.Clear;
       fEditor.Frame.CompletionProposal.InsertList.Clear;
       fItemList.Clear;
       fEditor.Frame.CompletionProposal.ItemList.Clear;
       Editor:=TPageSheet(TSynEdit(Sender).Parent.Parent);
       Line:=TSynEdit(Sender).LineText;
       Cx:=TSynEdit(Sender).CaretX;
       if Line<>'' then begin
          fWord:=LeftBStr(Line,Cx-2);
          x:=fVariables.IndexOf(fWord);
          if x>-1 then begin
             F:=TField(fVariables.Objects[x]);
             if (F<>nil) then
                if (fTypes.IndexOf(F.Return)>-1) then begin
                   T:=TType(fTypes.Objects[fTypes.IndexOf(F.Return)]);
                   if T<>nil then begin
                      T.ExtendsType:=Launcher.Lib.TypExists(T.Extends);
                      RTTIGetProperties(T.Extends,fInsertList);
                      fEditor.Frame.CompletionProposal.InsertList.Assign(fInsertList);
                      for i:=0 to fInsertList.Count-1 do begin
                          F:=TField(fInsertList.Objects[i]);
                          if F.Params<>'' then
                             s:=format('%s \column{}\style{+B}%s\style{-B}(%s)',[F.Kind,F.Hosted,F.Params])
                          else
                             s:=format('%s \column{}\style{+B}%s\style{-B}',[F.Kind,F.Hosted]);
                          fEditor.Frame.CompletionProposal.ItemList.Add(s)
                      end;
                   end;
                end
          end
       end;

    end; inherited;
end;

procedure TCompletionDataBase.Scan;
begin
end;

end.
