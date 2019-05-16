object frmMain: TfrmMain
  Left = 0
  Top = 0
  ActiveControl = trackbarR
  Caption = 'clConverter'
  ClientHeight = 350
  ClientWidth = 660
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MMMain
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlColor: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 216
    Width = 654
    Height = 128
    Hint = 'Text wurde Kopiert'
    Align = alTop
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    PopupMenu = puMenuConverter
    ShowHint = False
    TabOrder = 0
    OnClick = pnlColorClick
    OnMouseLeave = pnlColorMouseLeave
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 654
    Height = 65
    Align = alTop
    Color = clRed
    ParentBackground = False
    TabOrder = 1
    object LblR: TLabel
      Left = 1
      Top = 51
      Width = 652
      Height = 13
      Align = alBottom
      Alignment = taCenter
      Caption = 'Red'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 22
    end
    object trackbarR: TTrackBar
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 646
      Height = 45
      Cursor = crHandPoint
      Align = alTop
      Max = 255
      TabOrder = 0
      OnChange = RGB_onchage
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 74
    Width = 654
    Height = 65
    Align = alTop
    Color = clGreen
    ParentBackground = False
    TabOrder = 2
    object LblG: TLabel
      Left = 1
      Top = 51
      Width = 652
      Height = 13
      Align = alBottom
      Alignment = taCenter
      Caption = 'Green'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 34
    end
    object TrackBarG: TTrackBar
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 646
      Height = 45
      Cursor = crHandPoint
      Align = alTop
      Max = 255
      TabOrder = 0
      OnChange = RGB_onchage
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 145
    Width = 654
    Height = 65
    Align = alTop
    Color = clBlue
    ParentBackground = False
    TabOrder = 3
    object LblB: TLabel
      Left = 1
      Top = 51
      Width = 652
      Height = 13
      Align = alBottom
      Alignment = taCenter
      Caption = 'Blue'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 24
    end
    object TrackBarB: TTrackBar
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 646
      Height = 30
      Cursor = crHandPoint
      Align = alTop
      Max = 255
      TabOrder = 0
      OnChange = RGB_onchage
    end
  end
  object puMenuConverter: TPopupMenu
    Left = 467
    Top = 240
    object ppHTML: TMenuItem
      Action = acToHTML
    end
  end
  object MMMain: TMainMenu
    Left = 595
    object N1: TMenuItem
      Caption = '&File'
      object N2: TMenuItem
        Action = actExit
      end
    end
    object N3: TMenuItem
      Caption = '&About'
      object N4: TMenuItem
        Action = actAbout
      end
    end
  end
  object ActionList1: TActionList
    Left = 593
    Top = 40
    object actOpenFile: TAction
      Category = 'File'
      Caption = 'Open File(s)...'
    end
    object actShowInExplorer: TAction
      Caption = 'Show in Explorer'
    end
    object actOpenFolder: TAction
      Category = 'File'
      Caption = 'Open Folder(s)...'
      OnExecute = actOpenFolderExecute
    end
    object actExit: TAction
      Category = 'File'
      Caption = 'Exit'
      OnExecute = actExitExecute
    end
    object actOption: TAction
      Category = 'Option'
      Caption = 'Option'
      ShortCut = 16463
    end
    object actAbout: TAction
      Category = 'About'
      Caption = 'Info'
      ShortCut = 16457
      OnExecute = actAboutExecute
    end
    object acToHTML: TAction
      Category = 'Converter'
      Caption = 'ToHTML'
      OnExecute = acToHTMLExecute
    end
  end
end
