unit newItemUnit;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Menus, TypesUnit, FrameNewItems,
  HelperUnit, iniFiles, TypInfo;

type
  TnewItems = class(TForm)
    PopupMenu: TPopupMenu;
    menuNewItem: TMenuItem;
    menuRemoveTab: TMenuItem;
    N1: TMenuItem;
    menuDeleteItem: TMenuItem;
    PageControl: TPageControl;
    btAdd: TBitBtn;
    menuNewTab: TMenuItem;
    btClose: TBitBtn;
    procedure menuNewItemClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure menuNewTabClick(Sender: TObject);
    procedure menuDeleteItemClick(Sender: TObject);
    procedure menuRemoveTabClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function AddPage(v:string):TNewItemSheet;
    function AddItem(p:TNewItemSheet;v:string):TNewItem;
    procedure Read;
    procedure Write;
  end;

var
  newItems: TnewItems;

implementation

{$R *.dfm}

uses MainUnit, ContainerUnit, LauncherUnit;

function TnewItems.AddPage(v:string):TNewItemSheet;
begin
    result:=TNewItemSheet.Create(PageControl);
    result.Caption:=v;
    result.PageControl:=PageControl;
end;

function TNewItems.AddItem(p:TNewItemSheet; v:string):TNewItem;
var
    Lw:TListView;
    Li:TListItem;
begin
    result:=nil;
    if p<>nil then begin
       result:=TNewItem.Create;
       result.Name:=v;
       Lw:=TListView(TFrameNewI(p.Controls[0]).Controls[0]);
       if Lw<>nil then begin
          Li:=Lw.Items.Add;
          Li.Data:=result;
          Li.Caption:=v;
       end
    end
end;

procedure TnewItems.Read;
var
   L,B,IT:TStrings;
   s,p,v:string;
   i,j,k:integer;
   Pg:TNewItemSheet;
   item:TNewItem;
begin
    L:=TStringList.Create;
    B:=TStringList.Create;
    IT:=TStringList.Create;
    with TIniFile.Create(ideDir+'newItems\newitems.ini') do begin
         ReadSection('Pages',L);
         if L.Count=0 then begin Free ;exit; end;
         for i:=0 to L.Count-1 do begin
             Pg:=AddPage(L[i]);
             ReadSection(L[i],B);
             for j:=0 to B.Count-1 do begin
                 item:=AddItem(Pg,B[j]);
                 ReadSectionValues(B[j],IT);
                 for k:=0 to IT.Count-1 do begin
                     p:=copy(IT[k],1,pos('=',IT[k])-1);
                     v:=copy(IT[k],pos('=',IT[k])+1,length(IT[k]));
                     if GetPropInfo(item,p)<>nil then
                        SetPropValue(item,p,v);
                 end
             end
         end;
         Free;
    end;
    L.Free;
    B.Free;
    IT.Free;
end;

procedure TnewItems.Write;
var
   i,j:integer;
   Lw:TListView;
begin
     with TIniFile.Create(ideDir+'newItems\newitems.ini') do begin
          for i:=0 to PageControl.PageCount-1 do begin
              WriteString('Pages',PageControl.Pages[i].Caption,inttostr(i));
              Lw:=TListView(TFrameNewI(PageControl.Pages[i].Controls[0]).Controls[0]);
              for j:=0 to Lw.Items.Count-1 do begin
                  WriteString(PageControl.Pages[i].Caption,Lw.Items[j].Caption,inttostr(j));
                  WriteString(Lw.Items[j].Caption,'CodeFile',TNewItem(Lw.Items[j].Data).CodeFile);
              end;
          end;
          Free
     end
end;

procedure TnewItems.menuNewItemClick(Sender: TObject);
var
   s :string;
   T :TNewItemSheet;
   Ni :TNewItem;
   Li :TListItem;
   function FindItem(v:string):TListItem;
   var
      i,j:integer;
      Lw:TListView;
   begin
      result:=nil;
      for i:=0 to PageControl.PageCount-1 do begin
          Lw:=TListView(TFrameNewI(PageControl.Pages[i].Controls[0]).Controls[0]);
          if Lw<>nil then
             for j:=0 to Lw.Items.Count-1 do
                 if compareText(Lw.Items[i].Caption,v)=0 then begin
                    result:=Lw.Items[i];
                    break
                 end
      end
   end;
begin
    T := TNewItemSheet(PageControl.ActivePage);
    if T= nil then begin
       s:=NamesList.AddName('myItems');// GetIdx('myItems');
       if InputQuery('Add New Item','Name Tab:',s)then begin
          T :=TNewItemSheet.Create(PageControl);
          T.Caption:= s;
          T.PageControl:=PageControl;
          Ni := TNewItem.Create;
          s:=NamesList.AddName('myItem');//GetIdx('myItem');
          if InputQuery('Add New Item','Name Item:',s) then begin
             if FindItem(s)<>nil then begin
                messageDlg('Exists.',mtInformation,[mbok],0)
             end else begin
                Ni.Name :=s;
                Li := TNewItemSheet(T).Frame.ListView.Items.Add;
                Ni.Owner:=Li;
                Li.Caption := Ni.Name;
                Li.Data := Ni;
             end
          end;
       end;
    end else begin
       Ni := TNewItem.Create;
       s:=NamesList.AddName('myItem');//GetIdx('myItem');
       if InputQuery('Add New Item','Name Item:',s) then begin
          if FindItem(s)<>nil then begin
             messageDlg('Exists.',mtInformation,[mbok],0)
          end else begin
             Ni.Name :=s;
             Li := TNewItemSheet(T).Frame.ListView.Items.Add;
             Ni.Owner:=Li;
             Li.Caption := Ni.Name;
             Li.Data := Ni;
          end
       end;
    end;
end;

procedure TnewItems.btAddClick(Sender: TObject);
begin
   menuNewItem.Click
end;

procedure TnewItems.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Write;
end;

procedure TnewItems.FormShow(Sender: TObject);
begin
   Read
end;

procedure TnewItems.menuNewTabClick(Sender: TObject);
var
   T :TNewItemSheet;
   s :string;
   function Find(v :string):TNewItemSheet;
   var
      i :integer;
   begin
      result:=nil;
      for i :=0 to PageControl.PageCount-1 do
          if CompareText(PageControl.Pages[i].Caption,v)=0 then begin
             result :=TNewItemSheet(PageControl.Pages[i]);
          end;
   end;
begin
    s:=NamesList.AddName('myTabItems');{GetIdx('myItems'); T := Find(s)};

       if InputQuery('Add New Items Tab','Name Tab:',s)then begin
          if Find(s)<>nil then begin
             PageControl.ActivePage:=Find(s)
          end else begin
             T :=TNewItemSheet.Create(PageControl);
             T.Caption:= s;
             T.PageControl:=PageControl;
             PageControl.ActivePage:=T;
          end
       end;
end;

procedure TnewItems.menuDeleteItemClick(Sender: TObject);
var
  Ti :TNewItemSheet;
  ini :TIniFile;
  s :string;
begin
   Ti := TNewItemSheet(PageControl.ActivePage);
   s:=ExtractFilePath(ParamStr(0))+'newitems\'+Ti.Name+'.ini';
   ini:=TiniFile.Create(s);
   if Ti.Frame.ListView.Selected<>nil then begin
      TNewItem(Ti.Frame.ListView.Selected.Data).Free;
      ini.EraseSection(Ti.Frame.ListView.Selected.Caption);
      Ti.Frame.ListView.Selected.Free;
   end;
   ini.Free;
end;

procedure TnewItems.menuRemoveTabClick(Sender: TObject);
var
  Ti :TNewItemSheet;
  i  :integer;
  ini :TIniFile;
  s :string;
begin
   Ti := TNewItemSheet(PageControl.ActivePage);
   if Ti<>nil then begin
      s := ExtractFilePath(ParamStr(0))+'newitems\'+Ti.Name+'.ini';
      ini:=TiniFile.Create(s);
      for i:=Ti.Frame.ListView.Items.Count-1 downto 0 do begin
          ini.EraseSection(Ti.Frame.ListView.Items[i].Caption);
          TNewItems(Ti.Frame.ListView.Items[i].Data).Free;
      end;
      Ti.Free;
      DeleteFile(s);
    end;
end;

procedure TnewItems.btCloseClick(Sender: TObject);
begin
    Close
end;

procedure TnewItems.PopupMenuPopup(Sender: TObject);
begin
   menuRemoveTab.Enabled:= (PageControl.PageCount>0) and (PageControl.ActivePageIndex>-1);
   menuDeleteItem.Enabled := (PageControl.ActivePageIndex>-1) and (TNewItemSheet(PageControl.ActivePage).Frame.ListView.Selected<>nil);
end;

end.
