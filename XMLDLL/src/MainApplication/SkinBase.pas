{ ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit SkinBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, JvSimpleXml,
  Dialogs, Forms, Vcl.Imaging.pngimage, ButtonEventList;

type
  TSkinBase = class(TComponent)
  private
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

constructor TSkinBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSkinBase.Destroy;
begin
  inherited Destroy;
end;

end.
 