{ ============================================
  Software Name : 	CreateEvent
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit Main;

interface

uses
  System.UITypes, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Contnrs, ExtCtrls, uEvent;

type
  TfrmMain = class(TForm)
    ListBox: TListBox;
    BitBtnNew: TBitBtn;
    BitBtnDuplicate: TBitBtn;
    Panel: TPanel;
    lblNameEvent: TLabel;
    edtName: TEdit;
    lblDate: TLabel;
    DateTimePickerDate: TDateTimePicker;
    lblTime: TLabel;
    DateTimePickerTime: TDateTimePicker;
    lblCategorie: TLabel;
    ColorBoxCategorie: TColorBox;
    lblDescription: TLabel;
    MemDescription: TMemo;
    BitBtnSave: TBitBtn;
    procedure edtNameExit(Sender: TObject);
    procedure DateTimePickerDateExit(Sender: TObject);
    procedure BitBtnDuplicateClick(Sender: TObject);
    procedure BitBtnNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure DateTimePickerTimeExit(Sender: TObject);
    procedure ColorBoxCategorieExit(Sender: TObject);
    procedure MemDescriptionExit(Sender: TObject);
    procedure BitBtnSaveClick(Sender: TObject);
  private
    ListEvent: TObjectList;

    EventSelection: TEvent;

    procedure AddNewItemListBox;
    procedure DisplayEvent;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.edtNameExit(Sender: TObject);
begin
  EventSelection.Name := Trim(edtName.Text);
end;

procedure TfrmMain.DateTimePickerDateExit(Sender: TObject);
begin
  EventSelection.Date := DateTimePickerDate.Date;
end;

procedure TfrmMain.BitBtnDuplicateClick(Sender: TObject);
var
  EventClone: TEvent;
begin
  if ListBox.Count = 0 then
  begin
    MessageDlg('No Event Found.', mtInformation, [mbOK], 0);
    BitBtnNew.SetFocus;
    Exit;
  end;
  EventClone := EventSelection.Clone;
  ListEvent.Add(EventClone);
  AddNewItemListBox;
  DisplayEvent;
  edtName.SetFocus;
end;

procedure TfrmMain.BitBtnNewClick(Sender: TObject);
var
  NewEvent: TEvent;
begin
  Panel.Visible := True;
  NewEvent := TEvent.Create;
  ListEvent.Add(NewEvent); //add Event to EventList
  AddNewItemListBox;
  DisplayEvent;
  edtName.SetFocus;
end;

procedure TfrmMain.BitBtnSaveClick(Sender: TObject);
begin
  //

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ListEvent := TObjectList.Create;
end;

procedure TfrmMain.ListBoxClick(Sender: TObject);
begin
  DisplayEvent;
end;

procedure TfrmMain.DateTimePickerTimeExit(Sender: TObject);
begin
  EventSelection.Time := DateTimePickerTime.Time;
end;

procedure TfrmMain.ColorBoxCategorieExit(Sender: TObject);
begin
  EventSelection.Categorie := ColorBoxCategorie.Selected;
end;

procedure TfrmMain.MemDescriptionExit(Sender: TObject);
begin
  EventSelection.Description := MemDescription.Text;
end;

procedure TfrmMain.AddNewItemListBox;
begin
  ListBox.Items.Add('Event #' + IntToStr(ListBox.Items.Count + 1));
  ListBox.ItemIndex := ListBox.Items.Count - 1;
end;

procedure TfrmMain.DisplayEvent;
begin
  EventSelection := ListEvent[ListBox.ItemIndex] as TEvent;
  edtName.Text := EventSelection.Name;
  DateTimePickerDate.Date := EventSelection.Date;
  DateTimePickerTime.Time := EventSelection.Time;
  ColorBoxCategorie.Selected := EventSelection.Categorie;
  MemDescription.Text := EventSelection.Description;
end;

end.
