{ ============================================
  Software Name : 	MySQL_StoreProc
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit UConfig;


interface

uses
  System.SysUtils, System.Classes, IniFiles;

const

  FILECFG = 'MySQL.dat';
  APP_INI = 'MySQL_StoreProc';
  MySQL_INI = 'MySQL';
  SRV_INI = 'SrvC';

type
  TSrvcConf = packed record
    HostName      : string;
    Port          : word;
    RetryCount    : byte;  // is Work Propery
    AutoReconnect : Boolean; // is Work Propery
    TimeOut       : Byte;   // TimeOut
  end;

  TMySQLConf = packed record
    DataBase  : string;
    UserName  : string;
    Password  : string;
    CharSet   : string;
    VendorLib : string;
    procedure SetUserName (const usrName : string);
    procedure SetPassWord (const usrPass : string);
  end;

  TAppConfig = packed record
  private
    FSrvC       : TSrvcConf;
    FMySQL        : TMySQLConf;
    FDefSettings: Boolean;
    procedure SetMySQL(const Value: TMySQLConf);
    procedure SetSrvC(const Value: TSrvcConf);
  public
    procedure GetDefConfig;
    procedure LoadFromFile(const FileName : string = FILECFG);
    procedure Save;
    property SrvC : TSrvcConf read FSrvC write SetSrvC;
    property MySQL : TMySQLConf read FMySQL write SetMySQL;
    property isDefSettings : Boolean read FDefSettings;
  end;

var
  PAppConf : TAppConfig;

implementation

{ TAppConfig }

uses
  Vcl.Forms;

procedure TAppConfig.GetDefConfig;
begin
  FDefSettings := True;
  FSrvC.hostname  := '127.0.0.1';
  FSrvC.port      := 3306;
  FSrvC.RetryCount:= 3;
  FSrvC.AutoReconnect := False;
  FSrvC.TimeOut   := 120; //sec

  FMySQL.DataBase := 'MYWALID';
  FMySQL.UserName := 'walid';
  FMySQL.Password := 'walid';
  FMySQL.CharSet  := '_.UTF8';
  FMySQL.VendorLib:= 'C:\AllServer\mysql\lib\libmysql.dll';

end;

procedure TAppConfig.LoadFromFile(const FileName: string);
const DEFCRC12 = '3127';
var
  f : TIniFile;
  fn : string;
  s : TStringBuilder;

  FCfgCheckSum : String;

  function GetCRC12 : String;
  begin
    Result := IntToStr( Random(600000000) );
  end;




begin

  s := TStringBuilder.Create(ExtractFileDir( Application.ExeName ));
  s.Append(fn);
  s.Append('\');
  s.Append(FileName);
  fn := s.ToString;
  s.Free;

  if FileExists(fn) then
  begin

    f := TIniFile.Create(fn);
    try

      FCfgCheckSum    := f.ReadString(APP_INI, 'MyConnec', DEFCRC12 );

      FSrvC.hostname  := f.ReadString(SRV_INI, 'host','127.0.0.1');
      FSrvC.port      := f.ReadInteger(SRV_INI, 'port',3306);

      FMySQL.DataBase   := f.ReadString(MySQL_INI, 'database','MYWALID');
      {FOra.CharSet    := f.ReadString(ORA_INI, 'charset','_.UTF8');}
      FDefSettings := False;
      if FCfgCheckSum = DEFCRC12 then
      begin
        Randomize;
        FCfgCheckSum  := GetCRC12;
      end;

    finally
      f.Free;
    end;
    //if UpdateParam then SaveIni(fn);
  end
    else
    begin
      //SaveIni(fn);
      Save;
    end;
end;

procedure TAppConfig.Save;
var
  f : TIniFile;
  fn : string;
  s : TStringBuilder;

  FCfgCheckSum : String;

  function GetCRC12 : String;
  begin
    Result := IntToStr( Random(600000000) );
  end;

begin

  s := TStringBuilder.Create(ExtractFileDir( Application.ExeName ));
  s.Append(fn);
  s.Append('\');
  s.Append(FILECFG);
  fn := s.ToString;
  s.Free;

  if FileExists(fn) then DeleteFile(fn);

  f := TIniFile.Create(fn);
  try
    FCfgCheckSum := GetCRC12;

    f.WriteString(APP_INI,'MyConnec',FCfgCheckSum);

    f.WriteString(SRV_INI, 'host',FSrvC.hostname);
    f.WriteInteger(SRV_INI, 'port',FSrvC.port);

    f.WriteString(MySQL_INI, 'database',FMySQL.DataBase);
    {f.WriteString(ORA_INI, 'charset',FOra.CharSet);}

  finally
    f.Free;
  end;
end;

procedure TAppConfig.SetMySQL(const Value: TMySQLConf);
begin
  FMySQL := Value;
end;

procedure TAppConfig.SetSrvC(const Value: TSrvcConf);
begin
  FSrvC := Value;
end;

{ TOraConf }

procedure TMySQLConf.SetPassWord(const usrPass: string);
begin
  Password := usrPass;
end;

procedure TMySQLConf.SetUserName(const usrName: string);
begin
  UserName := usrName
end;

initialization

  PAppConf.GetDefConfig;
  PAppConf.LoadFromFile;

end.
