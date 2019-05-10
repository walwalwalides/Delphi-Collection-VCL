unit Skins;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, JvSimpleXml,
  Dialogs, Forms, SkinBase, Configuration, Vcl.Imaging.pngimage, ButtonEventList;

type
  TSkins = class(TSkinBase)
  private
    FNavigationPage: integer;
    procedure SetNavigationPage(val: integer);
    function PngDrawBmp(filename: string): TBitmap;
  public
    Brightness: integer;
    Settings: TSettings;
    ButtonEventList: TButtonEventList;
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithSettings(AOwner: TComponent; S: TSettings);
    destructor Destroy; override;
    procedure DrawSkinMainForm(Canvas: TCanvas; DrawRect, SelectRect: TRect;status: ShortInt=0);
    function GetButtonCaptionPosition(ButtonName: string): TButtonPosition;
    property NavigationPage: integer read FNavigationPage write SetNavigationPage;
  end;

implementation

uses DB;

constructor TSkins.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNavigationPage := 0;
  Brightness := 0;

end;

constructor TSkins.CreateWithSettings(AOwner: TComponent; S: TSettings);
begin
  Create(AOwner);
  Settings := S;
  ButtonEventList := TButtonEventList.Create(nil);
  ButtonEventList.Settings := Settings;
  ButtonEventList.BuildEventList;

end;

destructor TSkins.Destroy;
begin
  ButtonEventList.Free;
  inherited Destroy;
end;

procedure TSkins.SetNavigationPage(val: integer);
var
  modval: integer;
begin
  if ButtonEventList.EventList.RecordCount >= val * 6 then
  begin
    if val < 0 then
    begin
      modval := ButtonEventList.EventList.RecordCount mod 6;
      if modval > 0 then
        modval := 1
      else
        modval := 0;
      FNavigationPage := (ButtonEventList.EventList.RecordCount div 6) - 1 + modval;
    end
    else
      FNavigationPage := val;
  end
  else
    FNavigationPage := 0;

end;

function TSkins.GetButtonCaptionPosition(ButtonName: string): TButtonPosition;
var
  i: integer;
begin
  for i := 0 to Settings.ButtonList.Count - 1 do
  begin
    if LowerCase(TButtonPosition(Settings.ButtonList[i]).ButtonName) = LowerCase(ButtonName) then
    begin
      Result := TButtonPosition(Settings.ButtonList[i]);
      break;
    end;
  end;
end;

procedure TSkins.DrawSkinMainForm(Canvas: TCanvas; DrawRect, SelectRect: TRect;status: ShortInt=0);
var
  BackgroundImage, DownBackgroundImage: string;
  BmpOff, BmpOn: TBitmap;
  IconPng: TPNGObject;
  caption, iconPath: string;
  fontname: string;
  fontsize: integer;
  TextX, TextY, IconX, IconY: integer;
  i, ButtonIndex: integer;
  RecNo: integer;
begin
  BackgroundImage := Settings.SkinPath + '\screens\Main_Back.png';
  DownBackgroundImage := Settings.SkinPath + '\screens\Main_Front.png';
  if FileExists(BackgroundImage) then
  begin
    BmpOff := PngDrawBmp(BackgroundImage);
    BmpOn := PngDrawBmp(DownBackgroundImage);

    BmpOff.Canvas.CopyRect(SelectRect, BmpOn.Canvas, SelectRect);
    ButtonEventList.EventList.First;
    while not ButtonEventList.EventList.Eof do
    begin
      RecNo := ButtonEventList.EventList.RecNo;
      if (RecNo > (FNavigationPage * 6)) and (RecNo <= ((FNavigationPage + 1) * 6)) then
      begin
        if ButtonEventList.EventList.FieldByName('formname').AsString = 'Mainform' then
        begin
          ButtonIndex := (RecNo mod 6);
          if ButtonIndex = 0 then
            ButtonIndex := 6;
          // ShowMessage(IntToStr(RecNo)+'--'+IntToStr(ButtonIndex)+'--'+IntToStr(FNavigationPage * 6)+'---'+IntToStr((FNavigationPage + 1) * 6));
          caption := ButtonEventList.EventList.FieldByName('buttoncaption').AsString;
          iconPath := ExtractFilePath(ButtonEventList.EventList.FieldByName('libpath').AsString) + 'Skin\' +
            ButtonEventList.EventList.FieldByName('icon').AsString;
          fontname := GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).fontname;
          fontsize := GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).fontsize;
          TextX := GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).CaptionX;
          TextY := GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).CaptionY;
          IconX := GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).IconX;
          IconY := GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).IconY;
          GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(ButtonIndex)).PluginButtonName :=
            ButtonEventList.EventList.FieldByName('buttonname').AsString;
          BmpOff.Canvas.Font.Name := fontname;
          BmpOff.Canvas.Font.Style := [fsBold];
          BmpOff.Canvas.Font.Size := fontsize;
          BmpOff.Canvas.Brush.Style := bsClear;
          BmpOff.Canvas.TextOut(TextX, TextY, caption);

          if FileExists(iconPath) then
          begin
            IconPng := TPNGObject.Create;
            IconPng.LoadFromFile(iconPath);
            BmpOff.Canvas.Draw(IconX, IconY, IconPng);
            IconPng.Free;
          end;

        end;
      end;
      ButtonEventList.EventList.Next;
    end;

    // for i := 6 downto ButtonIndex+1 do
    // GetButtonCaptionPosition(Settings.MenuButtonBaseName + IntToStr(i)).PluginButtonName := '';
    case status of
      0:
        Canvas.StretchDraw(DrawRect, BmpOff);
      1:
        Canvas.StretchDraw(DrawRect, BmpOn);
    end;

    BmpOff.Free;
    BmpOn.Free;
  end;
end;

function TSkins.PngDrawBmp(filename: string): TBitmap;
var
  Png: TPNGObject;
  Bmp: TBitmap;
begin
  if FileExists(filename) then
  begin
    Png := TPNGObject.Create;
    Png.LoadFromFile(filename);

    Bmp := TBitmap.Create;
    Bmp.Width := Png.Width;
    Bmp.Height := Png.Height;
    Bmp.Canvas.Brush.Style := bsSolid;
    Bmp.Canvas.Brush.Color := clBtnFace;
    Bmp.Canvas.FillRect(Rect(0, 0, Png.Width, Png.Height));
    Bmp.Canvas.Draw(0, 0, Png);
    Bmp.Canvas.Pixels[0, Bmp.Height - 1] := clBtnFace;
    Png.Free;
    Result := Bmp;
  end
  else
    Result := nil;
end;

end.
