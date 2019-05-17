{ ============================================
  Software Name : 	MeteoChart
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit Chart;

interface

uses
  SysUtils, Classes, Controls, Forms,
  VCLTee.TeEngine, VCLTee.Series, VCLTee.Chart, UInterfaces, ExtCtrls, VCLTee.TeeProcs, StdCtrls,
  ComCtrls, VCLTee.TeeGDIPlus;

type
  TfrmChart = class(TForm, IObserver)
    TempChart: TChart;
    Series1: TLineSeries;
    HumiditeChart: TChart;
    LineSeries2: TLineSeries;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    chbxTemp: TCheckBox;
    chbxHumidite: TCheckBox;
    chbxPression: TCheckBox;
    PressionChart: TChart;
    Series2: TFastLineSeries;
    Label1: TLabel;
    edtPoint: TEdit;
    UpDown1: TUpDown;
    pnlFeed: TPanel;
    btnReinit: TButton;
    btnClose: TButton;

    procedure FormDestroy(Sender: TObject);
    procedure chbxTempClick(Sender: TObject);
    procedure chbxHumiditeClick(Sender: TObject);
    procedure chbxPressionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnReinitClick(Sender: TObject);
  private
    FObservable: IObservable;

    procedure UpdateObserver(Observable: IObservable);
  public
    constructor CreateObserver(Observable: IObservable);
  end;

implementation

uses UMeteo, Main;

{$R *.dfm}

constructor TfrmChart.CreateObserver(Observable: IObservable);
begin
  inherited Create(Application);
  FObservable := Observable;
  Observable.AddObserver(Self);
end;

procedure TfrmChart.FormCreate(Sender: TObject);
begin
  Self.position := poMainFormCenter;
end;

procedure TfrmChart.FormDestroy(Sender: TObject);
begin
  FObservable.RemoveObserver(Self);
end;

procedure TfrmChart.UpdateObserver(Observable: IObservable);
var
  i: integer;
  T: TDateTime;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TChart then
      with Components[i] as TChart do
        while Series[0].Count > UpDown1.position do
          Series[0].Delete(0); // Delete the Series to set the limit of number point in Digarame

  T := Time;

  if chbxTemp.Checked then
    TempChart.Series[0].AddXY(T, (Observable as IMeteo).GetTemp, TimeToStr(T)); // get Temperature

  if chbxHumidite.Checked then
    HumiditeChart.Series[0].AddXY(T, (Observable as IMeteo).GetHumidity, TimeToStr(T)); // Get Humidity

  if chbxPression.Checked then
    PressionChart.Series[0].AddXY(T, (Observable as IMeteo).GetPressure, TimeToStr(T)); // Get Pressure

end;

procedure TfrmChart.chbxTempClick(Sender: TObject);
begin
  TempChart.Visible := chbxTemp.Checked;
end;

procedure TfrmChart.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmChart.btnReinitClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TChart then
      with Components[i] as TChart do
        while Series[0].Count > 0 do
        Series[0].Delete(0);

end;

  procedure TfrmChart.chbxHumiditeClick(Sender: TObject);
  begin
    HumiditeChart.Visible := chbxHumidite.Checked;
  end;

  procedure TfrmChart.chbxPressionClick(Sender: TObject);
  begin
    PressionChart.Visible := chbxPression.Checked;
  end;

end.
