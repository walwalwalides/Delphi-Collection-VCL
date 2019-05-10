{ ============================================
  Software Name : 	RegisterKey
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
  FileFolderReg = 'RegFile\';

type
  TfrmMain = class(TForm)
    RadGrpKeyRot: TRadioGroup;
    GrpBoxKey: TGroupBox;
    GrpControle: TGroupBox;
    bitbtnCreateKey: TBitBtn;
    edtKeyName: TEdit;
    edtSubKeyValue: TEdit;
    lblKeyName: TLabel;
    lblSubKeyValue: TLabel;
    bvlFeet: TBevel;
    lblKeyRoot: TLabel;
    lblSubKeyname: TLabel;
    edtSubKeyName: TEdit;
    BitBtnOK: TBitBtn;
    bvlKey: TBevel;
    RadGrpMethode: TRadioGroup;
    BitBtnGeneratRegFile: TBitBtn;
    RadGrpType: TRadioGroup;
    //Declaration proceduren
    procedure RadGrpKeyRotClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bitbtnCreateKeyClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure edtKeyNameChange(Sender: TObject);
    procedure edtSubKeyNameChange(Sender: TObject);
    procedure edtSubKeyValueChange(Sender: TObject);
    procedure BitBtnGeneratRegFileClick(Sender: TObject);
    procedure edtKeyNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FsHkey: HKEY;
    function SaveEnabled: Boolean;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property sHkey: HKEY read FsHkey write FsHkey;
  end;

var
  frmMain: TfrmMain;

implementation

uses ToolLib;

{$R *.dfm}

function TfrmMain.SaveEnabled: Boolean;
begin
  result := (Length(edtSubKeyName.Text) > 0) and (Length(edtSubKeyValue.Text) > 0);
end;

procedure TfrmMain.BitBtnGeneratRegFileClick(Sender: TObject);
var
  sKey, sSubn, sSubv: string;
  resKey: Boolean;
begin
  sKey := 'SOFTWARE\' + edtKeyName.Text;
  sSubn := edtSubKeyName.Text;
  sSubv := edtSubKeyValue.Text;
  try
    resKey := GenerateRegFile(FsHkey, sKey, sSubn, sSubv,RadGrpType.ItemIndex);
  finally
    if (resKey = true) then
      ShowMessage('File successfully created');
    BitBtnGeneratRegFile.Enabled := False;
  end;

end;

procedure TfrmMain.BitBtnOKClick(Sender: TObject);
var
  sKey, sSubn, sSubv: string;
begin
  RadGrpKeyRotClick(nil);
  lblKeyRoot.caption := lblKeyRoot.caption + edtKeyName.Text;
  sKey := 'SOFTWARE\' + edtKeyName.Text;
  if CheckKey(FsHkey, sKey) = False then
  begin
    CreateKey(FsHkey, sKey);
  end;

  BitBtnOK.Enabled := False;
  edtSubKeyName.Enabled := true;

  if (RadGrpType.ItemIndex = 1) then
  begin
    edtSubKeyValue.NumbersOnly := True;
  end
  else
    edtSubKeyValue.NumbersOnly := False;

  edtSubKeyValue.Enabled := true;
  edtSubKeyName.SetFocus;
end;

procedure TfrmMain.bitbtnCreateKeyClick(Sender: TObject);
var
  sKey, sSubn, sSubv: string;
  resKey: Boolean;
begin
  sKey := 'SOFTWARE\' + edtKeyName.Text;
  sSubn := edtSubKeyName.Text;
  sSubv := edtSubKeyValue.Text;
  try
    case RadGrpMethode.ItemIndex of
      0:
        resKey := writeRegStringM1(FsHkey, sKey, sSubn, sSubv,RadGrpType.ItemIndex);
      1:
        resKey := writeRegStringM2(FsHkey, sKey, sSubn, sSubv,RadGrpType.ItemIndex);
    end;

  finally
    if (resKey = true) then
      ShowMessage('key successfully created');
    bitbtnCreateKey.Enabled := False;
  end;
end;

procedure TfrmMain.edtKeyNameChange(Sender: TObject);
begin

  if Length(edtKeyName.Text) > 0 then
  begin

    BitBtnOK.Enabled := true
  end
  else
  begin
    RadGrpKeyRotClick(nil);
    BitBtnOK.Enabled := False;
  end;
end;

procedure TfrmMain.edtKeyNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    BitBtnOKClick(nil);
end;

procedure TfrmMain.edtSubKeyNameChange(Sender: TObject);
begin
  BitBtnGeneratRegFile.Enabled := SaveEnabled;
  bitbtnCreateKey.Enabled := SaveEnabled;
end;

procedure TfrmMain.edtSubKeyValueChange(Sender: TObject);
begin
  BitBtnGeneratRegFile.Enabled := SaveEnabled;
  bitbtnCreateKey.Enabled := SaveEnabled;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  PathFolderReg: string;
begin
  PathFolderReg := ExtractFilePath(Application.ExeName) + FileFolderReg;
  // ---------------------------------------  //
  RadGrpKeyRot.ItemIndex := -1;
  RadGrpMethode.ItemIndex := 0;
  RadGrpType.ItemIndex := 0;
  // ---------------------------------------  //
  lblKeyRoot.caption := 'Key  Root  : ';
  // ---------------------------------------  //
  forcedirectories(PathFolderReg);
  // ---------------------------------------  //
  edtKeyName.Clear;
  edtSubKeyName.Clear;
  edtSubKeyValue.Clear;
  // ---------------------------------------  //
  bitbtnCreateKey.Enabled := False;
  BitBtnGeneratRegFile.Enabled := False;
  BitBtnOK.Enabled := False;
  edtSubKeyName.Enabled := False;
  edtSubKeyValue.Enabled := False;
  GrpBoxKey.Enabled := False;

end;

procedure TfrmMain.RadGrpKeyRotClick(Sender: TObject);
begin
  lblKeyRoot.caption := 'Key  Root  : ';
  case RadGrpKeyRot.ItemIndex of
    - 1:
      begin
        RadGrpKeyRot.ItemIndex := -1;
        lblKeyRoot.caption := 'Key  Root  : ';
        GrpBoxKey.Enabled := False;
      end;
    0:
      begin

        RadGrpKeyRot.ItemIndex := 0;
        lblKeyRoot.caption := lblKeyRoot.caption + 'Computer\HKEY_LOCAL_MACHINE\SOFTWARE\';
        FsHkey := HKEY_LOCAL_MACHINE;
        GrpBoxKey.Enabled := true;
        // if (Length(edtKeyName.Text) > 0) then
        // edtKeyName.Clear;
        edtKeyName.SetFocus;
      end;
    1:
      begin
        RadGrpKeyRot.ItemIndex := 1;
        lblKeyRoot.caption := lblKeyRoot.caption + 'Computer\HKEY_CURRENT_USER\SOFTWARE\';
        FsHkey := HKEY_CURRENT_USER;
        GrpBoxKey.Enabled := true;
        // if (Length(edtKeyName.Text) > 0) then
        // edtKeyName.Clear;
        edtKeyName.SetFocus;
      end;

  end;

end;

end.
