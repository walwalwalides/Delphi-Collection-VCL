{ ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Configuration, StdCtrls, Vcl.Imaging.pngimage, Skins,
  MainSkinRect, volume, AppEvnts,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.CategoryButtons, Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.ToolWin;

type

  TMainForm = class(TForm)
    ApplicationEvents: TApplicationEvents;
    imlIcons: TImageList;
    ActionList1: TActionList;
    actHome: TAction;
    actLayout: TAction;
    actPower: TAction;
    ToolBar1: TToolBar;
    tbtnNavigation: TToolButton;
    ToolButton: TToolButton;
    tbtnHome: TToolButton;
    ToolButton2: TToolButton;
    tbtnAbout: TToolButton;
    tbtnClose: TToolButton;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormPaint(Sender: TObject);
    procedure tbtnNavigationMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbtnNavigationMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbtnHomeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbtnHomeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure tbtnAboutMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbtnAboutMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbtnCloseClick(Sender: TObject);
  private
    ScrWidth, ScrHeight: Integer;
    Skin: TSkins;
    ProcList: TStringList;
    MainSkinsRect: TMainSkinsRect;
    SelectedRect: TRect;
    procedure DisplayTextButton(strBtn: string);
  public
    Settings: TSettings;
  end;

var
  MainForm: TMainForm;

implementation

uses
  System.Threading, About;

{$R *.dfm}

function WindowsExit(RebootParam: Longword): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;

function SetScreenResolution(Width, Height: Integer): Longint;
var
  DeviceMode: TDeviceMode;
begin
  try
    with DeviceMode do
    begin
      dmSize := SizeOf(TDeviceMode);
      dmPelsWidth := Width;
      dmPelsHeight := Height;
      dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
    end;
    Result := ChangeDisplaySettings(DeviceMode, CDS_UPDATEREGISTRY);
  except

  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  caption := Application.Title;
  Position := poDesigned;
  WindowState := wsMaximized;
  Left := 0;
  Top := 0;
  ScrWidth := GetSystemMetrics(SM_CXSCREEN);
  ScrHeight := GetSystemMetrics(SM_CYSCREEN);

  SetScreenResolution(ScrWidth, ScrHeight);
  Width := Screen.Width;
  Height := Screen.Height;

  Settings := TSettings.Create(nil);
  Settings.GetSkinSettings;

  Skin := TSkins.CreateWithSettings(nil, Settings);

  MainSkinsRect := TMainSkinsRect.Create(nil);
  MainSkinsRect.Settings := Settings;
  // MainSkinsRect.OnClickEvent := ButtonClick;
  MainSkinsRect.FormWidth := Width;
  MainSkinsRect.FormHeight := Height;
  MainSkinsRect.Skin := Skin;

end;

procedure DrawVert(Canvas: TCanvas; Box: TRect; const Text: string);
var
  i: Integer;
  s: string;
  R: TRect;
  WaitHandle: Cardinal;
  pi: TProcessInformation;
  closed: Integer;
begin
  closed := 0;
  Screen.Cursor := crHourGlass;
  s := '';
  for i := 1 to Length(Text) do
    s := s + Text[i] + ' ';
  R := Rect(0, 0, 1, 0);
  Canvas.TextRect(R, s, [tfCalcRect, tfNoClip, tfWordBreak]);
  Box.Left := Box.Left + (Box.Right - Box.Left - R.Right) div 2;
  Box.Top := Box.Top + (Box.Bottom - Box.Top - R.Bottom) div 2;
  Box.Right := Box.Left + R.Right;
  Box.Bottom := Box.Top + R.Bottom;
  TTask.Run(
    procedure
    Begin
      Canvas.TextRect(Box, s, [tfWordBreak]);

      TThread.Synchronize(nil,
        procedure
        begin

          Screen.Cursor := crDefault;

        end);
    End);

end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if Skin <> nil then
    Skin.DrawSkinMainForm(Canvas, ClientRect, SelectedRect, 0);
end;

procedure TMainForm.tbtnHomeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  strBtn: string;
begin
  strBtn := tbtnHome.caption;
  DisplayTextButton(strBtn);

end;

procedure TMainForm.tbtnHomeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Skin <> nil then
    Skin.DrawSkinMainForm(Canvas, ClientRect, SelectedRect, 0);

  MainSkinsRect.ButtonClick(self.Name, tbtnHome.caption);
end;

procedure TMainForm.tbtnNavigationMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  strBtn: string;
begin
  strBtn := tbtnNavigation.caption;
  DisplayTextButton(strBtn);
end;

procedure TMainForm.tbtnNavigationMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Skin <> nil then
    Skin.DrawSkinMainForm(Canvas, ClientRect, SelectedRect, 0);

  MainSkinsRect.ButtonClick(self.Name, tbtnNavigation.caption);
end;

procedure TMainForm.tbtnAboutMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  strBtn: string;
begin
  strBtn := tbtnAbout.caption;
  DisplayTextButton(strBtn);

end;

procedure TMainForm.tbtnAboutMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Skin <> nil then
    Skin.DrawSkinMainForm(Canvas, ClientRect, SelectedRect, 0);
  frmAboutBox.ShowModal;
end;

procedure TMainForm.tbtnCloseClick(Sender: TObject);
begin
Close;
end;

procedure TMainForm.DisplayTextButton(strBtn: string);
begin
  if Skin <> nil then
    Skin.DrawSkinMainForm(Canvas, ClientRect, SelectedRect, 1);
  Canvas.Font.Name := 'Arial';
  Canvas.Brush.Color := clTeal;
  Canvas.Font.Size := 50;
  Canvas.Font.Color := clwhite;
  Canvas.Font.Style := [fsBold];
  DrawVert(Canvas, ClientRect, strBtn);

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Mute;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Skin.Free;
    MainSkinsRect.Free;
    Settings.Free;
  }
  SetScreenResolution(ScrWidth, ScrHeight);
end;

procedure TMainForm.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  E := nil;
end;

end.
