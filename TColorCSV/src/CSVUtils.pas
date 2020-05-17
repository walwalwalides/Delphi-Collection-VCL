{ ============================================
  Software Name : 	TColorCSV
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit CSVUtils;

interface

uses
  System.Rtti, System.uitypes, Spring.Collections, Vcl.Grids, Gridview;

type

  ICSVWriter = Interface(IInvokable)
    ['{F78811E7-21F2-4C20-935D-1157C8B817D7}']

    function AddRow: ICSVWriter;
    function Delimiter(const pDelimiter: Char): ICSVWriter;
    function Field(const pFieldName: string): ICSVWriter;
    function Fields(const pFieldNames: array of string): ICSVWriter;
    function QuoteStr(const pEnable: Boolean): ICSVWriter;
    procedure SaveToFile(const pFileName: string;
      var arrColorCell: array of TColorCell;
      var arrWidthCol: array of TWidthColumn);
    function Value(const pFieldName: string; const pValue: TValue): ICSVWriter;
    procedure LoadCSVToStringGrid(Filename: string; sg: TStringGrid;
      var arrColorCell: array of TColorCell;
      var arrWidthCol: array of TWidthColumn);

  End;

  TCSVWriter = class(TInterfacedObject, ICSVWriter)

  private
    FCurrentLine: IDictionary<string, TValue>;
    FIntDelimiter: Char;
    FIntFields: IList<string>;
    FIntQuoteStr: Boolean;
    FLines: IList<IDictionary<string, TValue>>;

    property CurrentLine: IDictionary<string, TValue> read FCurrentLine
      write FCurrentLine;
    property IntDelimiter: Char read FIntDelimiter write FIntDelimiter;
    property IntFields: IList<string> read FIntFields write FIntFields;
    property IntQuoteStr: Boolean read FIntQuoteStr write FIntQuoteStr;
    property Lines: IList < IDictionary < string, TValue >> read FLines
      write FLines;
  public
    // arrColorCell2: array of TColorCell;
    constructor Create;
    function AddRow: ICSVWriter;
    function Delimiter(const pDelimiter: Char): ICSVWriter;
    function Field(const pFieldName: string): ICSVWriter;
    function Fields(const pFieldNames: array of string): ICSVWriter;
    function QuoteStr(const pEnable: Boolean): ICSVWriter;
    procedure SaveToFile(const pFileName: string;
      var arrColorCell: array of TColorCell;
      var arrWidthCol: array of TWidthColumn);
    procedure LoadCSVToStringGrid(Filename: string; sg: TStringGrid;
      var arrColorCell: array of TColorCell;
      var arrWidthCol: array of TWidthColumn);

    function Value(const pFieldName: string; const pValue: TValue): ICSVWriter;
  end;

implementation

uses
  System.Classes, Spring, System.SysUtils;

procedure TCSVWriter.LoadCSVToStringGrid(Filename: string; sg: TStringGrid;
  var arrColorCell: array of TColorCell;
  var arrWidthCol: array of TWidthColumn);
var
  I, j, Position, count, edt1, ipos, ipos2, iArrHigh, iArrHigh2, ncolor, ic,
    ic2: Integer;
  temp, tempField, spos, spos2: string;
  FieldDel: Char;
  Data: TStringList;
  ccRow, ccColumn: Integer;
  ccColor: TColor;

begin
  iArrHigh := 0;
  ic := 0;
  iArrHigh2 := -1;
  ic2 := 0;
  ncolor := 0;
  Data := TStringList.Create;
  FieldDel := ';';
  Data.LoadFromFile(Filename);
  temp := Data[1];
  count := 0;
  for I := 1 to length(temp) do
    if copy(temp, I, 1) = FieldDel then
      inc(count);
  edt1 := count + 1;
  sg.ColCount := edt1;
  for I := 0 to Data.count - 1 do
  begin;
    temp := Data[I];

    if ((Pos('col:', temp) > 0) or (Pos('wid:', temp) > 0)) then
      inc(ncolor)

  end;

  sg.RowCount := Data.count - ncolor;
  sg.FixedCols := 0;

  for I := 0 to Data.count - 1 do
  begin;
    temp := Data[I];

    if Pos('wid:', temp) > 0 then
    begin
      if Pos(',', temp) > 0 then
      begin

        ipos := Pos(',', temp);
        spos := copy(temp, 5, ipos - 5);
        ccColumn := StrToInt(spos);
        ipos2 := ipos + 1;
        spos := copy(temp, ipos2, length(temp));
        ccRow := StrToInt(spos);

      end;

      inc(iArrHigh2);
      ic2 := Low(arrWidthCol) + iArrHigh2;
      arrWidthCol[ic2].ColumnNr := ccColumn;
      arrWidthCol[ic2].ColumnWidth := ccRow;

    end
    else if Pos('col:', temp) > 0 then
    begin
      if Pos(',', temp) > 0 then
      begin
        // inc(iArrHigh);
        // setlength(arrColorCell, iArrHigh);

        ipos := Pos(',', temp);
        spos := copy(temp, 5, ipos - 5);
        ccColumn := StrToInt(spos);
        ipos2 := ipos + 1;
        spos := copy(temp, ipos2, length(temp));
        // Delete(temp, 0, ipos2);

        ipos := Pos(',', spos);
        spos2 := copy(spos, 0, ipos - 1);
        ccRow := StrToInt(spos2);
        spos2 := copy(spos, ipos + 1, length(spos));
        // Delete(temp, 0, ipos2);

        ccColor := StrToInt(spos2);
        // Delete(temp, 0, ipos);

      end;
      // if ((ccColumn<>0)and  (ccRow<>0) and (ccColor<>0))then
      // Begin
      inc(iArrHigh);
      ic := Low(arrColorCell) + iArrHigh;
      arrColorCell[ic].ccColumn := ccColumn;
      arrColorCell[ic].ccRow := ccRow;
      arrColorCell[ic].ccColor := ccColor;
      // End;

    end
    else

    begin

      if (copy(temp, length(temp), 1) <> FieldDel) then
        temp := temp + FieldDel;
      while Pos('"', temp) > 0 do
      begin
        Delete(temp, Pos('"', temp), 1);
      end;
      for j := 1 to edt1 do
      begin
        Position := Pos(FieldDel, temp);
        tempField := copy(temp, 0, Position - 1);
        sg.Cells[j - 1, I] := tempField;
        Delete(temp, 1, length(tempField) + 1);
      end;
    end;

  end;

  Data.Free;
end;

constructor TCSVWriter.Create;
begin
  inherited;
  FIntDelimiter := ';';
  FIntQuoteStr := False;
  FIntFields := TCollections.CreateList<string>;
  FLines := TCollections.CreateList<IDictionary<string, TValue>>;
end;

function TCSVWriter.AddRow: ICSVWriter;
begin
  Result := self;
  CurrentLine := TCollections.CreateDictionary<string, TValue>;
  Lines.Add(CurrentLine);
end;

function TCSVWriter.Delimiter(const pDelimiter: Char): ICSVWriter;
begin
  Result := self;
  FIntDelimiter := pDelimiter;
end;

function TCSVWriter.Field(const pFieldName: string): ICSVWriter;
begin
  Result := self;
  FIntFields.Add(pFieldName);
end;

function TCSVWriter.Fields(const pFieldNames: array of string): ICSVWriter;
begin
  Result := self;
  FIntFields.AddRange(pFieldNames);
end;

function TCSVWriter.QuoteStr(const pEnable: Boolean): ICSVWriter;
begin
  Result := self;
  FIntQuoteStr := pEnable;
end;

procedure TCSVWriter.SaveToFile(const pFileName: string;
  var arrColorCell: array of TColorCell;
  var arrWidthCol: array of TWidthColumn);
var
  header: TStringList;
  sl: TStringList;
  I: Integer;
begin
  sl := TStringList.Create;
  try
    // hlavicka
    header := TStringList.Create;
    try
      header.Delimiter := IntDelimiter;
      header.StrictDelimiter := True;

      IntFields.ForEach(
        procedure(const pFieldName: string)
        begin
          header.Add(pFieldName);
        end);
      sl.Add(header.DelimitedText);
    finally
      header.Free;
    end;
    // polozky
    Lines.ForEach(
      procedure(const line: IDictionary<string, TValue>)
      var
        Row: TStringList;
        lValue: TValue;
      begin
        Row := TStringList.Create;
        try
          Row.Delimiter := IntDelimiter;
          Row.StrictDelimiter := True;

          IntFields.ForEach(
            procedure(const pFieldName: string)
            begin
              if line.TryGetValue(pFieldName, lValue) then
                if lValue.IsString then
                begin
                  if IntQuoteStr then
                    Row.Add(lValue.ToString.QuotedString('"'))
                  else
                    Row.Add(lValue.ToString);
                end
                else
                  Row.Add(lValue.ToString)
              else
                Row.Add('');
            end);
          sl.Add(Row.DelimitedText);
        finally
          Row.Free;
        end;
      end);

    for I := Low(arrWidthCol) to High(arrWidthCol) do
    begin

      sl.Add('wid:' + (arrWidthCol[I].ColumnNr).ToString + ',' +
        (arrWidthCol[I].ColumnWidth).ToString);

    end;

    for I := Low(arrColorCell) to High(arrColorCell) do
    begin

      sl.Add('col:' + (arrColorCell[I].ccColumn).ToString + ',' +
        (arrColorCell[I].ccRow).ToString + ',' +
        IntToStr(arrColorCell[I].ccColor));

    end;

    sl.SaveToFile(pFileName);
  finally
    sl.Free;
  end;
end;

function TCSVWriter.Value(const pFieldName: string; const pValue: TValue)
  : ICSVWriter;
begin
  Result := self;
  CurrentLine.AddOrSetValue(pFieldName, pValue);

end;

end.
