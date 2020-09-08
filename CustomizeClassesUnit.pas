unit CustomizeClassesUnit;

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
  Dialogs, StdCtrls, CheckLst, Buttons, TypesUnit, ComCtrls, CustomizeClassesFrame,
  Menus;

type
  TCCSheet=class(TTabSheet)
  private
    fFrame:TCustClassesFrame;
  public
    constructor create(aowner:tcomponent);override;
    destructor destroy; override;
    property Frame:TCustClassesFrame read fFrame;
  end;
  
  TCustomizeClasses = class(TForm)
    btOK: TBitBtn;
    btCancel: TBitBtn;
    PageControl: TPageControl;
    PopupMenu: TPopupMenu;
    menuAddClass: TMenuItem;
    N1: TMenuItem;
    menuPalette: TMenuItem;
    menuAddPalette: TMenuItem;
    menuRemove: TMenuItem;
    N2: TMenuItem;
    menuHide: TMenuItem;
    procedure btOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure menuAddPaletteClick(Sender: TObject);
    procedure menuRemoveClick(Sender: TObject);
    procedure menuHideClick(Sender: TObject);
    procedure menuAddClassClick(Sender: TObject);
  private
    { Private declarations }
    fClasses:TPageControl;
    procedure SetClasses(v:TPageControl);
  public
    { Public declarations }
    procedure Reset;
    property Classes:TPageControl read fClasses write SetClasses;
  end;

var
  CustomizeClasses: TCustomizeClasses;

implementation

{$R *.dfm}

uses MainUnit, LauncherUnit, ScannerUnit, ClassModuleUnit;

{ TCCSheet }
constructor TCCSheet.create(aowner:tcomponent);
begin
    inherited;
    fFrame:=TCustClassesFrame.Create(self);
    fFrame.Align:=alClient;
    fFrame.Parent:=self;
end;

destructor TCCSheet.destroy;
begin
    inherited;
end;

{ TCustomizelasses }
procedure TCustomizeClasses.SetClasses(v:TPageControl);
var
  i,j:integer;
  P:TTabSheet;
  T:TCCSheet;
begin
    Reset;
    if v=nil then exit;
    for i:=0 to v.PageCount-1 do begin
        P:=v.Pages[i];
        if P<>nil then begin
           T:=TCCSheet.create(PageControl);
           T.Caption:=P.Caption;
           T.PageControl:=PageControl;
           for j:=1 to P.ControlCount-1  do   
               if TPaletteButton(P.Controls[j]).typ<>nil then
                  T.fFrame.CheckListBox.AddItem(TPaletteButton(P.Controls[j]).Typ.Hosted,TPaletteButton(P.Controls[j]).Typ);
        end;
    end

end;

procedure TCustomizeClasses.Reset;
var
  i:integer;
begin
    for i:=PageControl.PageCount-1 downto 0 do
        TCCSheet(PageControl.Pages[i]).Free;
end;

procedure TCustomizeClasses.btOKClick(Sender: TObject);
var
   i,j ,x :integer;
   s :string;
   B :TPaletteButton;
   P:TCCSheet;
   function CheckCount :integer;
   var
      i,j :integer;
   begin
      result :=0;
      for j:=0 to PageControl.PageCount-1 do begin
          P:=TCCSheet(PageControl.Pages[j]);
          for i :=0 to P.fFrame.CheckListBox.Items.Count-1 do
             if P.fFrame.CheckListBox.Checked[i] then inc(result);
      end
   end;
begin
   s := '';
   for i:=0 to PageControl.PageCount-1 do begin
       P:=TCCSheet(PageControl.Pages[i]);
       for j :=0 to P.fFrame.CheckListBox.Items.Count-1 do
           if P.fFrame.CheckListBox.Checked[j] then
              if i=0 then
                 s := s+P.fFrame.CheckListBox.Items[j]
              else
                 s := s+', '+P.fFrame.CheckListBox.Items[j];
   end;
   x:=0;
   for i:=1 to length(s) do
       if s[i]=',' then begin
          inc(x);
          if x>4 then begin
             s[i]:=#10;
             x:=0;
          end;
        end;
   if CheckCount>0 then
      case messageDlg(format('Remove %s?',[s]),mtConfirmation,[mbyes,mbno],0) of
      mryes : begin

          for j:=0 to PageControl.PageCount-1 do begin
              P:=TCCSheet(PageControl.Pages[j]);
              for i :=P.fFrame.CheckListBox.Items.Count-1 downto 0 do
                  if P.fFrame.CheckListBox.Checked[i] then begin
                     B := Launcher.isButton(P.fFrame.CheckListBox.Items[i]) ;
                     if B<>nil then begin
                        x:=Launcher.Classes.IndexOf(P.fFrame.CheckListBox.Items[i]);
                        if x>-1 then Launcher.Classes.Delete(x);
                        B.Free;
                     end;
                     P.fFrame.CheckListBox.Items.Delete(i);
                  end;
              Launcher.UpdateItems;
              end
          end
      end;

      P:=TCCSheet(PageControl.ActivePage);
      for i :=0 to P.fFrame.CheckListBox.Items.Count-1 do begin
          B:=Launcher.AddClass(P.Caption,P.fFrame.CheckListBox.Items[i]);
          if FindResource(Bridge,PChar(P.fFrame.CheckListBox.Items[i]),rt_bitmap)>0 then
             B.Glyph.LoadFromResourceName(Bridge,P.fFrame.CheckListBox.Items[i]);
      end;
      if Launcher.isPage(P.Caption)<>nil then
         Launcher.isPage(P.Caption).UpdateItems;

      if NeedRebuildBridge then begin
         DiscardBridge;
         Main.BuildBridge;
         Main.LoadBridge;
      end
end;

procedure TCustomizeClasses.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action:=caHide;
end;

procedure TCustomizeClasses.FormShow(Sender: TObject);
begin
   classes:=Main.PanelPalette;
end;

procedure TCustomizeClasses.menuAddPaletteClick(Sender: TObject);
var
   P:TPalettePage;
   s:string;
begin
    s:=format('myPalette%d',[Launcher.PaletteClasses.PageCount]);
    if inputQuery('Class Palette','Name your new class palette:',s) then begin
       P:=Launcher.isPage(s) ;
       if P=nil then begin
          P:=Launcher.AddPage(s);
          SetClasses(Launcher.PaletteClasses);
       end else
          messageDlg(format('The %s palette already exists.',[s]),mtInformation,[mbok],0);
    end
end;

procedure TCustomizeClasses.menuRemoveClick(Sender: TObject);
var
   P:TPalettePage;
begin
    if PageControl.ActivePage<>nil then begin
       P:=Launcher.isPage(PageControl.ActivePage.Caption);
       if P<>nil then begin
          PageControl.ActivePage.Free;
          P.Free;
       end
    end;
end;

procedure TCustomizeClasses.menuHideClick(Sender: TObject);
var
   P:TPalettePage;
begin
   if PageControl.ActivePage<>nil then begin
       P:=Launcher.isPage(PageControl.ActivePage.Caption);
       if P<>nil then begin
          if P.TabVisible then begin
             P.TabVisible:=false ;
             menuHide.Caption:='Show';
          end else begin
             P.TabVisible:=true ;
             menuHide.Caption:='Hide';
          end;
       end
    end;
end;

procedure TCustomizeClasses.menuAddClassClick(Sender: TObject);
var
   P:TPalettePage;
   L:TStringList;
   i:integer;
   B:TPaletteButton;
begin
   if PageControl.ActivePage<>nil then begin
      P:=Launcher.isPage(PageControl.ActivePage.Caption);
      if P<>nil then begin
         L:=TStringList.Create;
         Launcher.RegisteredClassesByModule(P.Module,L);
         with TClassModule.Create(nil) do begin
              CheckListBox.Items.Assign(L);
              for i:=1 to P.ControlCount-1 do begin
                  B:=TPaletteButton(P.Controls[i]);
                  if CheckListBox.Items.IndexOf(B.Typ.Hosted)>-1 then
                     CheckListBox.Checked[i-1]:=true;
              end;
              if ShowModal=mrok then ;
              Free
         end;
         L.free;
      end
   end
end;

end.
