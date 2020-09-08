unit CodeUnit;

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
  Dialogs, ImgList, Menus, ComCtrls, ExtCtrls, ELSuperEdit, SynEdit;

type
  TResultKind=(rkNone,rkCompiler,rkSearch);
  TResultPage=class(TTabSheet)
  private
  fEdit:TELSuperEdit;
  fResultKind:TResultKind;
  procedure GutterClick(Sender:TObject; Button: TMouseButton; X,
  Y, Line: Integer; Mark: TSynEditMark);
  public
  constructor Create(AOwner:TComponent);override;
  destructor Destroy; override;
  property Edit:TELSuperEdit read fEdit;
  property ResultKind:TResultKind read fResultKind write fResultKind;
  end;

  TCode = class(TForm)
    SplitterL: TSplitter;
    SplitterB: TSplitter;
    PageControl: TPageControl;
    TreeView: TTreeView;
    PanelResults: TPanel;
    StatusBar: TStatusBar;
    ResultsControl: TPageControl;
    PopupMenuPageControl: TPopupMenu;
    menuClosePage: TMenuItem;
    N1: TMenuItem;
    menuCompileRunthisfile: TMenuItem;
    N2: TMenuItem;
    menuConverttoFreeBasic: TMenuItem;
    ImageList: TImageList;
    menuAddtoProject: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    menuCodeFont: TMenuItem;
    PopupMenuTree: TPopupMenu;
    PopupMenuResult: TPopupMenu;
    menuFontTree: TMenuItem;
    menuFontResult: TMenuItem;
    N5: TMenuItem;
    menuSaveResult: TMenuItem;
    N6: TMenuItem;
    menuCopy: TMenuItem;
    procedure menuClosePageClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure menuCompileRunthisfileClick(Sender: TObject);
    procedure menuAddtoProjectClick(Sender: TObject);
    procedure PopupMenuPageControlPopup(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure TreeViewDblClick(Sender: TObject);
    procedure menuCodeFontClick(Sender: TObject);
    procedure menuFontTreeClick(Sender: TObject);
    procedure menuFontResultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menuSaveResultClick(Sender: TObject);
    procedure menuCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function AddResult(v:string=''):TResultPage;
  end;

var
  Code: TCode;
  ActiveResult:TResultPage;

implementation

{$R *.dfm}

uses MainUnit, PageSheetUnit, ProjectsUnit, InspectorUnit, TypesUnit,
  FindDialogUnit, ReplaceDialogunit;

{  TResultPage  }
constructor TResultPage.Create(AOwner:TComponent);
begin
   inherited;
   fEdit:=TELSuperEdit.Create(Self);
   fEdit.Align:=alclient;
   fEdit.Parent:=self;
   fEdit.OnGutterClick:=GutterClick;
end;

destructor TResultPage.Destroy;
begin
   inherited;
end;

procedure TResultPage.GutterClick(Sender:TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
   s,ifl,ln:string;
   P:TPageSheet;
   E:TError;
   v,ev :integer;
begin
   s:=fEdit.LineText;
   if s<>'' then begin
      if pos('error',lowercase(s))>0 then begin  
         ifl:=copy(s,1,pos('(',s)-1);
         ln:=copy(s,pos('(',s)+1,pos(')',s)-pos('(',s)-1);
         val(ln,v,ev);
         P:=Launcher.isOpen(ifl);
         if P<>nil then begin
            E:=TError.Create;
            if ev=0 then
               E.Line:=v;
            E.Mark.ImageIndex:=4;
            E.Kind:=erkUser;
            P.Frame.Edit.Errors.AddObject(E.ClassName,E) ;
            P.Frame.Edit.Repaint;
         end
      end
   end
end;

{  TCode  }
function TCode.AddResult(v:string=''):TResultPage;
begin
   result:=TResultPage.Create(resultsControl);
   result.Align:=alclient;
   result.PageControl:=resultsControl;
   if fileexists(v) then begin
      result.Edit.Lines.LoadFromFile(v);
      result.Caption:=extractFileName(v);
   end else result.Edit.Text:=v;
   if result.Caption='' then
      result.Caption:='&Result';
   ActiveResult:=result;
   ActiveResult.PopupMenu:=PopupMenuResult;
end;

procedure TCode.menuClosePageClick(Sender: TObject);
begin
    CanFreeDialog:=TPageSheet(PageControl.ActivePage).HasDialog;
    if ActiveProject<>nil then
       if PageControl.ActivePage=ActiveProject.Page then
          ActiveProject.Page:=nil;{}
    Projects.UpdateToolBar;

    TPageSheet(PageControl.ActivePage).Dispose;
    CanFreeDialog:=false;

    PageControl.ActivePage:=PageControl.FindNextPage(PageControl.ActivePage,true,true);
    PageControlChange(PageControl);

    if PageControl.PageCount=0 then TreeView.Items.Clear;
end;

procedure TCode.PageControlChange(Sender: TObject);
begin
    ActiveEditor:=TPageSheet(PageControl.ActivePage); 
    ActiveObject:=ActiveEditor;
    if ActiveEditor<>nil then begin
       ActiveEditor.Scanner.Execute;
       if FindDialog.Visible then FindDialog.SynEdit:=ActiveEditor.Frame.Edit;
       if ReplaceDialog.Visible then ReplaceDialog.SynEdit:=ActiveEditor.Frame.Edit;
    end;
end;

procedure TCode.menuCompileRunthisfileClick(Sender: TObject);
begin
    if not ActiveEditor.Saved then
       if FileExists(ActiveEditor.FileName) then
          ActiveEditor.Save
       else
          ActiveEditor.SaveAs;
    Debugger.Reset;      
    Compiler.Params:=ActiveEditor.FileName;
    Compiler.Switch:=Launcher.Switch;
    Compiler.CompileRun
end;

procedure TCode.menuAddtoProjectClick(Sender: TObject);
begin
    if ActiveProject<>nil then
       if ActiveEditor<>nil then
          ActiveProject.AddPage(ActiveEditor)
end;

procedure TCode.PopupMenuPageControlPopup(Sender: TObject);
begin
    menuAddToProject.Enabled:=(ActiveProject<>nil) and (TPageSheet(PageControl.ActivePage).Project=nil) and FileExists(TPageSheet(PageControl.ActivePage).FileName);
    menuCompileRunThisFile.Enabled:=ActiveEditor<>nil;
    menuClosePage.Enabled:=ActiveEditor<>nil;{}
end;

procedure TCode.TreeViewClick(Sender: TObject);
var
   T:TField;
begin
    if TreeView.Selected<>nil then begin
       T:=TType(TreeView.Selected.Data);
       if (T<>nil) and (ActiveEditor<>nil) then begin
          with TPageSheet (PageControl.ActivePage) do begin
               Frame.Edit.TopLine:=T.Where.Y+1;
               Frame.Edit.CaretY:=T.Where.Y+1;
               Frame.Edit.CaretX:=T.Where.X;
                 Windows.SetFocus(Frame.Edit.Handle);
          end  ;
       end;
    end
end;

procedure TCode.TreeViewDblClick(Sender: TObject);
var
   T:TField;
begin
    if TreeView.Selected<>nil then begin
       T:=TType(TreeView.Selected.Data);
       if (T<>nil) and (ActiveEditor<>nil) then begin
          with TPageSheet (PageControl.ActivePage) do begin
               Frame.Edit.TopLine:=T.Implemented.Y+1;
               Frame.Edit.CaretY:=T.Implemented.Y+1;
               Frame.Edit.CaretX:=T.Implemented.X;
                 Windows.SetFocus(Frame.Edit.Handle);
          end  ;
       end;
    end

end;

procedure TCode.menuCodeFontClick(Sender: TObject);
begin
       with TFontDialog.Create(nil) do begin
         Font:=Code.Font;
         if Execute then
            Code.Font:=Font;
         Free   
    end;
end;

procedure TCode.menuFontTreeClick(Sender: TObject);
begin
       with TFontDialog.Create(nil) do begin
         Font:=TreeView.Font;
         if Execute then
            TreeView.Font:=Font;
         Free   
    end;
end;

procedure TCode.menuFontResultClick(Sender: TObject);
begin
       with TFontDialog.Create(nil) do begin
         Font:=ActiveResult.Edit.Font;
         if Execute then
           ActiveResult.Edit.Font:=Font;
         Free
    end;
end;

procedure TCode.FormCreate(Sender: TObject);
begin
    AddResult
end;

procedure TCode.menuSaveResultClick(Sender: TObject);
begin
    with TsaveDialog.Create(nil) do begin
         Filter:='Text File (*.txt)|*.txt|all Files (*.*)|*.*';
         FileName:=ActiveResult.Caption;
         if Execute then begin
            case FilterIndex of
            1: FileName:=ChangeFileExt(FileName,'.txt');
            end;
            ActiveResult.Edit.Lines.SaveToFile(FileName);
         end;
         free;
    end;
end;

procedure TCode.menuCopyClick(Sender: TObject);
begin
   ActiveResult.fEdit.CopyToClipboard
end;

end.
