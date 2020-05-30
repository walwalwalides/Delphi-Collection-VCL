object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 542
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 24
    Top = 488
    object F1: TMenuItem
      Caption = 'File'
      object miExit: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16472
        OnClick = miExitClick
      end
    end
    object N1: TMenuItem
      Caption = 'Help'
      object miAbout: TMenuItem
        Caption = '&About'
        ShortCut = 16449
        OnClick = miAboutClick
      end
    end
  end
end
