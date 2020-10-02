unit PageSheetUnit;


interface

uses
   Windows,
   SysUtils, Messages, Classes, Controls, Dialogs, ComCtrls, DialogUnit, EditFrame,
   ScannerUnit, Graphics, TypInfo, SynEdit, SynEditTypes, FreeBasicRTTI,
   SynEditMiscClasses, TypesUnit;

type
   TPageSheet=class(TTabSheet)
   private
   fScanTree, fObjTree:TTreeView;
   fNode:TTreeNode;
   fScanner:TScanner;
   fSaved:boolean;
   fFileName:string;
   fFrame:TEditor;
   fDialog:TDialog;
   fHasDialog:boolean;
   fNameChanged, fSetHasDialog:TNotifyEvent;
   fDependencies, fExported:TStrings;
   procedure SetDialog(v:TDialog);
   procedure SetHasDialog(v:boolean);
   procedure SetSaved(v:boolean);
   procedure SetFileName(v:string);
   procedure SetObjTree(v:TTreeView);
   protected
   procedure SetName(const v:TComponentName);override;
   public
   Project:TProject;
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
   function Dispose:integer;
   procedure SilentSave(v:string);
   procedure Save;
   procedure SaveAs;
   procedure Select(v:TObject);
   function Find(v:string;where:integer=0;o:TObject=nil):TPoint;
   function InsertDialog:string;
   procedure InsertControl( o:TControl);
   procedure DeleteControl(o:TControl);
   procedure UpdateControl(o:TControl;pn:string='';pv:string='');
   procedure UpdateControlName(o:TControl);
   function UpdateEvent(o:TControl;evn,prms:string):string;
   property Dependencies:TStrings read fDependencies;
   property Exported:TStrings read fExported;
   property Node:TTreeNode read fNode write fNode;
   property ObjTree:TTreeView read fObjTree write SetObjTree;
   property Scanner:TScanner read fScanner;
   property ScanTree:TTreeView read fScanTree write fScanTree;
   property Frame:TEditor read fFrame;
   property Dialog:TDialog read fDialog write SetDialog;
   property HasDialog:boolean read fhasdialog write SetHasDialog;
   property Saved:boolean read fSaved write SetSaved;
   property FileName:string read fFileName write SetFileName;
   property OnNameChanged:TNotifyEvent read fNameChanged write fNameChanged;
   property OnSetHasDialog:TNotifyEvent read fSetHasDialog write fSetHasDialog;
   end;
var
   CanFreeDialog:boolean;
   PagesList:TStringList;
   oldName:string;

implementation

uses MainUnit, ContainerUnit, ObjectsTreeUnit, CodeUnit, InspectorUnit, HelperUnit,
     InstallClassUnit;

constructor TPageSheet.Create(AOwner:TComponent);
begin
   inherited;
   fScanner:=TScanner.create;
   fFrame:=TEditor.Create(self);
   fFrame.Align:=alClient;
   fFrame.Parent:=self;
   Saved:=true;
   PagesList.AddObject(Name,self) ;
   fScanTree:=Code.TreeView;
   fScanner.Tree:=fScanTree;
   fScanner.Edit:=fFrame.Edit;
   fDependencies:=TStringList.Create;
   fExported:=TStringList.Create;
end;

destructor TPageSheet.Destroy;
var
   i:integer;
begin
   if fDialog<>nil then begin
      Inspector.Reset;
      fDialog.Page:=nil;
      if CanFreeDialog then begin
         if Launcher.ideMode=mdVB then
            if fDialog.Sheet<>nil then
               fDialog.Sheet.Free
            else
               fDialog.Free;
      end;
   end;
   i:=PagesList.IndexOfObject(self);
   if i>-1 then PagesList.Delete(i);
   if Project<>nil then begin
      i:=Project.Files.IndexOfObject(self);
      if i>-1 then
         Project.Files.Objects[i]:=nil
      else begin
         i:=Project.Files.IndexOf(ffilename);
         if i>-1 then
            Project.Files.Objects[i]:=nil;
      end;
      if Project.Page=self then
         Project.Page:=nil; Activeresult.Edit.Lines.Add(project.filename);
   end;
   fScanner.Free;
   if ActiveEditor=self then ActiveEditor:=nil;
   if ActiveObject=self then ActiveObject:=nil;
   fDependencies.Free;
   fExported.Free;
   inherited;
end;

procedure TPageSheet.SetObjTree(v:TTreeView);
begin
   fObjTree:=v;
   if v<>nil then
      fNode:=v.Items.AddChildObject(ActiveProject.node,Name,self)
end;

procedure TPageSheet.SetName(const v:TComponentName);
var
   i:integer;
begin
   inherited;
   i:=PagesList.IndexOfObject(self);
   if i>-1 then PagesList[i]:=Name;
   if fNode<>nil then fNode.Text:=Name;
   if assigned(fNameChanged) then
      fNameChanged(self);
end;

procedure TPageSheet.SetDialog(v:TDialog);

begin
    fDialog:=v;
    if v<>nil then begin
       Name:=v.Name;
       Caption:=Name; 
    end;
end;

procedure TPageSheet.SetHasDialog(v:boolean);
begin
    fHasDialog:=v;
    if v then
       if fDialog=nil then begin
          ActiveDialog:=TDialog.Create(nil);
          Dialog:=ActiveDialog;
          fDialog.Page:=self;
          fDialog.DropdownMenu:=Main.menuWindows;
          fDialog.Show;
          oldName:=fDialog.Name;
          if assigned(fsethasdialog) then fsethasdialog(self);
       end;
    if not v then
       if fDialog<>nil then begin
          fDialog.Free;
          fDialog:=nil;
       end;
end;

procedure TPageSheet.SetSaved(v:boolean);
begin
    fSaved:=v;
    if v then
       if Caption<>'' then
          if pos('*',Caption)>0 then Caption:=StringReplace(Caption,'*','',[rfreplaceall]);
    if not v then
       if Caption<>'' then
          if pos('*',Caption)=0 then Caption:='*'+Caption;
end;

procedure TPageSheet.SetFileName(v:string);
begin
    if self=nil then exit;
    if FileExists(v) then begin
       fFileName:=v;
       fFrame.Edit.Lines.LoadFromFile(v);
       Caption:=ExtractFileName(v);
    end else begin
       if (pos(#10,v)>1) then
          fFrame.Edit.Text:=v
       else
          fFileName:=v; 
    end
end;

procedure TPageSheet.Save;
begin
    if FileExists(fFileName) then begin
       fFrame.Edit.Lines.SaveToFile(fFileName);
       Saved:=true; Scanner.Scan;
    end else SaveAs;
end;

procedure TPageSheet.SilentSave(v:string);
begin
    if v<>'' then begin
       fFrame.Edit.Lines.SaveToFile(v);
       Saved:=true
    end
end;

procedure TPageSheet.SaveAs;
var
   s:string;
begin
   if fFrame=nil then exit;
   with TSaveDialog.Create(nil) do begin
        options:=options+[ofoverwriteprompt];
        Filter:=Launcher.Filter;
        if Filter='' then
           Filter:='FreeBasic file(*.bas)|*.bas|FreeBasic include (*.bi)|*.bi|HTML file (*.html)|*.html|RTF file (*.rtf)|*.rtf|Text file (*.txt)|*.txt|All files (*.*)|*.*';
        FileName:=fFileName;
        if FileName='' then
           FileName:=Self.Name;
        if Execute then begin
           s:=GetFilterByIndex(FilterIndex,Filter);
           s:=ExtractFileExt(s);
           if s='*.' then
              fFileName:=FileName
           else
              fFileName:=ChangeFileExt(FileName,s);
           if pos('html',lowercase(s))>0 then begin
              fFrame.ExporterHTML.ExportAll(fFrame.Edit.Lines);
              fFrame.ExporterHTML.SaveToFile(fFileName);
              exit
           end ;
           if pos('rtf',lowercase(s))>0 then begin
              fFrame.ExporterRTF.ExportAll(fFrame.Edit.Lines);
              fFrame.ExporterRTF.SaveToFile(fFileName);
              exit
           end ;
           fFrame.Edit.Lines.SaveToFile(fFileName);
           Caption:=ExtractFileName(fFileName);
           if fNode<>nil then fNode.Text:=Caption;
           Saved:=true; Scanner.Scan;
        end;
        Free;
   end
end;

function TPageSheet.Dispose:integer;
var
   s:string;
begin
    if FileExists(fFileName) then
       s:=fFileName
    else
       s:=StringReplace(Caption,'*','',[rfreplaceall]);
    result:=mrok;   
    if not fSaved or not FileExists(fFileName) then
       case messageDlg(format('The %s page was modified.'#10'Do you want to save?',[s]),mtConfirmation,[mbyes,mbno,mbcancel],0) of
       mryes:if FileExists(fFileName) then
                Save
             else
                SaveAs;
       mrcancel:begin result:=mrcancel; end;
       end;
    if result=mrCancel then Exit;
    try
       Free
    except messageDlg('Internal error $em: can''t free memory.',mtError,[mbok],0);
    end ;
end;

function TPageSheet.InsertDialog:string;
var
   t,ifl:string;
begin
    result:='';
    Launcher.Lib.MainType:=Launcher.Lib.TypExists(Launcher.Lib.MainTypeName);  
    if Launcher.Lib.MainType=nil then begin
       messageDlg('The MainType in library are not set.'#10'No form will be created.',mtInformation,[mbok],0);
       exit;
    end;
    ifl:=Launcher.Lib.MainFile;
    if ifl='' then ifl:=Launcher.Lib.MainFile;
    if Launcher.Lib.MainType=nil then begin
       if messageDlg('Type has no Extends. Set MainType in library',mtError,[mbok],0)=mryes then
          exit;
    end ;
    if pos('type ',lowercase(fFrame.Edit.Text))=0 then
       if pos(lowercase(fDialog.Name),lowercase(fFrame.Edit.Text))=0 then
          if pos('extends ',lowercase(fFrame.Edit.Text))=0 then begin
             fDialog.Page:=Self;
             if fDialog.Typ.Hosted<>'' then
                if fDialog.Typ.Hosted[1] in ['Q','q'] then
                   fDialog.Name:=copy(fDialog.Typ.Hosted,2,length(fDialog.Typ.Hosted)) else fDialog.Name:=fDialog.Typ.Hosted;
             t:=fDialog.Typ.Extends;
             fDialog.Visible:=true;
             with fFrame.Edit.Lines do begin
                  if pos('-include ',lowercase(Launcher.Switch))=0 then begin
                     Add(format('#include once "%s"',[ifl]));
                     Add('');
                  end;
                  AddObject(format('type %s extends %s',[fDialog.Typ.Hosted,t]),fDialog);
                  AddObject('    public:',fDialog);
                  Add('    declare operator cast as any ptr');
                  Add('    declare constructor');
                  AddObject('end type',fDialog);
                  Add('');
                  Add(format('var %s=%s',[fDialog.Name,fDialog.Typ.Hosted]));
                  Add('');
                  Add(format('operator %s.cast as any ptr',[fDialog.Typ.Hosted]));
                  Add('   return @this');
                  Add('end operator');
                  Add('');
                  AddObject(format('constructor %s',[fDialog.Typ.Hosted]),fDialog);
                  AddObject(format('    this.Name="%s"',[fDialog.Name]),fDialog);
                  AddObject(format('    this.Text="%s"',[fDialog.Caption]),fDialog);
                  AddObject(format('    this.SetBounds(%d,%d,%d,%d)',[fDialog.Left,fDialog.Top,fDialog.Width,fDialog.Height]),fDialog);
                  AddObject('    this.Parent=0',fDialog);
                  AddObject('end constructor',fDialog);
                  Add('');
             end;
          end ;
          fScanner.Execute;
          Inspector.Dialog:=fDialog;
end;

procedure TPageSheet.InsertControl( o:TControl);
var
   i,x:integer;
   s,ifl:string;
   wasInserted:boolean;
begin
    for i:=0 to fFrame.Edit.Lines.Count-1 do begin
        s:=trim(fFrame.Edit.Lines[i]);
        if fFrame.Edit.Lines.Objects[i]=fDialog then begin
           if (pos('end ',lowercase(s))>0) and (pos(' constructor',lowercase(s))>0) then begin
               fFrame.Edit.Lines.InsertObject(i,format('    %s.Parent=this',[o.Name]),o);
               fFrame.Edit.Lines.InsertObject(i,format('    %s.SetBounds(%d,%d,%d,%d)',[o.Name,o.Left,o.Top,o.Width,o.Height]),o);
               fFrame.Edit.Lines.InsertObject(i,format('    %s.Name="%s"',[o.Name,o.Name]),o);
               fFrame.Edit.Lines.InsertObject(i,format('    %s.Canvas.Color=%s',[o.Name,StringReplace(ColorToString(TContainer(o).Color),'$','&H',[])]),o);
               fFrame.Edit.Lines.InsertObject(i,format('    %s.Align=%d',[o.Name,integer(o.Align)]),o);
               if GetPropInfo(o,'text')<>nil then
                  fFrame.Edit.Lines.InsertObject(i,format('    %s.Text="%s"',[o.Name,GetPropValue(o,'text')]),o);
               Scanner.Execute;
               break
           end
        end
    end;

    wasInserted:=false;
    for i:=0 to fFrame.Edit.Lines.Count-1 do begin
        s:=trim(fFrame.Edit.Lines[i]);
        if fFrame.Edit.Lines.Objects[i]=fDialog then begin
           if (pos('public:',lowercase(s))>0) then begin  
              fFrame.Edit.Lines.InsertObject(i,format('    as %s %s',[TContainer(o).Hosted,o.Name]),o);
              wasInserted:=true;
              Saved:=false;
              break
           end
        end
    end ;

    if wasInserted=false then begin
       for i:=0 to fFrame.Edit.Lines.Count-1 do begin
           s:=trim(fFrame.Edit.Lines[i]);
           if fFrame.Edit.Lines.Objects[i]=fDialog then begin
              if (pos('end ',lowercase(s))>0) and (pos(' type',lowercase(s))>0) then begin
                 fFrame.Edit.Lines.InsertObject(i,format('    as %s %s',[TContainer(o).Hosted,o.Name]),o);
                 Saved:=false;
                 break
              end;
           end
        end
    end ;
    if FileExists(TContainer(o).Typ.Module) then begin
       x:=-1;
       if CompareText(TContainer(o).Typ.Module,Launcher.Lib.MainFile)<>0 then begin
          for i:=0 to fFrame.Edit.Lines.Count-1 do begin
              s:=trim(fFrame.Edit.Lines[i]);
              if pos('#include',lowercase(s))>0 then
                 x:=i;
          end
       end;
       ifl:=format('#include once "%s"',[ChangeFileExt(TContainer(o).Typ.Module,'.bas')]);
       wasInserted:=pos(lowercase(ifl),lowercase(fFrame.Edit.Text))>0;

       if (wasInserted=false) and (x>-1) then begin
          ifl:=format('#include once "%s"',[ChangeFileExt(TContainer(o).Typ.Module,'.bas')]);
          fFrame.Edit.Lines.Insert(x+1,ifl);
       end;
    end;

    fScanner.Execute ;
end;

procedure TPageSheet.DeleteControl(o:TControl);
var
   i:integer;
begin
    if (Self=nil) or (o=nil) then exit;
    for i:=fFrame.Edit.Lines.Count-1 downto 0 do begin
        if fFrame.Edit.Lines.Objects[i]=o then
           if o=fDialog then begin
              if messageDlg(format('You do not have permission to delete this.'#10'%s',[fDialog.Name]),mtInformation,[mbok],0)=mrok then
                 exit;
           end else
           fFrame.Edit.Lines.Delete(i);
    end;
    fScanner.Scan;
    //ObjectsTree.UpdateItems;
    //Inspector.UpdateItems
end;

procedure TPageSheet.UpdateControl(o:TControl;pn:string='';pv:string='');
var
   i,x:integer;
   s,ln,lp,lv,n:string;
begin
    if (self=nil) or (o=nil) then exit;
    if fFrame.Edit=nil then exit;
    i:=0;
          repeat
                ln:=fFrame.Edit.Lines[i];
                if Ln<>'' then begin
                   if (fFrame.Edit.Lines.Objects[i]=o) then begin
                      if (pn='') and (pv='') then
                          if pos('setbounds',lowercase(Ln))>0 then begin
                             s:='';
                             for x:=1 to length(Ln) do
                                 if Ln[x]=' ' then s:=s+' ';
                             if o=fDialog then
                                n:='this'
                             else
                                n:=o.Name;
                             Frame.Edit.Lines[i]:=format('%s%s.SetBounds(%d,%d,%d,%d)',[s,n,o.Left,o.Top,o.Width,o.Height]);
                             //Saved:=false
                          end ;
                      if pos(lowercase(pn),lowercase(Ln))>0 then begin
                         s:=Frame.Edit.Lines[i];
                         lp:=copy(s,1,pos('=',s)-1);
                         lv:=copy(s,pos('=',s)+1,length(s));
                         if pos('"',s)>0 then
                            lv:='"'+StringReplace(lv,lv,pv,[])+'"'
                         else
                            lv:=StringReplace(lv,lv,pv,[]);
                         Frame.Edit.Lines[i]:=lp+'='+lv;
                         Saved:=false
                      end ;
                   end
                end;
                inc(i);
          until i>Frame.Edit.Lines.Count-1;

end;

procedure TPageSheet.UpdateControlName(o:TControl);
var
   eso:TSynSearchOptions;
begin
    if o=nil then exit;
    if oldName='' then exit; 
    try
       eso:=[ssoReplaceAll,ssoWholeWord,ssoEntireScope];
       fFrame.Edit.SearchReplace(oldName,TWincontrol(o).Name,eso);
    except
       messageDlg('Internal error $cn-can''t change the name.',mtError,[mbok],0)
    end
end;

function TPageSheet.UpdateEvent(o:TControl;evn,prms:string):string;
var
   i,x:integer;
   s,ln,lv,lp:string;
   fn:boolean;
   sp, DLG:string;
   T:TType;
   L:TStrings;
   F:TField;
   B:TBufferCoord;
begin
   result:='';
   if (self=nil) or (o=nil) then exit;
   if fFrame.Edit=nil then exit;
   if evn='' then exit;
   if pos(lowercase(evn),lowercase(Frame.Edit.Text))>0 then exit;
   L:=TStringList.Create;
   i:=0;
   fn:=false;
   F:=nil;
   repeat
       ln:=fFrame.Edit.Lines[i];
       if Ln<>'' then begin
          if (fFrame.Edit.Lines.Objects[i]=o) then begin
             if (pos(lowercase(evn),lowercase(Ln))>0) then begin
                fn:=true;
                s:=Frame.Edit.Lines[i];
                lp:=copy(s,1,pos('=',s)-1);
                lv:=copy(s,pos('=',s)+1,length(s));
                if pos('"',s)>0 then
                   lv:='"'+StringReplace(lv,lv,evn,[])+'"'
                else
                   lv:=StringReplace(lv,lv,evn,[]);
                Frame.Edit.Lines[i]:=lp+'='+lv;
                Saved:=false
              end ;
           end;
           if fn=false then begin
           end;
       end;
       inc(i);
  until i>Frame.Edit.Lines.Count-1;
  s:= format('declare static sub %s%s%s',[o.Name,evn,prms]);
  if o.InheritsFrom(TDialog) then
     T:=TDialog(o).Typ
  else
  if o.InheritsFrom(TContainer) then
     T:=TContainer(o).Typ
  else T:=nil;
  if T<>nil then begin
     RTTIGetFields(T.Extends,L);
     if evn<>'' then i:=L.IndexOf(evn);
     if i>-1 then begin
        F:=TField(L.Objects[i]);
        if F<>nil then begin
           F.Value:=Format('@%s%s',[o.Name,evn]);
           UpdateControl(o,evn,F.Value);
        end
     end else F:=nil;
  end;
  if pos(lowercase(s),lowercase(Frame.Edit.Text))=0 then begin
     i:=pos('public:',lowercase(Frame.Edit.Text));
     if i=-1 then
        i:=pos('end create',lowercase(Frame.Edit.Text));
     if i>-1 then begin
        B:=Frame.Edit.CharIndexToRowCol(i);
        for x:=1 to B.Char-2 do
            sp:=sp+' ';
        Frame.Edit.Lines.InsertObject(B.Line,sp+s,o);
     end
  end ;
  s:= format('%s.%s',[o.Name,evn]);
  if pos(lowercase(s),lowercase(Frame.Edit.Text))=0 then begin
     i:=pos('end constructor',lowercase(Frame.Edit.Text));
     if i>0 then begin
        B:=Frame.Edit.CharIndexToRowCol(i);
        for x:=1 to B.Char-2 do
            sp:=sp+' ';
        if F<>nil then
           if Scanner.Variables.IndexOf(o.Name)=-1 then begin
              Frame.Edit.Lines.InsertObject(B.Line-1,sp+s+'='+F.Value,o);
              if TContainer(o).AssignedEvents.IndexOf(evn)=-1 then
                 TContainer(o).AssignedEvents.AddObject(evn,F);
           end else begin
              Frame.Edit.Lines.InsertObject(B.Line-1,sp+'this.'+evn+'='+F.Value,o) ;
              if TDialog(o).AssignedEvents.IndexOf(evn)=-1 then
                 TDialog(o).AssignedEvents.AddObject(evn,F);
           end
     end
  end;
  if (pos('type',lowercase(Frame.Edit.Text))>0) and (pos(' extends ',lowercase(Frame.Edit.Text))>0) then
     dlg:=trim(copy(Frame.Edit.Text,pos('type',lowercase(Frame.Edit.Text))+4,pos(' extends ',lowercase(Frame.Edit.Text))-pos('type',lowercase(Frame.Edit.Text))-4));
  prms:=StringReplace(prms,'byref','byref Sender',[]);
  prms:=StringReplace(prms,'BYREF','BYREF Sender',[]);
  result:=Format('sub %s.%s%s%s',[dlg,o.Name,evn,prms]);
  L.Clear;
  L.Add('');
  L.AddObject(result,o) ;
  L.AddObject('    '' your code here',o) ;
  L.AddObject('end sub',o) ;
  Frame.Edit.Lines.AddStrings(L);
  Scanner.Execute;
  L.Free;
end;

procedure TPageSheet.Select(v:TObject);
var
   i:integer;
   M:TSynEditMark;
begin
    
    for i:=0 to fFrame.Edit.Lines.Count-1 do
        if fFrame.Edit.Lines.Objects[i]=v then begin
           M:=TSynEditMark.Create;
           M.ImageIndex:=1;
           fFrame.Edit.Marks.Add(M)
        end
end;

function TPageSheet.Find(v:string;where:integer=0;o:TObject=nil):TPoint;
var
   i,j,x:integer;
   tk:string;
   L:TStrings;
begin
   result:=point(-1,-1); L:=TStringList.Create;
   if pos(',',v)>0 then v:=StringReplace(v,',',#10,[rfReplaceAll]); 
   L.Text:=v;
   for j:=0 to L.Count-1 do begin
       for i:=where to fFrame.Edit.Lines.Count-1 do begin 
           x:=pos(lowercase(L[j]),lowercase(fFrame.Edit.Lines[i]));
           if x>0 then begin
              if x<length(fFrame.Edit.Lines[i]) then begin
                 tk:=copy(fFrame.Edit.Lines[i],x,x+length(v)+1);
                 if tk<>'' then
                    if tk[length(tk)] in [' ','.','='] then begin
                       if o=fFrame.Edit.Lines.Objects[i] then begin
                          if (result.X=x) and (result.y=i) then
                             result:=point(x,i);
                             break
                          end
                       end
                    end
             end;
         end
   end ;
   L.Free;
end;

initialization
   PagesList:=TStringList.Create;
   PagesList.OnChange:=Main.PagesListChange;
finalization
   PagesList.Free;
end.
