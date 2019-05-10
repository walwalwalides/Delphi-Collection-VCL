{ ============================================
  Software Name : 	CheeckTooL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2018                             }
{ Email : WalWalWalides@gmail.com              }
{ ******************************************** }

unit Unit1;

interface
function CreateBLP:Boolean;
implementation

uses
  Vcl.Dialogs;

function CreateBLP:Boolean;
begin
  Result:=true;
  ShowMessage('Hallo the World');
end;

exports CreateBLP name 'CreateBPL';

end.
