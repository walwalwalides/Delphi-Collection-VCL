{ ============================================
  Software Name : 	CountDown
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit UCountDownTimer4;

interface

uses Windows, Sysutils, controls, forms, classes, graphics, extctrls, mmsystem;

type
  TrunMode4 = (Countup, CountDown);

  TCountDown4 = class(Tpanel)
  private
    Fstarttime: TDateTime;
    Fcurrenttime: TDateTime;

    FRunMode: TrunMode4;
    FOnExpired: TNotifyevent;
    FOnTimerPop: TNotifyevent;
    fmtstr: string;
    tmrCD4: TTimer;
    Timerset: boolean;
    StartTOD: TDateTime;


    Image1: TImage;
    Panel1: Tpanel;
    center: TPoint;
    shandlen, mhandlen, hhandlen: integer;
    lastsc, lastmn, lasthr: TPoint;
    textheight: integer;

    function GetRunning: boolean;
    procedure SetStartTime(value: TDateTime);
    procedure SetfontSize(p: Tpanel; h: integer);
    procedure SetRunMode(value: TrunMode4);
    procedure updatetimer;
    procedure timerpop(sender: TObject);

  published
    property starttime: TDateTime read Fstarttime write SetStartTime;
    property currenttime: TDateTime read Fcurrenttime;
    property running: boolean read GetRunning;
    property runmode: TrunMode4 Read FRunMode write SetRunMode;
    property onexpires: TNotifyevent read FOnExpired write FOnExpired;
    property onTimerPop: TNotifyevent read FOnTimerPop write FOnTimerPop;

  public
    constructor Create(CustumPanel: Tpanel); reintroduce;
    destructor Destroy; override;
    procedure SetCountDownInterval(h, M, S: integer);
    procedure startCountDown;
    procedure stopCountDown;
  end;

implementation



constructor TCountDown4.Create(CustumPanel: Tpanel);
var
  Size: longword;
begin
  inherited Create(CustumPanel.owner);
  parent := CustumPanel.parent;
  boundsrect := CustumPanel.boundsrect;
  brush.assign(CustumPanel.brush);

  color := CustumPanel.color;
  borderstyle := CustumPanel.borderstyle;
  borderwidth := CustumPanel.borderwidth;
  bevelouter := CustumPanel.bevelouter;
  bevelinner := CustumPanel.bevelinner;

  if Assigned(CustumPanel.onexit) then
    FOnExpired := CustumPanel.onexit;

  tmrCD4 := TTimer.Create(self);
  tmrCD4.ontimer := timerpop;
  tmrCD4.enabled := false;
  tmrCD4.interval := 100;


  Fstarttime := 1 / 86400;
  Fcurrenttime := Fstarttime;
  FRunMode := CountDown;
  Timerset := false;
end;

destructor TCountDown4.Destroy;
begin
  if Assigned(Panel1) then
    Panel1.free;

  tmrCD4.free;
  // clicksound.free;
  inherited;
end;


function TCountDown4.GetRunning: boolean;
begin
  Result := tmrCD4.enabled;
end;




procedure TCountDown4.SetfontSize(p: Tpanel; h: integer);
var
  str: string;
  tempcanvas: TCanvas;
  notused: HWnd;
begin
  if h = 0 then { no hour value needed }
  begin
    str := '00:00';
    fmtstr := 's';
  end
  else
  begin { leave room for hours }
    str := '00:00:00';
    fmtstr := 'hh:nn:ss';
  end;

  tempcanvas := TCanvas.Create;
  tempcanvas.Handle := GetDeviceContext(notused);
  tempcanvas.font.assign(font);
  with tempcanvas do
  begin
    font.Size := 6;
    font.style := [fsbold];



    while (textwidth(str) < width) and (textheight(str) < height) and (font.Size < 100) do
      font.Size := font.Size + 2;
    font.Size := font.Size - 2;
  end;
  font.assign(tempcanvas.font);
  tempcanvas.free;
end;


procedure TCountDown4.SetStartTime(value: TDateTime);
var
  h, M, S, MS: word;
begin
  decodetime(value, h, M, S, MS);
  SetCountDownInterval(h, M, S);
end;


procedure TCountDown4.SetCountDownInterval(h, M, S: integer);
begin
  Fstarttime := Encodetime(h, M, S, 0);
  Fcurrenttime := Fstarttime;
  SetfontSize(self, h);
  updatetimer;
  Timerset := true;
end;

procedure TCountDown4.SetRunMode(value: TrunMode4);
begin
  FRunMode := value;
end;


procedure TCountDown4.startCountdown;
begin

  if not Timerset then
    SetCountDownInterval(0, 0, 0);
  StartTOD := Now;
  tmrCD4.enabled := true;
end;

procedure TCountDown4.stopCountdown;
begin
  font.Color := clBlue;
  Timerset := false;
  tmrCD4.enabled := false;
end;

procedure TCountDown4.updatetimer;
var
  S, M, h, MS: word;
  stime, mtime, htime: extended;
  sangle, mangle, hangle: extended;
begin
  If Assigned(FOnTimerPop) then
    FOnTimerPop(self); { Take onTimerPop exit if defined }
  caption := formatdatetime(fmtstr, currenttime);
  application.processmessages;
end;

procedure TCountDown4.timerpop(sender: TObject);

var
  delta: TDateTime;
begin
  delta := Now - StartTOD;

  if FRunMode = CountDown then
  begin
    Fcurrenttime := Fstarttime - delta;
    if Fcurrenttime >= 0.1 / 86400 then
    begin
      Fcurrenttime := (Fcurrenttime - 0.0001 / 86400)*75; { Set variation time tmrCD4 }
    end;
    updatetimer;
    if Fcurrenttime <= (0.5 / 86400)*2 then
    begin
      tmrCD4.enabled := false;
      Timerset := false;
      If Assigned(FOnExpired) then
        FOnExpired(self);
    end;
  end
  else
  begin
    Fcurrenttime := Fstarttime + delta;
    Fcurrenttime := Fcurrenttime + 1 / 86400;
    updatetimer;
    If Assigned(FOnTimerPop) then
      FOnTimerPop(self);
  end;

  application.processmessages;
end;

end.
