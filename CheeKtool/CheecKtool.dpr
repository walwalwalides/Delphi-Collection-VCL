program CheeckTool;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.dialogs,
  Vcl.Styles,
  system.SysUtils,
  MainTools in 'MainTools.pas' {frmMainTools} ,
  ToolLib in 'Unit\ToolLib.pas',
  untSplash in 'Form\untSplash.pas' {frmSplash};

{$R *.res}

const
  AppName = 'CheecKtool';

var

  StylePath: string;

begin

  Application.Initialize;

  StylePath := 'C:\Users\Public\Documents\Embarcadero\Studio\18.0\' + 'Styles\'; // path depend of delphi version

  Application.MainFormOnTaskbar := True;
  Application.Title := AppName;
  Application.CreateForm(TfrmMainTools, frmMainTools);
  frmMainTools.caption := AppName;


    if not TStyleManager.TrySetStyle('Auric', False) then
    begin
      try

        TStyleManager.LoadFromFile(StylePath + 'Auric.vsf')
      except

      end;
      TStyleManager.TrySetStyle('Auric', False); // set style after loading it
    end;


  // Display Splash Screen...
  try
    frmSplash := TfrmSplash.Create(Application);
    //
    frmSplash.ShowModal;
  finally
    frmSplash.Free;
  end;
  //

  Application.Run;

end.
