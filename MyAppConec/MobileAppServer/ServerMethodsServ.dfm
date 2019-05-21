object ServerMethods: TServerMethods
  OldCreateOrder = False
  OnCreate = DSServerModuleCreate
  Height = 628
  Width = 570
  object ConnectionMain: TFDConnection
    Params.Strings = (
      'ConnectionDef=MYWALID_MYSQL')
    Connected = True
    LoginPrompt = False
    Left = 337
    Top = 262
  end
  object ProcGetActive: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = 'mywalid.GetActive'
    Left = 89
    Top = 515
    ParamData = <
      item
        Position = 1
        Name = 'AWorkID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftBoolean
        ParamType = ptResult
      end>
  end
  object ProcGetAdress: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = 'mywalid.GetAdress'
    Left = 209
    Top = 498
    ParamData = <
      item
        Position = 1
        Name = 'AWorkID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftString
        ParamType = ptResult
        Size = 255
      end>
  end
  object FncgetriderequirementProc: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = '"fncGetRideRequirement"'
    Left = 268
    Top = 28
    ParamData = <
      item
        Position = 1
        Name = 'arg_ride_id'
        DataType = ftInteger
        FDDataType = dtInt32
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftInteger
        FDDataType = dtInt32
        ParamType = ptResult
      end>
  end
  object ProcGetPosition: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = 'mywalid.GetPosition'
    Left = 160
    Top = 299
    ParamData = <
      item
        Position = 1
        Name = 'AWorkID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftString
        ParamType = ptResult
        Size = 20
        Value = Null
      end>
  end
  object qrWorkerInfo: TFDQuery
    Connection = ConnectionMain
    SQL.Strings = (
      'SELECT * FROM tWorkerInfo')
    Left = 75
    Top = 383
  end
  object qrWorkerStatus: TFDQuery
    Connection = ConnectionMain
    SQL.Strings = (
      'SELECT * FROM tWorkerStatus')
    Left = 336
    Top = 443
  end
  object DSPWorkerInfo: TDataSetProvider
    DataSet = qrWorkerInfo
    Left = 464
    Top = 336
  end
  object DSPWorkerStatus: TDataSetProvider
    DataSet = qrWorkerStatus
    Left = 448
    Top = 400
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 280
    Top = 208
  end
  object tmpScript: TFDScript
    SQLScripts = <>
    Connection = ConnectionMain
    Params = <>
    Macros = <>
    Left = 256
    Top = 380
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\AllServer\mysql\lib\libmysql.dll'
    Left = 56
    Top = 272
  end
  object ProcGetWorkID: TFDStoredProc
    Connection = ConnectionMain
    StoredProcName = 'mywalid.GetWorkID'
    Left = 49
    Top = 459
    ParamData = <
      item
        Position = 1
        Name = 'AName'
        DataType = ftString
        ParamType = ptInput
        Size = 40
      end
      item
        Position = 2
        Name = 'result'
        DataType = ftInteger
        ParamType = ptResult
      end>
  end
end
