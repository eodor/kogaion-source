unit InspectorUnit;

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
  Dialogs, Menus, StdCtrls, CheckLst, Grids, ELPropInsp, ComCtrls,
  ComboBoxAx, ExtCtrls, DialogUnit, TypInfo, FreeBasicRTTI, TypesUnit;

type
  TInspector = class(TForm)
    Splitter: TSplitter;
    ObjectsBox: TComboBoxAx;
    StatusBar: TStatusBar;
    PageControl: TPageControl;
    TabProperties: TTabSheet;
    Properties: TELPropertyInspector;
    TabEvents: TTabSheet;
    Memo: TMemo;
    PopupMenu: TPopupMenu;
    menuFont: TMenuItem;
    ListView: TListView;
    procedure PropertiesFilterProp(Sender: TObject; AInstance: TPersistent;
      APropInfo: PPropInfo; var AIncludeProp: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ObjectsBoxChange(Sender: TObject);
    procedure PropertiesModified(Sender: TObject);
    procedure menuFontClick(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
  private
    { Private declarations }
    fPage:TTabSheet;
    fDialog:TDialog;
    procedure SetDialog(v:TDialog);
  public
    { Public declarations }
    Filter:TStrings;
    procedure ReadEvents(T:TType);
    procedure UpdateItems;
    procedure Clear;
    procedure Reset;
    procedure ReadObject(v:TPersistent);
    procedure ReadObjects(v:TWincontrol);
    property Page:TTabSheet read fPage write fPage;
    property Dialog:TDialog read fDialog write SetDialog;
  end;

var
  Inspector: TInspector;

implementation

{$R *.dfm}

uses ContainerUnit, PageSheetUnit, MainUnit, DialogsListUnit;

procedure TInspector.ReadEvents(T:TType);
var
   L:TStrings;
   i:integer;
   Li:TListItem;
begin
   ListView.Items.Clear;
   if T=nil then exit;
   if DialogsList.Count=0 then exit;
   L:=TStringList.Create;
      RTTIGetEvents(T.Hosted,L);
      if L.count>0 then
         for i:=0 to L.Count-1 do begin
             Li:=ListView.Items.Add;
             Li.Caption:=L[i];
             Li.Data:=L.Objects[i];
         end;
      L.Free
end;

procedure TInspector.Clear;
begin
   Properties.Clear;
end;

procedure TInspector.Reset;
begin
   Properties.Clear;
   ObjectsBox.Clear;
end;

procedure TInspector.ReadObject(v:TPersistent);
begin
    Properties.Clear;
    if v<>nil then begin
       Properties.Add(v);
       if v.InheritsFrom(TContainer) then
          ReadEvents(TContainer(v).Typ)
       else
       if v.InheritsFrom(TDialog) then
          ReadEvents(TDialog(v).Typ);
    end
end;

procedure TInspector.ReadObjects(v:TWincontrol);
var
     i:integer;
begin
      for i:=0 to v.ControlCount-1 do
          if v.Controls[i].InheritsFrom(TWincontrol) then begin
             ObjectsBox.AddItem(Format('%s :%s',[v.Controls[i].Name,TContainer(v.Controls[i]).Hosted]),v.Controls[i]);
             ReadObjects(v.Controls[i] as TWinControl)
          end
end;

procedure TInspector.UpdateItems;
begin
    SetDialog(fDialog)
end;

procedure TInspector.SetDialog(v:TDialog);
var
   i:integer;

begin
    fDialog:=v;
    Reset;
    
    if v=nil then exit;
    fPage:=v.Page;
    Properties.Designer:=v.ELDesigner;
    ObjectsBox.AddItem(format('%s :%s',[v.Name,v.Hosted]),v);
    ReadObjects(v);
    if (v<>nil) and (v.ELDesigner<>nil) and (v.ELDesigner.SelectedControls.Count>0) then begin
       i:=ObjectsBox.Items.IndexOfObject(v.ELDesigner.SelectedControls.DefaultControl);
       ObjectsBox.ItemIndex:=i;
       Properties.Clear;
       Properties.Add(v.ELDesigner.SelectedControls.DefaultControl);
    end  ;
    
end;

procedure TInspector.PropertiesFilterProp(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);

begin
    if AInstance.InheritsFrom(TDialog) then
       RTTIGetProperties(TDialog(AInstance).Hosted,Filter,'public')
    else
    if AInstance.InheritsFrom(TContainer) then
       RTTIGetProperties(TContainer(AInstance).Hosted,Filter,'public');
    if Filter.IndexOf(APropInfo^.Name)=-1 then AIncludeProp:=false;
end;

procedure TInspector.FormCreate(Sender: TObject);
begin
    Filter:=TStringList.Create;
end;

procedure TInspector.FormDestroy(Sender: TObject);
begin
    Filter.Free;
end;

procedure TInspector.ObjectsBoxChange(Sender: TObject);
var
   P:TObject;
   i:integer;
begin
    i:=ObjectsBox.ItemIndex;
    if i>-1 then begin
       P:=ObjectsBox.Items.Objects[i];
       if fDialog<>nil then begin
          fDialog.ELDesigner.SelectedControls.Clear;
          fDialog.ELDesigner.SelectedControls.Add(TControl(P));
       end
    end

end;

procedure TInspector.PropertiesModified(Sender: TObject);
var
   p, v:string;
begin
    if Properties=nil then exit;
    p:=Properties.ActiveItem.Caption;
    v:=Properties.ActiveItem.DisplayValue;
    if (p<>'') then begin
       if (CompareText(p,'left')=0) or
          (CompareText(p,'top')=0) or
          (CompareText(p,'width')=0) or
          (CompareText(p,'height')=0) then begin
          if ActiveDialog.Page<>nil then
             TPageSheet(ActiveDialog.Page).UpdateControl(TControl(Properties.Objects[0]))
       end else if comparetext(p,'name')=0 then begin
          TPageSheet(ActiveDialog.Page).UpdateControlName(TControl(Properties.Objects[0]));
       end else begin
          if comparetext(p,'color')=0 then begin
          end;
          if fPage<>nil then
             TPageSheet(ActiveDialog.Page).UpdateControl(TControl(Properties.Objects[0]),p,v);
       end
    end; 
    { }   with TPageSheet(ActiveDialog.Page) do
         UpdateControl(TControl(Properties.Objects[0]),Properties.ActiveItem.Caption,Properties.ActiveItem.DisplayValue);
    
end;

procedure TInspector.menuFontClick(Sender: TObject);
begin
    with TFontDialog.Create(nil) do begin
         Font:=Inspector.Font;
         if Execute then
            Inspector.Font:=Font;
         Free
    end;
end;

procedure TInspector.ListViewDblClick(Sender: TObject);
var
   e:string;
   T,ET:TType;
begin
    if ListView.Selected<>nil then begin
       e:=ListView.Selected.Caption;
       T:=TType(ListView.Selected.Data);
       if T<>nil then begin
          ET:=Launcher.TypeExists(T.Return) ;
          if ET<>nil then begin
             if ActiveEditor.UpdateEvent(TControl(Properties.Objects[0]),e,'('+ET.Params+')')<>'' then begin
                ListView.Selected.Checked:=true;
                TContainer(Properties.Objects[0]).AssignedEvents.AddObject(e,ET);
             end
          end
       end ; 
    end
end;

end.
