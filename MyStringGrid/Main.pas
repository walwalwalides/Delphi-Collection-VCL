{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, uStringGrid,
  uTConnection, Vcl.Menus;

type
  TfrmMain = class(TForm)
    StrGrid: TStringGrid;
    btnUpdateDB: TButton;
    btnInsert: TButton;
    btnCSV: TButton;
    btnJSON: TButton;
    btnPrint: TButton;
    btnPDF: TButton;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    A1: TMenuItem;
    I1: TMenuItem;
    procedure btnUpdateDBClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCSVClick(Sender: TObject);
    procedure btnJSONClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnPDFClick(Sender: TObject);
    procedure StrGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    FConnection: TConnection;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

  end;

var
  frmMain: TfrmMain;

implementation

uses
  SetupPrinter, Module, About;

{$R *.dfm}

procedure TfrmMain.btnUpdateDBClick(Sender: TObject);
begin

  StrGrid.UpdateData;

  // StrGrid.SaveToPDF('Hallo.pdf');
end;

procedure TfrmMain.btnCSVClick(Sender: TObject);
begin
  StrGrid.SaveToCSV;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  self.Position := poMainFormCenter;
  self.caption := Application.title;
  StrGrid.RowCount := 11;
  StrGrid.ColCount := 5;

  StrGrid.Cells[0, 0] := 'ID';
  StrGrid.Cells[1, 0] := 'Note1';
  StrGrid.Cells[2, 0] := 'Note2';
  StrGrid.Cells[3, 0] := 'Note3';
  StrGrid.Cells[4, 0] := 'Note4';

  FConnection := TConnection.create;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  StrGrid.Connection := FConnection.getconnection;
  StrGrid.SQLText := FConnection.GetSQL;
end;

procedure TfrmMain.I1Click(Sender: TObject);
var
  FAbout: TfrmAbout;
begin
  FAbout := nil;
  FAbout.free;

  if not assigned(FAbout) then
  Begin
    FAbout := TfrmAbout.create(nil);
    try
      FAbout.show;
    finally

    end;
  end;
end;

procedure TfrmMain.N2Click(Sender: TObject);
begin
  Application.terminate;
end;

procedure TfrmMain.StrGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  AGrid: TStringGrid;
begin
  AGrid := TStringGrid(Sender);

  if gdFixed in State then // if is fixed use the clBtnFace color
    AGrid.Canvas.Brush.Color := clBtnFace
  else if gdSelected in State then // if is selected use the clAqua color
    AGrid.Canvas.Brush.Color := clAqua
  else
    AGrid.Canvas.Brush.Color := clWindow;

  AGrid.Canvas.FillRect(Rect);
  AGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, AGrid.Cells[ACol, ARow]);
end;

procedure TfrmMain.btnInsertClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 10 do
  begin
    StrGrid.Cells[0, i] := inttostr(i);
    StrGrid.Cells[1, i] := inttostr(random(20));
    StrGrid.Cells[2, i] := inttostr(random(20));
    StrGrid.Cells[3, i] := inttostr(random(20));
    StrGrid.Cells[4, i] := inttostr(random(20));
  end;

end;

procedure TfrmMain.btnJSONClick(Sender: TObject);
begin
  StrGrid.SaveToJSON;
end;

procedure TfrmMain.btnPDFClick(Sender: TObject);
begin
  StrGrid.SaveToPDF;
end;

procedure TfrmMain.btnPrintClick(Sender: TObject);
var
  FSetupPrinter: TfrmSetupPrinter;
begin
  FSetupPrinter := nil;
  FSetupPrinter.free;

  if not assigned(FSetupPrinter) then
  Begin
    FSetupPrinter := TfrmSetupPrinter.create(nil);
    try

      if (FSetupPrinter.ShowModal = mrok) then
      Begin
        case FSetupPrinter.PrintSize of
          1:
            StrGrid.print(0, 0, -1, -1, -1, -1, 1, FSetupPrinter.PrintColor);
          2:
            StrGrid.print(0, 0, -1, -1, -1, -1, 0.5, FSetupPrinter.PrintColor);

        end;

      End;

    finally
      //
      FreeAndNil(FSetupPrinter);
    end;

  End;

  // Change cell size
  // StrGrid.print(StrGrid.left,StrGrid.top,0,4,0,4,1,true);
  // 1/2 Size + color
end;

end.
