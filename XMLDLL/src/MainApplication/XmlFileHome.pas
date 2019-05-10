{ ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit XmlFileHome;

interface

uses Classes, XMLDoc, XMLIntf,
  System.SyncObjs;

type
  TrecPlugin = record
    PluName: string;
    PluLib: string;
  end;

  TrecButton = record
    ButName: string;
    ButDRAWFORM: string;
  end;

  TProjectOptions = class
  private
    FProjectName: String;
    FProjectXML: IXMLDocument;
    FUpdateCount: integer;
    RootNode, CurNodeSkin, CurNodeBtn, CurNodePlug, CurNodeBtnEvt, CurNodeBtnEvtfunc: IXMLNode;
    function GetXMLValue(const NodeName: String): String;
    procedure SetXMLValue(const NodeName, NodeValue: String);
    function GetProjectName: String;
    function GetPLUGIN: TrecPlugin;
    function GetButton: TrecButton;
    procedure SetPLUGIN(const Value: TrecPlugin);
    procedure SetXMLAtributesPlugin(const NodeName: string; const Value: TrecPlugin);
    procedure SetXMLAtributesButton(const NodeName: string; const Value: TrecButton);
    procedure SetButton(const Value: TrecButton);
    function GetXMLAttVal_Button(const NodeName: String): TrecButton;
    function GetXMLAttVal_Plugin(const NodeName: String): TrecPlugin;
    function GetButtonEvt: string;
    procedure SetButtonEvt(const Value: string);
    procedure SetXMLAtributesEvtButton(const NodeName, Value: string);
    function GetButtonEvtValue: string;
    procedure SetButtonEvtValue(const Value: string);
    procedure SetXMLAtributesEvtButtonFunc(const NodeName, Value: string);
    procedure SetXMLAtributesSkin(const NodeName, Value: string);
    function GetSKIN: string;
    procedure SetSKIN(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure Open(const AProjectName: String);
    procedure NewConfig;
    procedure Save;

    class function GetDefProjectSource(const ProjectName: String): String; static;
    class function GetDefDelphiSource: String; static;

    property ProjectName: String read GetProjectName;
    property PLUGIN: TrecPlugin read GetPLUGIN write SetPLUGIN;
    property SKIN: string read GetSKIN write SetSKIN;
    property Button: TrecButton read GetButton write SetButton;
    property ButtonEvt: string read GetButtonEvt write SetButtonEvt;
    property ButtonEvtValue: string read GetButtonEvtValue write SetButtonEvtValue;
  end;

var
  gvProjectHome: TProjectOptions = nil;

implementation

uses SysUtils, JclIDEUtils, System.IOUtils, System.Types, Vcl.Dialogs, UtilsFunc;

{ TProjectOptions }

// <?xml version="1.0"?>
// <SETTINGS>
// <CURRENT>
// <SKIN>MainSkin</SKIN>
// <SCREEN WIDTH="1920" HEIGHT="1080" />
// </CURRENT>
// </SETTINGS>
procedure TProjectOptions.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TProjectOptions.Clear;
begin
  FProjectName := '';
  FProjectXML := nil;
  FUpdateCount := 0;
end;

constructor TProjectOptions.Create;
begin
  inherited Create;

  FProjectXML := nil;
  FUpdateCount := 0;
end;

destructor TProjectOptions.Destroy;
begin

  inherited;
end;

procedure TProjectOptions.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
    Save;
end;

function TProjectOptions.GetProjectName: String;
begin
  Result := FProjectName;
end;

// <?xml version="1.0"?>
// <CONFIG>
// <PLUGIN NAME="HOME" Lib="HOME.dll" />
// <SKIN PATH="Skin" />
// <BUTTON NAME="HOME" DRAWFORM="MainForm">
// <EVENT NAME="ONCLICK">
// <CALLFUNCTION VALUE="ShowNavigationForm" />
// </EVENT>
// </BUTTON>
// </CONFIG>

procedure TProjectOptions.NewConfig;

begin
  FProjectXML := TXMLDocument.Create(nil);
  FProjectXML.NodeIndentStr := '  ';
  FProjectXML.Options := FProjectXML.Options + [doNodeAutoIndent, doNodeAutoCreate];
  FProjectXML.Active := True;
  FProjectXML.Encoding := 'utf-8';

  RootNode := FProjectXML.AddChild('CONFIG');

  // RootNode := RootNode.AddChild('CURRENT');
  // DocNode.Attributes['version'] := '1.0';
end;

procedure TProjectOptions.Open(const AProjectName: String);
begin
  if AProjectName <> FProjectName then
    Clear;

  FProjectName := AProjectName;
  if FileExists(FProjectName) then
    FProjectXML := TXMLDocument.Create(FProjectName)
  else
    NewConfig;
end;

procedure TProjectOptions.Save;
begin
  if Assigned(FProjectXML) then
    try
      FProjectXML.SaveToFile(FProjectName);
    except
      on E: Exception do
        ShowMessageFmt('Save to "%s" fail: %s', [FProjectName, E.Message]);
    end;
end;

function TProjectOptions.GetSKIN: string;
begin
  Result := GetXMLValue('SKIN');
end;



procedure TProjectOptions.SetSKIN(const Value: string);
begin
  SetXMLAtributesSkin('SKIN', Value);
end;


function TProjectOptions.GetButton: TrecButton;
begin
  Result := GetXMLAttVal_Button('Buuton');
end;

function TProjectOptions.GetButtonEvt: string;
begin
 Result := GetXMLValue('EVENT');
end;

function TProjectOptions.GetButtonEvtValue: string;
begin
  Result := GetXMLValue('CALLFUNCTION');
end;

class function TProjectOptions.GetDefDelphiSource: String;
var
  Installations: TJclBorRADToolInstallations;
  DelphiRoot: String;
begin
  Result := '';

  Installations := TJclBorRADToolInstallations.Create;
  try
    if Installations.Count > 0 then
    begin
      DelphiRoot := Installations.Installations[Installations.Count - 1].RootDir;
      Result := IncludeTrailingPathDelimiter(DelphiRoot) + 'source';
    end;
  finally
    FreeAndNil(Installations);
  end;
end;

class function TProjectOptions.GetDefProjectSource(const ProjectName: String): String;
var
  DprName: String;
  DprPathName: String;
  Find: TStringDynArray;
begin
  Result := '';

  if ProjectName <> '' then
  begin
    DprName := ExtractFileName(ProjectName);
    DprName := ChangeFileExt(DprName, '.dpr');

    Result := ExtractFileDir(ProjectName);

    while (Result <> '') and TDirectory.Exists(Result) do
    begin
      DprPathName := Result + PathDelim + DprName;
      if TFile.Exists(DprPathName) then
        Break;

      Find := TDirectory.GetFiles(Result, '*.dpr');
      if Length(Find) > 0 then
        Break;

      Result := ExtractFileDir(Result);

      if Result = IncludeTrailingPathDelimiter(ExtractFileDrive(Result)) then
      begin
        Result := '';
        Break;
      end;
    end;

    if Result <> '' then
    begin
      // TODO: Source dirs from DPR
    end;
  end;
end;

function TProjectOptions.GetPLUGIN: TrecPlugin;
begin
  Result := GetXMLAttVal_Plugin('PLUGIN');
end;

procedure TProjectOptions.SetButton(const Value: TrecButton);
begin
  SetXMLAtributesButton('BUTTON', Value);
end;

procedure TProjectOptions.SetButtonEvt(const Value: string);
begin
  SetXMLAtributesEvtButton('EVENT', Value);
end;

procedure TProjectOptions.SetButtonEvtValue(const Value: string);
begin
  SetXMLAtributesEvtButtonFunc('CALLFUNCTION', Value);
end;

procedure TProjectOptions.SetPLUGIN(const Value: TrecPlugin);
begin
  SetXMLAtributesPlugin('PLUGIN', Value);
end;

function TProjectOptions.GetXMLAttVal_Button(const NodeName: String): TrecButton;
var
  tmpButton: TrecButton;
begin
  Result := tmpButton;
  // if Assigned(RootNode) then
  // Result := UtilsFunc.GetXMLAttributeValueScreen(RootNode, NodeName);
end;

function TProjectOptions.GetXMLAttVal_Plugin(const NodeName: String): TrecPlugin;
var
  tmpPlugin: TrecPlugin;
begin
  Result := tmpPlugin;
  // if Assigned(RootNode) then
  // Result := UtilsFunc.GetXMLAttributeValueScreen(RootNode, NodeName);
end;

function TProjectOptions.GetXMLValue(const NodeName: String): String;
begin
  Result := '';
  if Assigned(RootNode) then
    Result := UtilsFunc.GetXMLValue(RootNode, NodeName);
end;

procedure TProjectOptions.SetXMLValue(const NodeName, NodeValue: String);
begin
  if Assigned(RootNode) then
  begin
    BeginUpdate;
    UtilsFunc.SetXMLValue(RootNode, NodeName, NodeValue);
    EndUpdate;
  end;
end;

procedure TProjectOptions.SetXMLAtributesButton(const NodeName: string; const Value: TrecButton);
begin
  if Assigned(RootNode) then
  begin
    BeginUpdate;
    CurNodeBtn := RootNode.AddChild(NodeName);
    CurNodeBtn.Attributes['NAME'] := Value.ButName;
    CurNodeBtn.Attributes['DRAWFORM'] := Value.ButDRAWFORM;
    EndUpdate;
  end;
end;

procedure TProjectOptions.SetXMLAtributesEvtButtonFunc(const NodeName: string; const Value: string);
begin
  if Assigned(CurNodeBtnEvt) then
  begin
    BeginUpdate;
    CurNodeBtnEvtfunc := CurNodeBtnEvt.AddChild(NodeName);
    CurNodeBtnEvtfunc.Attributes['VALUE'] := Value;
    EndUpdate;
  end;
end;

procedure TProjectOptions.SetXMLAtributesEvtButton(const NodeName: string; const Value: string);
begin
  if Assigned(CurNodeBtn) then
  begin
    BeginUpdate;
    CurNodeBtnEvt := CurNodeBtn.AddChild(NodeName);
    CurNodeBtnEvt.Attributes['NAME'] := Value;
    EndUpdate;
  end;
end;

procedure TProjectOptions.SetXMLAtributesPlugin(const NodeName: string; const Value: TrecPlugin);
begin
  if Assigned(RootNode) then
  begin
    BeginUpdate;
    CurNodePlug := RootNode.AddChild(NodeName);
    CurNodePlug.Attributes['Name'] := Value.PluName;
    CurNodePlug.Attributes['Lib'] := Value.PluLib;
    EndUpdate;
  end;
end;

procedure TProjectOptions.SetXMLAtributesSkin(const NodeName: string; const Value: string);
begin
  if Assigned(RootNode) then
  begin
    BeginUpdate;
    CurNodeSkin := RootNode.AddChild(NodeName);
    CurNodeSkin.Attributes['PATH'] := Value;
    EndUpdate;
  end;
end;

initialization

gvProjectHome := TProjectOptions.Create;

finalization

FreeAndNil(gvProjectHome);

end.
