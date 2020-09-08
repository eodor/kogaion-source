unit AlignmentInWindowUnit;

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
  Dialogs, StdCtrls, ExtCtrls, Buttons, ELDsgnr;

type
  TAlignmentInWindow = class(TForm)
    rgHorizontal: TRadioGroup;
    rgVertical: TRadioGroup;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlignmentInWindow: TAlignmentInWindow;

implementation

{$R *.dfm}

uses MainUnit;

procedure TAlignmentInWindow.btnOKClick(Sender: TObject);
var
   i:integer;
begin
   with ActiveDialog.ELDesigner do
       SelectedControls.Align(TELDesignerAlignType(rgHorizontal.ItemIndex),TELDesignerAlignType(rgVertical.ItemIndex));
end;

end.
