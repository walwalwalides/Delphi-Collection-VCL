program CountDown;





{$R *.dres}

uses
  Forms,
  UCountDownTimer1 in 'Unit\UCountDownTimer1.pas',
  UCountDownTimer2 in 'Unit\UCountDownTimer2.pas',
  UCountDownTimer3 in 'Unit\UCountDownTimer3.pas',
  UCountDownTimer4 in 'Unit\UCountDownTimer4.pas',
  Main in 'View\Main.pas' {frmMain},
  uAbout in 'View\uAbout.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
