{ ============================================
  Software Name : 	MySQL_StoreProc
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit URegConfig;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, Winapi.Windows, Registry;

const
  REGPSYNCKEY = 'Software\\MyProg\\MySQL_StoreProc\\';

type
  TParamValue = (
    BoolType  = 1,
    IntType   = 2,
    DoubleType= 3,
    StrType   = 4
  );

  TRegParamValue = packed record
    ValueType : TParamValue;
    Value : String;
  end;

  TRegParams = TDictionary<String,TRegParamValue>;

  TRegConfig = class
  private
    FPSyncReg   : TRegistry;
    FAppPath    : string;
    FAppFileCfg : string;
    FParams : TRegParams;
    procedure RegVerify;
    procedure SetDefValues;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReadParams;
    procedure UpdateParam(const ParamName : String; const ParamValue : TRegParamValue);
    procedure Clear;
    property Params : TRegParams read FParams;
    property AppPath : string read FAppPath write FAppPath;
    property AppFileCfg : string read FAppFileCfg write FAppFileCfg;
  end;

implementation

{ TRegConfig }

procedure TRegConfig.Clear;
begin
  SetDefValues;
end;

constructor TRegConfig.Create;
const
  FILEAPPDEF = 'MySQL.dat';
var
  RegParamVal : TRegParamValue;
begin
  FParams := TRegParams.Create();

  RegParamVal.ValueType := BoolType;
  RegParamVal.Value := '1';
  FParams.Add('ConfirmExit',RegParamVal);

  RegParamVal.ValueType := BoolType;
  RegParamVal.Value := '0';
  FParams.Add('AutoHideApp',RegParamVal);

  RegParamVal.ValueType := IntType;
  RegParamVal.Value := '5';
  FParams.Add('HideAppAfter',RegParamVal);

  FAppFileCfg := FILEAPPDEF;
  FPSyncReg := TRegistry.Create(KEY_READ);
  FPSyncReg.RootKey := HKEY_CURRENT_USER;

  if not FPSyncReg.KeyExists(REGPSYNCKEY) then
  begin
    FPSyncReg.Access := KEY_WRITE;
    FPSyncReg.OpenKey(REGPSYNCKEY, True);
    FPSyncReg.CloseKey;
  end;



end;

destructor TRegConfig.Destroy;
begin
  FParams.Clear;
  FParams.Free;

  FPSyncReg.Free;
  inherited;
end;



procedure TRegConfig.ReadParams;
var
  ValueParam : TRegParamValue;
  BoolValue : Boolean;
  IntValue  : Integer;
begin
  RegVerify;

  FPSyncReg.Access := KEY_READ;
  FPSyncReg.OpenKey(REGPSYNCKEY, False);


  BoolValue := FPSyncReg.ReadBool('AutoHideApp');

  if FParams.TryGetValue('AutoHideApp', ValueParam) then
  begin
    if BoolValue then
    begin
      ValueParam.Value := '1';
      FParams.AddOrSetValue('AutoHideApp',ValueParam);
    end
      else
        begin
          ValueParam.Value := '0';
          FParams.AddOrSetValue('AutoHideApp',ValueParam);
        end;
  end;

  BoolValue := FPSyncReg.ReadBool('ConfirmExit');

  if FParams.TryGetValue('ConfirmExit', ValueParam) then
  begin
    if BoolValue then
    begin
      ValueParam.Value := '1';
      FParams.AddOrSetValue('ConfirmExit',ValueParam);
    end
      else
        begin
          ValueParam.Value := '0';
          FParams.AddOrSetValue('ConfirmExit',ValueParam);
        end;
  end;

  IntValue := FPSyncReg.ReadInteger('HideAppAfter');

  if FParams.TryGetValue('HideAppAfter', ValueParam) then
  begin
    ValueParam.Value := IntValue.ToString;
    FParams.AddOrSetValue('HideAppAfter', ValueParam);
  end;


end;

procedure TRegConfig.RegVerify;
  procedure SetRegistyMode(const mode : byte = 0);
  begin
    FPSyncReg.CloseKey;
    if mode = 1 then FPSyncReg.Access := KEY_WRITE else FPSyncReg.Access := KEY_READ;
    FPSyncReg.OpenKey(REGPSYNCKEY, False);
  end;

begin

  FPSyncReg.Access := KEY_READ;
  FPSyncReg.OpenKey(REGPSYNCKEY, False);


  if not FPSyncReg.ValueExists('AppPath') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteString('AppPath',FAppPath);
    SetRegistyMode(0);
  end;

  if not FPSyncReg.ValueExists('AppFileConfig') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteString('AppFileConfig',FAppFileCfg);
    SetRegistyMode(0);
  end;

  if FPSyncReg.ValueExists('ConfirmExit') = False then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteBool('ConfirmExit',True);
    SetRegistyMode(0);
  end;

  if not FPSyncReg.ValueExists('AutoHideApp') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteBool('AutoHideApp',False);
    SetRegistyMode(0);
  end;

  if not FPSyncReg.ValueExists('HideAppAfter') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteInteger('HideAppAfter',10);
    SetRegistyMode(0);
  end;

  if not FPSyncReg.ValueExists('DataBaseDef') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteString('DataBaseDef','MYWALID');
    SetRegistyMode(0);
  end;

  if not FPSyncReg.ValueExists('SrvcHostDef') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteString('SrvcHostDef','127.0.0.1');
    SetRegistyMode(0);
  end;

  if not FPSyncReg.ValueExists('SrvcPortDef') then
  begin
    SetRegistyMode(1);
    FPSyncReg.WriteInteger('SrvcPortDef',3306);
    SetRegistyMode(0);
  end;

  FPSyncReg.CloseKey;
end;

procedure TRegConfig.SetDefValues;
begin
  FPSyncReg.DeleteKey(REGPSYNCKEY);
end;

procedure TRegConfig.UpdateParam(const ParamName: String;
  const ParamValue: TRegParamValue);
var
  Value : TRegParamValue;
begin
  FPSyncReg.CloseKey;
  FPSyncReg.Access := KEY_WRITE;
  FPSyncReg.OpenKey(REGPSYNCKEY, False);
  if FParams.TryGetValue(ParamName, Value) then
  begin

    if ParamValue.ValueType = TParamValue.BoolType then
    begin
      if ParamValue.Value = '1' then FPSyncReg.WriteBool(ParamName,True)
        else FPSyncReg.WriteBool(ParamName, False);
    end;

    if ParamValue.ValueType = TParamValue.IntType then
    begin
      FPSyncReg.WriteInteger(ParamName,strtoint(ParamValue.Value));
    end;

  end;

  FPSyncReg.CloseKey;

end;

end.
