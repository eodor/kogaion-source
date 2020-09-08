unit ObjectsTreeUnit;

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
  Dialogs, Menus, ImgList, ComCtrls, ToolWin, DialogUnit, ScannerUnit;

type
  TObjectsTree = class(TForm)
    TreeView: TTreeView;
    ToolBar: TToolBar;
    s1: TToolButton;
    tbAdd: TToolButton;
    tbRemove: TToolButton;
    s2: TToolButton;
    tbUp: TToolButton;
    tbDown: TToolButton;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    menuDelete: TMenuItem;
    N1: TMenuItem;
    menuFont: TMenuItem;
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure menuDeleteClick(Sender: TObject);
    procedure menuFontClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
  private
    { Private declarations }
    fDialog:TWinControl;
    procedure SetDialog(v:TWinControl);
    procedure Enum(v:TWinControl);
  public
    { Public declarations }
    function Find(v:TObject):TTreeNode;overload;
    function Find(v:string):TTreeNode;overload;
    procedure AddObject(v:TObject);
    procedure DeleteObject(v:TObject);
    procedure UpdateDialog;
    property Dialog:TWinControl read fDialog write SetDialog;
  end;

var
  ObjectsTree: TObjectsTree;

implementation

{$R *.dfm}

uses MainUnit, ContainerUnit, InspectorUnit;

procedure TObjectsTree.UpdateDialog;
begin
   TreeView.Items.Clear;
   TDialog(fDialog).Node:=TreeView.Items.AddObject(nil,fDialog.Name,fDialog); 
   if fDialog<>nil then begin
      Enum(fDialog);
      TreeView.FullExpand
   end   
end;

procedure TObjectsTree.Enum(v:TWinControl);
var
      i:integer;
      N:TTreeNode;
begin
       for i:=0 to v.ControlCount-1 do begin
           if v.Controls[i].InheritsFrom(TContainer) then begin
              if v.Controls[i].Parent.InheritsFrom(TContainer) then
                 N:=TContainer(v.Controls[i].Parent).Node
              else
                 N:=TDialog(v.Controls[i].Parent).Node;
              TContainer(v.Controls[i]).Node:=TreeView.Items.AddChildObject(N,v.Controls[i].Name,v.Controls[i]);
              Enum(v.Controls[i] as TWinControl);
           end
       end
end;

procedure TObjectsTree.SetDialog(v:TWinControl);
var
   i:integer;

begin
    TreeView.Items.Clear;
    fDialog:=v;
    if v<>nil then begin
       TDialog(v).Node:=TreeView.Items.AddObject(nil,v.Name,v);
       Enum(v);
    end
end;

function TObjectsTree.Find(v:TObject):TTreeNode;
var
   i:integer;
begin
   result:=nil;
   if v=nil then exit;
   for i:=0 to TreeView.Items.Count-1 do
       if TreeView.Items[i].Data=v then begin
          result:=TreeView.Items[i];
          exit;
       end
end;

function TObjectsTree.Find(v:string):TTreeNode;
var
   i:integer;
begin
   result:=nil;
   if v='' then exit;
   for i:=0 to TreeView.Items.Count-1 do
       if TreeView.Items[i].Text=v then begin
          result:=TreeView.Items[i];
          exit;
       end
end;

procedure TObjectsTree.AddObject(v:TObject);
begin
    if Find(v)=nil then
       if v.InheritsFrom(TWinControl) then begin
          
          if v.InheritsFrom(TDialog) then
             TDialog(v).Node:=TreeView.Items.AddChildObject(Find(TWinControl(v).Parent),TWinControl(v).Name,v)
          else
          if v.InheritsFrom(TContainer) then
             TContainer(v).Node:=TreeView.Items.AddChildObject(Find(TWinControl(v).Parent),TWinControl(v).Name,v)
;
       end;
     TreeView.FullExpand;
end;

procedure TObjectsTree.DeleteObject(v:TObject);
begin
    if Find(v)<>nil then
       TreeView.Items.Delete(Find(v));
end;

procedure TObjectsTree.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i:integer;
begin
    if TreeView.GetNodeAt(x,y)=nil then begin
       for i:=TreeView.Items.Count-1 downto 0 do
           if TreeView.Items[i].Selected then
              TreeView.Items[i].Selected:=false;
       if fDialog<>nil then
          TDialog(fDialog).ELDesigner.SelectedControls.Clear;
    end
end;

procedure TObjectsTree.TreeViewGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
      if Dialog<>nil then begin
        if TreeView.SelectionCount>1 then
            with TDialog(fDialog).ELDesigner.SelectedControls do
                 if indexof (TControl(Node.Data))=-1 then
                    Add(TControl(Node.Data));
      end
end;

procedure TObjectsTree.menuDeleteClick(Sender: TObject);
begin
    if fDialog<>nil then
       TDialog(fDialog).DeleteObjects;
end;

procedure TObjectsTree.menuFontClick(Sender: TObject);
begin
        with TFontDialog.Create(nil) do begin
         Font:=TreeView.Font;
         if Execute then
            TreeView.Font:=Font;
         Free   
    end;
end;

procedure TObjectsTree.TreeViewClick(Sender: TObject);
begin
    if TreeView.Selected<>nil then
       if TreeView.Selected.Data<>nil then
          Inspector.ReadObject(TPersistent(TreeView.Selected.Data));
end;

end.
