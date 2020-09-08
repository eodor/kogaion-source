unit MenuEditorUnit;

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
  Dialogs, Menus, ComCtrls, PropertyEditUnit, StdCtrls, StrUtils, DialogUnit;

type
  TMenuEditorDlg = class(TPropertyEditor)
    MainMenu: TMainMenu;
    PopupMenu: TPopupMenu;
    menuAdd: TMenuItem;
    menuRemove: TMenuItem;
    N1: TMenuItem;
    menuClear: TMenuItem;
    StatusBar: TStatusBar;
    Label1: TLabel;
    procedure menuAddClick(Sender: TObject);
    procedure menuRemoveClick(Sender: TObject);
    procedure menuClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
    fSelected :TMenu;
    fEditMenu:TMainMenu;
    fDialog:TDialog;
    procedure SetDialog(v:TDialog);
  public
    { Public declarations }
    procedure MenuClick(Sender :TObject);
    procedure BuildMenuResources;
    property Selected: TMenu read fSelected;
    property EditMenu:TMainMenu read fEditMenu write fEditMenu;
    property Dialog:TDialog read fDialog write SetDialog;
  end;

  QMainMenu=class(TMainMenu);
  QPopupMenu=class(TPopupMenu);
  QMenuItem=class(TMenuItem);

var
  MenuEditorDlg: TMenuEditorDlg;

implementation

{$R *.dfm}

uses LauncherUnit, MainUnit, InspectorUnit, ResourceDialogUnit;

procedure TMenuEditorDlg.SetDialog(v:TDialog);
begin
    fDialog:=v;
    if v<>nil then begin
       if v.Menu<>nil then begin
          EditMenu:=v.Menu;
          v.Menu:=nil;
          Menu:=EditMenu;
        end;
        Show;
    end
end;

procedure TMenuEditorDlg.MenuClick(Sender :TObject);
var
   c :string;
begin
    fSelected :=TMenu(Sender);
    c:= TMenuItem(fSelected).Caption ;
    c:=StringReplace(c,'&','',[]);
    StatusBar.SimpleText :=format('Last Item Selected:  %s',[c]);
    with Inspector do begin
         Properties.Clear;
         Properties.Add(fSelected);
    end;
end;

procedure TMenuEditorDlg.menuAddClick(Sender: TObject);
var
   Mi :QMenuItem;
   c :string;
begin
   c := format('myItem%d',[MainMenu.ComponentCount]);
   if InputQuery('MenuItem Caption',';Insert a caption text for MenuItem:',c) then begin
      Mi :=QMenuItem.Create(MainMenu);
      Mi.OnClick:=MenuClick;
      Mi.Caption:=c;
      if fSelected.InheritsFrom(QMenuItem) then
         QMenuItem(fSelected).Add(Mi) else
      if fSelected.InheritsFrom(TMainMenu) then
         TMainMenu(fSelected).Items.Add(Mi)   ;
      with Inspector do begin
         Properties.Clear;
         Properties.Add(Mi);
      end;
      if Menu<>nil then

   end;   
end;

procedure TMenuEditorDlg.menuRemoveClick(Sender: TObject);
var
   P :TMenu;
begin
   if fSelected.InheritsFrom(TMenu) then exit;
   P:=nil;
   if fSelected.InheritsFrom(TMenuItem) then begin
      StatusBar.SimpleText:=format('Menu Selected: %s',[TMenuItem(fSelected).Parent.Name]);
      P := TMenu(TMenuItem(fSelected).Parent);
   end;
   TObject(fSelected).Free; fSelected:=P;
   with Inspector do begin
         Properties.Clear;
         Properties.Add(fSelected);
   end;
end;

procedure TMenuEditorDlg.menuClearClick(Sender: TObject);
begin
    Menu.Items.Clear;
    fSelected:=Menu;
    StatusBar.SimpleText:=format('Menu Selected: %s',[fSelected.Name]);
end;

procedure TMenuEditorDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    EditMenu:=Menu;
    Menu:=nil;
    fDialog.Menu:=EditMenu;
    BuildMenuResources;
end;

procedure TMenuEditorDlg.FormShow(Sender: TObject);
var
   Handled:boolean;
   Msg:TWMKey;
begin
   Handled:=false;
   Msg.CharCode:=vk_f3;
   FormShortCut(Msg,Handled);
end;

procedure TMenuEditorDlg.BuildMenuResources;
var
   L:TStrings;
   Level:integer;
   s:string;
   i:integer;
   procedure Enum(Mi:TMenuItem);
   var
      i:integer;
      s,space:string;
   begin
       inc(level);
       for i:=0 to Level do
           space:=space+#32;
       if Mi.Count>0 then begin
          s:='POPUP "%s"';
          L.AddObject(format(space+s,[Mi.Caption]),Mi);
          L.AddObject(space+'BEGIN',Mi);
       end else begin
          if Mi.Caption='-' then
             s:='MENUITEM SEPARATOR'
          else
             s:='MENUITEM "%s", %d';
          L.AddObject(format(space+s,[Mi.Caption, Mi.command]),Mi);
       end;
       for i:=0 to Mi.Count-1 do
          Enum(Mi.Items[i]);
       if Mi.Count>0 then L.AddObject(space+'END',Mi)
   end;
begin
    level:=0;
    L:=TStringList.Create;
    L.AddObject(format('%s MENU',[uppercase(MainMenu.Name)]),MainMenu);
    L.AddObject('BEGIN',MainMenu);
    for i:=0 to MainMenu.Items.Count-1 do begin
        level:=1;
        Enum(MainMenu.Items[i]);
    end;
    L.AddObject('END',MainMenu);
    resources.Menus.AddStrings(L);
    L.Free;
end;

procedure TMenuEditorDlg.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
    if Msg.CharCode=vk_f3 then begin
       fSelected:=MainMenu;
       StatusBar.SimpleText:=format('Menu Selected: %s',[fSelected.Name]);
       with Inspector do begin
         Properties.Clear;
         Properties.Add(fSelected);
       end;
       Handled:=true
    end;
end;

end.
