library CountDownDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  mmsystem,
  windows,
  vcl.Dialogs,
  System.classes,
  winapi.messages,
  vcl.Forms,
  uCountDown in 'View\uCountDown.pas' {frmCountDown} ,
  uOption in 'View\uOption.pas' {frmOption} ,
  CountDownDLL_Lib in 'Unit\CountDownDLL_Lib.pas';

{$R *.res}

var
  sAppPath: string;
  dirRes: UTF8String {$IFNDEF MACOSX} = 'Wav/' {$ENDIF};
  MH: THandle;
  H1: THandle;

  { R *.res }

procedure PlayResSound(RESName: string; uFlags: Integer);
var
  // Handle Deklaration
  hResInfo, hRes: THandle;
  // Char Deklaration
  lpGlob: PChar;
begin

  hResInfo := FindResource(HInstance, PChar(RESName), MAKEINTRESOURCE('WAVES'));
  if hResInfo = 0 then
  begin
    messagebox(0, 'Could not find this Resource', PChar(RESName), 16);
    Exit;
  end;

  hRes := LoadResource(HInstance, hResInfo);
  if hRes = 0 then
  begin
    messagebox(0, 'Could not load this Resource', PChar(RESName), 16);
    Exit;
  end;
  lpGlob := LockResource(hRes);
  if lpGlob = nil then
  begin
    messagebox(0, 'Resource bad.', PChar(RESName), 16);
    Exit;
  end;
  uFlags := snd_Memory or uFlags;
  SndPlaySound(lpGlob, uFlags);
  UnlockResource(hRes);
  FreeResource(hRes);

end;

Function CheckN(Handle: THandle): boolean;
begin

  // Waiting for the end of message processing
  Result := boolean(SendMessage(Handle, WM_ENABLE, Integer(false), 0));

end;

function HandleOf(TitreFenetre: String): THandle;
begin
  Result := 0;
  // find the handle of principal handle
  Result := FindWindow(nil, PChar(TitreFenetre));
end;

function HandleOfChild(HndlParent: THandle; Classe, Titre: String; PrevHandle: THandle): THandle;
var
  ProgramHwnd: THandle;
begin
  // find the handle of a child control of type Class of name (caption) Title
  Result := 0;
  if HndlParent <> 0 then
    Result := FindWindowEx(HndlParent, PrevHandle, PChar(Classe), PChar(Titre));
end;

function SHOWCOUNTDOWN: Tform; stdcall;
var
  sSoundOpen: string;
  Pt: TPoint;
begin
//   KillTask('CountDownDLL');
  if (processExists('CountDownDLL')) then
  begin

    Exit;
  end;


  sAppPath := ExtractFilePath(Application.exename);
  if (frmCountDown = nil) then
  begin
    MH := HandleOf('CountDown'); // Check if thge correct window Handle
    if MH = 0 then
      Exit;

    H1 := HandleOfChild(MH, 'TEdit', 'edtInfo', 0);
    SendMessage(H1, WM_SETTEXT, 0, DWord(PChar('Game Started !')));

    // SendMessage(H1, WM_ENABLE, WM_ENABLE, 1);
    sSoundOpen := dirRes + 'openclock.wav'; // opning Sound
    Application.CreateForm(TfrmCountDown, frmCountDown);
    Application.CreateForm(TfrmOption, frmOption);
    try

      SndPlaySound(PChar(sSoundOpen), SND_ASYNC);
      Result := frmCountDown;
    except
      Exit;
      //

    end;
  end;

end;

procedure STARTCHRONO; stdcall;
begin
  if (frmCountDown <> nil) then
  begin
    frmCountDown.chronoshow;
    frmCountDown.TmrProcess.Enabled := true;
    // CheckN(H1);
  end;
end;

procedure CLOSECOUNTDOWN; stdcall;
var
  sSoundclose: string;
begin
  if (frmCountDown <> nil) then
  begin
    try
      frmCountDown.tmrMain.Enabled := false;
      sSoundclose := dirRes + 'closeclock.wav';
      SndPlaySound(PChar(sSoundclose), SND_ASYNC);
      FreeAndNil(frmCountDown);
      FreeAndNil(frmOption);
    except

    end;
  end;

end;

procedure SHOWGAMEOVER; export;
var
  sSoundIni: string;
begin
  if (frmCountDown <> nil) then
  begin
    // SendMessage(H1, WM_SETTEXT, 0, DWord(PChar('Game Over!')));
    // sSoundIni := dirRes + 'IniClock.wav';
    // SndPlaySound(PChar(sSoundIni), SND_ASYNC);
    // frmCountDown.ilongtime := 0;
  end;
  //
end;

procedure SHOWCHRONO; export;
var
  sSoundIni: string;
begin
  if (frmCountDown <> nil) then
  begin
    sSoundIni := dirRes + 'IniClock.wav';
    SndPlaySound(PChar(sSoundIni), SND_ASYNC);
    frmCountDown.ilongtime := 0;
    frmCountDown.chronoshow;
    frmCountDown.tmrMain.Enabled := false;
  end;
  //
end;

procedure SETCHRONO(var minustime: WORD); export;
begin
  frmCountDown.ilongtime := frmCountDown.ilongtime - minustime;
end;
//

exports SHOWCOUNTDOWN, CLOSECOUNTDOWN, STARTCHRONO, SHOWCHRONO, SETCHRONO, SHOWGAMEOVER;

begin

end.
