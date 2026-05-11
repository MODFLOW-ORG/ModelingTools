unit ModflowMipWriterUnit;

interface

uses
  CustomModflowWriterUnit, ModflowPackageSelectionUnit, Vcl.Forms, DataSetUnit;

type
  TMipWriter = class(TCustomFlowPackageWriter)
  private
    FPrtModel: TPrtModel;
    procedure WriteOptions;
    procedure WriteGridData;
    procedure WritePorosity;
    procedure WriteRetardationFactor;
    procedure WriteIZone;
  protected
    class function Extension: string; override;
  public
    property PrtModel: TPrtModel read FPrtModel write FPrtModel;
    procedure WriteFile(const AFileName: string);
  end;


implementation

uses
  frmErrorsAndWarningsUnit, ModflowUnitNumbers, frmProgressUnit, GoPhastTypes,
  ModflowOptionsUnit, PhastModelUnit,
  System.SysUtils, PestParamRoots, DataSetNamesUnit;

{ TMipWriter }

class function TMipWriter.Extension: string;
begin
  result := '.mip';
end;

procedure TMipWriter.WriteFile(const AFileName: string);
begin
  Assert(PrtModel <> nil);
  if not PrtModel.IsSelected then
  begin
    Exit;
  end;
  frmErrorsAndWarnings.BeginUpdate;
  try
    FNameOfFile := ChangeFileExt(AFileName, '') + '.' + PrtModel.ModelName + Extension;
    FInputFileName := FNameOfFile;
    WriteToNameFile('MIP', -1, FNameOfFile, foInput, Model, False, 'MIP');
    OpenFile(FNameOfFile);
    try
      frmProgressMM.AddMessage('Writing MIP data');
      frmProgressMM.AddMessage(StrWritingDataSet0);
      WriteDataSet0;
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;

      frmProgressMM.AddMessage(StrWritingOptions);
      WriteOptions;
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;

      frmProgressMM.AddMessage(StrWritingGridData);
      WriteGridData;
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;
    finally
      CloseFile;
    end;
  finally
    frmErrorsAndWarnings.EndUpdate;
  end;
end;

procedure TMipWriter.WriteGridData;
begin
  NewLine;
  WriteBeginGridData;
  try
    frmProgressMM.AddMessage('Writing POROSITY');
    WritePorosity;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage('Writing RETFACTOR');
    WriteRetardationFactor;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage('Writing IZONE');
    WriteIZone;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;
  finally
    WriteEndGridData;
  end;
end;

procedure TMipWriter.WriteIZone;
var
  DataArray: TDataArray;
begin
  if FPrtModel.ZoneUsed then
  begin
    frmProgressMM.AddMessage('  Writing IZONE');
    DataArray := Model.DataArrayManager.GetDataSetByName(FPrtModel.ZoneDataArrayName);
    WriteMf6_DataSet(DataArray, 'IZONE');
  end;
end;

procedure TMipWriter.WriteOptions;
begin
  WriteBeginOptions;
  try
    WriteExportAsciiArray;
  finally
    WriteEndOptions;
  end;
end;

procedure TMipWriter.WritePorosity;
var
  DataArray: TDataArray;
begin
  frmProgressMM.AddMessage('  Writing POROSITY');
  DataArray := Model.DataArrayManager.GetDataSetByName(rsPorosity);
  WriteMf6_DataSet(DataArray, 'POROSITY');
end;

procedure TMipWriter.WriteRetardationFactor;
var
  DataArray: TDataArray;
begin
  if FPrtModel.RetardationFactorUsed then
  begin
    frmProgressMM.AddMessage('  Writing RETFACTOR');
    DataArray := Model.DataArrayManager.GetDataSetByName(FPrtModel.RetardationDataArrayName);
    WriteMf6_DataSet(DataArray, 'RETFACTOR');
  end;
end;

end.
