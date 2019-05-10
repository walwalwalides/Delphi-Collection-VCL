{ ============================================
  Software Name : 	BatterflyTray
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit View.Home;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Template, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.StdCtrls, dxGDIPlusClasses, GR32_Image, Vcl.AppEvnts,
  Vcl.Buttons;

type
  TfrmViewHome = class(TfrmTemplate)
    CboxAA: TCheckBox;
    tiButterfly: TTrayIcon;
    ilButterfly: TImageList;
    ImgBatterfly: TImage32;
    ApplicationEvents1: TApplicationEvents;
    BtnDrawCurve: TBitBtn;
    bitbtnTrayIcon: TBitBtn;
    procedure BtnDrawCurveClick(Sender: TObject);
    procedure bitbtnTrayIconClick(Sender: TObject);
    procedure CboxAAClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmViewHome: TfrmViewHome;

implementation

{$R *.dfm}

uses
  Math, GR32, GR32_Geometry, GR32_VectorUtils, GR32_Resamplers, GR32_LowLevel,
  GR32_Polygons;

function MakeCurve(const Points: TArrayOfFloatPoint; Kernel: TCustomKernel; Closed: Boolean): TArrayOfFloatPoint;
const
  TOLERANCE: TFloat = 5.0;
  THRESHOLD: TFloat = 0.5;
var
  I, H, R: Integer;
  Filter: TFilterMethod;
  WrapProc: TWrapProc;

  procedure AddPoint(const P: TFloatPoint);
  var
    L: Integer;
  begin
    L := Length(Result);
    SetLength(Result, L + 1);
    Result[L] := P;
  end;

  function GetPoint(I: Integer; t: TFloat = 0.0): TFloatPoint;
  var
    f, Index: Integer;
    W: TFloat;
  begin
    Result.X := 0;
    Result.Y := 0;
    for f := -R to R do
    begin
      Index := WrapProc(I - f, H);
      W := Filter(f + t);
      Result.X := Result.X + W * Points[Index].X;
      Result.Y := Result.Y + W * Points[Index].Y;
    end;
  end;

  procedure Recurse(I: Integer; const P1, P2: TFloatPoint; const t1, t2: TFloat);
  var
    Temp: TFloat;
    P: TFloatPoint;
  begin
    AddPoint(P1);
    Temp := (t1 + t2) * 0.5;
    P := GetPoint(I, Temp);

    if (Abs(CrossProduct(FloatPoint(P1.X - P.X, P1.Y - P.Y), FloatPoint(P.X - P2.X, P.Y - P2.Y))) > TOLERANCE) or (t2 - t1 >= THRESHOLD) then
    begin
      Recurse(I, P1, P, t1, Temp);
      Recurse(I, P, P2, Temp, t2);
    end
    else
      AddPoint(P);
  end;

const
  WRAP_PROC: array [Boolean] of TWrapProc = (Clamp, Wrap);
begin
  WrapProc := WRAP_PROC[Closed];
  Filter := Kernel.Filter;
  R := Ceil(Kernel.GetWidth);
  H := High(Points);

  for I := 0 to H - 1 do
    Recurse(I, GetPoint(I), GetPoint(I + 1), 0, 1);

  if Closed then
    Recurse(H, GetPoint(H), GetPoint(0), 0, 1)
  else
    AddPoint(GetPoint(H));
end;

procedure TfrmViewHome.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  inherited;
  BtnDrawCurveClick(Sender);
end;

procedure TfrmViewHome.BtnDrawCurveClick(Sender: TObject);
var
  PX, PY: TArrayOfFloatPoint;
  I: Integer;
  K: TCustomKernel;
  X, Y: Integer;
begin
  inherited;
  ImgBatterfly.SetupBitmap(True, $11223344); // color of Background
  SetLength(PX, 4);

  // Array of float 64 Pixel bigger
  PX[0] := FloatPoint(31.5, RandomRange(0, 63));
  PX[1] := FloatPoint(63, 31.5);
  PX[2] := FloatPoint(31.5, 31.5);
  PX[3] := FloatPoint(31.5, 31.5);

  K := TGaussianKernel.Create;
  try
    PY := MakeCurve(PX, K, True);
  finally
    K.Free;
  end;
  PolygonFS(ImgBatterfly.Bitmap, PY, $AAAAAAAA, pfWinding);
end;

procedure TfrmViewHome.bitbtnTrayIconClick(Sender: TObject);
begin
  inherited;
  if not(tiButterfly.Visible) then
  begin

    tiButterfly.BalloonHint := 'Trayicon is active';
//    tiButterfly.ShowBalloonHint;
      tiButterfly.Visible := True;
  end
  else
  begin

    tiButterfly.BalloonHint := 'Trayicon is dective';
//    tiButterfly.ShowBalloonHint;
      tiButterfly.Visible := False;
  end;
end;

procedure TfrmViewHome.CboxAAClick(Sender: TObject);
begin
  if CboxAA.Checked then
    Application.OnIdle := ApplicationEvents1Idle
  else
    Application.OnIdle := nil;
end;

procedure TfrmViewHome.FormCreate(Sender: TObject);
begin
  inherited;
  tiButterfly.AnimateInterval := 15;
  tiButterfly.BalloonTimeout := 100;
end;

end.
