unit FindDialogUnit;

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
  Dialogs, StdCtrls, ExtCtrls, Buttons, SynEdit, SynEditTypes ;

type
  TFindDialog = class(TForm)
    editFindText: TComboBox;
    lblTextToFind: TLabel;
    btnFind: TBitBtn;
    btnCancel: TBitBtn;
    Direction: TRadioGroup;
    cbMatchWord: TCheckBox;
    cbbMatchCase: TCheckBox;
    cbFromCursor: TCheckBox;
    procedure btnFindClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure editFindTextExit(Sender: TObject);
  private
    { Private declarations }
    FSynEdit :TSynEdit;
    FNextCan :boolean;
    function GetFindText :string;
    procedure SetFindText(value :string);
    procedure DoFindText;
  public
    { Public declarations }
    Options: TSynSearchOptions;
    procedure FindNext;
    procedure Execute(ASynEdit :TSynEdit);
    property NextCan :boolean read FNextCan;
    property FindText :string read GetFindText write SetFindText;
    property SynEdit :TSynEdit read FSynEdit write FSynEdit;
  end;

var
  FindDialog: TFindDialog;
  RecoverText :string;
  Found:boolean;

implementation

{$R *.dfm}

uses MainUnit;

function TFindDialog.GetFindText :string;
begin
   Result := editFindText.Text
end;

procedure TFindDialog.SetFindText(value :string);
begin
   editFindText.Text := value;
   EditFindText.SelectAll ;
   RecoverText := value;
end;

procedure TFindDialog.Execute(ASynEdit :TSynEdit);
begin
    FSynEdit :=  ASynEdit  ;
    if fSynEdit<>nil then
       if FSynEdit.SelText <> '' then
          editFindText.Text := FSynEdit.SelText;
    Visible := true;
end;

procedure TFindDialog.DoFindText;
var
  sSearch: string;
begin
  sSearch := FindText;
  if FSynEdit <>  nil then
     if FSynEdit.SelText <> '' then
        editFindText.Text := FSynEdit.SelText;
  if (sSearch = '') and (Visible = false) then
     sSearch := RecoverText;
  if Length(sSearch) = 0 then begin
    Beep;
    MessageDlg( 'Wrong word. Can''t be wide one.',mtInformation,[mbok],0);
    FNextCan := false;
  end else begin
    Options := [];
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
    end;
    RecoverText := sSearch;
    if FSynEdit.SearchReplace(sSearch, '', Options) = 0 then begin
       MessageBeep(MB_ICONASTERISK);
       if ssoBackwards in Options then
          SynEdit.BlockEnd := SynEdit.BlockBegin
       else
         SynEdit.BlockBegin := SynEdit.BlockEnd;
       SynEdit.CaretXY := SynEdit.BlockBegin;
       MessageDlg(format('Wrong %s. can''t be wide.',[sSearch]),mtInformation,[mbok],0);
       FNextCan := false;
    end else
       FNextCan := true;
  end;
end;

procedure TFindDialog.btnFindClick(Sender: TObject);
begin
   if FSynEdit <> nil then
      DoFindText
end;

procedure TFindDialog.btnCancelClick(Sender: TObject);
begin
   Close
end;

procedure TFindDialog.FormShow(Sender: TObject);
begin
   Found:=false;
   if fSynEdit=nil then
      if ActiveEditor<>nil then
         fSynEdit:=ActiveEditor.Frame.Edit;
   if fSynEdit<>nil then
      if FSynEdit.SelText <> '' then
         editFindText.Text := FSynEdit.SelText;
   btnFind.Enabled:=fSynEdit<>nil;
end;
          
procedure TFindDialog.FindNext;
begin
   DoFindText;
end;

procedure TFindDialog.editFindTextExit(Sender: TObject);
begin
    if editFindText.Items.IndexOf(editFindText.Text) = -1 then
      editFindText.Items.Add(editFindText.Text)
end;

end.
