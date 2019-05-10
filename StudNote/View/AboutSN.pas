unit AboutSN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ShellApi, acPNG;

type
  TfrmAboutSN = class(TForm)
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
  frmAboutSN: TfrmAboutSN;

implementation

{$R *.dfm}

procedure TfrmAboutSN.FormCreate(Sender: TObject);
begin
frmAboutSN.BorderIcons:=[biSystemMenu] ;
end;

procedure TfrmAboutSN.UrlLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
// Ouvre le navigateur sur mon site en cliquant le lien
 ShellExecute(Handle, 'open', PChar(Link), Nil, Nil, SW_SHOWDEFAULT);
end;

end.
