{ ============================================
  Software Name : 	clConverter
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList;

type
  TfrmMain = class(TForm)
    trackbarR: TTrackBar;
    TrackBarB: TTrackBar;
    TrackBarG: TTrackBar;
    pnlColor: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    LblG: TLabel;
    LblB: TLabel;
    LblR: TLabel;
    puMenuConverter: TPopupMenu;
    MMMain: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actShowInExplorer: TAction;
    actOpenFolder: TAction;
    actExit: TAction;
    actOption: TAction;
    actAbout: TAction;
    acToHTML: TAction;
    ppHTML: TMenuItem;
    PROCEDURE RGB_onchage(sender: TObject);
    procedure pnlColorClick(sender: TObject);
    procedure pnlColorMouseLeave(sender: TObject);
    procedure actAboutExecute(sender: TObject);
    procedure actExitExecute(sender: TObject);
    procedure actOpenFolderExecute(sender: TObject);
    procedure acToHTMLExecute(sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmMain: TfrmMain;
  R, G, B: Byte;

implementation

{$R *.dfm}

uses ClipBrd, uAbout;

procedure TfrmMain.actAboutExecute(sender: TObject);
var
  F: TfrmAbout;
begin

  inherited;

  if not Assigned(F) then
    Application.CreateForm(TfrmAbout, F);
  F.Position := poMainFormCenter;
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmMain.actExitExecute(sender: TObject);
begin
  Application.Terminate;
end;

function ColorToHtml(Color: TColor): string;
var
  COL: LongInt;
begin
  COL := ColorToRGB(Color);
  Result := '#' + IntToHex(COL and $FF, 2) + IntToHex(COL shr 8 and $FF, 2) + IntToHex(COL shr 16 and $FF, 2);  {  convert TColor to Integer to remove the higher bits }
end;

function ColorToHtml2(Clr: TColor): string;
begin
  Result := IntToHex(Clr, 6);
  Result := '#' + Copy(Result, 5, 2) + Copy(Result, 3, 2) + Copy(Result, 1, 2);
end;

function HtmlToColor(Color: string): TColor;
begin
  Result := StringToColor('$' + Copy(Color, 6, 2) + Copy(Color, 4, 2) + Copy(Color, 2, 2));
end;

function HexToColor(sColor: string): TColor;
begin
  Result := RGB(
    { get red value }
    StrToInt('$' + Copy(sColor, 1, 2)),
    { get green value }
    StrToInt('$' + Copy(sColor, 3, 2)),
    { get blue value }
    StrToInt('$' + Copy(sColor, 5, 2)));
end;

function ColorToHexDelphi(Color: TColor): string;
begin
  Result := '$00' + IntToHex(GetBValue(Color), 2) + IntToHex(GetRValue(Color), 2) + IntToHex(GetGValue(Color), 2);
end;

function TColorToHex(Color: TColor): string;
begin
  Result := IntToHex(GetRValue(ColorToRGB(Color)), 2) + IntToHex(GetGValue(ColorToRGB(Color)), 2) + IntToHex(GetBValue(ColorToRGB(Color)), 2);
end;

procedure TfrmMain.acToHTMLExecute(sender: TObject);
var
  ColorTemp: TColor;
  ident: string;
begin
  if (ppHTML.Caption = '') then
    exit;

  if (ppHTML.Caption = '&ToHTML') then
  begin
    pnlColor.Caption := ColorToHtml(StringToColor(pnlColor.Caption));
    ppHTML.Caption := '&ToHEX';
    exit;
  end;

  if (ppHTML.Caption = '&ToHEX') then
  Begin
    pnlColor.Caption := ColorToHexDelphi(HtmlToColor(pnlColor.Caption));
    ppHTML.Caption := '&ToHTML';
    exit;
  End;

  // ColorTemp  := HtmlToColor(Edit1.Text); // #808080 -----> $808080 (clGray)
  // ColorToIdent(StringToColor(IntToStr(ColorTemp)), ident); // ---> ident = clGray
  // Edit2.Text := ident; // clGray

end;

procedure TfrmMain.actOpenFolderExecute(sender: TObject);
begin
  //
end;

procedure TfrmMain.pnlColorClick(sender: TObject);

var
  sColor: string;
begin
  sColor := pnlColor.Caption;
  Clipboard.AsText := sColor;
  pnlColor.ShowHint := true;
end;

procedure TfrmMain.pnlColorMouseLeave(sender: TObject);
begin
  pnlColor.ShowHint := false;
end;

procedure TfrmMain.RGB_onchage(sender: TObject);
begin
  R := Byte(trackbarR.Position);
  G := Byte(TrackBarG.Position);
  B := Byte(TrackBarB.Position);

  LblR.Caption := R.ToString;
  LblG.Caption := G.ToString;
  LblB.Caption := B.ToString;

  pnlColor.Color := RGB(R, G, B);
  pnlColor.Caption := colortostring(pnlColor.Color);

end;

end.
