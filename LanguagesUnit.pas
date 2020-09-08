unit LanguagesUnit;

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
  Dialogs, HelperUnit, TypesUnit, StdCtrls, Buttons, ExtCtrls, iniFiles, TypInfo,
  Menus, ComCtrls;

type
  TLanguagesDlg = class(TForm)
    btClose: TBitBtn;
    Panel: TPanel;
    ListBox: TListBox;
    btnLoad: TBitBtn;
    btnSet: TBitBtn;
    btnShow: TBitBtn;
    PopupMenuLangs: TPopupMenu;
    pmenuRemove: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PopupMenuLangsPopup(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure pmenuRemoveClick(Sender: TObject);
  private
    { Private declarations }
    FDirectory :string;
  public
    { Public declarations }
    procedure GetLanguages;
    procedure ExportStringProperties;
    function LanguageExists(v:string):TLanguage;
  end;

var
  LanguagesDlg :TLanguagesDlg ;
  LanguagesDir:string;

implementation

{$R *.dfm}

uses MainUnit, LauncherUnit;

procedure TLanguagesDlg.ExportStringProperties;
var
   i:integer;
   L:TStrings;
   Pif:PPropInfo;
   s:string;
   function isBtnSep(c:TComponent):boolean;
   begin
      result:=false;
      if c=nil then exit;
      if c.InheritsFrom(TToolButton) then
         result:=TToolButton(c).Style=tbsSeparator;
   end;
   procedure Enum(v:TWinControl);
   var
      i:integer;
   begin
      for i:=0 to v.ComponentCount-1 do begin
          Pif:=GetPropInfo(v.Components[i],'caption');
          if Pif<>nil then begin
             s:=GetPropValue(v.Components[i],'caption');
             if not(v.Components[i].InheritsFrom(TToolButton)) and
                not(v.Components[i].InheritsFrom(TToolBar)) and
                not(v.Components[i].InheritsFrom(TPanel)) then
                if s<>'' then
                   L.AddObject(format('%s.caption=%s',[v.Components[i].Name,s]),v.Components[i]);
          end;
          Pif:=GetPropInfo(v.Components[i],'text');
          if Pif<>nil then begin
             s:=GetPropValue(v.Components[i],'text');
             if s<>'' then
                L.AddObject(format('%s.text=%s',[v.Components[i].Name,s]),v.Components[i]);
          end;
          if GetPropInfo(v.Components[i],'Hint')<>nil then
             if not v.Components[i].InheritsFrom(TMenuItem) then
                if not isBtnSep(v.Components[i]) then
                if v.Components[i].Name<>'' then
                   L.AddObject(format('%s.hint=%s',[v.Components[i].Name,GetPropValue(v.Components[i],'hint')]),v.Components[i]);
          if v.Components[i].InheritsFrom(TWinControl) then
             Enum(v.Components[i] as TWinControl)
      end
   end;
begin
    L:=TStringList.Create;
    with L do begin
        for i:=0 to Application.ComponentCount-1 do
           if Application.Components[i].InheritsFrom(TForm) then begin
              AddObject(format('[%s]',[Application.Components[i].Name]),Application.Components[i]);
              Pif:=GetPropInfo(Application.Components[i],'caption');
              if Pif<>nil then
                 AddObject(format('caption=%s',[GetPropValue(Application.Components[i],'caption')]),Application.Components[i]);
              Pif:=GetPropInfo(Application.Components[i],'hint');
              if Pif<>nil then
                 if TForm(Application.Components[i]).Hint<>'' then
                    AddObject(format('hint=%s',[GetPropValue(Application.Components[i],'hint')]),Application.Components[i]);
              Enum(TForm(Application.Components[i]));
           end;
      SaveToFile(LanguagesDir+'\Base.txt');
      Free;
    end
end;

procedure TLanguagesDlg.GetLanguages;
var
   L:TStrings;
   i:integer;
   Lang:TLanguage;
begin
    ListBox.Clear;
    L:=TStringList.Create;
    FindFiles(L,ideDir+'Languages\','*.txt');
    for i:=0 to L.Count-1 do begin
        Lang:=TLanguage.Create;
        Lang.Launcher:=Launcher;
        Lang.FileName:=L[i];
        Lang.Name:=ChangeFileExt(L[i],'');
        ListBox.AddItem(ExtractFileName(L[i]),Lang);
    end;
    if ActiveLang<>nil then
       ListBox.ItemIndex:=ListBox.Items.IndexOf(ExtractFileName(ActiveLang.FileName));
    L.Free;
end;

function TLanguagesDlg.LanguageExists(v:string):TLanguage;
var
   i:integer;
   L:TLanguage;
begin
    result:=nil;
    if v='' then exit;
    GetLanguages;
    for i:=0 to ListBox.Items.Count-1 do begin
        L:=TLanguage(ListBox.Items.Objects[i]);
        if L<>nil then
           if (CompareText(L.Name,v)=0) or (CompareText(L.FileName,v)=0)  then begin
               result:=L;
               break
           end
    end
end;

procedure TLanguagesDlg.FormCreate(Sender: TObject);
begin
    LanguagesDir:= ideDir + 'Languages\';
    FDirectory:=LanguagesDir;
    if not DirectoryExists(FDirectory) then
      CreateDir(FDirectory);
end;

procedure TLanguagesDlg.ListBoxClick(Sender: TObject);
begin
   if ListBox.ItemIndex = -1 then begin
      ActiveLang := nil;
      Exit;
   end;
   ActiveLang := TLanguage(ListBox.Items.Objects[ListBox.ItemIndex]) ;
   btnSet.Enabled:= (ActiveLang <> nil);
   btnShow.Enabled := FileExists(ActiveLang.FileName) ;
end;

procedure TLanguagesDlg.btnSetClick(Sender: TObject);
var
   s :string;
begin
   s := ChangeFileExt(ParamStr(0),'.ini');
   with TIniFile.Create(s) do begin
        WriteString('Main','ActiveLang',ActiveLang.FileName);
        Free;
   end;     
   if ListBox.ItemIndex>-1 then begin
      ActiveLang:=TLanguage(ListBox.Items.Objects[ListBox.ItemIndex]); 
      ActiveLang.SetLanguage;
   end
end;

procedure TLanguagesDlg.btnLoadClick(Sender: TObject);
   function Check(v:string):integer;
   var
      i:integer;
      L:TLanguage;
   begin
      result:=-1;
      if v='' then exit;
      for i:=0 to ListBox.Items.Count-1 do begin
          L:=TLanguage(ListBox.Items.Objects[i]);
          if CompareText(v,L.FileName)=0 then begin
             result:=i;
             break;
          end;
      end
   end;
begin
    with TOpenDialog.Create(nil) do begin
        Filter := 'ActiveLang file (*.txt)| *.txt';
        if Execute then begin
           if Check(FileName)=-1 then begin
              ActiveLang := TLanguage.Create;
              ActiveLang.FileName := FileName;
              ListBox.AddItem(ExtractFileName(ActiveLang.FileName) ,ActiveLang);
           end else messageDlg(format(StringReplace('','\n',#10,[rfReplaceAll]),[ExtractFileName(ActiveLang.FileName)]),mtInformation,[mbok],0);
        end;
        Free
    end;
end;

procedure TLanguagesDlg.btnShowClick(Sender: TObject);
begin
     newEditor(ActiveLang.FileName);
end;

procedure TLanguagesDlg.FormShow(Sender: TObject);
begin
    ListBox.Items.Clear;
    //if not FileExists(LanguagesDir+'Base.txt') then
       ExportStringProperties;
    GetLanguages;
end;

procedure TLanguagesDlg.PopupMenuLangsPopup(Sender: TObject);
begin
   pmenuRemove.Enabled := (ListBox.ItemIndex <> -1);
end;

procedure TLanguagesDlg.btCloseClick(Sender: TObject);
begin
   Close
end;

procedure TLanguagesDlg.pmenuRemoveClick(Sender: TObject);
var
   L:TLanguage;
begin
   if ListBox.ItemIndex=-1 then exit;
   case messageDlg(format(StringReplace('','\n',#10,[rfReplaceAll]),[ListBox.Items[ListBox.ItemIndex]]),mtConfirmation,[mbyes,mbno],0) of
   mryes:begin
         L:=  TLanguage(ListBox.Items.Objects[ListBox.ItemIndex]);
         if L<>nil then begin
            ListBox.Items.Objects[ListBox.ItemIndex].Free;
            ListBox.Items.Delete(ListBox.ItemIndex);
         end
         end
   end ;
   btnShow.Enabled:=ListBox.Items.Count>0;
   btnSet.Enabled:=btnShow.Enabled;
end;

end.
