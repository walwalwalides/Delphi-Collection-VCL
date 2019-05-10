unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.pngimage, ExtCtrls, PngFunctions, acPNG, dxGDIPlusClasses;

type
  TfrmAboutBox = class(TForm)
    Label2: TLabel;
    ImagClose: TImage;
    lblAppname: TLabel;
    procedure lblAppnameClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ImagCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAboutBox: TfrmAboutBox;

implementation

uses main;

{$R *.dfm}

procedure TfrmAboutBox.lblAppnameClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAboutBox.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAboutBox.FormCreate(Sender: TObject);
begin
 lblAppname.caption:=Application.Title;
end;

procedure TfrmAboutBox.FormPaint(Sender: TObject);
var
  PngOffObj: TPNGObject;
  BmpOff   : TBitmap;
  BackPath : string;
begin
  BackPath := MainForm.Settings.SkinPath + '\Logo\About.png';
  PngOffObj := TPNGObject.Create;
  PngOffObj.LoadFromFile(BackPath);

  BmpOff := TBitmap.Create;
  BmpOff.Width := PngOffObj.Width;
  BmpOff.Height := PngOffObj.Height;
  BmpOff.Canvas.Brush.Style := bsSolid;
  BmpOff.Canvas.Brush.Color := $00E7BFC8;
  BmpOff.Canvas.FillRect(Rect(0, 0, PngOffObj.Width, PngOffObj.Height));
  BmpOff.Canvas.Draw(0, 0, PngOffObj);
  BmpOff.Canvas.Pixels[0, BmpOff.Height-1] := clBtnFace;

  Canvas.StretchDraw(ClientRect,BmpOff);
  PngOffObj.Free;
  BmpOff.Free;
end;

procedure TfrmAboutBox.FormShow(Sender: TObject);
begin
 color:= $00E7BFC8;
end;

procedure TfrmAboutBox.ImagCloseClick(Sender: TObject);
begin
   Close;
end;

end.
