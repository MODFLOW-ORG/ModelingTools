unit ModflowpPrpWriterUnit;

interface

uses
  CustomModflowWriterUnit, ModflowPackageSelectionUnit, Vcl.Forms,
  System.SysUtils, System.Generics.Collections, PhastModelUnit;

type
  TPrtParticle = record
    Layer: Integer;
    Row: Integer;
    Column: Integer;
    X: double;
    Y: double;
    Z: double;
  end;
  TPrtParticleList = TList<TPrtParticle>;

  TPrpWriter = class(TCustomPackageWriter)
  private
    FPrtModel: TPrtModel;
    FPrpPackage: TPrpPackage;
    FParticles: TPrtParticleList;
    procedure WriteOptions;
   protected
    function Package: TModflowPackageSelection; override;
    class function Extension: string; override;
  public
    Constructor Create(AModel: TCustomModel; EvaluationType: TEvaluationType); override;
    destructor Destroy; override;
    procedure Evaluate;
    procedure WriteFile(const AFileName: string);
    property PrtModel: TPrtModel read FPrtModel write FPrtModel;
    property PrpPackage: TPrpPackage read FPrpPackage write FPrpPackage;
  end;

implementation

uses
  ScreenObjectUnit, frmProgressUnit, frmErrorsAndWarningsUnit, GoPhastTypes,
  ModflowPrpUnit, CellLocationUnit, ModpathParticleUnit,
  ModflowIrregularMeshUnit, ModflowGridUnit, FastGEO;

{ TPrpWriter }

constructor TPrpWriter.Create(AModel: TCustomModel;
  EvaluationType: TEvaluationType);
begin
  inherited;
  FParticles := TPrtParticleList.Create;
end;

destructor TPrpWriter.Destroy;
begin
  FParticles.Free;
  inherited;
end;

procedure TPrpWriter.Evaluate;
var
  ScreenObject: TScreenObject;
  PrpBoundary: TPrpBoundary;
  ACell: TCellAssignment;
  CellList : TCellAssignmentList;
  Particles: TParticles;
  AParticle: TParticleLocation;
  DisvGrid: TModflowDisvGrid;
  ModflowGrid: TModflowGrid;
  PrtParticle: TPrtParticle;
  function ProjectParticleLocation(AParticle: TPrtParticle): TPrtParticle;
  var
    APoint2D: TPoint2D;
    LayerTop: double;
    LayerBottom: double;
  begin
    result := AParticle;
    if ModflowGrid <> nil then
    begin
      APoint2D.X := (ModflowGrid.ColumnPositions[AParticle.Column] +
        ModflowGrid.ColumnPositions[AParticle.Column +1])/2 + AParticle.X;
      APoint2D.Y := (ModflowGrid.RowPositions[AParticle.Row] +
        ModflowGrid.RowPositions[AParticle.Row +1])/2 + AParticle.Y;
      APoint2D := ModflowGrid.RotateFromGridCoordinatesToRealWorldCoordinates(APoint2D);
      result.X := APoint2D.X;
      result.Y := APoint2D.Y;
      LayerTop := ModflowGrid.LayerElevations[AParticle.Column, AParticle.Row, AParticle.Layer];
      LayerBottom := ModflowGrid.LayerElevations[AParticle.Column, AParticle.Row, AParticle.Layer+1];
      result.Z := AParticle.Z * (LayerTop-LayerBottom) + LayerBottom;
    end
    else
    begin
      // Finish this.
      Assert(DisvGrid <> nil);
      if DisvGrid.MeshType = mtUnknown then
      begin
        DisvGrid.UpdateMeshType;
      end;
      if DisvGrid.MeshType = mtQuad then
      begin

      end
      else
      begin
        Assert(DisvGrid.MeshType = mtPolygon);
      end;
    end;
  end;
begin
  Assert(PrtModel <> nil);
  if not PrtModel.IsSelected then
  begin
    Exit;
  end;
  Assert(PrpPackage <> nil);
  if not PrpPackage.IsSelected then
  begin
    Exit;
  end;
  if not frmProgressMM.ShouldContinue then
  begin
    Exit;
  end;
  DisvGrid := nil;
  ModflowGrid := nil;
  if Model.DisvUsed then
  begin
    DisvGrid := Model.DisvGrid;
  end
  else
  begin
    ModflowGrid := Model.ModflowGrid;
  end;
  FParticles.Clear;
  for var ScreenObjectIndex := 0 to Model.ScreenObjectCount - 1 do
  begin
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;
    ScreenObject := Model.ScreenObjects[ScreenObjectIndex];
    if ScreenObject.Deleted then
    begin
      Continue;
    end;
    if not ScreenObject.UsedModels.UsesModel(Model) then
    begin
      Continue;
    end;
    PrpBoundary := ScreenObject.ModflowPrpBoundary;
    if PrpBoundary = nil then
    begin
      Continue;
    end;
    if not AnsiSameText(PrpBoundary.PrtModelName, PrtModel.ModelName)
      or not AnsiSameText(PrpBoundary.PrpPackageName, PrpPackage.PackageName) then
    begin
      Continue;
    end;
    CellList:= TCellAssignmentList.Create;
    try
      ScreenObject.GetCellsToAssign('0', nil, nil, CellList, alAll, Model);
      for var CellIndex := 0 to CellList.Count - 1 do
      begin
        ACell := CellList[CellIndex];
        PrtParticle.Layer := ACell.Layer;
        PrtParticle.Row := ACell.Row;
        PrtParticle.Column := ACell.Column;
        Particles := PrpBoundary.ParticleStorage.Particles;
        if Particles = nil then
        begin
          Assert(ScreenObject.Count = ScreenObject.SectionCount);
          // Finish this.
        end
        else
        begin
          for var ParticleIndex := 0 to Particles.Count - 1 do
          begin
            AParticle := Particles.Items[ParticleIndex] as TParticleLocation;
            PrtParticle.X := AParticle.X;
            PrtParticle.Y := AParticle.Y;
            PrtParticle.Z := AParticle.Z;
            // Finish this
          end;
        end;

      end;

    finally
      CellList.Free;
    end;
  end;

end;

class function TPrpWriter.Extension: string;
begin
  result := '.prp';
end;

function TPrpWriter.Package: TModflowPackageSelection;
begin
  result := nil;
  Assert(False);
end;

procedure TPrpWriter.WriteFile(const AFileName: string);
begin
  Assert(PrtModel <> nil);
  if not PrtModel.IsSelected then
  begin
    Exit;
  end;
  Assert(PrpPackage <> nil);
  if not PrpPackage.IsSelected then
  begin
    Exit;
  end;
  Evaluate;
  frmErrorsAndWarnings.BeginUpdate;
  try
    FNameOfFile := ChangeFileExt(AFileName, '') + '.' + PrtModel.ModelName
       + '.' + PrpPackage.PackageName + Extension;
    FInputFileName := FNameOfFile;
    WriteToNameFile('PRP6', -1, FNameOfFile, foInput, Model, False, PrpPackage.PackageName);
    OpenFile(FNameOfFile);
    try
      frmProgressMM.AddMessage('Writing PRP data');
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
    finally
      CloseFile;
    end;
  finally
    frmErrorsAndWarnings.EndUpdate;
  end;
end;

procedure TPrpWriter.WriteOptions;
var
  BaseNameOfFile: string;
  TrackFileOut: string;
  TrackCsvFileOut: string;
  procedure WriteSingleQuoteMF6;
  begin
    WriteString('''');
  end;
begin
  BaseNameOfFile := ChangeFileExt(FNameOfFile, '') + '.' + PrtModel.ModelName
    + '.' + PrpPackage.PackageName;
  WriteBeginOptions;
  try
    WriteString('  BOUNDNAMES');
    NewLine;

    PrintListInputOption;

    if PrpPackage.SolverToleranceUsed then
    begin
      WriteString('  EXIT_SOLVE_TOLERANCE');
      WriteFloat(PrpPackage.SolverTolerance);
      NewLine;
    end;

    if PrpPackage.LocalZ then
    begin
      WriteString('  LOCAL_Z');
      NewLine;
    end;

    if PrpPackage.ExtendTracking then
    begin
      WriteString('  EXTEND_TRACKING');
      NewLine;
    end;

    if PrpPackage.PrtTrackingOutput in [ptoBinary, ptoAll] then
    begin
      TrackFileOut := BaseNameOfFile + '.trk';
      Model.AddModelOutputFile(TrackFileOut);
      WriteString('  TRACK FILEOUT ');
      WriteSingleQuoteMF6;
      WriteString(ExtractFileName(TrackFileOut));
      WriteSingleQuoteMF6;
      NewLine
    end;

    if PrpPackage.PrtTrackingOutput in [ptoCSV, ptoAll] then
    begin
      TrackCsvFileOut := BaseNameOfFile + '.trk.csv';
      Model.AddModelOutputFile(TrackCsvFileOut);
      WriteString('  TRACKCSV FILEOUT ');
      WriteSingleQuoteMF6;
      WriteString(ExtractFileName(TrackCsvFileOut));
      WriteSingleQuoteMF6;
      NewLine
    end;

    if PrpPackage.StopTimeUsed then
    begin
      WriteString('  STOPTIME');
      WriteFloat(PrpPackage.StopTime);
      NewLine;
    end;

    if PrpPackage.StopTravelTimeUsed then
    begin
      WriteString('  STOPTRAVELTIME');
      WriteFloat(PrpPackage.StopTravelTime);
      NewLine;
    end;

    if PrpPackage.StopAtWeakSinks then
    begin
      WriteString('  STOP_AT_WEAK_SINK');
      NewLine;
    end;

    if PrpPackage.StopZone <> 0 then
    begin
      WriteString('  ISTOPZONE');
      WriteInteger(PrpPackage.StopZone);
      NewLine;
    end;

    if PrpPackage.Drape then
    begin
      WriteString('  DRAPE');
      NewLine;
    end;

    case PrpPackage.DryTrackingMethod of
      pdtDrop: WriteString('  DRAPE');
      pdtStop: WriteString('  STOP');
      pdtStay: WriteString('  STAY');
      else Assert(False);
    end;
    NewLine;

    if PrpPackage.ReleaseTimeToleranceUsed then
    begin
      WriteString('  RELEASE_TIME_TOLERANCE');
      WriteFloat(PrpPackage.ReleaseTimeTolerance);
      NewLine;
    end;

    if PrpPackage.ReleaseTimeFrequencyUsed then
    begin
      WriteString('  RELEASE_TIME_FREQUENCY');
      WriteFloat(PrpPackage.ReleaseTimeFrequency);
      NewLine;
    end;

    case PrpPackage.CoordinateCheckMethod of
      ccmEager: WriteString('  EAGER');
      ccmNone: WriteString('  NONE');
    end;
    NewLine;

  finally
    WriteEndOptions;
  end;
end;

end.
