unit uToolLib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Inifiles, Winapi.ShlObj;

function GetAppDataPath: string;

const
  NOF = '--nof--';

implementation

function ShGetFolderPath(hWndOwner: HWND; csidl: Integer; hToken: THandle;
  dwReserved: DWord; lpszPath: PChar): HResult; stdcall;
  external 'ShFolder.dll' name 'SHGetFolderPathW';

function GetAppDataPath: string;
var
  DataPath: array [0 .. MAX_PATH] of CHAR;
  success: Boolean;
begin
  success := ShGetFolderPath(0, CSIDL_LOCAL_APPDATA or
    $8000 { CSIDL_FLAG_CREATE } , 0, { SHGFP_TYPE_CURRENT } 0, DataPath) = S_OK;
  if success then
    Result := DataPath
  else
    Result := NOF;
end;

end.
