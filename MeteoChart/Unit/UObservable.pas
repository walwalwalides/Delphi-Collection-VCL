{ ============================================
  Software Name : 	MeteoChart
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit UObservable;

interface

uses
  Classes, UInterfaces;

type
  TObservable = class(TInterfacedObject, IObservable)
  private
    FObservers: TInterfaceList;
    FObservable: IObservable;
  public
    constructor Create(Observable: IObservable);
    destructor destroy; override;
    // IObservable
    procedure AddObserver(Obs: IObserver);
    procedure RemoveObserver(Obs: IObserver);
    procedure NotifyObservers;
  end;

implementation

{ TObservable }

constructor TObservable.Create(Observable: IObservable);
begin
  inherited Create;
  FObservers := TInterfaceList.Create;
  FObservable := Observable;
end;

destructor TObservable.destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TObservable.AddObserver(Obs: IObserver);
begin
  if FObservers.IndexOf(Obs) = -1 then
    FObservers.Add(Obs);
end;

procedure TObservable.RemoveObserver(Obs: IObserver);
begin
  if FObservers.IndexOf(Obs) <> -1 then
    FObservers.Remove(Obs);
end;

procedure TObservable.NotifyObservers;
var
  i: integer;
begin
  for i := 0 to FObservers.Count - 1 do     //Parcour All The List Of Interface
    IObserver(FObservers[i]).UpdateObserver(FObservable);
end;

end.

