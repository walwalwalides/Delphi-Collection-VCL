{ ============================================
  Software Name : 	CountDown
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit UCountDownTimer2;

interface

uses Windows, Sysutils, controls, forms, classes, graphics, extctrls, mmsystem, dialogs;

type
  TrunMode2 = (Countup, CountDown);

  TCountDown2 = class(Tpanel)
  private
    Fstarttime: TDateTime;
    Fcurrenttime: TDateTime;
    FRunMode: TrunMode2;
    FOnExpired: TNotifyevent;
    FOnTimerPop: TNotifyevent;
    fmtstr: string;
    tmrCD2: TTimer;
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
    procedure SetRunMode(value: TrunMode2);
    procedure updatetimer;
    procedure timerpop(sender: TObject);

  published
    property starttime: TDateTime read Fstarttime write SetStartTime;
    property currenttime: TDateTime read Fcurrenttime;
    property running: boolean read GetRunning;
    property runmode: TrunMode2 Read FRunMode write SetRunMode;
    property onexpires: TNotifyevent read FOnExpired write FOnExpired;
    property onTimerPop: TNotifyevent read FOnTimerPop write FOnTimerPop;

  public

    constructor Create(CustumPanel: Tpanel); reintroduce;
    destructor Destroy; override;
    procedure SetCountDownInterval(h, M, S: integer);
    procedure startCountDown;
    procedure stopCountDown;

  end;

type
  TStatusTime = class
  private

    function getstatustime: string;
    procedure setstatustime(Statustime: string);
  public

    Fstatustime: string;
    test: TStatusTime;
    constructor CreateStatustime(Fstatustime: string);
  published
    property Statustime: string read getstatustime write setstatustime;
  end;

implementation




constructor TCountDown2.Create(CustumPanel: Tpanel);
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

  tmrCD2 := TTimer.Create(self);
  tmrCD2.ontimer := timerpop;
  tmrCD2.enabled := false;
  tmrCD2.interval := 100;

  Fstarttime := (1 / 86400);
  Fcurrenttime := Fstarttime;
  FRunMode := CountDown;
  Timerset := false;
end;

destructor TCountDown2.Destroy;
begin
  if Assigned(Panel1) then
    Panel1.free;
  tmrCD2.free;
  inherited;
end;


function TCountDown2.GetRunning: boolean;
begin
  Result := tmrCD2.enabled;
end;





procedure TCountDown2.SetfontSize(p: Tpanel; h: integer);
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


procedure TCountDown2.SetStartTime(value: TDateTime);
var
  h, M, S, MS: word;
begin
  decodetime(value, h, M, S, MS);
  SetCountDownInterval(h, M, S);
end;

procedure TCountDown2.SetCountDownInterval(h, M, S: integer);

begin
  Fstarttime := Encodetime(h, M, S, 0);
  Fcurrenttime := Fstarttime;
  SetfontSize(self, h);
  updatetimer;
  Timerset := true;

end;

procedure TCountDown2.SetRunMode(value: TrunMode2);
begin
  FRunMode := value;
end;



procedure TCountDown2.startCountDown;
begin

  if not Timerset then
    SetCountDownInterval(0, 0, 0);
  StartTOD := Now;
  tmrCD2.enabled := true;
end;

procedure TCountDown2.stopCountDown;
begin
   font.Color := clBlue;
  Timerset := false;
  tmrCD2.enabled := false;
end;

procedure TCountDown2.updatetimer;
var
  S, M, h, MS: word;
  stime, mtime, htime: extended;
  sangle, mangle, hangle: extended;

begin
  If Assigned(FOnTimerPop) then
    FOnTimerPop(self);
  caption := formatdatetime(fmtstr, currenttime);
  application.processmessages;

end;


procedure TCountDown2.timerpop(sender: TObject);

var
  delta: TDateTime;
begin
  delta := Now - StartTOD;

  if FRunMode = CountDown then
  begin
    Fcurrenttime := Fstarttime - delta;
    if Fcurrenttime >= (0.1 / 86400) then
    begin
      Fcurrenttime := (Fcurrenttime - 0.0001 / 86400) * 25; { Set variation time tmrCD2 }
    end;
    updatetimer;
    if Fcurrenttime <= (0.5 / 86400) * 2 then
    begin
      tmrCD2.enabled := false;
      Timerset := false;
      If Assigned(FOnExpired) then
        FOnExpired(self);
    end;

  end
  else
  begin
    Fcurrenttime := Fstarttime + delta;
    Fcurrenttime := (Fcurrenttime + 0.0001 / 86400) * 1;
    updatetimer;
    If Assigned(FOnTimerPop) then
      FOnTimerPop(self);
  end;

  application.processmessages;
end;

{ TStatusTime }

constructor TStatusTime.CreateStatustime;
begin

  self.Fstatustime := Fstatustime;
end;

function TStatusTime.getstatustime: string;
begin
  Result := Fstatustime;
end;

procedure TStatusTime.setstatustime;
begin
  Fstatustime := Statustime;

end;

end.
