{ ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit XmlFileSettings;

interface

uses Classes, XMLDoc, XMLIntf,
  System.SyncObjs;

type
  TrecScreen = record
    scrWidth: integer;
    scrHeight: integer;
  end;

  TProjectOptions = class
  private
    FProjectName: String;
    FProjectXML: IXMLDocument;
    FUpdateCount: integer;
    RootNode, CurNode: IXMLNode;
    function GetXMLValue(const NodeName: String): String;
    procedure SetXMLValue(const NodeName, NodeValue: String);
    function GetXMLAttributeValue(const NodeName: String): TrecScreen;
    function GetSkinName: String;
    function GetProjectName: String;
    function GetSCREEN: TrecScreen;

    procedure SetSkinName(const Value: String);
    procedure SetSCREEN(const Value: TrecScreen);
    procedure SetXMLAtributesScreen(const NodeName: string; const Value: TrecScreen);
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
    property SkinName: String read GetSkinName write SetSkinName;
    property SCREEN: TrecScreen read GetSCREEN write SetSCREEN;
  end;

const
  _DEFAULT_PROJECT = '_default.prg';

var
  gvProjectSettings: TProjectOptions = nil;

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

procedure TProjectOptions.NewConfig;

begin
  FProjectXML := TXMLDocument.Create(nil);
  FProjectXML.NodeIndentStr := '  ';
  FProjectXML.Options := FProjectXML.Options + [doNodeAutoIndent, doNodeAutoCreate];
  FProjectXML.Active := True;
  FProjectXML.Encoding := 'utf-8';

  RootNode := FProjectXML.AddChild('SETTINGS');

   CurNode := RootNode.AddChild('CURRENT');
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
  if Assigned(FProjectXML) and (ExtractFileName(FProjectName) <> _DEFAULT_PROJECT) then
    try
      FProjectXML.SaveToFile(FProjectName);
    except
      on E: Exception do
        ShowMessageFmt('Save to "%s" fail: %s', [FProjectName, E.Message]);
    end;
end;

function TProjectOptions.GetSkinName: String;
begin
  Result := GetXMLValue('SKIN');
end;

procedure TProjectOptions.SetSkinName(const Value: String);
begin
  SetXMLValue('SKIN', Value);
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


function TProjectOptions.GetSCREEN: TrecScreen;
begin
  Result := GetXMLAttributeValue('SCREEN');
end;


procedure TProjectOptions.SetSCREEN(const Value: TrecScreen);
begin
  SetXMLAtributesScreen('SCREEN', Value);
end;


function TProjectOptions.GetXMLAttributeValue(const NodeName: String): TrecScreen;
var
  tmpSreecn: TrecScreen;
begin
  Result := tmpSreecn;
  if Assigned(CurNode) then
    Result := UtilsFunc.GetXMLAttributeValueScreen(CurNode, NodeName);
end;

function TProjectOptions.GetXMLValue(const NodeName: String): String;
begin
  Result := '';
  if Assigned(CurNode) then
    Result := UtilsFunc.GetXMLValue(CurNode, NodeName);
end;

procedure TProjectOptions.SetXMLValue(const NodeName, NodeValue: String);
begin
  if Assigned(CurNode) then
  begin
    BeginUpdate;
    UtilsFunc.SetXMLValue(CurNode, NodeName, NodeValue);
    EndUpdate;
  end;
end;

procedure TProjectOptions.SetXMLAtributesScreen(const NodeName: string; const Value: TrecScreen);
begin
  if Assigned(CurNode) then
  begin
    BeginUpdate;
    CurNode := CurNode.AddChild(NodeName);
    CurNode.Attributes['Width'] := Value.scrWidth;
    CurNode.Attributes['Height'] := Value.scrHeight;
    EndUpdate;
  end;
end;

initialization

gvProjectSettings := TProjectOptions.Create;

finalization

FreeAndNil(gvProjectSettings);

end.
