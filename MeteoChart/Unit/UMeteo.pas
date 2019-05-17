{ ============================================
  Software Name : 	MeteoChart
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit UMeteo;

interface

uses
  Forms, ExtCtrls, UObservable, UInterfaces;

type
  TMeteo = class(TInterfacedObject, IObservable, IMeteo)
  private
    FTimer: TTimer;
    FTemp: integer;
    FHumidity: integer;
    FPressure: integer;
    FObservable: IObservable;
    procedure TimerOnTimer(Sender: TObject);

  public

    constructor Create;
    destructor destroy; override;
    // IObservable
    procedure AddObserver(Obs: IObserver);
    procedure RemoveObserver(Obs: IObserver);
    procedure NotifyObservers;
    // IMeteo
    function GetTemp: integer;
    function GetHumidity: integer;
    function GetPressure: integer;
    function GetTimerInterval: integer;
    procedure SetTimerInterval(const Value: integer);
    property TimerInterval: integer read GetTimerInterval write SetTimerInterval;
  end;

implementation

{ TMeteo }

constructor TMeteo.Create;
begin
  inherited;
  FObservable := TObservable.Create(Self);
  FTimer := TTimer.Create(Application);
  FTimer.OnTimer := TimerOnTimer;
  FTimer.Enabled := True;

end;

destructor TMeteo.destroy;
begin
  FTimer.Free;
  inherited;
end;

function TMeteo.GetHumidity: integer;
begin
  Result := FHumidity;
end;

function TMeteo.GetPressure: integer;
begin
  Result := FPressure;
end;

function TMeteo.GetTemp: integer;
begin
  Result := FTemp;
end;

function TMeteo.GetTimerInterval: integer;
begin
  Result := FTimer.Interval;
end;

procedure TMeteo.AddObserver(Obs: IObserver);
begin
  FObservable.AddObserver(Obs);
end;

procedure TMeteo.NotifyObservers;
begin
  FObservable.NotifyObservers;
end;

procedure TMeteo.RemoveObserver(Obs: IObserver);
begin

  FObservable.RemoveObserver(Obs);
end;

procedure TMeteo.SetTimerInterval(const Value: integer);
begin
  FTimer.Interval := Value;
end;

procedure TMeteo.TimerOnTimer(Sender: TObject);
begin
  // MeteoChart Simulation using timer
  FTemp := 10 + random(20);
  FHumidity := 40 + random(40);
  FPressure := 1100 + random(100);

  // Notify of Observers
  FObservable.NotifyObservers;
end;

end.
