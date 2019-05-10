{ ============================================
  Software Name : 	CheeckFont
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

const
  FolderVBS = 'VBS\';
  FolderFONTS = 'FONTS\';
  vbScriptname = 'InstallFont.VBS';

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edtFontName: TEdit;
    OpDlgFont: TOpenDialog;
    Bevel1: TBevel;
    lstboxFonts: TListBox;
    bvlHead: TBevel;
    BalloonHint1: TBalloonHint;
    btnCheckFontWinApi: TBitBtn;
    btnListOfFont: TBitBtn;
    btnInstallFont: TBitBtn;
    btnSelectFont: TBitBtn;
    lblFontname: TLabel;
    procedure btnInstallFontClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectFontClick(Sender: TObject);
    procedure btnCheckFontWinApiClick(Sender: TObject);
    procedure btnListOfFontClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtFontNameChange(Sender: TObject);
  private
    FFontName: string;
    FDirFont: string;

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property FontName: string read FFontName write FFontName;
    property DirFont: string read FDirFont write FDirFont;
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  ToolLib, System.Win.Registry, System.IOUtils;

{$R *.dfm}

const
  RegRootKey = HKEY_LOCAL_MACHINE;

var
  vbScriptPath: string;
  PathFolderVBS, PathFolderFonts: string;

procedure TFrmMain.btnCheckFontWinApiClick(Sender: TObject);
begin
  // Name := copy(edtFontName.text, 0, length(edtFontName.text) - 4);

  Try
    if (Screen.Fonts.IndexOf(FFontName) <> -1) then
    begin
      ShowMessage('Font : "' +FFontName+ '" is already installed');
    end
    else
    begin
      btnInstallFont.Font.Color := clGreen;
      btnInstallFont.Enabled := true;
    end;
  finally

  End;

end;

procedure TFrmMain.btnInstallFontClick(Sender: TObject);
var
  Iselect: Integer;
begin
  if FileExists(vbScriptPath) then
    DeleteFile(vbScriptPath);

  CreateScript(vbScriptPath, edtFontName.Text, FDirFont);

  SetCursor(Screen.Cursors[crHourGlass]);
  try
    ExecuteScript(PathFolderVBS, 'cscript.exe ' + (vbScriptPath), vbScriptname, 'vbs');
  finally
    SetCursor(Screen.Cursors[crDefault]);
    ShowMessage('Font : " ' + FontName + ' "' + ' is successfully installed');

    btnListOfFontClick(nil);

    Iselect := lstboxFonts.Items.IndexOf(FFontName);
    if (Iselect > -1) then
      lstboxFonts.Selected[Iselect] := true;
    btnInstallFont.Font.Color := clWindowText;
    btnInstallFont.Enabled := False;
  end;
end;

procedure TFrmMain.btnListOfFontClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Screen.Fonts.Count - 1 do
    lstboxFonts.Items.add(Screen.Fonts[I]);

end;

procedure TFrmMain.btnSelectFontClick(Sender: TObject);
var
  tmpFontName: string;
begin
  if OpDlgFont.Execute then
  begin
    tmpFontName := ExtractFileName(OpDlgFont.FileName);
    SetCursor(Screen.Cursors[crHourGlass]);
    try
      FDirFont := ExtractFileDir(OpDlgFont.FileName);
      edtFontName.Text := tmpFontName;
    finally
      SetCursor(Screen.Cursors[crDefault]);
      FFontName := TPath.GetFileNameWithoutExtension(OpDlgFont.FileName);
    end;

  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
var
  Iselect: Integer;
begin
  Iselect := lstboxFonts.Items.IndexOf(FFontName);
  if (Iselect > -1) then
    lstboxFonts.Selected[Iselect] := true;

end;

procedure TFrmMain.edtFontNameChange(Sender: TObject);
begin
  btnCheckFontWinApi.Enabled := (edtFontName.Text <> '');

end;

procedure TFrmMain.FormCreate(Sender: TObject);

begin
  { Initial editFontName }
  // -------------------------------------------  //
  edtFontName.Clear;
  edtFontName.Font.Style := [fsBold];
  edtFontName.ReadOnly := true;
  edtFontName.Alignment := taCenter;
  // -------------------------------------------  //
  { Initial OpDlgFont }
  // -------------------------------------------  //
  OpDlgFont.Filter := 'TrueType Fonts|*.ttf|OpenType Font|*.otf|Printer Font Metrics|*.pfm|Generic Font File|*.fon|Alle Types|*.*';
  // -------------------------------------------  //
  btnInstallFont.Enabled := False;
  btnCheckFontWinApi.Enabled := False;
  PathFolderVBS := ExtractFilePath(Application.ExeName) + FolderVBS;
  PathFolderFonts := ExtractFilePath(Application.ExeName) + FolderFONTS;
  forcedirectories(PathFolderVBS);
  forcedirectories(PathFolderFonts);
  vbScriptPath := PathFolderVBS + vbScriptname;
end;

end.
