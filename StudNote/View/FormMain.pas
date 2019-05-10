{ ============================================
  Software Name : 	StudNote
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Vcl.Buttons, Vcl.Menus;

const
  iniFile = 'Data\';
  iniName = 'Student.ini';

type
  TStudentData = record
    iName: String;
    iFre: Integer;
    iEng: Integer;
    iMath: Integer;
    iMoy: Double;
  end;

  TMainForm = class(TForm)
    NameEdit: TEdit;
    FreEdit: TEdit;
    EngEdit: TEdit;
    MathEdit: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StringGrid: TStringGrid;
    KorPanel: TPanel;
    EngPanel: TPanel;
    MathPanel: TPanel;
    TotalPanel: TPanel;
    GrBoxNote: TGroupBox;
    GrBoxControle: TGroupBox;
    bvlHead: TBevel;
    bvlFeet: TBevel;
    AddButton: TBitBtn;
    DelButton: TBitBtn;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    BalloonHint: TBalloonHint;
    A1: TMenuItem;
    I1: TMenuItem;
    BitBtnChart: TBitBtn;
    BitBtnEdit: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure I1Click(Sender: TObject);
    procedure BitBtnChartClick(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure FreEditChange(Sender: TObject);
    procedure EngEditChange(Sender: TObject);
    procedure MathEditChange(Sender: TObject);
    procedure BitBtnEditClick(Sender: TObject);
  private
    fStudentArr: array of TStudentData;
    fSumArr: array [0 .. 3] of Integer;

    procedure AddStudent(aName: String; aFre, aEng, aMath: Integer);
    procedure RemoveStudent(aName: String);
    procedure DoOutput(aArrIndex: Integer; aName: String);
    procedure writeIniDatei;
    procedure LoadIniDatei;
    procedure ShowCellHint(X, Y: Integer);
    function ADDpermisition: boolean;
    procedure EditStudent(aName: String);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  System.IniFiles, AboutSN, ChartStudent;

{$R *.dfm}

var
  iniFolder, iniPath: String;
  Bitmap1, Bitmap2, Bitmap3: TBitmap;
  LastRow, LastCol: Integer;
  AColLastCol, ARowLastRow: boolean;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainForm.KeyPreview := True;
  // ------------------------------------  //
  MathEdit.NumbersOnly := True;
  FreEdit.NumbersOnly := True;
  EngEdit.NumbersOnly := True;

  AddButton.Enabled := False;

  iniFolder := ExtractFilePath(Application.ExeName) + iniFile;
  ForceDirectories(iniFolder);
  iniPath := iniFolder + iniName;

  SetLength(fStudentArr, 0);
  fSumArr[0] := 0;
  fSumArr[1] := 0;
  fSumArr[2] := 0;
  StringGrid.Cells[0, 0] := 'Student';
  StringGrid.Cells[1, 0] := 'Note1';
  StringGrid.Cells[2, 0] := 'Note2';
  StringGrid.Cells[3, 0] := 'Note3';
  StringGrid.Cells[4, 0] := 'Moyen';
  LoadIniDatei;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  writeIniDatei;
end;

procedure TMainForm.FreEditChange(Sender: TObject);
begin
  AddButton.Enabled := ADDpermisition;
end;

procedure TMainForm.I1Click(Sender: TObject);
begin
  frmAboutSN.Show;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.NameEditChange(Sender: TObject);
begin
  AddButton.Enabled := ADDpermisition;
end;

procedure TMainForm.AddButtonClick(Sender: TObject);
begin
  AddStudent(NameEdit.Text, StrToInt(FreEdit.Text), StrToInt(EngEdit.Text), StrToInt(MathEdit.Text));
  AddButton.Enabled := False;
end;

procedure TMainForm.AddStudent(aName: String; aFre, aEng, aMath: Integer);
var
  aIndex, i: Integer;
begin
  aIndex := -1;
  for i := 0 to Length(fStudentArr) - 1 do
  begin
    if fStudentArr[i].iName = aName then
    begin
      aIndex := 0;
      Break;
    end;
  end;
  if aIndex < 0 then
  begin
    aIndex := Length(fStudentArr);
    SetLength(fStudentArr, aIndex + 1);
  end;
  fSumArr[0] := fSumArr[0] - fStudentArr[aIndex].iFre + aFre;
  fSumArr[1] := fSumArr[1] - fStudentArr[aIndex].iEng + aEng;
  fSumArr[2] := fSumArr[2] - fStudentArr[aIndex].iMath + aMath;
  fStudentArr[aIndex].iName := aName;
  fStudentArr[aIndex].iFre := aFre;
  fStudentArr[aIndex].iEng := aEng;
  fStudentArr[aIndex].iMath := aMath;
  fStudentArr[aIndex].iMoy := (aFre + aEng + aMath) / 3;
  DoOutput(aIndex, aName);
end;

function TMainForm.ADDpermisition: boolean;
begin
  result := ((Length(NameEdit.Text) > 0) and (Length(MathEdit.Text) > 0) and (Length(EngEdit.Text) > 0) and (Length(FreEdit.Text) > 0));
end;

procedure TMainForm.BitBtnChartClick(Sender: TObject);
begin
  //

  Application.CreateForm(TfrmChartStudent, frmChartStudent);
  try
    frmChartStudent.ShowModal;
  finally
    FreeAndNil(frmChartStudent)
  end;
end;

procedure TMainForm.BitBtnEditClick(Sender: TObject);
var
  Ycol: Integer;
  studentName: string;
begin
  if AddButton.Enabled then
  begin
    AddButtonClick(nil);
    exit;
  end;

  Ycol := StringGrid.Selection.BottomRight.Y;
  if (Ycol > -1) then
  begin
    studentName := StringGrid.Cells[0, Ycol];

    EditStudent(studentName);

  end;
end;

procedure TMainForm.btnClick(Sender: TObject);
begin
  ShowMessage(StringGrid.Cells[0, 1]);
end;

procedure TMainForm.RemoveStudent(aName: String);
var
  i, aIndex, aArrLeng: Integer;
begin
  aArrLeng := Length(fStudentArr);
  aIndex := -1;
  for i := 0 to aArrLeng - 1 do
  begin
    if fStudentArr[i].iName = aName then
    begin
      aIndex := i;
      Break;
    end;
  end;
  if aIndex >= 0 then
  begin
    fSumArr[0] := fSumArr[0] - fStudentArr[aIndex].iFre;
    fSumArr[1] := fSumArr[1] - fStudentArr[aIndex].iEng;
    fSumArr[2] := fSumArr[2] - fStudentArr[aIndex].iMath;
    fStudentArr[aIndex] := fStudentArr[aArrLeng - 1];
    SetLength(fStudentArr, aArrLeng - 1);
    DoOutput(-1, aName);
  end;
end;

procedure TMainForm.EditStudent(aName: String);
var
  i, aIndex, aArrLeng: Integer;
begin
  aArrLeng := Length(fStudentArr);
  aIndex := -1;
  for i := 0 to aArrLeng - 1 do
  begin
    if fStudentArr[i].iName = aName then
    begin
      aIndex := i;
      Break;
    end;
  end;
  if aIndex >= 0 then
  begin
    NameEdit.Text := aName;
    FreEdit.Text := (fStudentArr[aIndex].iFre).ToString;
    EngEdit.Text := (fStudentArr[aIndex].iEng).ToString;
    MathEdit.Text := (fStudentArr[aIndex].iMath).ToString;

    DoOutput(aIndex, aName);
  end;
end;

procedure TMainForm.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  AGrid: TStringGrid;
  CellLeftMargin, CellTopMargin: Integer;
begin

  AGrid := TStringGrid(Sender);
  if (ARow = 0) then
    StringGrid.Canvas.Font.Style := [fsBold];

  if gdFixed in State then // if is fixed use the clBtnFace color
    AGrid.Canvas.Brush.Color := clBtnFace
  else if gdSelected in State then // if is selected use the clAqua color
    AGrid.Canvas.Brush.Color := clAqua
  else
    AGrid.Canvas.Brush.Color := clWindow; // if is not selected use the clwindow color

  AGrid.Canvas.FillRect(Rect);
  AGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, AGrid.Cells[ACol, ARow]);

end;

procedure TMainForm.StringGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

  ShowCellHint(X, Y);
end;

{
  Show Cell Hint
}
procedure TMainForm.ShowCellHint(X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if StringGrid.ShowHint = False then
    StringGrid.ShowHint := True;
  StringGrid.MouseToCell(X, Y, ACol, ARow);
  if (ACol > -1) and (ARow > -1) then
    StringGrid.Hint := StringGrid.Cells[ACol, ARow];
  // if (AColLastCol) or (ARowLastRow) then
  // begin
  // Application.CancelHint;
  // LastCol:=ACol;
  // LastRow:=ARow;
  // end;
end;

procedure TMainForm.DelButtonClick(Sender: TObject);
begin
  RemoveStudent(NameEdit.Text);
  NameEdit.Clear;
  MathEdit.Clear;
  FreEdit.Clear;
  EngEdit.Clear;
  
end;

procedure TMainForm.DoOutput(aArrIndex: Integer; aName: String);
var
  i, aGridIndex: Integer;
begin
  aGridIndex := -1;
  if aArrIndex < 0 then
  begin
    for i := 1 to StringGrid.RowCount - 1 do
    begin
      if StringGrid.Cells[0, i] = aName then
      begin
        aGridIndex := i;
        Break;
      end;
    end;
    if aGridIndex < -1 then
      exit
    else
    begin
      for i := aGridIndex to StringGrid.RowCount - 1 do
      begin
        StringGrid.Cells[0, i] := StringGrid.Cells[0, i + 1];
        StringGrid.Cells[1, i] := StringGrid.Cells[1, i + 1];
        StringGrid.Cells[2, i] := StringGrid.Cells[2, i + 1];
        StringGrid.Cells[3, i] := StringGrid.Cells[3, i + 1];
        StringGrid.Cells[4, i] := StringGrid.Cells[4, i + 1];
      end;
      StringGrid.RowCount := StringGrid.RowCount - 1;
    end;
  end
  else
  begin
    for i := 1 to StringGrid.RowCount - 1 do
    begin
      if StringGrid.Cells[0, i] = aName then
      begin
        aGridIndex := i;
        Break;
      end;
    end;
    if aGridIndex < 0 then
    begin
      if StringGrid.Cells[0, 1] = '' then
        aGridIndex := 1
      else
      begin
        StringGrid.RowCount := StringGrid.RowCount + 1;
        aGridIndex := StringGrid.RowCount - 1;
      end;
    end;
    StringGrid.Cells[0, aGridIndex] := fStudentArr[aArrIndex].iName;
    StringGrid.Cells[1, aGridIndex] := IntToStr(fStudentArr[aArrIndex].iFre);
    StringGrid.Cells[2, aGridIndex] := IntToStr(fStudentArr[aArrIndex].iEng);
    StringGrid.Cells[3, aGridIndex] := IntToStr(fStudentArr[aArrIndex].iMath);
    StringGrid.Cells[4, aGridIndex] := FormatFloat('0.00', fStudentArr[aArrIndex].iMoy);
  end;
  KorPanel.Caption := FormatFloat('0.00', fSumArr[0] / (StringGrid.RowCount - 1));
  EngPanel.Caption := FormatFloat('0.00', fSumArr[1] / (StringGrid.RowCount - 1));
  MathPanel.Caption := FormatFloat('0.00', fSumArr[2] / (StringGrid.RowCount - 1));
  TotalPanel.Caption := FormatFloat('0.00', (fSumArr[0] + fSumArr[1] + fSumArr[2]) / ((StringGrid.RowCount - 1) * 3));

end;

procedure TMainForm.EngEditChange(Sender: TObject);
begin
  AddButton.Enabled := ADDpermisition;
end;

procedure TMainForm.writeIniDatei;
var
  sIniDatei: TIniFile;
  i: Integer;
begin
  sIniDatei := TIniFile.Create(iniPath);

  for i := 1 to StringGrid.RowCount do
  begin
    if (StringGrid.Cells[0, i] <> '') then
    begin
      sIniDatei.WriteString('Student n°' + i.ToString, 'Name', StringGrid.Cells[0, i]);
      sIniDatei.WriteString('Student n°' + i.ToString, 'Note1', StringGrid.Cells[1, i]);
      sIniDatei.WriteString('Student n°' + i.ToString, 'Note2', StringGrid.Cells[2, i]);
      sIniDatei.WriteString('Student n°' + i.ToString, 'Note3', StringGrid.Cells[3, i]);
    end;

  end;

  sIniDatei.Free;
end;

procedure TMainForm.LoadIniDatei;
var
  sIniDatei: TIniFile;
  ANote1: string;
  ANote2: string;
  ANote3: string;
  i: Integer;
  oSL: TStringlist;
  iline: Integer;
  Astudent: string;
begin
  if not FileExists(iniPath) then
    exit;

  oSL := TStringlist.Create;
  try
    oSL.LoadFromFile(iniPath);
    iline := oSL.Count div 4
  finally
    oSL.Free;
  end;
  if (iline <= 0) then
    exit;

  sIniDatei := TIniFile.Create(iniPath);

  for i := 1 to iline do
  begin

    Astudent := sIniDatei.ReadString('Student n°' + i.ToString, 'Name', '');
    ANote1 := sIniDatei.ReadString('Student n°' + i.ToString, 'Note1', '');
    ANote2 := sIniDatei.ReadString('Student n°' + i.ToString, 'Note2', '');
    ANote3 := sIniDatei.ReadString('Student n°' + i.ToString, 'Note3', '');
    if ((Astudent <> '') and (ANote1 <> '') and (ANote2 <> '') and (ANote3 <> '')) then
      AddStudent(Astudent, StrToInt(ANote1), StrToInt(ANote2), StrToInt(ANote3));
  end;

  sIniDatei.Free;
end;

procedure TMainForm.MathEditChange(Sender: TObject);
begin
  AddButton.Enabled := ADDpermisition;
end;

end.
