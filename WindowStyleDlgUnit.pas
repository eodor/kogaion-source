unit WindowStyleDlgUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ELPropInsp, Menus, IniFiles, ClipBrd, HelperUnit;

type
  TWindowStyleDlg = class(TForm)
    ListBox: TListBox;
    PopupMenu: TPopupMenu;
    pmenuShowAll: TMenuItem;
    pmenuShowSpecific: TMenuItem;
    N1: TMenuItem;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    cbxAsConstants: TCheckBox;
    EditStyle: TEdit;
    btnBrowse: TButton;
    cbClasses: TComboBox;
    procedure cbClassesCloseUp(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    { Private declarations }
    fControl:TWinControl;
    FValue:cardinal;
    procedure SetValue(v :uint);
    function GetValue :uint;
    procedure SetControl(v:TWinControl);
  public
    { Public declarations }
    NameClass :string;
    constructor Create(AOwner :TComponent); override;
    procedure ComputeStyle;
    procedure Initialize;
    procedure ClearAndFree;
    property Value :uint read GetValue write SetValue;
    property Control: TWinControl read fControl write SetControl;
    function Execute: Boolean;
  end;

var
  WindowStyleDlg: TWindowStyleDlg;

implementation

{$R *.dfm}

uses
   MainUnit, ContainerUnit, PropEditorsUnit, TypesUnit, DialogUnit;

constructor TWindowStyleDlg.Create(AOwner :TComponent);
begin
   inherited;
   if Launcher<>nil then
      cbClasses.Items.Assign(Launcher.Lib.Types);
end;

function TWindowStyleDlg.Execute: Boolean;
begin
    Result := (ShowModal = mrOk);
    cbClasses.Enabled:=false
end;

procedure TWindowStyleDlg.SetValue(v :uint);
var
   i :integer;
   W :TWindowStyle;
begin
    if ListBox=nil then exit;
    FValue := value;
    for i := 0 to ListBox.Items.Count-1 do begin
        W := TWindowStyle(ListBox.Items.Objects[I]);
        if (W.Value or Value) = value then begin
            ListBox.Selected[i] := true;
        end;
    end;
end;

function TWindowStyleDlg.GetValue :uint;
var
   i:integer;
   x:uint;
   W :TWindowStyle;
begin
    result:=0;
    if ListBox=nil then exit;
    x:=0;
    for i := 0 to ListBox.Items.Count-1 do begin
        if ListBox.Selected[i] then begin
           W := TWindowStyle(ListBox.Items.Objects[I]);
           x:= x or W.Value ;
           fvalue:=x;
        end
    end;
    result :=fvalue;
end;

procedure TWindowStyleDlg.SetControl(v :TWinControl);
begin
    fControl:=v;
    {if v <> nil then begin
       if v.InheritsFrom(TContainer) then
          NameClass := TContainer(v).Typ.Hosted
       else
          NameClass := v.ClassName;
//       cbClasses.ItemIndex := cbClasses.Items.IndexOf(NameClass);
       BuildStyles;
       BuildSpecificStyle(NameClass);
       if v.InheritsFrom(TContainer) then
          Value := Tcontainer(v).typ.Style or ws_visible or ws_child;
       if v.InheritsFrom(TDialog) then
          Value := GetWindowLong(TDialog(v).Handle,gwl_style);
    end;}
end;

procedure TWindowStyleDlg.Initialize;
begin
   BuildStyles;
   BuildSpecificStyle(NameClass);
end;

procedure TWindowStyleDlg.ClearAndFree;
var
   i :integer;
begin
   if ListBox=nil then exit;
   if ListBox.Count=0 then exit;
   for i := ListBox.Items.Count-1 downto 0 do
       TWindowStyle(ListBox.Items.Objects[i]).Free;
   ListBox.Clear;
end;

procedure TWindowStyleDlg.cbClassesCloseUp(Sender: TObject);
begin
    ListBox.Clear;
    NameClass:= cbClasses.Items[cbClasses.itemindex];
    BuildStyles;
    BuildSpecificStyle(NameClass);
    ListBox.Items.Assign(StylesList);
end;

procedure TWindowStyleDlg.ComputeStyle;
var
   i:integer;
   x :uint;
   s :string;
   W :TWindowStyle;
begin
    if not cbxAsConstants.Checked then begin
       x:=0;
       for i := 0 to ListBox.Items.Count-1 do begin
           if ListBox.Selected[i] then begin
              W := TWindowStyle(ListBox.Items.Objects[I]);
              x:= x or W.Value ;
           end
       end;
       EditStyle.Text := inttostr(x);
       EditStyle.Hint:= EditStyle.Text;
    end else begin
       s:='';
       for i := 0 to ListBox.Items.Count-1 do begin
           if ListBox.Selected[i] then begin
              W := TWindowStyle(ListBox.Items.Objects[I]);
              s:= s +' | ' + W.Name ;
           end;
       end;
       EditStyle.Text := s;
       EditStyle.Hint:= s;
    end;
    Clipboard.Open;
    ClipBoard.AsText;
    Clipboard.SetTextBuf(PChar(EditStyle.Text));
    Clipboard.Close;
    if fControl<>nil then begin
       SetWindowLong(TContainer(fControl).HostedHandle,gwl_style,Value);
       SetWindowPos(TContainer(fControl).HostedHandle,0,0,0,0,0,swp_noactivate or swp_nozorder or swp_nomove or swp_nosize or swp_framechanged);
       UpdateWindow(TContainer(fControl).HostedHandle);
       TContainer(fControl).Repaint;
    end;
end;

procedure TWindowStyleDlg.btnBrowseClick(Sender: TObject);
begin
   ComputeStyle;
end;

procedure TWindowStyleDlg.FormShow(Sender: TObject);
begin
    ClearAndFree;
    BuildStyles;
    BuildSpecificStyle;
    ListBox.Items.Assign(StylesList);
    if ActiveDialog<>nil then
       if ActiveDialog.ELDesigner.SelectedControls.Count>0 then begin
          fControl:=ActiveDialog.ELDesigner.SelectedControls[0] as TWinControl;
          Value:=GetWindowLong(TContainer(ActiveDialog.ELDesigner.SelectedControls[0]).HostedHandle,gwl_style);
       end;
end;

procedure TWindowStyleDlg.btOKClick(Sender: TObject);
begin
   ModalResult:=mrOk;
   Close;
end;

procedure TWindowStyleDlg.btCancelClick(Sender: TObject);
begin
   ModalResult:=mrCancel;
   Close;
end;

end.
