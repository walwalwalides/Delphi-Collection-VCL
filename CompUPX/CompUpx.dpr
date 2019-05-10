program CompUpx;

uses
  Vcl.Forms,
  uMain in 'View\uMain.pas' {frmMain},
  uFileUtils in 'Unit\uFileUtils.pas',
  uFileChecker in 'Unit\uFileChecker.pas',
  uProgress in 'View\uProgress.pas' {frmProgress},
  uOption in 'View\uOption.pas' {frmOption},
  uAbout in 'View\uAbout.pas' {frmAbout};

{$R *.res}


begin
  Application.Initialize;


  Application.MainFormOnTaskbar := True;
  Application.Title:='CompUPX';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);

  Application.Run;

end.
