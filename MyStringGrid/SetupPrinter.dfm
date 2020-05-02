object frmSetupPrinter: TfrmSetupPrinter
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Printer'
  ClientHeight = 313
  ClientWidth = 211
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RGrpColor: TRadioGroup
    Left = 13
    Top = 8
    Width = 185
    Height = 82
    Caption = 'Color'
    ItemIndex = 0
    Items.Strings = (
      'Color'
      'Back/white')
    TabOrder = 0
    OnClick = RGrpColorClick
  end
  object CBPrinter: TComboBox
    Left = 13
    Top = 184
    Width = 185
    Height = 21
    TabOrder = 1
    Text = 'Printers'
    OnChange = CBPrinterChange
  end
  object btnOK: TButton
    Left = 13
    Top = 268
    Width = 84
    Height = 28
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 114
    Top = 268
    Width = 84
    Height = 28
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object RGrpSize: TRadioGroup
    Left = 13
    Top = 96
    Width = 185
    Height = 82
    Caption = 'Size'
    ItemIndex = 0
    Items.Strings = (
      '1/1'
      '1/2')
    TabOrder = 4
    OnClick = RGrpSizeClick
  end
end
