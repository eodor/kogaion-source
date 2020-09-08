unit GaugeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList;

type
  TGauge = class(TForm)
    ImageList: TImageList;
    Timer: TTimer;
    Image: TImage;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Gauge: TGauge;
  Bitmap :TBitmap;

implementation

{$R *.dfm}

procedure TGauge.TimerTimer(Sender: TObject);
begin
   Application.ProcessMessages;
   Bitmap.FreeImage;
   if Timer.Tag > 9 then Timer.Tag := 0;
   ImageList.GetBitmap(Timer.Tag, Bitmap);
   Image.Picture.Bitmap:=Bitmap;
   Timer.Tag := Timer.Tag + 1;
end;

procedure TGauge.FormShow(Sender: TObject);
begin
   ClientWidth := 100;
   {Height := 100;}
   Bitmap.TransparentColor := clYellow;
   Bitmap.TransparentMode := tmauto;
   Bitmap.Transparent := true;
   ImageList.GetBitmap(0, Bitmap);
   Image.Picture.Bitmap:=Bitmap;
   Timer.Enabled := true;
end;

procedure TGauge.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Timer.Enabled := false;
end;

procedure TGauge.FormClick(Sender: TObject);
begin
   Close;
end;

initialization
   Bitmap := TBitmap.Create;
finalization
   Bitmap.Free;
end.
