program MySQL_StoreProc;

uses
  Vcl.Forms,
  UScript in 'Unit\UScript.pas',
  Module in 'Module\Module.pas' {DMModule: TDataModule},
  Main in 'Form\Main.pas' {frmMain},
  URegConfig in 'Unit\URegConfig.pas',
  UConfig in 'Unit\UConfig.pas',
  ULog in 'Unit\ULog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMModule, DMModule);
  BuildTable;
  CreateScript;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
