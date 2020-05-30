{ ============================================
  Software Name : 	SoftwareLicense
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : walwalwalides@gmail.com }
{ GitHub : https://github.com/walwalwalides }
{ ******************************************** }

unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miAbout: TMenuItem;
    F1: TMenuItem;
    miExit: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    AppDataPath: string;
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;
  LicenseRead: Boolean; // if set do not show about screen on startup

const
  MyAppName = 'SoftwareLicense';
  AppDataName = '\' + MyAppName;
  IniFileName = '\SoftwareLicense.ini';
  SetupSection = 'Setup';
  CurVersion = '1.0.0';
  NOF = '--nof--';

implementation

uses Inifiles, Winapi.ShlObj, about;

{$R *.dfm}
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

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Inif: TCustomIniFile;
  ParityStr: String; // string reprentaton of com values for com port
  Swflow, HwFlow: String;

begin
{
  try
      Inif := TMemIniFile.Create(AppDataPath + IniFileName);
          // setup section
              Inif.WriteBool(SetupSection, 'LicenseRead', LicenseRead);
                Finally
                    Inif.UpdateFile;
                        Inif.Free;
                            // Except
                                // ShowMessage('error updating ' + AppDataPath + IniFileName);
                                  end;
                                  }
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  AppDataPath := GetAppDataPath;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  Inif: TCustomIniFile;
  MyAbout: TForm;

begin
  LicenseRead := FALSE; // license acceptance?
  Application.BringToFront;

  try
    Inif := TMemIniFile.Create(AppDataPath + IniFileName);
    // note: a TMemIniFile is believed to be more efficient than TIniFile
    LicenseRead := Inif.ReadBool(SetupSection, 'LicenseRead', FALSE);

    if not(LicenseRead) then
    begin
      MyAbout := TfrmAbout.Create(nil);

      Try
        MyAbout.ShowModal
      Finally
        MyAbout.Free;
      End;
    end;
  finally
    Inif.Free;
  end;
  //
  if not(LicenseRead) then
    Application.Terminate;
end;

end.
