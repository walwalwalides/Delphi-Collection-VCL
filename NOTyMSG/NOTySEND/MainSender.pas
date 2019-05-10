{ ============================================
  Software Name : 	NOTySEND
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit MainSender;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw, MSHtml, ActiveX, Vcl.Buttons, Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.Samples.Spin;

const
  FolderLibary = 'Libary\';
  FolderPng = 'png\';
  pngFile = 'test.png';
  FolderHtml = 'html\';
  htmlFile = 'Main.htm';

type
  TfrmMainSender = class(TForm)
    WebBrowser: TWebBrowser;
    memHtml: TMemo;
    edtMsg: TEdit;
    edtTitle: TEdit;
    btnSend: TBitBtn;
    bitbtnLoad: TBitBtn;
    btnWeb: TBitBtn;
    btnAddItem: TBitBtn;
    BitBtnPic: TBitBtn;
    imgPic: TImage;
    SPedtNumber: TSpinEdit;
    pnlBackroungIMG: TPanel;
    procedure btnSendClick(Sender: TObject);
    procedure bitbtnLoadClick(Sender: TObject);
    procedure btnWebClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure BitBtnPicClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    sAppPathLib: string;
    procedure SendMSG(const ATitle: string; const AMsg: string; const ANbr: LongInt);
    procedure WB_LoadHTML(HTMLCode: string);
    procedure LoadPicChoose;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMainSender: TfrmMainSender;

implementation

uses
  Vcl.Imaging.pngimage;

{$R *.dfm}

type
  TCopyDataStruct = packed record
    dwData: DWORD; // up to 32 bits of data to be passed to the receiving application
    cbData: DWORD; // the size, in bytes, of the data pointed to by the lpData member
    lpData: Pointer; // Points to data to be passed to the receiving application. This member can be nil.
  end;

procedure TfrmMainSender.SendMSG(const ATitle: string; const AMsg: string; const ANbr: LongInt);
var
  stringToSend: string;
  copyDataStruct: TCopyDataStruct;
  hwnd: THandle;
begin
  // get the handle of the window
  hwnd := FindWindow('TfrmMainRecieve', nil);
  stringToSend := 'NOTIFY  ' + ATitle + '"  ' + AMsg + '"00' + IntToStr(ANbr) + '"00"  ' + pngFile + '"10' + IntToStr(ANbr) +
    '"100"100"100"100"100"10000000000000000"p00000000000';
  copyDataStruct.dwData := 0; // use it to identify the message contents
  copyDataStruct.cbData := 1 + Length(stringToSend);
  copyDataStruct.lpData := PChar(stringToSend);
  // SendData(copyDataStruct);
  SendMessage(hwnd, wm_CopyData, frmMainSender.Handle, Integer(@copyDataStruct))
end;

var
  Doc: IHTMLDocument2;
  TempFile: string;
  xBody: IHTMLElement;
  xLoaded: Boolean;
  onlyOnce: Boolean;

procedure TfrmMainSender.WB_LoadHTML(HTMLCode: string);
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  xLoaded := False;
  WebBrowser.Navigate('about:blank');
  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

  if Assigned(WebBrowser.Document) then
  begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := HTMLCode;
        sl.SaveToStream(ms);
        ms.Seek(0, 0);
        (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
      finally
        ms.Free;
      end;
    finally
      sl.Free;
      Doc := WebBrowser.Document as IHTMLDocument2;
    end;
  end;
end;

procedure TfrmMainSender.LoadPicChoose;
var
  sPathtarget: string;
  Stream: TMemoryStream;
  Image: TPngImage;
begin
  if not DirectoryExists(sAppPathLib + FolderPng) then
    ForceDirectories(sAppPathLib + FolderPng);
  sPathtarget := sAppPathLib + FolderPng + pngFile;
  if FileExists(sPathtarget) then
  begin
    Stream := TMemoryStream.Create;
    try
      Stream.LoadFromFile(sPathtarget);
      Image := TPngImage.Create;
      try
        Stream.Position := 0;
        Image.LoadFromStream(Stream);
        imgPic.Picture.Graphic := Image;
      finally
        Image.Free;
      end;
    finally
      Stream.Free;
    end;
  end;
end;

function ReadMWord(f: TFileStream): Word;
type
  TMotorolaWord = record
    case Byte of
      0:
        (Value: Word);
      1:
        (Byte1, Byte2: Byte);
  end;
var
  MW: TMotorolaWord;
begin
  { It would probably be better to just read these two bytes in normally }
  { and then do a small ASM routine to swap them.  But we aren't talking }
  { about reading entire files, so I doubt the performance gain would be }
  { worth the trouble. }
  f.read(MW.Byte2, SizeOf(Byte));
  f.read(MW.Byte1, SizeOf(Byte));
  Result := MW.Value;
end;

procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
type
  TPNGSig = array [0 .. 7] of Byte;
const
  ValidSig: TPNGSig = (137, 80, 78, 71, 13, 10, 26, 10);
var
  Sig: TPNGSig;
  f: TFileStream;
  x: Integer;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    f.read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then
        Exit;
    f.Seek(18, 0);
    wWidth := ReadMWord(f);
    f.Seek(22, 0);
    wHeight := ReadMWord(f);
  finally
    f.Free;
  end;
end;

procedure TfrmMainSender.BitBtnPicClick(Sender: TObject);
var
  sPathtarget: string;
  x, y: Word;
begin
  if not DirectoryExists(sAppPathLib + FolderPng) then
    ForceDirectories(sAppPathLib + FolderPng);
  sPathtarget := sAppPathLib + FolderPng + pngFile;

  // if u wanna choose Picture
  with TOpenDialog.Create(self) do
    try
      Caption := 'Open Image';
      Options := [ofPathMustExist, ofFileMustExist];
      Filter := 'images (*.png)|*.PNG';
      InitialDir := ExtractFileDir(Application.ExeName);
      if Execute then
      begin
        GetPNGSize(FileName, x, y);
        if ((x <= 48) or (y <= 48)) then // max H =48 max w=48
        begin
          imgPic.Picture.LoadFromFile(FileName);
          imgPic.Picture.SaveToFile(sPathtarget);
        end
        else
        begin
          MessageDlg('Size picture not allow !,W : ' + (x).ToString + ' H : ' + (y).ToString + '.', mtWarning, [mbOK], 0);
        end;
      end;
    finally
      Free;
    end;

end;

procedure TfrmMainSender.btnAddItemClick(Sender: TObject);
begin
  WebBrowser.OleObject.Document.getElementById('items').innerHTML := '<div id="context"><div id="icon" style="background-color:white; "><img src="' +
    sAppPathLib + FolderPng + pngFile + '" /><div id="title">' + edtTitle.Text + '</div><div id="clear"></div><div id="description">' + edtMsg.Text +
    ' </div></div><div id="time">' + TimeToStr(now) + '<br>' + DateToStr(now) + '</div></div>';
end;

procedure TfrmMainSender.bitbtnLoadClick(Sender: TObject);
var
  pathtargetHmtl: string;
begin
  pathtargetHmtl := sAppPathLib + FolderHtml + htmlFile;
  if (bitbtnLoad.Caption = 'Load') then
  begin
    memHtml.Lines.LoadFromFile(pathtargetHmtl);
    bitbtnLoad.Caption := 'Save';
    Exit;
  end;

  if (bitbtnLoad.Caption = 'Save') then
  begin
    memHtml.Lines.SaveToFile(pathtargetHmtl);
    bitbtnLoad.Caption := 'Load';
    Exit;
  end;

end;

procedure TfrmMainSender.btnSendClick(Sender: TObject);
begin
  SendMSG(edtTitle.Text, edtMsg.Text, SPedtNumber.Value)
end;

procedure TfrmMainSender.btnWebClick(Sender: TObject);
begin
  WB_LoadHTML(memHtml.Text);
end;

procedure TfrmMainSender.FormCreate(Sender: TObject);
begin
  // imgPic.Stretch := True;
  imgPic.Center := true;
  imgPic.Proportional := true;
  sAppPathLib := ExtractFilePath(Application.ExeName) + FolderLibary;
end;

procedure TfrmMainSender.FormShow(Sender: TObject);
begin
  LoadPicChoose;

end;

end.
