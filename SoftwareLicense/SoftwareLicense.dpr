program SoftwareLicense;

uses
  Vcl.Forms,
  Inifiles,
  Main in 'Main.pas' {frmMain},
  License in 'License.pas' {frmLicense},
  uExScrollBox in 'uExScrollBox.pas',
  uToolLib in 'uToolLib.pas',
  About in 'About\About.pas' {AboutBox};

{$R *.res}
var
  Inif: TCustomIniFile;
  MyLicense: TForm;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := false;

    LicenseRead := FALSE; // license acceptance?

  try
    Inif := TMemIniFile.Create(GetAppDataPath + IniFileName);
    LicenseRead := Inif.ReadBool(SetupSection, 'LicenseRead', FALSE);

    if not(LicenseRead) then
    begin
      MyLicense := TfrmLicense.Create(Application);
      Try
        MyLicense.ShowModal
      Finally
        MyLicense.Free;
      End;
    end;
  finally
    Inif.Free;
  end;
  //
  if not(LicenseRead) then
    exit;

  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
