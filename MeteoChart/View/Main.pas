{ ============================================
  Software Name : 	MeteoChart
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
  SysUtils, Classes, Controls, Forms, Vcl.Graphics,
  StdCtrls, UInterfaces, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.Menus;

type
  TfrmMain = class(TForm, IObserver)
    btnChart: TButton;
    lblInfo: TLabel;
    Label1: TLabel;
    btnLogging: TButton;
    Label2: TLabel;
    Label3: TLabel;
    lblTemperature: TLabel;
    lblHumidity: TLabel;
    lblPressure: TLabel;
    pnlMain: TPanel;
    bvlHead: TBevel;
    ilMain: TImageList;
    MMMain: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    A2: TMenuItem;
    actAbout1: TMenuItem;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actShowInExplorer: TAction;
    actOpenFolder: TAction;
    actExit: TAction;
    actOption: TAction;
    actAbout: TAction;
    N2: TMenuItem;
    Exit1: TMenuItem;
    pnlFeed: TPanel;
    BevelTemperature: TBevel;
    bvlHumidity: TBevel;
    bvlPressure: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnChartClick(Sender: TObject);
    procedure btnLoggingClick(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    FObservable: IObservable;
    procedure UpdateObserver(Observable: IObservable);
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses UMeteo, Chart, Logging, About;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  frmMain.WindowState := wsMaximized;
  lblTemperature.font.Color := clred;
  lblHumidity.font.Color := clBlue;
  lblPressure.font.Color := clGreen;
  frmMain.Position := poMainFormCenter;
  FObservable := TMeteo.Create;
  FObservable.AddObserver(Self);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FObservable.RemoveObserver(Self);
end;

procedure TfrmMain.UpdateObserver(Observable: IObservable);
begin
  lblTemperature.Caption := IntToStr((Observable as IMeteo).GetTemp);
  lblHumidity.Caption := IntToStr((Observable as IMeteo).GetHumidity);
  lblPressure.Caption := IntToStr((Observable as IMeteo).GetPressure);
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  F: TfrmAbout;
begin

  inherited;
  if not Assigned(F) then
    Application.CreateForm(TfrmAbout, F);
  F.Position := poMainFormCenter;
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;

end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.btnChartClick(Sender: TObject);
var
  ChartMeteoForm: TfrmChart;
begin
  ChartMeteoForm := TfrmChart.CreateObserver(FObservable);
  ChartMeteoForm.Show;
end;

procedure TfrmMain.btnLoggingClick(Sender: TObject);
var
  LoggingMeteoForm: TfrmLogging;
begin
  LoggingMeteoForm := TfrmLogging.CreateObserver(FObservable);
  LoggingMeteoForm.Show;
end;

end.
