object DMModule: TDMModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 281
  Width = 494
  object ConnectionMain: TFDConnection
    Params.Strings = (
      'ConnectionDef=MYWALID_MYSQL')
    LoginPrompt = False
    Left = 47
    Top = 86
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\AllServer\mysql\lib\libmysql.dll'
    Left = 16
    Top = 128
  end
  object MySQLWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 40
    Top = 176
  end
  object ProcGetName: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = 'mywalid.GetName'
    Left = 120
    Top = 128
    ParamData = <
      item
        Position = 1
        Name = 'theI'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftString
        ParamType = ptResult
        Size = 20
      end>
  end
  object ProcCounter: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = 'mywalid.Counter'
    Left = 120
    Top = 200
    ParamData = <
      item
        Position = 1
        Name = 'b'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftInteger
        ParamType = ptResult
        Value = 3
      end>
  end
  object FDErrLogConn: TFDConnection
    Params.Strings = (
      'Pooled=False'
      'ConnectionDef=MYWALID_MYSQL')
    LoginPrompt = False
    OnError = FDErrLogConnError
    AfterConnect = FDErrLogConnAfterConnect
    AfterDisconnect = FDErrLogConnAfterDisconnect
    Left = 244
    Top = 88
  end
  object FDErrLogQuery: TFDQuery
    Connection = FDErrLogConn
    SQL.Strings = (
      
        'INSERT INTO LogConnec (APPID,EVN_TYPE,EMSG) VALUES (:APPID, :EVN' +
        '_TYPE, :EMSG)')
    Left = 268
    Top = 144
    ParamData = <
      item
        Name = 'APPID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'EVN_TYPE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'EMSG'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDTestConn: TFDConnection
    Params.Strings = (
      'ConnectionDef=MYWALID_MYSQL')
    LoginPrompt = False
    Left = 88
    Top = 48
  end
  object FDTestQuery: TFDQuery
    Connection = FDTestConn
    SQL.Strings = (
      'SELECT COUNT(AIS.SERVER_ID) AS AROWS FROM ASI_IN_SERVER ais;'
      
        'SELECT COUNT(aiso.SERVER_ID) AS AROWS FROM ASI_IN_SERVER_OPERATI' +
        'ONS aiso;')
    Left = 176
    Top = 48
  end
end
