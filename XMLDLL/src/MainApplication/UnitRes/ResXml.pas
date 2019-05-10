 { ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }



{
Generate  Settings.XML  to relate the Main Application with Home.DLL
}
unit ResXml;

interface

uses forms, SysUtils, XmlFileHome, XmlFileSettings;

const
  FolderSettings = 'System\';
  FolderHome = 'Plugins\DLLHome\';
procedure CheckXmlRes;

implementation

procedure CheckXmlRes;
var
  sLink: string;
  sApp: string;
  tmpScreen: TrecScreen;
  tmpPlugin: TrecPlugin;
  tmpButton: TrecButton;
Begin
  sApp:=ExtractFilePath(Application.ExeName);
  sLink := '';
  sLink := sApp + FolderSettings + 'settings.xml';
  // DeleteFile(sLink);
  // Set Setting Configuration
  if not fileexists(sLink) then
  begin

    if not DirectoryExists(sApp + FolderSettings) then
      ForceDirectories(sApp + FolderSettings);

    tmpScreen.scrWidth := Screen.Width;
    tmpScreen.scrHeight := Screen.Height;
    // ------------------------------  //
    gvProjectSettings.Open(sLink);
    gvProjectSettings.skinname := 'MainSkin';
    gvProjectSettings.Screen := tmpScreen;
    // int1:=gvProjectOptions.SCREEN.scrWidth;
  end;
  sLink := '';
  sLink := ExtractFilePath(Application.ExeName) + FolderHome + 'Config.xml';

  // DeleteFile(sLink);
  if not fileexists(sLink) then
  begin
    if not DirectoryExists(sApp + FolderSettings) then
      ForceDirectories(sApp + FolderSettings);
    // ------------------------------  //
    tmpPlugin.PluName := 'HOME';
    tmpPlugin.PluLib := 'HOME.dll';
    tmpButton.ButName := 'HOME';
    tmpButton.ButDRAWFORM := 'MainForm';

    gvProjectHome.Open(sLink);
    // gvProjectHome.skinname := 'MainSkin';
    gvProjectHome.PLUGIN := tmpPlugin;
    gvProjectHome.SKIN := 'Skin';
    gvProjectHome.Button := tmpButton;
    gvProjectHome.ButtonEvt := 'ONCLICK';
    gvProjectHome.ButtonEvtValue := 'ShowNavigationForm';

    // int1:=gvProjectOptions.SCREEN.scrWidth;
  end;
end;

end.
