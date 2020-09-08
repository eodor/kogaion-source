unit ClassModuleUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst;

type
  TClassModule = class(TForm)
    CheckListBox: TCheckListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClassModule: TClassModule;

implementation

{$R *.dfm}

uses CustomizeClassesUnit;

procedure TClassModule.btnOKClick(Sender: TObject);
var
   i:integer;
begin
    for i:=0 to CheckListBox.Items.Count-01 do
        if CheckListBox.Checked[i] then
           if TCCSheet(CustomizeClasses.PageControl.ActivePage).Frame.CheckListBox.Items.IndexOf(CheckListBox.Items[i])=-1 then
              TCCSheet(CustomizeClasses.PageControl.ActivePage).Frame.CheckListBox.Items.AddObject(CheckListBox.Items[i],CheckListBox.Items.Objects[i])
end;

end.
