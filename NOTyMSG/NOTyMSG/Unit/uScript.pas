{ ============================================
  Software Name : 	NOTyMSG
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2019                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uScript;

interface

uses
  Winapi.Windows, system.Types, system.sysutils, system.classes, registry, ShellApi;

procedure CrHTMLscript(AFilevbs, AFunc: string);



implementation

procedure CrHTMLscript(AFilevbs, AFunc: string);
var
  HtmlScript: Tstringlist;
begin
  HtmlScript := Tstringlist.Create;
  try
    HtmlScript.ADD('<!DOCTYPE html>');
    HtmlScript.ADD('<html lang="en">');
    HtmlScript.ADD('<head>');
    HtmlScript.ADD('<meta charset="utf-8">');
    HtmlScript.ADD('<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />');
    HtmlScript.ADD('<title></title>');
    HtmlScript.ADD('<style type="text/css">');
    // CSS Script to describes how HTML elements are to be displayed on screen
    HtmlScript.ADD('*{cursor:default;}');
    HtmlScript.ADD('html,body{margin:0px; padding:0px;}');
    HtmlScript.ADD('body{font-family: Segoe UI; font-weight:lighter; color:#666666;}');//text color
    HtmlScript.ADD('#clear{clear:both; float:none; height:0;}');
    HtmlScript.ADD('#header{color:#878787; margin:0 18px 10px 18px;}');
    HtmlScript.ADD('#header #title{float:left; font-size:20px; font-weight:500;}');
    HtmlScript.ADD('#clear_btn{float:right; margin-top:1px;}');
    HtmlScript.ADD('a{text-decoration:none; font-size:12px; cursor:pointer; font-weight:500; padding:10px;}');
    HtmlScript.ADD('a:hover{color:#3a66cc;}');
    HtmlScript.ADD('#items{overflow:auto; height:250px; color:#545454;}');
    HtmlScript.ADD('#item{margin:18px 22px 0 18px; height:45px; overflow:hidden;}');
    HtmlScript.ADD('#item:first-child{margin:0 22px 0 18px;}');
    HtmlScript.ADD('#item:hover{background-color:#3c3c3c;}'); //item background
    HtmlScript.ADD('#icon{position:relative; float:left; width:45px; height:45px;}');
    HtmlScript.ADD('#icon img{position:absolute; top:0; bottom:0; left:0; right:0; margin:auto; max-width:45px; max-height:45px;}');
    HtmlScript.ADD('#context{float:left;}');
    HtmlScript.ADD
      ('#item #title{float:left; font-size:14px; padding:0 5px 2px 5px; font-weight:600; width:208px; overflow:hidden; height:22px; text-overflow:ellipsis;}');
    HtmlScript.ADD
      ('#description{float:left; font-size:12px; padding:0 5px; font-weight:400; width:208px; overflow:hidden; height:18px; text-overflow:ellipsis;}');
    HtmlScript.ADD('#time{position:relative; top:0; float:right; padding:6px 4px 0 0; font-weight:500; font-size:13px; text-align:right;}');
    HtmlScript.ADD('</style>');
    HtmlScript.ADD('</head>');
    HtmlScript.ADD('<body oncontextmenu="return false" onselectstart="return false">');
    HtmlScript.ADD('<div id="header">');
    HtmlScript.ADD('<div id="title"></div>');
    HtmlScript.ADD('<div id="clear_btn">');
    HtmlScript.ADD('<a onclick="document.location='+ QuotedStr('#rm') +'; "></a>');    //on delete event
    HtmlScript.ADD('</div>');
    HtmlScript.ADD('</div>');
    HtmlScript.ADD('<div id="clear"></div>');
    HtmlScript.ADD('<div style="height:20px;"></div>');
    HtmlScript.ADD('<div id="items">');
    HtmlScript.ADD('<!--<div id="item"><div id="icon" style="background-color:gray; "><img src="test.png" /></div><div id="context"><div id="title"></div><div id="clear"></div><div id="description"></div></div><div id="time">18:00</div></div>-->');
    HtmlScript.ADD('</div>');
    HtmlScript.ADD('</body>');
    HtmlScript.ADD('</html>');

    HtmlScript.SaveToFile(AFilevbs);
  finally
    HtmlScript.Free;
  end;

end;

end.
