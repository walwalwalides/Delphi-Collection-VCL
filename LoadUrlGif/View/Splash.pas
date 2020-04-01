{ ============================================
  Software Name : 	LoadUrlGif
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ ******************************************** }
unit Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, acPNG,
  dxGDIPlusClasses;

type
  TfrmSplash = class(TForm)
    TimerSplash: TTimer;
    lblSplash: TLabel;
    imgLogo: TImage;
    lblSoftVer: TLabel;
    bvlcontour: TBevel;
    procedure FormShow(Sender: TObject);
    procedure TimerSplashTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    CountSplash: Integer;
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.dfm}

procedure TfrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  lblSplash.Font.Size := 20;
  lblSplash.font.Color := clGreen;
  lblSoftVer.font.Color := clGreen;
  self.Color:=clGray;
  TimerSplash.Interval:=500;
end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin

  lblSoftVer.caption := 'Ver. ' + '1.0.0.0';
  CountSplash := 2;
  //
  TimerSplash.Enabled := True;
end;

procedure TfrmSplash.TimerSplashTimer(Sender: TObject);
begin
  if (CountSplash > 0) then
    // LabelSplash.Caption := 'CheecKtool ' + IntToStr(CountSplash) + 's'
  else
    Close;
  //
  CountSplash := (CountSplash - 1);
end;

end.
