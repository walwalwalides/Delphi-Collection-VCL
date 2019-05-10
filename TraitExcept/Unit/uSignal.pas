{ ============================================
  Software Name : 	TraitExcept
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uSignal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TAniCheckThread = class(TThread)
  private
    FWnd: HWND;
    FPaintRect: TRect;
    FbkColor, FfgColor: TColor;
    FInterval: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(APanel: TWinControl;
      ARec: TRect;
      bkColor, barcolor: TColor;
      interval: integer);
  end;

implementation

constructor TAniCheckThread.Create(APanel: TWinControl; ARec: TRect; bkColor, barcolor: TColor; interval: integer);
begin
  inherited Create(True);
  FWnd := APanel.Handle;
  FPaintRect := ARec;
  FbkColor := bkColor;
  FfgColor := barcolor;
  FInterval := interval;
  FreeOnterminate := True;
  Resume;
end;

procedure TAniCheckThread.Execute;
var
  img: TBitmap;
  DC: HDC;
  left, right: integer;
  increment: integer;
  imagerect: TRect;
  state: (incRight, incLeft, decLeft, decRight);
begin
  img := TBitmap.Create;
  try
    with img do
    begin
      Width := FPaintRect.right - FPaintRect.left;
      Height := FPaintRect.Bottom - FPaintRect.Top;
      imagerect := Rect(0, 0, Width, Height);
    end;
    left := 0;
    right := 0;
    increment := imagerect.right div 50;
    state := Low(state);
    while not Terminated do
    begin
      with img.Canvas do
      begin
        Brush.Color := FbkColor;
        FillRect(imagerect);
        case state of
          incRight:
            begin
              Inc(right, increment);
              if right > imagerect.right then
              begin
                right := imagerect.right;
                Inc(state);
              end;
            end;
          incLeft:
            begin
              Inc(left, increment);
              if left >= right then
              begin
                left := right;
                Inc(state);
              end;
            end;
          decLeft:
            begin
              Dec(left, increment);
              if left <= 0 then
              begin
                left := 0;
                Inc(state);
              end;
            end;
          decRight:
            begin
              Dec(right, increment);
              if right <= 0 then
              begin
                right := 0;
                state := incRight;
              end;
            end;
        end;
        Brush.Color := FfgColor;
        FillRect(Rect(left, imagerect.Top, right, imagerect.Bottom));
      end;
      DC := GetDC(FWnd);
      if DC <> 0 then
        try
          BitBlt(DC, FPaintRect.left, FPaintRect.Top, imagerect.right, imagerect.Bottom, img.Canvas.Handle, 0, 0, SRCCOPY);
        finally
          ReleaseDC(FWnd, DC);
        end;
      Sleep(FInterval);
    end;
  finally
    img.Free;
  end;
  InvalidateRect(FWnd, nil, True);
end;

end.
