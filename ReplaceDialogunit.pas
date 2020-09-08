unit ReplaceDialogunit;

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
  Dialogs, StdCtrls, ExtCtrls, Buttons, SynEdit, SynEditTypes;

type
  TReplaceDialog = class(TForm)
    editFind: TComboBox;
    Label1: TLabel;
    btnCancel: TBitBtn;
    Direction: TRadioGroup;
    cbMatchWord: TCheckBox;
    cbbMatchCase: TCheckBox;
    Label2: TLabel;
    editReplace: TComboBox;
    btnReplace: TBitBtn;
    btnReplaceAll: TBitBtn;
    cbFromCursor: TCheckBox;
    procedure btnReplaceClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure editFindExit(Sender: TObject);
    procedure editReplaceExit(Sender: TObject);
  private
    { Private declarations}
    FSynEdit :TSynEdit;
    procedure DoReplaceText;
    function GetFindText :string;
    procedure SetFindText(value :string);
    function GetReplaceText :string;
    procedure SetReplaceText(value :string);
  public
    { Public declarations }
    Options: TSynSearchOptions;
    procedure Execute(ASynEdit :TSynEdit);
    property FindText :string read GetFindText write SetFindText;
    property ReplaceText :string read GetReplaceText write SetReplaceText;
    property SynEdit :TSynEdit read FSynEdit write FSynEdit;
  end;

var
  ReplaceDialog: TReplaceDialog;

implementation

{$R *.dfm}

uses MainUnit;

function TReplaceDialog.GetFindText :string;
begin
      Result := editFind.Text
end;

procedure TReplaceDialog.SetFindText(value :string);
begin
   editFind.Text := value;
   EditFind.SelectAll
end;

function TReplaceDialog.GetReplaceText :string;
begin
   Result := editReplace.Text
end;

procedure TReplaceDialog.SetReplaceText(value :string);
begin
   editReplace.Text := value;
   editReplace.SelectAll
end;

procedure TReplaceDialog.Execute(ASynEdit :TSynEdit);
begin
   FSynEdit :=  ASynEdit  ;
   if FSynEdit.SelText <> '' then
      editFind.Text := FSynEdit.SelText;
   Visible := true;   
end;

procedure TReplaceDialog.DoReplaceText;
var
  sSearch, sReplace: string;
begin
  if FSynEdit = nil then Exit;
  sSearch := EditFind.Text;
  sReplace := EditReplace.Text;
  if Length(sSearch) = 0 then begin
    Beep;
    MessageDlg(  'Can''t replace an empty text!',mtInformation,[mbok],0);
  end else begin
    Options := Options + [ssoPrompt, ssoReplace];
    if Direction.ItemIndex = 1 then
        Include(Options, ssoBackwards);
    if cbbMatchCase.Checked then
        Include(Options, ssoMatchCase);
    if cbMatchWord.Checked then
        Include(Options, ssoWholeWord);
    if cbFromCursor.Checked then begin
       Include(Options, ssoEntireScope);
       if SynEdit.SelAvail and (SynEdit.BlockBegin.Line = SynEdit.BlockEnd.Line) then
           sSearch := SynEdit.SelText
       else
           sSearch := SynEdit.GetWordAtRowCol(SynEdit.CaretXY);
       FSynEdit.SelText := SynEdit.SelText;
    end;
    if FSynEdit.SearchReplace(sSearch, sReplace, Options) = 0  then begin
       MessageDlg(  'SearchText ''' + sSearch + ''' could not be replaced!',mtInformation,[mbok],0);;
       MessageBeep(MB_ICONASTERISK);
       if ssoBackwards in Options then
          SynEdit.BlockEnd := SynEdit.BlockBegin
       else
         SynEdit.BlockBegin := SynEdit.BlockEnd;
       SynEdit.CaretXY := SynEdit.BlockBegin;
    end else

  end;
end;

procedure TReplaceDialog.btnReplaceClick(Sender: TObject);
begin
   Exclude(Options, ssoReplaceAll);
   DoReplaceText;
end;

procedure TReplaceDialog.btnReplaceAllClick(Sender: TObject);
begin
   Include(Options, ssoReplaceAll);
   DoReplaceText;
end;

procedure TReplaceDialog.btnCancelClick(Sender: TObject);
begin
   Close
end;

procedure TReplaceDialog.FormShow(Sender: TObject);
begin
   if fSynEdit=nil then
      if ActiveEditor<>nil then
         fSynEdit :=ActiveEditor.Frame.Edit;
   if fSynEdit<>nil then
      if FSynEdit.SelText <> '' then
         editFind.Text := FSynEdit.SelText;
    btnReplace.Enabled:=fSynEdit<>nil;
    btnReplaceAll.Enabled:=btnReplace.Enabled;
end;

procedure TReplaceDialog.editFindExit(Sender: TObject);
begin
   if editFind.Items.IndexOf(editFind.Text) = -1 then
      editFind.Items.Add(editFind.Text)
end;

procedure TReplaceDialog.editReplaceExit(Sender: TObject);
begin
    if editReplace.Items.IndexOf(editReplace.Text) = -1 then
       editReplace.Items.Add(editReplace.Text)
end;

end.
