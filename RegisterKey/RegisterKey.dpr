program RegisterKey;

uses
  Vcl.Forms,
  Main in 'View\Main.pas' {frmMain},
  ToolLib in 'Unit\ToolLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
