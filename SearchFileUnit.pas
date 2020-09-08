unit SearchFileUnit;

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
  Dialogs, SynEdit, StdCtrls, Buttons, HelperUnit, ExtCtrls;

type
  TSearchFile = class(TForm)
    cbFiles: TComboBox;
    lbFileName: TLabel;
    btnSearch: TBitBtn;
    lbFile: TLabel;
    cbWhere: TComboBox;
    btnWhere: TBitBtn;
    lbWhere: TLabel;
    btnClose: TBitBtn;
    Bevel: TBevel;
    procedure btnSearchClick(Sender: TObject);
    procedure FindFileSearchFinish(Sender: TObject);
    procedure btnWhereClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbFilesExit(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function SearchEvent(var AFile :string) :integer; stdcall;
    procedure GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
  public
    { Public declarations }
  end;

var
  SearchFile: TSearchFile;
  bFound :boolean;
  oldGutterEvent:TGutterClickEvent;

implementation

{$R *.dfm}

uses
    MainUnit, SearchInFilesUnit, CodeUnit;

procedure InFile(var str :string; var i :integer; var Found :boolean) ;
begin
end;

function TSearchFile.SearchEvent(var AFile :string) :integer;
begin
    result:=0;
    if CompareText(ExtractFileName(AFile),ExtractFileName(cbFiles.Text))=0 then begin 
       //result:=-1;
       ActiveResult.Edit.Lines.Add(AFile);
       result:=ActiveResult.Edit.Lines.Count;
    end;
end;

procedure TSearchFile.btnSearchClick(Sender: TObject);
   function Find(value :string) :integer;
   var
      i :integer;
   begin
      Result := -1;
      for i:= 0 to cbFiles.Items.Count-1 do
          if CompareText(value,cbFiles.Items[i]) = 0 then begin
             Result := i;
             Break;
          end;
   end;
begin
    ActiveResult.Edit.ClearAll;
    lbFile.Caption := '';
    btnSearch.Enabled := false;
    ActiveResult.Edit.Text := SearchTree(cbWhere.Text,cbFiles.Text);
    ListFileDir(cbWhere.Text,SearchEvent);
    btnSearch.Enabled := true;
    if (ActiveResult.Edit.Text <> '') then begin
       cbFiles.Items.Add(cbFiles.Text);
       lbFile.Caption := cbFiles.Text;
    end;

end;

procedure TSearchFile.FindFileSearchFinish(Sender: TObject);
begin
   if ActiveResult.Edit.Lines.Count = 0 then begin
      messageDlg(Format('Searches for %s found nothing.',[cbFiles.Text]),mtInformation,[mbok],0);
      Exit;
   end;
   messageDlg(Format('Searches for %s finished.',[cbFiles.Text]),mtInformation,[mbok],0)
end;

procedure TSearchFile.btnWhereClick(Sender: TObject);
var
   Folder :string;
   function Find(value :string) :integer;
   var
      i :integer;
   begin
      Result := -1;
      for i:= 0 to cbWhere.Items.Count-1 do
          if CompareText(value,cbWhere.Items[i]) = 0 then begin
             Result := i;
             Break;
          end;
   end;
begin
    Folder := cbWhere.Text;
    if BrowseForFolder(Folder, 'Browse for folder...') then begin
       cbWhere.Text := Folder;
       if Find(cbWhere.Text) = -1 then
          cbWhere.Items.Add(Folder);
    end;
end;

procedure TSearchFile.GutterClick(Sender: TObject; Button: TMouseButton;
  X, Y, Line: Integer; Mark: TSynEditMark);
var
   FileName :string;
begin
    FileName := ActiveResult.Edit.Lines[Line-1];
    if FileExists(FileName) then begin
       ActiveResult.Edit.Hint := Format('File: %s',[FileName]);
       ActiveResult.Edit.ShowHint := true;
       with NewEditor(FileName) do begin
       end;
    end
end;

procedure TSearchFile.FormShow(Sender: TObject);
begin
   oldGutterEvent:=ActiveResult.Edit.OnGutterClick;
   ActiveResult.Edit.OnGutterClick := GutterClick;
   cbWhere.Text := WorkDir;
end;

procedure TSearchFile.cbFilesExit(Sender: TObject);
begin
   if cbFiles.Items.IndexOf(cbFiles.Text) = -1 then
      cbFiles.Items.Add(cbFiles.Text)
end;

procedure TSearchFile.btnCloseClick(Sender: TObject);
begin
   Close
end;

procedure TSearchFile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ActiveResult.Edit.OnGutterClick:=oldGutterEvent;
end;

end.

