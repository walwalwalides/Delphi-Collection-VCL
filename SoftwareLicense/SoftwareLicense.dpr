program SoftwareLicense;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  About in 'About.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
