{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit SetupPrinter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, printers;

type
  TfrmSetupPrinter = class(TForm)
    RGrpColor: TRadioGroup;
    CBPrinter: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    RGrpSize: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure RGrpColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CBPrinterChange(Sender: TObject);
    procedure RGrpSizeClick(Sender: TObject);
  private
    FPrintColor: boolean;
    FPrintSize: integer;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    property PrintColor: boolean read FPrintColor write FPrintColor;
    property PrintSize :integer read FPrintSize write FPrintSize;
  end;


implementation

uses uSettingPrint;

{$R *.dfm}

procedure TfrmSetupPrinter.Button1Click(Sender: TObject);
begin

  caption := (GetDefaultPrinter);
end;

procedure TfrmSetupPrinter.CBPrinterChange(Sender: TObject);
begin
 SetDefaultPrinter((CBPrinter.Items[CBPrinter.ItemIndex]));
end;

procedure TfrmSetupPrinter.FormCreate(Sender: TObject);
var
  sNameAccutelPrinter: string;
  iPos: integer;
begin

  self.Color := clwhite;
  self.Position := poMainFormCenter;
  FPrintColor := true;
  FPrintSize := 1;

  CBPrinter.Text := '';
  CBPrinter.Items.Clear;
  CBPrinter.Items.AddStrings(Printer.printers);
  sNameAccutelPrinter := GetDefaultPrinter;
  iPos := CBPrinter.Items.IndexOf(sNameAccutelPrinter);
  CBPrinter.ItemIndex := iPos;
end;

procedure TfrmSetupPrinter.RGrpColorClick(Sender: TObject);
begin
  case RGrpColor.ItemIndex of
    0:
      FPrintColor := true;
    1:
      FPrintColor := false;
  end;

end;

procedure TfrmSetupPrinter.RGrpSizeClick(Sender: TObject);
begin
  case RGrpSize.ItemIndex of
    0:
      FPrintSize := 1;
    1:
      FPrintSize := 2;
  end;
end;

end.
