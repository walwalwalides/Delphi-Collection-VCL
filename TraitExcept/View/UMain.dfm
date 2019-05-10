inherited frmMain: TfrmMain
  Caption = 'TraitException'
  ClientHeight = 431
  Menu = MainMenu1
  OnCreate = FormCreate
  ExplicitHeight = 490
  PixelsPerInch = 96
  TextHeight = 13
  object LblMessage: TLabel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 626
    Height = 24
    Align = alTop
    Alignment = taCenter
    Caption = '---------------------'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 189
  end
  object btnException: TButton [1]
    Left = 8
    Top = 351
    Width = 81
    Height = 57
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'Exception'
    TabOrder = 0
    OnClick = btnExceptionClick
    ExplicitTop = 371
  end
  object pnlSignal: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 414
    Width = 626
    Height = 14
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 434
  end
  object radGrpState: TRadioGroup [3]
    Left = 8
    Top = 248
    Width = 185
    Height = 81
    Caption = 'STATE'
    ItemIndex = 0
    Items.Strings = (
      'NO ERROR'
      'ERROR 1'
      'ERROR 2')
    TabOrder = 2
  end
  inherited TmrException: TTimer
    Left = 17
    Top = 60
  end
  object MainMenu1: TMainMenu
    Left = 48
    Top = 216
    object File1: TMenuItem
      Caption = 'File'
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit2: TMenuItem
        Action = actExit
      end
    end
    object A2: TMenuItem
      Caption = 'About'
      object actAbout1: TMenuItem
        Action = actAbout
      end
    end
  end
  object ActionList1: TActionList
    Left = 57
    Top = 96
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
    end
    object actExit: TAction
      Category = 'File'
      Caption = 'Exit'
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
  end
end
