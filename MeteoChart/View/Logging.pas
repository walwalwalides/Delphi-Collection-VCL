{ ============================================
  Software Name : 	MeteoChart
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit Logging;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls, UInterfaces, Vcl.ExtCtrls;

type
  TfrmLogging = class(TForm, IObserver)
    memLogging: TMemo;
    btnReinit: TButton;
    btnClose: TButton;
    pnlFeed: TPanel;
    procedure btnReinitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTempMin: integer;
    FTempMax: integer;
    FHumidityMin: integer;
    FHumidityMax: integer;
    FPressureMin: integer;
    FPressureMax: integer;

    FObservable: IObservable;
    // IObserver
    procedure UpdateObserver(Observable: IObservable);
  public
    constructor CreateObserver(Observable: IObservable);
  end;

implementation

uses UMeteo, Main;

{$R *.dfm}

procedure TfrmLogging.btnReinitClick(Sender: TObject);
begin
  memLogging.Clear;
end;

constructor TfrmLogging.CreateObserver(Observable: IObservable);
begin
  inherited Create(Application);
  // Initial Meteo Value
  FTempMin := 20;
  FHumidityMin := 60;
  FPressureMin := 1015;
  FObservable := Observable;
  // Add the Observer
  Observable.AddObserver(Self);
end;

procedure TfrmLogging.UpdateObserver(Observable: IObservable);
var
  Meteo: IMeteo;
begin
  Meteo := Observable as IMeteo;

  if (Meteo.Temp < FTempMin) then
    FTempMin := Meteo.Temp;

  if (Meteo.Temp > FTempMax) then
    FTempMax := Meteo.Temp;

  if (Meteo.Humidity < FHumidityMin) then
    FHumidityMin := Meteo.Humidity;

  if (Meteo.Humidity > FHumidityMax) then
    FHumidityMax := Meteo.Humidity;

  if (Meteo.Pressure < FPressureMin) then
    FPressureMin := Meteo.Pressure;

  if (Meteo.Pressure > FPressureMax) then
    FPressureMax := Meteo.Pressure;

  with memLogging.Lines do
  begin
    Append('Time Of The Statement : ' + DateTimeToStr(now));
    Append('Current Value / Min / Max :');
    Append(Format('Temperature : %d / %d / %d', [Meteo.Temp, FTempMin, FTempMax]));
    Append(Format('Humidity : %d / %d / %d', [Meteo.Humidity, FHumidityMin, FHumidityMax]));
    Append(Format('Pressure : %d / %d / %d', [Meteo.Pressure, FPressureMin, FPressureMax]));
    Append('---');
  end;
end;

procedure TfrmLogging.FormCreate(Sender: TObject);
begin
  self.Position := poMainFormCenter;

end;

procedure TfrmLogging.FormDestroy(Sender: TObject);
begin
  FObservable.RemoveObserver(Self);
end;

procedure TfrmLogging.btnCloseClick(Sender: TObject);
begin
  Release;
end;

end.
