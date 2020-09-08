unit PropertyEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls;

type
   TPropertyEditor=class(TForm)
   protected
     fStoredHandle:hwnd;
     fValue:variant;
     procedure SetValue(v:variant); virtual; abstract;
     function GetValue:variant; virtual; abstract;
   private
     procedure SetStoredHandle(v :hwnd);
   public
     function Execute :boolean;
     property Value:variant read GetValue write SetValue;
     property StoredHandle :hwnd read fStoredHandle write SetStoredHandle;
   end;

implementation

function TPropertyEditor.Execute: boolean;
begin
    result :=(ShowModal=mrok);
end;

procedure TPropertyEditor.SetStoredHandle(v :hwnd);
begin
    fStoredHandle:=v;
end;

end.
