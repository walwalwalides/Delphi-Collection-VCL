{ ============================================
  Software Name : 	MySQL_StoreProc
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit ULog;

interface

uses
  System.Classes,
  System.SysUtils;

type

  IMySQLDataBase = interface
    procedure Connect;
    procedure Disconnect;
    procedure Insert(const AppID : Integer; const EventMsg : string; EventType : Byte = 0);
  end;

  TMySQLLog = class
  private
    FEnabled : Boolean;
    Fdb : IMySQLDataBase;
    FAppID : Byte;
  public
    constructor Create(const AppID : Byte; DB : IMySQLDataBase);
    procedure Write(const EventMsg : string; EventType : Byte = 0);
    property Enabled : Boolean read FEnabled write FEnabled;
  end;

implementation

{ TErrLog }

constructor TMySQLLog.Create(const AppID : Byte; DB : IMySQLDataBase);
begin
  FEnabled := True;
  FAppID := AppID;
  Fdb := DB;
end;

procedure TMySQLLog.Write(const EventMsg: string; EventType: Byte);
begin
  if FEnabled then Fdb.Insert(FAppID, EventMsg, EventType);
end;

end.
