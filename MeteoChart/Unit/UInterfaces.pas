{ ============================================
  Software Name : 	MeteoChart
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit UInterfaces;

interface

type

  IObservable = interface;

  IObserver = interface
    ['{1CCCAD36-4A8C-46D9-8964-0C538CEFAAED}']
    procedure UpdateObserver(Observable: IObservable);
  end;

  IObservable = interface // relite to meteo Class
    ['{825F8B6C-EDCF-48AB-872F-3C3456E8F1C8}']
    procedure AddObserver(Obs: IObserver);
    procedure RemoveObserver(Obs: IObserver);
    procedure NotifyObservers;
  end;

  IMeteo = interface
    ['{77D2F2CF-9EF8-4CF9-A7D0-62CCD6146849}']
    function GetTemp: integer;
    function GetHumidity: integer;
    function GetPressure: integer;
    function GetTimerInterval: integer;
    procedure SetTimerInterval(const Value: integer);

    property Temp: integer read GetTemp;
    property Humidity: integer read GetHumidity;
    property Pressure: integer read GetPressure;
    property TimerInterval: integer read GetTimerInterval write SetTimerInterval;
  end;

implementation

end.
