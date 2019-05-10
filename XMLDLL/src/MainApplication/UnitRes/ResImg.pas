unit ResImg;

interface

uses forms,SysUtils,PngImage;

const
  FolderLogo = 'Skins\MainSkin\Logo\';
  FolderScreens = 'Skins\MainSkin\Screens\';
procedure CheckImgRes;
procedure CreateResImages(Const nameRes: string; const pathRes: string);

implementation

procedure CheckImgRes;

var
  sLink: string;
  sApp: string;
Begin
  sApp:=ExtractFilePath(Application.ExeName);
  sLink := '';
  sLink := sApp + FolderScreens + 'Main_Back.png';
  if not fileexists(sLink) then
  begin
    if not DirectoryExists(sApp + FolderScreens) then
      ForceDirectories(sApp + FolderScreens);
    CreateResImages('Main_Back', sLink);   //Generate Image from Resource
  end;

  sLink := '';
  sLink := sApp + FolderScreens + 'Main_Front.png';
  if not fileexists(sLink) then
  begin
    if not DirectoryExists(sApp + FolderScreens) then
      ForceDirectories(sApp + FolderScreens);
    CreateResImages('Main_Front', sLink); //Generate Image from Resource
  end;

  sLink := '';
  sLink := sApp + FolderLogo + 'About.png';
  if not fileexists(sLink) then
  begin
    if not DirectoryExists(sApp + FolderLogo) then
      ForceDirectories(sApp + FolderLogo);
    CreateResImages('About', sLink);
  end;
end;

procedure CreateResImages(Const nameRes: string; const pathRes: string);
var
  Png: TPngImage;
begin
  Png := TPngImage.Create;
  try
    Png.LoadFromResourceName(HInstance, nameRes);
    Png.SaveToFile(pathRes);
  finally
    Png.Free;
  end;
end;

end.
