unit MainSkinRect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Graphics, JvSimpleXml,
  Dialogs, Forms, Configuration, Vcl.Imaging.pngimage, ButtonEventList, Skins, pluginlist;

type
  TDLLFunc = function (): TForm;

  TClickEvent = procedure (Sender: TObject; FormName,Event: string) of object;
  TPos = class(TObject)
    X,Y,W,H: integer;
  end;

  TClickResult = packed record
    FormName, Text: string;
  end;

  TMainSkinsRect = class(TComponent)
  private
    FClickEvent: TClickEvent;
    FList: TStringList;
    procedure SetSettings(val: TSettings);
    procedure PluginLoadAndShow(PluginName: string; proc: Ansistring);

  public
    FormWidth, FormHeight: integer;
    FSettings: TSettings;
    Skin : TSkins;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
        procedure ButtonClick(FormName,Text: string);
  published
    property OnClickEvent: TClickEvent read FClickEvent write FClickEvent;
    property Settings: TSettings read FSettings write SetSettings;
  end;

implementation

constructor TMainSkinsRect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList := TStringList.Create;
end;

destructor TMainSkinsRect.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function GetClickResult(str: string): TClickResult;
var
  tmp: string;
begin
  tmp := str;
  Result.FormName := copy(tmp,1,Pos('=',tmp)-1);
  Result.Text     := copy(tmp,Pos('=',tmp)+1,length(tmp));
end;

procedure TMainSkinsRect.SetSettings(val: TSettings);
begin
  FSettings := val;
end;



procedure TMainSkinsRect.ButtonClick(FormName,Text: string);//
var
  PluginName,eventName,callFunction,caption: string;
begin
  Skin.ButtonEventList.EventList.First;
  while not Skin.ButtonEventList.EventList.Eof do
  begin

    if (Skin.ButtonEventList.EventList.FieldByName('formname').AsString = FormName) and
          (Skin.ButtonEventList.EventList.FieldByName('buttonname').AsString = Text) then
    begin
      PluginName  := Skin.ButtonEventList.EventList.FieldByName('pluginname').AsString;
      eventName := Skin.ButtonEventList.EventList.FieldByName('eventname').AsString;
      callFunction := Skin.ButtonEventList.EventList.FieldByName('callfunction').AsString;
      break;
    end;
    Skin.ButtonEventList.EventList.Next;
  end;
  if PluginName <> '' then
  begin
    PluginLoadAndShow(PluginName,callFunction);
  end else begin

  end;
  if Assigned(FClickEvent) then FClickEvent(Self,FormName,Text);
end;

procedure TMainSkinsRect.PluginLoadAndShow(PluginName: string; proc: Ansistring);
const
   DLLFunc: TDLLFunc = nil;
var
  DLLHandle: THandle;
  Form,tmpForm: TForm;
  i: integer;
begin
  Form := FSettings.PluginList.GetPluginForm(PluginName);
  if Form = nil then
  begin
    if UpperCase(PluginName) = 'HOME' then
    begin
      tmpForm := FSettings.PluginList.GetPluginForm('HOME');
      if tmpForm <> nil then
      begin
        tmpForm := nil;
        FSettings.PluginList.DeletePluginForm('HOME');
      end;


    end;

    DLLHandle := FSettings.PluginList.GetPluginHandle(PluginName);
    try
     @DLLFunc := GetProcAddress(DLLHandle,Pansichar(proc));
     Form     := DLLFunc;
     FSettings.PluginList.SetPluginForm(PluginName, Form);
     Form.Show;                    //Call Home DLL

    finally

    end;
  end else Form.Show;

end;

end.
