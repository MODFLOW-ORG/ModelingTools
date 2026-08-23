unit ModflowGwfPrtExchangeWriterUnit;

interface

uses
  System.SysUtils, CustomModflowWriterUnit, ModflowPackageSelectionUnit;

type
  TModflowGwfPrtExchangeWriter = class(TCustomPackageWriter)
  protected
    function Package: TModflowPackageSelection; override;
    class function Extension: string; override;
  public
    procedure WriteFile(const AFileName: string; ModelIndex: Integer);
  end;


implementation

{ TModflowGwfPrtExchangeWriter }

class function TModflowGwfPrtExchangeWriter.Extension: string;
begin
  result := '.gwfprt';
end;

function TModflowGwfPrtExchangeWriter.Package: TModflowPackageSelection;
begin
  result := nil;
end;

procedure TModflowGwfPrtExchangeWriter.WriteFile(const AFileName: string;
  ModelIndex: Integer);
var
  ModelName: string;
  PrtExcFile: string;
  Exchange: string;
  PrtModel: TPrtModel;
begin
  PrtModel := Model.ModflowPackages.PrtModels[ModelIndex].PrtModel;
  ModelName := PrtModel.ModelName;
  if not PrtModel.IsSelected then
  begin
    Exit;
  end;
//  else if PrtModel.RunAsSeparateSimulation then
//  begin
//    Exit;
//  end;
  PrtExcFile := ChangeFileExt(AFileName, '.' + ModelName) + Extension;
  FNameOfFile := PrtExcFile;
  if not PrtModel.RunAsSeparateSimulation then
  begin
    Model.AddModelInputFile(PrtExcFile);
  end;
  FInputFileName := PrtExcFile;
  Exchange := Format('GWF6-PRT6 %0:s MODFLOW %1:s', [ExtractFileName(PrtExcFile), ModelName]);
  Model.SimNameWriter.AddExchange(Exchange);
  if PrtModel.RunAsSeparateSimulation then
  begin
    Exit;
  end;
  OpenFile(FNameOfFile);
  try
    WriteCommentLine('GWF6-PRT6 file created by ModelMuse');
  finally
    CloseFile;
  end;

end;

end.
