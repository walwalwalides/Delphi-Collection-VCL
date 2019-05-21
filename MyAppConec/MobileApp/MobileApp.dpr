program MobileApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  MAIN in 'MAIN.pas' {Form4},
  ClientClassesApp in 'ClientClassesApp.pas',
  ClientModuleApp in 'ClientModuleApp.pas' {ClientModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TClientModule, ClientModule);
  Application.Run;
end.
