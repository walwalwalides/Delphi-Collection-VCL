{ ============================================
  Software Name : 	MyAppConec
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit ServerMethodsServ;

interface

uses System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter,
  DataSnap.DSServer, DataSnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Script,
  FireDAC.Comp.DataSet, DataSnap.Provider, FireDAC.VCLUI.Wait, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  FireDAC.Comp.UI;

type
  TServerMethods = class(TDSServerModule)
    ConnectionMain: TFDConnection;
    ProcGetActive: TFDStoredProc;
    ProcGetAdress: TFDStoredProc;
    FncgetriderequirementProc: TFDStoredProc;
    ProcGetPosition: TFDStoredProc;
    qrWorkerInfo: TFDQuery;
    qrWorkerStatus: TFDQuery;
    DSPWorkerInfo: TDataSetProvider;
    DSPWorkerStatus: TDataSetProvider;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    tmpScript: TFDScript;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    ProcGetWorkID: TFDStoredProc;
    procedure DSServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CreateScript;
    procedure DeleteScript;
    procedure CreateTable1;
    procedure CreateTable2;
    procedure BuildTable;
    procedure FullTable;
    // -------------------------------------------------------//
    procedure CreateFuncGetWorkID;
    procedure CreateFuncGetPosition;
    procedure CreateFuncGetActive;
    procedure CreateFuncGetAdress;
    // -------------------------------------------------------//

    procedure CreateData_Table;
    procedure DeleteAllProcFunc;
    procedure CreateFunc1;

    procedure CreateStoredProc;

  public
    { Public declarations }
    function GetWorkerID(AName: string): integer;
    function GetWorkerPosition(AWorkID: integer): string;
    function GetWorkerActive(AWorkID: integer): Boolean;
    function GetWorkerAddress(AWorkID: integer): string;

    // -------------------------------------------------------//

    function GetRideRequirement(AName: integer): string;
    procedure ChangeRideStatus(AName: integer; StatusId: integer);
    procedure MoveRideToArchive(AName: integer);
  end;

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

{$R *.dfm}

uses System.StrUtils;

procedure TServerMethods.CreateFuncGetActive;
begin

  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'GetActive';
      SQL.Add('DROP FUNCTION IF EXISTS GetActive;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function GetActive (AWorkID INT) RETURNS Boolean');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE BAct BOOLEAN DEFAULT FALSE;');
      SQL.Add('SELECT Active into BAct from tWorkerStatus where WorkID = AWorkID;');
      SQL.Add('RETURN BAct;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');

    end;

  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    ProcGetActive.StoredProcName := 'mywalid.GetActive';

  end;

end;

procedure TServerMethods.CreateFuncGetAdress;
begin
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'GetAdress';
      SQL.Add('DROP FUNCTION IF EXISTS GetAdress;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function GetAdress (AWorkID INT) RETURNS VARCHAR (255)');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE AdrW VARCHAR (255);');
      SQL.Add('SELECT Adress into AdrW from tWorkerInfo where WorkID = AWorkID;');
      SQL.Add('RETURN AdrW;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    ProcGetAdress.StoredProcName := 'mywalid.GetAdress';

  end;

end;

procedure TServerMethods.CreateFuncGetPosition;
begin
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'GetPosition';
      SQL.Add('DROP FUNCTION IF EXISTS GetPosition;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function GetPosition(AWorkID INT) RETURNS varchar(40)');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE PosW VARCHAR (40);');
      SQL.Add('SELECT Position into PosW from tWorkerStatus where WorkID = AWorkID;');
      SQL.Add('RETURN PosW;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');

    end;

  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally

    ProcGetPosition.StoredProcName := 'mywalid.GetPosition';

  end;

end;

{$REGION 'Test'}
// Create FUNCTION my_func(in_id INT(11), value INT(11))RETURNS INT(11)DETERMINISTIC RETURN in_id IN (SELECT id FROM table_name WHERE id = value);

{$ENDREGION}

procedure TServerMethods.CreateFuncGetWorkID;
begin
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'GetWorkID';
      SQL.Add('DROP FUNCTION IF EXISTS GetWorkID;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function GetWorkID(AName VARCHAR(40)) RETURNS INT');
      SQL.Add('BEGIN');
      // SQL.Add('select ' +char(39)+'YOUR MESSAGE HERE'+char(39));
      SQL.Add('DECLARE IDC INT DEFAULT 0;');
      SQL.Add('SELECT WorkID into IDC from tWorkerInfo where Name = AName;');
      SQL.Add('RETURN IDC;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    ProcGetWorkID.StoredProcName := 'mywalid.GetWorkID';

  end;

end;

procedure TServerMethods.CreateFunc1;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'fncGetDriverId';
      SQL.Add('DROP FUNCTION IF EXISTS GetDriverId;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function GetDriverId(AValue VARCHAR(40)) RETURNS INT');
      SQL.Add('BEGIN');
      // SQL.Add('DECLARE inb INT;');
      SQL.Add('SELECT COUNT(*) INTO inb FROM tRideStatus;');
      SQL.Add('RETURN inb;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    // FncgetdriveridProc.StoredProcName := 'mywalid.fncGetDriverId';

  end;

end;

procedure TServerMethods.DeleteAllProcFunc;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Delete';
      SQL.Add('DROP FUNCTION IF EXISTS GetWorkID;');
      SQL.Add('DROP FUNCTION IF EXISTS GetPosition;');
      SQL.Add('DROP FUNCTION IF EXISTS GetActive;');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure TServerMethods.CreateData_Table;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Data_Table';
      SQL.Add('DROP TABLE IF EXISTS Data_Table ;');
      SQL.Add('create table Data_Table(');
      SQL.Add('Id INT NOT NULL AUTO_INCREMENT,');
      SQL.Add('VTYPE INT,');
      SQL.Add('KIND_ID INT,');
      SQL.Add('PRIMARY KEY ( Id )');
      SQL.Add(');');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure TServerMethods.CreateTable1;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'tWorkerStatus';
      SQL.Add('DROP TABLE IF EXISTS tWorkerStatus ;');
      SQL.Add('Create Table tWorkerStatus(');
      SQL.Add('Id INT AUTO_INCREMENT PRIMARY KEY,');
      SQL.Add('WorkID INT NOT NULL,');
      SQL.Add('nbHour INT NOT NULL,');
      SQL.Add('Position VARCHAR(40) NOT NULL,');
      SQL.Add('Active BOOLEAN DEFAULT FALSE');
      SQL.Add(');');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  except
    raise Exception.Create('Fehlermeldung');

  end;

end;

procedure TServerMethods.CreateTable2;
var
  tmpScript: TFDScript;
begin
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'tWorkerInfo';
      SQL.Add('DROP TABLE IF EXISTS tWorkerInfo ;');
      SQL.Add('Create Table tWorkerInfo(');
      SQL.Add('Id INT AUTO_INCREMENT PRIMARY KEY,');
      SQL.Add('WorkID INT NOT NULL,');
      SQL.Add('Name VARCHAR(40) NOT NULL,');
      SQL.Add('Adress VARCHAR(255) NOT NULL');
      SQL.Add(');');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  except

    raise Exception.Create('Fehlermeldung');

  end;

end;

procedure TServerMethods.FullTable;
begin

  with tmpScript.SQLScripts do
  begin
    Clear;
    with Add do
    begin
      SQL.Add('INSERT INTO tWorkerInfo (Name,WorkID,Adress)');
      SQL.Add('VALUES');
      SQL.Add('("alex",15,"2 Street Welcome");');
      SQL.Add('INSERT INTO tWorkerInfo(Name,WorkID,Adress)');
      SQL.Add('VALUES');
      SQL.Add('("ali",16,"15 Street Welcome");');
      SQL.Add('INSERT INTO tWorkerStatus(WorkID,Position,nbHour,Active)');
      SQL.Add('VALUES');
      SQL.Add('(15,"Developer",500,TRUE);');
      SQL.Add('INSERT INTO tWorkerStatus(WorkID,Position,nbHour,Active)');
      SQL.Add('VALUES');
      SQL.Add('(16,"Engineer",400,FALSE);');
    end;
  end;
  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  except
    raise Exception.Create('Fehlermeldung');

  end;
end;

procedure TServerMethods.CreateScript;
begin
  //
end;

procedure TServerMethods.CreateStoredProc;
begin
  CreateFuncGetWorkID;
  CreateFuncGetAdress;
  CreateFuncGetPosition;
  CreateFuncGetActive;
  // CreateFunc;
end;

procedure TServerMethods.DeleteScript;
begin
  DeleteAllProcFunc;
end;

procedure TServerMethods.BuildTable;
begin
  DeleteAllProcFunc;
  CreateTable1;
  CreateTable2;
  FullTable;
  CreateStoredProc;

end;

procedure TServerMethods.MoveRideToArchive(AName: integer);

var
  query: TFDQuery;

begin
  query := TFDQuery.Create(nil);
  query.Connection := ConnectionMain;

  query.SQL.Add('CALL public."prcMoveRideToArchive"(:ride_id);');
  query.Params[0].value := AName;
  query.ExecSQL;
end;

procedure TServerMethods.ChangeRideStatus(AName: integer; StatusId: integer);
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := ConnectionMain;

  query.SQL.Add('CALL public."prcChangeRideStatus"(:ride_id, :status_id);');
  query.Params[0].value := AName;
  query.Params[1].value := StatusId;
  query.ExecSQL;
end;

function TServerMethods.GetWorkerID(AName: string): integer;
begin
  ProcGetWorkID.Params[0].value := AName;
  Result := ProcGetWorkID.ExecFunc;
end;

procedure TServerMethods.DSServerModuleCreate(Sender: TObject);
begin
  // link connection to StoredProc
  ConnectionMain.LoginPrompt := False;
  ConnectionMain.ConnectionDefName := 'MYWALID_MYSQL';
  // ConnectionMain.Connected := True;
  { Build Tables }
  BuildTable;
end;

function TServerMethods.GetWorkerActive(AWorkID: integer): Boolean;
begin
  ProcGetActive.Params[0].value := AWorkID;
  Result := ProcGetActive.ExecFunc;
end;

function TServerMethods.GetWorkerPosition(AWorkID: integer): string;
begin
  ProcGetPosition.Params[0].value := AWorkID;
  Result := ProcGetPosition.ExecFunc;
end;

function TServerMethods.GetWorkerAddress(AWorkID: integer): string;
begin
  ProcGetAdress.Params[0].value := AWorkID;
  Result := ProcGetAdress.ExecFunc;
end;

function TServerMethods.GetRideRequirement(AName: integer): string;
begin
  FncgetriderequirementProc.Params[0].value := AName;
  Result := FncgetriderequirementProc.ExecFunc;
end;

end.
