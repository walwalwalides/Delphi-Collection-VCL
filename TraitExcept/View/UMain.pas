{ ============================================
  Software Name : 	TraitException
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UBase, Vcl.StdCtrls, Vcl.ExtCtrls, System.IniFiles, System.Actions, Vcl.ActnList, Vcl.Menus;

type
  EMyException = class(Exception)
  private
    FErrorCode: integer;
  public
    constructor CreateErrCode(const Msg: string; const ErrCode: integer);
    property ErrorCode: integer read FErrorCode write FErrorCode;
  end;

  TfrmMain = class(TfrmBase)
    LblMessage: TLabel;
    btnException: TButton;
    pnlSignal: TPanel;
    radGrpState: TRadioGroup;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    A2: TMenuItem;
    actAbout1: TMenuItem;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actShowInExplorer: TAction;
    actOpenFolder: TAction;
    actExit: TAction;
    actOption: TAction;
    actAbout: TAction;
    Exit2: TMenuItem;
    Procedure TraitException(Sender: TObject; E: Exception);
    procedure btnExceptionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

  end;

  TWork = class
  private
    Dest: Boolean;
    Name: String;
  Public
    constructor create(Name: string; const Construction: Boolean; const destruction: Boolean);
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;
  MyException: EMyException;

implementation

{$R *.dfm}

uses uSignal,uAbout;

var
  istate: byte;

constructor EMyException.CreateErrCode(const Msg: string; const ErrCode: integer);
begin
  inherited create(Msg);
  ErrorCode := ErrCode;
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  F: TfrmAbout;
begin

  inherited;

  if not Assigned(F) then
    Application.CreateForm(TfrmAbout, F);
  F.Position := poMainFormCenter;
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmMain.btnExceptionClick(Sender: TObject);

var
  W: TWork;
  ani: TAniCheckThread;
  r: TRect;
  Berror1, Berror2: Boolean;
begin

  inherited;
  self.Invalidate;
  case radGrpState.ItemIndex of
    0:
      begin
        Berror1 := false;
        Berror2 := false;
      end;
    1:
      begin
        Berror1 := True;
        Berror2 := false;
      end;
    2:
      begin
        Berror1 := false;
        Berror2 := True;
      end;
  end;
  r := pnlSignal.clientrect;
  InflateRect(r, -pnlSignal.bevelwidth, -pnlSignal.bevelwidth);
  ani := TAniCheckThread.create(pnlSignal, r, pnlSignal.Color, clRed, 15);
  btnException.Enabled := false;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Sleep(3150); // Do SomeWork
  btnException.Enabled := True;
  ani.Terminate;
  Screen.Cursor := crDefault;

  self.Refresh;
  W := nil;
  try
    W := TWork.create('Work_Error', Berror1, Berror2);
  finally

    W.free;
  end;
  showmessage('Everything is fine.');

end;

Procedure TfrmMain.TraitException(Sender: TObject; E: Exception);
begin
  LblMessage.Caption := '---------------------';
  Application.MessageBox(PChar(E.Message), PChar(Application.Title), MB_OK + MB_ICONERROR);
  ExecException('Exception n°' + istate.ToString);
end;

procedure TfrmMain.FormCreate(Sender: TObject);

var
  ini: TIniFile;
  iniPath: string;
  RegistraPreVenda: String;
begin
  iniPath := ExtractFilePath(Application.ExeName);
  try
    ini := TIniFile.create(iniPath + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini'));
    ini.WriteString('SOFTWARE', 'START', Datetimetostr(now));
  finally
    ini.free;
  end;
  inherited;
  Position := poMainFormCenter;
  WindowState := wsNormal;
  Application.OnException := TraitException;

end;

{ TWork }

constructor TWork.create(Name: string; const Construction: Boolean; const destruction: Boolean);
begin
  inherited create;
  self.Name := Name;
  self.Dest := destruction;
  if (Construction) then
  begin
    istate := 1;
    raise EMyException.CreateErrCode('A problem occurred', 1);
  end;

end;

destructor TWork.Destroy;
begin
  if (Dest) then
  begin
    istate := 2;
    raise EMyException.CreateErrCode('A problem occurred', 2);
  end;

  inherited;

end;

end.
