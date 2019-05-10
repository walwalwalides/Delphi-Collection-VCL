object frmMainTools: TfrmMainTools
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  ClientHeight = 327
  ClientWidth = 575
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageCtrlMain: TPageControl
    Left = 0
    Top = 0
    Width = 575
    Height = 327
    ActivePage = TabSheetClear
    Align = alClient
    TabOrder = 0
    object TabSheetCheeck: TTabSheet
      Caption = 'Check'
      object mmo1: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 461
        Height = 267
        Align = alLeft
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object psRepair: TProgressBar
        AlignWithMargins = True
        Left = 3
        Top = 276
        Width = 561
        Height = 20
        Align = alBottom
        BorderWidth = 2
        ParentShowHint = False
        BarColor = clGreen
        ShowHint = True
        TabOrder = 2
      end
      object btnGlowCheek: TButton
        AlignWithMargins = True
        Left = 474
        Top = 5
        Width = 88
        Height = 263
        Cursor = crHandPoint
        Hint = 'Chat'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = 'Check             (DLL && BPL)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = False
        WordWrap = True
        OnClick = btnGlowCheekClick
      end
    end
    object TabSheetinf: TTabSheet
      Caption = 'Display'
      ImageIndex = 1
      object redOut: TRichEdit
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 467
        Height = 293
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Zoom = 100
      end
      object btnGlowLog: TButton
        AlignWithMargins = True
        Left = 476
        Top = 3
        Width = 88
        Height = 293
        Cursor = crHandPoint
        Hint = 'Chat'
        Align = alRight
        Anchors = []
        Caption = 'Log (User)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = False
        WordWrap = True
        OnClick = btnGlowLogClick
      end
    end
    object TabSheetClear: TTabSheet
      Caption = 'Clear'
      ImageIndex = 2
      DesignSize = (
        567
        299)
      object DirectoryListBox1: TDirectoryListBox
        Left = 3
        Top = 28
        Width = 135
        Height = 242
        Anchors = [akLeft, akTop, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object DriveComboBox1: TDriveComboBox
        Left = 3
        Top = 6
        Width = 135
        Height = 19
        TabOrder = 3
        OnChange = DriveComboBox1Change
      end
      object ListBox1: TListBox
        Left = 141
        Top = 6
        Width = 329
        Height = 264
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = 3947580
        Font.Height = -8
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ItemHeight = 10
        ParentFont = False
        TabOrder = 4
      end
      object PbarTemporary: TProgressBar
        AlignWithMargins = True
        Left = 3
        Top = 276
        Width = 561
        Height = 20
        Align = alBottom
        BorderWidth = 2
        ParentShowHint = False
        BarColor = clGreen
        ShowHint = True
        TabOrder = 5
      end
      object btnGlowChecktmp: TButton
        AlignWithMargins = True
        Left = 476
        Top = 6
        Width = 88
        Height = 233
        Cursor = crHandPoint
        Hint = 'Chat'
        Anchors = [akTop, akRight, akBottom]
        Caption = 'Check (Temporary files)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = False
        WordWrap = True
        OnClick = btnGlowChecktmpClick
      end
      object btnGlowDeletetmp: TButton
        AlignWithMargins = True
        Left = 476
        Top = 245
        Width = 88
        Height = 25
        Cursor = crHandPoint
        Hint = 'Chat'
        Anchors = [akRight, akBottom]
        Caption = 'Delete'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = False
        WordWrap = True
        OnClick = btnGlowDeletetmpClick
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 392
    Top = 64
    object Plik1: TMenuItem
      Caption = 'File'
      object Zamknij1: TMenuItem
        Caption = 'Close'
        OnClick = Zamknij1Click
      end
    end
    object S1: TMenuItem
      Caption = 'Style'
      object S2: TMenuItem
        Caption = 'SetStyle'
        OnClick = S2Click
      end
    end
    object Pomoc1: TMenuItem
      Caption = 'About'
      object Informacjao1: TMenuItem
        Caption = 'Information'
        OnClick = Informacjao1Click
      end
    end
  end
end
