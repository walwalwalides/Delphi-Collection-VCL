unit Module;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.SQLite, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

const
  DnameDataBase = 'Daten\Event.db';
  FnameDataBase = 'Daten\';

type
  TDMModule = class(TDataModule)
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ConnectionMain: TFDConnection;
    qrEvent: TFDQuery;
    qrCheck: TFDQuery;
    qrCheckID: TFDAutoIncField;
    qrCheckEvtName: TStringField;
    qrCheckEvtDate: TDateField;
    qrCheckEvtTime: TTimeField;
    qrCheckEvtColor: TShortintField;
    qrCheckEvtDescription: TWideMemoField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    strAppPath: string;
    procedure DBINI;
    procedure SetEvtTable;

    procedure SetDB;
    function CheckEvent(const AEvtName, ATablename: string): Boolean;
  public
    { Public-Deklarationen }
    function InsertEvent(AEvtName: string; AEvtDate: Tdate; AEvtTime: Ttime; AEvtColor: ShortInt; AEvtDescrip: WideString): Boolean;
    function LoadEvent: Boolean;
  end;

var
  DMModule: TDMModule;

implementation

uses vcl.forms, System.IOUtils, Main, System.DateUtils, vcl.Graphics;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

var
  boolConnection: Boolean = false;

procedure TDMModule.DataModuleCreate(Sender: TObject);
begin
  //
  boolConnection := false;
  ConnectionMain.Connected := false;
  ConnectionMain.LoginPrompt := false;
  ConnectionMain.SharedCliHandle := nil;
  ConnectionMain.Params.Pooled := false;
  ConnectionMain.DriverName := 'SQLite';
  ConnectionMain.Params.Add('SharedCache=False');
  ConnectionMain.Params.Add('LockingMode=Normal');
  ConnectionMain.ResourceOptions.SilentMode := false;
  DBINI;
end;

procedure TDMModule.DBINI;
begin

  strAppPath := ExtractFilePath(Application.ExeName);

  if FileExists(strAppPath + DnameDataBase) = false then
  begin
    try
      SetDB;
      SetEvtTable;
    except
      DeleteFile(strAppPath + DnameDataBase) ;
    end;
  end
  else
  begin
    if (boolConnection = false) then
      ConnectionMain.Params.Database := TPath.Combine(TPath.GetLibraryPath, DnameDataBase);
    ConnectionMain.ExecSQL
      ('CREATE TABLE IF NOT EXISTS Event (ID integer NOT NULL PRIMARY KEY AUTOINCREMENT,EvtName varchar(100),EvtDate date,EvtTime time,EvtColor TINYINT,EvtDescription Text)');

    boolConnection := true;

  end;
  ConnectionMain.Open;
  if ConnectionMain.Connected = false then
    ConnectionMain.Connected := true;
end;

function TDMModule.CheckEvent(const AEvtName: String; const ATablename: string): Boolean;
begin
  Result := false;
  if (ATablename = 'Event') then
  begin
    qrCheck.Close;
    qrCheck.SQl.Clear;
    try
      qrCheck.SQl.Text := 'Select * from Event where EvtName=:Nam';
      qrCheck.ParamByName('Nam').Value := AEvtName;
      qrCheck.Open;
      if (qrCheck.RecordCount > 0) then
      begin
        Result := true;
      end
      else
      begin
        Result := false;
      end;
    finally
      qrCheck.SQl.Clear;
      qrCheck.Close;
    end;
  end;

end;

function TDMModule.InsertEvent(AEvtName: string; AEvtDate: Tdate; AEvtTime: Ttime; AEvtColor: ShortInt; AEvtDescrip: WideString): Boolean;
begin
  Result := false;

  if ((AEvtName <> '')) then
  begin
    qrEvent.Close;
    qrEvent.SQl.Clear;
    if (CheckEvent(AEvtName, 'Event') = false) then
      qrEvent.SQl.Text := 'INSERT INTO Event(EvtName,EvtDate,EvtTime,EvtColor,EvtDescription) VALUES(:Nam,:Dat,:Tim,:Col,:Des)'
    else
      qrEvent.SQl.Text := 'Update Event Set EvtName=:Nam,EvtDate=:Dat,EvtTime=:Tim,EvtColor=:Col,EvtDescription=:Des where EvtName=:Nam';

    try
      qrEvent.ParamByName('Nam').Value := AEvtName;
      qrEvent.ParamByName('Dat').AsDate := AEvtDate;
      qrEvent.ParamByName('Tim').AsTime := AEvtTime;
      qrEvent.ParamByName('Col').Value := AEvtColor;
      qrEvent.ParamByName('Des').Value := AEvtDescrip;
      try
        qrEvent.ExecSQL;
        Result := true;
      except
        on E: Exception do
        begin
          qrEvent.Cancel;

          Result := false;
          raise Exception.Create('Event can not to be added.'#13#10#13#10'Details: ' + E.Message);
        end;
      end;
    finally
      qrEvent.Close;
    end;

  end
  else
    Exception.Create('Event can not to be added,Event Name No found it...');
end;

function GetColorFromColBox(Aindex: ShortInt): TColor;
begin
  frmMain.ColorBoxCategorie.ItemIndex := Aindex;
  Result := frmMain.ColorBoxCategorie.Selected;
end;

function TDMModule.LoadEvent: Boolean;
var
  I: Integer;
begin
  qrCheck.Close;
  qrCheck.SQl.Clear;
  try
    qrCheck.SQl.Text := 'Select * from Event';
    qrCheck.Open;
    if (qrCheck.RecordCount > 0) then
    begin
      for I := 0 to qrCheck.RecordCount-1 do
      begin

        frmMain.BitBtnNewClick(nil);
        frmMain.EventSelection.Name := qrCheckEvtName.AsString;
        frmMain.EventSelection.Date := Dateof(qrCheckEvtDate.AsDateTime);
        frmMain.EventSelection.Time := TimeOf(qrCheckEvtTime.AsDateTime);
        frmMain.EventSelection.Categorie := GetColorFromColBox(qrCheckEvtColor.AsInteger);
        frmMain.EventSelection.Description := qrCheckEvtDescription.AsWideString;
        qrCheck.Next;

      end;
      Result := true;
     frmMain.CloseLoadEvent;
    end
    else
    begin
      Result := false;
    end;
  finally
    qrCheck.SQl.Clear;
    qrCheck.Close;
  end;
end;

procedure TDMModule.SetDB;

begin
  ForceDirectories(strAppPath + FnameDataBase);
  ConnectionMain.ConnectionName := TPath.Combine(TPath.GetLibraryPath, DnameDataBase);
  ConnectionMain.Params.Database := TPath.Combine(TPath.GetLibraryPath, DnameDataBase);

end;

procedure TDMModule.SetEvtTable;
begin
  qrEvent.Close;
  qrEvent.SQl.Clear;
  qrEvent.SQl.Add('Create Table Event (');
  qrEvent.SQl.Add('ID integer NOT NULL PRIMARY KEY AUTOINCREMENT,');
  qrEvent.SQl.Add('EvtName VARCHAR(100),');
  qrEvent.SQl.Add('EvtDate DATE,');
  qrEvent.SQl.Add('EvtTime TIME,');
  qrEvent.SQl.Add('EvtColor TINYINT,');
  qrEvent.SQl.Add('EvtDescription TEXT)');
  qrEvent.Execute;

end;

end.
