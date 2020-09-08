unit PropEditorsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ELPropInsp, HelperUnit, WindowStyleDlgUnit, WindowExStyleDlgUnit;

type
  TCompilerPropEdit =class(TELStringPropEditor)
     function GetAttrs:TELPropAttrs;override;
     procedure Edit; override;
  end;

  TFileNamePropEdit =class(TELStringPropEditor)
     function GetAttrs:TELPropAttrs;override;
     procedure Edit; override;
  end;

  TDirectoryPropEdit =class(TELStringPropEditor)
     function GetAttrs:TELPropAttrs;override;
     procedure Edit; override;
  end;

  TDLLPropEdit =class(TELStringPropEditor)
     function GetAttrs:TELPropAttrs;override;
     procedure Edit; override;
  end;

  TCodeFilePropEdit =class(TELStringPropEditor)
     function GetAttrs:TELPropAttrs;override;
     procedure Edit; override;
  end;

  var
     StyleValues :array[0..25] of string=('WS_OVERLAPPED','WS_POPUP','WS_CHILD',
'WS_MINIMIZE','WS_VISIBLE','WS_DISABLED','WS_CLIPSIBLINGS','WS_CLIPCHILDREN',
'WS_MAXIMIZE''WS_CAPTION ','WS_BORDER','WS_DLGFRAME','WS_VSCROLL','WS_HSCROLL',
'WS_SYSMENU',' WS_THICKFRAME','WS_GROUP','WS_TABSTOP','WS_MINIMIZEBOX','WS_MAXIMIZEBOX',
'WS_TILED','WS_ICONIC','WS_SIZEBOX ','WS_TILEDWINDOW ','WS_OVERLAPPEDWINDOW',
'WS_POPUPWINDOW','WS_CHILDWINDOW');
      StyleExValues:array[0..17] of string=('WS_EX_DLGMODALFRAME','WS_EX_NOPARENTNOTIFY',
'WS_EX_TOPMOST','WS_EX_ACCEPTFILES','WS_EX_TRANSPARENT','WS_EX_MDICHILD',
'WS_EX_TOOLWINDOW','WS_EX_WINDOWEDGE','WS_EX_CLIENTEDGE','WS_EX_CONTEXTHELP',
'WS_EX_RIGHT','WS_EX_LEFT','t WS_EX_LTRREADING','WS_EX_LEFTSCROLLBAR',
'WS_EX_RIGHTSCROLLBAR','WS_EX_CONTROLPARENT','WS_EX_STATICEDGE','WS_EX_APPWINDOW' );

implementation

{TCompilerPropEdit}
function TCompilerPropEdit.GetAttrs:TELPropAttrs;
begin
    result :=[praDialog];
end;

procedure TCompilerPropEdit.Edit;
begin
    with TOpenDialog.Create(nil) do begin
         Filter :='Executable file(*.exe)|*.exe';
         FileName :=Value;
         if Execute then
            Value := FileName;
         Free;
    end;
end;

{TFileNamePropEdit}
function TFileNamePropEdit.GetAttrs:TELPropAttrs;
begin
    result :=[praDialog];
end;

procedure TFileNamePropEdit.Edit;
begin
    with TOpenDialog.Create(nil) do begin
         Filter :='All file(*.*)|*.*';
         FileName :=Value;
         if Execute then
            Value := FileName;
         Free;
    end;
end;

{TDLLPropEdit}
function TDLLPropEdit.GetAttrs:TELPropAttrs;
begin
    result :=[praDialog];
end;

procedure TDLLPropEdit.Edit;
begin
    with TOpenDialog.Create(nil) do begin
         Filter :='DLL file(*.dll.*.ocx)|*.dll;*.ocx';
         FileName :=Value;
         if Execute then
            Value := FileName;
         Free;
    end;
end;

{TDirectoryPropEdit}
function TDirectoryPropEdit.GetAttrs:TELPropAttrs;
begin
    result :=[praDialog];
end;

procedure TDirectoryPropEdit.Edit;
var
   s :string;
begin
    s := Value;
    if BrowseForFolder(s,'Browse for Folder') then begin
         value:=s;
    end;
end;

{TCodeFilePropEdit}
function TCodeFilePropEdit.GetAttrs:TELPropAttrs;
begin
    result :=[praDialog];
end;

procedure TCodeFilePropEdit.Edit;
begin
    with TOpenDialog.Create(nil) do begin
         Filter :='RqWork script file(*.ksm)|*.ksm|All files (*.*)|*.*';
         FileName :=Value;
         if Execute then
            Value := FileName;
         Free;
    end;
end;

{TBorderStylePropEdit}

{TStylePropEdit}

{TClllipngPropEditor}

end.
