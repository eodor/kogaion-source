unit DialogsListUnit;

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
  Dialogs, StdCtrls, Buttons, DialogUnit;

type
  TDialogList = class(TForm)
    ListBox: TListBox;
    btnShow: TBitBtn;
    btnHide: TBitBtn;
    btnFree: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure btnFreeClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateButtons;
  public
    { Public declarations }
  end;

var
  DialogList: TDialogList;
  selectedDialog:TDialog;

implementation

{$R *.dfm}

uses PageSheetUnit, LauncherUnit, CodeUnit;

procedure TDialogList.UpdateButtons;
begin
    btnShow.Enabled:=(selectedDialog<>nil) and not IsWindowVisible(selectedDialog.Handle);
    btnHide.Enabled:=(selectedDialog<>nil) and IsWindowVisible(selectedDialog.Handle);
    btnFree.Enabled:=selectedDialog<>nil
end;

procedure TDialogList.FormShow(Sender: TObject);
begin
    ListBox.Items.Assign(DialogsList);
end;

procedure TDialogList.ListBoxClick(Sender: TObject);
var
   i:integer;
begin
    i:=ListBox.ItemIndex;
    if i=-1 then exit;
    selectedDialog:=TDialog(ListBox.Items.Objects[i]);
    UpdateButtons;
end;

procedure TDialogList.btnShowClick(Sender: TObject);
begin
    
    ShowWindow(selectedDialog.Handle,sw_show);
    UpdateButtons;
end;

procedure TDialogList.btnHideClick(Sender: TObject);
begin
    
    ShowWindow(selectedDialog.Handle,sw_hide);
    UpdateButtons;
end;

procedure TDialogList.btnFreeClick(Sender: TObject);
begin
    if selectedDialog<>nil then
       if selectedDialog.Page<>nil then begin
          CanFreeDialog:=TPageSheet(selectedDialog.Page).HasDialog;
          TPageSheet(selectedDialog.Page).Dispose;
          selectedDialog:=nil ;
          CanFreeDialog:=false
       end;
    if Code.PageControl.PageCount=0 then
       Code.TreeView.Items.Clear;   
    UpdateButtons;
end;

end.
