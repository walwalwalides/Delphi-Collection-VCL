{ ============================================
  Software Name : 	TabCSV
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit GridView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Samples.Spin, System.Actions, Vcl.ActnList,
  Vcl.Menus;

type
  TModeArr = (arrLoad, arrCreate);

  TfrmGridView = class(TForm)
    btnLoad: TButton;
    strGridView: TStringGrid;
    btnColoumn: TButton;
    btnSave: TButton;
    imglstMain: TImageList;
    lbledtColumn: TLabeledEdit;
    lbledtRow: TLabeledEdit;
    btnWriteCell: TButton;
    pnlView: TPanel;
    btnAddRow: TButton;
    ODlgCSV: TOpenDialog;
    SpedtColumnW: TSpinEdit;
    lblColomnWidth: TLabel;
    GrpBoxCSV: TGroupBox;
    SDlgCSV: TSaveDialog;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnEditColumn: TButton;
    btnDelRow: TButton;
    mainMenu: TMainMenu;
    File1: TMenuItem;
    OpenFiles1: TMenuItem;
    OpenFolders1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    View1: TMenuItem;
    Refresh1: TMenuItem;
    Option1: TMenuItem;
    actOption1: TMenuItem;
    A2: TMenuItem;
    actAbout1: TMenuItem;
    actLMain: TActionList;
    actDesktop: TAction;
    actAndroid: TAction;
    actOpenFile: TAction;
    actShowInExplorer: TAction;
    actSaveFile: TAction;
    actExit: TAction;
    actCopyToClipboard: TAction;
    actUpdate: TAction;
    actSettings: TAction;
    actAbout: TAction;
    actSource: TAction;
    actWav: TAction;
    actMathE: TAction;
    actFMXE: TAction;
    ColorDialog1: TColorDialog;
    btnCellColor: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnColoumnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnWriteCellClick(Sender: TObject);
    procedure btnAddRowClick(Sender: TObject);
    procedure strGridViewSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SpedtColumnWChange(Sender: TObject);
    procedure btnEditColumnClick(Sender: TObject);
    procedure btnDelRowClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveFileExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure strGridViewDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnCellColorClick(Sender: TObject);
    procedure lbledtRowKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbledtColumnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actCopyToClipboardExecute(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type
  TColorCell = Record
    ccColumn: Integer;
    ccRow: Integer;
    ccColor: TColor;
  end;

type
  TWidthColumn = Record
    ColumnNr: Integer;
    ColumnWidth: Integer;
  end;

var
  frmGridView: TfrmGridView;
  icol: Integer;
  iArrHigh: Integer = 0;
  arrColorCell: array of TColorCell;
  arrWidthCol: array of TWidthColumn;
  ModeArr: TModeArr;

implementation

uses CSVutils, About, Vcl.Clipbrd;

{$R *.dfm}
{ TForm1 }

procedure TfrmGridView.btnWriteCellClick(Sender: TObject);
begin
  if (strGridView.Row = 0) then
    exit;

  strGridView.Cells[strGridView.Col, strGridView.Row] := lbledtRow.Text;
  lbledtRow.Clear;
end;

procedure TfrmGridView.btnEditColumnClick(Sender: TObject);
begin
  if (lbledtColumn.Text = '') then
    exit;

  strGridView.Cols[strGridView.Col].Text := lbledtColumn.Text;
  lbledtColumn.Clear;
end;

procedure TfrmGridView.btnLoadClick(Sender: TObject);
var
  test: ICSVWriter;
  sFilename: string;
  I: Integer;
begin
  if ODlgCSV.Execute then
    sFilename := ODlgCSV.FileName;

  if (sFilename <> '') then
  begin
    test := TCSVWriter.Create;
    setlength(arrColorCell, 100);

    test.LoadCSVToStringGrid(sFilename, strGridView, arrColorCell, arrWidthCol);
    for I := 0 to strGridView.ColCount - 1 do
    begin
      // arrWidthCol[I].ColumnNr := I;
      strGridView.ColWidths[I] := arrWidthCol[I].ColumnWidth;
    end;

    ModeArr := arrLoad;
  end;
end;

procedure TfrmGridView.actAboutExecute(Sender: TObject);
var
  f: TAboutBox;
begin
  if Assigned(f) then
    Application.CreateForm(TAboutBox, f);
  f.Position := poMainFormCenter;
  try
    f.ShowModal;
  finally
    FreeAndNil(f);
  end;

end;

procedure TfrmGridView.actCopyToClipboardExecute(Sender: TObject);
begin
   if lbledtColumn.Focused=True then lbledtColumn.CopyToClipboard;
   if lbledtRow.Focused=True then lbledtRow.CopyToClipboard;

end;

procedure TfrmGridView.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmGridView.actOpenFileExecute(Sender: TObject);
begin
  btnLoadClick(nil);

end;

procedure TfrmGridView.actSaveFileExecute(Sender: TObject);
begin
  btnSaveClick(nil);
end;

procedure TfrmGridView.btnAddRowClick(Sender: TObject);
begin
  strGridView.RowCount := strGridView.RowCount + 1;

end;

procedure TfrmGridView.btnCellColorClick(Sender: TObject);
var
  ic: Integer;
begin
  //

  if (ColorDialog1.Execute) then
  begin

    if ModeArr = arrCreate then
    Begin
      inc(iArrHigh);
      setlength(arrColorCell, iArrHigh);

      arrColorCell[High(arrColorCell)].ccColumn := strGridView.Col;
      arrColorCell[High(arrColorCell)].ccRow := strGridView.Row;
      arrColorCell[High(arrColorCell)].ccColor := ColorDialog1.Color;
    End;

    if ModeArr = arrLoad then
    Begin
      // setlength(arrColorCell, High(arrColorCell)+1);
      // inc(iArrHigh);
      // ic := High(arrColorCell) - iArrHigh;
      ic := 0;
      repeat
        inc(ic);
      until (arrColorCell[ic].ccColor = 0);

      arrColorCell[ic].ccColumn := strGridView.Col;
      arrColorCell[ic].ccRow := strGridView.Row;
      arrColorCell[ic].ccColor := ColorDialog1.Color;

    End;

  end;
end;

procedure TfrmGridView.btnColoumnClick(Sender: TObject);
begin
  if (lbledtColumn.Text = '') then
    exit;

  inc(icol);
  if (icol = 7) then
  begin
    MessageDlg('limit column number in Table is 6 .', mtWarning, [mbOK], 0);
    exit;

  end;

  if ModeArr = arrLoad then
    strGridView.ColCount := strGridView.ColCount + 1
  else if (icol > 1) then
    strGridView.ColCount := strGridView.ColCount + 1;

  strGridView.ColCount := strGridView.ColCount;
  strGridView.Cols[strGridView.ColCount - 1].Text := lbledtColumn.Text;
  lbledtColumn.Clear;

end;

procedure TfrmGridView.btnDelRowClick(Sender: TObject);
begin
  if (strGridView.RowCount > 2) then

    strGridView.RowCount := strGridView.RowCount - 1;
end;

procedure TfrmGridView.btnSaveClick(Sender: TObject);
var
  writer: ICSVWriter;
  I: Integer;
  lStringGrid: Integer;
  rStringGrid: Integer;
  j: Integer;
  sField, sField1, sField2, sField3, sField4, sField5: string;
  sValue, sValue1, sValue2, sValue3, sValue4, sValue5: string;
  sFilename: string;
begin
  if SDlgCSV.Execute then
    sFilename := SDlgCSV.FileName
  else
    exit;

  if (sFilename <> '') then
  Begin
    writer := TCSVWriter.Create;
    lStringGrid := strGridView.ColCount;
    rStringGrid := strGridView.RowCount;
    for I := 0 to lStringGrid - 1 do
    begin
      writer.Field(strGridView.Cells[I, 0]);

    end;

    // for I := 0 to lStringGrid - 1 do
    // Begin
    for j := 1 to rStringGrid - 1 do
    begin
      sField := strGridView.Cells[0, 0];
      sValue := strGridView.Cells[0, j];

      sField1 := strGridView.Cells[1, 0];
      sValue1 := strGridView.Cells[1, j];

      sField2 := strGridView.Cells[2, 0];
      sValue2 := strGridView.Cells[2, j];

      sField3 := strGridView.Cells[3, 0];
      sValue3 := strGridView.Cells[3, j];

      sField4 := strGridView.Cells[4, 0];
      sValue4 := strGridView.Cells[4, j];

      sField5 := strGridView.Cells[5, 0];
      sValue5 := strGridView.Cells[5, j];

      case lStringGrid of
        1:
          writer.AddRow.Value(sField, sValue);
        2:
          writer.AddRow.Value(sField, sValue).Value(sField1, sValue1);
        3:
          writer.AddRow.Value(sField, sValue).Value(sField1, sValue1)
            .Value(sField1, sValue1).Value(sField2, sValue2)
            .Value(sField3, sValue3);
        4:
          writer.AddRow.Value(sField, sValue).Value(sField1, sValue1)
            .Value(sField1, sValue1).Value(sField2, sValue2)
            .Value(sField3, sValue3);
        5:
          writer.AddRow.Value(sField, sValue).Value(sField1, sValue1)
            .Value(sField1, sValue1).Value(sField2, sValue2)
            .Value(sField3, sValue3).Value(sField4, sValue4);

        6:
          writer.AddRow.Value(sField, sValue).Value(sField1, sValue1)
            .Value(sField1, sValue1).Value(sField2, sValue2)
            .Value(sField3, sValue3).Value(sField4, sValue4)
            .Value(sField5, sValue5);

      end;

    end;

  end;
  if ExtractFileExt(sFilename) = EmptyStr then
    sFilename := sFilename + '.csv';

  for I := 0 to strGridView.ColCount - 1 do
  begin
    arrWidthCol[I].ColumnNr := I;
    arrWidthCol[I].ColumnWidth := strGridView.ColWidths[I];
  end;

  writer.SaveToFile(sFilename, arrColorCell, arrWidthCol);

end;

procedure TfrmGridView.FormCreate(Sender: TObject);
begin
  ODlgCSV.Filter := 'CSV Files (*.csv)|*.csv';
  SDlgCSV.Filter := 'CSV Files (*.csv)|*.csv';
  Self.Caption:='TColorCSV';
  self.Position := poMainFormCenter;
  self.WindowState := wsMaximized;
  self.Color := RGB(46, 141, 230);
  KeyPreview := True;
  icol := 0;
  ModeArr := arrCreate;
  setlength(arrWidthCol, 6);

end;

procedure TfrmGridView.lbledtColumnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Ord(Key) of
    188:
      Begin
        if (ssCtrl in Shift) then
        begin
          lbledtColumn.Text := Clipboard.AsText
        end
        else
          Key := 0;
      End;

    99:
      begin

        if (ssCtrl in Shift) then
          lbledtColumn.CopyToClipboard
        else
          Key := 0;
      end;
  end;
end;

procedure TfrmGridView.lbledtRowKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Ord(Key) of
    188:
      Begin
        if (ssCtrl in Shift) then
        begin
          lbledtRow.Text := Clipboard.AsText
        end
        else
          Key := 0;
      End;

    99:
      begin

        if (ssCtrl in Shift) then
          lbledtRow.CopyToClipboard
        else
          Key := 0;
      end;
  end;

end;

procedure TfrmGridView.SpedtColumnWChange(Sender: TObject);
begin
  strGridView.ColWidths[strGridView.Col] := SpedtColumnW.Value;
end;

procedure TfrmGridView.strGridViewDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  I: Integer;
  ALength: Integer;
begin
  ALength := Length(arrColorCell);
  if (ALength > 0) then
    for I := low(arrColorCell) to High(arrColorCell) do
    Begin
      if (arrColorCell[I].ccColor <> 0) then
        if (ACol = arrColorCell[I].ccColumn) and (ARow = arrColorCell[I].ccRow)
        then
          with TStringGrid(Sender) do
          begin

            // paint the background Green
            Canvas.Brush.Color := arrColorCell[I].ccColor;
            Canvas.FillRect(Rect);
            Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
          end;

    End;

end;

procedure TfrmGridView.strGridViewSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  //
  if strGridView.Col = ACol then

    SpedtColumnW.Value := strGridView.ColWidths[ACol]

end;

{ TODO : Add Column width as Array to save in csv datei }

end.
