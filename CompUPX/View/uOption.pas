{ ============================================
  Software Name : 	CompUPX
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uOption;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI, XPMan, ComCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmOption = class(TForm)
    XPLook: TXPManifest;
    CompressionBox: TGroupBox;
    CompressionBar: TTrackBar;
    LabTauxCompression: TLabel;
    BruteBox: TCheckBox;
    UBruteBox: TCheckBox;
    OptionsBox: TGroupBox;
    RessourcesBox: TCheckBox;
    ExportsBox: TCheckBox;
    IconesBox: TComboBox;
    RelocsBox: TCheckBox;
    DiversBox: TGroupBox;
    CompatibiliteBox: TCheckBox;
    ForceBox: TCheckBox;
    BackupBox: TCheckBox;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    ShpComp: TShape;
    ShpDecomp: TShape;
    lblCompress: TLabel;
    lblDecomp: TLabel;
    procedure CompressionBarChange(Sender: TObject);
    procedure BruteBoxClick(Sender: TObject);
    procedure UBruteBoxClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmOption: TfrmOption;

implementation

{$R *.dfm}



procedure TfrmOption.BruteBoxClick(Sender: TObject);
begin
 if BruteBox.Checked  then
  UBruteBox.Checked := False;
end;

procedure TfrmOption.UBruteBoxClick(Sender: TObject);
begin
 if UBruteBox.Checked  then
  BruteBox.Checked := False;
end;

procedure TfrmOption.CompressionBarChange(Sender: TObject);
begin
 LabTauxCompression.Caption := IntToStr(CompressionBar.Position);
end;

end.
