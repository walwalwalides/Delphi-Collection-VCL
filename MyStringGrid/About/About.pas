{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ ******************************************** }
unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ShellApi, acPNG, dxGDIPlusClasses;

type
  TfrmAbout = class(TForm)
    Logo: TImage;
    lblTitle: TLabel;
    Texte: TMemo;
    Url: TLinkLabel;
    procedure UrlLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
 frmAbout.BorderIcons:=[biSystemMenu] ;
end;

procedure TfrmAbout.UrlLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
// Ouvre le navigateur sur mon site en cliquant le lien
 ShellExecute(Handle, 'open', PChar(Link), Nil, Nil, SW_SHOWDEFAULT);
end;

end.
