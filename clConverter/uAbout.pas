{ ============================================
  Software Name : 	clConverter
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ShellApi, acPNG;

type
  TfrmAbout = class(TForm)
    Logo: TImage;
    Titre: TLabel;
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
  BorderIcons:=[biSystemMenu] ;
end;

procedure TfrmAbout.UrlLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
// Ouvre le navigateur sur mon site en cliquant le lien
 ShellExecute(Handle, 'open', PChar(Link), Nil, Nil, SW_SHOWDEFAULT);
end;

end.
