# runtimeform
Delphi Runtime Form

Penggunaan
```
procedure TForm1.Button1Click(Sender: TObject);
var
  VirForm : TVirtualForm;
  FrmName : String;
  I: Integer;
begin
  FrmName := 'nameform';
  if not Assigned(FindComponent(FrmName) as TVirtualForm) then
  begin
    VirForm := TVirtualForm.Create(Self);
    VirForm.Name := FrmName;
  end;
end;
```
