{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit uStringGrid;

interface

uses
  windows, Classes, SysUtils, Forms, Graphics, Controls, Grids, DB, Zdataset,
  ZConnection, dialogs,
  system.json, system.ioutils, system.types, Printers;

type
  TStringGrid = Class(Grids.TStringGrid)
  Private
    // private declare
    function GetSQL: String;
    procedure SetSQL(ASQL: String);
    function GetConnection: TZConnection;
    procedure SetConnection(Connection: TZConnection);
    function GetDataSet: TZQuery;
    procedure SetDataSet(ADataset: TZQuery);
    procedure CreateDataSet;

  Public
    // public declare
    PSQL, Error: string;
    Conn: TZConnection;
    DBSource: TZQuery;
    property Connection: TZConnection Read GetConnection Write SetConnection;
    property SQLText: String Read GetSQL Write SetSQL;
    property Dataset: TZQuery Read GetDataSet Write SetDataSet;
    procedure RefreshSQL; // re-open database
    procedure UpdateData; // Update database
    procedure DeleteData; // Delete selected data on grid
    procedure ForUpdateData;
    procedure SaveToCSV;
    procedure SaveToJSON; // save to JSON format
    procedure SaveToPDF; // save to PDF file
    procedure Print(Left, top, vColumn, bColumn, vLine, bLine: Integer;
      scale: double; bColor: boolean);
  end;

implementation

uses uSettingPrint;

procedure TStringGrid.CreateDataSet;
begin

  if assigned(DBSource) then
    DBSource := TZQuery.Create(self);
  with DBSource do
  begin
    Connection := Conn;
    sql.Text := PSQL;
    open;
  end;

end;

procedure TStringGrid.SaveToPDF;
const
  cPDFPrinter = 'Microsoft Print to PDF';
var
  ls: TstringList;
begin
  ls := ListPrinters;

  if (ls.IndexOf(cPDFPrinter)>-1) then
  Begin
    SetDefaultPrinter(cPDFPrinter);
    Print(0, 0, -1, -1, -1, -1, 1, true);
  End
  else
  Begin
   MessageDlg('"Microsoft Print to PDF" not found !', mtWarning, [mbOK], 0);

  End;

end;

function TStringGrid.GetDataSet: TZQuery;
begin
  result := DBSource;
end;

procedure TStringGrid.SetDataSet(ADataset: TZQuery);
begin
  DBSource := TZQuery.Create(self);
  ADataset := DBSource;
end;

procedure TStringGrid.SaveToJSON;
var
  i, j: Integer;
  lJsonObj: TJSONObject;
  SD: TSaveDialog;
  Filename: string;
begin
  SD := TSaveDialog.Create(nil);
  try
    SD.Filter := 'JSON (*.JSON)|*.JSON';
    if SD.Execute then
    Begin
      Filename := SD.Filename;
      if (ExtractFileExt(Filename) <> '.json') then
        Filename := Filename + '.json';
      Screen.Cursor := crHourGlass;
      try
        lJsonObj := TJSONObject.Create;
        for j := 1 to rowcount - 1 do
        Begin
          for i := 0 to ColCount do
          begin
            lJsonObj.AddPair(Cells[i, 0], Cells[i, j]);
          end;
        end;
        TFile.WriteAllText(Filename, lJsonObj.ToString);
      finally
        Screen.Cursor := crDefault;
      end;

    End;

  finally
    SD.free;
  end;
end;

procedure TStringGrid.SaveToCSV;
var
  i: Integer;
  CSV: TStrings;
  SD: TSaveDialog;
  Filename: string;
begin
  SD := TSaveDialog.Create(nil);
  try
    SD.Filter := 'CSV (*.csv)|*.CSV';
    if SD.Execute then
    begin
      Filename := SD.Filename;
      if (ExtractFileExt(Filename) <> '.csv') then
        Filename := Filename + '.csv';
      Screen.Cursor := crHourGlass;
      try
        CSV := TstringList.Create;
        try
          for i := 0 to rowcount - 1 do
            CSV.Add(Rows[i].CommaText);
          CSV.SaveToFile(Filename);
        finally
          CSV.free;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    SD.free;
  end;
end;

procedure TStringGrid.UpdateData;
var
  i, j, x: Integer;
  sl: TstringList;
begin

  try
    sl := TstringList.Create;

    if (DBSource = nil) then
      DBSource := TZQuery.Create(self);
    try
      CreateDataSet;
      // Delete the old data from the database..
      for x := 0 to DBSource.RecordCount - 1 do
      Begin
        if not DBSource.IsEmpty then
          DBSource.Delete;
      end;

      for i := 1 to rowcount - 1 do
      begin
        DBSource.Insert;
        for j := 0 to ColCount - 1 do // load value to the table
        begin
          sl.Add(Cells[j, i]);
          DBSource.Fields[j].Value := strtoint(sl[j]);
        end;
        // DBSource.Fields[jj].Value :=sss[jj];
        DBSource.Post;
        sl.Clear;
      end;
    finally
      FreeAndNil(sl);
      RefreshSQL;
    end;

  except
    on E: Exception do
      Error := 'An exception was raised: ' + E.Message;
  end;

end;

procedure TStringGrid.DeleteData;
begin
  try
    DBSource := TZQuery.Create(self);
    CreateDataSet;
    DBSource.Locate(Cells[col, 0], Cells[col, row], []);
    if not DBSource.IsEmpty then
      DBSource.Delete;
  finally
    RefreshSQL;
  end;
end;

procedure TStringGrid.ForUpdateData;
var
  i: Integer;
begin

  CreateDataSet;
  for i := 0 to DBSource.RecordCount - 1 do
  Begin
    if not DBSource.IsEmpty then
      DBSource.Delete;
  end;

end;

procedure TStringGrid.RefreshSQL;
begin
  SetSQL(PSQL);
end;

function TStringGrid.GetSQL: String;
begin
  result := PSQL;
end;

procedure TStringGrid.SetConnection(Connection: TZConnection);
begin
  Conn := TZConnection.Create(self);
  Conn := Connection;
end;

function TStringGrid.GetConnection: TZConnection;
begin
  result := Conn;
end;

procedure TStringGrid.SetSQL(ASQL: String);
var
  i, j: Integer;
begin
  try
    DBSource := TZQuery.Create(self);

    with DBSource do
    begin
      Connection := Conn;
      DBSource.sql.Text := ASQL;
      open;
    end;
    PSQL := ASQL;
    rowcount := DBSource.RecordCount + 1;
    ColCount := DBSource.FieldCount;

    for i := 0 to DBSource.Fields.Count - 1 do
      Cells[i, 0] := DBSource.Fields[i].FieldName;
    DBSource.First;
    j := 0;
    while not DBSource.EOF do
    begin
      for i := 0 to DBSource.Fields.Count - 1 do
        Cells[i, j + 1] := DBSource.Fields[i].AsString;
      DBSource.Next;
      Inc(j);
    end;
    DBSource.free;
  except
    on E: Exception do
      Error := 'An exception was raised: ' + E.Message;
  end;

end;

procedure TStringGrid.Print(Left, top, vColumn, bColumn, vLine, bLine: Integer;
  scale: double; bColor: boolean);
var
  x, y, li, ob, re, un, waag, senk, a,ierror: Integer;
  fix, grund, cFont: TColor;
  r: Trect;
  function CalPos(i, j: Integer): Integer;
  begin
    result := round(((i * j) / 72) * scale);
  end;

begin
  if (vLine < 0) then
    vLine := 0;
  if (vColumn < 0) then
    vColumn := 0;

  if (bLine >= rowcount) or (bLine < 0) then
    bLine := rowcount - 1;

  if (bColumn >= ColCount) or (bColumn < 0) then
    bColumn := ColCount - 1;
  if vLine > bLine then
  begin
    a := vLine;
    vLine := bLine;
    bLine := a;
  end;
  if vColumn > bColumn then
  begin
    a := vColumn;
    vColumn := bColumn;
    bColumn := a;
  end;
  if (scale > 0) and (vLine < rowcount) and (vColumn < ColCount) then
  begin
    if bColor then
    begin
      fix := fixedcolor;
      grund := color;
      cFont := font.color;
    end
    else
    begin
      fix := clsilver;
      grund := clwhite;
      cFont := clblack;
    end;
    waag := getdevicecaps(printer.handle, logpixelsx);
    // Logical pixelsinch in X
    senk := getdevicecaps(printer.handle, logpixelsy);
    // Logical pixelsinch in Y
    Left := CalPos(Left, waag);
    top := CalPos(top, senk);
    li := getdevicecaps(printer.handle, physicaloffsetx) + 1 + Left;
    a := CalPos(3, waag);
    // Setting parametres Printer
    with printer do
    begin
      title := 'Print';

      BeginDoc;
      if (Printing =false) then exit;     //no file selected

      if (gridlinewidth > 0) then
      begin
        canvas.pen.color := $333333;
        canvas.pen.width := 1;
        canvas.pen.style := pssolid
      end
      else
        canvas.pen.style := psclear;
      canvas.font := font;
      canvas.font.color := cFont;
      canvas.font.size := round((font.size / 0.72) * scale);
      for x := vColumn to bColumn do
      begin
        ob := getdevicecaps(printer.handle, physicaloffsety) + 1 + top;
        re := li + CalPos(ColWidths[x] + 1, waag);
        for y := vLine to bLine do
        begin
          un := ob + CalPos(RowHeights[y] + 1, senk);
          if (x < fixedcols) or (y < fixedrows) then
            canvas.brush.color := fix
          else
            canvas.brush.color := grund;
          canvas.rectangle(li, ob, re + 2, un + 2);
          r := rect(li + a, ob + 1, re - a, un - 2);
          drawtext(canvas.handle, pchar(Cells[x, y]), length(Cells[x, y]), r,
            DT_SINGLELINE or DT_VCENTER);
          ob := un;
        end;
        li := re;
      end;
      enddoc;
    end;
  end;
end;

end.
