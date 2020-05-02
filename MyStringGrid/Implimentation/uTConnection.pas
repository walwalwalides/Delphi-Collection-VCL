{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit uTConnection;

interface

uses uIConnection, classes, ZConnection, sysutils, Module;

type
  TConnection = class(TInterfacedObject, IConnection)
  strict private
    FDM: TDMModule;
    FIConnection: IConnection;

  public
    function GetConnection: TZconnection;
    function GetSQL: string;
    constructor create;
    destructor Destroy; override;

  end;

implementation

{ TConnection }

constructor TConnection.create;
begin
  if not assigned(FDM) then
  Begin

    try
      FDM := TDMModule.create(nil);
    finally
      //

    end;

  End;

end;

destructor TConnection.Destroy;
begin
  //
  freeandnil(FDM);
  inherited;
end;

function TConnection.GetConnection: TZconnection;

Begin
  Result := FDM.Connection;
  //
end;

function TConnection.GetSQL: string;
begin
  Result := 'Select * from student'

end;

end.
