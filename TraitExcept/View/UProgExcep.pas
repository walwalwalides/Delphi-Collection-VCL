{ ============================================
  Software Name : 	TraitException
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit UProgExcep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, UBase,
  Dialogs, ExtCtrls, StdCtrls, JvProgressBar, ComCtrls, Generics.Collections,
  Vcl.Samples.Gauges;

type
  TfrmProgExcep = class(TfrmBase)
    Timer: TTimer;
    Gauge1: TGauge;

    procedure CopyLastException;

    procedure ExportExceptiontxt;

    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    MsgExcept, Filtro: String;
    { Public declarations }
  end;

var
  frmProgExcep: TfrmProgExcep;
  PathLocal, PathRemoto, PathCheck, JsonString: String;

implementation

uses
  UMain;

{$R *.dfm}
{$REGION 'Infra'}

procedure TfrmProgExcep.FormShow(Sender: TObject);
begin
  ForceDirectories(ExtractFilePath(Application.ExeName) + 'Exception');
  Timer.Enabled := True;
end;

procedure TfrmProgExcep.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmProgExcep := nil;
end;

procedure TfrmProgExcep.CopyLastException;
var
  ipos: Integer;

begin

  try
    ipos := 0;
    try
      Gauge1.Progress := ipos;
      //
      if CopyFile(PChar(ExtractFilePath(Application.ExeName) + 'Exception.ini'), PChar(PathCheck), False) then
      begin
        if CopyFile(PChar(PathLocal), PChar(PathRemoto), False) then
        begin
          Application.ProcessMessages;
          DeleteFile(PChar(PathCheck));
        end;
      end;
    except
    end;
  finally
    repeat
      Sleep(5);
      Inc(ipos);
      Gauge1.Progress := ipos
    until (Gauge1.Progress = 100);
    Gauge1.Progress := 100;
  end;
end;
{$ENDREGION 'Infra'}
{$REGION 'Exception'}

procedure TfrmProgExcep.ExportExceptiontxt;
var
  txtFile: TextFile;
begin

  try

    AssignFile(txtFile, PathLocal);
    if FileExists(PathLocal) then
      Append(txtFile)
    else
      Rewrite(txtFile);

    Write(txtFile, JsonString);
    Writeln(txtFile);
  finally
    CloseFile(txtFile);
    CopyLastException;
  end;

end;

procedure TfrmProgExcep.TimerTimer(Sender: TObject);

begin
  Timer.Enabled := False;
  FormatSettings.DecimalSeparator := '.';
  PathCheck := '';
  PathLocal := ExtractFilePath(Application.ExeName) + 'Exception\' + 'Exception_' + FormatDateTime('yyyy-mm-dd', now) + '.txt';
  PathRemoto := 'Last Exception' + '_' + FormatDateTime('yyyy-mm-dd', now) + '.txt';

  try
    JsonString := MsgExcept;
    ExportExceptiontxt;
  finally

    FormatSettings.DecimalSeparator := ',';
    frmMain.LblMessage.Caption := 'Report : ' + MsgExcept;
    Application.ProcessMessages;
    Close;
  end;
end;
{$ENDREGION 'Exception'}

end.
