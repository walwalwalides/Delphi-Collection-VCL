{ ============================================
  Software Name : 	MySQL_StoreProc
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, Vcl.Samples.Spin,
  FireDAC.Comp.Script, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.Menus;

type
  TfrmMain = class(TForm)
    GrBoxControle: TGroupBox;
    SPedtCount: TSpinEdit;
    lblID: TLabel;
    pnlHead: TPanel;
    bitbtnDelScript: TBitBtn;
    bitbtnCrScript: TBitBtn;
    btnBuildTable: TBitBtn;
    btnDisplayName: TBitBtn;
    GrBoxConnection: TGroupBox;
    lblConfirmExit: TLabel;
    lblDataBase: TLabel;
    lblHideAfter: TLabel;
    lblAutoHide: TLabel;
    ToglSwitchExit: TToggleSwitch;
    ToglSwitchHide: TToggleSwitch;
    edtHideAfter: TEdit;
    ComboBoxEx1: TComboBoxEx;
    lbledtHost: TLabeledEdit;
    lbledtPort: TLabeledEdit;
    BitBtnDisplay: TBitBtn;
    BitBtnSaveConfig: TBitBtn;
    TrayIcon1: TTrayIcon;
    tmrAutoHide: TTimer;
    popMenuTrayIcon: TPopupMenu;
    OpenPSync1: TMenuItem;
    PSync1: TMenuItem;
    BitBtnTestConnec: TBitBtn;
    procedure btnDisplayNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bitbtnCrScriptClick(Sender: TObject);
    procedure bitbtnDelScriptClick(Sender: TObject);
    procedure btnBuildTableClick(Sender: TObject);
    procedure BitBtnSaveConfigClick(Sender: TObject);
    procedure BitBtnDisplayClick(Sender: TObject);
    procedure tmrAutoHideTimer(Sender: TObject);
    procedure PSync1Click(Sender: TObject);
    procedure OpenPSync1Click(Sender: TObject);
    procedure BitBtnTestConnecClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure Tray(ActInd: Integer);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  TTypeWndMsg = (msgText, msgWaring, msgWindow, msgError);

var
  frmMain: TfrmMain;
  BoolstatDel: Boolean = False;
  IconIndex: byte;
  IconFull: TIcon;

implementation

uses Module, Uscript, URegConfig, uConfig, System.Threading, Winapi.ShellAPI;

{$R *.dfm}

procedure SendStatusMsg(StrMsg: String; TypeWnd: TTypeWndMsg = msgText; const ADelay: Word = 5000);
begin

  case TypeWnd of
    msgText:
      begin
        TTask.Run(
          procedure
          begin
            TThread.Synchronize(nil,
              procedure
              begin
                frmMain.Caption := StrMsg;
              end);
            Sleep(ADelay);
            TThread.Synchronize(nil,
              procedure
              begin
                frmMain.Caption := '';
              end);
          end);
      end;
    msgWaring:
      ;
    msgWindow:
      ShowMessage(StrMsg);
    msgError:
      TTask.Run(
        procedure
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              frmMain.Caption := StrMsg;
            end);
        end);
  end;

end;

procedure TfrmMain.btnDisplayNameClick(Sender: TObject);
begin // user getName Function

  DMModule.ProcGetName.Params[0].Value := SPedtCount.Value;

  try
    ShowMessage(DMModule.ProcGetName.ExecFunc);

  except
    if (BoolstatDel = True) then
      MessageDlg('func. "GetName " was deleted', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMain.btnBuildTableClick(Sender: TObject);
begin
  BuildTable;
end;

procedure TfrmMain.bitbtnDelScriptClick(Sender: TObject);
begin
  try
    DeleteScript;
  finally
    BoolstatDel := True;
  end;
end;

procedure TfrmMain.BitBtnDisplayClick(Sender: TObject);
var
  RegConf: TRegConfig;
  ValParam: TRegParamValue;

begin
  PAppConf.LoadFromFile;
  lbledtHost.Text := PAppConf.Srvc.HostName;
  lbledtPort.Text := PAppConf.Srvc.Port.ToString;
  ComboBoxEx1.Clear;
  ComboBoxEx1.Items.Add(PAppConf.MySQL.DataBase);
  ComboBoxEx1.ItemIndex := 0;

  RegConf := TRegConfig.Create;
  RegConf.ReadParams;

  if RegConf.Params.TryGetValue('ConfirmExit', ValParam) then
  begin
    if ValParam.Value = '1' then
      ToglSwitchExit.State := tssOn
    else
      ToglSwitchExit.State := tssOff;
  end;

  if RegConf.Params.TryGetValue('HideAppAfter', ValParam) then
  begin
    edtHideAfter.Text := ValParam.Value;
    tmrAutoHide.Interval := StrToInt(edtHideAfter.Text) * 1000;
  end;

  if RegConf.Params.TryGetValue('AutoHideApp', ValParam) then
  begin
    if ValParam.Value = '1' then
    Begin
      ToglSwitchHide.State := tssOn;
      tmrAutoHide.Enabled := True;
    end
    else
    begin
      ToglSwitchHide.State := tssOff;
      tmrAutoHide.Enabled := False;
    end;

  end;

  RegConf.Free;

  // CardPanel1.Cards[1].Show;
end;

procedure TfrmMain.BitBtnSaveConfigClick(Sender: TObject);
var
  SrvcConf: TSrvcConf;
  MySQLConf: TMySQLConf;
  RegConf: TRegConfig;
  RegParamVal, RegParamValInt: TRegParamValue;
begin
  RegConf := TRegConfig.Create;
  // ................................................. //
  RegParamVal.ValueType := IntType;
  RegParamVal.Value := edtHideAfter.Text;
  RegConf.UpdateParam('HideAppAfter', RegParamVal);
  tmrAutoHide.Interval := StrToInt(edtHideAfter.Text) * 1000;
  // ................................................. //
  RegParamVal.ValueType := BoolType;
  if (ToglSwitchExit.State = tssOn) then
    RegParamVal.Value := '1'
  else
    RegParamVal.Value := '0';
  RegConf.UpdateParam('ConfirmExit', RegParamVal);
  // ................................................. //
  RegParamVal.ValueType := BoolType;
  if (ToglSwitchHide.State = tssOn) then
  begin
    RegParamVal.Value := '1';
    tmrAutoHide.Enabled := True;
  end
  else
  Begin
    RegParamVal.Value := '0';
    tmrAutoHide.Enabled := False;
  end;
  RegConf.UpdateParam('AutoHideApp', RegParamVal);

  // ................................................. //
  SrvcConf.HostName := lbledtHost.Text;
  SrvcConf.Port := StrToInt(lbledtPort.Text);

  MySQLConf.DataBase := ComboBoxEx1.Text;

  PAppConf.Srvc := SrvcConf;
  PAppConf.MySQL := MySQLConf;
  PAppConf.Save;
  RegConf.Free;

  SendStatusMsg('Change Saved');
end;

procedure TfrmMain.BitBtnTestConnecClick(Sender: TObject);
begin
  CreateTableLog;
  try
     DMModule.DBMySQL.connect;
     DMModule.DBMySQL.DisConnect;
  finally

  end;

end;

procedure TfrmMain.bitbtnCrScriptClick(Sender: TObject);
begin
  try
    CreateScript;
  finally
    BoolstatDel := False;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  RegConf: TRegConfig;
begin
  SPedtCount.EditorEnabled := False;
  frmMain.Position := poMainFormCenter;

  RegConf := TRegConfig.Create;
  RegConf.AppPath := ExtractFilePath(Application.ExeName);
  RegConf.AppFileCfg := FILECFG;
  RegConf.ReadParams;
  RegConf.Free;

end;
 procedure TfrmMain.Tray(ActInd: Integer);
var
  nim: TNotifyIconData;
begin

  with nim do
  begin
    cbSize := System.SizeOf(nim);
    Wnd := frmMain.Handle;
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

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  IconIndex:=0;
  Tray(2);
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  iMaxValue: Integer;
begin

  DMModule.ProcCounter.Params[0].Value := iMaxValue;
  iMaxValue := DMModule.ProcCounter.ExecFunc;
  SPedtCount.MinValue := 1;
  SPedtCount.MaxValue := iMaxValue;
  BitBtnDisplayClick(nil);

end;

procedure TfrmMain.OpenPSync1Click(Sender: TObject);
begin
  if not frmMain.Visible then
    frmMain.Visible := True;

end;

procedure TfrmMain.PSync1Click(Sender: TObject);
begin
  Close
end;

procedure TfrmMain.tmrAutoHideTimer(Sender: TObject);
begin
  if (frmMain.Visible) then
  begin
    TrayIcon1.BalloonTitle := 'MySQl_StoreProc';
    TrayIcon1.BalloonHint := 'Application as TrayIcon';
    TrayIcon1.BalloonFlags := bfInfo;
    TrayIcon1.ShowBalloonHint;
    frmMain.Visible := False;
  end;

  tmrAutoHide.Enabled := False;

end;

end.
