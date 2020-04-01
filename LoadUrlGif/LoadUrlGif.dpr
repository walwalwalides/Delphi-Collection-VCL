program LoadUrlGif;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Main in 'Main.pas' {frmMain} ,
  Splash in 'View\Splash.pas' {frmSplash} ,
  About in 'View\About.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  // Display Splash Screen...
  try
    frmSplash := TfrmSplash.Create(Application);
    //
    frmSplash.ShowModal;
  finally
    frmSplash.Free;
  end;
  Application.Run;

end.
