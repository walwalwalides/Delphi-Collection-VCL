object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Demo'
  ClientHeight = 510
  ClientWidth = 338
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    338
    510)
  PixelsPerInch = 96
  TextHeight = 13
  object StrGrid: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 332
    Height = 286
    Align = alTop
    RowCount = 11
    TabOrder = 0
    OnDrawCell = StrGridDrawCell
  end
  object btnUpdateDB: TButton
    Left = 260
    Top = 295
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Update DB'
    TabOrder = 1
    OnClick = btnUpdateDBClick
  end
  object btnInsert: TButton
    Left = 3
    Top = 295
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 2
    OnClick = btnInsertClick
  end
  object btnCSV: TButton
    Left = 174
    Top = 477
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'CSV'
    TabOrder = 3
    OnClick = btnCSVClick
  end
  object btnJSON: TButton
    Left = 260
    Top = 477
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'JSON'
    TabOrder = 4
    OnClick = btnJSONClick
  end
  object btnPrint: TButton
    Left = 3
    Top = 477
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Print'
    TabOrder = 5
    OnClick = btnPrintClick
  end
  object btnPDF: TButton
    Left = 88
    Top = 477
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'PDF'
    TabOrder = 6
    OnClick = btnPDFClick
  end
end
