unit RunVoroGridGenUnit;

interface

uses
  System.SysUtils;



type
  TVorogridGenOptions = record
    VoroGridGenLocation: string;
    BaseFileName: string;
    MaxCentroidSeparation: double;
    MaxCells: Integer;
    PolyGrowthRate: double;
    SearchDimensionsUsed: Boolean;
    SearchDimensions: Integer;
    MaxLloydUsed: Boolean;
    MaxLloyd: Integer;
    EpsLloydUsed: Boolean;
    EpsLloyd: Double;
    LloydFactorUsed: Boolean;
    LloydFactor: double;
    SafetyUsed: Boolean;
    Safety: Integer;
  end;

  EVoroGridGenError = class(Exception);

Procedure RunVorGridGen(const Options: TVorogridGenOptions);

implementation

uses
  PhastModelUnit, ScreenObjectUnit, frmGoPhastUnit, System.Classes, FastGEO,
  GoPhastTypes, ModelMuseUtilities;

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
  procedure AddLinesToBln;
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
      BlnFile.Add(ALine)
    end;
  end;
begin
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
    BoundaryObject := nil;
    for var Index := 0 to Model.ScreenObjectCount- 1 do
    begin
      AScreenObject := Model.ScreenObjects[Index];
      if AScreenObject.StoredCentroidSeparation.Value > 0 then
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
          if SecIndex = BoundarySectionIndex then
          begin
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            FileName := BaseName + '_outer_boundary.bln';
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
            FileName := BaseName + Format('_inner_boundary_%d.bln', [BoundaryIndex]);
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
            FileName := BaseName + Format('_line_%d.bln', [LineIndex]);
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
          if AScreenObject.SectionClosed[SecIndex] then
          begin
            Inc(PolygonIndex);
            BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
            AddLinesToBln;
            FileName := BaseName + Format('_poly_%d.bln', [PolygonIndex]);
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
            FileName := BaseName + Format('_line_%d.bln', [LineIndex]);
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
        if AScreenObject.SectionLength[SecIndex] > 1 then
        begin
          Inc(LineIndex);
          BlnFile.Add(AScreenObject.SectionLength[SecIndex].ToString);
          AddLinesToBln;
          FileName := BaseName + Format('_line_%d.bln', [LineIndex]);
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
          AddLinesToBln;
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
          AddLinesToBln;
        end;
      end;
    end;
    for var ObjectIndex := 0 to PointObjects.Count - 1 do
    begin
      AScreenObject := PointObjects[ObjectIndex];
      Separation := AScreenObject.StoredCentroidSeparation.Value;
      for SecIndex := 0 to AScreenObject.SectionCount - 1 do
      begin
        AddLinesToBln;
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

    RunAProgram('"' + FileName + '"');

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


end.
