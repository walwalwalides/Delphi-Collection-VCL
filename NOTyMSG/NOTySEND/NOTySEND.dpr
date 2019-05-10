program NOTySEND;

uses
  Vcl.Forms,
  MainSender in 'MainSender.pas' {frmMainSender};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMainSender, frmMainSender);
  Application.Run;
end.
