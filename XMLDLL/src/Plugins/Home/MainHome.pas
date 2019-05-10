unit MainHome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, Vcl.Imaging.pngimage,Buttons, PngFunctions, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin;

type
  TfrmMainHome = class(TForm)
    imlIcons: TImageList;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    tbtnHome: TToolButton;
    ToolButton3: TToolButton;
    tbtnAbout: TToolButton;
    ToolButton4: TToolButton;
    tbtnClose: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainHome: TfrmMainHome;

implementation

{$R *.dfm}


procedure TfrmMainHome.ToolButton1Click(Sender: TObject);
begin
     close;
end;

end.
