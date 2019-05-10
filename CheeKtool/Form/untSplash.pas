{ ============================================
  Software Name : 	CheecKtool
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2018 }
{ Email : WalWalWalides@gmail.com }
{ ******************************************** }
unit untSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, acPNG;

type
  TfrmSplash = class(TForm)
    TimerSplash: TTimer;
    LabelSplash: TLabel;
    imgLogo: TImage;
    lblSoftVer: TLabel;
    bvlcontour: TBevel;
    procedure FormShow(Sender: TObject);
    procedure TimerSplashTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
    CountSplash: Integer;
  end;

var
  frmSplash: TfrmSplash;

implementation

uses
  MainTools;

{$R *.dfm}

procedure TfrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
   lblSoftVer.caption:='Ver. '+'0.0.0.1';
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
