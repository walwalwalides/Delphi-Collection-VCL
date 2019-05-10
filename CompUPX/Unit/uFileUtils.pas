{ ============================================
  Software Name : 	CompUPX
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit uFileUtils;

interface

uses
  System.Classes, Winapi.ShellAPI, Winapi.Windows,Tlhelp32;

function FileNameHasExecutableExtension(const AFileName: string): Boolean;
function FileTimeToDateTime(AFileTime: TFileTime): TDateTime;
procedure FindExecutableFiles(ASourceFiles: TStrings; ADestFiles: TStrings);
function GetFileInfo(const AFileName: string): SHFILEINFO;
function GetFileTypeName(const AFileName: string): string;
function processExists(ExeFileName: string): boolean;

implementation

uses
  System.SysUtils, System.IOUtils, System.Types;

// ----------------------------------------------------------------------------
function FileNameHasExecutableExtension(const AFileName: string): Boolean;
const
  EXECUTABLE_FILE_EXTENSIONS = '|.exe|.dll|.bpl|';
begin
  Result := AnsiPos('|' + LowerCase(ExtractFileExt(AFileName)) + '|', EXECUTABLE_FILE_EXTENSIONS) > 0;
end;

// ----------------------------------------------------------------------------
function FileTimeToDateTime(AFileTime: TFileTime): TDateTime;
var
  LModifiedTime: TFileTime;
  LSystemTime: TSystemTime;
begin
  Result := 0;

  if (AFileTime.dwLowDateTime = 0) and (AFileTime.dwHighDateTime = 0) then
    Exit;
  try
    FileTimeToLocalFileTime(AFileTime, LModifiedTime);
    FileTimeToSystemTime(LModifiedTime, LSystemTime);
    Result := SystemTimeToDateTime(LSystemTime);
  except
    Result := Now;
  end;
end;

// ----------------------------------------------------------------------------
procedure FindExecutableFiles(ASourceFiles: TStrings; ADestFiles: TStrings);

  procedure CheckForExecutable(const AFileName: string);
  begin
    if FileNameHasExecutableExtension(AFileName) then
      ADestFiles.Add(AFileName);
  end;

var
  i: Integer;
  LSourceFile: string;
  LDiscoveredFiles: TStringDynArray;
  LFileAttributes: TFileAttributes;
begin
  ADestFiles.Clear;

  for LSourceFile in ASourceFiles do
  begin
    try
      LFileAttributes := TPath.GetAttributes(LSourceFile);
      if (TFileAttribute.faDirectory in LFileAttributes) then
      begin
        LDiscoveredFiles := TDirectory.GetFiles(LSourceFile, '*', TSearchOption.soAllDirectories);
        for i := 0 to Length(LDiscoveredFiles) - 1 do
          CheckForExecutable(LDiscoveredFiles[i]);
      end
      else
        CheckForExecutable(LSourceFile);
    except
    end;
  end;
end;

// ----------------------------------------------------------------------------
function GetFileInfo(const AFileName: string): SHFILEINFO;
var
  LFileExtension: string;
begin
  LFileExtension := '*' + ExtractFileExt(AFileName);
  SHGetFileInfo(PChar(LFileExtension),
    FILE_ATTRIBUTE_NORMAL,
    Result,
    SizeOf(Result),
    SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES
    );
end;

// ----------------------------------------------------------------------------
function GetFileTypeName(const AFileName: string): string;
var
  LFileInfo: SHFILEINFO;
begin
  LFileInfo := GetFileInfo(AFileName);
  Result := LFileInfo.szTypeName;
end;


function processExists(ExeFileName: string): boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: Thandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  result := false;
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)))
    then
    begin
      result := true;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


end.
