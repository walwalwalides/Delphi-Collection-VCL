program BatterflyTray;

{$R 'AppIcon.res' 'AppIcon.rc'}

uses
  Forms,
  Template in 'View\Template.pas' {frmTemplate},
  View.Main in 'View\View.Main.pas' {frmViewMain},
  View.Home in 'View\View.Home.pas' {frmViewHome};

begin
  Application.Initialize;
  Application.CreateForm(TfrmViewMain, frmViewMain);
  Application.CreateForm(TfrmTemplate, frmTemplate);
  Application.CreateForm(TfrmViewHome, frmViewHome);
  Application.Run;
end.
