program CreEvent;

uses
  Forms,
  Main in 'Form\Main.pas' {frmMain} ,
  uEvent in 'Unit\uEvent.pas',
  Module in 'Module\Module.pas' {DMModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CreateEvent';
  Application.CreateForm(TDMModule, DMModule);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
