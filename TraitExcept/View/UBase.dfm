object frmBase: TfrmBase
  Left = 510
  Top = 433
  Caption = 'frmBase'
  ClientHeight = 56
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TmrException: TTimer
    Enabled = False
    Interval = 8000
    OnTimer = TmrExceptionTimer
    Left = 33
    Top = 4
  end
end
