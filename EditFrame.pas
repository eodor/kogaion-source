unit EditFrame;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ComCtrls,
  Dialogs, SynEdit, ELSuperEdit, SynExportHTML, SynEditExport,
  SynExportRTF, SynHighlighterURI, SynHighlighterRC, SynCompletionProposal,
  SynEditOptionsDialog, SynEditMiscClasses, SynEditSearch, SynURIOpener,
  SynHighlighterAny, Menus, SynEditPrint, SynEditHighlighter,
  SynHighlighterMulti, SynHighlighterPython, SynHighlighterPerl,
  SynHighlighterXML, SynHighlighterVBScript, SynHighlighterPHP,
  SynHighlighterJScript, SynHighlighterHtml, SynHighlighterCSS, ImgList;

type
  TEditor = class(TFrame)
    Edit:TELSuperEdit; 
    EditPrint: TSynEditPrint;
    PopupMenu: TPopupMenu;
    menuUndo: TMenuItem;
    menuRedo: TMenuItem;
    PN2: TMenuItem;
    menuPaste: TMenuItem;
    menuCut: TMenuItem;
    menuCopy: TMenuItem;
    menuDelete: TMenuItem;
    PN3: TMenuItem;
    menuSelectAll: TMenuItem;
    PN4: TMenuItem;
    menuNormalizeText: TMenuItem;
    N1: TMenuItem;
    menuBlock: TMenuItem;
    menuComment: TMenuItem;
    menuUncomment: TMenuItem;
    PN5: TMenuItem;
    menuProperties: TMenuItem;
    FreeBasic: TSynAnySyn;
    URIOpener: TSynURIOpener;
    EditSearch: TSynEditSearch;
    EditOptionsDialog: TSynEditOptionsDialog;
    CompletionProposal: TSynCompletionProposal;
    RC: TSynRCSyn;
    URI: TSynURISyn;
    ExporterRTF: TSynExporterRTF;
    ExporterHTML: TSynExporterHTML;
    Multi: TSynMultiSyn;
    css: TSynCssSyn;
    HTML: TSynHTMLSyn;
    JScript: TSynJScriptSyn;
    PHP: TSynPHPSyn;
    VBScript: TSynVBScriptSyn;
    XML: TSynXMLSyn;
    Python: TSynPythonSyn;
    BookmarkImageList: TImageList;
    procedure EditChange(Sender: TObject);
    procedure EditGutterClick(Sender: TObject; Button: TMouseButton; X, Y,
      Line: Integer; Mark: TSynEditMark);
    procedure menuUndoClick(Sender: TObject);
    procedure menuRedoClick(Sender: TObject);
    procedure menuPasteClick(Sender: TObject);
    procedure menuCutClick(Sender: TObject);
    procedure menuCopyClick(Sender: TObject);
    procedure menuDeleteClick(Sender: TObject);
    procedure menuSelectAllClick(Sender: TObject);
    procedure menuNormalizeTextClick(Sender: TObject);
    procedure menuCommentClick(Sender: TObject);
    procedure menuUncommentClick(Sender: TObject);
    procedure menuPropertiesClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure EditStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure EditDropFiles(Sender: TObject; X, Y: Integer;
      AFiles: TStrings);
    procedure menuBlockClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   Token:string;  

implementation

{$R *.dfm}

uses PageSheetUnit, ContainerUnit, DialogUnit, MainUnit, LauncherUnit,
  CodeUnit, TypesUnit,FreeBasicRTTI, HelperUnit;

procedure TEditor.EditChange(Sender: TObject);
begin
    TPageSheet(Edit.Parent.Parent).Saved:=false;
    Debugger.Reset;
end;

procedure TEditor.EditGutterClick(Sender: TObject; Button: TMouseButton; X,
  Y, Line: Integer; Mark: TSynEditMark);
var
   c:TControl;
   E:TError;
begin
    c:=TControl(Edit.Lines.Objects[Line-1]);
    if c<> nil then begin
       if c.InheritsFrom(TContainer) then
          Hint:=format('object:%d, class: %s',[integer(c),TContainer(c).hosted])
       else
       if c.InheritsFrom(TDialog) then begin
          Hint:=format('object:%d, class: %s',[integer(c),TDialog(c).Typ.hosted]);
          TDialog(c).BringToFront
       end
    end else Hint:='';

end;

procedure TEditor.menuUndoClick(Sender: TObject);
begin
   Edit.Undo ; Edit.Refresh;
end;

procedure TEditor.menuRedoClick(Sender: TObject);
begin
    Edit.Redo;  ; Edit.Refresh;
end;

procedure TEditor.menuPasteClick(Sender: TObject);
begin
    Edit.PasteFromClipboard ; Edit.Refresh;
end;

procedure TEditor.menuCutClick(Sender: TObject);
begin
   Edit.CutToClipboard ; Edit.Refresh;
end;

procedure TEditor.menuCopyClick(Sender: TObject);
begin
   Edit.CopyToClipboard ; Edit.Refresh;
end;

procedure TEditor.menuDeleteClick(Sender: TObject);
begin
   Edit.ClearSelection; ; Edit.Refresh;
end;

procedure TEditor.menuSelectAllClick(Sender: TObject);
begin
    Edit.SelectAll
end;

procedure TEditor.menuNormalizeTextClick(Sender: TObject);
begin
   Edit.SelText:=stringreplace(Edit.SelText,#9,#32,[rfreplaceall]);
end;

procedure TEditor.menuCommentClick(Sender: TObject);
var
   L:TStrings;
   i:integer;
begin
    L:=TStringList.Create;
    L.Text:=Edit.SelText;
    for i:=0 to L.Count-1 do
        if L[i]<>'' then
           if L[i][1]<>'''' then
              L[i]:=''''+L[i];
    Edit.SelText:=trim(L.Text);
    L.Free;
end;

procedure TEditor.menuUncommentClick(Sender: TObject);
var
   L:TStrings;
   i:integer;
begin
    L:=TStringList.Create;
    L.Text:=Edit.SelText;
    for i:=0 to L.Count-1 do
        if L[i]<>'' then
           if L[i][1]='''' then
              L[i]:=StringReplace(L[i],'''','',[]);
    Edit.SelText:=L.Text;
    L.Free
end;

procedure TEditor.menuPropertiesClick(Sender: TObject);
begin
   Launcher.EditOptions.Assign(Edit);
   if EditOptionsDialog.Execute(Launcher.EditOptions) then
      Launcher.EditOptions.AssignTo(Edit);
end;

procedure TEditor.PopupMenuPopup(Sender: TObject);
begin
    menuUndo.Enabled:=ActiveEditor.Frame.Edit.CanUndo;
    menuRedo.Enabled:=ActiveEditor.Frame.Edit.CanRedo;
    menuPaste.Enabled:=ActiveEditor.Frame.Edit.CanPaste;
    menuCut.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
    menuCopy.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
    menuDelete.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
    menuSelectAll.Enabled:=ActiveEditor.Frame.Edit.Text<>'';
    menuBlock.Enabled:=ActiveEditor.Frame.Edit.SelText<>'';
    menuComment.Enabled:=pos('''',ActiveEditor.Frame.Edit.Text)=0;
    menuUncomment.Enabled:=pos('''',ActiveEditor.Frame.Edit.Text)>0;
    menuNormalizeText.Enabled:=(ActiveEditor.Frame.Edit.SelText<>'') and (pos(#9,ActiveEditor.Frame.Edit.SelText)>0);

end;

procedure TEditor.EditStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
    if scModified in Changes then
       Code.StatusBar.Panels[1].Text:='Modified';
    if scInsertMode in Changes then
       Code.StatusBar.Panels[1].Text:='Insert';
    if (scCaretX in changes) or (scCaretY in changes) then
       Code.StatusBar.Panels[0].Text:=format('Lin: %d, Col: %d',[TSynEdit(Sender).CaretY,TSynEdit(Sender).CaretX]);

end;

procedure TEditor.EditDropFiles(Sender: TObject; X, Y: Integer;
  AFiles: TStrings);
var
   i:integer;
   L:TStrings;
begin  
    L:=TStringList.Create;
    for i:=0 to AFiles.Count-1 do begin
        L.LoadFromFile(AFiles[i]);
        Edit.Lines.Insert(Edit.CaretY,L.Text);
    end;
    L.Free
end;

procedure TEditor.menuBlockClick(Sender: TObject);
begin
    menuComment.Enabled:=pos('''',Edit.SelText)=0;
    menuUnComment.Enabled:=pos('''',Edit.SelText)>0;
end;

procedure TEditor.EditKeyPress(Sender: TObject; var Key: Char);
begin
     inherited ;
     Token:=Token+key;
     if key=' ' then
        token:='';
end;

procedure TEditor.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   s,ident,return:string;
   L:TStrings;
   i,x:integer;
   F:TField;
   T:TType;
   C:TContainer;
   procedure onlyPublic;
   var
      F:TField;
      i:integer;
   begin
       if CompletionProposal.InsertList.Count=0 then exit;
       i:=0;
       repeat
             F:=TField(CompletionProposal.InsertList.Objects[i]);
             if F<>nil then
                if CompareText(F.Visibility,'public')<>0 then
                   CompletionProposal.InsertList.Delete(i);
             inc(i);
       until i>CompletionProposal.InsertList.Count-1;
   end;
begin
    L:=TStringList.Create;

    if key=$BE {'.'} then begin
       if Launcher.AlowCompletion then begin
          CompletionProposal.InsertList.Clear;
          CompletionProposal.ItemList.Clear;
          L.Text:=StringReplace(Edit.LineText,#32,#10,[rfreplaceall]);
          i:=0;
          repeat
                if pos('.',L[i])>0 then begin
                    ident:=copy(L[i],1,pos('.',L[i])-1);
                    return:=copy(L[i],pos('.',L[i])+1,length(L[i]));
                end else begin
                    ident:=L[i];
                    return:='';
                end;

                if (TPageSheet(Parent)<>nil)  then begin
                    if TPageSheet(Parent).Scanner<>nil then begin
                       TPageSheet(Parent).Scanner.Scan; {?}
                       if TPageSheet(Parent).Scanner.Variables.Count>0 then
                          x:=TPageSheet(Parent).Scanner.Variables.indexOf(ident)
                       else
                          x:=-1;
                       if x>-1 then
                          F:=TField(TPageSheet(Parent).Scanner.Variables.Objects[x]);
                       if F<>nil then T:=TPageSheet(Parent).Scanner.TypExists(F.Return);
                       if T<>nil then begin
                          //RTTIGetProperties(T.Extends,CompletionProposal.InsertList);
                          RTTIGetFields(T.Extends,TStrings(CompletionProposal.InsertList));
                          onlyPublic;
                          for i:=0 to CompletionProposal.InsertList.Count-1 do begin
                              F:=TField(CompletionProposal.InsertList.Objects[i]);
                              if F.Params<>'' then
                                 s:=format('%s \column{}\style{+B}%s\style{-B}(%s)',[F.Kind,F.Hosted,F.Params])
                              else
                                 s:=format('%s \column{}\style{+B}%s\style{-B}',[F.Kind,F.Hosted]);
                              CompletionProposal.ItemList.Add(s)
                          end;
                       end;
                    end;
                 end;


                inc(i);
          until i>L.Count-1;
        end;
     end;

     if Key=vk_delete then begin
        if Edit.LineText<>'' then
           L.Text:=StringReplace(Edit.LineText,#32,#10,[rfreplaceall])
        else
           L.Text:='';
        if L.Count=0 then exit;
        i:=0;
        repeat
             if L[i]=#10 then L[i]:='';
             inc(i);
        until i>L.Count-1;

        TPageSheet(Parent).Scanner.Text:=Edit.Text;
        TPageSheet(Parent).Scanner.Scan;
     end;
    
    if key=vk_return then begin
          if Edit.LineText<>'' then
             L.Text:=SkipBlanks(StringReplace(Edit.LineText,#32,#10,[rfreplaceall]))
          else
             L.Text:='';
          if L.Count=0 then exit;
          i:=0;
          if CompareText(L[0],'dim')=0 then
             if CompareText(L[1],'shared')<>0 then begin
                if CompareText(L[1],'as')=0 then begin
                   return:=L[2];
                   ident:=L[3];
                   F:=TField.Create;
                   F.Hosted:=ident;
                   F.Return:=Return;
                   F.Where.X:=Edit.CaretX;
                   F.Where.Y:=Edit.CaretY-1;
                   F.Kind:='variable';
                   if Launcher.TypeExists(return)<>nil then begin
                      F.Owner:=Launcher.TypeExists(return);
                      F.Special:=Launcher.TypeExists(return).Hosted;
                   end;
                   TPageSheet(Parent).Scanner.Scan
                 end;
                 if CompareText(L[2],'as')=0 then begin
                    ident:=L[1];
                    return:=L[3];
                    F:=TField.Create;
                    F.Hosted:=ident;
                    F.Return:=Return;
                    F.Where.X:=Edit.CaretX;
                    F.Where.Y:=Edit.CaretY-1;
                    F.Kind:='variable';
                    if Launcher.TypeExists(return)<>nil then begin
                       F.Owner:=Launcher.TypeExists(return);
                       F.Special:=Launcher.TypeExists(return).Hosted;
                    end;
                    TPageSheet(Parent).Scanner.Scan
                 end;
             end else begin
                 if CompareText(L[2],'as')=0 then begin
                   return:=L[3];
                   ident:=L[4];
                   F:=TField.Create;
                   F.Hosted:=ident;
                   F.Return:=Return;
                   F.Where.X:=Edit.CaretX;
                   F.Where.Y:=Edit.CaretY-1;
                   F.Kind:='variable';
                   if Launcher.TypeExists(return)<>nil then begin
                      F.Owner:=Launcher.TypeExists(return);
                      F.Special:=Launcher.TypeExists(return).Hosted;
                   end;
                   TPageSheet(Parent).Scanner.Scan
                 end;
                 if CompareText(L[3],'as')=0 then begin
                    ident:=L[2];
                    return:=L[4];
                    F:=TField.Create;
                    F.Hosted:=ident;
                    F.Return:=Return;
                    F.Where.X:=Edit.CaretX;
                    F.Where.Y:=Edit.CaretY-1;
                    F.Kind:='variable';
                    if Launcher.TypeExists(return)<>nil then begin
                       F.Owner:=Launcher.TypeExists(return);
                       F.Special:=Launcher.TypeExists(return).Hosted;
                    end;
                    TPageSheet(Parent).Scanner.Scan
                 end;
                 TPageSheet(Parent).Scanner.Text:=Edit.Text;
                 TPageSheet(Parent).Scanner.Scan;
             end;
          L.Free;

       if Launcher.Conjoin then begin
          T:=Launcher.isRegisteredClass(return);
          if T<>nil then begin
             C:=TContainer.Create(ActiveDialog);
             C.Parent:=ActiveDialog;
             C.Typ:= T ;
             TPageSheet(Parent).Scanner.Text:=Edit.Text;
             TPageSheet(Parent).Scanner.Scan;
          end;;
       end;

    end
end;

end.
