{ ============================================
  Software Name : 	CountDown
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit UCountDownTimer1;

interface

uses Windows, Sysutils, controls, forms, classes, graphics, extctrls, mmsystem;

type
  TrunMode = (Countup, CountDown);

  TCountDown = class(Tpanel)
  private
    Fstarttime: TDateTime;
    Fcurrenttime: TDateTime;
    FRunMode: TrunMode;
    FOnExpired: TNotifyevent;
    FOnTimerPop: TNotifyevent;
    fmtstr: string;
    FNoSound: boolean;
    tmrCD1: TTimer;
    Timerset: boolean;
    ClickSound: pointer;
    StartTOD: TDateTime;

    Image1: TImage;
    Panel1: Tpanel;
    center: TPoint;
    shandlen, mhandlen, hhandlen: integer;
    lastsc, lastmn, lasthr: TPoint;
    textheight: integer;

    function GetRunning: boolean;
    procedure Setnosound(value: boolean);
    procedure SetStartTime(value: TDateTime);
    procedure SetfontSize(p: Tpanel; h: integer);
    procedure SetRunMode(value: TrunMode);
    procedure updatetimer;
    procedure timerpop(sender: TObject);

  published
    property starttime: TDateTime read Fstarttime write SetStartTime;
    property currenttime: TDateTime read Fcurrenttime;
    property running: boolean read GetRunning;
    property runmode: TrunMode Read FRunMode write SetRunMode;
    property Nosound: boolean read FNoSound write Setnosound;
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

{tmrCD4 is the main timer ,Inteval 10 second}

function GetResourceAsPointer(ResName: pchar; ResType: pchar; out Size: longword): pointer;
var
  InfoBlock: HRSRC;
  GlobalMemoryBlock: HGLOBAL;
begin
  InfoBlock := FindResource(hInstance, ResName, ResType);
  if InfoBlock = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
  Size := SizeofResource(hInstance, InfoBlock);
  if Size = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
  GlobalMemoryBlock := LoadResource(hInstance, InfoBlock);
  if GlobalMemoryBlock = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
  Result := LockResource(GlobalMemoryBlock);
  if Result = nil then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;


constructor TCountDown.Create(CustumPanel: Tpanel);
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

  tmrCD1 := TTimer.Create(self);
  tmrCD1.ontimer := timerpop;
  tmrCD1.enabled := false;
  tmrCD1.interval := 1000;

  ClickSound := GetResourceAsPointer('TaktCD', 'WAV', size);


  FNoSound := true;
  Fstarttime := 1 / 86400;    //86400 number of second in one hour
  Fcurrenttime := Fstarttime;
  FRunMode := CountDown;
  Timerset := false;

end;

destructor TCountDown.Destroy;
begin
  if Assigned(Panel1) then
    Panel1.free;

  tmrCD1.free;
  // clicksound.free;
  inherited;
end;


function TCountDown.GetRunning: boolean;
begin
  Result := tmrCD1.enabled;
end;


procedure TCountDown.Setnosound(value: boolean);
begin
  FNoSound := value;
end;


procedure TCountDown.SetfontSize(p: Tpanel; h: integer);
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
      { temporair Countdown}

  tempcanvas := TCanvas.Create;
  tempcanvas.Handle := GetDeviceContext(notused);
  tempcanvas.font.assign(font);
  with tempcanvas do
  begin
    font.Size := 6;
    font.style := [fsbold];
    font.Color := clGreen;

    while (textwidth(str) < width) and (textheight(str) < height) and (font.Size < 100) do
      font.Size := font.Size + 2;
    font.Size := font.Size - 2;
  end;
  font.assign(tempcanvas.font);
  tempcanvas.free;
end;


procedure TCountDown.SetStartTime(value: TDateTime);
var
  h, M, S, MS: word;
begin
  decodetime(value, h, M, S, MS);
  SetCountDownInterval(h, M, S);
end;


procedure TCountDown.SetCountDownInterval(h, M, S: integer);
begin
  Fstarttime := Encodetime(h, M, S, 0);
  Fcurrenttime := Fstarttime;
  { digital timer }
  SetfontSize(self, h);
  updatetimer;
  Timerset := true;
end;

procedure TCountDown.SetRunMode(value: TrunMode);
begin
  FRunMode := value;
end;


procedure TCountDown.startCountDown;
begin

  if not Timerset then
    SetCountDownInterval(0, 0, 0);

  StartTOD := Now;
  tmrCD1.enabled := true;
end;

procedure TCountDown.stopCountDown;
begin
  Timerset := false;
  tmrCD1.enabled := false;
end;

procedure TCountDown.updatetimer;
var
  S, M, h, MS: word;
  stime, mtime, htime: extended;
  sangle, mangle, hangle: extended;
begin
//  if (FNoSound = false) then
//    PlaySound(ClickSound, 0, SND_MEMORY);
  If Assigned(FOnTimerPop) then
    FOnTimerPop(self); { Take onTimerPop exit if defined }
  caption := formatdatetime(fmtstr, currenttime);
  application.processmessages;
end;


procedure TCountDown.timerpop(sender: TObject);

var
  delta: TDateTime;
begin
  delta := Now - StartTOD;

  if FRunMode = CountDown then
  begin
    Fcurrenttime := Fstarttime - delta;
    if Fcurrenttime >= 0.1 / 86400 then
    begin
      Fcurrenttime := Fcurrenttime - 0.0001 / 86400;  { decrease Countdown by 1 second }
    end;
    updatetimer;
    if Fcurrenttime <= 0.5 / 86400 then
    begin
      tmrCD1.enabled := false;
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
