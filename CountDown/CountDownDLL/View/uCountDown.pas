{ ============================================
  Software Name : 	CountDouwnDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit uCountDown;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, Inifiles, StdCtrls, Jpeg;

type
  TWMMYMessage = record
    Msg: Cardinal; // ( first is the message ID )
    Handle: HWND; // ( this is the wParam, Handle of sender)
    Info: Longint; // ( this is lParam, pointer to our data)
    Result: Longint;
  end;

type
  TfrmCountDown = class(TForm)
    PaintBox1: TPaintBox;
    PopupMenu1: TPopupMenu;
    MPosition: TMenuItem;
    N1: TMenuItem;
    MColor: TMenuItem;
    tmrMain: TTimer;
    tmrFinish: TTimer;
    tmrProcess: TTimer;
    MSize: TMenuItem;
    szSmall: TMenuItem;
    szMedium: TMenuItem;
    szLarge: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: Tobject);
    procedure tmrMainTimer(Sender: Tobject);
    procedure PaintBox1MouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure PaintBox1MouseMove(Sender: Tobject; Shift: TShiftState; X, Y: integer);
    procedure PaintBox1MouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure MPositionClick(Sender: Tobject);
    procedure MColorClick(Sender: Tobject);
    procedure PaintBox1Paint(Sender: Tobject);
    procedure Reduire1Click(Sender: Tobject);
    procedure FormClose(Sender: Tobject; var Action: TCloseAction);
    procedure FormPaint(Sender: Tobject);
    procedure AppliOnrestore(Sender: Tobject);
    procedure tmrProcessTimer(Sender: Tobject);
    procedure tmrFinishTimer(Sender: Tobject);
    procedure szSmallClick(Sender: Tobject);
    procedure szMediumClick(Sender: Tobject);
    procedure szLargeClick(Sender: Tobject);

  private
    { Déclarations privées }

    Procedure Initsincos; { precalcule  sinus & cosinus 0..360 }

    Function Calculcolo(code, { Determine the pallet rank of a color in one of the intervals }
      plage1, plage2, coef: integer): integer;
    { calculation function positions x and y as a function of time and radius }
    Procedure Timetoxy(style, { 0 heure, 1 minutes, 2 secondes }
      k1, k2, r: integer; { radius of the cerle }
      var wx, wy: Longint); { coordinates of the result }
    Procedure Setcolorpalette(n: integer; c: Tcolor);
    Procedure Calculrayons;
    Procedure creepalette;
    procedure GameOverMode(sGameOver: string);
    Procedure HorlogeByProcess(cancan: Tcanvas; ki: integer);
    Procedure HorlogeByEnd(cancan: Tcanvas);
    procedure SaveChange; //
  public
    { Déclarations publiques }

    ilongtime: integer;
    ntakt: SmallInt;

    procedure chronoshow;

    procedure DefaultHandler(var Message); override; // Check recive message
    procedure WMMYMessage(var Msg: TWMMYMessage); // Handle broadcast recieve message

    procedure NewParams;
  end;

var
  frmCountDown: TfrmCountDown;
  boolfinish: boolean;
  WM_OURMESSAGE: DWORD;

  Newpalette: HPalette; { new palette degrade }
  OldPal: HPalette; { old handle of pointer }
  pPal: PLOGPALETTE; { pointer to logical Palette }

  sz: integer; { Diameter of countdown }
  Colors: array [1 .. 16] OF Tcolor; { define colors }
  Fichierwav: Tfilename; { wav Filename }
  fond: integer; { type de fond cf frmOption radiogroup1 }
  posdate: integer; { position de la date }
  leftform, topform: integer;

  Bmp1: Tbitmap;
  Bmp2: Tbitmap;
  modif: integer; { number of  modifs options }

  { 4 plages horaires maxi utilisées par form7 }
  maxplage: integer; { rang plage maxi }
  plagehdeb: array [1 .. 4] of integer;
  plagemdeb: array [1 .. 4] of integer;
  plagehfin: array [1 .. 4] of integer;
  plagemfin: array [1 .. 4] of integer;

implementation

uses uOption, mmsystem;

{$R *.DFM}

CONST
  Inifilename = 'CountDown.ini';

  { prametre inifilename }

  K0 = 'CountDown';
  F00 = 'SIZE';
  F01 = 'COlOR01';
  F02 = 'COlOR02';
  F03 = 'COlOR03';
  F04 = 'COlOR04';
  F05 = 'COlOR05';
  F06 = 'COlOR06';
  F07 = 'COlOR07';
  F12 = 'COlOR12';
  F13 = 'COlOR13';
  F19 = 'FOND';
  F26 = 'DATE';
  F27 = 'LEFT'; // last position of Coundown  of X axe.
  F28 = 'TOP'; // last position of Coundown  of Y axe.

Var
  { ---------------- Design CountDown  ---------------------- }

  r1: integer; { Rayon bord extérieur }
  r3: integer; { rayon intérieur graduations }
  r4: integer; { rayon fond cadran }
  r5: integer; { rayon centre des chiffres }
  cx, cy: integer; { centre de l'horloge }
  deplace: boolean; { true si déplacement avec clic bouton gauche }
  fx, fy: integer; { pour déplacement de la fenêtre }

  { pré-calcul  sinus & cosinus }
  zsin: array [0 .. 360] OF single;
  zcos: array [0 .. 360] OF single;

  alcurcolo: array [1 .. 8] of Tcolor;
  angle: integer;
  rgn: THandle; { région elliptique pour fenêtre ronde }
  curdir: string; { directory de l'application }
  Inifilepath: String;
  dirRes: UTF8String {$IFNDEF MACOSX} = 'wav/' {$ENDIF};
  irest: Int64;

procedure TfrmCountDown.AppliOnrestore(Sender: Tobject);
begin
  tmrMain.enabled := true;
end;

procedure TfrmCountDown.FormCreate(Sender: Tobject);
const
  IniFolder = 'Ini\';
Var
  Fichini: Tinifile;
  decal: integer;
begin
  Application.onrestore := AppliOnrestore;
  modif := 0;
  randomize;
  Initsincos;
  curdir := ExtractFilePath(Application.exename);
  if not DirectoryExists(curdir + IniFolder) then
    ForceDirectories(curdir + IniFolder);
  Inifilepath := curdir + IniFolder + Inifilename;
  IF copy(curdir, length(curdir), 1) = '\' then
    delete(curdir, length(curdir), 1);
  // ----------------------------------------  //
  // if not FileExists(Inifilename) then
  Fichini := Tinifile.Create(Inifilepath);
  WITH Fichini DO
  BEGIN
    sz := Readinteger(K0, F00, 180);
    if (sz <= 0) then
      sz := 180;
    case sz of
      180:
        szSmall.Checked := true;
      270:
        szMedium.Checked := true;
      360:
        szLarge.Checked := true;
    end;

    Colors[01] := Tcolor(Readinteger(K0, F01, clwhite)); { interior casing }
    Colors[02] := Tcolor(Readinteger(K0, F02, clwhite)); { exterior casing }
    Colors[03] := Tcolor(Readinteger(K0, F03, clgreen)); { interior dial }
    Colors[04] := Tcolor(Readinteger(K0, F04, clwhite)); { exterior dial }
    Colors[05] := Tcolor(Readinteger(K0, F05, clred)); { fond graduation }
    Colors[06] := Tcolor(Readinteger(K0, F06, clred)); { Alert Color }
    Colors[07] := Tcolor(Readinteger(K0, F07, clgreen)); { Number color }
    // Colors[08] :=clWhite;
    // Colors[09] :=clWhite;
    // Colors[10] :=clWhite;
    // Colors[11] :=clWhite;
    // Colors[12] :=clWhite;
    // Colors[13] :=clWhite;
    // Colors[14] :=clWhite;
    Colors[15] := clwhite;
    Colors[16] := clwhite;

    leftform := Readinteger(K0, F27, 0);
    topform := Readinteger(K0, F28, 0);

    fond := Readinteger(K0, F19, 0);
    IF fond < 0 then
      fond := 0;
    IF fond > 1 then
      fond := 1;
    posdate := Readinteger(K0, F26, 1);
    if posdate < 0 then
      posdate := 0;
    if posdate > 3 then
      posdate := 3;
    Free;
  END;

  creepalette;
  { save the orginal palette }
  OldPal := selectpalette(canvas.Handle, Newpalette, False);
  Calculrayons;
  deplace := False;
  maxplage := 0;
  frmCountDown.width := sz + 4;
  frmCountDown.height := sz + 4;
  { initial position }
  frmCountDown.left := screen.width - frmCountDown.width - 32;
  // frmCountDown.top := screen.height - frmCountDown.height -32;
  frmCountDown.top := 32;
  rgn := CreateEllipticrgn(0, 0, sz, sz);
  SetWindowRgn(Handle, rgn, true);
  PaintBox1.top := 0;
  PaintBox1.left := 0;
  PaintBox1.width := sz;
  PaintBox1.height := sz;
  { Create the bitmap }
  Bmp1 := Tbitmap.Create;
  Bmp1.width := sz;
  Bmp1.height := sz;
  Bmp1.pixelformat := pf24bit;
  Bmp2 := Tbitmap.Create;
  Bmp2.width := sz;
  Bmp2.height := sz;
  Bmp2.pixelformat := pf24bit;

  Bmp1.palette := Newpalette;

  HorlogeByEnd(Bmp1.canvas);
  tmrMain.interval := 50;
  // tmrMain.enabled := true;
  // Timer2.enabled := true;
  if ((leftform = 0) and (topform = 0)) then
  begin
    // frmCountDown.left := screen.width - frmCountDown.width - 16;
    frmCountDown.top := 0;
    frmCountDown.left := (screen.width div 2) - (frmCountDown.width div 2);
  end
  else
  begin
    frmCountDown.left := leftform;
    frmCountDown.top := topform;
  end;
  // ilongtime := 24;
end;

{ teste si device présent }
function DiskInDrive(Drive: Char): boolean;
var
  ErrorMode: word;
begin
  if Drive in ['a' .. 'z'] then
    dec(Drive, $20);
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    if DiskSize(Ord(Drive) - $40) = -1 then
      Result := False
    else
      Result := true;
  finally
    SetErrorMode(ErrorMode);
  end;
end;

procedure TfrmCountDown.SaveChange;
Var
  Fichini: Tinifile;
begin
  IF (modif > 0) then
  begin
    Fichini := Tinifile.Create(Inifilepath);
    WITH Fichini DO
    BEGIN
      Writeinteger(K0, F00, sz);
      Writeinteger(K0, F01, Longint(Colors[01]));
      Writeinteger(K0, F02, Longint(Colors[02]));
      Writeinteger(K0, F03, Longint(Colors[03]));
      Writeinteger(K0, F04, Longint(Colors[04]));
      Writeinteger(K0, F05, Longint(Colors[05]));
      Writeinteger(K0, F06, Longint(Colors[06]));
      Writeinteger(K0, F07, Longint(Colors[07]));

      // Writeinteger(K0, F12, Longint(Colors[12]));
      // Writeinteger(K0, F13, Longint(Colors[13]));
      Writeinteger(K0, F19, fond);

      Writeinteger(K0, F26, posdate);
      Writeinteger(K0, F27, left);
      Writeinteger(K0, F28, top);

      Free;
    end;
  end;

end;

procedure TfrmCountDown.FormClose(Sender: Tobject; var Action: TCloseAction);
Var
  Fichini: Tinifile;
begin
  tmrMain.enabled := False;
  IF (modif > 0) then
    IF messagedlg('Do you want to keep the settings ?', mtconfirmation, [mbyes, mbno], 0) = mrYes then
      modif := 1
    else
      modif := 0;
  IF (modif = 1) then
  begin

    Fichini := Tinifile.Create(Inifilepath);
    WITH Fichini DO
    BEGIN
      Writeinteger(K0, F00, sz);
      Writeinteger(K0, F01, Longint(Colors[01]));
      Writeinteger(K0, F02, Longint(Colors[02]));
      Writeinteger(K0, F03, Longint(Colors[03]));
      Writeinteger(K0, F04, Longint(Colors[04]));
      Writeinteger(K0, F05, Longint(Colors[05]));
      Writeinteger(K0, F06, Longint(Colors[06]));
      Writeinteger(K0, F07, Longint(Colors[07]));

      // Writeinteger(K0, F12, Longint(Colors[12]));
      // Writeinteger(K0, F13, Longint(Colors[13]));
      Writeinteger(K0, F19, fond);
      Writeinteger(K0, F26, posdate);
      Writeinteger(K0, F27, leftform);
      Writeinteger(K0, F28, topform);

      Free;
    end;
  end;
  Bmp1.Free;
  Bmp2.Free;
  { remet Colors à l'état origine et suprime Newpalette }
  selectpalette(canvas.Handle, OldPal, False);
  DeleteObject(Newpalette);
  // Action := caFree;
end;

Procedure TfrmCountDown.Initsincos; // crée la table optimisation des calculs
const
  k = pi / 180;
var
  i: integer;
Begin
  For i := 0 TO 90 do
  begin
    zsin[i] := sin(i * k);
    zcos[i] := cos(i * k);
    zsin[i + 90] := zcos[i];
    zcos[i + 90] := -zsin[i];
    zsin[i + 180] := -zsin[i];
    zcos[i + 180] := -zcos[i];
    zsin[i + 270] := -zcos[i];
    zcos[i + 270] := zsin[i];
  end;
end;

Procedure TfrmCountDown.Setcolorpalette(n: integer; c: Tcolor);
Var
  r, g, b: byte;
Begin
  IF n < 0 then
    exit;
  IF n > 255 then
    exit;
  with pPal^ do
  begin
{$R-}
    r := GetRvalue(c);
    g := GetGvalue(c);
    b := GetBvalue(c);
    palPalEntry[n].peRed := r;
    palPalEntry[n].peGreen := g;
    palPalEntry[n].peBlue := b;
    palPalEntry[n].peFlags := PC_RESERVED;
{$R+}
  end;
end;

procedure TfrmCountDown.szSmallClick(Sender: Tobject);
begin
  //
  szSmall.Checked := true;
  sz := 180;
  inc(modif);
  SaveChange;
  NewParams;
end;

{ Creates the necessary palette in 256 Colors mode }
procedure TfrmCountDown.creepalette;
Const
  entries = 256;
  { 20 Colors system }
  wincolors: array [1 .. 21] of Tcolor = (clActiveBorder, clActiveCaption, clAppWorkSpace, clBackground, clBtnFace, clBtnHighlight, clBtnShadow, clBtnText,
    clCaptionText, clGrayText, clHighlight, clHighlightText, clInactiveBorder, clInactiveCaption, clInactiveCaptionText, clMenu, clMenuText, clscrollbar,
    clWindow, clWindowFrame, clWindowText);
var
  i: word;
  CurPal: Array [0 .. 255] of TPALETTEENTRY; { pallet entries }
  ScreenDC: HDC; { pointer to DC Screen }
  SizeMemLog: Longint; { SizeMemLog size memorie logique }
  k246: word;
  CR1, CR2, CG1, CG2, CB1, CB2: integer;
begin
  SizeMemLog := sizeof(TLogPalette) + entries * sizeof(TPALETTEENTRY);
  getmem(pPal, SizeMemLog);
  pPal^.palVersion := $300;
  pPal^.palNumEntries := entries;
  { Device context of the screen that has the 20 Colors system }
  ScreenDC := getdc(0);
  with pPal^ do
  begin
{$R-}     // Ignoring  bounds problems
    { Identity palette : 20 Colors système dans 0..9 et 246..255 }
    GetSystemPaletteEntries(ScreenDC, 0, 10, palPalEntry[0]);
    k246 := 246;
    GetSystemPaletteEntries(ScreenDC, k246, 10, palPalEntry[k246]);
    { les 21 Colors de Windows entrées 10 à 30, $02 -> PC_RESERVED }
    For i := 1 TO 21 DO
      Setcolorpalette(i + 9, wincolors[i]);
    CR1 := GetRvalue(Colors[1]);
    CG1 := GetGvalue(Colors[1]);
    CB1 := GetBvalue(Colors[1]);
    CR2 := GetRvalue(Colors[2]);
    CG2 := GetGvalue(Colors[2]);
    CB2 := GetBvalue(Colors[2]);
    For i := 1 TO 64 do
    begin
      palPalEntry[i + 30].peRed := CR1 + ((CR2 - CR1) * i) div 64;
      palPalEntry[i + 30].peGreen := CG1 + ((CG2 - CG1) * i) div 64;
      palPalEntry[i + 30].peBlue := CB1 + ((CB2 - CB1) * i) div 64;
      palPalEntry[i + 30].peFlags := PC_RESERVED;
    end;
    CR1 := GetRvalue(Colors[3]);
    CG1 := GetGvalue(Colors[3]);
    CB1 := GetBvalue(Colors[3]);
    CR2 := GetRvalue(Colors[4]);
    CG2 := GetGvalue(Colors[4]);
    CB2 := GetBvalue(Colors[4]);
    For i := 1 TO 64 do
    begin
      palPalEntry[i + 94].peRed := CR1 + ((CR2 - CR1) * i) div 64;
      palPalEntry[i + 94].peGreen := CG1 + ((CG2 - CG1) * i) div 64;
      palPalEntry[i + 94].peBlue := CB1 + ((CB2 - CB1) * i) div 64;
      palPalEntry[i + 94].peFlags := PC_RESERVED;
    end;
    For i := 1 to 64 do
    begin
      palPalEntry[i + 158].peRed := 127 + i * 2;
      palPalEntry[i + 158].peGreen := 127 + i * 2;
      palPalEntry[i + 158].peBlue := 127 + i * 2;
      palPalEntry[i + 158].peFlags := PC_RESERVED;
    end;
    For i := 1 TO 13 do
      Setcolorpalette(i + 222, Colors[i]);
    for i := 0 to entries - 1 do
      CurPal[i] := palPalEntry[i];
{$R+}
  end;
  Newpalette := CreatePalette(pPal^);
  FreeMem(pPal, SizeMemLog);
end;

Function TfrmCountDown.Calculcolo(code, plage1, plage2, coef: integer): integer;
var
  i: integer;
BEGIN
  { Determine the pallet rank of a color in one of the intervals }

  IF (plage2 < plage1) or (coef < plage1) or (coef > plage2) then
    i := 1
  else
    i := (64 * (coef - plage1 + 1)) div (plage2 - plage1 + 1);
  case code of
    0:
      Result := 30 + i;
    1:
      Result := 94 + i;
    2:
      Result := 159 + i;
  else
    Result := 0;
  end;
end;

Procedure TfrmCountDown.Timetoxy(style, k1, k2, r: integer; var wx, wy: Longint);
var
  rs: single;
Begin
  case style of
    0:
      begin
        if k1 >= 12 then
          k1 := k1 - 12;
        k1 := (3 - k1) * 30 - k2 div 2;
      end;
    1:
      begin
        k1 := (15 - k1) * 6 - k2 div 10;
      end;
    2:
      begin
        k1 := (15 - k1) * 6; { 6° per minute }
      end;
  end;
  { protection access to the sine and cosine table }
  While k1 > 360 do
    k1 := k1 - 360;
  While k1 < 0 do
    k1 := 360 + k1;
  rs := r;
  wx := round(rs * zcos[k1]);
  { y reversed with respect to Cartesian coordinates }
  wy := -round(rs * zsin[k1]);
end;

procedure TfrmCountDown.tmrFinishTimer(Sender: Tobject);
begin
  tmrFinish.enabled := False;
  tmrProcess.enabled := False;
  tmrMain.enabled := False;
end;

procedure TfrmCountDown.tmrProcessTimer(Sender: Tobject);

var
  sSoundTakt: string;
  sGameOver: String;

begin
  MColor.enabled := False;

  sSoundTakt := dirRes + 'TaktClock.wav';
  if (Fichierwav = '') then
    sGameOver := dirRes + 'CloseClock.wav'
  else
  begin
    sGameOver := Fichierwav;
  end;

  { time is smaller then 0 }
  if (ilongtime <= 0) then
  begin
    GameOverMode(sGameOver);

  end;

  irest := round(ilongtime);

  HorlogeByEnd(Bmp1.canvas);

  if plagemfin[1] = 0 then
  begin

    ntakt := ntakt + 1;
    HorlogeByProcess(Bmp1.canvas, -ntakt);
    Refresh;
    if (irest - ntakt < 4) then
      SndPlaySound(PChar(sSoundTakt), SND_ASYNC);

    if (irest - ntakt < 11) then
    begin

      Colors[7] := clred; // color of numbers

      Colors[8] := clred;

    end
    else
    begin
      Colors[7] := clgreen; // color of numbers
      Colors[8] := clgreen;
    end;
  end;
  { time is out }
  if (ntakt = irest) then
  begin

    Colors[7] := clwhite;
    Colors[8] := clwhite;

    tmrProcess.enabled := False;
    ntakt := 0;
    GameOverMode(sGameOver);
    frmCountDown.chronoshow;
    if (boolfinish = False) then
      tmrFinish.enabled := true;
    MColor.enabled := true;
  end;
end;

procedure TfrmCountDown.Calculrayons;
begin
  cx := sz div 2; { center of the CountDown }
  cy := sz div 2;
  r1 := sz div 2; { Outside edge radius }
  r3 := (r1 * 14) div 16; { inner radius graduations }
  r4 := 1 + (r1 * 13) Div 16; { radius bottom dial }
  r5 := (r1 * 11) Div 16; { center of numbers }
end;

procedure TfrmCountDown.tmrMainTimer(Sender: Tobject);
var
  present: Tdatetime;
  i: integer;
  Heure, Minute, Sec, MSec: word;
begin
  present := now;
  DecodeTime(present, Heure, Minute, Sec, MSec);
  IF Sec = 0 then
    HorlogeByEnd(Bmp1.canvas);
  Bmp2.canvas.Draw(0, 0, Bmp1);
  Realizepalette(PaintBox1.canvas.Handle);
  PaintBox1.canvas.Draw(0, 0, Bmp2); { Dispaly }
end;

procedure TfrmCountDown.MPositionClick(Sender: Tobject);
var
  sSoundclose: string;
begin
  modif:=1;
  SaveChange;
  if (frmCountDown <> nil) then
  begin
    try
      frmCountDown.tmrMain.enabled := False;
      sSoundclose := dirRes + 'closeclock.wav';
      SndPlaySound(PChar(sSoundclose), SND_ASYNC);
      FreeAndNil(frmCountDown);
      FreeAndNil(frmOption);
    except

    end;
  end;
end;

procedure TfrmCountDown.PaintBox1MouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  IF Button = mbleft then
  begin
    deplace := true;
    fx := X;
    fy := Y;
    tmrMain.enabled := False;
  end;
end;

procedure TfrmCountDown.PaintBox1MouseMove(Sender: Tobject; Shift: TShiftState; X, Y: integer);
begin
  IF deplace then
  begin
    frmCountDown.left := frmCountDown.left + X - fx;
    frmCountDown.top := frmCountDown.top + Y - fy;
  end;
end;

procedure TfrmCountDown.PaintBox1MouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  IF deplace then
  begin
    frmCountDown.left := frmCountDown.left + X - fx;
    frmCountDown.top := frmCountDown.top + Y - fy;
    deplace := False;
    tmrMain.enabled := true;
  end;
end;

procedure TfrmCountDown.NewParams;
Var
  decal: integer;
begin
  Calculrayons;
  Bmp1.Free;
  Bmp2.Free;
  width := sz + 8;
  height := sz + 8;
  rgn := CreateEllipticrgn(0, 0, sz, sz);
  SetWindowRgn(Handle, rgn, true);
  PaintBox1.top := 0;
  PaintBox1.left := 0;
  PaintBox1.width := sz;
  PaintBox1.height := sz;

  Bmp1 := Tbitmap.Create;
  Bmp1.width := sz;
  Bmp1.height := sz;
  Bmp1.pixelformat := pf24bit;

  Bmp2 := Tbitmap.Create;
  Bmp2.width := sz;
  Bmp2.height := sz;
  Bmp2.pixelformat := pf24bit;

  creepalette;
  Bmp1.palette := Newpalette;
  HorlogeByEnd(Bmp1.canvas);

end;

procedure TfrmCountDown.MColorClick(Sender: Tobject);
var
  sSoundclose: string;
begin
  SendMessage(HWND_BROADCAST, WM_OURMESSAGE, 0, 1);
  tmrMain.enabled := False;
  frmOption.showmodal;
  if (szSmall.Checked) then
    sz := 180;
  if (szMedium.Checked) then
    sz := 270;
  if (szLarge.Checked) then
    sz := 360;

  SaveChange;
  sSoundclose := dirRes + 'closeclock.wav';
  SndPlaySound(PChar(sSoundclose), SND_ASYNC);
  self.Free;
  frmOption.Free;

  // SendMessage(HWND_BROADCAST, WM_OURMESSAGE, 0, 3); // Close CoutDownDLL
  // HorlogeByEnd(Bmp1.canvas);

  // SendMessage(HWND_BROADCAST, WM_OURMESSAGE, 0, 3);
  // tmrMain.enabled := true;
end;

procedure TfrmCountDown.szLargeClick(Sender: Tobject);
begin
  //
  szLarge.Checked := true;
  sz := 360;
  inc(modif);
  SaveChange;
  NewParams;
end;

procedure TfrmCountDown.szMediumClick(Sender: Tobject);
begin
  //
  szMedium.Checked := true;
  sz := 270;
  inc(modif);
  SaveChange;
  NewParams;
end;

procedure TfrmCountDown.PaintBox1Paint(Sender: Tobject);
begin
  IF tmrMain.enabled then
    PaintBox1.canvas.Draw(0, 0, Bmp2);
end;

procedure TfrmCountDown.Reduire1Click(Sender: Tobject);
begin
  tmrMain.enabled := False;
  Application.minimize;
end;

procedure TfrmCountDown.FormPaint(Sender: Tobject);
begin
  tmrMain.enabled := False;
  selectpalette(frmCountDown.canvas.Handle, Bmp1.palette, False);
  Realizepalette(frmCountDown.canvas.Handle);
  tmrMain.enabled := true;
end;

procedure TfrmCountDown.chronoshow;
begin
  if frmCountDown <> nil then
  begin

    // ilongtime:=0;
    HorlogeByEnd(Bmp1.canvas);
    if maxplage <> 0 then
      dec(maxplage);

    inc(maxplage);
    plagehdeb[maxplage] := 0;
    plagemdeb[maxplage] := 0;
    plagehfin[maxplage] := 24;
    plagemfin[maxplage] := 00;
    ntakt := 0;

  end;
end;

Procedure TfrmCountDown.HorlogeByProcess(cancan: Tcanvas; ki: integer);
Var
  i: integer;
  x1, y1: Longint;
  x2, y2: Longint;
  dx, dy: integer;
  s: string[20];
  present: Tdatetime;
  m, n: integer;

Begin
  With cancan do
  begin
    Brush.style := bsclear;
    Pen.style := PsSolid;

    Pen.width := 2;

    For i := 4 TO r4 do { Gradient inside the dial }
    begin
      Pen.color := paletteindex(Calculcolo(1, 4, r4, i));
      ellipse(cx - i, cy - i, cx + i + 1, cy + i + 1);
    end;
    n := r5 div (r1 - (r3 + 1)); // Delta for pixels outer thickness of the dial
    For i := r3 to r1 do
    begin
      Pen.color := paletteindex(Calculcolo(0, r3, r1, i));
      ellipse(cx - i, cy - i, cx + i + 1, cy + i + 1);
    end;
    Pen.color := Colors[2];

    ellipse(cx - r1, cy - r1, cx + r1, cy + r1);
    Pen.color := Colors[1];
    ellipse(cx - r3 - 1, cy - r3 - 1, cx + r3 + 2, cy + r3 + 2);

    Pen.color := Colors[4];
    For i := r4 to r3 do
      ellipse(cx - i, cx - i, cx + i + 1, cy + i + 1);
    { Numbers }
    font.name := 'Arial';
    font.size := sz div 4 - 20;

    s := inttostr(irest + ki);

    dx := textwidth(s) div 2;
    dy := textheight(s) div 2;
    Timetoxy(0, ki, 0, r5, x1, y1);

    font.color := Colors[7];
    Textout(cx + x1 - dx + 2, cy + y1 - dy + 2, s);

    { Numbers }
    Textout(cx + x1 - dx + 1, cy + y1 - dy + 1, s);

    Pen.width := 1;
    For i := 0 to 59 do
    begin { graduations }
      Timetoxy(2, i, 0, r3 + 1, x1, y1);
      IF i mod 5 = 0 then
      begin
        Pen.color := Colors[09];
        Timetoxy(2, i, 0, r4 - 4, x2, y2);
      end
      else
      begin
        Pen.color := Colors[10];
        Timetoxy(2, i, 0, r4 - 3, x2, y2);
      end;
      moveto(cx + x1, cy + y1);
      lineto(cx + x2, cy + y2);
    end;
  end;
end;

{ Design the CountDown by end Mode }
Procedure TfrmCountDown.HorlogeByEnd(cancan: Tcanvas); // by initial or finish process
Var
  i: integer;
  x1, y1: Longint;
  x2, y2: Longint;
  dx, dy: integer;
  sx, Sy, sz: string[20];
  present: Tdatetime;
  m, n: integer;

Begin
  With cancan do
  begin
    Brush.style := bsclear;
    Pen.style := PsSolid;
    Pen.width := 10;

    For i := 4 TO r4 do
    begin
      Pen.color := paletteindex(Calculcolo(1, 4, r4, i));
      ellipse(cx - i, cy - i, cx + i + 1, cy + i + 1);
    end;
    n := r5 div (r1 - (r3 + 1)); // Delta for pixels outer thickness of the dial
    For i := r3 to r1 do { outside gradient }
    begin
      Pen.color := paletteindex(Calculcolo(0, r3, r1, i));
      ellipse(cx - i, cy - i, cx + i + 1, cy + i + 1);
    end;
    Pen.color := Colors[2];
    ellipse(cx - r1, cy - r1, cx + r1, cy + r1);
    Pen.color := Colors[1];
    ellipse(cx - r3 - 1, cy - r3 - 1, cx + r3 + 2, cy + r3 + 2);
    if (posdate = 2) then
      Pen.color := clred
    else
      Pen.color := clwhite; { Colors[8] }; { fond graduations }  // countour

    For i := r4 to r3 do
      ellipse(cx - i, cx - i, cx + i + 1, cy + i + 1);

    { Numbers }

    font.name := 'Arial'; // font type

    font.size := 14;
    present := now;
    // s := ' ' + formatdatetime('ddd d', present) + ' ';
    sx := 'START';
    Sy := 'END';
    sz := 'CountDown';

    sx[2] := Upcase(sx[2]); { première lettre en majuscules }
    dx := textwidth(sx) div 2;
    dy := textheight(sx) div 2;
    if (posdate = 2) then
      font.color := clred
    else
      font.color := clgreen; // contour of text
    case posdate of { 0 is not display }
      1:
        for m := -1 to 1 do { contour }
          for n := -1 to 1 do
            Textout(cx + m - dx, cy - n + r5 div 2, sx); { Down }
      2:
        For m := -1 to 1 do
          for n := -1 to 1 do
            Textout(cx + m + 10 - dx, cy + n - r5 - dy, Sy); { Top }
      3:
        For m := -1 to 1 do
          for n := -1 to 1 do
            Textout(cx + m + (r5 - dx - dx) div 2, cy + n - dy, sz); { right }
    end;
    font.color := clwhite; // Text color

    case posdate of { 0 ne pas afficher }
      1:
        Textout(cx - dx, cy + r5 div 2, sx); { Down }
      2:
        Textout(cx - dx - 15, cy - r5 div 6 - dy, sz); { center }  // display application by finish
      3:
        Textout(cx + (r5 - dx - dx) div 2, cy - dy, sx); { right }
    end;
    posdate := 0;
    Pen.width := 1;

  end;

end;

procedure TfrmCountDown.GameOverMode(sGameOver: string);
begin
  // GameOver(Bmp1.canvas);
  posdate := 2;
  Colors[7] := clwhite;
  // plagecolo[maxplage] := Colors[7];
  Colors[8] := clwhite;
  SndPlaySound(PChar(sGameOver), SND_ASYNC);
  tmrFinish.enabled := False;
  ntakt := 0;

end;

procedure TfrmCountDown.DefaultHandler(var Message);
var
  ee: TWMMYMessage;
begin
  with TMessage(Message) do
  begin
    if (Msg = WM_OURMESSAGE) then
    begin
      ee.Msg := Msg;
      ee.Handle := wParam;
      ee.Info := lParam;
      // Checking if this message is not from us
      if ee.Handle <> Handle then
        WMMYMessage(ee);
    end
    else
      inherited DefaultHandler(Message);
  end;
end;

procedure TfrmCountDown.WMMYMessage(var Msg: TWMMYMessage);
begin
  ilongtime := ilongtime + Msg.Info;
  if not(ilongtime > 0) then
  begin
    Colors[7] := clwhite;
    Colors[8] := clwhite;

    tmrProcess.enabled := False;
    ntakt := 0;
    GameOverMode('');
    frmCountDown.chronoshow;
    if (boolfinish = False) then
      tmrFinish.enabled := true;
    MColor.enabled := true;

  end;
end;

initialization

WM_OURMESSAGE := RegisterWindowMessage('Our broadcast message');

end.
