{ ============================================
  Software Name : 	CompUPX
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit uProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmProgress = class(TForm)
    pnlButtons: TPanel;
    btnClose: TButton;
    btnCancel: TButton;
    memLog: TRichEdit;
    ProgressBar1: TProgressBar;
    lblCurrentFolder: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FOnCancel: TNotifyEvent;
    procedure SetCurrentFolder(const Value: string);
  public
    procedure ClearLog;
    procedure DisableCancel;
    procedure EnableCancel;
    procedure Log(const aMessage: string);
    procedure Start;
    procedure Stop;
    procedure UpdateProgress(aPosition: Integer);
    property CurrentFolder: string write SetCurrentFolder;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}


// TfrmProgress
// ============================================================================
procedure TfrmProgress.btnCancelClick(Sender: TObject);
begin
  ProgressBar1.State := pbsPaused;
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.ClearLog;
begin
  memLog.Clear;
  memLog.Refresh;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.DisableCancel;
begin
  btnCancel.Enabled := False;
  Application.ProcessMessages;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.EnableCancel;
begin
  btnCancel.Enabled := True;
  Application.ProcessMessages;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.Log(const aMessage: string);
begin
  memLog.Lines.Add(aMessage);
  memLog.Refresh;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.SetCurrentFolder(const Value: string);
begin
  lblCurrentFolder.Caption := Value;
  lblCurrentFolder.Refresh;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.Start;
begin
  ProgressBar1.State := pbsNormal;
  ProgressBar1.Position := 0;
  ClearLog;
  lblCurrentFolder.Caption := '';

  btnClose.Hide;
  btnCancel.Show;

  Log('Searching for executable files...');
  Application.ProcessMessages;
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.Stop;
begin
  btnClose.Show;
  btnCancel.Hide;
  lblCurrentFolder.Caption := '';
end;

// ----------------------------------------------------------------------------
procedure TfrmProgress.UpdateProgress(aPosition: Integer);
begin
  ProgressBar1.Position := aPosition;
  ProgressBar1.Refresh;
end;

end.
