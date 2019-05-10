{ ============================================
  Software Name : 	RegisterKey
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit ToolLib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, registry;

function CreateKey(RootKey: HKey; const Key: string): Boolean;

function writeRegStringM1(Root: HKey; RootKey, NameKey, ValueKey: string; Atype: ShortInt): Boolean;
function writeRegStringM2(Root: HKey; RootKey, NameKey, ValueKey: string; Atype: ShortInt): Boolean;

function CheckKey(RootKey: HKey; const Key: string): Boolean;
function GenerateRegFile(Root: HKey; RootKey, NameKey, ValueKey: string; Atype: ShortInt): Boolean;

implementation

function CreateKey(RootKey: HKey; const Key: string): Boolean;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create;
    Reg.RootKey := RootKey;
    try
    Reg.CreateKey(Key);
    except
      raise Exception.Create('Can''t create new key');
    end;
  finally
    Reg.CloseKey;
    Reg.Free;

  end;
end;

function writeRegStringM1(Root: HKey; RootKey, NameKey, ValueKey: string; Atype: ShortInt): Boolean;
var
  HK: HKey;
  DW: integer;
begin
  Result := false;
  RegOpenKey(Root, PChar(RootKey), HK); // open the Key

  if HK = 0 then // check if the key exist
    RegCreateKeyEx(Root, PChar(RootKey), 0, nil, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, HK, @DW);

  // RegCreateKey(Root,PChar(chemin),HK);
  try
    case Atype of
      0:
        RegSetValueEx(HK, PChar(NameKey), 0, REG_SZ, PChar(ValueKey), Length(ValueKey));
      1:
        RegSetValueEx(HK, PChar(NameKey), 0, REG_DWORD, @ValueKey.ToInteger, SizeOf(ValueKey.ToInteger));
    end;

  except
    Result := false;
  end;

  RegCloseKey(HK); // close the Key
  Result := True;
end;

function writeRegStringM2(Root: HKey; RootKey, NameKey, ValueKey: string; Atype: ShortInt): Boolean;
var
  Reg: TRegistry;
begin
  try
    Result := false;
    Reg := TRegistry.Create;
    Reg.RootKey := Root;
    if Reg.OpenKey('\' + RootKey, false) then
    begin
      try
        case Atype of
          0:
            Reg.WriteString(NameKey, ValueKey);
          1:
            Reg.WriteInteger(NameKey, StrToInt(ValueKey));
        end;

      except
        Result := false;
      end;
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
    Result := True;
  end;
end;

function CheckKey(RootKey: HKey; const Key: string): Boolean;
var
  registry: TRegistry;
begin
  Result := false;
  registry := TRegistry.Create;
  Try
    registry.RootKey := RootKey;
    Result := registry.OpenKeyReadOnly(Key);
  Finally
    registry.CloseKey;
    registry.Free;
  End;
end;

function GenerateRegFile(Root: HKey; RootKey, NameKey, ValueKey: string; Atype: ShortInt): Boolean;
var
  slstRegFile: TStringList;
  lastPath: String;
  tmpint: integer;
begin
  lastPath := ExtractFilePath(Application.ExeName) + 'RegFile\' + NameKey + '.reg';
  Result := false;
  slstRegFile := TStringList.Create;
  try
    slstRegFile.Add('Windows Registry Editor Version 5.00');
    if (Root = HKEY_CURRENT_USER) then
      slstRegFile.Add('[HKEY_CURRENT_USER\' + RootKey + ']');
    if (Root = HKEY_LOCAL_MACHINE) then
      slstRegFile.Add('[HKEY_LOCAL_MACHINE\' + RootKey + ']');
    case Atype of
      0:
        slstRegFile.Add('"' + NameKey + '"' + ' = ' + '"' + ValueKey + '"');

      1:
        begin
          tmpint:=StrToInt(ValueKey);
          slstRegFile.Add('"' + NameKey + '"' + ' =dword:' + IntToHex(tmpint,8));
        end;

    end;

    try
      slstRegFile.SaveToFile(lastPath);
    except
      Result := false;
    end;
  finally
    slstRegFile.Free;
    Result := True;
  end;

end;

end.
