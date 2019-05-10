unit pluginlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, JvSimpleXml,
  Dialogs, Forms, Vcl.Imaging.pngimage;

type
  TPluginHandle = class(TComponent)
  private

  public
    PluginHandle: THandle;
    Form : TForm;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TPluginList = class(TComponent)
  private

  public
    FList: TStringList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddPlugin(PluginName,FileName: string);
    function GetPluginHandle(PluginName: string): THandle;
    function GetPluginForm(PluginName: string): TForm;
    function DeletePluginForm(PluginName: string): TForm;
    procedure SetPluginForm(PluginName: string; Form: TForm);
  end;


implementation


constructor TPluginHandle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Form := nil;
end;

destructor TPluginHandle.Destroy;
begin
  inherited Destroy;
end;

//------------------------------------------------------------------------------

constructor TPluginList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList := TStringList.Create;
end;

destructor TPluginList.Destroy;
var
  i: integer;
begin
  for i := FList.Count - 1 downto 0 do
  begin
    FreeLibrary(TPluginHandle(FList.Objects[i]).PluginHandle);
    TPluginHandle(FList.Objects[i]).Free;
    FList.Delete(i);
  end;
  FList.Free;
  inherited Destroy;
end;

procedure TPluginList.AddPlugin(PluginName,FileName: string);
var
  PluginHandle : TPluginHandle;
begin
  PluginHandle := TPluginHandle.Create(nil);
  PluginHandle.PluginHandle := LoadLibrary(PChar(filename));
  FList.AddObject(PluginName,PluginHandle);
end;

function TPluginList.GetPluginHandle(PluginName: string): THandle;
var
  i: integer;
begin
  for i := 0 to FList.Count -1 do
  begin
    if LowerCase(FList[i]) = LowerCase(PluginName) then
    begin
      Result := TPluginHandle(FList.Objects[i]).PluginHandle;
      break;
    end;
  end;
end;

function TPluginList.GetPluginForm(PluginName: string): TForm;
var
  i: integer;
  girdi: boolean;
  tmp: TForm;
begin
  girdi := false;
  for i := 0 to FList.Count -1 do
  begin
    if LowerCase(FList[i]) = LowerCase(PluginName) then
    begin
      girdi := true;
      tmp := TPluginHandle(FList.Objects[i]).Form;
      break;
    end;
  end;
  if girdi then
    Result := tmp
  else
    Result := nil;
end;

function TPluginList.DeletePluginForm(PluginName: string): TForm;
var
  i: integer;
  F: TForm;
begin
  for i := FList.Count -1 downto 0 do
  begin
    if LowerCase(FList[i]) = LowerCase(PluginName) then
    begin
      TPluginHandle(FList.Objects[i]).Form.Free;
      TPluginHandle(FList.Objects[i]).Form := nil;
   //   FreeLibrary(TPluginHandle(FList.Objects[i]).PluginHandle);
   //   TPluginHandle(FList.Objects[i]).Free;
    //  FList.Delete(i);
    end;
  end;
end;

procedure TPluginList.SetPluginForm(PluginName: string; Form: TForm);
var
  i: integer;
begin
  for i := 0 to FList.Count -1 do
  begin
    if LowerCase(FList[i]) = LowerCase(PluginName) then
    begin
      TPluginHandle(FList.Objects[i]).Form := Form;
      break;
    end;
  end;

end;


end.
