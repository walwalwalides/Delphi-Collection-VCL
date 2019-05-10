{ ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit ButtonEventList;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, JvSimpleXml,
  Dialogs, Forms, db, JvMemoryDataset, Configuration, pluginlist;

type

  TButtonEventList = class(TComponent)
  private
    procedure CreateFields;
  public
    Settings: TSettings;
    EventList: TJvMemoryData;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildEventList;
  published

  end;

implementation

uses JclSimpleXml;

constructor TButtonEventList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TButtonEventList.Destroy;
begin
  EventList.Close;
  EventList.Free;
  inherited Destroy;
end;

procedure TButtonEventList.CreateFields;
begin
  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'formname';
    DataType := ftString;
    Size := 30;
    CreateField(EventList);
   end;

  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'pluginname';
    DataType := ftString;
    Size := 30;
    CreateField(EventList);
   end;

  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'libpath';
    DataType := ftString;
    Size := 200;
    CreateField(EventList);
   end;

  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'skinpath';
    DataType := ftString;
    Size := 30;
    CreateField(EventList);
   end;

  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'buttonname';
    DataType := ftString;
    Size := 30;
    CreateField(EventList);
   end;



  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'eventname';
    DataType := ftString;
    Size := 80;
    CreateField(EventList);
   end;

  with EventList.FieldDefs.AddFieldDef do
   begin
    Name := 'callfunction';
    DataType := ftString;
    Size := 80;
    CreateField(EventList);
   end;
end;

procedure TButtonEventList.BuildEventList; // load Dll Data
var
  SimpleXML: TJvSimpleXML;
  ConfigItem,PluginItem,SkinItem,ButtonItem,EventItem,CallfuncItem: TJvSimpleXMLElem;
  path,libPath,pluginName: string;
  SearchRec: TSearchRec;
  Index: integer;
  dirName: string;
begin
  path := ExtractFilePath(ParamStr(0))+'Plugins\';
  if DirectoryExists(path) then
  begin
    EventList := TJvMemoryData.Create(nil);
    CreateFields;
    EventList.Open;
    Index := FindFirst(path+'*.*',faDirectory,SearchRec);
    while Index = 0 do
    begin
      dirName := SearchRec.Name;
      if (dirName <> '') and (dirName <> '.') and (dirName <> '..') then
      begin
        SimpleXML   := TJvSimpleXML.Create(nil);
        SimpleXML.LoadFromFile(path + dirName + '\config.xml');
        ConfigItem    := SimpleXML.Root;
        PluginItem    := ConfigItem.Items.ItemNamed['PLUGIN'];
        SkinItem      := ConfigItem.Items.ItemNamed['SKIN'];
        ButtonItem    := ConfigItem.Items.ItemNamed['BUTTON'];
        EventItem     := ButtonItem.Items.ItemNamed['EVENT'];
        CallfuncItem  := EventItem.Items.ItemNamed['CALLFUNCTION'];
        libPath       := ExtractFilePath(ParamStr(0))+'Plugins\'+dirName+'\'+ PluginItem.Properties.Value('Lib');
        pluginName    := PluginItem.Properties.Value('NAME');
        if FileExists(libPath) then
          Settings.PluginList.AddPlugin(pluginName,libPath);
        EventList.Append;
        EventList.FieldByName('formname').AsString    := ButtonItem.Properties.Value('DRAWFORM');
        EventList.FieldByName('pluginname').AsString  := PluginItem.Properties.Value('NAME');
        EventList.FieldByName('libpath').AsString     := libPath;
        EventList.FieldByName('skinpath').AsString    := SkinItem.Properties.Value('PATH');
        EventList.FieldByName('buttonname').AsString  := ButtonItem.Properties.Value('NAME');
        EventList.FieldByName('eventname').AsString   := EventItem.Properties.Value('NAME');
        EventList.FieldByName('callfunction').AsString := CallfuncItem.Properties.Value('VALUE');
        EventList.Post;
        SimpleXML.Free;
      end;
      Index := FindNext(SearchRec);
    end;
  end;
end;


end.
