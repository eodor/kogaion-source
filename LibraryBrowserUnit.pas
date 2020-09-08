unit LibraryBrowserUnit;

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
  Dialogs, ComCtrls, StdCtrls, Buttons, TypesUnit, ImgList;

type
  TLibraryBrowser = class(TForm)
    PageControl: TPageControl;
    TabClasses: TTabSheet;
    TabFiles: TTabSheet;
    ListBox: TListBox;
    TreeView: TTreeView;
    btnClose: TBitBtn;
    ImageList: TImageList;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fLib:TLibrary;
    procedure SetLib(v:TLibrary);
  public
    { Public declarations }
    property Lib:TLibrary read fLib write setlib;
  end;

var
  LibraryBrowser: TLibraryBrowser;

implementation

{$R *.dfm}

uses MainUnit, LauncherUnit;

procedure TLibraryBrowser.SetLib(v:TLibrary);
var
   N:TTreeNode;
   i:integer;
   T:TType;
   function Find(v:string):TTreeNode;
   var
      i:integer;
   begin
      result:=nil;
      for i:=0 to TreeView.Items.Count-1 do begin
          if comparetext(TreeView.Items[i].Text,v)=0 then begin
             result:=TreeView.Items[i];
             break;
          end
      end
   end;
begin
    fLib:=v;
    TreeView.Items.Clear;
    ListBox.Clear;
    if v=nil then exit;
    for i:=0 to v.Types.Count-1 do begin
        T:=TType(v.Types.Objects[i]);
        if T<>nil then begin
           if (T.Extends='') and (T.Forwarder='') then begin
               N:=TreeView.Items.AddObject(nil,T.Hosted,T);
               N.ImageIndex:=1;
           end;
        end ;
    end;
    for i:=0 to v.Types.Count-1 do begin
        T:=TType(v.Types.Objects[i]);
        if T<>nil then begin
           if (T.Extends<>'') then begin
              N:=TreeView.Items.AddChildObject(Find(T.Extends),T.Hosted,T); 
              N.ImageIndex:=1;
           end
        end
    end;
    for i:=0 to v.Types.Count-1 do begin
        T:=TType(v.Types.Objects[i]);
        if T<>nil then begin
           if (T.Forwarder<>'') then begin
              N:=TreeView.Items.AddChildObject(Find(T.Forwarder),T.Hosted,T);
              N.ImageIndex:=1;
           end;
        end
    end ;
    TreeView.FullExpand;
    ListBox.Items.Assign(v.files);
end;

procedure TLibraryBrowser.btnCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TLibraryBrowser.FormShow(Sender: TObject);
var
   N:TTreeNode;
   function Find(v:string):TTreeNode;
   var
      i:integer;
   begin
      result:=nil;
      for i:=0 to TreeView.Items.Count-1 do begin
          if comparetext(TreeView.Items[i].Text,v)=0 then begin
             result:=TreeView.Items[i];
             break;
          end
      end
   end;
begin
   N:=Find(Launcher.Lib.MainTypeName);
   if N<>nil then N.Selected:=true;
end;

procedure TLibraryBrowser.ListBoxClick(Sender: TObject);
begin
   if ListBox.ItemIndex=-1 then ListBox.ClearSelection;
end;

procedure TLibraryBrowser.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   i:integer;
begin
    for i:=0 to ListBox.Items.Count-1 do
        if ListBox.Selected[i] then
           NewEditor(ListBox.Items[i]);
end;

end.
