unit ActiveXUnit;

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
  Dialogs, HelperUnit, StdCtrls, Buttons, ActiveX, ComObj, Menus;

type
  TActiveX = class(TForm)
    ListBox: TListBox;
    ListBoxClasses: TListBox;
    ldDLL: TLabel;
    PopupMenu: TPopupMenu;
    menuSave: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ListActiveXDLLs;
  end;

var
  ActiveX: TActiveX;
  selDLL :TTypeLib;
  Ifc :iClassFactory;
  IC :Pointer;
  GetTypeClass :function(RIID:TGuid; icf:iClassFactory; ici :Pointer ):PChar; stdcall;

implementation

uses MainUnit;

{$R *.dfm}

procedure TActiveX.ListActiveXDLLs;
begin
    GetWin32TypeLibList(ListBox.Items);
end;

procedure TActiveX.FormShow(Sender: TObject);
begin
    ListActiveXDLLs;
end;

procedure TActiveX.ListBoxClick(Sender: TObject);
var
   i :integer;
   hDLL :hmodule;
begin
    i := ListBox.ItemIndex;
    if i>-1 then begin
       selDLL :=TTypeLib(ListBox.Items.Objects[i]);
       if selDLL<>nil then begin
          hDLL:= LoadLibrary(PChar(selDLL.FileName));
          if hDLL>0 then begin
             GetTypeClass :=GetProcAddress(hDLL,'DllGetClassObject');
             if @GetTypeClass<>nil then
                NewEditor(selDLL.FileName);
             ListBoxClasses.Items.Add(selDLL.Name);
             ListBoxClasses.Items.Add(selDLL.Win32);
             ListBoxClasses.Items.Add(selDLL.FileName);
             FreeLibrary(hDLL);
          end;
       end;
    end;
end;

procedure TActiveX.menuSaveClick(Sender: TObject);
begin
   ListBoxClasses.Items.SaveToFile(ideDir+'ActiveX.txt');
   NewEditor(ideDir+'ActiveX.txt');
end;

end.
