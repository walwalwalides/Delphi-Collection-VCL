{ ============================================
  Software Name : 	MyStringGrid
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit uSettingPrint;

interface

uses
  CLasses,Printers, Messages, sysutils, StdCtrls, controls, windows, shellApi,
 ActiveX, ComObj, Variants; //

function GetDefaultPrinter: string;
function ListPrinters:Tstringlist;
function SetDefaultPrinter(const DeviceID: string): boolean;

implementation


 //Compatible with windows 10
function ListPrinters:Tstringlist;
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
begin;
  Result:=Tstringlist.Create;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet := FWMIService.ExecQuery
    ('SELECT DeviceID, Name FROM Win32_Printer', 'WQL', wbemFlagForwardOnly);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    result.add(Format('%s', [{FWbemObject.DeviceID,}
      FWbemObject.Name]));
    FWbemObject := Unassigned;
  end;
end;

function SetDefaultPrinter(const DeviceID: string): boolean;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObject: OLEVariant;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObject := FWMIService.Get(Format('Win32_Printer.DeviceID="%s"',
    [DeviceID]));
  if not VarIsClear(FWbemObject) then
    Result := FWbemObject.SetDefaultPrinter() = 0
  else
    Result := false;
end;

function GetDefaultPrinter: string;
Begin
  if (Printer.Printers.Count > 0) then
  begin
    Printer.PrinterIndex := -1; // select default printer
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
  begin
    Result := '';
    // this computer does not have any printer installed (in Windows)
  end;
End;



end.
