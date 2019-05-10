object DMModule: TDMModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 303
  Width = 378
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 49
    Top = 24
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 120
    Top = 24
  end
  object ConnectionMain: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Walid\Desktop\PosDelphi-master\Design Patterns' +
        '\Prototype\DEBUG\Daten\Event.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 80
  end
  object qrEvent: TFDQuery
    Connection = ConnectionMain
    Left = 40
    Top = 128
  end
  object qrCheck: TFDQuery
    Connection = ConnectionMain
    SQL.Strings = (
      'SELECT * FROM EVENT')
    Left = 136
    Top = 104
    object qrCheckID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qrCheckEvtName: TStringField
      FieldName = 'EvtName'
      Origin = 'EvtName'
      Size = 100
    end
    object qrCheckEvtDate: TDateField
      FieldName = 'EvtDate'
      Origin = 'EvtDate'
    end
    object qrCheckEvtTime: TTimeField
      FieldName = 'EvtTime'
      Origin = 'EvtTime'
    end
    object qrCheckEvtColor: TShortintField
      FieldName = 'EvtColor'
      Origin = 'EvtColor'
    end
    object qrCheckEvtDescription: TWideMemoField
      FieldName = 'EvtDescription'
      Origin = 'EvtDescription'
      BlobType = ftWideMemo
    end
  end
end
