{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit uIConnection;

interface

uses ZConnection;

type
  IConnection = interface
    ['{1CCCAD36-4A8C-46D9-8964-0C538CEFAAED}']
    function GetConnection: TZConnection;
    function GetSQL: string;
  end;

implementation

end.
