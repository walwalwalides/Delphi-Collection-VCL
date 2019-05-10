program TraitExcept;

uses
  Vcl.Forms,
  UBase in 'View\UBase.pas' {frmBase},
  UProgExcep in 'View\UProgExcep.pas' {frmProgExcep},
  UMain in 'View\UMain.pas' {frmMain},
  uSignal in 'Unit\uSignal.pas',
  uAbout in 'View\uAbout.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title:='TraitException';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
