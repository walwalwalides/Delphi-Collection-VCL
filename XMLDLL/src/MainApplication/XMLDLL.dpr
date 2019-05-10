program XMLDLL;



{$R 'ResImages.res' 'ResImages.rc'}

uses
  Forms,
  System.SysUtils,
  main in 'main.pas' {MainForm},
  Configuration in 'Configuration.pas',
  MainSkinRect in 'MainSkinRect.pas',
  Skins in 'Skins.pas',
  ButtonEventList in 'ButtonEventList.pas',
  SkinBase in 'SkinBase.pas',
  About in 'About.pas' {frmAboutBox},
  pluginlist in 'pluginlist.pas',
  XmlFileSettings in 'XmlFileSettings.pas',
  UtilsFunc in 'UtilsFunc.pas',
  XmlFileHome in 'XmlFileHome.pas',
  ResImg in 'UnitRes\ResImg.pas',
  ResXml in 'UnitRes\ResXml.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.Title := 'XMLDLL';

  CheckImgRes;
  CheckXmlRes;

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmAboutBox, frmAboutBox);
  Application.Run;

end.
