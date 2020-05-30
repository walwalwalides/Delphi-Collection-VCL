{ ============================================
  Software Name : 	SoftwareLicense
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : walwalwalides@gmail.com }
{ GitHub : https://github.com/walwalwalides }
{ ******************************************** }

unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
  Buttons, ExtCtrls, shellapi, acPNG, Messages, Variants;

type

  TScrollBox =  Class (TScrollBox)
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;

  private
    FOnScrollVert: TNotifyEvent;
    FOnScrollHorz: TNotifyEvent;
  public
    Property OnScrollVert: TNotifyEvent read FOnScrollVert Write FOnScrollVert;
    Property OnScrollHorz: TNotifyEvent read FOnScrollHorz Write FOnScrollHorz;
  End;

  TfrmAbout = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    OKButton: TButton;
    ScrollBox1: TScrollBox;
    Aboutlbl: TLabel;
    Labelurl: TLabel;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    // procedure LabelurlClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure LabelurlClick(Sender: TObject);
    procedure ScrollBox1Click(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure MyScrollHorz(Sender: TObject);
    procedure MyScrollVert(Sender: TObject);

  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;
  AppDir: String;

implementation

{$R *.DFM}

uses Main;

procedure TfrmAbout.FormActivate(Sender: TObject);
begin
  Aboutlbl.caption := char(9) + char(9) +
    'Copyright (C) 2020 - 2021 - WalWalWalides' + char(10) + char(10) +

    'SoftwareLicense is free.You don''t have to pay for it, and you can use it any'
    + char(10) +
    'way you want. It is developed as an Open Source project under the GNU' +
    char(10) +
    'General Public License (GPL). That means you have full access to the source'

    + char(10) + 'code of this program. You can find it at GitHub here: ' +
    'https://github.com/walwalwalides' + char(10) +

    'The General Public License (GPL) is shipped with the installer-package and'
    + char(10) + 'should be located in the same folder as this file (gpl.txt).'
    + char(10) +
    'If you simply wish to install and use this software, you need only be aware'
    + char(10) +
    'of the disclaimer conditions in the license, which are set out below.' +
    char(10) +

    'NO WARRANTY' + char(10) +

    'Because the program is licensed free of charge, there is no warranty for the'
    + char(10) +
    'program, to the extent permitted by applicable law.  Except when otherwise'
    + char(10) +
    'stated in writing the copyright holders and/or other parties provide the' +
    char(10) +
    'program "as is" without warranty of any kind, either expressed or implied,'
    + char(10) +
    'including, but not limited to, the implied warranties of merchantability and'
    + char(10) +
    'fitness for a particular purpose. The entire risk as to the quality and' +
    char(10) +
    'performance of the program is with you.  Should the program prove defective,'
    + char(10) +
    'you assume the cost of all necessary servicing, repair or correction.' +
    char(10) + char(10) +
    'In no event unless required by applicable law or agreed to in writing will'
    + char(10) +
    'any copyright holder, or any other party who may modify and/or redistribute'
    + char(10) +
    'the program as permitted above, be liable to you for damages, including any'
    + char(10) +
    'general, special, incidental or consequential damages arising out of the use'
    + char(10) +
    'or inability to use the program (including but not limited to loss of data'
    + char(10) +
    'or data being rendered inaccurate or losses sustained by you or third' +
    char(10) +
    'parties or a failure of the program to operate with any other programs),' +
    char(10) +
    'even if such holder or other party has been advised of the possibility of'
    + char(10) + 'such damages.'

end;

{ procedure TAboutBox.LabelurlClick(Sender: TObject);
  begin
  ShellExecute(Self.Handle, nil, PChar(Labelurl.caption), nil, nil, SW_SHOW);
  end; }

procedure TfrmAbout.OKButtonClick(Sender: TObject);
begin
  if Not(LicenseRead) then
    // if we have no record of the license being agreed to, ask
    iF MessageDlg('Do You Agree With The Terms Of The License?', mtConfirmation,
      [mbYes, mbNo], 0, mbYes) = mrYes then
      LicenseRead := True;
end;

procedure TfrmAbout.ScrollBox1Click(Sender: TObject);
begin
  //
  if (ScrollBox1.VertScrollBar.range = 1000) then
    if (OKButton.Enabled = false) then
      OKButton.Enabled := True;

end;

procedure TfrmAbout.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if (ScrollBox1.VertScrollBar.range = 1000) then
    if (OKButton.Enabled = false) then
      OKButton.Enabled := True;
end;


procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  ScrollBox1.OnScrollVert := MyScrollVert;
  ScrollBox1.OnScrollHorz := MyScrollHorz;

end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  Self.caption := 'About';
  ProductName.caption := 'Product Name : SoftwareLicense';
  Version.caption := 'Version: ' + CurVersion;
  AppDir := ExtractFilePath(Application.ExeName);
  Labelurl.caption := AppDir + 'Doc\SoftwareLicense.html';
end;

procedure TfrmAbout.LabelurlClick(Sender: TObject);
begin
  if FileExists(Labelurl.caption) then
    ShellExecute(Self.Handle, nil, PChar(Labelurl.caption), nil, nil, SW_SHOW)
  else
    ShowMessage
      ('Doc Directory not found, download from https://github.com/walwalwalides');
end;

{ TScollBox }

procedure TScrollBox.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  if Assigned(FOnScrollHorz) then
    FOnScrollHorz(Self);
end;

procedure TScrollBox.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  if Assigned(FOnScrollVert) then
    FOnScrollVert(Self);
end;

procedure TfrmAbout.MyScrollVert(Sender: TObject);
begin
  Scrollbox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position

    if (ScrollBox1.VertScrollBar.range = 1000) then
    if (OKButton.Enabled = false) then
      OKButton.Enabled := True;

end;

procedure TfrmAbout.MyScrollHorz(Sender: TObject);
begin
  Scrollbox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position
end;


end.
