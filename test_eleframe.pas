unit test_eleframe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TForm1 = class(TForm)
    PageControl: TPageControl;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses EditFrame, PageSheetUnit;

procedure TForm1.FormShow(Sender: TObject);
begin
    with TPageSheet.Create(PageControl) do begin
         Align:=alClient;
         PageControl:=Self.PageControl;
    end
end;

end.
 