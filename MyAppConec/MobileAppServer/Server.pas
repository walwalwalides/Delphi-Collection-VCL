{ ============================================
  Software Name : 	MyAppConec
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit Server;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Types,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TForm3.FormCreate(Sender: TObject);
begin
  Position := TFormPosition.MainFormCenter;
  Label1.Position.x := 3;
  Label1.Position.y := 3;
  Label1.StyledSettings := [TStyledSetting.Family, TStyledSetting.Size, TStyledSetting.FontColor];
//  Label1.TextSettings.Font.Style := [TFontStyle.fsBold];
  Label1.TextSettings.Font.Size := 25;
//  Label1.TextSettings.Font.Style := Label1.TextSettings.Font.Style + [TFontStyle.fsBold];
  Label1.Text := 'Starting Time : '+DateTimeToStr(Now);
end;

end.
