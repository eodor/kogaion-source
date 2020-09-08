unit FrameNewItems;
interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, IniFiles, TypesUnit, HelperUnit;

type
  TFrameNewI = class(TFrame)
    ListView: TListView;
    ImageList: TImageList;
    procedure ListViewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TNewItemSheet=class(TTabSheet)
  private
     fFrame :TFrameNewI;
     fIniFile :string;
  protected
     procedure WMSetText(var message :TWMSetText); message wm_settext;
  public
     constructor Create(AOwner :TComponent); override;
     destructor Destroy; override;
     procedure ReadIni;
     procedure SaveIni(Allow:boolean=true);
     property Frame :TFrameNewI read fFrame;
  end;

implementation

{$R *.dfm}

uses MainUnit, ScripterUnit, InspectorUnit;

constructor TNewItemSheet.Create(AOwner :TComponent);
begin
    inherited;
    fFrame := TFrameNewI.Create(Self);
    fFrame.Align := alClient;
    fFrame.Parent :=Self;
end;

destructor TNewItemSheet.Destroy;
begin
    inherited;
end;

procedure TNewItemSheet.WMSetText(var message :TWMSetText);
begin
    inherited;
    fIniFile := ExtractFilePath(ParamStr(0))+'newItems\'+message.Text+'.ini';
end;

procedure TNewItemSheet.ReadIni;
var
   Ni :TNewItem;
   Li :TListItem;
begin
   fFrame.ListView.Clear;
   if fIniFile='' then
      fIniFile := ExtractFilePath(ParamStr(0))+'newItems\'+ Caption+'.ini';
   with TIniFile.Create(finifile) do begin
        Ni :=TNewItem.Create;
        Ni.Name:=Caption;
        Ni.CodeFile:=ReadString(Ni.Name,'CodeFile','');
        Li :=fFrame.ListView.Items.Add;  Ni.Owner:= Li;
        Li.Caption := Ni.Name;
        Li.Data := Ni;
        Free;
   end;
end;

procedure TNewItemSheet.SaveIni(Allow:boolean=true);
var
   i :integer;
   Ni :TNewItem;
begin
    if Allow then begin
    if not DirectoryExists(ExtractFilePath(ParamStr(0))+'newItems') then
       CreateDir(ExtractFilePath(ParamStr(0))+'newItems');
    if fIniFile='' then
       fIniFile := ExtractFilePath(ParamStr(0))+'newItems\'+ Caption+'.ini';
    if FileExists(finifile) then deleteFile(finifile);
    with TIniFile.Create(fIniFile) do begin
         for i :=0 to fFrame.ListView.Items.Count-1 do begin
             Ni := TNewItem(fFrame.ListView.Items[i].Data);
             if Ni<>nil then begin
                WriteString(Ni.Name,'CodeFile',Ni.CodeFile);
                if Ni.Owner<>nil then
                   WriteString(Ni.Name,'Owner',Ni.Owner.Caption);
             end;
         end;
         Free;
    end;
    end else begin
        if fIniFile='' then
           fIniFile := ExtractFilePath(ParamStr(0))+'newItems\'+ Caption+'.ini';
        if FileExists(fIniFile) then
           DeleteFile(fIniFile);
    end;
end;

procedure TFrameNewI.ListViewClick(Sender: TObject);
var
   Ni :TNewItem;
begin
    if ListView.Selected<>nil then begin
       Ni :=TNewItem(ListView.Selected.Data);
       if Ni<>nil then
          if Ni.Code<>nil then
             if Ni.Code.Count=0 then begin
             with Main do begin
                  Inspector.Properties.Clear;
                  Inspector.Filter.Text:='CodeFile'#10'Name';
                  Inspector.Properties.Add(TPersistent(Ni));
             end;
          end else begin
             Scripter.LoadFromFile(Ni.CodeFile); 
             Scripter.Execute;
          end;
    end;
end;

end.
