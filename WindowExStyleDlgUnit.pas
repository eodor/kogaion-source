unit WindowExStyleDlgUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ELPropInsp, ClipBrd;

type
  TExWindowStyleDlg = class(TForm)
    ListBox: TListBox;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    EditStyle: TEdit;
    cbxAsConstants: TCheckBox;
    btnBrowse: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    Fcomponent :TComponent;
    FValue :uint;
    procedure BuildStyles;
    procedure SetValue(value :uint);
    function GetValue :uint;
    procedure SetComponent(value :TComponent);
  public
    { Public declarations }
    NameClass :string;
    procedure Initialize;
    procedure ClearAndFree;
    property Component: TComponent read FComponent write SetComponent;
    function Execute: Boolean;
    procedure ComputeStyle;
    property Value: uint read GetValue write SetValue;
  end;

var
  ExWindowStyleDlg: TExWindowStyleDlg;

implementation

{$R *.dfm}

uses MainUnit, HelperUnit, ContainerUnit, TypesUnit;

procedure TExWindowStyleDlg.FormCreate(Sender: TObject);
begin
   BuildStyles;
end;

function TExWindowStyleDlg.Execute: Boolean;
begin
    Result := (ShowModal = mrOk);
end;

procedure TExWindowStyleDlg.SetValue(value :uint);
var
   i :integer;
   W :TWindowStyle;
begin
    FValue := value;
    for i := 0 to ListBox.Items.Count-1 do begin
        W := TWindowStyle(ListBox.Items.Objects[I]);
        if (W.Value or Value) = value then begin
            ListBox.Selected[i] := true;
        end;
    end;
end;

function TExWindowStyleDlg.GetValue :uint;
var
   i :integer;
   x :uint;
   W :TWindowStyle;
begin
    x:=0;
    for i := 0 to ListBox.Items.Count-1 do begin
        if ListBox.Selected[i] then begin
           W := TWindowStyle(ListBox.Items.Objects[I]);
           x:= x or W.Value ;
        end ;
    end;
    result :=x;
end;

procedure TExWindowStyleDlg.SetComponent(value :TComponent);
begin
    FComponent := value;
    if value <> nil then begin
       if value.InheritsFrom(TContainer) then
          NameClass := Tcontainer(value).Typ.Hosted
       else
          NameClass := value.ClassName;
       BuildStyles;
    end;
end;

procedure TExWindowStyleDlg.Initialize;
begin
   BuildStyles;
end;

procedure TExWindowStyleDlg.ClearAndFree;
var
   i :integer;
begin
   for i := ListBox.Items.Count-1 downto 0 do
       TWindowStyle(ListBox.Items.Objects[i]).Free;
   ListBox.Clear;
end;

procedure TExWindowStyleDlg.BuildStyles;
var
   S :TWindowStyle;
   i :integer;
begin
    for i := ListBox.Items.Count-1 downto 0 do
        TWindowStyle(ListBox.Items.Objects[i]).Free;
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_DLGMODALFRAME';
    S.Value := WS_EX_DLGMODALFRAME;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_NOPARENTNOTIFY';
    S.Value := WS_EX_NOPARENTNOTIFY;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_TOPMOST';
    S.Value := WS_EX_TOPMOST;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_ACCEPTFILES';
    S.Value := WS_EX_ACCEPTFILES;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_TRANSPARENT';
    S.Value := WS_EX_TRANSPARENT;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_MDICHILD';
    S.Value := WS_EX_MDICHILD;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_TOOLWINDOW';
    S.Value := WS_EX_TOOLWINDOW;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_WINDOWEDGE';
    S.Value := WS_EX_WINDOWEDGE;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_CLIENTEDGE';
    S.Value := WS_EX_CLIENTEDGE;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_CONTEXTHELP';
    S.Value := WS_EX_CONTEXTHELP;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_RIGHT';
    S.Value := WS_EX_RIGHT;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_LEFT';
    S.Value := WS_EX_LEFT;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_RTLREADING';
    S.Value := WS_EX_RTLREADING;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_LTRREADING';
    S.Value := WS_EX_LTRREADING;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_LEFTSCROLLBAR';
    S.Value := WS_EX_LEFTSCROLLBAR;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_RIGHTSCROLLBAR';
    S.Value := WS_EX_RIGHTSCROLLBAR;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_CONTROLPARENT';
    S.Value := WS_EX_CONTROLPARENT;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_STATICEDGE';
    S.Value := WS_EX_STATICEDGE;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_APPWINDOW';
    S.Value := WS_EX_APPWINDOW;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_OVERLAPPEDWINDOW';
    S.Value := WS_EX_OVERLAPPEDWINDOW;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_PALETTEWINDOW';
    S.Value := WS_EX_PALETTEWINDOW;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_LAYERED';
    S.Value := WS_EX_LAYERED;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_NOINHERITLAYOUT';
    S.Value := WS_EX_NOINHERITLAYOUT;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_LAYOUTRTL';
    S.Value := WS_EX_LAYOUTRTL;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_COMPOSITED';
    S.Value := WS_EX_COMPOSITED;
    ListBox.AddItem(S.Name, S);
    S := TWindowStyle.Create;
    S.Name := 'WS_EX_NOACTIVATE';
    S.Value := WS_EX_NOACTIVATE;
    ListBox.AddItem(S.Name, S);
end;

procedure TExWindowStyleDlg.ComputeStyle;
var
   i :integer;
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
end;

procedure TExWindowStyleDlg.btnBrowseClick(Sender: TObject);
begin
   ComputeStyle;
end;

procedure TExWindowStyleDlg.btCancelClick(Sender: TObject);
begin
    ModalResult:=mrCancel;
    Close;
end;

procedure TExWindowStyleDlg.btOKClick(Sender: TObject);
begin
   ModalResult:=mrOk;
   Close;
end;

end.
