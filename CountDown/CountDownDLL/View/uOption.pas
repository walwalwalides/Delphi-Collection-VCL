{ ============================================
  Software Name : 	CountDouwnDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit uOption;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, Buttons, MMSystem;

type
  TfrmOption = class(TForm)
    BitBtn1: TBitBtn;
    GroupBox4: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label15: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label16: TLabel;
    GroupBox6: TGroupBox;
    Label5: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    Pnl01: TPanel;
    Pnl02: TPanel;
    Pnl03: TPanel;
    Pnl04: TPanel;
    pnl05: TPanel;
    pnl06: TPanel;
    pnl07: TPanel;
    ColorDialog1: TColorDialog;
    OpenDialog2: TOpenDialog;
    BitbtnView: TBitBtn;
    {Declartion intern}
    procedure Couleurclick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure BitbtnViewClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmOption: TfrmOption;

implementation

uses uCountDown;

{$R *.DFM}
Var
  Modifcolors : array[1..7] OF Tcolor;

procedure TfrmOption.Couleurclick(Sender: TObject);
var
  i : integer;
begin
  inc(modif);
  With sender as Tpanel do
  begin
    colordialog1.color := color;
    colordialog1.execute;
    color := colordialog1.color;
    i := strtoint(copy(name, length(name)-1,2));
    Colors[i] := color;
  end;
end;

Procedure TfrmOption.Formactivate(sender: Tobject);
var
  i : integer;
Begin
  For i := 1 TO 16 do Modifcolors[i] := Colors[i]; { save colors }
  Pnl01.color := Colors[01];  //Interior Color Casing
  Pnl02.color := Colors[02];  //Exterior Color Casing
  Pnl03.color := Colors[03];  //Interior Color Dial
  Pnl04.color := Colors[04];  //Exterior Color Dial
  Pnl05.color := Colors[05];
  Pnl06.color := Colors[06];
  Pnl07.color := Colors[07];   //Number

end;




procedure TfrmOption.FormCreate(Sender: TObject);
begin
  modif := 0;
end;

procedure TfrmOption.RadioGroup3Click(Sender: TObject);
begin
  inc(modif);
end;

procedure TfrmOption.SpinEdit1Change(Sender: TObject);
begin
  inc(modif);
end;

procedure TfrmOption.BitbtnViewClick(Sender: TObject);
begin
  frmCountDown.newParams;
end;

end.
