{ ============================================
  Software Name : 	NOTyMSG
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit MainRecieve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, MSHTML, ShellAPI, StdCtrls, ExtCtrls, XPMan,
  Menus, ImgList, IniFiles, System.ImageList, System.Actions, Vcl.ActnList,uResApp;

const
  FolderLibary = 'Libary\';
  FolderHtml = 'html\';
  FolderIni = 'ini\';
  FolderTxt = 'txt\';
  FolderPng = 'png\';


type
  TfrmMainRecieve = class(TForm)
    WebView: TWebBrowser;
    XPManifest: TXPManifest;
    PopupMenu: TPopupMenu;
    AboutBtn: TMenuItem;
    LineItem: TMenuItem;
    ExitBtn: TMenuItem;
    Icons: TImageList;
    actlstNOt: TActionList;
    CloseApplication: TAction;
    AboutApplication: TAction;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);

    procedure WebViewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure FormDestroy(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure WebViewDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure CloseApplicationExecute(Sender: TObject);
    procedure AboutApplicationExecute(Sender: TObject);
  private
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMNCHITTEST(var Msg: TMessage); message WM_NCHITTEST;
    procedure DefaultHandler(var Message); override;
    procedure MyShow;
    procedure MyHide;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure IconMouse(var Msg: TMessage); message WM_USER + 1;
    procedure WMActivate(var Msg: TMessage); message WM_ACTIVATE;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainRecieve: TfrmMainRecieve;
  Notifications, ExcludeList: TStringList;
  WM_TaskBarCreated: Cardinal;
  IconIndex: byte;
  IconFull: TIcon;
  ID_NOTIFICATIONS, ID_DELETE_ALL, ID_UNKNOWN_APP, ID_LAST_UPDATE: string;
  RunOnce: boolean;
  ipos: integer = 0;

implementation

uses
  uScript;

{$R *.dfm}

var
  sAppPathLib: string;

procedure TfrmMainRecieve.MyShow;
begin
  if RunOnce = false then
  begin
    frmMainRecieve.AlphaBlendValue := 255;
    RunOnce := true;
  end;
  Top := Screen.Height - frmMainRecieve.Height - 54;
  Left := Screen.Width - frmMainRecieve.Width - 8;
  if WebView.Document <> nil then
    (WebView.Document as IHTMLDocument2).ParentWindow.Focus;
  ShowWindow(Handle, SW_SHOW);
end;

procedure TfrmMainRecieve.MyHide;
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure funcTray(ActInd: integer);
var
  nim: TNotifyIconData;
begin
  with nim do
  begin
    cbSize := System.SizeOf(nim);
    Wnd := frmMainRecieve.Handle;
    uId := 1;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;

    if IconIndex = 0 then
      hIcon := SendMessage(Application.Handle, WM_GETICON, ICON_SMALL2, 0)
    else
      hIcon := IconFull.Handle;

    uCallBackMessage := WM_USER + 1;
    StrCopy(szTip, PChar(Application.Title));
  end;
  case ActInd of
    1:
      Shell_NotifyIcon(NIM_ADD, @nim);
    2:
      Shell_NotifyIcon(NIM_DELETE, @nim);
    3:
      Shell_NotifyIcon(NIM_MODIFY, @nim);
  end;
end;

procedure TfrmMainRecieve.IconMouse(var Msg: TMessage);
begin
  case Msg.LParam of
    WM_LBUTTONDOWN:
      begin
        MyShow;
        IconIndex := 0;
        funcTray(3);
      end;

    WM_LBUTTONDBLCLK:
      MyHide;

    WM_RBUTTONDOWN:
      PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TfrmMainRecieve.CloseApplicationExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainRecieve.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := WS_POPUP or WS_THICKFRAME;
end;

function GetLocaleInformation(flag: integer): string;
var
  pcLCA: array [0 .. 20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, flag, pcLCA, 19) <= 0 then
    pcLCA[0] := #0;
  Result := pcLCA;
end;

procedure TfrmMainRecieve.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  pathHtml: string;
  pathLang: string;
  pathLangEng: string;
  pathCfg: string;
  pathTxtNot: string;
  pathTxtExc: string;

begin
// with WebView.Document.web do
//  begin
//    OverflowX := 'hidden';
//    OverflowY := 'hidden';
//  end; { with WebBrowser1 }


//  ShowScrollBar(Handle, SB_NONE, False);
  sAppPathLib := ExtractFilePath(Application.ExeName) + FolderLibary;
  // Create Directory
  if not DirectoryExists(sAppPathLib) then
    ForceDirectories(sAppPathLib);
  if not DirectoryExists(sAppPathLib + FolderHtml) then
    ForceDirectories(sAppPathLib + FolderHtml);
  if not DirectoryExists(sAppPathLib + FolderTxt) then
    ForceDirectories(sAppPathLib + FolderTxt);
  if not DirectoryExists(sAppPathLib + FolderPng) then
    ForceDirectories(sAppPathLib + FolderPng);
  if not DirectoryExists(sAppPathLib + FolderIni) then
    ForceDirectories(sAppPathLib + FolderIni);
  if not DirectoryExists(sAppPathLib + FolderIni + '\lang') then
    ForceDirectories(sAppPathLib + FolderIni + '\lang');

  Top := Screen.Height - frmMainRecieve.Height - 54;
  Left := Screen.Width - frmMainRecieve.Width - 8;
  pathCfg := sAppPathLib + FolderIni + INI_Cf;

  Ini := TIniFile.Create(pathCfg);
  IconIndex := Ini.ReadInteger('Main', 'NewMessages', 0);
  Ini.Free;
  IconFull := TIcon.Create;
  Icons.GetIcon(0, IconFull);

  // Translate
  pathLang := sAppPathLib + FolderIni + 'Lang\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini';
  pathLangEng := sAppPathLib + FolderIni + 'Lang\English.ini';
  if FileExists(pathLang) then
    Ini := TIniFile.Create(pathLang)
  else if FileExists(pathLangEng) then
  begin
    Ini := TIniFile.Create(pathLangEng);

    Application.Title := Ini.ReadString('Main', 'ID_TITLE', '');
    ID_NOTIFICATIONS := Ini.ReadString('Main', 'ID_NOTIFICATIONS', '');
    ID_DELETE_ALL := Ini.ReadString('Main', 'ID_DELETE_ALL', '');
    ID_UNKNOWN_APP := Ini.ReadString('Main', 'ID_UNKNOWN_APP', '');
    AboutBtn.Caption := Ini.ReadString('Main', 'ID_ABOUT_TITLE', '');
    ID_LAST_UPDATE := Ini.ReadString('Main', 'ID_LAST_UPDATE', '');
    ExitBtn.Caption := Ini.ReadString('Main', 'ID_EXIT', '');

    Ini.Free;
  end
  else
  begin

    ID_NOTIFICATIONS := Application.Title;
    ID_DELETE_ALL := 'DELETE ALL';
    ID_UNKNOWN_APP :=Application.Title;
    ID_LAST_UPDATE := 'Last update:';

    Ini := TIniFile.Create(pathLangEng);
    Ini.WriteString('Main', 'ID_TITLE',Application.Title);
    Ini.WriteString('Main', 'ID_NOTIFICATIONS',ID_NOTIFICATIONS);
    Ini.WriteString('Main', 'ID_DELETE_ALL',ID_DELETE_ALL);
    Ini.WriteString('Main', 'ID_UNKNOWN_APP',ID_UNKNOWN_APP);
    Ini.WriteString('Main', 'ID_ABOUT_TITLE',AboutBtn.Caption);
    Ini.WriteString('Main', 'ID_LAST_UPDATE',ID_LAST_UPDATE);
    Ini.WriteString('Main', 'ID_EXIT',ExitBtn.Caption);
    Ini.Free;

  end;


  //

  WM_TaskBarCreated := RegisterWindowMessage('TaskbarCreated');

  WebView.Silent := true;

  pathHtml := sAppPathLib + FolderHtml + 'main.htm';
  if FileExists(pathHtml) then
    DeleteFile(pathHtml);
  CrHTMLscript(pathHtml, '');
  WebView.Navigate(pathHtml);
  funcTray(1);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
  MyHide;
  Notifications := TStringList.Create;
  pathTxtNot := sAppPathLib + FolderTxt + TXT_Notify;
  pathTxtExc := sAppPathLib + FolderTxt + TXT_Exclude;
  if FileExists(pathTxtNot) then
    Notifications.LoadFromFile(pathTxtNot);
  ExcludeList := TStringList.Create;
  if FileExists(pathTxtExc) then
    ExcludeList.LoadFromFile(pathTxtExc);
end;

procedure TfrmMainRecieve.WebViewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
  var Cancel: WordBool);
var
  sUrl: string;
  pathTxtNot: string;

begin
  sUrl := ExtractFileName(StringReplace(URL, '/', '\', [rfReplaceAll]));
  if Pos('main.htm', sUrl) = 0 then
    Cancel := true;

  if sUrl = 'main.htm#rm' then   // Delete All Notification
  begin
    pathTxtNot := sAppPathLib + FolderTxt + TXT_Notify;
    WebView.OleObject.Document.getElementById('items').innerHTML := '';
    Notifications.Clear;
    Notifications.SaveToFile(pathTxtNot);
  end;

end;

procedure TfrmMainRecieve.WebViewDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
var
  sUrl: string;

begin
  if pDisp = (ASender as TWebBrowser).Application then
  begin
    sUrl := ExtractFileName(StringReplace(URL, '/', '\', [rfReplaceAll]));
    if sUrl = 'main.htm' then
    begin
      Application.ProcessMessages;
      if WebView.Document <> nil then
      begin
        WebView.OleObject.Document.getElementById('items').innerHTML := Notifications.Text;
        WebView.OleObject.Document.getElementById('title').innerHTML := ID_NOTIFICATIONS;
        WebView.OleObject.Document.getElementById('clear_btn').innerHTML := '<a onclick="document.location=''#rm'';">' + ID_DELETE_ALL + '</a>';
      end;
      Caption := Application.Title;
    end;
  end;
end;

function MyTime: string;
begin
  Result := Copy(TimeToStr(Time), 1, 5);
  if Result[Length(Result)] = ':' then
    Result := Copy(Result, 1, Length(Result) - 1);
end;

procedure TfrmMainRecieve.WMCopyData(var Msg: TWMCopyData);
var
  NotifyMsg, NotifyTitle, Desc, DescSub, BigIcon, SmallIcon, NotifyColor: string;
  strMsg: string;
  pathNot: string;

  F: TextFile;
begin
   WebView.OleObject.Document.Body.Style.OverflowX := 'hidden';
  WebView.OleObject.Document.Body.Style.OverflowY := 'hidden';

  pathNot := sAppPathLib + FolderTxt +TXT_Notify;
  AssignFile(F, pathNot);
  if FileExists(pathNot) then
    Append(F)
  else
    Rewrite(F);
  Inc(ipos);
  strMsg := Copy(PChar(TWMCopyData(Msg).CopyDataStruct.lpData), 1, 7);
  if Copy(PChar(TWMCopyData(Msg).CopyDataStruct.lpData), 1, 7) = 'NOTIFY ' then
  begin

    IconIndex := 1;
    funcTray(3);

    NotifyMsg := PChar(TWMCopyData(Msg).CopyDataStruct.lpData);
    Delete(NotifyMsg, 1, 8);

    NotifyTitle := Copy(NotifyMsg, 1, Pos('"', NotifyMsg) - 1);
    Delete(NotifyMsg, 1, Pos('"', NotifyMsg) + 2);

    if Pos(NotifyTitle, ExcludeList.Text) > 0 then    //if u wanna exclude a Message
      Exit;

    Desc := Copy(NotifyMsg, 1, Pos('"', NotifyMsg) - 1);
    Delete(NotifyMsg, 1, Pos('"', NotifyMsg) + 2);

    DescSub := Copy(NotifyMsg, 1, Pos('"', NotifyMsg) - 1);
    Delete(NotifyMsg, 1, Pos('"', NotifyMsg) + 2);

    BigIcon := Copy(NotifyMsg, 1, Pos('"', NotifyMsg) - 1);
    Delete(NotifyMsg, 1, Pos('"', NotifyMsg) + 2);

    SmallIcon := Copy(NotifyMsg, 1, Pos('"', NotifyMsg) - 1);
    Delete(NotifyMsg, 1, Pos('"', NotifyMsg) + 2);

    NotifyColor := Copy(NotifyMsg, 1, Pos('"', NotifyMsg) - 1);

    if BigIcon = 'null' then
      BigIcon := 'sys.png';
    if SmallIcon <> 'null' then
      BigIcon := SmallIcon;

    if (Desc <> 'null') and (DescSub <> 'null') then
      Desc := Desc + ' - ' + DescSub;
    if (Desc = 'null') and (DescSub <> 'null') then
      Desc := DescSub;
    if (Desc = 'null') and (DescSub = 'null') then
      Desc := '';

    if NotifyTitle = 'null' then
      NotifyTitle := ID_UNKNOWN_APP;

    if NotifyColor <> 'null' then
    begin
      case NotifyColor[1] of
        '0':
          NotifyColor := '#666666';
        '1':
          NotifyColor := '#235d82';
        '2':
          NotifyColor := '#018399';
        '3':
          NotifyColor := '#008a00';
        '4':
          NotifyColor := '#5133ab';
        '5':
          NotifyColor := '#8b0094';
        '6':
          NotifyColor := '#ac193d';
        '7':
          NotifyColor := '#222222';
      end;
    end
    else
      NotifyColor := 'gray';
    WebView.OleObject.Document.getElementById('items').innerHTML := '<div id="item"><div id="icon" style="background-color:' + NotifyColor + ';"><img src="' +
      sAppPathLib + FolderPng + BigIcon + '" /></div><div id="context"><div id="title">' + NotifyTitle +
      '</div><div id="clear"></div><div id="description">' + Desc + ' </div></div><div id="time">' + TimeToStr(now) + '<br>' + DateToStr(now) + '</div></div>';
    Notifications.Text := WebView.OleObject.Document.getElementById('items').innerHTML;

    Writeln(F, Notifications.Text);
    CloseFile(F);
    // Notifications.SaveToFile(pathNot);
  end;
  Msg.Result := integer(true);
  Application.Terminate;

  ShellExecute(Application.Handle, nil, PChar(Application.ExeName), 'NOTyMSG', nil, SW_SHOWNORMAL);
  ShowWindow(Application.Handle, SW_SHOWNOACTIVATE); // Damit immer das form wird gezeigt ist
  // MyShow;

  // IconIndex := 0;
  // funcTray(3);
end;

procedure TfrmMainRecieve.WMActivate(var Msg: TMessage);
begin
  if Msg.WParam = WA_INACTIVE then
    MyHide;
  inherited;
end;

procedure TfrmMainRecieve.FormDestroy(Sender: TObject);
  procedure DeleteFileNotification(const FileToClear: string);
  var
    F: TextFile;
  begin
    AssignFile(F, FileToClear);
    Rewrite(F);
    CloseFile(F);
  end;

var
  Ini: TIniFile;
  pathCfg: string;
  pathNot: string;
begin

  pathNot := sAppPathLib + FolderTxt +TXT_Notify;
  // DeleteFileNotification(pathNot); //
  pathCfg := sAppPathLib+ FolderIni + INI_Cf;
  Ini := TIniFile.Create(pathCfg);
  Ini.WriteInteger('Main', 'NewMessages', IconIndex);
  Ini.Free;
  Notifications.Free;
  ExcludeList.Free;
  funcTray(2);
  IconFull.Free;
end;

procedure TfrmMainRecieve.DefaultHandler(var Message);
begin
  if TMessage(Message).Msg = WM_TaskBarCreated then
    funcTray(1);
  inherited;
end;

procedure TfrmMainRecieve.AboutApplicationExecute(Sender: TObject);
begin
Application.MessageBox(PChar(Application.Title + ' 0.0.1' + #13#10 + ID_LAST_UPDATE + '27.03.2019' + #13#10 + 'https://github.com/walwalwalides' + #13#10 +
    'walwalwalides@gmail.com'), PChar(AboutBtn.Caption), MB_ICONINFORMATION);
end;

procedure TfrmMainRecieve.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainRecieve.WMNCHITTEST(var Msg: TMessage);
begin
  Msg.Result := HTCLIENT;
end;

end.
