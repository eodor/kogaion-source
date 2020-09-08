unit ToolsUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  ShellApi, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TypesUnit, IniFiles, Menus;

type
  TTools = class(TForm)
    ListBox: TListBox;
    EditParams: TEdit;
    cbxShowMenu: TCheckBox;
    btAdd: TBitBtn;
    btRemove: TBitBtn;
    btExecute: TBitBtn;
    procedure btAddClick(Sender: TObject);
    procedure btRemoveClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure cbxShowMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ToolsMenu:TMenuItem;
    procedure MenuClick(Sender: TObject);
    procedure AddTool;
    procedure RemoveTool;
    procedure ExecuteTool;
    procedure SetMenuTool;
    function ToolExists(v:string):TTool;
  end;

var
  Tools: TTools;
  ActiveTool :TTool;
  ToolsList:TStrings;

implementation

{$R *.dfm}

uses MainUnit;

function TTools.ToolExists(v:string):TTool;
var
   i:integer;
   T:TTool;
begin
    result:=nil;
    for i:=0 to ToolsList.Count-1 do begin
        T:=TTool(ToolsList.Objects[i]);
        if T<>nil then
           if (comparetext(T.FileName,v)=0) or (comparetext(T.Name,v)=0) then begin
              result:=T;
              exit
           end
    end ;
end;

procedure TTools.AddTool;
begin
     with TOpenDialog.Create(nil) do begin
         if Execute then begin
            ActiveTool:=ToolExists(ChangeFileExt(ExtractFileName(FileName),''));
            if ActiveTool<>nil then begin  // update it in case we need that
               ActiveTool.Name := ChangeFileExt(ExtractFileName(FileName),'');
               ActiveTool.FileName := FileName;
               ActiveTool.Params :=EditParams.Text;
            end else begin
            ActiveTool:=TTool.Create;
            ActiveTool.Name := ChangeFileExt(ExtractFileName(FileName),'');
            ActiveTool.FileName := FileName;
            ActiveTool.Params :=EditParams.Text;
            ListBox.AddItem(ActiveTool.Name,ActiveTool);
            ToolsList.AddObject(ActiveTool.Name,ActiveTool)
            end
         end;
         Free;
     end;
end;

procedure TTools.RemoveTool;
var
   i:integer;
begin
    if ListBox.ItemIndex=-1 then exit;
    ActiveTool := TTool(ListBox.Items.Objects[ListBox.ItemIndex]);
    i:=ToolsList.IndexOfObject(ActiveTool) ;
    if i>-1 then ToolsList.Delete(i);
    ListBox.Items.Delete(ListBox.ItemIndex);
    ActiveTool.Free;
    ActiveTool:=nil;
end;

procedure TTools.ExecuteTool;
begin
   if ListBox.ItemIndex=-1 then exit;
   ActiveTool := TTool(ListBox.Items.Objects[ListBox.ItemIndex]);
   if ActiveTool<>nil then
       ShellExecute(0,'open',PChar(ActiveTool.FileName),'','',sw_show); { *Converted from ShellExecute* }
end;

procedure TTools.SetMenuTool;
begin
   if ActiveTool<>nil then begin
      if ActiveTool.InMenu then begin
         if ToolsMenu.Find(ActiveTool.Name)=nil then begin
            ActiveTool.MenuItem:=TMenuItem.Create(ToolsMenu);
            ActiveTool.MenuItem.Caption:=ActiveTool.Name;
            ActiveTool.MenuItem.Tag:=integer(ActiveTool);
            ActiveTool.MenuItem.OnClick:=MenuClick;
            if ToolsMenu<>nil then
               ToolsMenu.Add(ActiveTool.MenuItem);
         end
      end else begin
          if ActiveTool.MenuItem<>nil then begin
             ActiveTool.MenuItem.Free;
             ActiveTool.MenuItem:=nil;
          end
      end
   end
end;


procedure TTools.btAddClick(Sender: TObject);
begin
   AddTool;
end;

procedure TTools.btRemoveClick(Sender: TObject);
begin
    RemoveTool;
end;

procedure TTools.btExecuteClick(Sender: TObject);
begin
    ExecuteTool;
end;

procedure TTools.MenuClick(Sender: TObject);
var
   Tool:TTool;
begin
    Tool:=TTool(TMenuItem(sender).Tag);
    if Tool<>nil then
        ShellExecute(0,'open',PChar(Tool.FileName),'','',sw_show); { *Converted from ShellExecute* }
end;

procedure TTools.cbxShowMenuClick(Sender: TObject);
begin
   if ActiveTool<>nil then begin
      ActiveTool.InMenu:=TCheckBox(sender).Checked;
      SetMenuTool;
   end
end;

procedure TTools.FormCreate(Sender: TObject);
begin
    ListBox.Items.Assign(ToolsList);
    Launcher.addform(self);
end;

procedure TTools.ListBoxClick(Sender: TObject);
begin
    if ListBox.ItemIndex=-1 then exit;
    ActiveTool := TTool(ListBox.Items.Objects[ListBox.ItemIndex]);
    if ActiveTool<>nil then begin
       EditParams.Text :=ActiveTool.Params;
       cbxShowMenu.Checked:=ActiveTool.InMenu;
    end ;
end;

procedure TTools.FormShow(Sender: TObject);
begin
    ListBox.Items.Assign(ToolsList);
end;

initialization
   ToolsList:=TStringList.Create;
finalization
   ToolsList.Free;
end.
