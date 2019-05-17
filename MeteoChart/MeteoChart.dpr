program MeteoChart;

uses
  Forms,
  Main in 'View\Main.pas' {frmMain},
  UObservable in 'Unit\UObservable.pas',
  UInterfaces in 'Unit\UInterfaces.pas',
  UMeteo in 'Unit\UMeteo.pas',
  About in 'View\About.pas' {frmAbout},
  Logging in 'View\Logging.pas' {frmLogging},
  Chart in 'View\Chart.pas' {frmChart};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.

