unit SplashUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TypesUnit, ExtCtrls, StdCtrls;

type
  TSplash = class(TForm)
    LabelFile: TLabel;
    Kind: TLabel;
    Logo: TLabel;
    Prog: TLabel;
    version: TLabel;
    Copyright: TLabel;
    LabelLegal: TLabel;
    LabelVersion: TLabel;
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure WMEraseBkGnd(var m:TMessage); message wm_erasebkgnd;
  public
    { Public declarations }
    img:TJpegImage;
  end;

var
  Splash: TSplash;

implementation

{$R *.dfm}

uses MainUnit, CodeUnit, ObjectsTreeUnit, InspectorUnit, LauncherUnit,
     InstallClassUnit;

procedure TSplash.WMEraseBkGnd(var m:TMessage);
var
   I:TJpegImage;
begin
    if fileexists(ideDir+'res\splash_1.jpg') then begin
       I:=TJpegImage.Create;
       I.LoadFromFile(ideDir+'res\splash_1.jpg');
       Canvas.StretchDraw(rect(0,0,width,height),I);
       I.Free ;
    end else inherited;
end;

procedure TSplash.FormClick(Sender: TObject);
begin
    Close
end;

procedure TSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if FileExists(ideDir+'gui\core.bi') then begin
    try
       DiscardBridge;

       try
           Main.BuildBridge;
       except messageDlg('Internal error: $bbg-can''t build bridge.',mtError,[mbok],0); end;
       try
          Main.LoadBridge;
       except messageDlg('Internal error: $lbg-can''t load bridge.',mtError,[mbok],0); end;
       Launcher.LoadClasses;
    except
       messageDlg('External exception $lb:-unable to load bridge.',mterror,[mbok],0);
    end ;
    end;

    Code.show;
    ObjectsTree.show;
    Inspector.Show;

    Main.LinkBridge;
end;

end.
