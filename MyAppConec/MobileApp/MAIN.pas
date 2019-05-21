{ ============================================
  Software Name : 	MyAppConec
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit MAIN;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.ListBox, FMX.ScrollBox, FMX.Memo,
  Data.DBXDataSnap, Data.DBXCommon, IPPeerClient, Data.DB, Datasnap.DBClient,
  Datasnap.DSConnect, Data.SqlExpr, System.Rtti, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    WorkerNameEdit: TEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Memo1: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    DurationTimer: TTimer;
    Panel1: TPanel;
    UpdateInfoTimer: TTimer;
    ServerConnection: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    DriverStatusCDS: TClientDataSet;
    DriverStatusCDSid: TIntegerField;
    DriverStatusCDSname: TWideStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    RideStatusCDS: TClientDataSet;
    RideStatusCDSid: TIntegerField;
    RideStatusCDSname: TWideStringField;
    BindSourceDB2: TBindSourceDB;
    LinkFillControlToField2: TLinkFillControlToField;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DurationTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UpdateInfoTimerTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Click(Sender: TObject);
    procedure WorkerNameEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    TimeSec: integer;
    iactWorkID: integer;
    sAdress: string;
    boolAddpram: Boolean;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

uses ClientModuleApp;

{$R *.NmXhdpiPh.fmx ANDROID}

procedure TForm4.Button1Click(Sender: TObject);
begin
   TimeSec := 0;
   Label6.Text := '00:00';
  Label6.Visible:=false;
  ComboBox2.ItemIndex :=-1;
  boolAddpram := false;
  Label2.Text := '';
  Label3.Text := '';
  sAdress := '';
  Panel1.Visible := false;
  ComboBox2.Enabled := false;
  if WorkerNameEdit.Text <> '' then
  begin
    Panel1.Visible := true;

    iactWorkID := ClientModule.ServerMethods1Client.GetWorkerID(WorkerNameEdit.Text);

    ComboBox1.ItemIndex := 0;

    if (iactWorkID > 0) then
    begin
      Panel1.Visible := true;
      ComboBox1.Items[0] := 'WorkID : ' + iactWorkID.ToString;
      ComboBox2.Enabled := true;
      UpdateInfoTimer.Enabled := true;
      Label3.Text := ClientModule.ServerMethods1Client.GetWorkerPosition(iactWorkID);
      boolAddpram := true;
    end
    else
    begin
      Memo1.Lines.Clear;
      ComboBox2.Items[0] := 'No Information';
      ComboBox2.ItemIndex := 0;
      Panel1.Visible := true;
      ComboBox1.Items[0] := 'WorkID not found ! ';
      ComboBox2.Enabled := false;
      UpdateInfoTimer.Enabled := false;

    end;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Panel1.Visible := false;
  DurationTimer.Enabled := false;
  TimeSec := 0;
  ComboBox2.Enabled := false;
  Position := TFormPosition.MainFormCenter;
  WorkerNameEdit.SetFocus;
end;

procedure TForm4.UpdateInfoTimerTimer(Sender: TObject);
var
  boolactWorkID: Boolean;
  sPosition: string;

  I: integer;
begin
  try
    if (boolAddpram = true) then
      boolactWorkID := ClientModule.ServerMethods1Client.GetWorkerActive(iactWorkID);
  except
    UpdateInfoTimer.Enabled := false;

  end;
  UpdateInfoTimer.Enabled := false;
  if (boolactWorkID = true) then
  begin
    if (sAdress = '') then
      sAdress := ClientModule.ServerMethods1Client.GetWorkerAddress(iactWorkID);
    Label6.TextSettings.FontColor := TAlphaColorRec.Green;
    Label2.TextSettings.FontColor := TAlphaColorRec.Green;
    Label2.Text := 'Online';
    Label6.Visible := true;
    // sPosition := ClientModule.ServerMethods1Client.GetWorkerPosition(iactWorkID);
    // for I := 0 to ComboBox2.Items.Count - 1 do
    // if ComboBox2.Items[I] = sPosition then
    // ComboBox2.ItemIndex := I;

    // sAdress := ClientModule.ServerMethods1Client.GetWorkerAddress(iactWorkID);
    if (sAdress = '') then
    begin
      ComboBox2.Items[0] := 'No Information';
      ComboBox2.ItemIndex := 0;
      ComboBox2.Enabled := false;
    end
    else
    begin
      if (boolAddpram = true) then
      begin
        // boolAddpram := False;
        ComboBox2.Items[0] := 'Adress';
        // ComboBox2.Items[1] := 'Adress';
        // ComboBox2.ItemIndex := 1;
        // ComboBox2.Enabled := true;

      end;

    end;
    // Memo1.Lines.Clear;
    // Memo1.Lines.Add(sAdress);

    // Edit2.Text :=
    // Memo1.Lines.Clear;
    // Memo1.Lines.Add(ClientModule.ServerMethods1Client.GetRideRequirement(iactWorkID));

    DurationTimer.Enabled := true;

  end
  else
  begin
    Memo1.Lines.Clear;
    Label6.Visible := false;
    Label6.TextSettings.FontColor := TAlphaColorRec.Red;
    Label2.TextSettings.FontColor := TAlphaColorRec.Red;
    Label2.Text := 'Offline';
    ComboBox2.ItemIndex := 0;
    ComboBox2.Items[0] := 'No Information Acess';
    ComboBox2.Enabled := false;
  end;

end;

procedure TForm4.WorkerNameEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
if Key=13 then   Button1Click(nil);

end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  // ClientModule.ServerMethods1Client.MoveRideToArchive(iactWorkID);
  // RideId := -1;
//  DurationTimer.Enabled := false;
//  TimeSec := 0;
//  Label6.Text := '00:00';
//  Memo1.Lines.Clear;
//  Edit2.Text := '';
//  ComboBox2.ItemIndex := -1;
//  ComboBox2.Enabled := false;

{ TODO : Add more action using call methode }
end;

procedure TForm4.ComboBox2Change(Sender: TObject);
begin
  if ((ComboBox2.ItemIndex = 0) and (ComboBox2.Items[0] = 'Adress')) then
  begin
    Memo1.Lines.Clear;
    Memo1.Lines.Add(sAdress);

  end;

end;

procedure TForm4.ComboBox2Click(Sender: TObject);
begin
  if ((ComboBox2.ItemIndex = 0) and (ComboBox2.Items[0] = 'Adress')) then
  begin
    Memo1.Lines.Clear;
    Memo1.Lines.Add(sAdress);

  end;
end;

procedure TForm4.DurationTimerTimer(Sender: TObject);
var
  mins, secs: string;
begin
  inc(TimeSec);

  if TimeSec mod 60 < 10 then
    secs := '0';
  secs := secs + IntToStr(TimeSec mod 60);

  mins := IntToStr(TimeSec div 60);

  Label6.Text := mins + ':' + secs;
end;

end.
