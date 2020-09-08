unit SetModuleUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, LauncherUnit;

type
  TSetModule = class(TForm)
    CheckListBox: TCheckListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetModule: TSetModule;

implementation

{$R *.dfm}

uses MainUnit;

procedure TSetModule.FormCreate(Sender: TObject);
begin
    CheckListBox.Items.Assign(Launcher.Modules);
end;

procedure TSetModule.btnOKClick(Sender: TObject);
begin
    ModalResult:=mrOK;  Close;
end;

procedure TSetModule.btnCancelClick(Sender: TObject);
begin
    ModalResult:=mrCancel;  Close;
end;

end.
