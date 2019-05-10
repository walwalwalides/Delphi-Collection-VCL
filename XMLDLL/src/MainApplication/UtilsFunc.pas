{ ============================================
  Software Name : 	XMLDLL
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit UtilsFunc;

interface

uses Windows, Classes, SysUtils, StrUtils, XMLDoc, XMLIntf, Graphics,XmlFilesettings;


 function GetXMLAttributeValueScreen(const ParentNode: IXMLNode; const NodeName: String): TrecScreen;
function GetXMLChildNode(const ParentNode: IXMLNode; const NodeName: String; const AutoCreate: LongBool = True): IXMLNode;
function GetXMLValue(const ParentNode: IXMLNode; const NodeName: String): String;
procedure SetXMLValue(const ParentNode: IXMLNode; const NodeName, NodeValue: String);

implementation

procedure SetXMLValue(const ParentNode: IXMLNode; const NodeName, NodeValue: String);
begin
  if Assigned(ParentNode) then
    ParentNode.ChildValues[AnsiLowerCase(NodeName)] := NodeValue;
end;

function GetXMLChildNode(const ParentNode: IXMLNode; const NodeName: String; const AutoCreate: LongBool = True): IXMLNode;
begin
  Result := nil;

  if Assigned(ParentNode) then
  begin
    Result := ParentNode.ChildNodes.FindNode(AnsiLowerCase(NodeName));
    if not Assigned(Result) and AutoCreate then
      Result := ParentNode.AddChild(NodeName);
  end;
end;

function GetXMLValue(const ParentNode: IXMLNode; const NodeName: String): String;
var
  ResNode: IXMLNode;
begin
  Result := '';
  if Assigned(ParentNode) then
  begin
    ResNode := ParentNode.ChildNodes.FindNode(AnsiLowerCase(NodeName));
    if Assigned(ResNode) and ResNode.IsTextElement then
      Result := ResNode.Text;
  end;
end;

function GetXMLAttributeValueScreen(const ParentNode: IXMLNode; const NodeName: String): TrecScreen;
var
  ResNode: IXMLNode;
  valWidth,valHeight:integer;
  str:string;
  tmp:TrecScreen;
begin
  Result :=tmp;

  if Assigned(ParentNode) then
  begin
    ResNode := ParentNode.ChildNodes.FindNode(AnsiUpperCase(NodeName));
    if Assigned(ResNode) and ResNode.IsTextElement then
    begin

      str:= ResNode.Text;
//      ResNode.
      tmp.scrWidth:=valWidth;
      tmp.scrHeight:=valHeight;
      Result := tmp;

    end;
  end;
end;

end.
