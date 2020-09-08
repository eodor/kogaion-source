unit PrintUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Printers;

type
  TPrintAll = class(TForm)
    ListBox: TListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
  private
    { Private declarations }
    fPages:TPageControl;
    procedure SetPages(v:TPageControl);
  public
    { Public declarations }
    procedure PrintDocs;
    property Pages:TPageControl read fPages write SetPages;
  end;

var
  PrintAll: TPrintAll;

implementation

{$R *.dfm}

uses PageSheetUnit, HelperUnit, MainUnit;

procedure TPrintAll.SetPages(v:TPageControl);
var
   i:integer;
begin
   fPages:=v;
   if v<>nil then begin
      for i:=0 to v.PageCount-1 do
          ListBox.AddItem(v.Pages[i].Caption,v.Pages[i]);
   end
end;

procedure TPrintAll.PrintDocs;
var
   i:integer;
   P:TPageSheet;
   Im:TImage;
   Bitmap:TBitmap;
begin
    Im:=TImage.Create(nil);
    Im.Width:=600;
    Im.Height:=400;
    Im.Stretch:=true;
    for i:=0 to ListBox.Items.Count-1 do
        if ListBox.Selected[i] then begin
           P:=TPageSheet(ListBox.Items.Objects[i]);
           if P<>nil then begin
              if P.Dialog<>nil then begin
                 im:=TImage.Create(nil);
                 bitmap:=TBitmap.Create;
                 GetCapture(im,P.Dialog);
                 bitmap.Width:=im.Width*3;
                 bitmap.Height:=im.Height*3;
                 bitmap.Canvas.StretchDraw(rect(0,0,bitmap.Width,bitmap.Height),im.Picture.Bitmap);
                 Printer.BeginDoc;    
                 Printer.Canvas.Draw(0,0,bitmap); 
                 Printer.EndDoc;
                 im.Free;
                 bitmap.Free;
              end ;
              if Printer.Printing=false then begin
                 P.Frame.EditPrint.SynEdit:=P.Frame.Edit;
                 P.Frame.EditPrint.Print; 
              end
           end
        end ;
end;


end.
