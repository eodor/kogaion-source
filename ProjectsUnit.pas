unit ProjectsUnit;


interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ImgList, TypesUnit, Menus, StdCtrls, PageSheetUnit,
  CheckLst, ExtCtrls;

type
  TProjects = class(TForm)
    PanelProjects: TPanel;
    PanelGroups: TPanel;
    ToolBar: TToolBar;
    s3: TToolButton;
    tbNewProject: TToolButton;
    tbRemoveProject: TToolButton;
    s1: TToolButton;
    tbAddInProject: TToolButton;
    tbRemoveFromProject: TToolButton;
    s4: TToolButton;
    tbViewSource: TToolButton;
    s2: TToolButton;
    tbProjectProperties: TToolButton;
    TreeView: TTreeView;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    menuAddProject: TMenuItem;
    menuDeleteProject: TMenuItem;
    N1: TMenuItem;
    menuAddinProject: TMenuItem;
    menuRemovefromProject: TMenuItem;
    N2: TMenuItem;
    menuViewSource: TMenuItem;
    CheckListBox: TCheckListBox;
    PopupMenuGroup: TPopupMenu;
    menuViewSourceGroup: TMenuItem;
    procedure tbRemoveProjectClick(Sender: TObject);
    procedure tbAddInProjectClick(Sender: TObject);
    procedure tbRemoveFromProjectClick(Sender: TObject);
    procedure tbViewSourceClick(Sender: TObject);
    procedure menuAddProjectClick(Sender: TObject);
    procedure menuDeleteProjectClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure menuViewSourceClick(Sender: TObject);
    procedure menuAddinProjectClick(Sender: TObject);
    procedure menuRemovefromProjectClick(Sender: TObject);
    procedure TreeViewEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tbProjectPropertiesClick(Sender: TObject);
    procedure menuViewSourceGroupClick(Sender: TObject);
    procedure tbNewProjectClick(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ViewSource;
    procedure UpdateToolBar;
    procedure Execute;
    procedure NewProject;
    procedure RemoveProject;
    procedure AddInProject;
    procedure RemoveFromProject;
    procedure RemovePage(v:string);
    procedure GroupProjects;
  end;

var
  Projects: TProjects;

implementation

{$R *.dfm}

uses MainUnit, ContainerUnit, LauncherUnit, CodeUnit,
  ProjectPropertiesUnit;

procedure TProjects.RemovePage(v:string);
var
   i,j,k:integer;
   P:TProject;
   Ps:TPageSheet;
   procedure RemoveFromSource;
   var
      i:integer;
      s:string;
   begin
       if ActiveProject.Page<>nil then begin
          for i:=0 to TPageSheet(ActiveProject.Page).Frame.Edit.Lines.Count-1 do begin
              s:=TPageSheet(ActiveProject.Page).Frame.Edit.Lines[i];
              if (pos('#include ',lowercase(s))>0) and (pos(lowercase(v),lowercase(s))>0) then
                 TPageSheet(ActiveProject.Page).Frame.Edit.Lines.Delete(i);
          end
       end
   end;
begin
    Ps:=Launcher.isOpen(v);
    if Ps<>nil then
       case messageDlg('Are you sure?',mtConfirmation,[mbyes,mbno],0) of
            mryes: begin
            if ActiveProject<>nil then begin
               i:=ActiveProject.Files.IndexOf(v);
               if i>-1 then ActiveProject.Files.Delete(i);
            end;
            Ps.Dispose;
            RemoveFromSource;
            end;
       end;
    if TreeView.Selected<>nil then TreeView.Selected.Free ;
    i:=ActiveProject.Files.IndexOfObject(TreeView.Selected.Data);
    if i>-1 then ActiveProject.Files.Delete(i);
    UpdateToolBar;
end;


procedure TProjects.Execute;
begin
   Projects.Visible:=true;
   TreeView.FullExpand;
end;

procedure TProjects.ViewSource;
var         
  s:string;
  Ps:TPageSheet;
begin
    if ActiveProject<>nil then begin

       ActiveProject.BuildSource; 

          if ActiveProject.Saved then
             s:=ActiveProject.FileName
          else
             s:=ActiveProject.Text;
       Ps:=newEditor(s);
       Ps.Caption:=ActiveProject.Name;
       Ps.Project:=ActiveProject;
       ActiveProject.Page:=Ps;
       UpdateToolBar;
    end{}
end;

procedure TProjects.UpdateToolBar;
begin
    tbRemoveProject.Enabled:=ActiveProject<>nil;
    tbRemoveFromProject.Enabled:=(ActiveProject<>nil) and (ActiveProject.Files.Count>0);
    tbAddInProject.Enabled:=(ActiveProject<>nil);
    tbViewSource.Enabled:=(ActiveProject<>nil) and not (ActiveProject.Page<>nil) ;
    tbProjectProperties.Enabled:=ActiveProject<>nil;
end;

procedure TProjects.NewProject;
begin
   ActiveProject:=Launcher.NewProject;
end;

procedure TProjects.RemoveProject;
begin
    if ActiveProject<>nil then
       case messageDlg(format('Are you sure to want remove %s?',[ActiveProject.Name]),mtConfirmation,[mbyes,mbno],0) of
           mryes: begin
                  ActiveProject.Node.Free;
                  ActiveProject.Free;
                  ActiveProject:=nil;
                  updateToolBar;
           end;
           mrno: Abort;
       end
end;

procedure TProjects.AddInProject;
var
    x:integer;
    V:STRING;
    procedure AddInSource;
    begin
        if ActiveProject.Page<>nil then begin
           x:=TPageSheet(ActiveProject.Page).Frame.Edit.Lines.IndexOf('application.run');
           if x=-1 then x:=TPageSheet(ActiveProject.Page).Frame.Edit.Lines.Count-1;
           TPageSheet(ActiveProject.Page).Frame.Edit.Lines.Insert(x,format('#include once "%s"',[v]));
        end
    end;
begin
    with TOpenDialog.Create(nil) do begin
         if Execute then begin
            if ActiveProject<>nil then begin
               ActiveProject.AddPage(FileName); v:=FileName;
               ActiveProject.Saved:=false;
               AddInSource;
            end
         end;
         Free
    end;
end;

procedure TProjects.RemoveFromProject;
var
   i:integer;
begin
    if TreeView.Selected<>nil then
       if TreeView.Selected.Data<>nil then
          if not TObject(TreeView.Selected.Data).InheritsFrom(TProject) then
             if FileExists(TPageSheet(TreeView.Selected.Data).FileName) then
                removePage(TPageSheet(TreeView.Selected.Data).FileName)
             else
                 if ActiveProject<>nil then begin
                    i:=ActiveProject.Files.IndexOfObject(TreeView.Selected.Data) ;
                    if i>-1 then ActiveProject.Files.Delete(i);
                    TreeView.Selected.Free;
                 end;
    UpdateToolbar;
end;

procedure TProjects.tbRemoveProjectClick(Sender: TObject);
begin
   RemoveProject;
end;

procedure TProjects.tbAddInProjectClick(Sender: TObject);
begin
    AddInProject;
end;

procedure TProjects.tbRemoveFromProjectClick(Sender: TObject);
begin
    RemoveFromProject;
end;

procedure TProjects.tbViewSourceClick(Sender: TObject);
begin
   ViewSource;
end;

procedure TProjects.menuAddProjectClick(Sender: TObject);
begin
    newProject
end;

procedure TProjects.menuDeleteProjectClick(Sender: TObject);
begin
    RemoveProject;
end;

procedure TProjects.TreeViewClick(Sender: TObject);
begin
    //if ActiveProject<>nil then
       if TreeView.Selected<>nil then
          if TreeView.Selected.Data<>nil then begin
             if TObject(TreeView.Selected.Data).InheritsFrom(TProject) then begin
                ActiveProject:=TProject(TreeView.Selected.Data);
             end else
             if TObject(TreeView.Selected.Data).InheritsFrom(TPageSheet) then begin
                Code.PageControl.ActivePage:=TPageSheet(TreeView.Selected.Data);
             end
          end  ;
    UpdateToolBar;      
end;

procedure TProjects.menuViewSourceClick(Sender: TObject);
begin
    ViewSource
end;

procedure TProjects.menuAddinProjectClick(Sender: TObject);
begin
      AddInProject
end;

procedure TProjects.menuRemovefromProjectClick(Sender: TObject);
begin
    RemoveFromProject
end;

procedure TProjects.TreeViewEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
   if Node.Data<>nil then begin
      if TObject(Node.Data).InheritsFrom(TProject) then begin
         TProject(Node.Data).Name:=s;
         TProject(Node.Data).UpdatePage(Node.Text,s);
         if TProject(Node.Data).Page<>nil then
            TPageSheet(TProject(Node.Data).Page).Caption:=s;
      end else
      if TObject(Node.Data).InheritsFrom(TPageSheet) then begin
         TPageSheet(Node.Data).Name:=s;
      end
    end
end;

procedure TProjects.TreeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
   //
end;

procedure TProjects.tbProjectPropertiesClick(Sender: TObject);
begin
    ProjectProperties.showmodal
end;

procedure TProjects.GroupProjects;
var
   i,j:integer;
   P:TProject;
   L:TStrings;
begin
   L:=TStringList.Create;
   for i:=0 to CheckListBox.Items.Count-1 do
       if CheckListBox.Checked[i] then begin
          P:=TProject(CheckListBox.Items.Objects[i]);
          if P<>nil then begin
             L.AddObject('/'' was created with RqWork (Kogaion) ''/',P);
             L.Add('');
             L.AddObject(format('#deine isProject%s true',[P.Name]),P);
             L.AddObject(format('#deine %sCompiler "%s"',[P.Name,P.Compiler.FileName]),P);
             L.AddObject(format('#deine %sSwithch "%s"',[P.Name,P.Compiler.Switch]),P);
             L.AddObject(format('#deine %sTarget "%s"',[P.Name,P.Compiler.Target]),P);
             for j:=0 to P.Files.Count-1 do begin
                 L.AddObject(format('#include once "%s"',[P.Files[j]]),P)
             end ;
           end
        end ;
   if L.Count>0 then newEditor(L.Text).Caption:=NamesList.AddName('ProjectGroup');      
   L.Free
end;

procedure TProjects.menuViewSourceGroupClick(Sender: TObject);
begin
   GroupProjects;
end;

procedure TProjects.tbNewProjectClick(Sender: TObject);
begin
    newProject
end;

procedure TProjects.CheckListBoxClick(Sender: TObject);
begin
    if TObject(TreeView.Selected.Data).InheritsFrom(TProject) then
       ActiveProject:=TProject(TreeView.Selected.Data);
end;

end.
