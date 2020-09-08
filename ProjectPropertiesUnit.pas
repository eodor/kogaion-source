unit ProjectPropertiesUnit;

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
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, CheckLst;

type
  TProjectProperties = class(TForm)
    PageControl: TPageControl;
    TabGeneral: TTabSheet;
    LabelHelpFile: TLabel;
    PanelIcon: TPanel;
    ImageIcon: TImage;
    btnIcon: TBitBtn;
    TabDirectories: TTabSheet;
    CheckListBox: TCheckListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbxHelpFiles: TComboBox;
    btnBrowseHelp: TBitBtn;
    btnAdd: TBitBtn;
    procedure btnBrowseHelpClick(Sender: TObject);
    procedure btnIconClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProjectProperties: TProjectProperties;

implementation

{$R *.dfm}

uses MainUnit, HelperUnit;

procedure TProjectProperties.btnBrowseHelpClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='Help files (*.chm,*.hlp)|*.chm;*.hlp|All files (*.*)|*.*';
         if Execute then begin
            cbxHelpFiles.Text:=FileName;
            if cbxHelpFiles.Items.IndexOf(FileName)=-1 then
               cbxHelpFiles.Items.Add( FileName );
         end;      
         Free
    end;
end;

procedure TProjectProperties.btnIconClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='Icon File (*.ico)|*.ico';
         if Execute then begin
            ImageIcon.Hint:=FileName;
            ImageIcon.Picture.LoadFromFile( FileName );
         end;
         Free
    end;
end;

procedure TProjectProperties.FormShow(Sender: TObject);
begin
   CheckListBox.Clear;
   if ActiveEditor.Dependencies.Count>0 then
      CheckListBox.Items.Assign(ActiveEditor.Dependencies)
   else
      FindFiles(CheckListBox.Items,ideDir,'*.bi');
end;

procedure TProjectProperties.btnAddClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         Filter:='FreeBasic Files (*.bas,*.bi,*.fpk)|*.bas;*.bi;*.fpk|All files (*.*)|*.*';
         if Execute then
            if CheckListBox.Items.IndexOf(Filename)=-1 then begin
               CheckListBox.Items.Add(FileName);
            end;
         Free
    end;
end;

procedure TProjectProperties.btnOKClick(Sender: TObject);
begin
    ActiveEditor.Dependencies.Assign(CheckListBox.Items);
end;

end.
