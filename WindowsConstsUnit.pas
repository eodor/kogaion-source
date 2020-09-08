unit WindowsConstsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TypesUnit, ClipBrd, CompletionDataBase;

type
  TWindowsConstants = class(TForm)
    ListBox: TListBox;
    EditSearch: TEdit;
    btSearch: TBitBtn;
    EditValue: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fConstants:TStrings;
    fdb:TCompletionDataBase;
    procedure SetDB(v:TCompletionDataBase);
  public
    { Public declarations }
    property DB:TCompletionDataBase read fdb write SetDB;
  end;


var
  WindowsConstants: TWindowsConstants;

implementation

{$R *.dfm}

uses MainUnit;

procedure TWindowsConstants.SetDB(v:TCompletionDataBase);
begin
    fdb:=v;
    if v<>nil then
       fConstants.AddStrings(v.Constants);
end;

procedure TWindowsConstants.FormCreate(Sender: TObject);
var
   i,vr,e :integer;
   c :TField;
   s, n, v :string;
   Rs:TResourceStream;

begin
    fConstants:=TStringList.Create;
    if FindResource(hinstance,'consts',PChar('text'))>0 then begin
       Rs:=TResourceStream.Create(hinstance,'consts',PChar('text'));
       fConstants.LoadFromStream(Rs);
       if fConstants.Count>0  then begin 
       for i :=0 to fConstants.Count-1 do begin
          if fConstants[i]<>'' then begin
             if fConstants[i][1]<>';' then begin
                s := Trim( LowerCase(fConstants[i]) );
                if pos('const ',s)>0 then begin
                   s := Trim(Copy(s,pos(' ',s)+1,Length(s)));
                   n := Trim(Copy(s,1,pos('=',s)-1));
                   v := Trim(Copy(s,pos('=',s)+1,length(s)));
                   if ListBox.Items.IndexOf(n)=-1 then begin
                      c := TField.Create;
                      c.Name := n;
                      val(v,vr,e);
                      if e=0 then
                         c.value := v;
                      ListBox.AddItem(c.Name,c);
                   end;
                end;
             end;
          end;
       end;
    end;
    Rs.Free
    end;
end;

procedure TWindowsConstants.btSearchClick(Sender: TObject);
var
   i, v, e :integer;
begin
    val(EditSearch.Text,v,e);
    if e=0 then begin
       for i := 0 to ListBox.Items.Count-1 do
           if TField(ListBox.Items.Objects[i]).Value=EditSearch.Text then begin
              ListBox.ItemIndex := i;
              EditValue.Text := ListBox.Items[i];
              exit;
           end;
     end else begin
         i := ListBox.Items.IndexOf(EditSearch.Text);
         if i>-1 then begin
            ListBox.ItemIndex := i;
            EditValue.Text := TField(ListBox.Items.Objects[ListBox.ItemIndex]).value;
            exit;
         end;
     end;
     messageDlg(Format('The %s constants are untrouvaible.',[EditSearch.Text]),mtInformation,[mbok],0);
end;

procedure TWindowsConstants.ListBoxDblClick(Sender: TObject);
var
   c :TField;
begin
    if ListBox.ItemIndex>-1 then begin
       c := TField(ListBox.Items.Objects[ListBox.ItemIndex]);
       if c<>nil then begin
          Clipboard.Open;
          Clipboard.SetTextBuf(PChar(string(c.Value)));
          Clipboard.Close;
          ListBox.Hint :=Format('value %d copied to clipboard.',[c.Value]);
          ListBox.ShowHint := true;
       end;
    end ;
end;

procedure TWindowsConstants.ListBoxClick(Sender: TObject);
begin
   ListBox.Hint :='';
   ListBox.ShowHint := true;
   EditSearch.Text := ListBox.Items[ListBox.ItemIndex];
   EditValue.Text :=Format('%d',[integer(TField( ListBox.Items.Objects[ListBox.ItemIndex]).Value)]);
end;

procedure TWindowsConstants.FormDestroy(Sender: TObject);
begin
    fConstants.Free;
end;

end.
