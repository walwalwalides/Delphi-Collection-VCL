{ ============================================
  Software Name : 	TColorCSV
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, acPNG, AdvGlowButton;

type
  TAboutBox = class(TForm)
    AboutPanel: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Author: TLabel;
    SepBevel: TBevel;
    ProgramIcon2: TImage;
    btnGlowOk: TAdvGlowButton;
    Panel1: TPanel;
    linklblGitHub: TLinkLabel;
    procedure btnGlowOkClick(Sender: TObject);
    procedure linklblGitHubLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses ShellApi;

{$R *.dfm}

procedure TAboutBox.btnGlowOkClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  Color := RGB(46, 141, 230);
  KeyPreview := True;
end;

procedure TAboutBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ord(Key) = VK_RETURN then
  begin
//    Key := 0; // Prevent Beeping
    Close;
  end;
end;

procedure TAboutBox.linklblGitHubLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(Handle, 'open', PChar(Link), Nil, Nil, SW_SHOWDEFAULT);
end;

end.
