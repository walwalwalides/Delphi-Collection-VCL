{ ============================================
  Software Name : 	CheecKtool
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2018 }
{ Email : WalWalWalides@gmail.com }
{ ******************************************** }
unit MainTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, RzStatus, Vcl.FileCtrl, Vcl.Menus;

type
  TfrmMainTools = class(TForm)
    mmo1: TMemo;
    redOut: TRichEdit;
    DirectoryListBox1: TDirectoryListBox;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    Plik1: TMenuItem;
    Zamknij1: TMenuItem;
    Pomoc1: TMenuItem;
    Informacjao1: TMenuItem;
    DriveComboBox1: TDriveComboBox;
    PageCtrlMain: TPageControl;
    TabSheetCheeck: TTabSheet;
    TabSheetinf: TTabSheet;
    TabSheetClear: TTabSheet;
    psRepair: TProgressBar;
    PbarTemporary: TProgressBar;
    btnGlowCheek: TButton;
    btnGlowLog: TButton;
    btnGlowChecktmp: TButton;
    btnGlowDeletetmp: TButton;
    S1: TMenuItem;
    S2: TMenuItem;
    {}
    procedure btnGlowCheekClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGlowLogClick(Sender: TObject);
    procedure btnGlowChecktmpClick(Sender: TObject);
    procedure btnGlowDeletetmpClick(Sender: TObject);
    procedure Zamknij1Click(Sender: TObject);
    procedure Informacjao1Click(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure S2Click(Sender: TObject);
  private
    procedure Verifying_DLL_BPL;
    function CheckLoadDLL(const DLLFileName: String; var ErrorCode: Cardinal; var ErrorString: string): Boolean;
    procedure ReadLogUser;
    procedure FindDocs(const Root: string);
    { Private declarations }
  public
    { Public declarations }


  end;


var
  frmMainTools: TfrmMainTools;

implementation

uses
  ToolLib;

{$R *.dfm}

const
  {Software Version}
  STversion = '0.0.0.1';
  {Constant Folder}
  FolderDlls='DLLUser';//name of the folder where  dlls stored
  FolderBPLs='BPLUser';

  {Constant File}
  logFile='UserLog.log';

  MSDLL_Core: array of string = ['concrt140', 'msvcp140', 'ucrtbase', 'vcruntime140', 'user32', 'Ntdll']; // Microsoft DLLs

  DLLUSER_Core: array of string = ['DLL1', 'DLL2', 'DLL3', 'DLL4', 'DLL5']; // User Dlls

  BPLUser: array of string = ['BPL1', 'BPL2'];  //User Blps   (be careful by lower and uppercase letter)

procedure TfrmMainTools.btnGlowChecktmpClick(Sender: TObject);
begin
  ListBox1.Clear;
  FindDocs(DirectoryListBox1.Directory);
  PbarTemporary.position := 0;
  if ListBox1.Items.Count > 0 then
    btnGlowDeletetmp.Enabled := True;
end;

procedure TfrmMainTools.btnGlowCheekClick(Sender: TObject);
begin
  btnGlowCheek.Cursor := crHourGlass;
  Verifying_DLL_BPL;
  btnGlowCheek.Cursor := crHandPoint;
end;

procedure TfrmMainTools.btnGlowLogClick(Sender: TObject);
begin
  redOut.Clear;
  ReadLogUser;
end;

function TfrmMainTools.CheckLoadDLL(const DLLFileName: String; Var ErrorCode: Cardinal; var ErrorString: string): Boolean;
Var
  DLL: HMODULE;
begin
  DLL := LoadLibraryEx(PChar(DLLFileName), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
  if DLL = 0 then
  begin
    ErrorCode := GetLastError;
    ErrorString := SysErrorMessage(ErrorCode);
    Result := False;
  end
  else
  begin
    FreeLibrary(DLL);
    Result := True;
  end;
end;

procedure TfrmMainTools.DriveComboBox1Change(Sender: TObject);
begin
  DirectoryListBox1.Drive := DriveComboBox1.Drive;
end;

procedure TfrmMainTools.ReadLogUser;
var
  F: TextFile;
  line: string;
  sDateTime: string;
  sLog: string;
  sPathLOg: string;
begin
  redOut.Paragraph.TabCount := 3;
  redOut.Paragraph.Tab[0] := 100;
  redOut.Paragraph.Tab[1] := 200;
  // redOut.Paragraph.Tab[2]:=300;
  redOut.SelAttributes.Style := redOut.SelAttributes.Style + [fsBold];
  redOut.SelAttributes.Style := redOut.SelAttributes.Style + [fsUnderline];
  redOut.SelText := 'DATETIME';
  redOut.SelAttributes.Style := redOut.SelAttributes.Style - [fsBold];
  redOut.SelAttributes.Style := redOut.SelAttributes.Style - [fsUnderline];
  redOut.SelText := ''#9'';
  redOut.SelAttributes.Style := redOut.SelAttributes.Style + [fsBold];
  redOut.SelAttributes.Style := redOut.SelAttributes.Style + [fsUnderline];
  redOut.SelText := 'LOG';
  redOut.SelAttributes.Style := redOut.SelAttributes.Style - [fsBold];
  redOut.SelAttributes.Style := redOut.SelAttributes.Style - [fsUnderline];
  redOut.SelText := ''#10'';
  { redOut.SelAttributes.Style := redOut.SelAttributes.Style + [fsBold];
    redOut.SelAttributes.Style := redOut.SelAttributes.Style + [fsUnderline];
    redOut.SelText:= 'Age';
    redOut.SelAttributes.Style := redOut.SelAttributes.Style - [fsBold];
    redOut.SelAttributes.Style := redOut.SelAttributes.Style - [fsUnderline];
    redOut.SelText:=#10; }
 sPathLOg:=ExtractFilePath(ParamStr(0)) +logFile;
  if fileExists(sPathLOg) then
  begin
    assignFile(F, sPathLOg);
    reset(F);
    while not EoF(F) do
    begin
      readln(F, line);
      sDateTime := copy(line, 1, pos('-', line) - 1);
      delete(line, 1, pos('-', line));
      { sSurname:= copy(line, 1, pos('-', line)-1);        delete(line, 1, pos('-', line)); }
      sLog := line;
      redOut.SelText := sDateTime + ''#9'' + sLog + { + #9 + sAge } ''#10'';
    end;
  end;
  // redOut.SelText := ''#10''#13'';
end;

procedure TfrmMainTools.S2Click(Sender: TObject);
begin
 Selectstyle;
end;

procedure TfrmMainTools.FormShow(Sender: TObject);
begin
  mmo1.Clear;
end;

procedure TfrmMainTools.Informacjao1Click(Sender: TObject);
begin
  ShowMessage('Tools for specific task' + #13 + 'Version : ' + STversion + #13 + 'A set of support tools for software' + #13 + 'Created by : '
     + 'walwalwalides' + #13 + 'Email : ' +'walwalwalides@gmail.com' +#13 +char(9)+'All rights reserved!');
end;

procedure TfrmMainTools.Verifying_DLL_BPL;
Var
  i: Integer;
  ErrorCode: Cardinal;
  ErrorString: string;
  sline: string;
  R: Boolean;
  pathUserDLL: string;
  i1, nl: Integer;
  SL, SLFiles: TStringList;
  SearchResult: TSearchRec;
  pathUserBPL: string;
begin
  mmo1.Lines.Clear;
  psRepair.barColor := clwhite;
  psRepair.position := 0;
  btnGlowCheek.Enabled := False;
  Application.ProcessMessages;
  try
    mmo1.Lines.Add('----------------------------------- Verifying Microsoft DLL -----------------------------------');
    R := True;
    for i := 0 to High(MSDLL_Core) do
    begin
      if not CheckLoadDLL(MSDLL_Core[i] + '.dll', ErrorCode, ErrorString) then
      begin
        mmo1.Lines.Add('Verifying ' + MSDLL_Core[i] + '.dll');
        mmo1.Lines.Add('   Error code: ' + ErrorCode.ToString + ' - ' + ErrorString);
        R := False;
      end;
      { if not CheckLoadDLL(MSDLL_Core[i] + 'd.dll', ErrorCode, ErrorString) then
        begin
        mmo1.Lines.Add('Verifying ' + MSDLL_Core[i] + 'd.dll');
        mmo1.Lines.Add('   Error code: ' + ErrorCode.ToString + ' - ' + ErrorString);
        R := False;
        end; }
      psRepair.position := psRepair.position + 10;
      Application.ProcessMessages;
    end;
    if R then
      mmo1.Lines.Add('Microsoft DLL library is already loaded');

    mmo1.Lines.Add('----------------------------------- Verifying User DLL -----------------------------------');
    pathUserDll := ExtractFilePath(Application.ExeName) + 'DLLUser\';
    R := True;
    for i := 0 to High(DLLUser_Core) do
    begin
      if not CheckLoadDLL(pathUserDll + DLLUser_Core[i] + '.dll', ErrorCode, ErrorString) then
      begin
        mmo1.Lines.Add('Verifying ' + DLLUser_Core[i] + '.dll');
        mmo1.Lines.Add('   Error code: ' + ErrorCode.ToString + ' - ' + ErrorString);
        R := False;
      end;
 
      psRepair.position := psRepair.position + 10;
      Application.ProcessMessages;

    end;
    if R then
    begin
      SL := TStringList.Create;         //Create a stringList
      try
        for i1 := 1 to ParamCount do
          SL.Add(ParamStr(i1));

        if SL.IndexOfName('project') = -1 then
          SL.Values['project'] := ExtractFilePath(ParamStr(0));

        if SL.IndexOfName(FolderDlls) = -1 then        //
          SL.Values[FolderDlls] := ExtractFilePath(ParamStr(0)) + FolderDlls;

        SLFiles := TStringList.Create;
        if FindFirst(SL.Values[FolderDlls] + '\*.dll', faAnyFile, SearchResult) = 0 then
        begin
          repeat
            nl := 20 - length(SearchResult.Name);
            sline := StringOfChar(char(32), nl);
            sline := SearchResult.Name + sline;
            // sline:=Copy(sline,1,20);
            // ShowMessage(IntToStr(Length(sline)));
            SLFiles.Add(StringReplace(sline, '', '', []) + '-> Ok');
          until FindNext(SearchResult) <> 0;

          FindClose(SearchResult);
        end;
        mmo1.Lines.Add(SLFiles.Text);
        mmo1.Lines.Add('User DLL library is already loaded');

      finally
        SLFiles.Free;
        SL.Free;

      end;

    end;

    mmo1.Lines.Add('----------------------------------- Verifying User BPL -----------------------------------');
     pathUserBPL :=ExtractFilePath(ParamStr(0))+ 'BPLUser\';
    R := True;

    for i := 0 to High(BPLUser) do
    begin

      if not fileExists(pathUserBPL+BPLUser[i] + '.bpl') then    //check package existence
      begin
        R := False;
        mmo1.Lines.Add('   Error code: "' + BPLUser[i] + '.bpl' + '" -> Not Found !');
        psRepair.barColor := clRed;
        exit;
      end;
      if not CheckLoadBPL(BPLUser[i] + '.bpl', ErrorCode, ErrorString) then   //check package functionality
      begin
        mmo1.Lines.Add('Verifying ' + BPLUser[i] + '.bpl');
        mmo1.Lines.Add('   Error code: ' + ErrorCode.ToString + ' - ' + ErrorString);
        R := False;
      end;


      psRepair.position := psRepair.position + 10;
      Application.ProcessMessages;
    end;
    if R then
    begin
      SL := TStringList.Create;         //Create a stringList
      try
        for i1 := 1 to ParamCount do
          SL.Add(ParamStr(i1));

        if SL.IndexOfName('project') = -1 then
          SL.Values['project'] := ExtractFilePath(ParamStr(0));

        if SL.IndexOfName(FolderDlls) = -1 then        //
          SL.Values[FolderDlls] := ExtractFilePath(ParamStr(0)) + FolderBPLs;

        SLFiles := TStringList.Create;
        if FindFirst(SL.Values[FolderDlls] + '\*.bpl', faAnyFile, SearchResult) = 0 then
        begin
          repeat
            nl := 20 - length(SearchResult.Name);
            sline := StringOfChar(char(32), nl);
            sline := SearchResult.Name + sline;
            // sline:=Copy(sline,1,20);
            // ShowMessage(IntToStr(Length(sline)));
            SLFiles.Add(StringReplace(sline, '', '', []) + '-> Ok');
          until FindNext(SearchResult) <> 0;

          FindClose(SearchResult);
        end;
        mmo1.Lines.Add(SLFiles.Text);
        mmo1.Lines.Add('User BPL library is already loaded');

      finally
        SLFiles.Free;
        SL.Free;

      end;

    end;

     mmo1.Lines.Add(sLineBreak);


    if R then
      mmo1.Lines.Add('----------------------------------- Verification successful -----------------------------------');

  finally
    psRepair.position := 0;
    btnGlowCheek.Enabled := True;
  end;
end;

procedure TfrmMainTools.Zamknij1Click(Sender: TObject);
begin
  Close;
end;

{$REGION 'Log File sort without delimate '}
// This is my solution
{ if fileExists('data.txt') then
  begin
  assignFile(F, 'data.txt');
  reset(F);
  len := 0;
  while not EoF(F) do
  begin
  readln(F, temp);
  inc(len);
  end;
  reset(F);
  for i := 1 to (len div 3) do
  begin
  for j := 1 to 3 do
  begin
  readln(F, arrData[j]);
  end;
  redOut.SelText:= arrData[1] +#9+ arrData[2] +#9+ arrData[3] + #10;
  end;
  end; }

{$ENDREGION}

procedure TfrmMainTools.FindDocs(const Root: string);
var
  SearchRec: TSearchRec;
  Folders: array of string;
  Folder: string;
  i: Integer;
  Last: Integer;
begin
  SetLength(Folders, 1);
  Folders[0] := Root;
  i := 0;
  while (i < length(Folders)) do
  begin
    Folder := IncludeTrailingBackslash(Folders[i]);
    Inc(i);
    if (FindFirst(Folder + '*.*', faAnyFile, SearchRec) = 0) then
    begin
      repeat
        Application.ProcessMessages;
        if not((SearchRec.Name = '.') or (SearchRec.Name = '..')) then
        begin
          Last := length(Folders);
          SetLength(Folders, Succ(Last)); // only folder
          Folders[Last] := Folder + SearchRec.Name;
          if ((SearchRec.Attr and faDirectory) = faDirectory) and ((SearchRec.Name = '__history') OR (ExtractFileExt(SearchRec.Name) = '.tmp') OR
            (ExtractFileExt(SearchRec.Name) = '.log')) then
          Begin
            ListBox1.Items.Add(Folder + SearchRec.Name);
            Application.ProcessMessages;
          End;
        end;
      until (FindNext(SearchRec) <> 0);
      FindClose(SearchRec);
    end;
  end;
end;

procedure TfrmMainTools.btnGlowDeletetmpClick(Sender: TObject);
var
  wyb: Integer;
  i: Integer;
begin
  if ListBox1.Items.Count > 0 then
  Begin
    wyb := MessageBox(Handle, PWideChar('Are you sure you want to delete the temporery folders in selected Folder?' + #13 +
      'The changes will be irreversible!'), 'history delete', MB_YESNO + MB_ICONQUESTION);
    if wyb = mrYes then
    Begin
      PbarTemporary.position := 0;
      PbarTemporary.MarqueeInterval := ListBox1.Items.Count;
      for i := 0 to ListBox1.Items.Count - 1 do
      Begin
        DeleteDirectory(ListBox1.Items.Strings[i]);
        ListBox1.Items.Strings[i] := 'DELETE!! - ' + ListBox1.Items.Strings[i];
        PbarTemporary.position := i;
        Application.ProcessMessages;
      End;
      PbarTemporary.position := 100;
      btnGlowDeletetmp.Enabled := False;
    End;
  End
  else
    ShowMessage('No historical change folders for selected Folder to be cleaned!');
end;

end.
