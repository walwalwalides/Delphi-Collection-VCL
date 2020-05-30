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
    procedure miAboutClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
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

implementation

uses Inifiles, Winapi.ShlObj, uToolLib, license, About;

{$R *.dfm}

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
  self.Position := poMainFormCenter;
  self.Color := clwhite;
  self.Caption := 'SoftwareLicense';
  self.WindowState := wsMaximized;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  //
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
var
  f: TAboutBox;
begin
  if Assigned(f) then
    Application.CreateForm(TAboutBox, f);
  f.Position := poMainFormCenter;
  try
    f.ShowModal;
  finally
    FreeAndNil(f);
  end;

end;

procedure TfrmMain.miExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
