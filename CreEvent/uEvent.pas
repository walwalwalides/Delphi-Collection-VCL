{ ============================================
  Software Name : 	CreateEvent
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uEvent;

interface

uses
  SysUtils, Controls, Graphics;

type
  TEvent = class
  private
    FName: string;
    FDate: TDate;
    FTime: TTime;
    FCategorie: TColor;
    FDescription: string;
  public
    constructor Create;

    function Clone: TEvent;

    property Name: string read FName write FName;
    property Date: TDate read FDate write FDate;
    property Time: TTime read FTime write FTime;
    property Categorie: TColor read FCategorie write FCategorie;
    property Description: string read FDescription write FDescription;
  end;

implementation

{ TEvent }

function TEvent.Clone: TEvent;
var
  CloneEvent: TEvent;
begin
  CloneEvent := TEvent.Create;

  CloneEvent.Name := Self.Name;
  CloneEvent.Date := Self.Date;
  CloneEvent.Time := Self.Time;
  CloneEvent.Categorie := Self.Categorie;
  CloneEvent.Description := Self.Description;

  result := CloneEvent;
end;

constructor TEvent.Create;
begin
  FDate := Date;
  FTime := Time;
  FCategorie := clBlack;
end;

end.
