unit OccurenciesUnit;

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
  Dialogs, StdCtrls, SearchInFilesUnit, CodeUnit;

type
  TOccurences = class(TForm)
    ListBox: TListBox;
    procedure ListBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ModalExecute(v:TFileInfo) :boolean;
    procedure Execute(v:TFileInfo);
  end;

var
  Occurences: TOccurences;

implementation

{$R *.dfm}

uses MainUnit, LauncherUnit, PageSheetUnit;

function TOccurences.ModalExecute(v:TFileInfo) :boolean;
var
  i :integer;
begin
   ListBox.Clear;
   for i:=0 to v.OccurCount-1 do
       ListBox.AddItem(format('occur :%d [%s], SelStart: %d, SelLength: %d',[i,ExtractFileName(v.Occur[i].FileName),v.Occur[i].SelStart,v.Occur[i].SelLength]),v.Occur[i]);
   result:=ShowModal=mrok
end;

procedure TOccurences.Execute(v:TFileInfo);
var
  i :integer;
begin
   ListBox.Clear;
   for i:=0 to v.OccurCount-1 do
       ListBox.AddItem(format('occur :%d [%s], SelStart: %d, SelLength: %d',[i,ExtractFileName(v.Occur[i].FileName),v.Occur[i].SelStart,v.Occur[i].SelLength]),v.Occur[i]);
   Visible:=true;
end;

procedure TOccurences.ListBoxClick(Sender: TObject);
var
   oc :TOccurence;
   i  :integer;
   P:TPageSheet;
begin
    i:=ListBox.ItemIndex;
    if i=-1 then exit;
    oc:=TOccurence(ListBox.Items.Objects[i]);
    if oc<>nil then begin
       P:=Launcher.IsOpen(oc.FileName);
       if P<>nil then begin
          P.Frame.Edit.SelStart:=oc.SelStart;
          P.Frame.Edit.SelLength:=oc.SelLength;
          P.BringToFront;
       end
    end;
end;

end.
