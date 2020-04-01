{ ============================================
  Software Name : 	LoadUrlGif
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ ******************************************** }
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, JvExControls,
  JvAnimatedImage, JvGIFCtrl, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, frxClass, frxExportBaseDialog, frxExportImage, Vcl.ComCtrls,
  Vcl.Menus;

type
  TGIfState = (gsPlay, gsStop);

  TfrmMain = class(TForm)
    btnPStop: TButton;
    NetHTTPRequest1: TNetHTTPRequest;
    NetHTTPClient1: TNetHTTPClient;
    edtUrlLink: TEdit;
    imgLstMain: TImageList;
    pnlBottom: TPanel;
    imgGIFAnimator: TImage;
    TraBarGifAnimator: TTrackBar;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    A1: TMenuItem;
    I1: TMenuItem;
    lblAnimationSpeed: TLabel;
    procedure btnPStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;
  GifState: TGIfState;
  iWidthGif: integer = 600;

implementation

uses Vcl.Imaging.GIFImg, About;

{$R *.dfm}

procedure TfrmMain.btnPStopClick(Sender: TObject);
var
  gifStrm: TMemoryStream;
begin

  if (GifState = gsPlay) then
  begin
    imgGIFAnimator.Left := (self.Width - iWidthGif) div 2;
    Screen.Cursor := crHourGlass;
    GifState := gsStop;
    btnPStop.Caption := 'Stop';
    btnPStop.ImageIndex := 1;
    gifStrm := TMemoryStream.Create;
    try
      NetHTTPRequest1.Get(edtUrlLink.Text, gifStrm);
      gifStrm.Seek(0, soBeginning);
      imgGIFAnimator.Picture.LoadFromStream(gifStrm);
      gifStrm.Seek(0, soBeginning);
      (imgGIFAnimator.Picture.Graphic as TGIFImage).AnimationSpeed :=
        TraBarGifAnimator.position;
      (imgGIFAnimator.Picture.Graphic as TGIFImage).Animate := True;
    finally
      gifStrm.Free;
      Screen.Cursor := crDefault;
    end;
    exit;
  end;
  if (GifState = gsStop) then
  begin
    GifState := gsPlay;
    btnPStop.Caption := 'Play';
    btnPStop.ImageIndex := 0;
    (imgGIFAnimator.Picture.Graphic as TGIFImage).Animate := false;
    exit;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  self.position := poMainFormCenter;
  self.WindowState := wsMaximized;
  self.Padding.Left := 3;
  self.Padding.Top := 3;
  imgGIFAnimator.AutoSize := True;
  edtUrlLink.Font.Size := 8;
  GifState := gsPlay;
  btnPStop.Cursor := crHandPoint;
  Screen.Cursor := crDefault;
  self.DoubleBuffered := True;
  TraBarGifAnimator.position := 500;
  self.Color := clgray;
  imgGIFAnimator.Left := 0;
  imgGIFAnimator.Top := 60;
  imgGIFAnimator.Width := 600;
  lblAnimationSpeed.Font.Color:=clGreen;

end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  //
  btnPStop.Left := (self.Width - btnPStop.Width) div 2;
  imgGIFAnimator.Left := (self.Width - imgGIFAnimator.Width) div 2;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  //
end;

procedure TfrmMain.I1Click(Sender: TObject);
begin

  frmAbout.Show;

end;

procedure TfrmMain.N2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
