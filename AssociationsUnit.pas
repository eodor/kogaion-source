unit AssociationsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, ResourceExport;

type
  TAssociations = class(TForm)
    CheckListBox: TCheckListBox;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    btnClose: TBitBtn;
    ResourceExport: TResourceExport;
    procedure FormShow(Sender: TObject);
    procedure ResourceExportResourceNotFound(Sender: TObject);
    procedure ResourceExportSuccess(Sender: TObject;
      BytesWritten: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Associations: TAssociations;

implementation

{$R *.dfm}

procedure TAssociations.FormShow(Sender: TObject);
var
   s:TResourceStream;

begin
   {if FindResource(hinstance,'2',rt_icon)>0 then begin
      s:=TResourceStream.Create(hinstance,'2',rt_icon);
      image2.Picture.Icon.LoadFromStream(s);
      s.Free;
   end else begin messageDlg('Resource not found.',mtInformation,[mbok],0) ;}
      ResourceExport.Execute;
      

end;

procedure TAssociations.ResourceExportResourceNotFound(Sender: TObject);
begin
    showmessage('not found.');
end;

procedure TAssociations.ResourceExportSuccess(Sender: TObject;
  BytesWritten: Integer);
var
     I:TIcon;
begin
    if I<>nil then I.free;
    I:=TIcon.Create;
      I.LoadFromFile('2.ICO');
      Image2.Picture.Icon:=I
end;

end.
