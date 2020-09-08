unit CloseSelectionUnit;

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
  Dialogs, StdCtrls, Buttons;

type
  TCloseSelection = class(TForm)
    ListBox: TListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbxWithoutCheck: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CloseSelection: TCloseSelection;

implementation

uses CodeUnit, PageSheetUnit;

{$R *.dfm}

procedure TCloseSelection.FormShow(Sender: TObject);
var
  i:integer;
begin
    Listbox.Items.Clear;
    for i:=0 to Code.PageControl.PageCount-1 do
        Listbox.Items.AddObject(Code.PageControl.Pages[i].Caption,Code.PageControl.Pages[i]);
end;

procedure TCloseSelection.btnOKClick(Sender: TObject);
var
   i:integer;
begin
    CanFreeDialog:=true;
    for i:=Listbox.Items.Count-1 downto 0 do
        if ListBox.Selected[i] then begin
           if not cbxWithoutcheck.Enabled then
              TPageSheet(Listbox.Items.Objects[i]).Dispose
           else
              TPageSheet(Listbox.Items.Objects[i]).Free;
           Listbox.Items.Delete(i);
        end;
    CanFreeDialog:=false;
end;

end.
