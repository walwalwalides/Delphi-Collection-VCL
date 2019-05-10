program CheeckFont;

uses
  Vcl.Forms,
  Main in 'View\Main.pas' {FrmMain},
  ToolLib in 'Unit\ToolLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title:='CheeckFont';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
