unit CompilerSettingsUnit;

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
  Dialogs, StdCtrls;

type
  TCompilerSettings = class(TForm)
    cbxSwitches: TComboBox;
    cbxCompilers: TComboBox;
    LabelCompiler: TLabel;
    LabelSwitch: TLabel;
    btnBrowseCompler: TButton;
    btnBrowseSwitch: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    LabelTarget: TLabel;
    cbxTargets: TComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnBrowseComplerClick(Sender: TObject);
    procedure btnBrowseSwitchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxTargetsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CompilerSettings: TCompilerSettings;

implementation

{$R *.dfm}

uses MainUnit;

procedure TCompilerSettings.btnCancelClick(Sender: TObject);
begin
    ModalResult:=mrCancel;
    Close;
end;

procedure TCompilerSettings.btnOKClick(Sender: TObject);
begin
    ModalResult:=mrOK;
    Launcher.Switch:=cbxSwitches.Text;
    Launcher.Compiler.FileName:=cbxCompilers.Text;
    Launcher.Compilers.Assign(cbxCompilers.Items);
    Close;
end;

procedure TCompilerSettings.btnBrowseComplerClick(Sender: TObject);
begin
     with TOpenDialog.Create(nil) do begin
         FileName:=cbxCompilers.Text;
         Filter:='Executable (*.exe)|*.exe';
         if Execute then begin
            cbxCompilers.Text:=FileName;
            if cbxSwitches.Items.IndexOf(FileName)=-1 then
               cbxSwitches.Items.Add(FileName);
         end;
         Launcher.Compilers.Assign(cbxCompilers.Items);
         Free;
    end;
end;

procedure TCompilerSettings.btnBrowseSwitchClick(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do begin
         if Execute then
            if cbxSwitches.Items.IndexOf(FileName)=-1 then
               cbxSwitches.Items.Add(FileName);
         Free;
    end;
end;

procedure TCompilerSettings.FormCreate(Sender: TObject);
begin
   Launcher.AddForm(self);
end;

procedure TCompilerSettings.cbxTargetsChange(Sender: TObject);
begin
    if (comparetext(cbxTargets.Text,'win32')=0) or
       (comparetext(cbxTargets.Text,'windows')=0) or
       (comparetext(cbxTargets.Text,'win10')=0) then begin
       Launcher.Target:='windows';
       exit
    end;

    Launcher.Target:=cbxTargets.Text;
end;

end.
