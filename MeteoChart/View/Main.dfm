object frmMain: TfrmMain
  Left = 8
  Top = 22
  Caption = 'MeteoChart'
  ClientHeight = 409
  ClientWidth = 562
  Color = 16711422
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MMMain
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    562
    409)
  PixelsPerInch = 96
  TextHeight = 13
  object statbrMain: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 387
    Width = 556
    Height = 19
    Panels = <
      item
        Text = 'Interval Timer : '
        Width = 200
      end
      item
        Width = 50
      end>
    ExplicitLeft = 8
    ExplicitTop = 394
    ExplicitWidth = 562
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 152
    Width = 257
    Height = 229
    Anchors = [akLeft, akBottom]
    Caption = 'Meteo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object pnlFeed: TPanel
      Left = 7
      Top = 191
      Width = 244
      Height = 33
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object btnChart: TButton
        Left = 4
        Top = 2
        Width = 114
        Height = 25
        Cursor = crHandPoint
        Action = acDisChart
        ImageIndex = 0
        Images = ilMain
        TabOrder = 0
      end
      object btnLogging: TButton
        Left = 124
        Top = 2
        Width = 114
        Height = 25
        Cursor = crHandPoint
        Action = acDisLogging
        ImageIndex = 1
        Images = ilMain
        TabOrder = 1
      end
    end
    object pnlMain: TPanel
      Left = 7
      Top = 50
      Width = 244
      Height = 137
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 48
        Width = 97
        Height = 13
        Caption = 'Temperature (in '#176'C) :'
      end
      object Label2: TLabel
        Left = 16
        Top = 72
        Width = 74
        Height = 13
        Caption = 'Humidity (in %) :'
      end
      object Label3: TLabel
        Left = 16
        Top = 96
        Width = 103
        Height = 13
        Caption = 'Pressure (in millibars) :'
      end
      object lblHumidity: TLabel
        Left = 136
        Top = 72
        Width = 6
        Height = 13
        Caption = '?'
      end
      object lblInfo: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 236
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'Current Information'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 109
      end
      object lblPressure: TLabel
        Left = 125
        Top = 96
        Width = 6
        Height = 13
        Caption = '?'
      end
      object lblTemperature: TLabel
        Left = 136
        Top = 48
        Width = 6
        Height = 13
        Caption = '?'
      end
      object bvlHead: TBevel
        AlignWithMargins = True
        Left = 4
        Top = 23
        Width = 236
        Height = 112
        Align = alTop
        ExplicitWidth = 269
      end
      object BevelTemperature: TBevel
        Left = 119
        Top = 40
        Width = 38
        Height = 26
      end
      object bvlHumidity: TBevel
        Left = 119
        Top = 66
        Width = 38
        Height = 26
      end
      object bvlPressure: TBevel
        Left = 119
        Top = 89
        Width = 38
        Height = 26
      end
    end
  end
  object ilMain: TImageList
    Left = 512
    Top = 116
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000505050B242424424545457C6666
      66B7A0A0A0EF5D5C5ADF0705062D0000000000000000817C77DCA39D96FEA19B
      95FEA19B95FEA19B95FEA19B95FEA19B95FEA19B96FEA19B94FEA19C94FEA19A
      95FEA19B95FEA39C95FE827C78DC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000C195050BCFF0000
      000000000000000000005555CCFF00000F190000000000000000000000000000
      000F000000050000000000000000000000000000000000000000000000000000
      0004000000100000000000000000000000000000000000000000000000000000
      00001010101C33333356575757917E7E7FCCAFAFB0FBCCCCCCFFE1E1DFFFFAFA
      F9FFFEFEFEFF79736EFF383531EF0000000000000000A7A29DFEFEFEFEFFFEFD
      FBFFFEFEF9FFFEFCF8FFFEFDF7FFFEFBF7FFFEFAF4FFFEF9F4FFFEF8F1FFFEF5
      EFFFFDF4EDFFFEF8EEFFA7A29BFE000000001C1A14A737332BFF38332BFF3A36
      2DFF3C3830FF3E3A33FF413C35FF413D36FF413D35FF4F4FB4FF0E0EB8FF5656
      CFFF5D5A53FF5B5BDEFF1A1ACFFF5353C8FF0000000000000000000000240000
      85FF000038CA0000000800000000000000000000000000000000000000050000
      43C801019CFF000000310000000000000000000000003636365E636364A69292
      93E1BABBBBFED4D4D3FFE6E6E1FFFAFAF6FFFCFCF8FFFAFAF8FFFEFEFEFFFEFE
      FEFFFEFEFEFF7E7870FF646059FF0000000000000000A7A29AFEFEFEFCFFFBF9
      F6FFFBF8F6FFFBF8F5FFFBF7F4FFFAF6F4FFFAF5F1FFF9F4EFFFF9F3EDFFF8F2
      EBFFF8F0E9FFFCF4EBFFA6A099FE0000000039352CFFFAFAF8FFF9F8F5FFFAFA
      F8FFF9F9F6FFFAF9F6FFF9F9F7FFF9F8F7FFF8F8F5FFF5F4F1FF5252C2FF1D1D
      D6FF6060E5FF2929EEFF5656D6FF4C4940FF0000000000000024000082FF0606
      A5FF0808A5FF00003BCA00000008000000000000000000000005000047C81010
      BDFF1010BAFF01019DFF000000310000000000000000A4A4A4FEF2F1EDFFF8F8
      F1FFF6F6F4FFF8F9F5FFFDFDFDFFFBFBF9FFFDFDFDFFFBFBFAFFFDFDFDFFFBFB
      FAFFFEFEFEFF79746BFF615C57FF0000000000000000A6A19BFEFEFEFEFF807A
      72FF817A72FFFCFAF8FF462B0BFF462B0BFF462B0BFF462B0BFF462B0BFF462B
      0BFF462B0BFFFEF5EDFFA7A099FE000000003C352CFFFAFAF8FFFAFAF7FFFAF9
      F7FFFAF9F7FFF8F8F5FFF9F8F5FFF9F8F4FFF7F7F4FFF6F6F2FFF2F2EDFF5959
      D0FF2020DBFF5A5ADBFFEDECE7FF3D362DFF0000000000007DFF03039FFF0808
      ACFF0F0FB8FF0E0EB4FF00003FCA000000080000000500004AC81515CDFF1919
      CDFF1313C2FF0F0FB7FF01019BFF0000000400000000A9A8A6FEF9F9F5FFFEFC
      FDFFF8F8F5FFFEFBFBFFFBFAFAFFFBFAF9FFFBFBF9FFF9F9F8FFF9F9F8FFFCFA
      FAFFFEFEFEFF756F66FF615C53FF0000000000000000A6A19CFEFEFEFEFFF0EE
      EDFF8A847DFFFCFBFAFF462B0BFF462B0BFF462B0BFF462B0BFF462B0BFF462B
      0BFF462B0BFFFDF6F0FFA7A09AFE000000003F3930FFFBFAF9FFFBFAF8FFF8F7
      F5FFFAFAF7FFF8F8F5FFF8F7F4FFF7F7F3FFF7F6F2FFF3F3EFFF7F7FCBFF4D4D
      CAFF7171D2FF1313C1FF5353C7FF524C44FF00000000000034AF060699FF0A0A
      B1FF1111BEFF1818CBFF1212C3FF000044CA00004AC81818DBFF2323E2FF1D1D
      D4FF1616C9FF0B0BB5FF000044C70000000000000000A8A6A4FDC0E1C8FFF0EE
      E8FFF9F6F4FFF8F8F4FFFAF9F8FFF9F9F7FFFEFBFAFFE5F3E6FFFDF9F9FFFEFE
      FEFFFEFDFCFF736B61FF5F5851FF0000000000000000A6A39BFEFEFEFEFF9B95
      8FFF928C83FFFDFDFDFFFDFCFDFFFCFBFAFFFCFAF8FFFBF8F5FFFAF7F3FFFAF5
      F1FFF9F4EEFFFDF7F0FFA7A09AFE00000000433E33FFFBFBF9FFFBFAF9FFFBF9
      F7FFFAF9F6FFFAFAF7FFF7F7F3FFF7F6F2FFF6F5F1FF9494CBFF6B6BC3FF8787
      CCFFEFEEE9FF7676CBFF3434B2FF6363BDFF0000000000000000000038AF0707
      A4FF1212C1FF1919CEFF2020DDFF1616D2FF1A1ADFFF2C2CF5FF2626E6FF1E1E
      D9FF0F0FC3FF000049C7000000000000000000000000A6A4A0FD6AAB6CFF37AC
      55FF84CA94FFFEF9FAFFFCFAF9FFF7F6F3FFF5F2EDFF3D9F4FFF39984FFF3199
      49FFF2F8F3FF70675AFF5B554CFF0000000000000000A6A29BFEFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFCFCFFFCFBFAFFFCF9F7FFFBF8F5FFFAF6
      F2FFF9F4EFFFFEF8F3FFA7A09AFE000000004C463BFFFCFBFAFFFBFBF9FFFBFA
      F8FFF7F7F3FFFAF9F8FFFAF9F6FFF6F5F2FFF6F5F0FFDFDEE2FF9D9DCEFFF1F0
      EAFFF1F0EBFFEDEBE5FF7B7BC3FF6D696EFF0000000000000000000000000000
      3AAF0A0AADFF1A1ACEFF2020DAFF2626E7FF2B2BF1FF2A2AEFFF2525E5FF1010
      CCFF00004BC700000000000000000000000000000000A4A19DFDF3F0E8FFF4EA
      E6FF41A058FFB9D8BBFFEEE4D6FFD59342FF5AAA69FF94C097FFFEF9FAFFFEF8
      F7FFFBF9F5FF6B6255FF5C554CFF0000000000000000A6A29BFEFEFEFEFF756E
      65FF7B746DFFFEFEFEFF633B0BFF603A0BFF5D380BFF5A360BFF58350BFF5533
      0BFF52320BFFFEFAF3FFA7A199FE00000000595349FFFCFBFAFFFCFBFAFFFBFB
      F9FFFAFBF7FFF7F7F4FFF9F9F7FFF9F8F6FFF5F5F0FFF4F4EFFFF4F3EEFFF3F1
      EBFFEEEDE5FFEDECE4FFECEAE1FF575348FF0000000000000000000000000000
      000000003DB00B0BB4FF1C1CD4FF2121DEFF2424E4FF2525E3FF1111CCFF0000
      4CC70000000000000000000000000000000000000000A59E99FDF3F0EAFFF8F2
      EEFFF8F1EEFF249945FFC28A46FFEDE3D7FF25791DFFDBB383FFF5F1EFFFF5F3
      F0FFF7F6F1FF685D4FFF5B5349FF0000000000000000A6A29BFEFEFEFEFFDCDA
      D8FF96918AFFFEFEFEFF663D0BFF643C0BFF613A0BFF5E380BFF5B370BFF5835
      0BFF55340BFFFEF9F4FFA7A199FE0000000068635BFFFCFCFBFFFCFBFAFFFCFB
      FAFFFBFBF9FFF8F7F6FFFAF9F5FFFAF9F6FFF8F8F6FFF4F3EEFFF4F3EDFFEEED
      E5FFEDEBE3FFEBEAE0FFE9E8DDFF686259FF0000000000000000000000000000
      0004000036B64242C5FF1818CBFF1B1BD2FF1D1DD6FF1D1DD5FF1313C7FF0000
      4ED80000000A00000000000000000000000000000000A39D98FCF2EFE6FFEEEC
      E6FFEFECE6FFBCB081FF539343FF81BB88FFD1D8C5FFC68D48FFCDA87AFFF6F3
      EFFFF8F6F1FF655A4BFF595146FF0000000000000000A6A29BFEFEFEFEFF9D98
      90FF7D766EFFFEFEFEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFCFDFFFCFAF9FFFBF8
      F6FFFAF7F3FFFEFBF6FFA7A19BFE0000000078756CFFFCFCFBFFFCFCFAFFFCFB
      FAFFFBFBF9FFFBFAF9FFF6F5F1FFFAF9F7FFF9F8F6FFF7F6F2FFEDEBE3FFECEA
      E1FFEAE9DFFFE9E7DCFFE7E5DAFF78746BFF0000000000000000000000040000
      32B65454C0FF4C4CC9FF4747CDFF4242D0FF1616C8FF1616C7FF1414C3FF0E0E
      B9FF00004AD80000000A000000000000000000000000A09A95FCC48A40FFDBC0
      9BFFEAE5D8FFC28B4BFFC1E3CAFF439345FFFDF5F2FFEDECE5FFE7D8C4FFC089
      46FFF9F9F5FF615444FF574E43FF0000000000000000A6A29BFEFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFDFEFCFFFCFBF9FFFBF9
      F6FFFAF7F3FFFEFAF5FFA7A09AFE00000000817C73FFFDFDFCFFFCFCFBFFFCFC
      FBFFFCFCFAFFFBFBF9FFFAFBF9FFF4F3EEFFF5F4EFFFF4F3EDFFF3F1ECFFEBE9
      E0FFE8E6DBFFE6E4D9FFE5E3D6FF807C73FF000000000000000400002EB66666
      C0FF5959C2FF5555C5FF5050C9FF4A4AC3FF4444C2FF4141C8FF1C1CBBFF0A0A
      B0FF0909A9FF000046D80000000A00000000000000009D968FFCEAE8E0FFDCBD
      96FFBA863EFFE3E0D4FFEFEBE4FFF0EFE9FFF0EEE8FFF4F3EFFFF1F0EAFFF5EF
      E6FFF7F3ECFF5E503FFF564D41FF0000000000000000A6A29BFEFEFEFEFFFEFE
      FEFF7D766EFFFEFEFEFF78470BFF78470BFF78470BFF78470BFF78470BFF7847
      0BFF77470BFFFEFAF7FFA7A09AFE0000000087817CFFFDFDFCFFFDFDFCFFFCFC
      FBFFFCFCFAFFF9F8F6FFF6F5F1FFF4F4EFFFE8E7DCFFF3F2EDFFF2F1EBFFF1EF
      E9FFEFEDE5FFE4E1D4FFE2E0D2FF86817AFF00000000000029B67A7AC1FF6B6B
      C3FF6464C0FF5E5EC2FF5D5DC0FF00003FC700003DAF4949BEFF3D3DBCFF3434
      B5FF2929ADFF2727A8FF000040D80000000300000000999289FCEEECE5FFEFED
      E6FFEFEDE5FFF3EEE8FFF4F0EBFFF2F0EAFFF6F2EEFFF1F0E9FFF5F0EBFFF7F4
      F0FFF3F0E9FF594A38FF544A3EFF0000000000000000A6A29BFEFEFEFEFFF9F8
      F8FF7D766EFFFEFEFEFF78470BFF78470BFF78470BFF78470BFF78470BFF7847
      0BFF78470BFFFEFAF7FFA7A09AFE000000008C8883FFFBFBF9FFF9F9F7FFF8F9
      F6FFF9F8F5FFF7F6F4FFF6F5F1FFF5F5F0FFF3F2ECFFE5E3D6FFEFEEE7FFF1EF
      E8FFEFEEE6FFEDECE3FFE2DFD0FF8B8782FF00000000000067FF8080C7FF7878
      C8FF7171C6FF7272C1FF00003AC70000000000000000000038AF4D4DB9FF3D3D
      B1FF3636AEFF3030A5FF010184FF0000000100000000989186FBF2EAE0FFEEE7
      DFFFF0EAE1FFF0E9E1FFEDE7DDFFF1ECE3FFF0EAE0FFF1EBE1FFF1EAE0FFECE4
      DAFFE5DDD1FF554632FF504538FF0000000000000000A6A29BFEFEFEFEFFC5C2
      BDFF8A837CFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFDFDFEFFFCFBFAFFFBFA
      F8FFFBF7F4FFFEFAF5FFA7A09AFE00000000928E89FFA2937FFFA49782FFAA9D
      8BFFAFA494FFB6AB9BFFBCB2A3FFBEB4A6FFBDB3A5FFB8AE9EFFB0A793FFAEA3
      8EFFA79D88FF7871C4FF6D66C2FF928E89FF000000000000000100006BFF8686
      C9FF8787C5FF000035C700000000000000000000000000000000000038AF5353
      B2FF4545AAFF020283FF0000000D00000000000000009A9084FAE7DBCEFFD5CB
      BCFFC8BEAFFFC2B7A7FFBCB1A0FFB2A596FFA59888FF968979FF877C6CFF8076
      66FF837B6CFF878478F95C564DD20000000000000000A9A49EFEFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FDFFFEFDFAFFFEFEFBFFA8A39DFE0000000063605EBCC1B7A9FFC3BAABFFC7BE
      B0FFCBC3B5FFD0C7BCFFD4CBC1FFD4CDC3FFD3CDC3FFD0C8BEFFBFB7AAFFBEB5
      A7FFB8AE9EFFB9AF99FFB6AB96FF7A7976ED0000000000000000000000010000
      67FF000030C70000000000000000000000000000000000000000000000000000
      34AF02027CFF0000000D0000000000000000000000003B37338A514B46D88077
      6BFB736B60E4615952CA4D4841B0403A369735312D7D2A2723641F1D1A491412
      10300808071601000002000000000000000000000000817D77DCA49E98FEA29C
      96FEA29C96FEA29C96FEA29C96FEA29C96FEA29D96FEA29B97FEA39C95FEA19C
      96FEA19B96FEA39D97FE827C77DC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF018001FF9CE7E7F00180010000C3C3
      800180010000818180018001000080008001800100008001800180010000C003
      800180010000E007800180010000F00F800180010000E007800180010000C003
      80018001000080018001800100008000800180010000818080018001000083C1
      800180010000C7E380038001FFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object MMMain: TMainMenu
    Left = 512
    Top = 64
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Action = actExit
        ShortCut = 16453
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
    object N4: TMenuItem
      Caption = '&Display'
      object N5: TMenuItem
        Action = acDisChart
      end
      object N6: TMenuItem
        Action = acDisLogging
      end
    end
    object N3: TMenuItem
      Caption = '&Option'
      object T1: TMenuItem
        Caption = '&Timer'
        object N11: TMenuItem
          Caption = '1 Second'
          Checked = True
          RadioItem = True
          OnClick = N11Click
        end
        object N21: TMenuItem
          Caption = '2 Second'
          RadioItem = True
          OnClick = N21Click
        end
        object N51: TMenuItem
          Caption = '5 Second'
          RadioItem = True
          OnClick = N51Click
        end
        object N12: TMenuItem
          Caption = '10 Second'
          RadioItem = True
          OnClick = N12Click
        end
      end
    end
    object A2: TMenuItem
      Caption = '&About'
      object actAbout1: TMenuItem
        Action = actAbout
      end
      object N2: TMenuItem
        Caption = '-'
      end
    end
  end
  object ActionList1: TActionList
    Left = 513
    Top = 16
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
    object acDisChart: TAction
      Category = 'Display'
      Caption = '&Chart'
      ShortCut = 16451
      OnExecute = acDisChartExecute
    end
    object acDisLogging: TAction
      Category = 'Display'
      Caption = '&Logging'
      ShortCut = 16460
      OnExecute = acDisLoggingExecute
    end
  end
end
