{ ============================================
  Software Name : 	CountDown
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ExtCtrls, UCountDownTimer1, UCountDownTimer2, UCountDownTimer3, UCountDownTimer4, Vcl.Samples.Spin, System.Actions, Vcl.ActnList,
  Vcl.Menus, System.ImageList, Vcl.ImgList, Vcl.Buttons, System.IniFiles;

const
  IniFolder = 'Ini\';
  Inifilename = 'CountDown.ini';

type
  TWMMYMessage = record
    Msg: Cardinal; // ( first is the message ID )
    Handle: HWND; // ( this is the wParam, Handle of sender)
    Info: Longint; // ( this is lParam, pointer to our data)
    Result: Longint;
  end;

type
  TfrmMain = class(TForm)
    stResult: TStaticText;
    stCounter: TStaticText;
    PnlMain: TPanel;
    Pnl1: TPanel;
    pnl2: TPanel;
    Pnl3: TPanel;
    SPedtMinus: TSpinEdit;
    edtInfo: TEdit;
    MMMAin: TMainMenu;
    File1: TMenuItem;
    OpenFiles1: TMenuItem;
    N1: TMenuItem;
    Edit1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    View1: TMenuItem;
    Refresh1: TMenuItem;
    Option1: TMenuItem;
    actOption1: TMenuItem;
    A2: TMenuItem;
    actAbout1: TMenuItem;
    aclstMain: TActionList;
    actShowInExplorer: TAction;
    actExit: TAction;
    actRefresh: TAction;
    actOption: TAction;
    actAbout: TAction;
    Exit2: TMenuItem;
    ilMain: TImageList;
    bvlFeed: TBevel;
    bvlHead: TBevel;
    btnRunThread: TBitBtn;
    btnstart: TBitBtn;
    btnMinus: TBitBtn;
    Button2: TBitBtn;
    btnEvent1: TBitBtn;
    btnEvent2: TBitBtn;
    btnEvent3: TBitBtn;
    lblMinusValue: TLabel;
    procedure btnRunThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEvent1Click(Sender: TObject);
    procedure btnEvent2Click(Sender: TObject);
    procedure btnEvent3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnstartClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    b0: Boolean;
    b2: Boolean;
    b1: Boolean;
    { Private declarations }
    procedure EnableControlls(Enable: Boolean);
    procedure SetTimer(Sender: TObject);
    procedure StartCountDown(Sender: TObject);
    procedure StopCountDown;
    procedure SetTimer2(Sender: TObject);
    procedure StartTimer2(Sender: TObject);
    procedure StopTimer2;
    procedure SetTimer3(Sender: TObject);
    procedure StartTimer3(Sender: TObject);
    procedure StopTimer3;
    procedure SetTimer4(Sender: TObject);
    procedure StartTimer4(Sender: TObject);
    procedure StopTimer4;

  public
    { Public declarations }
    cTimerA, cTimerD: TCountDown;
    cTimerD2: TCountDown2;
    cTimerD3: TCountDown3;
    cTimerD4: TCountDown4;
    procedure DefaultHandler(var Message); override;
    procedure WMMYMessage(var Msg: TWMMYMessage);
  end;

type
  TSummeSec = class

    fsummeSec: word;

    constructor Create(fsummeSec: integer);
    function summesec(var summesecond: word): word;

  end;

var
  frmMain: TfrmMain;
  kmax: integer;
  curdir: string;
  Inifilepath: string;
  SecSumme: TSummeSec;
  // Array mit Handle für Ereignisse
  EventArray: array [0 .. 2] of THandle;

  // Thread-Parameter-Record
type
  TThreadParams = record
    bWaitForAll: Boolean;
    stResult: TStaticText;
    stCounter: TStaticText;
  end;

  PThreadParams = ^TThreadParams;
function ShowCountDown: TForm; stdcall; external 'CountDownDLL.dll' name 'SHOWCOUNTDOWN';
procedure CloseCountDown; stdcall; external 'CountDownDLL.dll' name 'CLOSECOUNTDOWN';
procedure SHOWCHRONO; stdcall; external 'CountDownDLL.dll' name 'SHOWCHRONO';
procedure STARTCHRONO; stdcall; external 'CountDownDLL.dll' name 'STARTCHRONO';

resourcestring
  rsEventSignaled = 'Event % d was signaled';
  rsAllEventsSignaled = 'You have %d Second ';
  rsTimeOut = 'You have %d Second ';
  rsWaitFailed = 'Error by Call "WaitForMultipleObject"';

const
  Itemp = 10; // Main Timer interval
  Itemp2 = 59; // First,Second,Third Timer interval

var
  mytimer2: TCountDown2;
  WM_OURMESSAGE: DWORD;

implementation

uses
  uAbout;

{$R *.dfm}

{ Create a gardient color form }
procedure FillGradientRect(Canvas: TCanvas; Recty: TRect; fbcolor, fecolor: TColor; fcolors: integer);
var
  i, j, h, w, fcolor: integer;
  R, G, B: Longword;
  beginRGBvalue, RGBdifference: array [0 .. 2] of Longword;
begin
  beginRGBvalue[0] := GetRvalue(colortoRGB(fbcolor));
  beginRGBvalue[1] := GetGvalue(colortoRGB(fbcolor));
  beginRGBvalue[2] := GetBvalue(colortoRGB(fbcolor));
  RGBdifference[0] := GetRvalue(colortoRGB(fecolor)) - beginRGBvalue[0];
  RGBdifference[1] := GetGvalue(colortoRGB(fecolor)) - beginRGBvalue[1];
  RGBdifference[2] := GetBvalue(colortoRGB(fecolor)) - beginRGBvalue[2];
  Canvas.pen.Style := pssolid;
  Canvas.pen.mode := pmcopy;
  j := 0;
  h := Recty.Bottom - Recty.Top;
  w := Recty.Right - Recty.Left;
  for i := fcolors downto 0 do
  begin
    Recty.Left := muldiv(i - 1, w, fcolors);
    Recty.Right := muldiv(i, w, fcolors);
    if (fcolors >= 1) then
    begin
      R := beginRGBvalue[0] + muldiv(j, RGBdifference[0], fcolors);
      G := beginRGBvalue[1] + muldiv(j, RGBdifference[1], fcolors);
      B := beginRGBvalue[2] + muldiv(j, RGBdifference[2], fcolors);
    end;
    Canvas.Brush.Color := RGB(R, G, B);
    patBlt(Canvas.Handle, Recty.Left, Recty.Top, Recty.Right - Recty.Left, h, patcopy);
    Inc(j);
  end;
end;

function Thread(p: Pointer): integer;
var
  bWaitForAll: Boolean;
  stResult, stCounter: TStaticText;
  wfmo: DWORD;
  s: string;
  dw: integer;
  Sender: TObject;

begin

  // Pass thread parameters to local variables
  bWaitForAll := PThreadParams(p)^.bWaitForAll;
  stResult := PThreadParams(p)^.stResult;
  stCounter := PThreadParams(p)^.stCounter;
  // Allow thread to wait for events
  wfmo := WaitForMultipleObjects(length(EventArray), @EventArray, bWaitForAll, Itemp * 1000);
  if bWaitForAll then
  begin
    kmax := SecSumme.fsummeSec;
    s := format(rsAllEventsSignaled, [round((SecSumme.fsummeSec))]);
    case wfmo of
      WAIT_TIMEOUT:
        begin
          s := format(rsAllEventsSignaled, [SecSumme.fsummeSec]);

          if frmMain.b0 = false then
          begin

            frmMain.StopTimer2;
            frmMain.cTimerD2.SetCountDownInterval(0, 0, 0);
          end;
          // else
          // FrmMain.btnStartGame.Enabled:=true;
          if frmMain.b1 = false then
          begin

            frmMain.StopTimer3;
            frmMain.cTimerD3.SetCountDownInterval(0, 0, 0);
          end;
          // else
          // FrmMain.btnStartGame.Enabled:=true;
          if frmMain.b2 = false then
          begin

            frmMain.StopTimer4;
            frmMain.cTimerD4.SetCountDownInterval(0, 0, 0);
          end;
          // else
          // FrmMain.btnStartGame.Enabled:=true;

        end;

      WAIT_FAILED:
        begin
          s := rsTimeOut;
          frmMain.btnstart.Enabled := false;
        end;
    end;
  end
  else
  begin
    case wfmo of
      WAIT_OBJECT_0 + 0:
        begin
          s := format(rsEventSignaled, [WAIT_OBJECT_0 + 1]);
          frmMain.b0 := true;

        end;
      WAIT_OBJECT_0 + 1:
        begin
          s := format(rsEventSignaled, [WAIT_OBJECT_0 + 2]);
          frmMain.b1 := true;

        end;
      WAIT_OBJECT_0 + 2:
        begin
          s := format(rsEventSignaled, [WAIT_OBJECT_0 + 3]);
          frmMain.b2 := true;

        end;
      WAIT_TIMEOUT:
        s := rsTimeOut;
      WAIT_FAILED:
        s := rsTimeOut;
    end;
  end;
  if s = rsAllEventsSignaled then
    frmMain.StopCountDown;
  frmMain.cTimerD.StopCountDown;
  SHOWCHRONO;
  stResult.Caption := s;
  frmMain.EnableControlls(false);
  // Speicher wieder freigeben
  FreeMem(p, sizeof(TThreadParams));
  // ShowMessage(inttostr(SecSumme.fsummeSec));

  SendMessage(HWND_BROADCAST, WM_OURMESSAGE, 0, SecSumme.fsummeSec); // send value to dll

  SecSumme.Free;
  Result := 0;

end;

procedure TfrmMain.EnableControlls(Enable: Boolean);
begin
  btnEvent1.Enabled := Enable;
  btnEvent2.Enabled := Enable;
  btnEvent3.Enabled := Enable;
  btnstart.Enabled := NOT Enable;
  btnRunThread.Enabled := not Enable;
end;

procedure TfrmMain.btnRunThreadClick(Sender: TObject);
var
  ThreadParams: PThreadParams;
  ThreadID: Cardinal;
  hThread: THandle;
begin
  CloseCountDown;
  b0 := false;
  b1 := false;
  b2 := false;

  SecSumme := TSummeSec.Create(0);
  frmMain.SetTimer(Sender);
  frmMain.StartCountDown(Sender);

  frmMain.SetTimer2(Sender);
  frmMain.StartTimer2(Sender);

  frmMain.SetTimer3(Sender);
  frmMain.StartTimer3(Sender);

  frmMain.SetTimer4(Sender);
  frmMain.StartTimer4(Sender);

  stResult.Caption := '';
  // Thread-Parameter
  GetMem(ThreadParams, sizeof(TThreadParams));
  ThreadParams.bWaitForAll := true; // set true if the Thread hav to wait for all event
  ThreadParams.stResult := stResult;
  ThreadParams.stCounter := stCounter;
  // Thread starten
  hThread := BeginThread(nil, 0, @Thread, ThreadParams, 0, ThreadID);
  ShowCountDown.show;
  if hThread <> 0 then
  begin

    // Handle schließen und Kontrollelemente aktivieren/deaktivieren
    CloseHandle(hThread);
    EnableControlls(true);

  end;

end;

procedure TfrmMain.btnMinusClick(Sender: TObject);
begin
  // Using BOADCAST

  SendMessage(HWND_BROADCAST, WM_OURMESSAGE, 0, -SPedtMinus.Value);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  ShowMessage('Game is started');
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  CloseCountDown;
end;

procedure TfrmMain.btnstartClick(Sender: TObject);
var
  OldHandler: TNotifyEvent;

begin

  if (SecSumme.fsummeSec <= 0) then
    kmax := 0;
  SPedtMinus.MaxValue := kmax;
  OldHandler := (Sender as TBitBtn).OnClick;
  (Sender as TBitBtn).OnClick := nil;
  try
    STARTCHRONO;
  finally
    (Sender as TBitBtn).OnClick := OldHandler;
  end;

end;

procedure TfrmMain.DefaultHandler(var Message);
var
  ee: TWMMYMessage;
begin
  with TMessage(Message) do
  begin
    if (Msg = WM_OURMESSAGE) then
    begin
      ee.Msg := Msg;

      ee.Handle := wParam;
      ee.Info := LParam;
      // Checking if this message is not from us
      if ee.Handle <> Handle then
        WMMYMessage(ee);
    end
    else
      inherited DefaultHandler(Message);
  end;

end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  cTimerD := TCountDown.Create(PnlMain);
  cTimerD2 := TCountDown2.Create(Pnl1);
  cTimerD3 := TCountDown3.Create(pnl2);
  cTimerD4 := TCountDown4.Create(Pnl3);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  k: integer;
  Fichini: TInifile;

begin
  SPedtMinus.MinValue := 0;
  SPedtMinus.MaxValue := 0;
  position := poMainFormCenter;
  // Ereignisse erzeuge mit automatischer Zurücksetzung (bManualReset = False)
  EventArray[0] := CreateEvent(nil, false, false, nil);
  EventArray[1] := CreateEvent(nil, false, false, nil);
  EventArray[2] := CreateEvent(nil, false, false, nil);
  // mytimer2:=TCountDown2.createstatustime(strtoint(pnl1.caption));
  // Create IniFile
  curdir := ExtractFilePath(Application.exename);
  if not DirectoryExists(curdir + IniFolder) then
    ForceDirectories(curdir + IniFolder);
  Inifilepath := curdir + IniFolder + Inifilename;
  // ------------------------------------------------------------  //
  Fichini := TInifile.Create(Inifilepath);
  WITH Fichini DO
  BEGIN

    Free;
  END;

end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  FillGradientRect(frmMain.Canvas, rect(0, 0, Width, Height), clgreen, $00000, $00FF);
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  F: TfrmAbout;
begin

  if not Assigned(F) then
    Application.CreateForm(TfrmAbout, F);
  F.position := poMainFormCenter;
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close
end;

procedure TfrmMain.btnEvent1Click(Sender: TObject);
var
  h, m, s2, ms: word;
begin
  btnEvent1.Enabled := false;
  frmMain.b0 := true;
  // Ereignis auslösen

  SetEvent(EventArray[0]);
  StopTimer2;
  decodetime(cTimerD2.currenttime, h, m, s2, ms);

  // ShowMessage(IntToStr(s2));
  SecSumme.fsummeSec := SecSumme.summesec(s2);

end;

procedure TfrmMain.btnEvent2Click(Sender: TObject);
var
  h, m, s3, ms: word;
begin
  btnEvent2.Enabled := false;
  frmMain.b1 := true;
  // Ereignis auslösen
  SetEvent(EventArray[1]);
  StopTimer3;
  decodetime(cTimerD3.currenttime, h, m, s3, ms);

  // Showmessage(inttostr(s3));
  SecSumme.fsummeSec := SecSumme.summesec(s3);

end;

procedure TfrmMain.btnEvent3Click(Sender: TObject);
var
  h, m, s4, ms: word;
begin
  btnEvent3.Enabled := false;
  // Delete Event
  frmMain.b2 := true;
  SetEvent(EventArray[2]);
  StopTimer4;
  decodetime(cTimerD4.currenttime, h, m, s4, ms);

  // ShowMessage(inttostr(s4));
  SecSumme.fsummeSec := SecSumme.summesec(s4);

end;

procedure TfrmMain.SetTimer(Sender: TObject);

begin
  if Sender = btnRunThread then
    with cTimerD do
    begin
      Nosound := false;
      SetCountDownInterval(0, 0, Itemp); // set Main event interval
    end;

end;

procedure TfrmMain.SetTimer2(Sender: TObject);
begin
  if Sender = btnRunThread then
    with cTimerD2 do
    begin
      SetCountDownInterval(0, 0, Itemp2); // set First event interval
    end;

end;

procedure TfrmMain.SetTimer3(Sender: TObject);
begin
  if Sender = btnRunThread then
    with cTimerD3 do
    begin
      SetCountDownInterval(0, 0, Itemp2); // set Second event interval
    end;
end;

procedure TfrmMain.SetTimer4(Sender: TObject);
begin
  if Sender = btnRunThread then
    with cTimerD4 do
    begin
      SetCountDownInterval(0, 0, Itemp2); // set third event interval
    end;

end;

procedure TfrmMain.StartCountDown(Sender: TObject);
begin

  if Sender = btnRunThread then

    with cTimerD do
    begin
      runmode := TRunMode(1);
      OnTimerPop := nil;
      StartCountDown;
    end;

end;

procedure TfrmMain.StartTimer2(Sender: TObject);
begin
  if Sender = btnRunThread then

    with cTimerD2 do
    begin
      runmode := TRunMode2(1);
      OnTimerPop := nil;
      StartCountDown;
    end;

end;

procedure TfrmMain.StartTimer3(Sender: TObject);
begin
  if Sender = btnRunThread then

    with cTimerD3 do
    begin
      runmode := TRunMode3(1);
      OnTimerPop := nil;
      StartCountDown;
    end;
end;

procedure TfrmMain.StartTimer4(Sender: TObject);
begin
  if Sender = btnRunThread then

    with cTimerD4 do
    begin
      runmode := TRunMode4(1);
      OnTimerPop := nil;
      StartCountDown;
    end;

end;

procedure TfrmMain.StopCountDown;

begin

  // If Sender = btnRunThread then
  cTimerD.StopCountDown;
  // showmessage(mytimer2.Fstatustime);
end;

procedure TfrmMain.StopTimer2;
begin

  cTimerD2.StopCountDown;
end;

procedure TfrmMain.StopTimer3;
begin
  cTimerD3.StopCountDown;
end;

procedure TfrmMain.StopTimer4;
begin
  cTimerD4.StopCountDown;
end;

procedure TfrmMain.WMMYMessage(var Msg: TWMMYMessage);
begin
  // MessageBox(0, '', inttostr(Msg.Info), MB_ICONWARNING or MB_OK);
  if (Msg.Info = 1) then
  begin
    frmMain.StopCountDown;
    frmMain.cTimerD.StopCountDown;

  end;

  if (Msg.Info = 3) then
  begin
//    CloseCountDown;
  end;

end;

{ TSummeSec }

constructor TSummeSec.Create(fsummeSec: integer);
begin
  inherited Create;
  self.fsummeSec := fsummeSec;
end;

function TSummeSec.summesec(var summesecond: word): word;
begin
  Result := fsummeSec + summesecond;

end;

initialization

WM_OURMESSAGE := RegisterWindowMessage('Our broadcast message');

end.
