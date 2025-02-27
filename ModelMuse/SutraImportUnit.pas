// @name is used to import SUTRA files generated by running PEST
unit SutraImportUnit;

interface

uses
  Vcl.Forms, Winapi.Windows, System.UITypes, System.Classes,
  frmImportShapefileUnit, System.SysUtils, Vcl.Dialogs;

procedure ImportDataSet14B(const FileName: string);

procedure ImportDataSet15B(const FileName: string);

procedure ImportInitConditions(const FileName: string);

implementation

uses
  System.IOUtils, frmGoPhastUnit, PhastModelUnit, GoPhastTypes,
  ScreenObjectUnit, SutraMeshUnit, UndoItems, DataSetUnit,
  ValueArrayStorageUnit, RbwParser, frmProgressUnit, GIS_Functions, FastGEO,
  DataSetNamesUnit;

resourcestring
  StrObject = 'Object ';

Type
  TNELocation = record
    Number: integer;
    Location: TPoint2D;
    Z: double;
  end;

  TNELocationArray = array of TNELocation;

  TImportSutra14B = class(TUndoImportShapefile)
  protected
    function Description: string; override;
  end;

  TImportSutra15B = class(TUndoImportShapefile)
  protected
    function Description: string; override;
  end;

  TImportSutraInitConditions = class(TUndoImportShapefile)
  protected
    function Description: string; override;
  end;

procedure MakeNewDataSet(NewDataSets: TList; Suffix, Classification: string;
   FileName: string; EvaluatedAt: TEvaluatedAt; out DataArray: TDataArray);
var
  NewDataSetName: string;
  ChildIndex: Integer;
  ChildModel: TChildModel;
  ChildDataSet: TDataArray;
begin
  NewDataSetName := ExtractFileName(FileName);
  NewDataSetName := ChangeFileExt(NewDataSetName, '');
  NewDataSetName := GenerateNewName(NewDataSetName + Suffix);

  DataArray := frmGoPhast.PhastModel.DataArrayManager.CreateNewDataArray(TDataArray,
    NewDataSetName, '0.', NewDataSetName, [], rdtDouble,
    EvaluatedAt, dso3D, Classification);

  DataArray.Comment := Format('Imported from "%0:s" on %1:s.',
    [FileName, DateTimeToStr(Now)]);

  DataArray.OnDataSetUsed := frmGoPhast.PhastModel.ModelResultsRequired;
  DataArray.Units := '';

  DataArray.TwoDInterpolator := nil;

  frmGoPhast.PhastModel.UpdateDataArrayDimensions(DataArray);

  if frmGoPhast.PhastModel.LgrUsed then
  begin
    for ChildIndex := 0 to frmGoPhast.PhastModel.ChildModels.Count - 1 do
    begin
      ChildModel := frmGoPhast.PhastModel.ChildModels[ChildIndex].ChildModel;
      if ChildModel <> nil then
      begin
        ChildDataSet := ChildModel.DataArrayManager.GetDataSetByName(DataArray.Name);
        ChildModel.UpdateDataArrayDimensions(ChildDataSet);
      end;
    end;
  end;

  NewDataSets.add(DataArray);
end;

procedure GetNodeLocations(out Locations: TNELocationArray);
var
  LocalModel: TPhastModel;
  Mesh: TSutraMesh3D;
  NodeIndex: Integer;
  Node2D: TSutraNode2D;
  LayerIndex: Integer;
  Node3D: TSutraNode3D;
  NodeLocation: TNELocation;
begin
  LocalModel := frmGoPhast.PhastModel;
  Assert(LocalModel.ModelSelection in SutraSelection);
  Mesh := LocalModel.SutraMesh;

  if Mesh.MeshType = mt3D then
  begin
    SetLength(Locations, Mesh.Mesh2D.Nodes.Count
      * (Mesh.LayerCount + 1));
    for NodeIndex := 0 to Mesh.Mesh2D.Nodes.Count - 1 do
    begin
      Node2D := Mesh.Mesh2D.Nodes[NodeIndex];
      NodeLocation.Location := Node2D.Location;
      for LayerIndex := 0 to Mesh.LayerCount do
      begin
        Node3D := Mesh.NodeArray[LayerIndex,NodeIndex];
        if Node3D.DisplayNumber > 0 then
        begin
          NodeLocation.Number := Node3D.DisplayNumber;
          NodeLocation.Z := Node3D.Z;
          Locations[Node3D.DisplayNumber-1] := NodeLocation;
        end;
      end;
    end;
  end
  else
  begin
    SetLength(Locations, Mesh.Mesh2D.Nodes.Count);
    NodeLocation.Z := 0;
    for NodeIndex := 0 to Mesh.Mesh2D.Nodes.Count - 1 do
    begin
      Node2D := Mesh.Mesh2D.Nodes[NodeIndex];
      NodeLocation.Number := Node2D.DisplayNumber;
      NodeLocation.Location := Node2D.Location;
      Locations[NodeIndex] := NodeLocation;
    end;
  end;
end;

procedure ImportDataSet14B(const FileName: string);
var
  ALine: string;
  Splitter: TStringList;
  LocalModel: TPhastModel;
  Z: double;
  Por: double;
  Undo: TImportSutra14B;
  Undo2: TCustomUndo;
  Mesh: TSutraMesh3D;
  Porosity: TDataArray;
  Thickness: TDataArray;
  PorosityValueArrayItem: TValueArrayItem;
  ThicknessValueArrayItem: TValueArrayItem;
  ThicknessValues: TValueArrayStorage;
  AScreenObject: TScreenObject;
  ScreenObjectList: TList;
  Position: integer;
  NewDataSets: TList;
  PointCount: Integer;
  Locations: TNELocationArray;
  NodeNumber: Integer;
  Sutra4Used: Boolean;
  Sutra4SoluteUsed: Boolean;
  Sutra4FreezingUsed: Boolean;
  Sutra4ProductionUsed: Boolean;
  COMPMA: TDataArray;
  COMPMAValueArrayItem: TValueArrayItem;
  CS: TDataArray;
  CS_ValueArrayItem: TValueArrayItem;
  RHOS: TDataArray;
  RHOS_ValueArrayItem: TValueArrayItem;
  PRODL0: TDataArray;
  PRODL0_ValueArrayItem: TValueArrayItem;
  PRODS0: TDataArray;
  PRODS0_ValueArrayItem: TValueArrayItem;
  PRODL1: TDataArray;
  PRODL1_ValueArrayItem: TValueArrayItem;
  PRODS1_ValueArrayItem: TValueArrayItem;
  PRODS1: TDataArray;
  PRODI: TDataArray;
  PRODI_ValueArrayItem: TValueArrayItem;
  procedure HandleFileStream(FileName: string);
  var
    TextStream: TStreamReader;
    COMPMA_Value: Double;
    CS_Value: double;
    RHOS_Value: Double;
    ValueIndex: Integer;
    PRODL0_Value: Double;
    PRODS0_Value: Double;
    PRODL1_Value: Double;
    PRODS1_Value: Double;
    PRODI_Value: Extended;
  begin
    TextStream := TFile.OpenText(FileName);
    try
      while not TextStream.EndOfStream do
      begin
        ALine := TextStream.ReadLine;
        if (ALine = '') or (ALine[1] = '#') then
        begin
          Continue;
        end;
        Splitter.DelimitedText := ALine;
        Assert(Splitter.Count >= 3);
        if UpperCase(Splitter[0]) = '@INSERT' then
        begin
          TDirectory.SetCurrentDirectory(ExtractFilePath(FileName));
          HandleFileStream(ExpandFileName(Splitter[2]));
        end
        else
        begin
          Assert(Splitter.Count >= 6);
          NodeNumber := StrToInt(Splitter[0]);
          Z := FortranStrToFloat(Splitter[4]);
          Por := FortranStrToFloat(Splitter[5]);

          if Sutra4Used then
          begin
            COMPMA_Value := FortranStrToFloat(Splitter[6]);
            CS_Value := FortranStrToFloat(Splitter[7]);
            RHOS_Value := FortranStrToFloat(Splitter[8]);
            ValueIndex := 8;
            if Sutra4ProductionUsed then
            begin
              Inc(ValueIndex);
              PRODL0_Value := FortranStrToFloat(Splitter[ValueIndex]);
              Inc(ValueIndex);
              PRODS0_Value := FortranStrToFloat(Splitter[ValueIndex]);
            end
            else
            begin
              PRODL0_Value := 0;
              PRODS0_Value := 0;
            end;
            if Sutra4SoluteUsed then
            begin
              Inc(ValueIndex);
              PRODL1_Value := FortranStrToFloat(Splitter[ValueIndex]);
              Inc(ValueIndex);
              PRODS1_Value := FortranStrToFloat(Splitter[ValueIndex]);
            end
            else
            begin
              PRODL1_Value := 0;
              PRODS1_Value := 0;
            end;
            if Sutra4FreezingUsed then
            begin
              Inc(ValueIndex);
              PRODI_Value := FortranStrToFloat(Splitter[ValueIndex]);
            end
            else
            begin
              PRODI_Value := 0;
            end;
          end
          else
          begin
            COMPMA_Value := 0;
            CS_Value := 0;
            RHOS_Value := 0;
            PRODL0_Value := 0;
            PRODS0_Value := 0;
            PRODL1_Value := 0;
            PRODS1_Value := 0;
            PRODI_Value := 0;
          end;



          Inc(PointCount);

          AScreenObject.AddPoint(Locations[NodeNumber-1].Location, True);
          ThicknessValues.Add(Z);
          PorosityValueArrayItem.Values.Add(Por);

          if Sutra4Used then
          begin
            COMPMAValueArrayItem.Values.Add(COMPMA_Value);
            CS_ValueArrayItem.Values.Add(CS_Value);
            RHOS_ValueArrayItem.Values.Add(RHOS_Value);
            if Sutra4ProductionUsed then
            begin
              PRODL0_ValueArrayItem.Values.Add(PRODL0_Value);
              PRODS0_ValueArrayItem.Values.Add(PRODS0_Value);
            end;
            if Sutra4SoluteUsed then
            begin
              PRODL1_ValueArrayItem.Values.Add(PRODL1_Value);
              PRODS1_ValueArrayItem.Values.Add(PRODS1_Value);
            end;
            if Sutra4FreezingUsed then
            begin
              PRODI_ValueArrayItem.Values.Add(PRODI_Value);
            end;
          end;
          frmProgressMM.ProgressLabelCaption :=
            Format('%0:d out of %1:d.', [PointCount, AScreenObject.Capacity]);
          frmProgressMM.StepIt;
          Application.ProcessMessages;
        end;
      end;
    finally
      TextStream.Free;
    end
  end;
begin
  Assert(TFile.Exists(FileName));
  LocalModel := frmGoPhast.PhastModel;
  Assert(LocalModel.ModelSelection in SutraSelection);


  Sutra4Used := LocalModel.DoSutra4Used(nil);
  Sutra4SoluteUsed := LocalModel.DoSutra4SoluteUsed(nil);
  Sutra4FreezingUsed := LocalModel.DoSutra4FreezingUsed(nil);
  Sutra4ProductionUsed := LocalModel.DoSutra4ProductionUsed(nil);

  Mesh := LocalModel.SutraMesh;

  GetNodeLocations(Locations);

  frmGoPhast.PhastModel.BeginScreenObjectUpdate;
  frmGoPhast.CanDraw := False;
  try
    ScreenObjectList := TList.Create;
    try
      ScreenObjectList.Capacity := 1;
      AScreenObject := TScreenObject.CreateWithViewDirection(
        LocalModel, vdTop, Undo2, False);
      NewDataSets := TList.Create;
      try
        ScreenObjectList.Add(AScreenObject);
        AScreenObject.Visible := False;
        AScreenObject.SetValuesOfIntersectedCells := True;
        AScreenObject.EvaluatedAt := eaNodes;
        if Mesh.MeshType = mt3D then
        begin
          AScreenObject.ElevationCount := ecOne;
          AScreenObject.Capacity := Mesh.Mesh2D.Nodes.Count
            * (Mesh.LayerCount + 1);
          AScreenObject.ElevationFormula :=
            rsObjectImportedValuesR
            + '("' + StrImportedElevations + '")';
        end
        else
        begin
          AScreenObject.ElevationCount := ecZero;
          AScreenObject.Capacity := Mesh.Mesh2D.Nodes.Count;
        end;

        try
          MakeNewDataSet(NewDataSets, '_Imported_Porosity',
            StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
            FileName, eaNodes, Porosity);

          Position := AScreenObject.AddDataSet(Porosity);
          PorosityValueArrayItem := AScreenObject.ImportedValues.Add;
          PorosityValueArrayItem.Name :=  Porosity.Name;
          PorosityValueArrayItem.Values.DataType := rdtDouble;
          AScreenObject.DataSetFormulas[Position]
            := rsObjectImportedValuesR + '("' + PorosityValueArrayItem.Name + '")';

          if Mesh.MeshType <> mt3D then
          begin
            MakeNewDataSet(NewDataSets, '_Imported_Thickness',
              StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
              FileName, eaNodes, Thickness);

            Position := AScreenObject.AddDataSet(Thickness);
            ThicknessValueArrayItem := AScreenObject.ImportedValues.Add;
            ThicknessValueArrayItem.Name :=  Thickness.Name;
            ThicknessValueArrayItem.Values.DataType := rdtDouble;
            AScreenObject.DataSetFormulas[Position]
              := rsObjectImportedValuesR + '("' + ThicknessValueArrayItem.Name + '")';
            ThicknessValues := ThicknessValueArrayItem.Values;
          end
          else
          begin
            Thickness := nil;
            ThicknessValues := AScreenObject.ImportedSectionElevations;
          end;

          if Sutra4Used then
          begin
            MakeNewDataSet(NewDataSets, '_Imported_COMPMA',
              StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
              FileName, eaNodes, COMPMA);

            Position := AScreenObject.AddDataSet(COMPMA);
            COMPMAValueArrayItem := AScreenObject.ImportedValues.Add;
            COMPMAValueArrayItem.Name :=  COMPMA.Name;
            COMPMAValueArrayItem.Values.DataType := rdtDouble;
            AScreenObject.DataSetFormulas[Position]
              := rsObjectImportedValuesR + '("' + COMPMAValueArrayItem.Name + '")';

            MakeNewDataSet(NewDataSets, '_Imported_CS',
              StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
              FileName, eaNodes, CS);

            Position := AScreenObject.AddDataSet(CS);
            CS_ValueArrayItem := AScreenObject.ImportedValues.Add;
            CS_ValueArrayItem.Name :=  CS.Name;
            CS_ValueArrayItem.Values.DataType := rdtDouble;
            AScreenObject.DataSetFormulas[Position]
              := rsObjectImportedValuesR + '("' + CS_ValueArrayItem.Name + '")';

            MakeNewDataSet(NewDataSets, '_Imported_RHOS',
              StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
              FileName, eaNodes, RHOS);

            Position := AScreenObject.AddDataSet(RHOS);
            RHOS_ValueArrayItem := AScreenObject.ImportedValues.Add;
            RHOS_ValueArrayItem.Name :=  RHOS.Name;
            RHOS_ValueArrayItem.Values.DataType := rdtDouble;
            AScreenObject.DataSetFormulas[Position]
              := rsObjectImportedValuesR + '("' + RHOS_ValueArrayItem.Name + '")';

            if Sutra4ProductionUsed then
            begin
              MakeNewDataSet(NewDataSets, '_Imported_PRODL0',
                StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
                FileName, eaNodes, PRODL0);

              Position := AScreenObject.AddDataSet(PRODL0);
              PRODL0_ValueArrayItem := AScreenObject.ImportedValues.Add;
              PRODL0_ValueArrayItem.Name :=  PRODL0.Name;
              PRODL0_ValueArrayItem.Values.DataType := rdtDouble;
              AScreenObject.DataSetFormulas[Position]
                := rsObjectImportedValuesR + '("' + PRODL0_ValueArrayItem.Name + '")';

              MakeNewDataSet(NewDataSets, '_Imported_PRODS0',
                StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
                FileName, eaNodes, PRODS0);

              Position := AScreenObject.AddDataSet(PRODS0);
              PRODS0_ValueArrayItem := AScreenObject.ImportedValues.Add;
              PRODS0_ValueArrayItem.Name :=  PRODS0.Name;
              PRODS0_ValueArrayItem.Values.DataType := rdtDouble;
              AScreenObject.DataSetFormulas[Position]
                := rsObjectImportedValuesR + '("' + PRODS0_ValueArrayItem.Name + '")';
            end;

            if Sutra4SoluteUsed then
            begin
              MakeNewDataSet(NewDataSets, '_Imported_PRODL1',
                StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
                FileName, eaNodes, PRODL1);

              Position := AScreenObject.AddDataSet(PRODL1);
              PRODL1_ValueArrayItem := AScreenObject.ImportedValues.Add;
              PRODL1_ValueArrayItem.Name :=  PRODL1.Name;
              PRODL1_ValueArrayItem.Values.DataType := rdtDouble;
              AScreenObject.DataSetFormulas[Position]
                := rsObjectImportedValuesR + '("' + PRODL1_ValueArrayItem.Name + '")';

              MakeNewDataSet(NewDataSets, '_Imported_PRODS1',
                StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
                FileName, eaNodes, PRODS1);

              Position := AScreenObject.AddDataSet(PRODS1);
              PRODS1_ValueArrayItem := AScreenObject.ImportedValues.Add;
              PRODS1_ValueArrayItem.Name :=  PRODS1.Name;
              PRODS1_ValueArrayItem.Values.DataType := rdtDouble;
              AScreenObject.DataSetFormulas[Position]
                := rsObjectImportedValuesR + '("' + PRODS1_ValueArrayItem.Name + '")';
            end;

            if Sutra4FreezingUsed then
            begin
              MakeNewDataSet(NewDataSets, '_Imported_PRODI',
                StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 14B file',
                FileName, eaNodes, PRODI);

              Position := AScreenObject.AddDataSet(PRODI);
              PRODI_ValueArrayItem := AScreenObject.ImportedValues.Add;
              PRODI_ValueArrayItem.Name :=  PRODI.Name;
              PRODI_ValueArrayItem.Values.DataType := rdtDouble;
              AScreenObject.DataSetFormulas[Position]
                := rsObjectImportedValuesR + '("' + PRODI_ValueArrayItem.Name + '")';
            end;
          end;

          frmProgressMM.Caption := '';
          frmProgressMM.Prefix := StrObject;
          frmProgressMM.PopupParent := frmGoPhast;
          frmProgressMM.Show;
          frmProgressMM.pbProgress.Max := AScreenObject.Capacity;
          frmProgressMM.pbProgress.Position := 0;
          frmProgressMM.ProgressLabelCaption :=
            Format('0 out of %d.', [AScreenObject.Capacity]);
          PointCount := 0;
          Splitter := TStringList.Create;
          try
            HandleFileStream(FileName);
          finally
            Splitter.Free;
          end;
        except
          AScreenObject.Free;
          raise
        end;

        Undo := TImportSutra14B.Create;
        try
          frmGoPhast.PhastModel.AddFileToArchive(FileName);
          Undo.StoreNewScreenObjects(ScreenObjectList);
          Undo.StoreNewDataSets(NewDataSets);
          frmGoPhast.UndoStack.Submit(Undo);
        except
          Undo.Free;
          raise;
        end;
      finally
        NewDataSets.Free;
      end;
    finally
      frmProgressMM.Hide;
      ScreenObjectList.Free;
      frmGoPhast.CanDraw := True;
      frmGoPhast.PhastModel.EndScreenObjectUpdate;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure ImportDataSet15B(const FileName: string);
var
  ALine: string;
  Splitter: TStringList;
  LocalModel: TPhastModel;
  Undo: TImportSutra15B;
  Undo2: TCustomUndo;
  Mesh: TSutraMesh3D;
  ElevationValues: TValueArrayStorage;
  AScreenObject: TScreenObject;
  ScreenObjectList: TList;
  Position: integer;
  NewDataSets: TList;
  PointCount: Integer;
  Locations: TNELocationArray;
  ElementLocation: TNELocation;
  LayerIndex: Integer;
  NodeNumber: Integer;
  ElementIndex: Integer;
  Element2D: TSutraElement2D;
  Element3D: TSutraElement3D;
  PMAX: TDataArray;
  PMID: TDataArray;
  PmaxValueArrayItem: TValueArrayItem;
  PmidValueArrayItem: TValueArrayItem;
  PMIN: TDataArray;
  PminValueArrayItem: TValueArrayItem;
  Angle1: TDataArray;
  Angle1ValueArrayItem: TValueArrayItem;
  Angle2: TDataArray;
  Angle2ValueArrayItem: TValueArrayItem;
  Angle3: TDataArray;
  Angle3ValueArrayItem: TValueArrayItem;
  ALMAX: TDataArray;
  AlmaxValueArrayItem: TValueArrayItem;
  ALMID: TDataArray;
  AlmidValueArrayItem: TValueArrayItem;
  ATMAX: TDataArray;
  AtmaxValueArrayItem: TValueArrayItem;
  ATMID: TDataArray;
  AtmidValueArrayItem: TValueArrayItem;
  ATMIN: TDataArray;
  AtminValueArrayItem: TValueArrayItem;
  AValue: double;
  ALMIN: TDataArray;
  AlminValueArrayItem: TValueArrayItem;
  Sutra4EnergyUsed: Boolean;
  SIGMAS: TDataArray;
  SIGMASValueArrayItem: TValueArrayItem;
  SIGMAA: TDataArray;
  SIGMAAValueArrayItem: TValueArrayItem;
  procedure GetDataSet(const Suffix: string; var DataSet: TDataArray;
    var ValueArrayItem: TValueArrayItem);
  begin
    MakeNewDataSet(NewDataSets, Suffix,
      StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set 15B file',
      FileName, eaBlocks, DataSet);

    Position := AScreenObject.AddDataSet(DataSet);
    ValueArrayItem := AScreenObject.ImportedValues.Add;
    ValueArrayItem.Name :=  DataSet.Name;
    ValueArrayItem.Values.DataType := rdtDouble;
    AScreenObject.DataSetFormulas[Position]
      := rsObjectImportedValuesR + '("' + ValueArrayItem.Name + '")';
  end;
  procedure HandleTextStream(FileName: string);
  var
    ATextStream: TStreamReader;
  begin
    ATextStream := TFile.OpenText(FileName);
    try
      while not ATextStream.EndOfStream do
      begin
        ALine := ATextStream.ReadLine;
        if (ALine = '') or (ALine[1] = '#') then
        begin
          Continue;
        end;
        Splitter.DelimitedText := Trim(ALine);
        Assert(Splitter.Count >= 3);
        if UpperCase(Splitter[0]) = '@INSERT' then
        begin
          TDirectory.SetCurrentDirectory(ExtractFilePath(FileName));
          HandleTextStream(ExpandFileName(Splitter[2]));
        end
        else
        begin
          Assert(Splitter.Count >= 9);
          NodeNumber := StrToInt(Splitter[0]);
          AScreenObject.AddPoint(Locations[NodeNumber-1].Location, True);

          if Mesh.MeshType = mt3D then
          begin
            ElevationValues.Add(Locations[NodeNumber-1].Z);

            Assert(Splitter.Count >= 14);
            AValue := FortranStrToFloat(Splitter[2]);
            PmaxValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[3]);
            PmidValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[4]);
            PminValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[5]);
            Angle1ValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[6]);
            Angle2ValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[7]);
            Angle3ValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[8]);
            AlmaxValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[9]);
            AlmidValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[10]);
            AlminValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[11]);
            AtmaxValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[12]);
            AtmidValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[13]);
            AtminValueArrayItem.Values.Add(AValue);
            if Sutra4EnergyUsed then
            begin
              AValue := FortranStrToFloat(Splitter[14]);
              SIGMASValueArrayItem.Values.Add(AValue);

              AValue := FortranStrToFloat(Splitter[15]);
              SIGMAAValueArrayItem.Values.Add(AValue);
            end;
          end
          else
          begin
            AValue := FortranStrToFloat(Splitter[2]);
            PmaxValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[3]);
            PminValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[4]);
            Angle1ValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[5]);
            AlmaxValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[6]);
            AlminValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[7]);
            AtmaxValueArrayItem.Values.Add(AValue);

            AValue := FortranStrToFloat(Splitter[8]);
            AtminValueArrayItem.Values.Add(AValue);

            if Sutra4EnergyUsed then
            begin
              AValue := FortranStrToFloat(Splitter[9]);
              SIGMASValueArrayItem.Values.Add(AValue);

              AValue := FortranStrToFloat(Splitter[10]);
              SIGMAAValueArrayItem.Values.Add(AValue);
            end;
          end;

          frmProgressMM.ProgressLabelCaption :=
            Format('%0:d out of %1:d.', [PointCount, AScreenObject.Capacity]);
          frmProgressMM.StepIt;
          Application.ProcessMessages;
        end;
      end
    finally
      ATextStream.Free;
    end;
  end;
begin
  Assert(TFile.Exists(FileName));
  LocalModel := frmGoPhast.PhastModel;
  Assert(LocalModel.ModelSelection in SutraSelection);
  Sutra4EnergyUsed := LocalModel.DoSutra4EnergyUsed(nil);
  Mesh := LocalModel.SutraMesh;

  if Mesh.MeshType = mt3D then
  begin
    SetLength(Locations, Mesh.Mesh2D.Elements.Count
      * (Mesh.LayerCount));
    for ElementIndex := 0 to Mesh.Mesh2D.Elements.Count - 1 do
    begin
      Element2D := Mesh.Mesh2D.Elements[ElementIndex];
      for LayerIndex := 0 to Mesh.LayerCount-1 do
      begin
        Element3D := Mesh.ElementArray[LayerIndex,ElementIndex];
        if Element3D.DisplayNumber > 0 then
        begin
          ElementLocation.Number := Element3D.DisplayNumber;
          ElementLocation.Location := Element2D.Center;
          ElementLocation.Z := Element3D.CenterElevation;
          Locations[Element3D.DisplayNumber-1] := ElementLocation;
        end;
      end;
    end;
  end
  else
  begin
    SetLength(Locations, Mesh.Mesh2D.Elements.Count);
    ElementLocation.Z := 0;
    for ElementIndex := 0 to Mesh.Mesh2D.Elements.Count - 1 do
    begin
      Element2D := Mesh.Mesh2D.Elements[ElementIndex];
      ElementLocation.Number := Element2D.DisplayNumber;
      ElementLocation.Location := Element2D.Center;
      Locations[ElementIndex] := ElementLocation;
    end;
  end;

  frmGoPhast.PhastModel.BeginScreenObjectUpdate;
  frmGoPhast.CanDraw := False;
  try
    ScreenObjectList := TList.Create;
    try
      ScreenObjectList.Capacity := 1;
      AScreenObject := TScreenObject.CreateWithViewDirection(
        LocalModel, vdTop, Undo2, False);
      NewDataSets := TList.Create;
      try
        ScreenObjectList.Add(AScreenObject);
        AScreenObject.Visible := False;
        AScreenObject.SetValuesOfIntersectedCells := True;
        AScreenObject.EvaluatedAt := eaBlocks;
        if Mesh.MeshType = mt3D then
        begin
          AScreenObject.ElevationCount := ecOne;
          AScreenObject.Capacity := Mesh.Mesh2D.Elements.Count
            * (Mesh.LayerCount);
          AScreenObject.ElevationFormula :=
            rsObjectImportedValuesR
            + '("' + StrImportedElevations + '")';
        end
        else
        begin
          AScreenObject.ElevationCount := ecZero;
          AScreenObject.Capacity := Mesh.Mesh2D.Elements.Count;
        end;

        try
          if Mesh.MeshType = mt3D then
          begin
            ElevationValues := AScreenObject.ImportedSectionElevations;
          end
          else
          begin
            ElevationValues := nil;
          end;

          GetDataSet('_Imported_PMAX', PMAX, PmaxValueArrayItem);

          if Mesh.MeshType = mt3D then
          begin
            GetDataSet('_Imported_PMID', PMID, PmidValueArrayItem);
          end
          else
          begin
            PMID := nil;
          end;

          GetDataSet('_Imported_PMIN', PMIN, PminValueArrayItem);

          GetDataSet('_Imported_Angle1', Angle1, Angle1ValueArrayItem);
          if Mesh.MeshType = mt3D then
          begin
            GetDataSet('_Imported_Angle2', Angle2, Angle2ValueArrayItem);
            GetDataSet('_Imported_Angle3', Angle3, Angle3ValueArrayItem);
          end
          else
          begin
            Angle2 := nil;
            Angle3 := nil;
          end;

          GetDataSet('_Imported_ALMAX', ALMAX, AlmaxValueArrayItem);

          if Mesh.MeshType = mt3D then
          begin
            GetDataSet('_Imported_ALMID', ALMID, AlmidValueArrayItem);
          end
          else
          begin
            ALMID := nil;
          end;

          GetDataSet('_Imported_ALMIN', ALMIN, AlminValueArrayItem);

          GetDataSet('_Imported_ATMAX', ATMAX, AtmaxValueArrayItem);

          if Mesh.MeshType = mt3D then
          begin
            GetDataSet('_Imported_ATMID', ATMID, AtmidValueArrayItem);
          end
          else
          begin
            ATMID := nil;
          end;

          GetDataSet('_Imported_ATMIN', ATMIN, AtminValueArrayItem);

          if Sutra4EnergyUsed then
          begin
            GetDataSet('_Imported_SIGMAS', SIGMAS, SIGMASValueArrayItem);
            GetDataSet('_Imported_SIGMAA', SIGMAA, SIGMAAValueArrayItem);
          end;

          frmProgressMM.Caption := '';
          frmProgressMM.Prefix := StrObject;
          frmProgressMM.PopupParent := frmGoPhast;
          frmProgressMM.Show;
          frmProgressMM.pbProgress.Max := AScreenObject.Capacity;
          frmProgressMM.pbProgress.Position := 0;
          frmProgressMM.ProgressLabelCaption :=
            Format('0 out of %d.', [AScreenObject.Capacity]);
          PointCount := 0;
          Splitter := TStringList.Create;
          try
            HandleTextStream(FileName);
          finally
            Splitter.Free;
          end;
        except
          AScreenObject.Free;
          raise
        end;

        Undo := TImportSutra15B.Create;
        try
          frmGoPhast.PhastModel.AddFileToArchive(FileName);
          Undo.StoreNewScreenObjects(ScreenObjectList);
          Undo.StoreNewDataSets(NewDataSets);
          frmGoPhast.UndoStack.Submit(Undo);
        except
          Undo.Free;
          raise;
        end;
      finally
        NewDataSets.Free;
      end;
    finally
      frmProgressMM.Hide;
      ScreenObjectList.Free;
      frmGoPhast.CanDraw := True;
      frmGoPhast.PhastModel.EndScreenObjectUpdate;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure ImportInitConditions(const FileName: string);
var
  LocalModel: TPhastModel;
  Mesh: TSutraMesh3D;
  Locations: TNELocationArray;
  DataType: string;
  ScreenObjectList: TList;
  AScreenObject: TScreenObject;
  NewDataSets: TList;
  InitialValue: TDataArray;
  Position: Integer;
  InitialValueArrayItem: TValueArrayItem;
  PointCount: Integer;
  Undo: TImportSutraInitConditions;
  Splitter: TStringList;
  ALine: string;
  NodeNumber: Integer;
  Z: double;
  Value: Double;
  Undo2: TCustomUndo;
  Elevations: TValueArrayStorage;
  procedure HandleFileStream(FileName: string);
  var
    TextStream: TStreamReader;
  begin
    TextStream := TFile.OpenText(FileName);
    try
      while not TextStream.EndOfStream do
      begin
        ALine := TextStream.ReadLine;
        if (ALine = '') or (ALine[1] = '#') then
        begin
          Continue;
        end;
        Splitter.DelimitedText := ALine;
//        Assert(Splitter.Count >= 3);
        if UpperCase(Splitter[0]) = '@INSERT' then
        begin
          TDirectory.SetCurrentDirectory(ExtractFilePath(FileName));
          HandleFileStream(ExpandFileName(Splitter[2]));
        end
        else
        begin
          NodeNumber := PointCount;
          Z := Locations[PointCount].Z;
          Value := FortranStrToFloat(Splitter[0]);
          Inc(PointCount);

          AScreenObject.AddPoint(Locations[NodeNumber].Location, True);
          if Elevations <> nil then
          begin
            Elevations.Add(Z);
          end;
          InitialValueArrayItem.Values.Add(Value);


          frmProgressMM.ProgressLabelCaption :=
            Format('%0:d out of %1:d.', [PointCount, AScreenObject.Capacity]);
          frmProgressMM.StepIt;
          Application.ProcessMessages;
        end;
      end;
    finally
      TextStream.Free;
    end
  end;
begin
  Assert(TFile.Exists(FileName));
  LocalModel := frmGoPhast.PhastModel;
  Assert(LocalModel.ModelSelection in SutraSelection);
  Mesh := LocalModel.SutraMesh;

  GetNodeLocations(Locations);

  frmGoPhast.PhastModel.BeginScreenObjectUpdate;
  frmGoPhast.CanDraw := False;
  try
    ScreenObjectList := TList.Create;
    try
      ScreenObjectList.Capacity := 1;
      AScreenObject := TScreenObject.CreateWithViewDirection(
        LocalModel, vdTop, Undo2, False);
      NewDataSets := TList.Create;
      try
        ScreenObjectList.Add(AScreenObject);
        AScreenObject.Visible := False;
        AScreenObject.SetValuesOfIntersectedCells := True;
        AScreenObject.EvaluatedAt := eaNodes;
        if Mesh.MeshType = mt3D then
        begin
          AScreenObject.ElevationCount := ecOne;
          AScreenObject.Capacity := Mesh.Mesh2D.Nodes.Count
            * (Mesh.LayerCount + 1);
          AScreenObject.ElevationFormula :=
            rsObjectImportedValuesR
            + '("' + StrImportedElevations + '")';
        end
        else
        begin
          AScreenObject.ElevationCount := ecZero;
          AScreenObject.Capacity := Mesh.Mesh2D.Nodes.Count;
        end;

        try
          DataType := Copy(ExtractFileExt(FileName), 2, MAXINT);
          MakeNewDataSet(NewDataSets, '_Imported_' + DataType,
            StrModelResults + StrModelFeatures + '|' + 'imported from SUTRA Data Set initial condition file',
            FileName, eaNodes, InitialValue);

          Position := AScreenObject.AddDataSet(InitialValue);
          InitialValueArrayItem := AScreenObject.ImportedValues.Add;
          InitialValueArrayItem.Name :=  InitialValue.Name;
          InitialValueArrayItem.Values.DataType := rdtDouble;
          AScreenObject.DataSetFormulas[Position]
            := rsObjectImportedValuesR + '("' + InitialValueArrayItem.Name + '")';


          if Mesh.MeshType <> mt3D then
          begin
            Elevations := nil;
          end
          else
          begin
            Elevations := AScreenObject.ImportedSectionElevations;
          end;

          frmProgressMM.Caption := '';
          frmProgressMM.Prefix := StrObject;
          frmProgressMM.PopupParent := frmGoPhast;
          frmProgressMM.Show;
          frmProgressMM.pbProgress.Max := AScreenObject.Capacity;
          frmProgressMM.pbProgress.Position := 0;
          frmProgressMM.ProgressLabelCaption :=
            Format('0 out of %d.', [AScreenObject.Capacity]);
          PointCount := 0;
          Splitter := TStringList.Create;
          try
            HandleFileStream(FileName);
          finally
            Splitter.Free;
          end;
        except
          AScreenObject.Free;
          raise
        end;

        Undo := TImportSutraInitConditions.Create;
        try
          frmGoPhast.PhastModel.AddFileToArchive(FileName);
          Undo.StoreNewScreenObjects(ScreenObjectList);
          Undo.StoreNewDataSets(NewDataSets);
          frmGoPhast.UndoStack.Submit(Undo);
        except
          Undo.Free;
          raise;
        end;
      finally
        NewDataSets.Free;
      end;
    finally
      frmProgressMM.Hide;
      ScreenObjectList.Free;
      frmGoPhast.CanDraw := True;
      frmGoPhast.PhastModel.EndScreenObjectUpdate;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.message, mtError, [mbOK], 0);
    end;
  end

end;


{ TImportSutra14B }

function TImportSutra14B.Description: string;
begin
  result := 'import SUTRA data set 14B generated by PEST';
end;

{ TImportSutra15B }

function TImportSutra15B.Description: string;
begin
  result := 'import SUTRA data set 15B generated by PEST';
end;

{ TImportSutraInitConditions }

function TImportSutraInitConditions.Description: string;
begin
  result := 'import SUTRA initial conditions generated by PEST';
end;

end.
