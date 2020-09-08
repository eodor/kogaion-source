unit ResourceDialogUnit;

interface

uses

  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HelperUnit, StdCtrls, Buttons, ComCtrls, Grids, TypesUnit,
  Menus, SynEditHighlighter, SynHighlighterRC, SynEdit;

type
  TResourcesDialog = class(TForm)
    btnLoad: TBitBtn;
    cbKinds: TComboBox;
    lbKind: TLabel;
    PopupMenu: TPopupMenu;
    menuLoad: TMenuItem;
    menuRemove: TMenuItem;
    N1: TMenuItem;
    menuClear: TMenuItem;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    PageControl: TPageControl;
    TabItems: TTabSheet;
    ListView: TListView;
    TabSource: TTabSheet;
    RCSource: TSynEdit;
    RC: TSynRCSyn;
    procedure btnLoadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbKindsChange(Sender: TObject);
    procedure cbKindsCloseUp(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure ListViewClick(Sender: TObject);
    procedure ListViewResize(Sender: TObject);
    procedure menuClearClick(Sender: TObject);
    procedure menuRemoveClick(Sender: TObject);
    procedure menuLoadClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function StrToRes(v:string):string;
    procedure LoadResources;

  end;

var
  ResourcesDialog: TResourcesDialog;

implementation

{$R *.dfm}

uses MainUnit;

function TResourceSDialog.StrToRes(v:string):string;
var
      Ext :string;
begin
      Result := '';
      if v='' then exit;
      Ext := ExtractFileExt(v); 
      if CompareText(Ext,'.bmp') = 0 then
         Result := 'BITMAP'
      else if CompareText(Ext,'.ico') = 0 then
         Result := 'ICON'
      else if CompareText(Ext,'.cur') = 0 then
         Result := 'CURSOR'
      else if (CompareText(Ext,'.html') = 0) or (CompareText(Ext,'.htm') = 0) then
         Result := 'HTML'
      else if CompareText(Ext,'.hta') = 0 then
         Result := 'COMPILEDHTML'
      else if CompareText(Ext,'.vxd') = 0 then
         Result := 'VXD'
      else if CompareText(Ext,'.JPEG') = 0 then
         Result := 'JPEG'
      else if CompareText(Ext,'.JPG') = 0 then
         Result := 'JPG'
      else if CompareText(Ext,'.TIFF') = 0 then
         Result := 'TIFF'
      else if CompareText(Ext,'.AVI') = 0 then
         Result := 'AVI'
      else if CompareText(Ext,'.MP3') = 0 then
         Result := 'MP3'
      else if CompareText(Ext,'.MP4') = 0 then
         Result := 'MP4'
      else if CompareText(Ext,'.FLV') = 0 then
         Result := 'FLASH'
      else if CompareText(Ext,'.3GP') = 0 then
         Result := 'JAVAMOBILE'
      else
         Result :='RCDATA';
end;

procedure TResourcesDialog.btnLoadClick(Sender: TObject);
var
   Li :TListItem;
   it :TResourceItem;
   i :integer;
begin
   with TOpenDialog.Create(nil) do begin
        Options := Options + [ofAllowMultiselect];
        if Execute then begin
           for i:=0 to Files.Count-1 do
            if Resources.ResourceExists(Files[i]) =nil then begin
                 Li := ListView.Items.Add;
                 Li.Caption := ChangeFileExt(ExtractFileName(Files[i]),'');
                 Li.SubItems.Add(StrToRes(Files[i]));
                 Li.SubItems.Add(Files[i]);
                 it := TResourceItem.Create;
                 it.Name:= Li.Caption;
                 it.FileName := Li.SubItems[1];
                 it.Kind := StrToRes(Files[i]);
                 Li.Data := it;
                 Resources.AddItem(it);
             end;
        end;
        Free;
   end;
end;

procedure TResourcesDialog.LoadResources;
var
   i :integer;
   L :TListItem;
begin
    ListView.Items.Clear;
    for i := 0 to Resources.Items.Count-1 do begin
        L := ListView.Items.Add;
        L.Caption := Resources.Items[i];
        L.SubItems.Add(TResourceItem(Resources.Items.Objects[i]).Kind);
        L.SubItems.Add(TResourceItem(Resources.Items.Objects[i]).FileName);
        L.Data:= Resources.Items.Objects[i];
    end
end;

procedure TResourcesDialog.FormShow(Sender: TObject);
begin
   LoadResources; 
end;

procedure TResourcesDialog.cbKindsChange(Sender: TObject);
var
   i :integer;
   L :TListItem;
begin
    i := ListView.ItemIndex;
    if i <> -1 then begin
       L := ListView.Items[i];
       L.SubItems[0] := cbKinds.Text;
    end;

end;

procedure TResourcesDialog.cbKindsCloseUp(Sender: TObject);
var
   i :integer;
   L :TListItem;
begin
    i := ListView.ItemIndex;
    if i <> -1 then begin
       L := ListView.Items[i];
       L.SubItems[0] := cbKinds.Text;
    end;
end;

procedure TResourcesDialog.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
    if Column = ListView.Columns[2] then
       btnLoad.Click
end;

procedure TResourcesDialog.ListViewEdited(Sender: TObject; Item: TListItem;
  var S: String);
var
   i :integer;
begin
    I := ListView.ItemIndex;
    if i <> -1 then
       Resources.Item[i].Name := s;
end;

procedure TResourcesDialog.ListViewClick(Sender: TObject);
var
   ri :TResourceItem;
begin
    cbKinds.Enabled :=(ListView.Selected <> nil);
    if cbKinds.Enabled then begin
       ri:=TResourceItem(ListView.Items[ListView.ItemIndex].Data);
       cbKinds.ItemIndex :=cbKinds.Items.IndexOf(ri.Kind);
    end;
end;

procedure TResourcesDialog.ListViewResize(Sender: TObject);
var
   i :integer;
begin
    i := ListView.ClientWidth div 3;
    ListView.Columns[0].Width := i;
    ListView.Columns[1].Width := i;
    ListView.Columns[2].Width := i;
end;

procedure TResourcesDialog.menuClearClick(Sender: TObject);
var
   i :integer;
begin
    for i := ListView.Items.Count-1 downto 0 do begin
        if ListView.Items[i].Data<>nil then
           if TObject(ListView.Items[i].Data).InheritsFrom(TResourceItem) then begin
              Resources.RemoveItem(TResourceItem(ListView.Items[i].Data).FileName);
           end;
        ListView.Items.Delete(i);
    end;
end;

procedure TResourcesDialog.menuRemoveClick(Sender: TObject);
var
   i :integer;
begin
    i:=ListView.ItemIndex;
    if i>-1 then begin
       if ListView.Items[i].Data<>nil then
          if TObject(ListView.Items[i].Data).InheritsFrom(TResourceItem) then begin
             Resources.RemoveItem(TResourceItem(ListView.Items[i].Data).FileName);
          end;
        ListView.Items.Delete(i);
    end;
end;

procedure TResourcesDialog.menuLoadClick(Sender: TObject);
begin
   btnLoad.Click;
end;

procedure TResourcesDialog.btOKClick(Sender: TObject);
var
   i :integer;
begin
   Resources.Items.Clear();
   for i := 0 to ListView.Items.Count-1 do
       Resources.AddItem(TResourceItem(ListView.Items[i].Data));
   ModalResult:=mrok;
   Close;
end;

procedure TResourcesDialog.PopupMenuPopup(Sender: TObject);
begin
    menuRemove.Enabled := ListView.Items.Count>0;
    menuClear.Enabled := ListView.Items.Count>0;
end;

procedure TResourcesDialog.btCancelClick(Sender: TObject);
begin
   ModalResult:=mrcancel;
   Close;
end;

procedure TResourcesDialog.PageControlChange(Sender: TObject);
begin
    RCSource.Lines.Assign(Resources);
end;

end.
