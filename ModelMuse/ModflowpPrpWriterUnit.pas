unit ModflowpPrpWriterUnit;

interface

uses
  CustomModflowWriterUnit, ModflowPackageSelectionUnit, Vcl.Forms,
  System.SysUtils, System.Generics.Collections, PhastModelUnit, System.Classes;

type
  TPrtParticle = record
    Layer: Integer;
    Row: Integer;
    Column: Integer;
    X: double;
    Y: double;
    Z: double;
    ScreenObjectName: string;
  end;
  TPrtParticleList = TList<TPrtParticle>;

  TPrpWriter = class(TCustomPackageWriter)
  private
    FPrtModel: TPrtModel;
    FPrpPackage: TPrpPackage;
    FParticles: TPrtParticleList;
    procedure WriteOptions;
    procedure WriteDimensions;
    procedure WritePackageData;
    procedure WriteReleaseTimes;
    procedure WriteStressPeriods;
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
  ModflowIrregularMeshUnit, ModflowGridUnit, FastGEO, MeshRenumberingTypes,
  System.Math, ModflowTimeUnit;

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
  APoint2D: TPoint2D;
  LayerTop: double;
  LayerBottom: double;
  DisvCell: TModflowDisVCell;
  function ProjectParticleLocation(AParticle: TPrtParticle): TPrtParticle;
  var
    APoint2D: TPoint2D;
    LayerTop: double;
    LayerBottom: double;
    ACellI: IElement2D;
    Node1: TPoint2D;
    Node2: TPoint2D;
    Node3: TPoint2D;
    DeltaX: double;
    DeltaY: double;
    Angle1: double;
    Angle2: double;
    DisvCell: TModflowDisVCell;
    IntersectSegment: TSegment2D;
    ACell2D: TModflowIrregularCell2D;
    AnEdge: TSegment2D;
    BadAngle: Boolean;
    VAngle: double;
  begin
  // This assumes that Particle.x, Particle.y, and Paricle.z vary from 0 to 1.
    result := AParticle;
    if ModflowGrid <> nil then
    begin
      DeltaX := ModflowGrid.ColumnPositions[AParticle.Column +1] -
        ModflowGrid.ColumnPositions[AParticle.Column];
      DeltaY := ModflowGrid.RowPositions[AParticle.Row] -
        ModflowGrid.RowPositions[AParticle.Row +1];
      APoint2D.X := ModflowGrid.ColumnPositions[AParticle.Column] + DeltaX*AParticle.X;
      APoint2D.Y := ModflowGrid.RowPositions[AParticle.Row] - DeltaY*AParticle.Y;
      APoint2D := ModflowGrid.RotateFromGridCoordinatesToRealWorldCoordinates(APoint2D);
      result.X := APoint2D.X;
      result.Y := APoint2D.Y;
      if not PrpPackage.LocalZ then
      begin
        LayerTop := ModflowGrid.LayerElevations[AParticle.Column, AParticle.Row, AParticle.Layer];
        LayerBottom := ModflowGrid.LayerElevations[AParticle.Column, AParticle.Row, AParticle.Layer+1];
        result.Z := AParticle.Z * (LayerTop-LayerBottom) + LayerBottom;
      end;
    end
    else
    begin
      Assert(DisvGrid <> nil);
      if DisvGrid.MeshType = mtUnknown then
      begin
        DisvGrid.UpdateMeshType;
      end;
      if DisvGrid.MeshType = mtQuad then
      begin
        ACellI := DisvGrid.TwoDGrid.Cells[AParticle.Column];
        APoint2D := ACellI.Center;
        Node1 := ACellI.Nodes[0].Location;
        Node2 := ACellI.Nodes[1].Location;
        Node3 := ACellI.Nodes[2].Location;
        Angle1 := ArcTan2(Node2.y - Node1.y, Node2.x - Node1.x) * 180/Pi;
        if Angle1 < 0 then
        begin
          Angle1 := Angle1  + 360;
        end;
        Angle2 := ArcTan2(Node3.y - Node2.y, Node3.x - Node2.x) * 180/Pi;
        if Angle2 < 0 then
        begin
          Angle2 := Angle2  + 360;
        end;
        DeltaX := Distance(Node1, Node2) * (AParticle.X-0.5);
        DeltaY := Distance(Node2, Node3) * (AParticle.Y-0.5);
        APoint2D := ProjectPoint(APoint2D, Angle1, DeltaX);
        APoint2D := ProjectPoint(APoint2D, Angle2, DeltaY);
        ACell2D := DisvGrid.TwoDGrid.Cells[AParticle.Column];
        if not ACell2D.RobustPointInside(APoint2D) then
        begin
          IntersectSegment[1] := ACellI.Center;
          IntersectSegment[2] := APoint2D;
          if not ACell2D.IntersectionPoint(IntersectSegment, APoint2D) then
          begin
            BadAngle := True;
            for var EdgeIndex := 0 to ACell2D.NodeCount - 1 do
            begin
              AnEdge := ACell2D.Edges[EdgeIndex];
              VAngle := VertexAngle(AnEdge[1], APoint2D, AnEdge[1]);
              if (VAngle > 179) and (VAngle < 181) then
              begin
                BadAngle := False;
                break;
              end;
            end;
            Assert(not BadAngle);
          end;
        end;

        result.X := APoint2D.X;
        result.Y := APoint2D.Y;
        if not PrpPackage.LocalZ then
        begin
          DisvCell := DisvGrid.Cells[AParticle.Layer, AParticle.Column];
          LayerTop := DisvCell.Top;
          LayerBottom := DisvCell.Bottom;
          result.Z := AParticle.Z * (LayerTop-LayerBottom) + LayerBottom;
        end;
      end
      else
      begin
        Assert(DisvGrid.MeshType = mtPolygon);
        ACellI := DisvGrid.TwoDGrid.Cells[AParticle.Column];
        APoint2D := ACellI.Center;
        DeltaX := (ACellI.MaxX - ACellI.MinX) * (AParticle.X-0.5);;
        DeltaY := (ACellI.MaxY - ACellI.MinY) * (AParticle.Y-0.5);

        APoint2D.X := APoint2D.X + DeltaX;
        APoint2D.Y := APoint2D.Y + DeltaY;

        ACell2D := DisvGrid.TwoDGrid.Cells[AParticle.Column];
        if not ACell2D.RobustPointInside(APoint2D) then
        begin
          IntersectSegment[1] := ACellI.Center;
          IntersectSegment[2] := APoint2D;
          if not ACell2D.IntersectionPoint(IntersectSegment, APoint2D) then
          begin
            BadAngle := True;
            for var EdgeIndex := 0 to ACell2D.NodeCount - 1 do
            begin
              AnEdge := ACell2D.Edges[EdgeIndex];
              VAngle := VertexAngle(AnEdge[1], APoint2D, AnEdge[1]);
              if (VAngle > 179) and (VAngle < 181) then
              begin
                BadAngle := False;
                break;
              end;
            end;
            Assert(not BadAngle);
          end;
        end;

        result.X := APoint2D.X;
        result.Y := APoint2D.Y;
        if not PrpPackage.LocalZ then
        begin
          DisvCell := DisvGrid.Cells[AParticle.Layer, AParticle.Column];
          LayerTop := DisvCell.Top;
          LayerBottom := DisvCell.Bottom;
          result.Z := AParticle.Z * (LayerTop-LayerBottom) + LayerBottom;
        end;
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
        PrtParticle.ScreenObjectName := ScreenObject.Name;
        Particles := PrpBoundary.ParticleStorage.Particles;
        if Particles = nil then
        begin
          Assert(ScreenObject.Count = ScreenObject.SectionCount);

          APoint2D := ScreenObject.Points[ACell.Section];
          if ModflowGrid <> nil then
          begin
            APoint2D := ModflowGrid.RotateFromRealWorldCoordinatesToGridCoordinates(APoint2D);
            PrtParticle.X := APoint2D.X;
            PrtParticle.Y := APoint2D.Y;
          end;

          PrtParticle.Z := ScreenObject.Higher3DElevations[Model][ACell.Layer, ACell.Row, ACell.Column];
          if PrpPackage.LocalZ then
          begin
            if ModflowGrid <> nil then
            begin
              LayerTop := ModflowGrid.LayerElevations[PrtParticle.Column, PrtParticle.Row, PrtParticle.Layer];
              LayerBottom := ModflowGrid.LayerElevations[PrtParticle.Column, PrtParticle.Row, PrtParticle.Layer+1];
            end
            else
            begin
              Assert(DisvGrid <> nil);
              DisvCell := DisvGrid.Cells[PrtParticle.Layer, PrtParticle.Column];
              LayerTop := DisvCell.Top;
              LayerBottom := DisvCell.Bottom;
            end;
            if LayerTop = LayerBottom then
            begin
              PrtParticle.Z := 0.5
            end
            else
            begin
              PrtParticle.Z := (PrtParticle.Z - LayerBottom)/(LayerTop - LayerBottom);
            end;
          end;
          FParticles.Add(PrtParticle);
        end
        else
        begin
          for var ParticleIndex := 0 to Particles.Count - 1 do
          begin
            AParticle := Particles.Items[ParticleIndex] as TParticleLocation;
            PrtParticle.X := AParticle.X;
            PrtParticle.Y := AParticle.Y;
            PrtParticle.Z := AParticle.Z;
            PrtParticle := ProjectParticleLocation(PrtParticle);
            FParticles.Add(PrtParticle);
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

procedure TPrpWriter.WriteDimensions;
begin
  WriteBeginDimensions;
  try
    WriteString('  NRELEASEPTS');
    WriteInteger(FParticles.Count);
    NewLine;

    WriteString(  '  NRELEASETIMES');
    WriteInteger(FPrpPackage.ReleaseTimes.Count);
    NewLine;
  finally
    WriteEndDimensions;
  end;
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

 frmErrorsAndWarnings.BeginUpdate;
  try
    Evaluate;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    FNameOfFile := ChangeFileExt(AFileName, '') + '.' + PrtModel.ModelName
       + '.' + PrpPackage.PackageName + Extension;
    FInputFileName := FNameOfFile;
    WriteToPrtNameFile('PRP6', FNameOfFile, PrtModel, PrpPackage.PackageName);
    OpenFile(FNameOfFile);
    try
      frmProgressMM.AddMessage('Writing PRP data');
      frmProgressMM.AddMessage(StrWritingDataSet0);
      WriteCommentLine(File_Comment('PRP Package for PRT model'));
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

      frmProgressMM.AddMessage(StrWritingDimensions);
      WriteDimensions;
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;

      frmProgressMM.AddMessage('Writing PRP Package Data');
      WritePackageData;
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;

      frmProgressMM.AddMessage('Writing Release Times');
      WriteReleaseTimes;
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;

      frmProgressMM.AddMessage('Writing PRP Stress Periods');
      WriteStressPeriods;
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
      ccmEager: WriteString('  COORDINATE_CHECK_METHOD EAGER');
      ccmNone: WriteString('  COORDINATE_CHECK_METHOD NONE');
    end;
    NewLine;

  finally
    WriteEndOptions;
  end;
end;

procedure TPrpWriter.WritePackageData;
var
  DisvUsed: Boolean;
  AParticle: TPrtParticle;
begin
  DisvUsed := Model.DisvUsed;
  WriteBeginPackageData;
  try
    for var ParticleIndex := 0 to FParticles.Count - 1 do
    begin
      AParticle := FParticles[ParticleIndex];
      WriteInteger(ParticleIndex+1);
      WriteInteger(AParticle.Layer+1);
      if not DisvUsed then
      begin
        WriteInteger(AParticle.Row+1);
      end;
      WriteInteger(AParticle.Column+1);
      WriteFloat(AParticle.X);
      WriteFloat(AParticle.Y);
      WriteFloat(AParticle.Z);
      WriteString(' ' + AParticle.ScreenObjectName);
      NewLine;
    end;
  finally
    WriteEndPackageData;
  end;
end;

procedure TPrpWriter.WriteReleaseTimes;
begin
  WriteString('BEGIN RELEASETIMES');
  NewLine;
  try
    for var TimeIndex := 0 to FPrpPackage.ReleaseTimes.Count - 1 do
    begin
      WriteFloat(FPrpPackage.ReleaseTimes[TimeIndex].Value);
      NewLine;
    end;
  finally
    WriteString('END RELEASETIMES');
    NewLine;
  end;
end;

procedure TPrpWriter.WriteStressPeriods;
var
  StressPeriods: TModflowStressPeriods;
  APeriodItem: TPrpPeriodDataItem;
  StartPeriod: Integer;
  EndPeriod: Integer;
begin
  if FPrpPackage.PeriodData.Count > 0 then
  begin
    StressPeriods := (Model as TPhastModel).ModflowFullStressPeriods;
    EndPeriod := -1;
    for var PeriodIndex := 0 to PrtModel.PeriodData.Count - 1 do
    begin
      APeriodItem := PrtModel.PeriodData[PeriodIndex];
      StartPeriod := StressPeriods.FindStressPeriod(APeriodItem.StartTime);
      if EndPeriod >= 0 then
      begin
        if (StartPeriod > EndPeriod+1) then
        begin
          WriteBeginPeriod(EndPeriod+1);
          WriteEndPeriod;
        end;
      end;
      EndPeriod := StressPeriods.FindEndStressPeriod(APeriodItem.EndTime);
      WriteBeginPeriod(StartPeriod);

      try
        if APeriodItem.All then
        begin
          WriteString('  ALL');
          NewLine;
        end;

        if APeriodItem.First then
        begin
          WriteString('  FIRST');
          NewLine;
        end;

        if APeriodItem.Last then
        begin
          WriteString('  LAST');
          NewLine;
        end;

        if APeriodItem.Frequency > 0 then
        begin
          WriteString('  FREQUENCY ');
          WriteInteger(APeriodItem.Frequency);
          NewLine;
        end;

        if APeriodItem.Steps.Count > 0 then
        begin
          WriteString('  STEPS ');
          for var StepIndex := 0 to APeriodItem.Steps.Count - 1 do
          begin
            WriteInteger(APeriodItem.Steps[StepIndex]);
          end;
          NewLine;
        end;
      finally
        WriteEndPeriod;
      end;

      if (EndPeriod >= 0) then
      begin
        if EndPeriod + 1 < StressPeriods.Count then
        begin
          WriteBeginPeriod(EndPeriod+1);
          WriteEndPeriod;
        end;
      end;
    end
  end;
end;

end.
