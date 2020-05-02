unit Module;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, ZDataset,
  ZDbcCache, ZAbstractRODataset, ZDbcMySQL, ZDbcPostgreSQL, DB, ZSqlUpdate,
  ComCtrls, ZDbcInterbase6, ZSqlMonitor, ZAbstractDataset, ZSequence;

type
  TDMModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FConnection: TZConnection;
    FDataset: TZQuery;
    FUpdateSQL: TZUpdateSQL;
    FDatabaseName: string;

  public
    { Public-Deklarationen }
    property Connection: TZConnection read FConnection write Fconnection;
    property Dataset: TZQuery read FDataset write FDataset;
    property UpdateSQL: TZUpdateSQL read FUpdateSQL write FUpdateSQL;
    property DatabaseName: string read FDatabaseName write FDatabaseName;
  end;

var
  DMModule: TDMModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDMModule.DataModuleCreate(Sender: TObject);
const
  cDB = 'Data\';
var
  sDirDB: string;
begin
  sDirDB := ExtractFilePath(paramstr(0)) + cDB;
  ForceDirectories(sDirDB);

  DatabaseName := 'MyTest.db';

  FConnection := TZConnection.Create(self);
  FConnection.Database := Concat(sDirDB, DatabaseName);
  FConnection.Protocol := 'sqLite';
  FConnection.Connect;

  Dataset := TZQuery.Create(self);
  Dataset.Connection := FConnection;

  Dataset.SQL.Add
    ('CREATE TABLE IF NOT EXISTS STUDENT(ID integer NOT NULL PRIMARY KEY AUTOINCREMENT,Note1 integer NOT NULL,Note2 integer NOT NULL,Note3 integer NOT NULL,Note4 integer NOT NULL)');
  Dataset.ExecSQL;
  // Set Stringgrid dimension

end;


end.
