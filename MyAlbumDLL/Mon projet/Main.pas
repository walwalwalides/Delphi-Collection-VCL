{ ============================================
  Software Name : 	MyAlbumDLL
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
  Windows, SysUtils, Controls, Forms,
  Dialogs, XPman, JPEG, Classes, StdCtrls, ExtCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TfrmMain = class(TForm)
    Shape1: TShape;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    btnAbout: TButton;
    Image1: TImage;
    statbrmain: TStatusBar;
    ilMain: TImageList;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  iR: Byte = 1;
  frmMain: TfrmMain;
  h: THandle;
  JPG: TjpegImage;
  Res: TResourceStream;
  ImageSuivante: String;

implementation

uses uAbout;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.Button2Click(Sender: TObject);

begin
  h := LoadLibrary('DLLImages.DLL');
  try
    if h <> 0 then
    begin
      JPG := TjpegImage.Create;
      try
        if (iR < 4) then
        begin
          ImageSuivante := 'R' + IntToStr(iR);
          Res := TResourceStream.Create(h, ImageSuivante, RT_RCDATA);
          JPG.LoadFromStream(Res);
          Image1.Picture.Bitmap.Assign(JPG);
          statbrmain.Panels[1].Text := 'Image Nr ° ' + IntToStr(iR);
          Inc(iR);
        end;
        If (iR = 4) then
          iR := 1;
      finally
        JPG.Free;
      end;

      statbrmain.Panels[0].Text := 'Sum Of The Images : 3';

    end
    else
    begin
      ShowMessage('Dll not found ...............!');
    end;
  finally
    FreeLibrary(h);
  end;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  Button2Click(Sender);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // statbrmain.Font.Style := ;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

end.
