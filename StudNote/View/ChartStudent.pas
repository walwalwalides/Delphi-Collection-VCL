{ ============================================
  Software Name : 	StudNote
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit ChartStudent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.grids, Generics.Collections,
  Vcl.Buttons, System.Threading;

type
  TarrStu = record
    Student: string;
    average: Extended;
  end;

type
  TfrmChartStudent = class(TForm)
    Panel: TPanel;
    statBarInfo: TStatusBar;
    lbValues: TListBox;
    leID: TLabeledEdit;
    leMaxi: TLabeledEdit;
    leMin: TLabeledEdit;
    Panel2: TPanel;
    PaintBox: TPaintBox;
    bClose: TBitBtn;
    bSave: TBitBtn;
    bStart: TBitBtn;
    BitBtnSearch: TBitBtn;
    procedure bStartClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure lbValuesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtnSearchClick(Sender: TObject);
    procedure leIDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure leIDChange(Sender: TObject);
  private
    { Déclarations privées }
    n: Integer;
    pasx, pasy: real;
    v, vmax, vmin: Extended;
    procedure TraceGraphe;
    function MaxIntValue(const Data: array of TarrStu): Extended;
    function MinIntValue(const Data: array of TarrStu): Extended;
    procedure arrStudBubble(arr: array of TarrStu);
    procedure DrawGraph;
    procedure TraceGrapheSearch(Aindex: Integer);
  public
    { Déclarations publiques }
    procedure FulltheTables(StuStringGrid: TStringGrid);
  end;

var
  frmChartStudent: TfrmChartStudent;

implementation

{$R *.dfm}

uses System.IOUtils, System.Character, FormMain;

var
  arrStu: array of TarrStu;

procedure TfrmChartStudent.bCloseClick(Sender: TObject);
begin
  Close
end;

procedure TfrmChartStudent.BitBtnSearchClick(Sender: TObject);
var
  I: Integer;
  Aindex: Integer;
begin
  Screen.Cursor := crHourGlass;
  lbValues.Clear;
  PaintBox.Refresh;
  // lbValues.Items.Add(leStartV.Text);
  // v:=StrtoInt(leStartV.Text);
  n := 2;
  vmax := MaxIntValue(arrStu);

  vmin := 1;
  // leMaxi.Text := vmax.ToString;

  for I := Low(arrStu) to High(arrStu) do
    if (arrStu[I].Student = leID.Text) then
    begin
      lbValues.Items.Add(arrStu[I].Student + ':' + arrStu[I].average.ToString);
      inc(n);
      Aindex := I;
      Break
    end;
  // vmin := MinIntValue(arrStu, n);
  // leMin.Text := vmin.ToString;
  Refresh;
  Screen.Cursor := crDefault;

  TraceGrapheSearch(Aindex);

end;

function TfrmChartStudent.MaxIntValue(const Data: array of TarrStu): Extended;
var
  I: Integer;
begin
  Result := Data[Low(Data)].average;
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I].average then
      Result := Data[I].average;
end;

function TfrmChartStudent.MinIntValue(const Data: array of TarrStu): Extended;
var
  I: Integer;
begin
  Result := Data[Low(Data)].average;
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I].average then
      Result := Data[I].average;
end;

procedure TfrmChartStudent.DrawGraph;

var
  I: Integer;
begin
  n := 2;
  Screen.Cursor := crHourGlass;
  lbValues.Clear;
  vmax := MaxIntValue(arrStu);
  leMaxi.Text := vmax.ToString;

  for I := Low(arrStu) to High(arrStu) do
    if (arrStu[I].Student <> '') then
    begin
      lbValues.Items.Add(arrStu[I].Student + ':' + arrStu[I].average.ToString);
      inc(n);
    end;
  vmin := MinIntValue(arrStu);
  leMin.Text := vmin.ToString;
  Refresh;
  Screen.Cursor := crDefault;
  TraceGraphe
end;

procedure TfrmChartStudent.FormCreate(Sender: TObject);
var
  strAppPfad: string;
begin
  with lbValues do
    Style := lbOwnerDrawFixed;
  statBarInfo.Font.Style := [fsBold];

  strAppPfad := ExtractFilePath(Application.ExeName);

end;

procedure TfrmChartStudent.arrStudBubble(arr: array of TarrStu);
var
  I, k: Integer;
  itmp: Extended;
  stmp: string;
begin
  for I := 0 to high(arr) - 1 do
    for k := I + 1 to high(arr) do
      if (arr[I].average > arr[k].average) then
      begin
        itmp := arr[k].average;
        stmp := arr[k].Student;
        arr[k].average := arr[I].average;
        arr[k].Student := arr[I].Student;
        arr[I].average := itmp;
        arr[I].Student := stmp;
      end;
end;

procedure TfrmChartStudent.FulltheTables(StuStringGrid: TStringGrid);
var
  I: Integer;
  iaverage: Extended;
  sStudent: string;
begin
  // btnLstBoxDuration.StyleElements := [];
  // posMor := 1;
  // posLun := 1;
  // posEve := 1;

  for I := 1 to StuStringGrid.RowCount do
  begin
    sStudent := StuStringGrid.Cells[0, I];
    if ((TryStrToFloat(StuStringGrid.Cells[4, I], iaverage)) and (sStudent <> '')) then
    begin
      arrStu[I - 1].Student := sStudent;
      arrStu[I - 1].average := iaverage;
    end;

    // lbValues.Items.Add(arrStu[I].Student);

  end;

  // pnlMor.Caption := IntToStr(posMor - 1);
  // pnlLun.Caption := IntToStr(posLun - 1);
  // pnlEve.Caption := IntToStr(posEve - 1);
  // lbValues.Invalidate;
  // TArray.Sort<TarrStu>(arrStu);
end;

procedure TfrmChartStudent.FormResize(Sender: TObject);
begin
  DrawGraph;

end;

procedure TfrmChartStudent.FormShow(Sender: TObject);
begin
  BitBtnSearch.Enabled := length(leID.Text) > 0;
  SetLength(arrStu, MainForm.StringGrid.RowCount - 1);
  FulltheTables(MainForm.StringGrid);
  TArray.Sort<TarrStu>(arrStu);
  statBarInfo.Panels[0].Text := ' Total number of students : ' + '(' + (High(arrStu) + 1).ToString + ')';
end;

procedure TfrmChartStudent.lbValuesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);

var
  LB: TListBox;
  dTop, dLeft: Integer;
  Size: TSize;
begin
  if not(Control is TListBox) then
    Exit;
  LB := Control as TListBox;

  Size := LB.Canvas.TextExtent(LB.Items[Index]);
  dTop := (LB.ItemHeight - Size.cy) div 2;
  dLeft := ((Rect.Right - Rect.Left) - Size.cx) div 2;

  LB.Canvas.TextRect(Rect, Rect.Left + 2 + dLeft, Rect.Top + dTop, LB.Items[Index]);
end;

procedure TfrmChartStudent.leIDChange(Sender: TObject);
begin
  BitBtnSearch.Enabled := length(leID.Text) > 0;

end;

procedure TfrmChartStudent.leIDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((Key = VK_RETURN) and (length(leID.Text) = 5)) then
  begin
    BitBtnSearchClick(nil);
  end;
end;

procedure TfrmChartStudent.TraceGraphe;

var
  I, Ox, Oy: Integer;
begin

  with PaintBox do
  begin
    if frmChartStudent.WindowState = wsMaximized then
      Font.Size := 11
    else
      Font.Size := 11;
    Ox := 40;
    Oy := ClientHeight - 40;
    pasx := (Clientwidth - 80) / n;
    pasy := (ClientHeight - 80) / vmax;
    Canvas.pen.width := 2;
    // Axe horizontal
    Canvas.MoveTo(Ox, Oy);
    Canvas.LineTo(trunc(Ox + pasx * n), Oy);
    // Axe vertical
    Canvas.MoveTo(Ox, Oy);
    Canvas.LineTo(Ox, Oy - trunc(pasy * vmax));

    Canvas.pen.width := 1;
    Canvas.pen.Color := clMaroon;
    Canvas.Brush.Color := clAqua;

    for I := Low(arrStu) to High(arrStu) do
    begin
      if (arrStu[I].Student <> '') then
      begin
        v := arrStu[I].average;
        Canvas.Rectangle(trunc(Ox + pasx * I), Oy, trunc(Ox + pasx * succ(I)), trunc(Oy - pasy * v));
        if v = vmax then
          Canvas.Font.Style := [fsBold]
        else
          Canvas.Font.Style := [];

        Canvas.TextOut(trunc(Ox + pasx * I) + 5, trunc(Oy - pasy * v) + 5, FloatToStr(arrStu[I].average) + Char(32) + '');
        Canvas.TextOut(trunc(Ox + pasx * I) + (frmChartStudent.width div 25), trunc(Oy - pasy * v) - (frmChartStudent.Height div 25) + 5, arrStu[I].Student);
      end;
    end;
  end;

end;

procedure TfrmChartStudent.TraceGrapheSearch(Aindex: Integer);

var
  I, Ox, Oy: Integer;
begin

  with PaintBox do
  begin
    if frmChartStudent.WindowState = wsMaximized then
      Font.Size := 11
    else
      Font.Size := 11;
    Ox := 40;
    Oy := ClientHeight - 40;
    pasx := (Clientwidth - 80) / n;
    pasy := (ClientHeight - 80) / vmax;
    Canvas.pen.width := 2;
    // Axe horizontal
    Canvas.MoveTo(Ox, Oy);
    Canvas.LineTo(trunc(Ox + pasx * n), Oy);
    // Axe vertical
    Canvas.MoveTo(Ox, Oy);
    Canvas.LineTo(Ox, Oy - trunc(pasy * vmax));

    Canvas.pen.width := 1;
    Canvas.pen.Color := clMaroon;
    Canvas.Brush.Color := clAqua;
    I := 1;
    if (arrStu[Aindex].Student <> '') then
    begin
      v := arrStu[Aindex].average;
      Canvas.Rectangle(trunc(Ox + pasx * I), Oy, trunc(Ox + pasx * succ(I)), trunc(Oy - pasy * v));
      if v = vmax then
        Canvas.Font.Style := [fsBold]
      else
        Canvas.Font.Style := [];

      Canvas.TextOut(trunc(Ox + pasx * I) + 5, trunc(Oy - pasy * v) + 5, FloatToStr(arrStu[Aindex].average) + Char(32) + '');
      Canvas.TextOut(trunc(Ox + pasx * I) + (frmChartStudent.width div 25), trunc(Oy - pasy * v) - (frmChartStudent.Height div 25) + 5, arrStu[Aindex].Student);
    end;

  end;

end;

procedure TfrmChartStudent.bSaveClick(Sender: TObject);
var
  bmp: tBitmap;
var
  saveDialog: tsavedialog; // Save dialog variable
begin
  saveDialog := tsavedialog.Create(Self);
  saveDialog.Title := 'Save your Bitmap file';
  saveDialog.InitialDir := GetCurrentDir;
  saveDialog.Filter := 'Bitmap file|*.bmp';
  saveDialog.DefaultExt := 'txt';
  saveDialog.FilterIndex := 1;
  if saveDialog.Execute then
  begin
    // Create Bitmap
    bmp := tBitmap.Create;
    bmp.width := PaintBox.width;
    bmp.Height := PaintBox.Height;
    BitBlt(bmp.Canvas.Handle, 0, 0, bmp.width, bmp.Height, PaintBox.Canvas.Handle, 0, 0, SRCCOPY);
    try
      bmp.SavetoFile(saveDialog.Filename);
    finally
      bmp.Free;
      MessageDlg('File : ' + ExtractFileName(saveDialog.Filename) + ' was successfully saved.', mtInformation, [mbOK], 0);
    end;
  end
  else
    ShowMessage('Save file was cancelled');

  saveDialog.Free;

end;

procedure TfrmChartStudent.bStartClick(Sender: TObject);
begin
  DrawGraph;
end;

end.
