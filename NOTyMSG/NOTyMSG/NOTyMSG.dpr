program NOTyMSG;

uses
  Vcl.Forms,System.SysUtils,
  MainRecieve in 'MainRecieve.pas' {frmMainRecieve},
  uScript in 'Unit\uScript.pas',
  UresApp in 'Unit\UresApp.pas';

{$R *.res}

begin

    if (ParamCount = 0) then
    Exit;

  case ParamCount of
    1:
      if (ParamStr(1) = 'NOTyMSG') then
      begin
        //
      end
      else
        Exit;
  end;
  Application.Initialize;
  Application.Title:= ChangeFileExt(ExtractFileName(Application.ExeName),'');
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMainRecieve, frmMainRecieve);
  Application.Run;
end.
