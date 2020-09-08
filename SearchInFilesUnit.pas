unit SearchInFilesUnit;

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
  Dialogs, StdCtrls, Buttons, HelperUnit, SynEdit, SynEditHighlighter,
  SynHighlighterGeneral, StrUtils;

type
  TOccurence = class
    SelStart, SelLength :integer;
    FileName :string;
  end;

  TFileInfo = class
  private
     FOccurencies :TStrings;
     FFileName :string;
     function GetOccurCount: integer;
     function GetOccur(index :integer) :TOccurence;
  public
     constructor Create;
     destructor Destroy; override;
     function Add(value :string; AStart, ALength :integer) :TOccurence;
     property FileName :string read FFileName write FFileName;
     property Occurencies :TStrings read FOccurencies;
     property OccurCount :integer read GetOccurCount;
     property Occur[index :integer] :TOccurence read GetOccur;
  end;


  TSearchInFiles = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lbTextToFind: TLabel;
    TextToFind: TComboBox;
    gbWhere: TGroupBox;
    rbProject: TRadioButton;
    rbOpen: TRadioButton;
    rbDirectories: TRadioButton;
    cbEditor: TCheckBox;
    gbDirectories: TGroupBox;
    cbFileMask: TComboBox;
    btnBrowse: TBitBtn;
    lbMask: TLabel;
    SynEdit: TSynEdit;
    General: TSynGeneralSyn;
    Label1: TLabel;
    cbFilter: TComboBox;
    gbOptions: TGroupBox;
    cbxCaseSensitive: TCheckBox;
    cbxMatchWholeWord: TCheckBox;
    cbxFromCursor: TCheckBox;
    procedure rbOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FindFileSearchFinish(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbFileMaskExit(Sender: TObject);
    procedure cbFilterExit(Sender: TObject);
    procedure TextToFindExit(Sender: TObject);
  private
    { Private declarations }
    procedure GutterClick(Sender: TObject; Button: TMouseButton;
              X, Y, Line: Integer; Mark: TSynEditMark);
    function FindInFileProc(var AFile :string) :integer;stdcall;

  public
    { Public declarations }
    Found :boolean;
    procedure Search;
    procedure Clear;
  end;



var
  SearchInFiles: TSearchInFiles;
  CaseSensitive, WholeWord, Expresion, Stop :boolean;

implementation

{$R *.dfm}

uses
    MainUnit, CodeUnit, GaugeUnit, OccurenciesUnit;

{ TFileInfo }
constructor TFileInfo.Create;
begin
   FOccurencies := TStringList.Create;
end;

destructor TFileInfo.Destroy;
var
   i :integer;
begin
    for i := FOccurencies.Count-1 downto 0 do
        FOccurencies.Objects[i].Free;
    FOccurencies.Free;
    inherited;
end;

function TFileInfo.GetOccurCount: integer;
begin
   Result := FOccurencies.Count
end;

function TFileInfo.GetOccur(index :integer) :TOccurence;
begin
    if (index > -1) and (index < FOccurencies.Count) then
       Result := TOccurence(FOccurencies.Objects[index])
    else
       Result := nil;
end;

function TFileInfo.Add(value :string; AStart, ALength :integer) :TOccurence;
begin
    Result := TOccurence.Create;
    Result.SelStart := AStart;
    Result.SelLength := ALength;
    Result.FileName := value;
    FOccurencies.AddObject(value, Result);
end;


{ TSearchInFile }
procedure TSearchInFiles.rbOpenClick(Sender: TObject);
begin
    if Sender = rbProject then
       if ActiveProject <> nil then
          cbFileMask.Text := extractFilePath(ActiveProject.FileName) else cbFileMask.Text:= '*'
    else if Sender = rbOpen then

    else if Sender = rbDirectories then begin
       cbFileMask.Text := '';
       btnBrowse.SetFocus;
    end   
end;

procedure TSearchInFiles.FormCreate(Sender: TObject);
begin
   rbOpenClick(rbOpen);
end;

function TSearchInFiles.FindInFileProc(var AFile :string) :integer;stdcall;
var
   x :integer;
   s, t, AText : string;
   L :TStrings;
   IT:TFileInfo;
begin
   Result := 0;
   AText := TextToFind.Text; 
   if (AFile='') or (AText = '') then Exit;
   L := TStringList.Create;
   if not DirectoryExists(AFile) then
   try
      if FileExists(AFile) then
         L.LoadFromFile(AFile);
   except end;
   s := L.Text; t:=s;
   if not cbxCaseSensitive.Checked then begin
      s := UpperCase(s);
      AText:=UpperCase(AText);
   end;
   IT:= TFileInfo.Create;
   x:=0;
   Cursor:=crHourGlass;
   repeat
      Application.ProcessMessages;
      x := PosEx(AText,s,x+1);
      if cbxMatchWholeWord.Checked then begin
         t:=copy(s,x,Length(AText)+1);
         if t<>'' then begin
            if t[length(t)] in [' ','.','*','/','\','_','=','+','-',':',';'] then begin
               inc(Result);
               Found := true;
               IT.FileName := AFile;
               IT.Add(AFile, x-1, Length(AText));
            end;
         end
      end else begin
          if x>0 then begin
             Found := true;
             inc(Result);
             IT.FileName := AFile;
             IT.Add(AFile, x-1, Length(AText));
          end
      end;
      if Stop then Break;
   until (x = 0) or Stop;
   Cursor:=crArrow;
   if Result>0  then
      ActiveResult.Edit .Lines.AddObject(Format('%s  [found %d occurence(s)]',[AFile, Result]), IT);
   L.Free;
end;

procedure TSearchInFiles.Clear;
var
   i :integer;
begin
   for i := ActiveResult.Edit.Lines.Count-1 downto 0 do
       if ActiveResult.Edit.Lines.Objects[i] <> nil then
          ActiveResult.Edit.Lines.Objects[i].Free;
   ActiveResult.Edit.ClearAll;
end;

procedure TSearchInFiles.Search;
begin
   Clear;
   if TextToFind.Text <> '' then begin
      //Gauge.Visible := true;
      Found := false;
      ListFileDir(cbFileMask.Text+'\',FindInFileProc,cbFilter.Text);
      //Gauge.Visible := false; ////
      if not Found then MessageDlg(Format('found 0 occurences of [ %s ]',[TextToFind.Text]),mtInformation,[mbok],0);
   end else
      MessageDlg('Text can''t be wide.',mterror,[mbok],0);
   if cbFileMask.Text = '' then
      cbFileMask.Text := IdeDir;
end;

procedure TSearchInFiles.FormShow(Sender: TObject);
begin
    rbProject.Enabled := (ActiveProject <> nil) or (Launcher <> nil);
    rbOpen.Enabled := Code.PageControl.PageCount>0;
    rbOpenClick(rbProject);
    ActiveResult.Edit.OnGutterClick := GutterClick;
end;

procedure TSearchInFiles.btnBrowseClick(Sender: TObject);
var
   Folder :string;
   function Find(value :string) :integer;
   var
      i :integer;
   begin
      Result := -1;
      for i:= 0 to cbFileMask.Items.Count-1 do
          if CompareText(value,cbFileMask.Items[i]) = 0 then begin
             Result := i;
             Break;
          end;
   end;
begin
   Folder := cbFileMask.Text;
   if BrowseForFolder(Folder, 'Browse for folder...') then begin
      cbFileMask.Text := Folder;
      if Find(cbFileMask.Text) = -1 then
         cbFileMask.Items.Add(Folder);
   end;
end;

procedure TSearchInFiles.btnOKClick(Sender: TObject);
var
   i :integer;
begin
   Stop := false;
   ActiveResult.Edit.ClearAll;
   Search;

   for i:= 0 to ActiveResult.Edit.Lines.Count-1 do
       SynEdit.Lines.AddObject(ExtractFileName( ActiveResult.Edit.Lines[i]), ActiveResult.Edit.Lines.Objects[i]);
   SynEdit.OnGutterClick := ActiveResult.Edit.OnGutterClick;
  {}
end;

procedure TSearchInFiles.FindFileSearchFinish(Sender: TObject);
begin
    messageDlg(Format('Yor search for ''%s'' is finished.',[TextToFind.Text]),mtInformation,[mbok],0)
end;

procedure TSearchInFiles.btnCancelClick(Sender: TObject);
begin
   Close
end;

procedure TSearchInFiles.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Stop := true;
   //ActiveResult.Edit.OnGutterClick := nil;
end;

procedure TSearchInFiles.GutterClick(Sender: TObject; Button: TMouseButton;
  X, Y, Line: Integer; Mark: TSynEditMark);
var
   IT :TFileInfo;
   BC:TBufferCoord;
begin
    IT := TFileInfo(ActiveResult.Edit.Lines.Objects[Line-1]);
    if IT <> nil then begin
       ActiveResult.Edit.Hint := Format('Occurencies %d',[IT.OccurCount]);
       ActiveResult.Edit.ShowHint := true;
       with NewEditor(IT.FFileName).Frame.Edit do begin
            if Text<>'' then begin
               SelStart := IT.Occur[0].SelStart;
               SelLength := IT.Occur[0].SelLength ;
               BC:=CharIndexToRowCol(SelStart);
               TopLine:=BC.Line;
            end;
       end;
       Occurences.Execute(it);
    end
end;

procedure TSearchInFiles.cbFileMaskExit(Sender: TObject);
begin
    if cbFileMask.Items.IndexOf(cbFileMask.Text) = -1 then
       cbFileMask.Items.Add(cbFileMask.Text)
end;

procedure TSearchInFiles.cbFilterExit(Sender: TObject);
begin
    if cbFilter.Items.IndexOf(cbFilter.Text) = -1 then
       cbFilter.Items.Add(cbFilter.Text)
end;

procedure TSearchInFiles.TextToFindExit(Sender: TObject);
begin
   if TextToFind.Items.IndexOf(TextToFind.Text) = -1 then
      TextToFind.Items.Add(TextToFind.Text)
end;

end.
