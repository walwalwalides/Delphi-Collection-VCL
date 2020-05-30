{ ============================================
  Software Name : 	SoftwareLicense
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : walwalwalides@gmail.com }
{ GitHub : https://github.com/walwalwalides }
{ ******************************************** }
unit uExScrollBox;
interface
uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
  Buttons, ExtCtrls, shellapi, acPNG, Messages, Variants;

type
  TExScrollBox =  Class (TScrollBox)
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;

  private
    FOnScrollVert: TNotifyEvent;
    FOnScrollHorz: TNotifyEvent;
  public
    Property OnScrollVert: TNotifyEvent read FOnScrollVert Write FOnScrollVert;
    Property OnScrollHorz: TNotifyEvent read FOnScrollHorz Write FOnScrollHorz;
  End;

implementation



{ TExScollBox }

procedure TExScrollBox.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  if Assigned(FOnScrollHorz) then
    FOnScrollHorz(Self);
end;

procedure TExScrollBox.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  if Assigned(FOnScrollVert) then
    FOnScrollVert(Self);
end;

end.
