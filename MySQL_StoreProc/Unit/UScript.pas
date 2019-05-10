{ ============================================
  Software Name : 	MySQL_StoreProc
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit UScript;

interface

uses FireDAC.Comp.Script;

procedure CreateScript;
procedure DeleteScript;
procedure CreateTable;
procedure BuildTable;
procedure CreateTableLog;

implementation

uses
  Module;

procedure CreateScriptGetName;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.ConnectionMain;

  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'GetName';
      SQL.Add('DROP FUNCTION IF EXISTS GetName;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function GetName (theI INT) RETURNS VARCHAR (20)');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE xyz VARCHAR (20) DEFAULT "";');
      SQL.Add('SELECT Name into xyz from customers where ID = theI;');
      SQL.Add('RETURN xyz;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');

    end;

  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;
    DMModule.ProcGetName.StoredProcName := 'mywalid.GetName';

  end;

end;

procedure CreateScriptCountable;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Counter';
      SQL.Add('DROP FUNCTION IF EXISTS Counter;');
      SQL.Add('DELIMITER $$');
      SQL.Add('create function Counter(inb INT) RETURNS INT');
      SQL.Add('BEGIN');
      // SQL.Add('DECLARE inb INT;');
      SQL.Add('SELECT COUNT(*) INTO inb FROM customers;');
      SQL.Add('RETURN inb;');
      SQL.Add('END$$');
      SQL.Add('DELIMITER;');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;
    DMModule.ProcCounter.StoredProcName := 'mywalid.Counter';

  end;

end;

procedure DeleteAllProcFunc;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Delete';
      SQL.Add('DROP FUNCTION IF EXISTS Counter;');
      SQL.Add('DROP FUNCTION IF EXISTS GetName;');
    end;
  end;

  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure CreateData_Table;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.ConnectionMain;
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

procedure CreateTableLog;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.FDErrLogConn;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'LogConnec';
      SQL.Add('CREATE TABLE IF NOT EXISTS LogConnec(');
      SQL.Add('Id INT NOT NULL AUTO_INCREMENT,');
      SQL.Add('APPID INT,');
      SQL.Add('EVN_TYPE INT,');
      SQL.Add('EMSG VARCHAR(255),');
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

procedure CreateTable;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;

    with Add do
    begin
      Name := 'Customers';
      SQL.Add('DROP TABLE IF EXISTS Customers ;');
      SQL.Add('create table customers(');
      SQL.Add('Id INT NOT NULL AUTO_INCREMENT,');
      SQL.Add('Name VARCHAR(40) NOT NULL,');
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

procedure InsertTable;
var
  tmpScript: TFDScript;
begin
  tmpScript := TFDScript.Create(nil);
  tmpScript.Connection := DMModule.ConnectionMain;
  with tmpScript.SQLScripts do
  begin
    Clear;
    with Add do
    begin
      SQL.Add('INSERT INTO customers (Id,Name)');
      SQL.Add('VALUES');
      SQL.Add('(1,"Alex");');
      SQL.Add('INSERT INTO customers (Id,Name)');
      SQL.Add('VALUES');
      SQL.Add('(2,"Jack");');
      SQL.Add('INSERT INTO customers (Id,Name)');
      SQL.Add('VALUES');
      SQL.Add('(3,"Patrick");');
    end;
  end;
  try
    tmpScript.ValidateAll;
    tmpScript.ExecuteAll;
  finally
    tmpScript.free;

  end;

end;

procedure CreateScript;
begin
  CreateScriptGetName;
  CreateScriptCountable;
end;

procedure DeleteScript;
begin
  DeleteAllProcFunc;
end;

procedure BuildTable;
begin
  CreateTable;
  InsertTable;
  CreateData_Table;
end;

end.
