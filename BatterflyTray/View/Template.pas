{ ============================================
  Software Name : 	BatterflyTray
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Template;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, dxGDIPlusClasses;

type
  TfrmTemplate = class(TForm)
    pnlHead: TPanel;
    imgExit: TImage;
    procedure FormCreate(Sender: TObject);
    procedure imgExitClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmTemplate: TfrmTemplate;

implementation

{$R *.dfm}

procedure TfrmTemplate.FormCreate(Sender: TObject);
begin
  Width := 600;
  Height := 600;
  BorderStyle := bsNone;
  Position:=poMainFormCenter;

end;

procedure TfrmTemplate.imgExitClick(Sender: TObject);
begin
Close;
end;

end.
