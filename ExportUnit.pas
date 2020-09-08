unit ExportUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TypesUnit, ExtCtrls, ShellApi, Clipbrd;

type
  TExportFiles = class(TForm)
    ListBox: TListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbJpeg: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fProject:TProject;
    procedure SetProject(v:TProject);
  public
    { Public declarations }
    procedure ExportAll;
    property Project:TProject read fProject write setproject;
  end;

var
  ExportFiles: TExportFiles;

implementation

{$R *.dfm}

uses CodeUnit, PageSheetUnit, MainUnit, HelperUnit;

procedure TExportFiles.SetProject(v:TProject);
var
   i:integer;
   P:TPageSheet;
begin
   fProject:=v;
   ListBox.Clear;
   if v=nil then exit;
   for i:=0 to Code.PageControl.PageCount-1 do begin
       P:=TPageSheet(Code.PageControl.Pages[i]);
       if P<>nil then begin
          if FileExists(P.FileName) then
             ListBox.AddItem(P.FileName,P)
          else
             ListBox.AddItem(P.Caption,P);
          {if P.Project<>nil then} ListBox.Selected[i]:=true;
       end
   end;
end;

procedure TExportFiles.ExportAll;
var
   i:integer;
   P:TPageSheet;
   L,Lk:TStrings;
   Image:TImage;
   s:string;
begin
   Image:=TImage.Create(nil);
   L:=TStringList.Create;
   Lk:=TStringList.Create;
   L.Add('<html>') ;
   L.Add(format('<head><title>%s</title></head>',[ActiveProject.name]));
   L.Add('<body Onload="Message()">') ;
   L.Add('<script>');
   L.Add('   function Message(){');
   L.Add('      alert("Exported by Kogaion(RqWork7)");');
   L.Add('   }');
   L.Add('</script>');
   for i:=0 to ListBox.Items.Count-1 do
       if ListBox.Selected[i] then begin
          P:=TPageSheet(ListBox.Items.Objects[i]);
          if P<>nil then begin
             if P.Dialog<>nil then begin
                s:=HelperUnit.GetCapture(Image,P.Dialog,cbJpeg.Checked);
                
                if P.Frame.Edit.Lines.Count>0 then begin
                   L.Add(format('<p id="%s">',[P.Dialog.Caption]));
                   L.Add(format('<h3>%s</h3><img src="%s" center>',[P.Dialog.Caption,s])) ;
                   L.Add('<pre>');
                   L.Add(P.Frame.Edit.Lines.Text) ;
                   L.Add('</pre>');
                   L.Add('</p>');
                   L.Add(format('<p><a href="#%s">%s</a><p>',[P.Dialog.Caption,P.Dialog.Caption]));
                   end;
                end;
            end
         end ;
   L.Insert(8,Lk.Text);
   L.Add(Lk.Text);
   L.Add('</body>');
   L.Add('</html>') ;
   s:=ideDir+ActiveProject.Name+'.html';
   L.SaveToFile(s);
   ShellExecute(0,'open',PChar(s),'','',sw_show);
   L.Free;
   Lk.Free;
   Image.Free;
end;

procedure TExportFiles.FormCreate(Sender: TObject);
begin
   Launcher.AddForm(self);
end;

end.
