program MyStringGrid;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  uStringGrid in 'uStringGrid.pas',
  uSettingPrint in 'uSettingPrint.pas',
  SetupPrinter in 'SetupPrinter.pas' {frmSetupPrinter},
  Module in 'Module\Module.pas' {DMModule: TDataModule},
  uIConnection in 'Api\uIConnection.pas',
  uTConnection in 'Implimentation\uTConnection.pas',
  About in 'About\About.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.title:='MyStringGrid';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
