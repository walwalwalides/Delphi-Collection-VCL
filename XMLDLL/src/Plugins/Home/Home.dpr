library Home;

uses
  SysUtils,
  Classes,
  Forms,
  MainHome in 'MainHome.pas' {frmMainHome};

{$R *.res}

function ShowNavigationForm: TForm; stdcall; export;
begin
  frmMainHome:= TfrmMainHome.Create(nil);
  Result := frmMainHome;
end;

exports
  ShowNavigationForm;

begin
end.
