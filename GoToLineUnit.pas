unit GoToLineUnit;

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
  Dialogs, SynEdit, SynEditTypes, StdCtrls, Buttons, ComCtrls, ImgList;

type
  TGoLine = class(TForm)
    GroupBox: TGroupBox;
    lbLineNumber: TLabel;
    edLineNumber: TEdit;
    UpDown: TUpDown;
    cbBookmark: TCheckBox;
    btnGo: TBitBtn;
    ImageLisT: TImageList;
    procedure btnGoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     SynEdit :TSynEdit;
  end;

var
  GoLine: TGoLine;


implementation

{$R *.dfm}

uses MainUnit, CodeUnit;

procedure TGoLine.btnGoClick(Sender: TObject);
var
   x :integer;
begin
   SynEdit.CaretX := 1;
   SynEdit.CaretY := UpDown.Position;
   SynEdit.BookMarkOptions.BookmarkImages := ImageList;
   x := (SynEdit.Gutter.Width - ImageList.Width) div 2;
   if cbBookmark.Checked then begin
       SynEdit.SetBookMark(0, x, SynEdit.CaretXY.Line);
   end;
   SynEdit.TopLine := SynEdit.CaretY;
   SynEdit.SetFocus;
   ActiveEditor.BringToFront;
end;

procedure TGoLine.FormShow(Sender: TObject);
begin
   if ActiveEditor<>nil then begin
      SynEdit :=ActiveEditor.Frame.Edit;
      UpDown.Max := SynEdit.Lines.Count;
      UpDown.Position := UpDown.Min;
      btnGo.Enabled := (UpDown.Max >0);
      GroupBox.Caption := Format('max lines: %d',[UpDown.Max]);
   end
end;

procedure TGoLine.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    btnGo.Enabled := (UpDown.Max >0);
end;

procedure TGoLine.FormCreate(Sender: TObject);
begin
   Launcher.AddForm(self);
end;

end.
