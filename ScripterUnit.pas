unit ScripterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, LauncherUnit, DialogUnit, ContainerUnit, TypInfo,
  StrUtils, CompilerUnit;


type
   TScripter=class(TStringList)
   private
     fKeywords,fVariables,fConstants,fProperties :TStrings;
     fFileName :string;
     procedure SetFileName(v :string);
   protected
     procedure ResolveAssignment(Line:string);
     procedure ResolveExpression(Tx:string);
   public
     Launcher:TLauncher;
     Compiler :TCompiler;
     constructor Create;
     destructor Destroy; override;
     function Execute:string;
     property FileName :string read fFileName write SetFileName;
     property Keywords :TStrings read fKeywords write fKeywords;
     property Constants :TStrings read fConstants write fConstants;
   end;

var
   Scripter :TScripter;

implementation

uses MainUnit,PageSheetUnit;

procedure TScripter.SetFileName(v :string);
begin
   fFileName:=v;
   if FileExists(v) then begin
      LoadFromFile(v);
   end
end;

procedure TScripter.ResolveAssignment(Line:string);
begin
end;

procedure TScripter.ResolveExpression(Tx:string);
begin
end;

function TScripter.Execute:string;
var
   i, LineIndex :integer;
   t,ident,prop,AssignTo,prm:string;
   C:TContainer;
   Pg:TPageSheet;
   Dlg:TDialog;
   lastObj:TObject;
   procedure DealColor(v:string;inter:string='i');
   var
      x:integer;
   begin
      if CompareText(inter,'i')=0 then begin
         for x:=0 to Application.ComponentCount-1 do
             if GetPropInfo(Application.Components[x],'color')<>nil then
                SetPropValue(Application.Components[x],'color',StringToColor(v))
      end
   end;
begin
    result:='success.';
    i:=1;
    LineIndex:=0;
    repeat
          if text[i]=';' then begin
             repeat
                   inc(i);
                   if text[i]=#10 then break;
             until i>length(text);
          end;
          t:=t+text[i];
          if text[i]='-' then begin   ;
             ident:=trim(copy(t,1,length(t)-1));
             t:='';
             repeat
                   inc(i);
                   if (text[i]=#34) or (text[i]=#10) or (text[i]='[') then begin
                      prop:=trim(t);
                      break;
                   end;
                   t:=t+text[i];
             until (i>length(text));
             t:='';
          end;
          if text[i]='[' then begin
             prm:='';
             repeat
                   inc(i);
                   prm:=prm+text[i];
                   if text[i]=']' then begin
                      prm:=copy(prm,1,length(prm)-1);
                      break
                   end;
             until i>length(text);
          end;
          if text[i]=#34 then begin
             prm:='';
             repeat
                   inc(i);
                   if text[i]=#34 then break;
                   prm:=prm+text[i];
             until i>length(text);
          end;
          if text[i]=#10 then begin
             inc(LineIndex);

             if fKeywords.indexof(ident)>-1 then begin
                 if (compareText(ident,'interface')=0) or (compareText(ident,'i')=0) then begin
                    if fProperties.IndexOf(prop)>-1 then begin
                       if compareText(prop,'color')=0 then DealColor(prop)
                    end else
                        result:=format('unknown property [%s]',[prop])
                 end else
                 if compareText(ident,'new')=0 then begin
                    if fProperties.IndexOf(prop)>-1 then begin
                       if compareText(prop,'page')=0 then begin
                          lastObj:=newEditor(prm);
                          prm:='';
                       end else
                       if compareText(prop,'dialog')=0 then begin
                          lastObj:=newDialog(prm);
                          prm:='';
                       end else
                       if Launcher.Classes.IndexOf(prop)=-1 then begin
                          if ActiveDialog<>nil then begin
                             C:=TContainer.create(ActiveDialog);
                             C.Parent:=ActiveDialog;
                             C.Typ.Hosted:=prop;
                          end;
                       end
                    end else
                        result:=format('unknown property [%s]',[prop])
                 end else
                 if compareText(ident,'page')=0 then begin
                    if pos('=',prop)>0 then begin
                       prm:=trim(copy(prop,pos('=',prop)+1,length(prop)));
                       prop:=trim(copy(prop,1,pos('=',prop)-1));
                       if GetPropInfo(lastObj,prop)<>nil then
                          SetPropValue(lastObj,prop,prm);
                    end;
                 end else
                 if compareText(ident,'compile')=0 then begin
                    if fProperties.IndexOf(prop)>-1 then begin
                       Compiler.Params:=prm;
                       Compiler.Compile;
                    end else
                        result:=format('unknown property [%s]',[prop])
                 end else
                 if compareText(ident,'compile_run')=0 then begin
                    if fProperties.IndexOf(prop)>-1 then begin
                       Compiler.Params:=prm;
                       Compiler.CompileRun;
                    end else
                        result:=format('unknown property [%s]',[prop])
                 end else
                 if compareText(ident,'run')=0 then begin
                    if fProperties.IndexOf(prop)>-1 then begin
                       Compiler.Outfile:=prm;
                       Compiler.Run;
                    end else
                        result:=format('unknown property [%s]',[prop])
                 end;
;
             end else result:=format('unknown ident [%s]',[ident]);
             t:=''; prm:=''; ident:=''; prop:='';
         end;
       inc(i) ;
    until i>length(text);
end;

constructor TScripter.Create;
begin
   fKeywords:=TStringList.Create;
   fKeyWords.Text:='new'#10'compile'#10'compile_run'#10'interface'#10'run'#10'var'#10'page'#10'dialog';
   fProperties:=TStringList.Create;
   fProperties.Text:='page'#10'dialog'#10'Font.Size'#10'Font.Name'#10'TextColor'#10'left'#10'top'#10'width'#10'height'#10'text'#10'color'#10'enabled'#10'visible';
   fConstants:=TStringList.Create;
   fVariables:=TStringList.Create;
end;

destructor TScripter.Destroy;
begin
   fKeywords.Free;
   fConstants.Free;
   fVariables.Free;
   inherited;
end;

end.
