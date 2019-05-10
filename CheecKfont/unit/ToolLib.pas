{ ============================================
  Software Name : 	CheeckFont
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit ToolLib;

interface

uses
  Winapi.Windows, system.Types, system.sysutils, ShellAPi, system.classes, vcl.dialogs;

procedure CreateScript(AFilevbs, AFileFont,APatchFont: string);//Create Script
Procedure ExecuteScript(AScriptDirectory, ACommandLine, scriptfilename, ScriptDirectoryAlias: String); // execute VBScript

implementation





procedure CreateScript(AFilevbs, AFileFont,APatchFont: string);
var
  vbsScript: Tstringlist;
begin
  vbsScript := Tstringlist.create;
  try
    vbsScript.add('Const FONTS = &H14&');
    vbsScript.add('Const ForAppending = 8');
    vbsScript.add('Dim fso            ');
    vbsScript.add('doexist = 0        ');
    vbsScript.add('dontexist = 0      ');
    vbsScript.add('Set objShell = CreateObject("Shell.Application")');
    vbsScript.add('Set objFolder = objShell.Namespace(FONTS)');
    vbsScript.add('set oShell = CreateObject("WScript.Shell")');
    vbsScript.add('strSystemRootDir = oshell.ExpandEnvironmentStrings("%systemroot%")');
    vbsScript.add('strFontDir = strSystemRootDir & "\fonts\"');
    vbsScript.add('strTempDir = oshell.ExpandEnvironmentStrings("%systemroot%") & "\temp"');
    vbsScript.add('Set fso = CreateObject("Scripting.FileSystemObject")');
    vbsScript.add('Set objDictionary = CreateObject("Scripting.Dictionary")');
    vbsScript.add('objDictionary.CompareMode = TextMode');
    vbsScript.add('Set f1 = FSO.createTextFile(strTempDir & "\installed_fonts.txt", ForAppending)');
    vbsScript.add('CollectFonts       ');
    vbsScript.add('Dim folderName     ');
    vbsScript.add('folderName = "'+APatchFont+'"');
    vbsScript.add('Dim fsofont        ');
    vbsScript.add('Set fsofont = CreateObject("Scripting.FileSystemObject")');
    vbsScript.add('Dim InstallFontp   ');
    vbsScript.add('InstallFontp = fsofont.GetAbsolutePathName(folderName)');
    vbsScript.add('InstallFonts InstallFontp');
    vbsScript.add('wscript.echo doexist & " fonts already installed." & vbcrlf & dontexist & " new fonts installed."');
    vbsScript.add('Public Sub CollectFonts');
    vbsScript.add('set colItems = objfolder.Items');
    vbsScript.add('For each ObjItem in ColItems');
    vbsScript.add('    If LCase(Right(objItem.Name, 3)) = "ttf" or _');
    vbsScript.add('       LCase(Right(objItem.Name, 3)) = "otf" or _');
    vbsScript.add('       LCase(Right(objItem.Name, 3)) = "pfm" or _');
    vbsScript.add('       LCase(Right(objItem.Name, 3)) = "fon" Then');
    vbsScript.add('        If Not objDictionary.Exists(LCase(ObjItem.Name)) Then');
    vbsScript.add('           objDictionary.Add LCase(ObjItem.Name), LCase(ObjItem.Name)');
    vbsScript.add('        End If');
    vbsScript.add('    End If');
    vbsScript.add('Next');
    vbsScript.add('For each ObjItem in ObjDictionary');
    vbsScript.add('    f1.writeline ObjDictionary.Item(objItem)');
    vbsScript.add('Next');
    vbsScript.add('End Sub');
    vbsScript.add('Public Sub InstallFonts(Folder)');
    vbsScript.add('Set FontFolder = fso.getfolder(Folder)');
    vbsScript.add('        For Each File in FontFolder.Files');
    vbsScript.add('             If LCase(fso.GetExtensionName(File))="ttf" or _');
    vbsScript.add('                LCase(fso.GetExtensionName(File))="otf" or _');
    vbsScript.add('                LCase(fso.GetExtensionName(File))="pfm" or _');
    vbsScript.add('                LCase(fso.GetExtensionName(File))="fon" Then');
    vbsScript.add('                If objDictionary.Exists(lcase(fso.GetFileName(File))) then');
    vbsScript.add('                    doexist = doexist + 1');
    vbsScript.add('                Else');
    vbsScript.add('              If LCase(fso.GetFileName(File)="' + AFileFont + '") then');
    vbsScript.add('                    objFolder.CopyHere FontFolder & "\" & fso.GetFileName(File)');
    vbsScript.add('                    dontexist = dontexist + 1');
    vbsScript.add('                end If');
    vbsScript.add('                end If');
    vbsScript.add('            End If');
    vbsScript.add('        Next');
    vbsScript.add('        For Each SubFolder in FontFolder.subFolders');
    vbsScript.add('            InstallFonts SubFolder');
    vbsScript.add('        Next');
    vbsScript.add('End Sub');
    vbsScript.SaveToFile(AFilevbs);
  finally
    vbsScript.Free;
  end;

end;

Procedure ExecuteScript(AScriptDirectory, ACommandLine, scriptfilename, ScriptDirectoryAlias: String); // execute VBScript
Const
  ReadBuffer = 4800;
Var
  Security: TSecurityAttributes;
  ProcessInfo: TProcessInformation;
  Start: TStartupInfo;
  ReadPipe, WritePipe: THandle;
  Buffer: PAnsiChar;
  BytesRead: DWord;
  wResult: DWord;
  sError: String;
Begin
  Security.nlength := SizeOf(TSecurityAttributes);
  Security.binherithandle := True;
  Security.lpsecuritydescriptor := nil;
  If CreatePipe(ReadPipe, WritePipe, @Security, 0) Then
  Begin
    Buffer := AllocMem(ReadBuffer + 1);
    FillChar(Start, SizeOf(Start), #0);
    Start.cb := SizeOf(Start);
    Start.hStdOutput := WritePipe;
    Start.hStdInput := ReadPipe;
    Start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    Start.wShowWindow := SW_HIDE;

    UniqueString(ACommandLine);
    If CreateProcess(Nil, PChar(ACommandLine), @Security, @Security, True, NORMAL_PRIORITY_CLASS, Nil, PChar(AScriptDirectory), Start, ProcessInfo) Then
    Begin
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      GetExitCodeProcess(ProcessInfo.hProcess, wResult);
      If (wResult = 0) Then
      Begin
        Repeat
          BytesRead := 0;
          ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil);
          Buffer[BytesRead] := #0;
          OemToAnsi(Buffer, Buffer);
          sError := sError + String(Buffer);
        Until (BytesRead < ReadBuffer);
        // log to the database
        // Log.Add(msgGENERIC_ERROR,Format('Script Error: %s', [sError]));
      End;
      // Success := (wResult > 0);
    End
    Else
    Begin
      // create an error message to raise out using global variables
      Raise Exception.CreateFmt('Error launching script: "%s" in directory "%s"'#13#10'System error: %s',
        [scriptfilename, ScriptDirectoryAlias, SysErrorMessage(GetLastError)]);
    End;

    FreeMem(Buffer);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  End;
End;

end.
