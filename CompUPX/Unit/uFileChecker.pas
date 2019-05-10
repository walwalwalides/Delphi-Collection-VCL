{ ============================================
  Software Name : 	CompUPX
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uFileChecker;

interface

type
  TFileInformation = record
    FileName: string;
    FileSize: Int64;
    DataModified: TDateTime;
    FileType: string;
    CPU: string;
    CompilerName: string;
    SKU: string;
  public
    procedure Clear;
  end;

  TResourceInformation = record
    ResourceIsFDM: Boolean;
    ResourceContainsLCLVersion: Boolean;
  end;


function FileIsInteresting(const AFileName: string; var AFileDetails: TFileInformation): Boolean;

implementation

uses
  System.SysUtils, Winapi.Windows, System.Classes,
  uFileUtils;

function CheckCompiler(const AFileName: string; var ACompilerName, ASKUName: string): Boolean; forward;
function CheckDFMResource(ALibraryHandle: Cardinal; const AResourceName: string): TResourceInformation; forward;
function CheckDVCLAL(ALibraryHandle: Cardinal; var ACompilerName, ASKUName: string): Boolean; forward;
function CheckForLazarusForm(AResourceStream: TResourceStream): Boolean; forward;
function CheckPackageInfo(ALibraryHandle: Cardinal; var ACompilerName: string): Boolean; forward;
function CheckPE(const AFileName: string; var ACPU: string): Boolean; forward;


// TFileInformation
// ============================================================================
procedure TFileInformation.Clear;
begin
  FileName := '';
  FileSize := -1;
  DataModified := 0;
  FileType := '';
  CPU := '';
  CompilerName := '';
  SKU := '';
end;


// ----------------------------------------------------------------------------
procedure PackageInfoCallbackProc(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
begin
  // Intentionaly left empty
end;

// ----------------------------------------------------------------------------
function EnumRCDataCallbackProc(HMODULE: THandle; lpszType, lpszName: PChar; list: TStrings): Boolean; stdcall;
begin
  list.Add(lpszName);
  Result := True;
end;

// ----------------------------------------------------------------------------
function CheckCompiler(const AFileName: string; var ACompilerName, ASKUName: string): Boolean;
var
  s: string;
  LLibraryHandle: Cardinal;
  LResourceNameList: TStringList;
  LDFMCount: Integer;
  LResourceInformation: TResourceInformation;
begin
  Result := False;

  LLibraryHandle := LoadLibraryEX(PChar(AFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
  if LLibraryHandle <> 0 then
  begin
    try
      if CheckDVCLAL(LLibraryHandle, ACompilerName, ASKUName) then
        Result := True;

      if CheckPackageInfo(LLibraryHandle, ACompilerName) then
        Result := True;

      if not Result then
      begin
        try
          LResourceNameList := TStringList.Create;
          LResourceNameList.CaseSensitive := False;
          LResourceNameList.Sorted := True;
          try
            EnumResourceNames(LLibraryHandle, RT_RCDATA, @EnumRCDataCallbackProc, NativeInt(LResourceNameList));
            LDFMCount := 0;

            for s in LResourceNameList do
            begin
              LResourceInformation := CheckDFMResource(LLibraryHandle, s);

              if LResourceInformation.ResourceIsFDM then
                Inc(LDFMCount);

              if LResourceInformation.ResourceContainsLCLVersion then
              begin
                ACompilerName := 'Lazarus';
                Result := True;
                Break;
              end;
            end;

            if not Result and (LResourceNameList.IndexOf('DVCLAL') >= 0) then
            begin
              ACompilerName := 'Delphi or C++ Builder (has DVCLAL)';
              ASKUName := 'Unreadable';
              Result := True;
            end;

            if not Result and (LResourceNameList.IndexOf('PACKAGEINFO') >= 0) then
            begin
              ACompilerName := 'Delphi or C++ Builder (has PACKAGEINFO)';
              Result := True;
            end;

            if not Result and (LDFMCount > 0) then
            begin
              ACompilerName := 'Delphi or C++ Builder (has DFM)';
              Result := True;
            end;
          finally
            LResourceNameList.Free;
          end;

        except
         //
        end;
      end;

    finally
      FreeLibrary(LLibraryHandle);
    end;
  end;
end;

// ----------------------------------------------------------------------------
function CheckDFMResource(ALibraryHandle: Cardinal; const AResourceName: string): TResourceInformation;
var
  LResourceStream: TResourceStream;
  LBuffer: TBytes;
begin
  Result.ResourceIsFDM := False;
  Result.ResourceContainsLCLVersion := False;

  try
    LResourceStream := TResourceStream.Create(ALibraryHandle, AResourceName, RT_RCDATA);
    try
      SetLength(LBuffer, 4);
      LResourceStream.Read(LBuffer[0], Length(LBuffer));
      if StringOf(LBuffer) = 'TPF0' then
      begin
        Result.ResourceIsFDM := True;

        Result.ResourceContainsLCLVersion := CheckForLazarusForm(LResourceStream);
      end;
    finally
      LResourceStream.Free;
    end;
  except
  end;
end;

// ----------------------------------------------------------------------------
function CheckDVCLAL(ALibraryHandle: Cardinal; var ACompilerName, ASKUName: string): Boolean;
const
  SKU_PER: TBytes = [$23, $78, $5D, $23, $B6, $A5, $F3, $19, $43, $F3, $40, $02, $26, $D1, $11, $C7];
  SKU_PRO: TBytes = [$A2, $8C, $DF, $98, $7B, $3C, $3A, $79, $26, $71, $3F, $09, $0F, $2A, $25, $17];
  SKU_ENT: TBytes = [$26, $3D, $4F, $38, $C2, $82, $37, $B8, $F3, $24, $42, $03, $17, $9B, $3A, $83];
var
  LBuffer: TBytes;
  LResourceSize: Integer;
  LResourceStream: TResourceStream;
begin
  Result := False;
  ASKUName := '';

  try
    LResourceStream := TResourceStream.Create(ALibraryHandle, 'DVCLAL', RT_RCDATA); // load resource in memory
    try
      LResourceSize := LResourceStream.Size;
      SetLength(LBuffer, LResourceSize);
      LResourceStream.Read(LBuffer[0], Length(LBuffer));
    finally
      LResourceStream.Free;
    end;

    if LResourceSize > 0 then
    begin
      Result := True;
      ACompilerName := 'Delphi or C++ Builder';

      if CompareMem(LBuffer, SKU_ENT, LResourceSize) then
        ASKUName := 'Enterprise'
      else
        if CompareMem(LBuffer, SKU_PRO, LResourceSize) then
        ASKUName := 'Professional'
      else
        if CompareMem(LBuffer, SKU_PER, LResourceSize) then
        ASKUName := 'Personal'
      else
        ASKUName := 'Unknown';
    end;
  except
    Result := False;
  end;
end;

// ----------------------------------------------------------------------------
function CheckForLazarusForm(AResourceStream: TResourceStream): Boolean;
var
  LDFMStream: TMemoryStream;
  LDFM: TStringList;
begin
  Result := False;

  LDFMStream := TMemoryStream.Create;
  try
    AResourceStream.Seek(0, 0);
    ObjectBinaryToText(AResourceStream, LDFMStream);
    LDFMStream.Seek(0, 0);
    LDFM := TStringList.Create;
    try
      LDFM.LoadFromStream(LDFMStream);
      if Pos('LCLVersion', LDFM.Text) <> 0 then
      begin
        Exit(True);
      end;
    finally
      LDFM.Free;
    end;
  finally
    LDFMStream.Free;
  end;
end;

// ----------------------------------------------------------------------------
function CheckPackageInfo(ALibraryHandle: Cardinal; var ACompilerName: string): Boolean;
var
  LPackageFlags: Integer;
begin
  Result := False;

  try
    GetPackageInfo(ALibraryHandle, nil, LPackageFlags, PackageInfoCallbackProc);
    Result := True;

    if (LPackageFlags and pfProducerMask = pfV3Produced) then
      ACompilerName := 'Delphi pre-V4'
    else
      if (LPackageFlags and pfProducerMask = pfDelphi4Produced) then
      ACompilerName := 'Delphi'
    else
      if (LPackageFlags and pfProducerMask = pfBCB4Produced) then
      ACompilerName := 'C++ Builder'
    else
      if (LPackageFlags and pfProducerMask = pfProducerUndefined) then
      ACompilerName := 'Delphi or C++ Builder (undefined flag)';
  except
    // ACompilerName left as-is
  end;
end;

// ----------------------------------------------------------------------------
function CheckPE(const AFileName: string; var ACPU: string): Boolean;
var
  LBase: Pointer;
  LHandle, LMap: HWND;
  LDosHeader: PImageDosHeader;
  LImageNTHeader32: PImageNtHeaders32;
begin
  Result := False;
  ACPU := '';

  LHandle := CreateFile(PChar(AFileName), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  if LHandle = INVALID_HANDLE_VALUE then
  begin
    // raise Exception.Create('Unable to open file: ' + SysErrorMessage(GetLastError));
    Exit;
  end;

  try
    LMap := CreateFileMapping(LHandle, nil, PAGE_READONLY, 0, 0, nil);

    if (LMap = 0) then
    begin
      Exit;
    end;

    try
      if (GetLastError() = ERROR_ALREADY_EXISTS) then
      begin
        // raise Exception.Create('Mapping already exists - not created.');
        Exit;
      end;

      LBase := MapViewOfFile(LMap, FILE_MAP_READ, 0, 0, 0);
      if (LBase = nil) then
      begin
        Exit;
      end;
      try
        try
          LDosHeader := PImageDosHeader(LBase);

          if LDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then
          begin
            // raise Exception.Create('Invalid DOS header signature');
            Exit;
          end;

          LImageNTHeader32 := PImageNtHeaders32(Pointer(Integer(LBase) + LDosHeader._lfanew));

          // All .Net assemblies are PE files
          // http://www.codeguru.com/cpp/w-p/dll/openfaq/article.php/c14001/Determining-Whether-a-DLL-or-EXE-Is-a-Managed-Component.htm
          if (LImageNTHeader32.Signature = IMAGE_NT_SIGNATURE) and (LImageNTHeader32.OptionalHeader.Magic = $10B) then
          begin
            if LImageNTHeader32.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR].VirtualAddress <> 0 then
            begin
              // No need to check .Net assemblies
              Exit;
            end;
          end;

          case LImageNTHeader32.OptionalHeader.Magic of
            $10B:
              ACPU := '32 bit';
            $20B:
              ACPU := '64 bit';
            $107:
              ACPU := 'ROM Image';
          else
            ACPU := 'Unknown';
          end;

          Result := True;
        except
          Exit;
        end;
      finally
        if LHandle <> 0 then
        begin
          UnmapViewOfFile(LBase);
        end;
      end;
    finally
      CloseHandle(LMap);
    end;
  finally
    CloseHandle(LHandle);
  end;
end;

// -------------------------------Get All Data Info File---------------------------------------------
function FileIsInteresting(const AFileName: string; var AFileDetails: TFileInformation): Boolean;
var
  LCompilerName: string;
  LSKUName: string;
  LCPU: string;
  LAttributeData: TWin32FileAttributeData;
begin
  Result := True;

  AFileDetails.Clear;
  AFileDetails.FileName := AFileName;

  if not CheckPE(AFileName, LCPU) then
    Exit(False);

  AFileDetails.CPU := LCPU;

  if not CheckCompiler(AFileName, LCompilerName, LSKUName) then
    Exit(False);

  AFileDetails.CompilerName := LCompilerName;
  AFileDetails.SKU := LSKUName;

  AFileDetails.FileType := GetFileTypeName(AFileName);

  if GetFileAttributesEx(PChar(AFileName), GetFileExInfoStandard, @LAttributeData) then
  begin
    Int64Rec(AFileDetails.FileSize).Lo := LAttributeData.nFileSizeLow;
    Int64Rec(AFileDetails.FileSize).Hi := LAttributeData.nFileSizeHigh;
    AFileDetails.DataModified := FileTimeToDateTime(LAttributeData.ftLastWriteTime);
  end;
end;

end.
