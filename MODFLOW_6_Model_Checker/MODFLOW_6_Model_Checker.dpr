program MODFLOW_6_Model_Checker;

uses
  Vcl.Forms,
  frmModflow6CheckerUnit in 'frmModflow6CheckerUnit.pas' {frmModflow6Checker};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmModflow6Checker, frmModflow6Checker);
  Application.Run;
end.
