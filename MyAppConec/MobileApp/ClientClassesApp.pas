{ ============================================
  Software Name : 	MyAppConec
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit ClientClassesApp;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FGetWorkerIDCommand: TDBXCommand;
    FGetWorkerActiveCommand: TDBXCommand;
    FGetWorkerPositionCommand: TDBXCommand;
    FGetWorkerAddressCommand: TDBXCommand;
    FGetRideRequirementCommand: TDBXCommand;
    FChangeRideStatusCommand: TDBXCommand;
    FMoveRideToArchiveCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function GetWorkerID(AName: string): Integer;
    function GetWorkerPosition(AWorkerID: Integer): string;
    function GetWorkerAddress(AWorkerID: Integer): string;
    function GetWorkerActive(AWorkerID: Integer): Boolean;


    function GetRideRequirement(AWorkerID: Integer): string;
    procedure ChangeRideStatus(AWorkerID: Integer; StatusId: Integer);
    procedure MoveRideToArchive(AWorkerID: Integer);
  end;

implementation

function TServerMethods1Client.GetWorkerID(AName: string): Integer;
begin
  if FGetWorkerIDCommand = nil then
  begin
    FGetWorkerIDCommand := FDBXConnection.CreateCommand;
    FGetWorkerIDCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetWorkerIDCommand.Text := 'TServerMethods.GetWorkerID';
    FGetWorkerIDCommand.Prepare;
  end;
  FGetWorkerIDCommand.Parameters[0].Value.SetWideString(AName);
  FGetWorkerIDCommand.ExecuteUpdate;
  Result := FGetWorkerIDCommand.Parameters[1].Value.GetInt32;
end;

function TServerMethods1Client.GetWorkerActive(AWorkerID: Integer): Boolean;
begin
  if FGetWorkerActiveCommand = nil then
  begin
    FGetWorkerActiveCommand := FDBXConnection.CreateCommand;
    FGetWorkerActiveCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetWorkerActiveCommand.Text := 'TServerMethods.GetWorkerActive';
    FGetWorkerActiveCommand.Prepare;
  end;
  FGetWorkerActiveCommand.Parameters[0].Value.SetInt32(AWorkerID);
  FGetWorkerActiveCommand.ExecuteUpdate;
  Result := FGetWorkerActiveCommand.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.GetWorkerPosition(AWorkerID: Integer): string;
begin
  if FGetWorkerPositionCommand = nil then
  begin
    FGetWorkerPositionCommand := FDBXConnection.CreateCommand;
    FGetWorkerPositionCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetWorkerPositionCommand.Text := 'TServerMethods.GetWorkerPosition';
    FGetWorkerPositionCommand.Prepare;
  end;
  FGetWorkerPositionCommand.Parameters[0].Value.SetInt32(AWorkerID);
  FGetWorkerPositionCommand.ExecuteUpdate;
  Result := FGetWorkerPositionCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.GetWorkerAddress(AWorkerID: Integer): string;
begin
  if FGetWorkerAddressCommand = nil then
  begin
    FGetWorkerAddressCommand := FDBXConnection.CreateCommand;
    FGetWorkerAddressCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetWorkerAddressCommand.Text := 'TServerMethods.GetWorkerAddress';
    FGetWorkerAddressCommand.Prepare;
  end;
  FGetWorkerAddressCommand.Parameters[0].Value.SetInt32(AWorkerID);
  FGetWorkerAddressCommand.ExecuteUpdate;
  Result := FGetWorkerAddressCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.GetRideRequirement(AWorkerID: Integer): string;
begin
  if FGetRideRequirementCommand = nil then
  begin
    FGetRideRequirementCommand := FDBXConnection.CreateCommand;
    FGetRideRequirementCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetRideRequirementCommand.Text := 'TServerMethods.GetRideRequirement';
    FGetRideRequirementCommand.Prepare;
  end;
  FGetRideRequirementCommand.Parameters[0].Value.SetInt32(AWorkerID);
  FGetRideRequirementCommand.ExecuteUpdate;
  Result := FGetRideRequirementCommand.Parameters[1].Value.GetWideString;
end;

procedure TServerMethods1Client.ChangeRideStatus(AWorkerID: Integer; StatusId: Integer);
begin
  if FChangeRideStatusCommand = nil then
  begin
    FChangeRideStatusCommand := FDBXConnection.CreateCommand;
    FChangeRideStatusCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FChangeRideStatusCommand.Text := 'TServerMethods.ChangeRideStatus';
    FChangeRideStatusCommand.Prepare;
  end;
  FChangeRideStatusCommand.Parameters[0].Value.SetInt32(AWorkerID);
  FChangeRideStatusCommand.Parameters[1].Value.SetInt32(StatusId);
  FChangeRideStatusCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.MoveRideToArchive(AWorkerID: Integer);
begin
  if FMoveRideToArchiveCommand = nil then
  begin
    FMoveRideToArchiveCommand := FDBXConnection.CreateCommand;
    FMoveRideToArchiveCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FMoveRideToArchiveCommand.Text := 'TServerMethods.MoveRideToArchive';
    FMoveRideToArchiveCommand.Prepare;
  end;
  FMoveRideToArchiveCommand.Parameters[0].Value.SetInt32(AWorkerID);
  FMoveRideToArchiveCommand.ExecuteUpdate;
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FGetWorkerIDCommand.DisposeOf;
  FGetWorkerActiveCommand.DisposeOf;
  FGetWorkerPositionCommand.DisposeOf;
  FGetWorkerAddressCommand.DisposeOf;
//  ---------------------------------------- //

  FGetRideRequirementCommand.DisposeOf;


  FChangeRideStatusCommand.DisposeOf;
  FMoveRideToArchiveCommand.DisposeOf;
  inherited;
end;

end.
