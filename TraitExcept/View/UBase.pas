{ ============================================
  Software Name : 	Traitexception
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit UBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,   ComCtrls,
   Rtti,  ActnList, Menus, Vcl.ExtCtrls;

type
  TfrmBase = class(TForm)
    TmrException: TTimer;
    procedure TmrExceptionTimer(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
    procedure ExecException(AMsgExcept: String);
  end;

var
  frmBase: TfrmBase;

implementation

uses uProgExcep;
{$R *.dfm}
{ TFBase }



procedure TfrmBase.TmrExceptionTimer(Sender: TObject);
begin
  TmrException.Enabled := False;

end;

procedure TfrmBase.ExecException(AMsgExcept: String);
begin
  TmrException.Enabled := False;
  if frmProgExcep = nil then
    Application.CreateForm(TfrmProgExcep, frmProgExcep);
  frmProgExcep.MsgExcept := AMsgExcept;
  frmProgExcep.ShowModal;
  TmrException.Enabled := True;
end;



end.
