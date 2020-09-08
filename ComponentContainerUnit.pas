unit ComponentContainerUnit;

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
  Dialogs, Menus, ImgList, XPMan, ComCtrls, ToolWin, ExtCtrls, TypesUnit,
  IniFiles, FreeBasicRTTI, ContainerUnit;

type
   TCContainer=class(TContainer)
   private
     fGlyph:TBitmap;
     fCanvas:TControlCanvas;
     procedure SetHosted(v:string);overload;
   protected
      procedure CreateParams(var params:TCreateParams);override;
      procedure Resize;override;
      procedure DoPaint(var m:TWmPaint);message wm_paint;
      
   public
      constructor Create(AOwner :TComponent);override;
      destructor Destroy; override;
   end;

implementation

constructor TCContainer.Create(AOwner :TComponent);
begin
    inherited;
    fGlyph:=TBitmap.Create;
    fCanvas:=TControlCanvas.Create;
    fCanvas.Control:=self;
end;

destructor TCContainer.Destroy;
begin
   fGlyph.Free;
   fCanvas.Free;
   inherited;
end;

procedure TCContainer.CreateParams(var params:TCreateParams);
begin
    params.ExStyle:=ws_ex_topmost;
    inherited
end;

procedure TCContainer.Resize;
begin
    inherited;
    width:=24;
    height:=24;
end;

procedure TCContainer.DoPaint(var m:TWmPaint);
begin
   inherited;
   if not fGlyph.Empty then begin
      fCanvas.StretchDraw(rect(0,0,width,height),fGlyph);
   end
end;

procedure TCContainer.SetHosted(v:string);
begin
    inherited;
end;

end.
