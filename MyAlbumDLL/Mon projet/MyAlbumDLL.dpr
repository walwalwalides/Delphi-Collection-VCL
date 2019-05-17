program MyAlbumDLL;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  uAbout in 'uAbout.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar:=True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout,frmAbout);
  Application.Run;
end.
