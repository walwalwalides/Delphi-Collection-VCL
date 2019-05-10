unit ToolLib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,vcl.themes,vcl.styles;

function CheckLoadBPL(const DLLFileName: String; Var ErrorCode: Cardinal; var ErrorString: string): Boolean;
procedure DeleteDirectory(const Name: string);
procedure Selectstyle;
implementation

var
  hPackageBPL2: Thandle; // or HModule
  hPackageBPL1: Thandle;



{$REGION 'Check SETTING BPL1'}

function CheekPackageBPL1(Var ErrorCode: Cardinal; var ErrorString: string): Boolean;
var
  createfunc: function: Boolean;
  pathbpl: string;
begin
  result := true;
  pathbpl := ExtractFilePath(Paramstr(0))+'BPLUser\'+ 'BPL1.bpl';
  If hPackageBPL1 = 0 Then
    hPackageBPL1 := LoadPackage(pathbpl);
  If hPackageBPL1 = 0 Then
  begin
    ErrorString := 'LoadPackage failed';
    ErrorCode := 1;
    result := false;
  end
  Else
  Begin
    @createfunc := GetProcAddress(hPackageBPL1, 'CreateBPL');
    If Assigned(createfunc) Then
    begin

      result := true;
      // FreeLibrary(hPackageBPL2);
      //
    end
    Else
    begin
      ErrorString := 'GetProcAddress failed';
      ErrorCode := 2;
      result := false;
    end;
  End;
  UnloadPackage(hPackageBPL1);
  // FreeLibrary(hPackageBPL1);
  hPackageBPL1 := 0;
end;
{$ENDREGION}

{$REGION 'Check SETTING BPL2'}

function CheekPackageBPL2(Var ErrorCode: Cardinal; var ErrorString: string): Boolean;
var
  createfunc: function: Boolean;
  pathbpl: string;
begin
  result := true;
  pathbpl := ExtractFilePath(Paramstr(0))+ 'BPLUser\'+ 'BPL2.bpl';
  If hPackageBPL2 = 0 Then
    hPackageBPL2 := LoadPackage(pathbpl);
  If hPackageBPL2 = 0 Then
  begin
    ErrorString := 'LoadPackage failed';
    ErrorCode := 1;
    result := false;
  end
  Else
  Begin
    @createfunc := GetProcAddress(hPackageBPL2, 'CreateBPL');
    If Assigned(createfunc) Then
    begin
      // UnloadPackage(hPackageBPL2);

      result := true;
    end
    else
    begin
      ErrorString := 'GetProcAddress failed';
      ErrorCode := 2;
      result := false;
    end;
  End;
  // FreeLibrary(hPackageBPL2);
  UnloadPackage(hPackageBPL2);
  hPackageBPL2 := 0;
end;

{$ENDREGION}


{$REGION 'Delete Directory'}
procedure DeleteDirectory(const Name: string);
var
  F: TSearchRec;
begin
  if FindFirst(Name + '\*', faAnyFile, F) = 0 then begin
    try
      repeat
        if (F.Attr and faDirectory <> 0) then begin
          if (F.Name <> '.') and (F.Name <> '..') then begin
            DeleteDirectory(Name + '\' + F.Name);
          end;
        end else begin
          DeleteFile(Name + '\' + F.Name);
        end;
      until FindNext(F) <> 0;
    finally
      FindClose(F);
    end;
    RemoveDir(Name);
  end;
end;
{$ENDREGION}

{$REGION 'Check Loding BPL'}
function CheckLoadBPL(const DLLFileName: String; Var ErrorCode: Cardinal; var ErrorString: string): Boolean;
Var
  DLL: HMODULE;
begin
  // u can define every package specifically...
  if (DLLFileName = 'BPL1.bpl') then
  begin
    result := CheekPackageBPL1(ErrorCode, ErrorString);

  end;
  if (DLLFileName = 'BPL2.bpl') then
  begin

    result := CheekPackageBPL2(ErrorCode, ErrorString);

  end;
end;
{$ENDREGION}


{$REGION 'Select Styles'}

procedure Selectstyle;
var
  StylePath:string;
  styleName: string;
  ipos: integer;
  openDialog: topendialog;
begin
  showmessage('Choose a Style');
  openDialog := topendialog.Create(nil);
  openDialog.InitialDir := 'C:\Users\Public\Documents\Embarcadero\Studio\';

  openDialog.Options := [ofFileMustExist];

  openDialog.Filter := 'Styles |*.*|Delphi Sytles|*.vsf';

  openDialog.FilterIndex := 2;

  // Display the open file dialog
  if openDialog.Execute then
  begin
    StylePath := openDialog.FileName;
    TStyleManager.LoadFromFile(StylePath);
    styleName := extractfilename(StylePath);
    ipos := pos('.', styleName);
    styleName := Copy(styleName, 0, ipos-1);

    TStyleManager.TrySetStyle(styleName, false);

  end
  else
    showmessage('no style selected');

  // Free up the dialog
  openDialog.Free;
end;

{$ENDREGION}

end.
