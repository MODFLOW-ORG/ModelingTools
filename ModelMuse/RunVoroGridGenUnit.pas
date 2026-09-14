unit RunVoroGridGenUnit;

interface

uses
  System.SysUtils, GoPhastTypes, System.Classes;



type
  TVorogridGenOptions = class(TGoPhastPersistent)
  private
    FSearchDimensionsUsed: Boolean;
    FSafety: Integer;
    FVoroGridGenLocation: string;
    FStoredPolyGrowthRate: TRealStorage;
    FStoredLloydFactor: TRealStorage;
    FMaxLloyd: Integer;
    FSearchDimensions: Integer;
    FLloydFactorUsed: Boolean;
    FStoredEpsLloyd: TRealStorage;
    FBaseFileName: string;
    FMaxCells: Integer;
    FSafetyUsed: Boolean;
    FStoredMaxCentroidSeparation: TRealStorage;
    FEpsLloydUsed: Boolean;
    FMaxLloydUsed: Boolean;
    function GetEpsLloyd: Double;
    function GetLloydFactor: double;
    function GetMaxCentroidSeparation: double;
    function GetPolyGrowthRate: double;
    procedure SetBaseFileName(const Value: string);
    procedure SetEpsLloyd(const Value: Double);
    procedure SetEpsLloydUsed(const Value: Boolean);
    procedure SetLloydFactor(const Value: double);
    procedure SetLloydFactorUsed(const Value: Boolean);
    procedure SetMaxCells(const Value: Integer);
    procedure SetMaxCentroidSeparation(const Value: double);
    procedure SetMaxLloyd(const Value: Integer);
    procedure SetMaxLloydUsed(const Value: Boolean);
    procedure SetPolyGrowthRate(const Value: double);
    procedure SetSafety(const Value: Integer);
    procedure SetSafetyUsed(const Value: Boolean);
    procedure SetSearchDimensions(const Value: Integer);
    procedure SetSearchDimensionsUsed(const Value: Boolean);
    procedure SetStoredEpsLloyd(const Value: TRealStorage);
    procedure SetStoredLloydFactor(const Value: TRealStorage);
    procedure SetStoredMaxCentroidSeparation(const Value: TRealStorage);
    procedure SetStoredPolyGrowthRate(const Value: TRealStorage);
    procedure SetVoroGridGenLocation(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
    Constructor Create(InvalidateModelEvent: TNotifyEvent);
    destructor Destroy; override;
    procedure Initialize;
    property VoroGridGenLocation: string read FVoroGridGenLocation write SetVoroGridGenLocation;
    property MaxCentroidSeparation: double read GetMaxCentroidSeparation write SetMaxCentroidSeparation;
    property PolyGrowthRate: double read GetPolyGrowthRate write SetPolyGrowthRate;
    property EpsLloyd: Double read GetEpsLloyd write SetEpsLloyd;
    property LloydFactor: double read GetLloydFactor write SetLloydFactor;
  published
    property BaseFileName: string read FBaseFileName write SetBaseFileName;
    property MaxCells: Integer read FMaxCells write SetMaxCells;
    property SearchDimensionsUsed: Boolean read FSearchDimensionsUsed write SetSearchDimensionsUsed;
    property SearchDimensions: Integer read FSearchDimensions write SetSearchDimensions;
    property MaxLloydUsed: Boolean read FMaxLloydUsed write SetMaxLloydUsed;
    property MaxLloyd: Integer read FMaxLloyd write SetMaxLloyd;
    property EpsLloydUsed: Boolean read FEpsLloydUsed write SetEpsLloydUsed;
    property LloydFactorUsed: Boolean read FLloydFactorUsed write SetLloydFactorUsed;
    property SafetyUsed: Boolean read FSafetyUsed write SetSafetyUsed;
    property Safety: Integer read FSafety write SetSafety;
    property StoredMaxCentroidSeparation: TRealStorage read FStoredMaxCentroidSeparation write SetStoredMaxCentroidSeparation;
    property StoredPolyGrowthRate: TRealStorage read FStoredPolyGrowthRate write SetStoredPolyGrowthRate;
    property StoredEpsLloyd: TRealStorage read FStoredEpsLloyd write SetStoredEpsLloyd;
    property StoredLloydFactor: TRealStorage read FStoredLloydFactor write SetStoredLloydFactor;
  end;

  EVoroGridGenError = class(Exception);

Procedure RunVorGridGen(const Options: TVorogridGenOptions);

implementation

uses
  PhastModelUnit, ScreenObjectUnit, frmGoPhastUnit, FastGEO,
  ModelMuseUtilities, frmErrorsAndWarningsUnit, System.IOUtils;

resourcestring
  SObjectNameSectionNumber = 'Object Name: %s; Section Number : %d';
  SObjectVertexNumber = 'Object: %s; Vertex number %d.';
  SVerticesTooCloselySpacedInTheFol = 'Vertices too closely spaced in the following objects';

Procedure RunVorGridGen(const Options: TVorogridGenOptions);
var
  PolygonObjects: TScreenObjectList;
  LineObjects: TScreenObjectList;
  PointObjects: TScreenObjectList;
  Model: TPhastModel;
  AScreenObject: TScreenObject;
  BoundaryObject: TScreenObject;
  BoundaryObjectArea: double;
  TestArea: double;
  BoundarySectionIndex: Integer;
  BlnFile: TStringList;
  BoundaryIndex: Integer;
  PolygonIndex: Integer;
  LineIndex: Integer;
  ControlFile: TStringList;
  Separation: double;
  APoint: TPoint2D;
  Item: TPointValue;
  ALine: string;
  OldDecimalSeparator: Char;
  SecIndex: Integer;
  BaseName: string;
  FileName: string;
  BatchFile: TStringList;
  Warnings: Boolean;
  DisvFileName: string;
  function EncloseQuotes(AName: string): string;
  begin
    if Pos(' ', AName) > 0 then
    begin
      result := '"' + AName + '"';
    end
    else
    begin
      result := AName;
    end;
  end;
  procedure AddLinesToBln(AddID: Boolean = False);
  var
    SegmentDistance: double;
  begin
    for var PointIndex := AScreenObject.SectionStart[SecIndex] to AScreenObject.SectionEnd[SecIndex] do
    begin
      APoint := AScreenObject.Points[PointIndex];
      Item := AScreenObject.PointPositionValues.GetPointValueItemByPositionAndName(PointIndex, 'Voronoi');
      if Item <> nil then
      begin
        Separation := Item.Value;
      end;
      ALine := FloatToStr(APoint.x) + ' ' + FloatToStr(APoint.y) + ' ' + FloatToStr(Separation);
      if AddID then
      begin
        ALine := ALine + Format(' ' + SObjectNameSectionNumber, [AScreenObject.Name, SecIndex+1]);
      end;
      BlnFile.Add(ALine);
      if PointIndex < AScreenObject.SectionEnd[SecIndex] then
      begin
        SegmentDistance := Distance(APoint, AScreenObject.Points[PointIndex + 1]);
        if SegmentDistance < Separation then
        begin
          Warnings := True;
          frmErrorsAndWarnings.AddWarning(Model, SVerticesTooCloselySpacedInTheFol,
            Format(SObjectVertexNumber, [AScreenObject.Name, PointIndex+1]), AScreenObject);
        end;
      end;
    end;
  end;
begin
  Warnings := False;
  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  PolygonObjects := TScreenObjectList.Create;
  LineObjects := TScreenObjectList.Create;
  PointObjects := TScreenObjectList.Create;
  BlnFile := TStringList.Create;
  ControlFile := TStringList.Create;
  BatchFile := TStringList.Create;
  try
    BaseName := ChangeFileExt(Options.BaseFileName, '');
    FormatSettings.DecimalSeparator := '.';
    Model := frmGoPhast.PhastModel;
    frmErrorsAndWarnings.RemoveWarningGroup(Model, SVerticesTooCloselySpacedInTheFol);
    BoundaryObject := nil;
    for var Index := 0 to Model.ScreenObjectCount- 1 do
    begin
      AScreenObject := Model.ScreenObjects[Index];
      if (AScreenObject.StoredCentroidSeparation.Value > 0) and not AScreenObject.Deleted then
      begin
        if AScreenObject.Closed then
        begin
          PolygonObjects.Add(AScreenObject);
        end
        else if AScreenObject.SectionCount = AScreenObject.Count then
        begin
          PointObjects.Add(AScreenObject);
        end
        else
        begin
          LineObjects.Add(AScreenObject);
        end;
      end;
    end;
    if PolygonObjects.Count = 0 then
    begin
      raise EVoroGridGenError.Create('No polygon objects define the edge of the Voronoi DISV grid');
    end
    else
    begin
      BoundaryObjectArea := 0;
      BoundarySectionIndex := -1;
      for var ObjectIndex := 0 to PolygonObjects.Count - 1 do
      begin
        AScreenObject := PolygonObjects[ObjectIndex];
        for SecIndex := 0 to AScreenObject.SectionCount - 1 do
        begin
          TestArea := AScreenObject.ScreenObjectSectionArea(SecIndex);
          if TestArea > BoundaryObjectArea then
          begin
            BoundaryObject := AScreenObject;
            BoundaryObjectArea := TestArea;
            BoundarySectionIndex := SecIndex;
          end;
        end;
      end;
    end;
    if BoundaryObject = nil then
    begin
      raise EVoroGridGenError.Create('No polygon objects define the edge of the Voronoi DISV grid');
    end;
    BoundaryIndex := 0;
    PolygonIndex := 0;
    LineIndex := 0;
    for var ObjectIndex := 0 to PolygonObjects.Count - 1 do
    begin
      AScreenObject := PolygonObjects[ObjectIndex];
      Separation := AScreenObject.StoredCentroidSeparation.Value;
      if AScreenObject = BoundaryObject then
      begin
        for SecIndex := 0 to AScreenObject.SectionCount - 1 do
        begin
          BlnFile.Clear;
//          BlnFile.Add(Format(SObjectNameSectionNumber, [AScreenObject.Name, SecIndex+1]));
          if SecIndex = BoundarySectionIndex then
          begin
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            if AScreenObject.SectionCount > 1 then
            begin
              FileName := BaseName + '_' + AScreenObject.Name + '_' + 'Section_' + (SecIndex+1).ToString + '_outer_boundary.bln';
            end
            else
            begin
              FileName := BaseName +  '_' + AScreenObject.Name + '_outer_boundary.bln';
            end;

            BlnFile.SaveToFile(FileName);
            ControlFile.Add('START OUTER_BOUNDARY');
            ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
            ControlFile.Add('END OUTER_BOUNDARY');
            ControlFile.Add('');
          end
          else if AScreenObject.SectionClosed[SecIndex] then
          begin
            Inc(BoundaryIndex);
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            if AScreenObject.SectionCount > 1 then
            begin
              FileName := BaseName + '_' + AScreenObject.Name + '_' + 'Section_' + (SecIndex+1).ToString + Format('_inner_boundary_%d.bln', [BoundaryIndex]);
            end
            else
            begin
              FileName := BaseName +  '_' + AScreenObject.Name + Format('_inner_boundary_%d.bln', [BoundaryIndex]);
            end;
//            FileName := BaseName + Format('_inner_boundary_%d.bln', [BoundaryIndex]);
            BlnFile.SaveToFile(FileName);
            ControlFile.Add('START INNER_BOUNDARY');
            ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
            ControlFile.Add('END INNER_BOUNDARY');
            ControlFile.Add('');
          end
          else if AScreenObject.SectionLength[SecIndex] > 1 then
          begin
            Inc(LineIndex);
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            if AScreenObject.SectionCount > 1 then
            begin
              FileName := BaseName + '_' + AScreenObject.Name + '_' + 'Section_' + (SecIndex+1).ToString + Format('_line_%d.bln', [LineIndex]);
            end
            else
            begin
              FileName := BaseName +  '_' + AScreenObject.Name + Format('_line_%d.bln', [LineIndex]);
            end;
//            FileName := BaseName + Format('_line_%d.bln', [LineIndex]);
            BlnFile.SaveToFile(FileName);
            ControlFile.Add('START INNER_LINE');
            ControlFile.Add('  numline=1');
            ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
            ControlFile.Add('END INNER_LINE');
            ControlFile.Add('');
          end;
        end;
      end
      else
      begin
        for SecIndex := 0 to AScreenObject.SectionCount - 1 do
        begin
          BlnFile.Clear;
//          BlnFile.Add(Format('Object Name: %s; Section Number : %d', [AScreenObject.Name, SecIndex+1]));
          if AScreenObject.SectionClosed[SecIndex] then
          begin
            Inc(PolygonIndex);
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            if AScreenObject.SectionCount > 1 then
            begin
              FileName := BaseName + '_' + AScreenObject.Name + '_' + 'Section_' + (SecIndex+1).ToString + Format('_poly_%d.bln', [PolygonIndex]);
            end
            else
            begin
              FileName := BaseName +  '_' + AScreenObject.Name + Format('_poly_%d.bln', [PolygonIndex]);
            end;
//            FileName := BaseName + Format('_poly_%d.bln', [PolygonIndex]);
            BlnFile.SaveToFile(FileName);
            ControlFile.Add('START INNER_POLYGON');
            ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
            ControlFile.Add('  max_centroid_separation=' + FloatToStr(AScreenObject.StoredCentroidSeparation.Value));
            ControlFile.Add('END INNER_POLYGON');
            ControlFile.Add('');
          end
          else if AScreenObject.SectionLength[SecIndex] > 1 then
          begin
            Inc(LineIndex);
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            if AScreenObject.SectionCount > 1 then
            begin
              FileName := BaseName + '_' + AScreenObject.Name + '_' + 'Section_' + (SecIndex+1).ToString + Format('_line_%d.bln', [LineIndex]);
            end
            else
            begin
              FileName := BaseName +  '_' + AScreenObject.Name + Format('_line_%d.bln', [LineIndex]);
            end;
//            FileName := BaseName + Format('_line_%d.bln', [LineIndex]);
            BlnFile.SaveToFile(FileName);
            ControlFile.Add('START INNER_LINE');
            ControlFile.Add('  numline=1');
            ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
            ControlFile.Add('END INNER_LINE');
            ControlFile.Add('');
          end;
        end;
      end;
    end;
    for var ObjectIndex := 0 to LineObjects.Count - 1 do
    begin
      AScreenObject := LineObjects[ObjectIndex];
      Separation := AScreenObject.StoredCentroidSeparation.Value;
      for SecIndex := 0 to AScreenObject.SectionCount - 1 do
      begin
        BlnFile.Clear;
//        BlnFile.Add(Format('Object Name: %s; Section Number : %d', [AScreenObject.Name, SecIndex+1]));
        if AScreenObject.SectionLength[SecIndex] > 1 then
        begin
          Inc(LineIndex);
          BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
          AddLinesToBln;
            if AScreenObject.SectionCount > 1 then
            begin
              FileName := BaseName + '_' + AScreenObject.Name + '_' + 'Section_' + (SecIndex+1).ToString + Format('_line_%d.bln', [LineIndex]);
            end
            else
            begin
              FileName := BaseName +  '_' + AScreenObject.Name + Format('_line_%d.bln', [LineIndex]);
            end;
//          FileName := BaseName + Format('_line_%d.bln', [LineIndex]);
          BlnFile.SaveToFile(FileName);
          ControlFile.Add('START INNER_LINE');
          ControlFile.Add('  numline=1');
          ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
          ControlFile.Add('END INNER_LINE');
          ControlFile.Add('');
        end;
      end;
    end;
    BlnFile.Clear;
    for var ObjectIndex := 0 to PolygonObjects.Count - 1 do
    begin
      AScreenObject := PolygonObjects[ObjectIndex];
      Separation := AScreenObject.StoredCentroidSeparation.Value;
      for SecIndex := 0 to AScreenObject.SectionCount - 1 do
      begin
        if AScreenObject.SectionLength[SecIndex] = 1 then
        begin
          AddLinesToBln(True);
        end;
      end;
    end;
    for var ObjectIndex := 0 to LineObjects.Count - 1 do
    begin
      AScreenObject := LineObjects[ObjectIndex];
      Separation := AScreenObject.StoredCentroidSeparation.Value;
      for SecIndex := 0 to AScreenObject.SectionCount - 1 do
      begin
        if AScreenObject.SectionLength[SecIndex] = 1 then
        begin
          AddLinesToBln(True);
        end;
      end;
    end;
    for var ObjectIndex := 0 to PointObjects.Count - 1 do
    begin
      AScreenObject := PointObjects[ObjectIndex];
      Separation := AScreenObject.StoredCentroidSeparation.Value;
      for SecIndex := 0 to AScreenObject.SectionCount - 1 do
      begin
        AddLinesToBln(True);
      end;
    end;
    if BlnFile.Count > 0 then
    begin
      BlnFile.Insert(0, BlnFile.Count.ToString);
      FileName := BaseName + '_Point.bln';
      BlnFile.SaveToFile(FileName);
      ControlFile.Add('START INNER_POINTS');
      ControlFile.Add('  bln_file=' + ExtractFileName(FileName));
      ControlFile.Add('END INNER_POINTS');
      ControlFile.Add('');
    end;

    ControlFile.Add('START MF6');
    ControlFile.Add('  nlay 1');
    ControlFile.Add('  mf6_basename=' + ExtractFileName(BaseName));
    ControlFile.Add('END MF6');
    ControlFile.Add('');

    ControlFile.Add('START CONTROL');
    ControlFile.Add('  out_file_base=' + ExtractFileName(BaseName));
    ControlFile.Add('  max_centroid_separation=' + FloatToStr(Options.MaxCentroidSeparation));
    ControlFile.Add('  max_cells=' + IntToStr(Options.MaxCells));
    ControlFile.Add('  poly_growth_rate=' + FloatToStr(Options.PolyGrowthRate));
    if Options.SearchDimensionsUsed then
    begin
      ControlFile.Add('  nsdim=' + IntToStr(Options.SearchDimensions));
    end;
    if Options.MaxLloydUsed then
    begin
      ControlFile.Add('  max_lloyd=' + IntToStr(Options.MaxLloyd));
    end;
    if Options.EpsLloydUsed then
    begin
      ControlFile.Add('  eps_lloyd=' + FloatToStr(Options.EpsLloyd));
    end;
    if Options.LloydFactorUsed then
    begin
      ControlFile.Add('  lloyd_fac=' + FloatToStr(Options.LloydFactor));
    end;
    if Options.SafetyUsed then
    begin
      ControlFile.Add('  safety=' + IntToStr(Options.Safety));
    end;
    ControlFile.Add('END CONTROL');

    FileName := BaseName + '_vorogridgen.in';
    ControlFile.SaveToFile(FileName);

    ALine := EncloseQuotes(Options.VoroGridGenLocation) + ' ' + ExtractFileName(FileName);
    BatchFile.Add(ALine);
    BatchFile.Add('pause');

    FileName := IncludeTrailingPathDelimiter(ExtractFileDir(BaseName)) + 'RunVoroGridGen.Bat';
    BatchFile.SaveToFile(FileName);

    DisvFileName := BaseName + '.disv';
    if TFile.Exists(DisvFileName) then
    begin
      TFile.Delete(DisvFileName);
    end;

    RunAProgram('"' + FileName + '"');

    if Warnings then
    begin
      frmErrorsAndWarnings.ShowAfterDelay;
    end;

  finally
    PolygonObjects.Free;
    LineObjects.Free;
    PointObjects.Free;
    BlnFile.Free;
    ControlFile.Free;
    BatchFile.Free;
    FormatSettings.DecimalSeparator := OldDecimalSeparator;

  end;
end;


{ TVorogridGenOptions }

procedure TVorogridGenOptions.Assign(Source: TPersistent);
var
  SourceOptions: TVorogridGenOptions;
begin
  if Source is TVorogridGenOptions then
  begin
    SourceOptions := TVorogridGenOptions(Source);
    VoroGridGenLocation := SourceOptions.VoroGridGenLocation;
    MaxCentroidSeparation := SourceOptions.MaxCentroidSeparation;
    PolyGrowthRate := SourceOptions.PolyGrowthRate;
    EpsLloyd := SourceOptions.EpsLloyd;
    LloydFactor := SourceOptions.LloydFactor;
    BaseFileName := SourceOptions.BaseFileName;
    MaxCells := SourceOptions.MaxCells;
    SearchDimensionsUsed := SourceOptions.SearchDimensionsUsed;
    SearchDimensions := SourceOptions.SearchDimensions;
    MaxLloydUsed := SourceOptions.MaxLloydUsed;
    MaxLloyd := SourceOptions.MaxLloyd;
    EpsLloydUsed := SourceOptions.EpsLloydUsed;
    LloydFactorUsed := SourceOptions.LloydFactorUsed;
    SafetyUsed := SourceOptions.SafetyUsed;
    Safety := SourceOptions.Safety;
    VoroGridGenLocation := SourceOptions.VoroGridGenLocation;
  end
  else
  begin
    inherited;
  end;
end;

constructor TVorogridGenOptions.Create(InvalidateModelEvent: TNotifyEvent);
begin
  inherited;
  FStoredMaxCentroidSeparation := TRealStorage.Create(InvalidateModelEvent);
  FStoredPolyGrowthRate := TRealStorage.Create(InvalidateModelEvent);
  FStoredEpsLloyd := TRealStorage.Create(InvalidateModelEvent);
  FStoredLloydFactor := TRealStorage.Create(InvalidateModelEvent);
  Initialize;
end;

destructor TVorogridGenOptions.Destroy;
begin
  FStoredMaxCentroidSeparation.Free;
  FStoredPolyGrowthRate.Free;
  FStoredEpsLloyd.Free;
  FStoredLloydFactor.Free;
 inherited;
end;

function TVorogridGenOptions.GetEpsLloyd: Double;
begin
  Result := StoredEpsLloyd.Value;
end;

function TVorogridGenOptions.GetLloydFactor: double;
begin
  Result := StoredLloydFactor.Value;
end;

function TVorogridGenOptions.GetMaxCentroidSeparation: double;
begin
  Result := StoredMaxCentroidSeparation.Value;
end;

function TVorogridGenOptions.GetPolyGrowthRate: double;
begin
  Result := StoredPolyGrowthRate.Value;
end;

procedure TVorogridGenOptions.Initialize;
begin
  VoroGridGenLocation := '';
  BaseFileName := '';
  MaxCentroidSeparation := 1000;
  PolyGrowthRate := 1.1;
  MaxCells := 10000;
  SearchDimensionsUsed := false;
  SearchDimensions := 31;
  MaxLloydUsed := False;
  MaxLloyd := 30;
  EpsLloydUsed := False;
  EpsLloyd := 1E-10;
  LloydFactorUsed := False;
  LloydFactor := 0.2;
  SafetyUsed := False;
  Safety := 0;
end;

procedure TVorogridGenOptions.SetBaseFileName(const Value: string);
begin
  SetStringProperty(FBaseFileName, Value);
end;

procedure TVorogridGenOptions.SetEpsLloyd(const Value: Double);
begin
  StoredEpsLloyd.Value := Value;
end;

procedure TVorogridGenOptions.SetEpsLloydUsed(const Value: Boolean);
begin
  SetBooleanProperty(FEpsLloydUsed, Value);
end;

procedure TVorogridGenOptions.SetLloydFactor(const Value: double);
begin
  StoredLloydFactor.Value := Value;
end;

procedure TVorogridGenOptions.SetLloydFactorUsed(const Value: Boolean);
begin
  SetBooleanProperty(FLloydFactorUsed, Value);
end;

procedure TVorogridGenOptions.SetMaxCells(const Value: Integer);
begin
  SetIntegerProperty(FMaxCells, Value);
end;

procedure TVorogridGenOptions.SetMaxCentroidSeparation(const Value: double);
begin
  StoredMaxCentroidSeparation.Value := Value;
end;

procedure TVorogridGenOptions.SetMaxLloyd(const Value: Integer);
begin
  SetIntegerProperty(FMaxLloyd, Value);
end;

procedure TVorogridGenOptions.SetMaxLloydUsed(const Value: Boolean);
begin
  SetBooleanProperty(FMaxLloydUsed, Value);
end;

procedure TVorogridGenOptions.SetPolyGrowthRate(const Value: double);
begin
  StoredPolyGrowthRate.Value := Value;
end;

procedure TVorogridGenOptions.SetSafety(const Value: Integer);
begin
  SetIntegerProperty(FSafety, Value);
end;

procedure TVorogridGenOptions.SetSafetyUsed(const Value: Boolean);
begin
  SetBooleanProperty(FSafetyUsed, Value);
end;

procedure TVorogridGenOptions.SetSearchDimensions(const Value: Integer);
begin
  SetIntegerProperty(FSearchDimensions, Value);
end;

procedure TVorogridGenOptions.SetSearchDimensionsUsed(const Value: Boolean);
begin
  SetBooleanProperty(FSearchDimensionsUsed, Value);
end;

procedure TVorogridGenOptions.SetStoredEpsLloyd(const Value: TRealStorage);
begin
  FStoredEpsLloyd.Assign(Value);
end;

procedure TVorogridGenOptions.SetStoredLloydFactor(const Value: TRealStorage);
begin
  FStoredLloydFactor.Assign(Value);
end;

procedure TVorogridGenOptions.SetStoredMaxCentroidSeparation(
  const Value: TRealStorage);
begin
  FStoredMaxCentroidSeparation.Assign(Value);
end;

procedure TVorogridGenOptions.SetStoredPolyGrowthRate(
  const Value: TRealStorage);
begin
  FStoredPolyGrowthRate.Assign(Value);
end;

procedure TVorogridGenOptions.SetVoroGridGenLocation(const Value: string);
begin
  SetStringProperty(FVoroGridGenLocation, Value);
end;

end.
