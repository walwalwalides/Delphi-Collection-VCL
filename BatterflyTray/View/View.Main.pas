{ ============================================
  Software Name : 	BatterflyTray
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Template, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, dxGDIPlusClasses;

type
  TfrmViewMain = class(TfrmTemplate)
    bitbtnEnter: TBitBtn;
    procedure bitbtnEnterClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmViewMain: TfrmViewMain;

implementation

uses
   View.Home;

{$R *.dfm}

procedure TfrmViewMain.bitbtnEnterClick(Sender: TObject);
begin
  inherited;
   Application.CreateForm(TfrmViewHome, frmViewHome);
  try
    frmViewHome.ShowModal;
  finally
    FreeAndNil(frmViewHome);
  end;
end;

end.
