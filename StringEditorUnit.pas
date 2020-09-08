unit StringEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PropertyEditUnit, StdCtrls, Menus, clipbrd;

type
  TStringEditor = class(TPropertyEditor)
    Memo: TMemo;
    btnOk: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    PopupMenu: TPopupMenu;
    menuLoad: TMenuItem;
    menuSave: TMenuItem;
    N1: TMenuItem;
    menuUndo: TMenuItem;
    N2: TMenuItem;
    menuPaste: TMenuItem;
    menuCut: TMenuItem;
    menuCopy: TMenuItem;
    N3: TMenuItem;
    menuSelectAll: TMenuItem;
    procedure menuLoadClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure menuUndoClick(Sender: TObject);
    procedure menuPasteClick(Sender: TObject);
    procedure menuCutClick(Sender: TObject);
    procedure menuCopyClick(Sender: TObject);
    procedure menuSelectAllClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  protected
     procedure SetValue(v:variant);override;
     function GetValue:variant;override;
  public
    { Public declarations }
  end;

var
  StringEditor: TStringEditor;

implementation

{$R *.dfm}

uses MainUnit;

procedure TStringEditor.SetValue(v:variant);
begin
    memo.Text:=v;
end;

function TStringEditor.GetValue:variant;
begin
    fvalue:=memo.Text;
    result:=fvalue;
end;

procedure TStringEditor.menuLoadClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         if Execute then
            Memo.Lines.LoadFromFile(FileName);
         Free
    end;
end;

procedure TStringEditor.menuSaveClick(Sender: TObject);
begin
    with TSaveDialog.Create(nil) do begin
         if Execute then
            Memo.Lines.SaveToFile(FileName);
         Free
    end;
end;

procedure TStringEditor.menuUndoClick(Sender: TObject);
begin
    Memo.Undo;
end;

procedure TStringEditor.menuPasteClick(Sender: TObject);
begin
    Memo.PasteFromClipboard;
end;

procedure TStringEditor.menuCutClick(Sender: TObject);
begin
    Memo.CutToClipboard;
end;

procedure TStringEditor.menuCopyClick(Sender: TObject);
begin
    Memo.CopyToClipboard;
end;

procedure TStringEditor.menuSelectAllClick(Sender: TObject);
begin
    Memo.SelectAll;
end;

procedure TStringEditor.PopupMenuPopup(Sender: TObject);
begin
    menuSave.Enabled:=Memo.Text<>'';
    menuUndo.Enabled:=Memo.CanUndo;
    menuPaste.Enabled:=Clipboard.AsText<>'';
    menuCut.Enabled:=memo.SelText<>'';
    menuCopy.Enabled:=memo.SelText<>'';
    menuSelectAll.Enabled:=memo.Text<>'';
end;

procedure TStringEditor.btnOkClick(Sender: TObject);
begin
    fValue:=memo.Text;
end;

procedure TStringEditor.btnCancelClick(Sender: TObject);
begin
    fvalue:=''
end;

initialization
   RegisterClass(TStringEditor);
finalization
  UnregisterClass(TStringEditor);

end.
