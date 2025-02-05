unit ModflowSfr6WriterUnit;

interface

uses Windows, Types, SysUtils, Classes, Contnrs, Forms, CustomModflowWriterUnit,
  ModflowPackageSelectionUnit, PhastModelUnit, System.Generics.Collections,
  ScreenObjectUnit, ModflowSfr6Unit, ModflowBoundaryDisplayUnit,
  Modflow6ObsUnit, IntListUnit, System.UITypes;

type
  TSfr6Observation = record
    FName: string;
    FBoundName: string;
    FReachStart: Integer;
    FCount: Integer;
    FObsTypes: TSfrObs;
    FSfrObsLocation: TSfrObsLocation;
    FModflow6Obs: TModflow6Obs;
  end;
  TSfr6ObservationList = TList<TSfr6Observation>;
  
  TSft6Observation = record
    FName: string;
    FBoundName: string;
    FReachStart: Integer;
    FCount: Integer;
    FObsTypes: TSftObs;
    FSfrObsLocation: TSfrObsLocation;
    FSpecies: Integer;
    FModflow6Obs: TModflow6Obs;
  end;
  TSft6ObservationList = TList<TSft6Observation>;
  TSft6ObservationLists = TObjectList<TSft6ObservationList>;

  TSfr6Segment = class(TObject)
  private
    FModel: TCustomModel;
    FReaches: TList;
    FSteadyValues: TSfrMF6ConstArray;
    FSfr6Boundary: TSfrMf6Boundary;
    FScreenObject: TScreenObject;
    FReachCount: Integer;
    procedure SetReachCount(const Value: Integer);
    function GetFirst: TSfrMF6ConstantRecord;
    function GetLast: TSfrMF6ConstantRecord;
    procedure SetFirst(const Value: TSfrMF6ConstantRecord);
    procedure SetLast(const Value: TSfrMF6ConstantRecord);
    procedure EliminateInactiveReaches;
    procedure AssignReachNumbers(var StartingNumber: Integer);
  public
    constructor Create(Model: TCustomModel);
    destructor Destroy; override;
    property ReachCount: Integer read FReachCount write SetReachCount;
    property SteadyValues: TSfrMF6ConstArray read FSteadyValues
      write FSteadyValues;
    property First: TSfrMF6ConstantRecord read GetFirst write SetFirst;
    property Last: TSfrMF6ConstantRecord read GetLast write SetLast;
    property ScreenObject: TScreenObject read FScreenObject;
  end;

  TSfr6SegmentList = TObjectList<TSfr6Segment>;

  TModflowSFR_MF6_Writer = class(TCustomPackageWriter)
  private
    FValues: TList;
    FSegments: TSfr6SegmentList;
    FReachCount: integer;
    FDiversionCount: Integer;
    FObsList: TSfr6ObservationList;
    FGwtObservations: TSft6ObservationLists;
    FDirectObsLines: TStrings;
    FFileNameLines: TStrings;
    FCalculatedObsLines: TStrings;
    FSpeciesIndex: Integer;
    FDiversionReaches: TIntegerList;
    FCrossSectionDictionary: TDictionary<TSfr6CrossSection, string>;
    procedure Evaluate;
    procedure EvaluateSteadyData;
    procedure AssignSteadyData(ASegment: TSfr6Segment);
    procedure AssignConnections;
    procedure WriteOptions;
    procedure WriteDimensions;
    procedure WritePackageData;
    procedure WriteCrossSections;
    procedure WriteACrossSection(CrossSection: TSfr6CrossSection;
      const FileName: string; ScreenObject: TScreenObject);
    procedure WriteConnections;
    procedure WriteDiversions;
    procedure WriteInitialStages;
    procedure WriteStressPeriods;
    procedure InternalUpdateDisplay(TimeLists: TModflowBoundListOfTimeLists);
    procedure WriteFileInternal;
    procedure WriteAdditionalAuxVariables;
    // SFT
    procedure WriteGwtOptions;
    procedure WriteGwtPackageData;
    procedure WriteGwtStressPeriods;
    procedure WriteGwtFileInternal;
//    // Check that stage decreases in the downstream direction.
//    procedure CheckStage;
  protected
    function Package: TModflowPackageSelection; override;
    function IsMf6Observation(AScreenObject: TScreenObject): Boolean;
    function IsMf6GwtObservation(AScreenObject: TScreenObject; SpeciesIndex: Integer): Boolean;
    function ObservationsUsed: Boolean;
    class function ObservationExtension: string;
    class function GwtObservationExtension: string;
  public
    Constructor Create(Model: TCustomModel; EvaluationType: TEvaluationType); override;
    destructor Destroy; override;
    procedure WriteFile(const AFileName: string);
    procedure WriteSftFile(const AFileName: string; SpeciesIndex: Integer);
    procedure UpdateDisplay(TimeLists: TModflowBoundListOfTimeLists);
    procedure UpdateSteadyData;
    property DirectObsLines: TStrings read FDirectObsLines write FDirectObsLines;
    property CalculatedObsLines: TStrings read FCalculatedObsLines write FCalculatedObsLines;
    property FileNameLines: TStrings read FFileNameLines write FFileNameLines;
    class function ObservationOutputExtension: string;
    class function Extension: string; override;
  end;

const
  StrSfrFlowPackageName = 'SFR-1';

implementation

uses
  frmErrorsAndWarningsUnit, GoPhastTypes, frmProgressUnit,
  RbwParser, GIS_Functions, DataSetUnit, frmFormulaErrorsUnit, ModflowCellUnit,
  Modflow6ObsWriterUnit,
  ModflowMvrWriterUnit, ModflowMvrUnit, ModflowIrregularMeshUnit, FastGEO,
  Vcl.Dialogs, ModflowParameterUnit, Mt3dmsChemSpeciesUnit,
  Mt3dmsChemUnit, GwtStatusUnit, DataSetNamesUnit, CellLocationUnit;

resourcestring
  StrTheFollowingPairO = 'The following pair of objects have the same SFR se' +
  'gment numbers. Reach connections can not be assigned correctly unless ' +
  'each segment has a unique segment number';
  StrSegmentNumber0d = 'Segment number: %0:d; Objects: %1:s, %2:s';
  StrTheFollowingObject = 'The following objects define a downstream connect' +
  'ion to another segment that does not exist.';
  StrObject0sInvali = 'Object: %0:s; Invalid Downstream Segment %1:d';
  StrTheFollowingObjectDiv = 'The following objects define a diversion from ' +
  'another segment that does not exist.';
  StrAllReachesInASeg = 'All reaches in a segment except the first are autom' +
  'atically assigned an upstream fraction of 1.';
  StrNoReaches = 'The following objects do not define any reaches ' +
  'in the SFR package.';
  StrAboveTop = 'The stage is above the cell top and may be ignored by ' +
    'MODFLOW 6 in the following SFR reaches (Layer, Row, Column, Object)';
  StrBelowBottom = 'The stage is below the cell bottom and may be ignored by ' +
    'MODFLOW 6 in the following SFR reaches';
  StrWritingSFROPTION = '  Writing SFR OPTIONS';
  StrWritingSFRDimens = '  Writing SFR Dimensions';
  StrWritingSFRPackag = '  Writing SFR Package Data';
  StrWritingSFRConnec = '  Writing SFR Connections';
  StrWritingSFRDivers = '  Writing SFR Diversions';
  StrWritingSFRStress = '  Writing SFR Stress Periods';
  StrWritingSFRStre = '    Writing SFR Stress Period %d';
  StrStreamStatusIn = 'Stream Status in %s';
  StrReachNumberIn = 'Reach Number in %s';
  StrInvalidResultType = 'Invalid result type.';
  StrReachLength = 'Reach Length';
  StrReachWidth = 'Reach Width';
  StrGradient = 'Gradient';
  StrStreambedTop = 'Streambed Top';
  StrStreambedThickness = 'Streambed Thickness';
  StrHydraulicConductivi = 'Hydraulic Conductivity';
  StrRoughness = 'Roughness';
  StrUpstreamFraction = 'Upstream Fraction';
  StrStreambedTopElevat = 'Streambed top elevation increases in the downstre' +
  'am direction';
  StrIn0sAtLayer = 'In %0:s, at Layer: %1:d; Row: %2:d, Column: %3:d';
  StrIn0sAtLayerCell = 'In %0:s, at Layer: %1:d; Cell: %2:d';
  StrTheRoughnessIsLes = 'The roughness is less then or equal to zero in the' +
  ' following SFR reaches';
  StrDownstreamSFRSegme = 'Downstream SFR segment separated from upstream SF' +
  'R segment';
  StrTheDownstreamEndDisv = 'The downstream end of the segment defined by "%' +
  '0:s" in cell %1:d is separated from the upstream end of the segment defin' +
  'ed by %2:s in cell %3:d by %4:g.';
  StrTheDownstreamEndGrid = 'The downstream end of the segment defined by "%' +
  '0:s" in (Row,Col) (%1:d, %2:d) is separated from the upstream end of the ' +
  'segment defined by %3:s in (%4:d, %5:d) by %6:d cells.';
  StrSFRUpstreamValues = 'SFR Upstream Values do not add up to 1';
  StrTheSumOfTheUpstr = 'The sum of the upstream factions in stress period %' +
  '0:d in active downstream reaches does not add up to 1 in reach number %1:' +
  'd defined by %2:s. the downstream segments for this reach are defined by ' +
  'the following Objects. %3:s';
  StrErrorAssigningDive = 'Error assigning diversions';
  StrIn0sTheDiversio = 'In %0:s the diversion segment number in SFR is the s' +
  'ame of the segment itself. The diversion segment number should be the num' +
  'ber of a different segment from which flow is diverted.';
  StrTheStreambedMinusThe = 'The streambed top minus the streambed thickness is below th' +
  'e cell bottom in the following SFR reaches';
  StrLayerRowColumnNameStreambed = '[Layer, Row, Column, Object, Streambed top, S' +
  'treambed Thickness, Cell Bottom: %0:d, %1:d, %2:d, %3:s, %4:g, %5:g, %6:g';
  StrStreamTimeExtended = 'Stream time extended';
  StrIn0sTheLastDe = 'In %0:s, the last defined time was %1:g which was befo' +
  're the end of the model. It has been extended to %2:g';
  StrInactiveStreamPeri = 'Inactive stream period added';
  StrInSTheStarting = 'In %s, the starting time for the stream was after the' +
  ' start of the model. An inactive stream period has been added to cover th' +
  'at time.';
  StrIn0sThereWasA = 'In %0:s, there was a gap in time from %1:g to %2:g. An' +
  ' inactive period has been inserted to fill that time.';
  StrTheSFRSegmentDefi = 'The SFR segment defined by %s doesn''t appear to i' +
  'ntersect any active cells.';
  StrStartingConcentratio = 'StartingConcentration_%s';
  StrDivideByZeroInSF = 'Divide by zero in SFR package';
  StrInvalidMinimumCros = 'Invalid minimum cross section height';
  StrTheMinimumHeightI = 'The minimum height in any SFR cross section must b' +
  'e zero. This isn''t true in %s.';
  StrUndefinedLengthUni = 'Undefined length unit';
  StrWhenTheSFRPackageLength = 'When the SFR package is used, you must speci' +
  'fy the length unit so that LENGTH_CONVERSION can be specified correctly';
  StrUndefinedTimeUnit = 'Undefined time unit';
  StrWhenTheSFRPackageTime = 'When the SFR package is used, you must specify' +
  ' the time unit so that TIME_CONVERSION can be specified correctly';
  StrNoActiveSFRDownst = 'No active SFR downstream reaches';
  StrTheDownstreamReach = 'The downstream reaches of %s are all inactive in ' +
  'stress period %d.';
  StrInitialStage = 'Initial Stage';
  StrDiversionSegmentAl = 'Diversion segment also listed as downstream segme' +
  'nt';
  StrIn0s1dIsLis = 'In %0:s, %1:d is listed as both a downstream segment and' +
  ' diversion segment.';
  StrDummyAssignmentOut = 'dummy assignment outside of model area';
  StrInvalidUseOfADat = 'Invalid use of a data set in formula for an SFR obj' +
  'ect outside the grid.';
  StrInvalidDataArrayI = 'Invalid data array in formula for an SFR object ou' +
  'tside the grid.';
  StrObject0sFormu = 'Object = %0:s; Formual = %1:s';
  StrTopAboveStage = 'In the SFR package, the stream top is above the initial stream stage';
  StrObject0sLayerDisv = 'Object: %0:s; (Layer, Cell): (%1:d, %2:d); Stream top:' +
  ' %3:g; Initial Stage: %4:g';
  StrObject0sLayer = 'Object: %0:s; (Layer, Row, Column): (%1:d, %2:d, %3:d)' +
  '; Stream top: %4:g; Initial Stage: %5:g';

{ TModflowSFR_MF6_Writer }

procedure TModflowSFR_MF6_Writer.AssignConnections;
var
  SegmentDictionary: TDictionary<Integer, TSfr6Segment>;
  SegIndex: Integer;
  ASegment: TSfr6Segment;
  OtherSegment: TSfr6Segment;
  ReachIndex: Integer;
  AReach: TSfrMF6ConstantRecord;
  PriorReach: TSfrMF6ConstantRecord;
  ConnectedIndex: Integer;
  DownstreamSegmentNumber: Integer;
  NewLength: Integer;
  OtherReach: TSfrMF6ConstantRecord;
  DiversionIndex: Integer;
  ADiversionSegIndex: Integer;
  ADiversion: TSDiversionItem;
  NeighborCells: Boolean;
  Cell2D1: TModflowIrregularCell2D;
  Cell2D2: TModflowIrregularCell2D;
  SeparationDistance: double;
  CellDistance: Integer;
  DivSeg: Integer;
  procedure CheckConnectionError;
  begin
    if AReach.Cell <> OtherReach.Cell then
    begin
      if Model.DisvUsed then
      begin
        Cell2D1 := Model.DisvGrid.TwoDGrid.Cells[AReach.Cell.Column];
        Cell2D2 := Model.DisvGrid.TwoDGrid.Cells[OtherReach.Cell.Column];
        NeighborCells :=  (Cell2D1 = Cell2D2) or Cell2D1.IsNeighbor(Cell2D2);
        if not NeighborCells then
        begin
          SeparationDistance := Distance(Cell2D1.Location, Cell2D2.Location);
          frmErrorsAndWarnings.AddWarning(Model,
            StrDownstreamSFRSegme, Format(StrTheDownstreamEndDisv,
            [ASegment.FScreenObject.Name, AReach.Cell.Column+1,
            OtherSegment.FScreenObject.Name, OtherReach.Cell.Column+1,
            SeparationDistance]),
            OtherSegment.FScreenObject)
        end;
      end
      else
      begin
        NeighborCells := (Abs(AReach.Cell.Column - OtherReach.Cell.Column) <= 1)
          and (Abs(AReach.Cell.Row - OtherReach.Cell.Row) <= 1);
        if not NeighborCells then
        begin
          CellDistance := Abs(AReach.Cell.Column - OtherReach.Cell.Column)
            + Abs(AReach.Cell.Row - OtherReach.Cell.Row);
          frmErrorsAndWarnings.AddWarning(Model,
            StrDownstreamSFRSegme, Format(StrTheDownstreamEndGrid,
            [ASegment.FScreenObject.Name, AReach.WarningCell.Row+1, AReach.WarningCell.Column+1,
            OtherSegment.FScreenObject.Name, OtherReach.WarningCell.Row+1, OtherReach.WarningCell.Column+1,
            CellDistance]),
            OtherSegment.FScreenObject)
        end;
      end;
    end
  end;
begin
  SegmentDictionary := TDictionary<Integer, TSfr6Segment>.Create;
  try
    FDiversionCount := 0;
    for SegIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegIndex];
      if SegmentDictionary.TryGetValue(ASegment.FSfr6Boundary.SegmentNumber,
        OtherSegment) then
      begin
        frmErrorsAndWarnings.AddError(Model, StrTheFollowingPairO,
          Format(StrSegmentNumber0d,
          [ASegment.FSfr6Boundary.SegmentNumber, ASegment.FScreenObject.Name,
          OtherSegment.FScreenObject.Name]), ASegment.FScreenObject);
      end
      else
      begin
        SegmentDictionary.Add(ASegment.FSfr6Boundary.SegmentNumber, ASegment);
      end;

      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        AReach := ASegment.SteadyValues[ReachIndex];
        if Length(ASegment.SteadyValues) > 1 then
        begin
          // Assign connections for reaches that are part of the same segment.
          if ReachIndex = 0 then
          begin
            SetLength(ASegment.SteadyValues[ReachIndex].ConnectedReaches, 1);
            ASegment.SteadyValues[ReachIndex].ConnectedReaches[0] := -(AReach.ReachNumber+1);
          end
          else if ReachIndex = Length(ASegment.SteadyValues) - 1 then
          begin
            SetLength(ASegment.SteadyValues[ReachIndex].ConnectedReaches, 1);
            ASegment.SteadyValues[ReachIndex].ConnectedReaches[0] := AReach.ReachNumber-1;
          end
          else
          begin
            SetLength(ASegment.SteadyValues[ReachIndex].ConnectedReaches, 2);
            ASegment.SteadyValues[ReachIndex].ConnectedReaches[0] := AReach.ReachNumber-1;
            ASegment.SteadyValues[ReachIndex].ConnectedReaches[1] := -(AReach.ReachNumber+1);
          end;
        end
        else
        begin
          SetLength(ASegment.SteadyValues[ReachIndex].ConnectedReaches, 0);
        end;
        if ReachIndex > 0 then
        begin
          if PriorReach.StreambedTop < AReach.StreambedTop then
          begin
            if Model.DisvUsed then
            begin
              frmErrorsAndWarnings.AddWarning(Model, StrStreambedTopElevat,
                Format(StrIn0sAtLayerCell,
                [ASegment.FScreenObject.name, AReach.WarningCell.Layer+1,
                AReach.WarningCell.Column+1]), ASegment.FScreenObject);
            end
            else
            begin
              frmErrorsAndWarnings.AddWarning(Model, StrStreambedTopElevat,
                Format(StrIn0sAtLayer,
                [ASegment.FScreenObject.name, AReach.WarningCell.Layer+1, AReach.WarningCell.Row+1,
                AReach.WarningCell.Column+1]), ASegment.FScreenObject);
            end;
          end;
        end;
        PriorReach := AReach;
      end;
    end;
    for SegIndex := 0 to FSegments .Count - 1 do
    begin
      ASegment := FSegments[SegIndex];

      for DiversionIndex := 0 to ASegment.FSfr6Boundary.Diversions.Count - 1 do
      begin
        DivSeg := ASegment.FSfr6Boundary.Diversions[DiversionIndex].DownstreamSegment;
        if ASegment.FSfr6Boundary.DownstreamSegments.IndexOf(DivSeg) >= 0 then
        begin
          frmErrorsAndWarnings.AddError(Model, StrDiversionSegmentAl,
            Format(StrIn0s1dIsLis,
            [ASegment.FScreenObject.Name, DivSeg]),  ASegment.FScreenObject);
        end;
      end;

      for ConnectedIndex := 0 to
        ASegment.FSfr6Boundary.DownstreamSegments.Count - 1 do
      begin
        DownstreamSegmentNumber := ASegment.FSfr6Boundary.
          DownstreamSegments[ConnectedIndex].Value;
        if SegmentDictionary.TryGetValue(DownstreamSegmentNumber,
          OtherSegment) then
        begin
          if (ASegment.ReachCount > 0) and (OtherSegment.ReachCount > 0) then
          begin
            AReach := ASegment.Last;
            OtherReach := OtherSegment.First;
            if OtherReach.StreambedTop > AReach.StreambedTop then
            begin
              if Model.DisvUsed then
              begin
                frmErrorsAndWarnings.AddWarning(Model, StrStreambedTopElevat,
                  Format(StrIn0sAtLayerCell,
                  [ASegment.FScreenObject.name, AReach.WarningCell.Layer+1,
                  AReach.WarningCell.Column+1]), ASegment.FScreenObject);
              end
              else
              begin
                frmErrorsAndWarnings.AddWarning(Model, StrStreambedTopElevat,
                  Format(StrIn0sAtLayer,
                  [ASegment.FScreenObject.name, AReach.WarningCell.Layer+1, AReach.WarningCell.Row+1,
                  AReach.WarningCell.Column+1]), ASegment.FScreenObject);
              end;
            end;

            CheckConnectionError;

            NewLength := Length(AReach.ConnectedReaches) + 1;
            SetLength(AReach.ConnectedReaches, NewLength);
            AReach.ConnectedReaches[NewLength-1] := -OtherReach.ReachNumber;
            ASegment.SteadyValues[Length(ASegment.SteadyValues)-1] := AReach;

            NewLength := Length(OtherReach.ConnectedReaches) + 1;
            SetLength(OtherReach.ConnectedReaches, NewLength);
            OtherReach.ConnectedReaches[NewLength-1] := AReach.ReachNumber;
            OtherSegment.SteadyValues[0] := OtherReach;
          end
          else
          begin
            if ASegment.ReachCount = 0 then
            begin
              frmErrorsAndWarnings.AddWarning(Model, StrNoReaches,
                ASegment.FScreenObject.Name, ASegment.FScreenObject);
            end;
            if OtherSegment.ReachCount = 0 then
            begin
              frmErrorsAndWarnings.AddWarning(Model, StrNoReaches,
                OtherSegment.FScreenObject.Name, OtherSegment.FScreenObject);
            end;
          end;
        end
        else
        begin
          frmErrorsAndWarnings.AddError(Model, StrTheFollowingObject,
            Format(StrObject0sInvali,
            [ASegment.FScreenObject.Name, DownstreamSegmentNumber]),
            ASegment.FScreenObject);
        end;
      end;
      for DiversionIndex := 0 to ASegment.FSfr6Boundary.Diversions.Count - 1 do
      begin
        ADiversion := ASegment.FSfr6Boundary.Diversions[DiversionIndex];
        Inc(FDiversionCount);
//        ADiversion.DiversionNumber := FDiversionCount;
        ADiversionSegIndex := ADiversion.DownstreamSegment;
        if SegmentDictionary.TryGetValue(ADiversionSegIndex, OtherSegment) then
        begin
          if OtherSegment = ASegment then
          begin
            frmErrorsAndWarnings.AddError(Model, StrErrorAssigningDive,
              Format(StrIn0sTheDiversio,
              [(ASegment.FScreenObject as TScreenObject).Name]),
              ASegment.FScreenObject);
//            Continue;
          end;
          if (ASegment.ReachCount > 0) and (OtherSegment.ReachCount > 0) then
          begin
            AReach := ASegment.Last;
            OtherReach := OtherSegment.First;
            FDiversionReaches.AddUnique(OtherReach.ReachNumber);
            if not AReach.IsConnected(-OtherReach.ReachNumber) then
            begin
              NewLength := Length(AReach.ConnectedReaches)+1;
              SetLength(AReach.ConnectedReaches, NewLength);
              AReach.ConnectedReaches[NewLength-1] := -OtherReach.ReachNumber;
              ASegment.Last := AReach;
            end;
            if not OtherReach.IsConnected(AReach.ReachNumber) then
            begin
              NewLength := Length(OtherReach.ConnectedReaches)+1;
              SetLength(OtherReach.ConnectedReaches, NewLength);
              OtherReach.ConnectedReaches[NewLength-1] := AReach.ReachNumber;
              OtherSegment.First := OtherReach;
            end;
            if OtherReach.StreambedTop > AReach.StreambedTop then
            begin
              if Model.DisvUsed then
              begin
                frmErrorsAndWarnings.AddWarning(Model, StrStreambedTopElevat,
                  Format(StrIn0sAtLayerCell,
                  [ASegment.FScreenObject.name, AReach.WarningCell.Layer+1,
                  AReach.WarningCell.Column+1]), ASegment.FScreenObject);
              end
              else
              begin
                frmErrorsAndWarnings.AddWarning(Model, StrStreambedTopElevat,
                  Format(StrIn0sAtLayer,
                  [ASegment.FScreenObject.name, AReach.WarningCell.Layer+1, AReach.WarningCell.Row+1,
                  AReach.WarningCell.Column+1]), ASegment.FScreenObject);
              end;
            end;

            CheckConnectionError;
          end
          else
          begin
            if ASegment.ReachCount = 0 then
            begin
              frmErrorsAndWarnings.AddWarning(Model, StrNoReaches,
                ASegment.FScreenObject.Name, ASegment.FScreenObject);
            end;
            if OtherSegment.ReachCount = 0 then
            begin
              frmErrorsAndWarnings.AddWarning(Model, StrNoReaches,
                OtherSegment.FScreenObject.Name, OtherSegment.FScreenObject);
            end;
          end;
        end
        else
        begin
          frmErrorsAndWarnings.AddError(Model, StrTheFollowingObjectDiv,
            Format(StrObject0sInvali, [ASegment.FScreenObject.Name]),
            ASegment.FScreenObject);
        end;
      end;
    end;
  finally
    SegmentDictionary.Free;
  end;
end;

procedure TModflowSFR_MF6_Writer.AssignSteadyData(ASegment: TSfr6Segment);
var
  Compiler: TRbwParser;
  CellList: TCellAssignmentList;
  Formula: string;
  Expression: TExpression;
  ACell: TCellAssignment;
  CellIndex: Integer;
  UseList: TStringList;
  VarIndex: Integer;
  ADataSet: TDataArray;
  ResultTypeOK: Boolean;
  TempFormula: string;
  VariablePositions: array of Integer;
  DataSetIndexes: array of Integer;
  VarName: string;
  VarPosition: Integer;
  DataSetIndex: Integer;
  LayerToUse: Integer;
  RowToUse: Integer;
  ColToUse: Integer;
  Variable: TCustomValue;
  PropertyName: string;
  AnnotationString: string;
  PropertyNames: TStringList;
  PropertyFormulas: TStringList;
  FormulaIndex: Integer;
  CellValues: TSfrMF6ConstantRecord;
  CellBottom: Double;
  Param: TModflowSteadyParameter;
  PestParamName: string;
  DataArray: TDataArray;
  StartingConcentrations: TStringConcCollection;
  FormulaItem: TStringConcValueItem;
  SpeciesIndex: Integer;
  Species: TMobileChemSpeciesItem;
  SpeciesCount: Integer;
  OutsideGridCell: Boolean;
begin
  OutsideGridCell := False;
  CellList := TCellAssignmentList.Create;
  UseList := TStringList.Create;
  PropertyNames := TStringList.Create;
  PropertyFormulas := TStringList.Create;
  try
    PropertyNames.Add(StrReachLength);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.ReachLength);
    PropertyNames.Add(StrReachWidth);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.ReachWidth);
    PropertyNames.Add(StrGradient);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.Gradient);
    PropertyNames.Add(StrStreambedTop);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.StreambedTop);
    PropertyNames.Add(StrStreambedThickness);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.StreambedThickness);
    PropertyNames.Add(StrHydraulicConductivi);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.HydraulicConductivity);
    PropertyNames.Add(StrInitialStage);
    PropertyFormulas.Add(ASegment.FSfr6Boundary.InitialStage);

    SpeciesCount := 0;
    if Model.GwtUsed then
    begin
      SpeciesCount := Model.MobileComponents.Count;
      StartingConcentrations := ASegment.FSfr6Boundary.StartingConcentrations;
      while StartingConcentrations.Count < Model.MobileComponents.Count do
      begin
        FormulaItem := StartingConcentrations.Add;
        FormulaItem.Value := '0.';
      end;

      for SpeciesIndex := 0 to Model.MobileComponents.Count - 1 do
      begin
        Species := Model.MobileComponents[SpeciesIndex];
        PropertyNames.Add(Format(StrStartingConcentratio, [Species.Name]));
        PropertyFormulas.Add(StartingConcentrations[SpeciesIndex].Value);
      end;
    end;

    Compiler := Model.rpThreeDFormulaCompiler;

    ASegment.FScreenObject.GetCellsToAssign('0', nil, nil, CellList,
      alAll, Model);
    if CellList.Count = 0 then
    begin
      CellList.Add(TCellAssignment.Create(0,0,0, nil, 0,
        StrDummyAssignmentOut, amIntersect));
      OutsideGridCell := True;
    end;
    ASegment.ReachCount := CellList.Count;

    for FormulaIndex := 0 to PropertyFormulas.Count - 1 do
    begin
      Formula := PropertyFormulas[FormulaIndex];
      if Formula = '' then
      begin
        Formula := '0';
      end;

      Param := Model.GetPestParameterByName(Formula);
      if Param <> nil then
      begin
        Param.IsUsedInTemplate := True;
        Formula := FortranFloatToStr(Param.Value);
        PestParamName := Param.ParameterName;
      end
      else
      begin
        DataArray := Model.DataArrayManager.GetDataSetByName(Formula);
        if OutsideGridCell and (DataArray <> nil) then
        begin
          frmErrorsAndWarnings.AddError(Model, StrInvalidUseOfADat,
            Format('%s', [ASegment.FScreenObject.Name]), ASegment.FScreenObject);
        end;
        if (DataArray <> nil) and DataArray.PestParametersUsed then
        begin
          PestParamName := DataArray.Name;
        end
        else
        begin
          PestParamName := '';
        end;
      end;

      TempFormula := Formula;
      PropertyName := PropertyNames[FormulaIndex];
      try
        Compiler.Compile(Formula);
      except  on E: ERbwParserError do
        begin
          frmFormulaErrors.AddFormulaError('', 'SFR ' + PropertyName, TempFormula, E.Message);
          Formula := '0';
          Compiler.Compile(Formula);
        end;
      end;
      Expression := Compiler.CurrentExpression;
      ResultTypeOK := Expression.ResultType in [rdtInteger, rdtDouble];
      if not ResultTypeOK then
      begin
        frmFormulaErrors.AddFormulaError('', PropertyName, TempFormula, StrInvalidResultType);
        Formula := '0';
        Compiler.Compile(Formula);
        Expression := Compiler.CurrentExpression;
      end;
      UseList.Assign(Expression.VariablesUsed);
      for VarIndex := 0 to UseList.Count - 1 do
      begin
        VarName := UseList[VarIndex];
        ADataSet := Model.DataArrayManager.GetDataSetByName(VarName);
        if ADataSet <> nil then
        begin
          ADataSet.Initialize;
          Model.DataArrayManager.AddDataSetToCache(ADataSet);
          if OutsideGridCell then
          begin
            frmErrorsAndWarnings.AddError(Model, StrInvalidDataArrayI,
              Format('%s', [ASegment.FScreenObject.Name]), ASegment.FScreenObject);
          end;
        end;
      end;

      SetLength(VariablePositions, UseList.Count);
      SetLength(DataSetIndexes, UseList.Count);
      for VarIndex := 0 to UseList.Count - 1 do
      begin
        VarName := UseList[VarIndex];
        VarPosition := Compiler.IndexOfVariable(VarName);
        VariablePositions[VarIndex] := VarPosition;
        if VarPosition >= 0 then
        begin
          DataSetIndex := Model.DataArrayManager.IndexOfDataSet(VarName);
          DataSetIndexes[VarIndex] := DataSetIndex;
        end
        else
        begin
          DataSetIndexes[VarIndex] := -1;
        end;
      end;


      for CellIndex := 0 to CellList.Count - 1 do
      begin
        ACell := CellList[CellIndex];
        if FormulaIndex = 0 then
        begin
          ASegment.FSteadyValues[CellIndex].Cell.Layer := ACell.Layer;
          ASegment.FSteadyValues[CellIndex].Cell.Row := ACell.Row;
          ASegment.FSteadyValues[CellIndex].Cell.Column := ACell.Column;
          ASegment.FSteadyValues[CellIndex].OutsideGridCell := OutsideGridCell;
          ASegment.FSteadyValues[CellIndex].StartingConcentrations.SpeciesCount := SpeciesCount;
        end;

        UpdateCurrentScreenObject(ASegment.FScreenObject);
        UpdateGlobalLocations(ACell.Column, ACell.Row, ACell.Layer,
          eaBlocks, Model);
        UpdateCurrentSegment(ACell.Segment);
        UpdateCurrentSection(ACell.Section);
        for VarIndex := 0 to UseList.Count - 1 do
        begin
          VarName := UseList[VarIndex];
          VarPosition := VariablePositions[VarIndex];
          if VarPosition >= 0 then
          begin
            Variable := Compiler.Variables[VarPosition];
            DataSetIndex := DataSetIndexes[VarIndex];
            if DataSetIndex >= 0 then
            begin
              ADataSet :=
                Model.DataArrayManager.DataSets[DataSetIndex];
              if OutsideGridCell then
              begin
                frmErrorsAndWarnings.AddError(Model, StrInvalidDataArrayI,
                  Format('%s', [ASegment.FScreenObject.Name]), ASegment.FScreenObject);
              end;
              Assert(Model = (ADataSet.Model as TCustomModel));
              Assert(ADataSet.DataType = Variable.ResultType);
              if ADataSet.Orientation = dsoTop then
              begin
                LayerToUse := 0;
              end
              else
              begin
                LayerToUse := ACell.Layer;
              end;
              if ADataSet.Orientation = dsoFront then
              begin
                RowToUse := 0;
              end
              else
              begin
                RowToUse := ACell.Row;
              end;
              if ADataSet.Orientation = dsoSide then
              begin
                ColToUse := 0;
              end
              else
              begin
                ColToUse := ACell.Column;
              end;

              case Variable.ResultType of
                rdtDouble:
                  begin
                    TRealVariable(Variable).Value :=
                      ADataSet.RealData[LayerToUse, RowToUse,
                      ColToUse];
                  end;
                rdtInteger:
                  begin
                    TIntegerVariable(Variable).Value :=
                      ADataSet.IntegerData[LayerToUse, RowToUse,
                      ColToUse];
                  end;
                rdtBoolean:
                  begin
                    TBooleanVariable(Variable).Value :=
                      ADataSet.BooleanData[LayerToUse, RowToUse,
                      ColToUse];
                  end;
                rdtString:
                  begin
                    TStringVariable(Variable).Value :=
                      ADataSet.StringData[LayerToUse, RowToUse,
                      ColToUse];
                  end;
              else
                Assert(False);
              end;
            end;
          end;
        end;
        try
          Expression.Evaluate;
          ASegment.FSteadyValues[CellIndex].BoundaryValue[FormulaIndex] := Expression.DoubleResult;
          AnnotationString := ASegment.FScreenObject.IntersectAnnotation(Formula, nil);
        except on E: EZeroDivide do
          begin
            ASegment.FSteadyValues[CellIndex].BoundaryValue[FormulaIndex] := 0;
            if AnnotationString <> E.Message then
            begin
              AnnotationString := E.Message;
            end;
            frmErrorsAndWarnings.AddWarning(Model, StrDivideByZeroInSF,
            Format(StrObject0sFormu, [ASegment.FScreenObject.Name, Formula])
             , ASegment.FScreenObject);
          end;
        end;
        ASegment.FSteadyValues[CellIndex].BoundaryAnnotation[FormulaIndex] := AnnotationString;
        ASegment.FSteadyValues[CellIndex].PestParamName[FormulaIndex] := PestParamName;

        if FormulaIndex = 0 then
        begin
          ASegment.FSteadyValues[CellIndex].BoundName := ASegment.FScreenObject.Name;
        end;
      end;
    end;

    for CellIndex := 0 to ASegment.ReachCount - 1 do
    begin
      CellValues := ASegment.FSteadyValues[CellIndex];
      CellBottom := Model.DiscretiztionElevation[
        CellValues.Cell.Column, CellValues.Cell.Row, CellValues.Cell.Layer+1];
      if CellValues.StreambedTop - CellValues.StreambedThickness < CellBottom then
      begin
        frmErrorsAndWarnings.AddError(Model, StrTheStreambedMinusThe,
          Format(StrLayerRowColumnNameStreambed, [CellValues.WarningCell.Layer+1,
          CellValues.WarningCell.Row+1, CellValues.WarningCell.Column+1, ASegment.ScreenObject.Name,
          CellValues.StreambedTop, CellValues.StreambedThickness, CellBottom]),
          ASegment.ScreenObject);
      end;

      if (CellValues.PestStreambedTop = '') and (CellValues.PestInitialStage = '') then
      begin
        if CellValues.InitialStage < CellValues.StreambedTop then
        begin
          if Model.DisvUsed then
          begin
            frmErrorsAndWarnings.AddError(Model, StrTopAboveStage,
              Format(StrObject0sLayerDisv,
              [ASegment.FScreenObject.Name, CellValues.Cell.Layer+1,
              CellValues.Cell.Column+1,
              CellValues.StreambedTop, CellValues.InitialStage]),
              ASegment.FScreenObject);
          end
          else
          begin
            frmErrorsAndWarnings.AddError(Model, StrTopAboveStage,
              Format(StrObject0sLayer,
              [ASegment.FScreenObject.Name, CellValues.Cell.Layer+1,
              CellValues.Cell.Row+1, CellValues.Cell.Column+1,
              CellValues.StreambedTop, CellValues.InitialStage]),
              ASegment.FScreenObject);
          end;
        end;
      end;
    end;

  finally
    CellList.Free;
    UseList.Free;
    PropertyNames.Free;
    PropertyFormulas.Free;
  end;

end;

constructor TModflowSFR_MF6_Writer.Create(Model: TCustomModel;
  EvaluationType: TEvaluationType);
var
  index: Integer;
begin
  inherited;
  FCrossSectionDictionary := TDictionary<TSfr6CrossSection, string>.Create;
  FValues := TObjectList.Create;
  FSegments := TSfr6SegmentList.Create;
  FObsList := TSfr6ObservationList.Create;
  FGwtObservations:= TSft6ObservationLists.Create;
  DirectObsLines := Model.DirectObservationLines;
  CalculatedObsLines := Model.DerivedObservationLines;
  FileNameLines := Model.FileNameLines;
  FDiversionReaches := TIntegerList.Create;
  if Model.GwtUsed then
  begin
    for index := 0 to Model.MobileComponents.Count - 1 do
    begin
      FGwtObservations.Add(TSft6ObservationList.Create);
    end;
  end;
  FDiversionReaches.Sorted := True;
end;

destructor TModflowSFR_MF6_Writer.Destroy;
begin
  FCrossSectionDictionary.Free;
  FGwtObservations.Free;
  FDiversionReaches.Free;
  FObsList.Free;
  FSegments.Free;
  FValues.Free;
  inherited;
end;

procedure TModflowSFR_MF6_Writer.Evaluate;
var
  ScreenObjectIndex: Integer;
  ScreenObject: TScreenObject;
  Boundary: TSfrMf6Boundary;
  Dummy: TStringList;
  ASegment: TSfr6Segment;
  NextReachNumber: Integer;
  ACellList: TValueCellList;
  TimeIndex: Integer;
  CellIndex: Integer;
  ACell: TSfrMf6_Cell;
  CellBottom: Real;
  CellTop: Real;
  MfObs: TModflow6Obs;
  Obs: TSfr6Observation;
  SftObs: TSft6Observation;
  ReachStart: Integer;
  EndTime: Double;
  StartTime: Double;
  SfrMf6Item: TSfrMf6Item;
  NewItem: TSfrMf6Item;
  ItemIndex: Integer;
  Item1: TSfrMf6Item;
  Item2: TSfrMf6Item;
  SpeciesIndex: Integer;
  AStringList: TStringList;
begin
  FReachCount := 0;
  frmErrorsAndWarnings.RemoveWarningGroup(Model, NoSegmentsWarning);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrNoReaches);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrAboveTop);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrBelowBottom);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrStreambedTopElevat);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrDownstreamSFRSegme);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrStreamTimeExtended);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrInactiveStreamPeri);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrDivideByZeroInSF);

  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrTheFollowingPairO);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrTheFollowingObject);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrTheFollowingObjectDiv);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrTheRoughnessIsLes);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrErrorAssigningDive);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrTheStreambedMinusThe);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrInvalidMinimumCros);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrNoActiveSFRDownst);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrSFRUpstreamValues);
  frmErrorsAndWarnings.RemoveErrorGroup(Model, StrTopAboveStage);

  StartTime := Model.ModflowFullStressPeriods.First.StartTime;
  EndTime := Model.ModflowFullStressPeriods.Last.Endtime;

  NextReachNumber := 1;
  ReachStart := 0;
  for ScreenObjectIndex := 0 to Model.ScreenObjectCount - 1 do
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
    Boundary := ScreenObject.ModflowSfr6Boundary;
    if (Boundary = nil) or not Boundary.Used then
    begin
      Continue;
    end;
    (Boundary.Values as TSfrMf6Collection).OutsideGridCell := False;

    frmProgressMM.AddMessage(Format(StrEvaluatingS, [ScreenObject.Name]));

    SfrMf6Item := Boundary.Values.First as TSfrMf6Item;
    if SfrMf6Item.StartTime > Starttime then
    begin
      NewItem := Boundary.Values.Add as TSfrMf6Item;
      NewItem.Assign(SfrMf6Item);
      NewItem.StreamStatus := ssInactive;
      NewItem.Starttime := Starttime;
      NewItem.Endtime := SfrMf6Item.Starttime;
      NewItem.Index := 0;
      frmErrorsAndWarnings.AddWarning(Model, StrInactiveStreamPeri,
        Format(StrInSTheStarting, [ScreenObject.Name]), ScreenObject);
    end;

    SfrMf6Item := Boundary.Values.Last as TSfrMf6Item;
    if SfrMf6Item.Endtime < Endtime then
    begin
      frmErrorsAndWarnings.AddWarning(Model, StrStreamTimeExtended,
        Format(StrIn0sTheLastDe, [ScreenObject.Name, SfrMf6Item.Endtime,
        Endtime]), ScreenObject);
      SfrMf6Item.Endtime := Endtime;
    end;

    for ItemIndex := Boundary.Values.Count - 2 downto 0 do
    begin
      Item1 := Boundary.Values[ItemIndex] as TSfrMf6Item;
      Item2 := Boundary.Values[ItemIndex+1] as TSfrMf6Item;
      if Item1.EndTime < Item2.StartTime then
      begin
        NewItem := Boundary.Values.Add as TSfrMf6Item;
        NewItem.Assign(Item1);
        NewItem.StreamStatus := ssInactive;
        NewItem.Starttime := Item1.EndTime;
        NewItem.Endtime := Item2.Starttime;
        NewItem.Index := ItemIndex+1;
        frmErrorsAndWarnings.AddWarning(Model, StrInactiveStreamPeri,
          Format(StrIn0sThereWasA,
          [ScreenObject.Name, NewItem.Starttime, NewItem.Endtime]), ScreenObject);
      end;
    end;

    Dummy := TStringList.Create;
    try
      Boundary.GetCellValues(FValues, Dummy, Model, self);
      if FValues.Count > 0 then
      begin
        ASegment := TSfr6Segment.Create(Model);
        FSegments.Add(ASegment);
        ASegment.FReaches.Assign(FValues);
        try
          (FValues as TObjectList).OwnsObjects := False;
          FValues.Clear;
        finally
          (FValues as TObjectList).OwnsObjects := True;
        end;
        ASegment.FSfr6Boundary := Boundary;
        ASegment.FScreenObject := ScreenObject;
        AssignSteadyData(ASegment);
        if not (Boundary.Values  as TSfrMf6Collection).OutsideGridCell then
        begin
          ASegment.EliminateInactiveReaches;
        end;
        ASegment.AssignReachNumbers(NextReachNumber);

        for TimeIndex := 0 to ASegment.FReaches.Count - 1 do
        begin
          ACellList := ASegment.FReaches[TimeIndex];
          for CellIndex := ACellList.Count - 1 downto 0 do
          begin
            ACell := ACellList[CellIndex] as TSfrMF6_Cell;

            CellBottom := Model.DiscretiztionElevation[ACell.Column, ACell.Row, ACell.Layer+1];
            CellTop := Model.DiscretiztionElevation[ACell.Column, ACell.Row, ACell.Layer];
            if ACell.Values.Status = ssSimple then
            begin
              if ACell.Values.Stage > CellTop then
              begin
                frmErrorsAndWarnings.AddWarning(Model, StrAboveTop,
                  Format('%0:d, %1:d, %2:d, %3:s', [ACell.WarningCell.Layer+1,
                  ACell.WarningCell.Row+1, ACell.WarningCell.Column+1, ScreenObject.Name]), ScreenObject);
              end;
              if ACell.Values.Stage < CellBottom then
              begin
                frmErrorsAndWarnings.AddWarning(Model, StrBelowBottom,
                  Format('%0:d, %1:d, %2:d, %3:s', [ACell.WarningCell.Layer+1,
                  ACell.WarningCell.Row+1, ACell.WarningCell.Column+1, ScreenObject.Name]), ScreenObject);
              end;
            end;

            if ACell.Values.Roughness <= 0 then
            begin

              frmErrorsAndWarnings.AddError(Model, StrTheRoughnessIsLes,
                Format('%0:d, %1:d, %2:d, %3:s', [ACell.WarningCell.Layer+1,
                ACell.WarningCell.Row+1, ACell.WarningCell.Column+1, ScreenObject.Name]), ScreenObject);
            end;

          end;
        end;

        if ObservationsUsed and IsMf6Observation(ScreenObject) then
        begin
          MfObs := ScreenObject.Modflow6Obs;
          Obs.FName := MfObs.Name;
          Obs.FBoundName := ScreenObject.Name;
          Obs.FObsTypes := MfObs.SfrObs;
          Obs.FSfrObsLocation := MfObs.SfrObsLocation;
          Obs.FReachStart := ReachStart;
          Obs.FCount := ASegment.ReachCount;
          Obs.FModflow6Obs := MfObs;
          FObsList.Add(Obs);
        end;
        if Model.GwtUsed then
        begin
          for SpeciesIndex := 0 to Model.MobileComponents.Count -1 do
          begin
            if ObservationsUsed and IsMf6GwtObservation(ScreenObject, SpeciesIndex) then
            begin
              MfObs := ScreenObject.Modflow6Obs;
    //          SftObs.FName := MfObs.Name;
              SftObs.FBoundName := ScreenObject.Name;
              SftObs.FObsTypes := MfObs.CalibrationObservations.SftObs[SpeciesIndex];
              if SpeciesIndex in MfObs.Genus then
              begin
                SftObs.FObsTypes := SftObs.FObsTypes + MfObs.SftObs;
              end;
              SftObs.FSfrObsLocation := MfObs.SfrObsLocation;
              SftObs.FReachStart := ReachStart;
              SftObs.FCount := ASegment.ReachCount;
              SftObs.FModflow6Obs := MfObs;
              SftObs.FName := MfObs.Name + '_' + IntToStr(SpeciesIndex);
              FGwtObservations[SpeciesIndex].Add(SftObs)
            end;
          end;
        end;
        ReachStart := ReachStart + ASegment.ReachCount;
      end
      else
      begin
        frmErrorsAndWarnings.AddWarning(Model,
          NoSegmentsWarning, ScreenObject.Name, ScreenObject);
      end;
      FTimeSeriesNames.AddStrings(Boundary.Mf6TimeSeriesNames);
      while FGwtTimeSeriesNames.Count < Boundary.GwtTimeSeriesNames.Count do
      begin
        AStringList := TStringList.Create;
        AStringList.Sorted := True;
        AStringList.Duplicates := dupIgnore;
        FGwtTimeSeriesNames.Add(AStringList);
      end;
      for var GwtIndex := 0 to Boundary.GwtTimeSeriesNames.Count - 1 do
      begin
        FGwtTimeSeriesNames[GwtIndex].AddStrings(Boundary.GwtTimeSeriesNames[GwtIndex]);
      end;
    finally
      Dummy.Free;
    end;
  end;

  AssignConnections;
  FReachCount := NextReachNumber-1;
end;

procedure TModflowSFR_MF6_Writer.EvaluateSteadyData;
var
  ScreenObjectIndex: Integer;
  ScreenObject: TScreenObject;
  Boundary: TSfrMf6Boundary;
  ASegment: TSfr6Segment;
  Obs: TSfr6Observation;
  SftObs: TSft6Observation;
  MfObs: TModflow6Obs;
  ReachStart: Integer;
  SpeciesIndex: Integer;
begin
  ReachStart := 0;
  for ScreenObjectIndex := 0 to Model.ScreenObjectCount - 1 do
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
    Boundary := ScreenObject.ModflowSfr6Boundary;
    if (Boundary = nil) or not Boundary.Used then
    begin
      Continue;
    end;
    frmProgressMM.AddMessage(Format(StrEvaluatingS, [ScreenObject.Name]));

    ASegment := TSfr6Segment.Create(Model);
    FSegments.Add(ASegment);
    ASegment.FSfr6Boundary := Boundary;
    ASegment.FScreenObject := ScreenObject;
    AssignSteadyData(ASegment);

    if ObservationsUsed and IsMf6Observation(ScreenObject) then
    begin
      MfObs := ScreenObject.Modflow6Obs;
      Obs.FName := MfObs.Name;
      Obs.FBoundName := ScreenObject.Name;
      Obs.FObsTypes := MfObs.SfrObs;
      Obs.FSfrObsLocation := MfObs.SfrObsLocation;
      Obs.FReachStart := ReachStart;
      Obs.FCount := ASegment.ReachCount;
      Obs.FModflow6Obs := MfObs;
      FObsList.Add(Obs);
    end;
    if Model.GwtUsed then
    begin
      for SpeciesIndex := 0 to Model.MobileComponents.Count -1 do
      begin
        if ObservationsUsed and IsMf6GwtObservation(ScreenObject, SpeciesIndex) then
        begin
          MfObs := ScreenObject.Modflow6Obs;
    //      SftObs.FName := MfObs.Name;
          SftObs.FBoundName := ScreenObject.Name;
          SftObs.FObsTypes := MfObs.SftObs;
          SftObs.FSfrObsLocation := MfObs.SfrObsLocation;
          SftObs.FReachStart := ReachStart;
          SftObs.FCount := ASegment.ReachCount;
          SftObs.FModflow6Obs := MfObs;
          SftObs.FName := MfObs.Name + '_' + IntToStr(SpeciesIndex);
          FGwtObservations[SpeciesIndex].Add(SftObs)
        end;
  //      FSftObsLists[MfObs.GwtSpecies].Add(SftObs)
      end;
    end;
    ReachStart := ReachStart + ASegment.ReachCount;
  end;

end;

class function TModflowSFR_MF6_Writer.Extension: string;
begin
  result := '.sfr';
end;

class function TModflowSFR_MF6_Writer.GwtObservationExtension: string;
begin
  result := '.ob_sft';
end;

procedure TModflowSFR_MF6_Writer.InternalUpdateDisplay(
  TimeLists: TModflowBoundListOfTimeLists);
var
  Inflow: TModflowBoundaryDisplayTimeList;
  Rainfall: TModflowBoundaryDisplayTimeList;
  Evaporation: TModflowBoundaryDisplayTimeList;
  Runoff: TModflowBoundaryDisplayTimeList;
  UpstreamFraction: TModflowBoundaryDisplayTimeList;
  Stage: TModflowBoundaryDisplayTimeList;
  Roughness: TModflowBoundaryDisplayTimeList;
  StreamStatus: TModflowBoundaryDisplayTimeList;
  ReachNumber: TModflowBoundaryDisplayTimeList;
  Index: Integer;
  ADisplayList: TModflowBoundaryDisplayTimeList;
  SegmentIndex: Integer;
  Segment: TSfr6Segment;
  StreamStatusComment: string;
  ReachIndex: Integer;
  Reach: TSfrMf6_Cell;
  TimeIndex: Integer;
  DataArray: TModflowBoundaryDisplayDataArray;
  ReachNumberComment: string;
  ACellList: TValueCellList;
  CurrentReachNumber: Integer;
  GWT_Start: Integer;
  SpecConcList: TModflowBoundListOfTimeLists;
  RainfallConcList: TModflowBoundListOfTimeLists;
  EvapConcList: TModflowBoundListOfTimeLists;
  RunoffConcList: TModflowBoundListOfTimeLists;
  InflowfConcList: TModflowBoundListOfTimeLists;
  SpeciesIndex: Integer;
  procedure AssignReachValues;
  var
    TimeIndex: Integer;
    DataArray: TModflowBoundaryDisplayDataArray;
    SpeciesIndex: Integer;
    GwtCellData: TGwtCellData;
  begin
    Assert(Inflow.Count = 1);
    for TimeIndex := 0 to Inflow.Count - 1 do
    begin
      DataArray := Inflow[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6InflowPosition, Model],
        Reach.RealValue[SfrMf6InflowPosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to Rainfall.Count - 1 do
    begin
      DataArray := Rainfall[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6RainfallPosition, Model],
        Reach.RealValue[SfrMf6RainfallPosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to Evaporation.Count - 1 do
    begin
      DataArray := Evaporation[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6EvaporationPosition, Model],
        Reach.RealValue[SfrMf6EvaporationPosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to Runoff.Count - 1 do
    begin
      DataArray := Runoff[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6RunoffPosition, Model],
        Reach.RealValue[SfrMf6RunoffPosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to UpstreamFraction.Count - 1 do
    begin
      DataArray := UpstreamFraction[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6UpstreamFractionPosition, Model],
        Reach.RealValue[SfrMf6UpstreamFractionPosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to Stage.Count - 1 do
    begin
      DataArray := Stage[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6StagePosition, Model],
        Reach.RealValue[SfrMf6StagePosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to Roughness.Count - 1 do
    begin
      DataArray := Roughness[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(Reach.RealAnnotation[SfrMf6RoughnessPosition, Model],
        Reach.RealValue[SfrMf6RoughnessPosition, Model],
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to StreamStatus.Count - 1 do
    begin
      DataArray := StreamStatus[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(StreamStatusComment,
        Ord(Reach.Values.Status),
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for TimeIndex := 0 to ReachNumber.Count - 1 do
    begin
      DataArray := ReachNumber[TimeIndex]
        as TModflowBoundaryDisplayDataArray;
      DataArray.AddDataValue(ReachNumberComment,
        CurrentReachNumber,
        Reach.Column, Reach.Row, Reach.Layer);
    end;
    for SpeciesIndex := 0 to SpecConcList.Count - 1 do
    begin
      ADisplayList := SpecConcList[SpeciesIndex];
      for TimeIndex := 0 to ADisplayList.Count - 1 do
      begin
        DataArray := ADisplayList[TimeIndex]
          as TModflowBoundaryDisplayDataArray;
        GwtCellData := Reach.Values.SpecifiedConcentrations;
        DataArray.AddDataValue(GwtCellData.ValueAnnotations[SpeciesIndex],
          GwtCellData.Values[SpeciesIndex],
          Reach.Column, Reach.Row, Reach.Layer);
      end;
    end;
    for SpeciesIndex := 0 to RainfallConcList.Count - 1 do
    begin
      ADisplayList := RainfallConcList[SpeciesIndex];
      for TimeIndex := 0 to ADisplayList.Count - 1 do
      begin
        DataArray := ADisplayList[TimeIndex]
          as TModflowBoundaryDisplayDataArray;
        GwtCellData := Reach.Values.RainfallConcentrations;
        DataArray.AddDataValue(GwtCellData.ValueAnnotations[SpeciesIndex],
          GwtCellData.Values[SpeciesIndex],
          Reach.Column, Reach.Row, Reach.Layer);
      end;
    end;
    for SpeciesIndex := 0 to EvapConcList.Count - 1 do
    begin
      ADisplayList := EvapConcList[SpeciesIndex];
      for TimeIndex := 0 to ADisplayList.Count - 1 do
      begin
        DataArray := ADisplayList[TimeIndex]
          as TModflowBoundaryDisplayDataArray;
        GwtCellData := Reach.Values.EvapConcentrations;
        DataArray.AddDataValue(GwtCellData.ValueAnnotations[SpeciesIndex],
          GwtCellData.Values[SpeciesIndex],
          Reach.Column, Reach.Row, Reach.Layer);
      end;
    end;
    for SpeciesIndex := 0 to RunoffConcList.Count - 1 do
    begin
      ADisplayList := RunoffConcList[SpeciesIndex];
      for TimeIndex := 0 to ADisplayList.Count - 1 do
      begin
        DataArray := ADisplayList[TimeIndex]
          as TModflowBoundaryDisplayDataArray;
        GwtCellData := Reach.Values.RunoffConcentrations;
        DataArray.AddDataValue(GwtCellData.ValueAnnotations[SpeciesIndex],
          GwtCellData.Values[SpeciesIndex],
          Reach.Column, Reach.Row, Reach.Layer);
      end;
    end;
    for SpeciesIndex := 0 to InflowfConcList.Count - 1 do
    begin
      ADisplayList := InflowfConcList[SpeciesIndex];
      for TimeIndex := 0 to ADisplayList.Count - 1 do
      begin
        DataArray := ADisplayList[TimeIndex]
          as TModflowBoundaryDisplayDataArray;
        GwtCellData := Reach.Values.InflowConcentrations;
        DataArray.AddDataValue(GwtCellData.ValueAnnotations[SpeciesIndex],
          GwtCellData.Values[SpeciesIndex],
          Reach.Column, Reach.Row, Reach.Layer);
      end;
    end;
  end;
begin
  SpecConcList := TModflowBoundListOfTimeLists.Create;
  RainfallConcList := TModflowBoundListOfTimeLists.Create;
  EvapConcList := TModflowBoundListOfTimeLists.Create;
  RunoffConcList := TModflowBoundListOfTimeLists.Create;
  InflowfConcList := TModflowBoundListOfTimeLists.Create;
  try
    Inflow := TimeLists[SfrMf6InflowPosition];
    Rainfall := TimeLists[SfrMf6RainfallPosition];
    Evaporation := TimeLists[SfrMf6EvaporationPosition];
    Runoff := TimeLists[SfrMf6RunoffPosition];
    UpstreamFraction := TimeLists[SfrMf6UpstreamFractionPosition];
    Stage := TimeLists[SfrMf6StagePosition];
    Roughness := TimeLists[SfrMf6RoughnessPosition];
    StreamStatus := TimeLists[7];
    ReachNumber := TimeLists[8];
    GWT_Start:= 9;
    if Model.GwtUsed and (TimeLists.Count > GWT_Start) then
    begin
      SpecConcList.Capacity := Model.MobileComponents.Count;
      RainfallConcList.Capacity := Model.MobileComponents.Count;
      EvapConcList.Capacity := Model.MobileComponents.Count;
      RunoffConcList.Capacity := Model.MobileComponents.Count;
      InflowfConcList.Capacity := Model.MobileComponents.Count;

      for SpeciesIndex := 0 to Model.MobileComponents.Count - 1 do
      begin
        SpecConcList.Add(TimeLists[GWT_Start]);
        Inc(GWT_Start);
        RainfallConcList.Add(TimeLists[GWT_Start]);
        Inc(GWT_Start);
        EvapConcList.Add(TimeLists[GWT_Start]);
        Inc(GWT_Start);
        RunoffConcList.Add(TimeLists[GWT_Start]);
        Inc(GWT_Start);
        InflowfConcList.Add(TimeLists[GWT_Start]);
        Inc(GWT_Start);
      end;
    end;

    // check that all the time lists contain the same number of times
    // as the first one.
    for Index := 1 to TimeLists.Count - 1 do
    begin
      ADisplayList := TimeLists[Index];
      Assert(Inflow.Count = ADisplayList.Count);
    end;

    CurrentReachNumber := 1;
    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      Segment := FSegments[SegmentIndex];
      StreamStatusComment := Format(StrStreamStatusIn, [Segment.FScreenObject.Name]);
      ReachNumberComment := Format(StrReachNumberIn, [Segment.FScreenObject.Name]);

      Assert(Segment.FReaches.Count = 1);
      ACellList := Segment.FReaches[0];
      for ReachIndex := 0 to ACellList.Count -1 do
      begin
        Reach := ACellList[ReachIndex] as TSfrMf6_Cell;
        AssignReachValues;
        Inc(CurrentReachNumber);
      end;
    end;

    // Mark all the data arrays and time lists as up to date.
    for Index := 0 to TimeLists.Count - 1 do
    begin
      ADisplayList := TimeLists[Index];
      for TimeIndex := 0 to ADisplayList.Count - 1 do
      begin
        DataArray := ADisplayList[TimeIndex]
          as TModflowBoundaryDisplayDataArray;
        DataArray.UpToDate := True;
      end;
      ADisplayList.SetUpToDate(True);
    end;
  finally
    SpecConcList.Free;
    RainfallConcList.Free;
    EvapConcList.Free;
    RunoffConcList.Free;
    InflowfConcList.Free;
    Model.InvalidateAllDynamicLists;
  end;

end;

function TModflowSFR_MF6_Writer.IsMf6GwtObservation(
  AScreenObject: TScreenObject; SpeciesIndex: Integer): Boolean;
var
  MfObs: TModflow6Obs;
begin
  MfObs := AScreenObject.Modflow6Obs;
  Result := (MfObs <> nil) and MfObs.Used and (((MfObs.SftObs <> [])
    and (SpeciesIndex in MfObs.Genus))
    or (MfObs.CalibrationObservations.SftObs[SpeciesIndex] <> []) );
end;

function TModflowSFR_MF6_Writer.IsMf6Observation(
  AScreenObject: TScreenObject): Boolean;
var
  MfObs: TModflow6Obs;
begin
  MfObs := AScreenObject.Modflow6Obs;
  Result := (MfObs <> nil) and MfObs.Used and (MfObs.SfrObs <> []);
end;

class function TModflowSFR_MF6_Writer.ObservationExtension: string;
begin
  result := '.ob_sfr';
end;

class function TModflowSFR_MF6_Writer.ObservationOutputExtension: string;
begin
  result := '.ob_sfr_out';
end;

procedure TModflowSFR_MF6_Writer.WriteFileInternal;
begin
  OpenFile(FNameOfFile);
  try
    WriteTemplateHeader;

    WriteDataSet0;

    frmProgressMM.AddMessage(StrWritingSFROPTION);
    WriteOptions;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingSFRDimens);
    WriteDimensions;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingSFRPackag);
    WritePackageData;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage('Writing SFR Package Cross Sections');
    WriteCrossSections;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingSFRConnec);
    WriteConnections;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingSFRDivers);
    WriteDiversions;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage('  Writing SFR INITIALSTAGES');
    WriteInitialStages;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingSFRStress);
    WriteStressPeriods;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;
  finally
    CloseFile;
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteGwtFileInternal;
begin
  OpenFile(FNameOfFile);
  try
    WriteTemplateHeader;

    WriteDataSet0;

    WriteGwtOptions;
    WriteGwtPackageData;
    WriteGwtStressPeriods;

  finally
    CloseFile;
  end;
end;

function TModflowSFR_MF6_Writer.ObservationsUsed: Boolean;
begin
  result := (Model.ModelSelection = msModflow2015)
    and Model.ModflowPackages.Mf6ObservationUtility.IsSelected;
end;

function TModflowSFR_MF6_Writer.Package: TModflowPackageSelection;
begin
  result := Model.ModflowPackages.SfrModflow6Package;
end;

procedure TModflowSFR_MF6_Writer.UpdateDisplay(
  TimeLists: TModflowBoundListOfTimeLists);
begin
  if not Package.IsSelected then
  begin
    UpdateNotUsedDisplay(TimeLists);
    Exit;
  end;

  Evaluate;
  if not frmProgressMM.ShouldContinue then
  begin
    Exit;
  end;

  InternalUpdateDisplay(TimeLists);
end;

procedure TModflowSFR_MF6_Writer.UpdateSteadyData;
var
  ReachLengthDataArray: TModflowBoundaryDisplayDataArray;
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ReachIndex: Integer;
  ReachProp: TSfrMF6ConstantRecord;
  ReachWidthDataArray: TModflowBoundaryDisplayDataArray;
  GradientDataArray: TModflowBoundaryDisplayDataArray;
  StreambedTopDataArray: TModflowBoundaryDisplayDataArray;
  StreambedThicknessDataArray: TModflowBoundaryDisplayDataArray;
  HydraulicConductivityDataArray: TModflowBoundaryDisplayDataArray;
  InitialStageDataArray: TModflowBoundaryDisplayDataArray;
begin
  if not frmProgressMM.ShouldContinue then
  begin
    Exit;
  end;
  EvaluateSteadyData;

  ReachLengthDataArray := Model.DataArrayManager.GetDataSetByName(KReachLengthSFR)
    as TModflowBoundaryDisplayDataArray;
  ReachWidthDataArray := Model.DataArrayManager.GetDataSetByName(KReachWidthSFR6)
    as TModflowBoundaryDisplayDataArray;
  GradientDataArray := Model.DataArrayManager.GetDataSetByName(KGradientSFR6)
    as TModflowBoundaryDisplayDataArray;
  StreambedTopDataArray := Model.DataArrayManager.GetDataSetByName(KStreambedTopSFR6)
    as TModflowBoundaryDisplayDataArray;
  StreambedThicknessDataArray := Model.DataArrayManager.GetDataSetByName(KStreambedThicknessSFR6)
    as TModflowBoundaryDisplayDataArray;
  HydraulicConductivityDataArray := Model.DataArrayManager.GetDataSetByName(KHydraulicConductivitySFR6)
    as TModflowBoundaryDisplayDataArray;
  InitialStageDataArray := Model.DataArrayManager.GetDataSetByName(KInitialStageSFR6)
    as TModflowBoundaryDisplayDataArray;

  if ReachLengthDataArray <> nil then
  begin
    ReachLengthDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        ReachLengthDataArray.AddDataValue(ReachProp.ReachLengthAnnotation,
          ReachProp.ReachLength, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    ReachLengthDataArray.ComputeAverage;
    ReachLengthDataArray.UpToDate := True;
  end;

  if ReachWidthDataArray <> nil then
  begin
    ReachWidthDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        ReachWidthDataArray.AddDataValue(ReachProp.ReachWidthAnnotation,
          ReachProp.ReachWidth, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    ReachWidthDataArray.ComputeAverage;
    ReachWidthDataArray.UpToDate := True;
  end;

  if GradientDataArray <> nil then
  begin
    GradientDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        GradientDataArray.AddDataValue(ReachProp.GradientAnnotation,
          ReachProp.Gradient, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    GradientDataArray.ComputeAverage;
    GradientDataArray.UpToDate := True;
  end;

  if StreambedTopDataArray <> nil then
  begin
    StreambedTopDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        StreambedTopDataArray.AddDataValue(ReachProp.StreambedTopAnnotation,
          ReachProp.StreambedTop, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    StreambedTopDataArray.ComputeAverage;
    StreambedTopDataArray.UpToDate := True;
  end;

  if StreambedThicknessDataArray <> nil then
  begin
    StreambedThicknessDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        StreambedThicknessDataArray.AddDataValue(ReachProp.StreambedThicknessAnnotation,
          ReachProp.StreambedThickness, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    StreambedThicknessDataArray.ComputeAverage;
    StreambedThicknessDataArray.UpToDate := True;
  end;

  if HydraulicConductivityDataArray <> nil then
  begin
    HydraulicConductivityDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        HydraulicConductivityDataArray.AddDataValue(ReachProp.HydraulicConductivityAnnotation,
          ReachProp.HydraulicConductivity, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    HydraulicConductivityDataArray.ComputeAverage;
    HydraulicConductivityDataArray.UpToDate := True;
  end;

  if InitialStageDataArray <> nil then
  begin
    InitialStageDataArray.Clear;

    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        ReachProp := ASegment.SteadyValues[ReachIndex];

        InitialStageDataArray.AddDataValue(ReachProp.InitialStageAnnotation,
          ReachProp.InitialStage, ReachProp.Cell.Column,
          ReachProp.Cell.Row, ReachProp.Cell.Layer);
      end;
    end;
    InitialStageDataArray.ComputeAverage;
    InitialStageDataArray.UpToDate := True;
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteACrossSection(
  CrossSection: TSfr6CrossSection; const FileName: string; ScreenObject: TScreenObject);
var
  Index: Integer;
  AnItem: TSfr6CrossSectionPoint;
  MinHeight: Double;
begin
  OpenTempFile(FileName);

  WriteBeginDimensions;
  try
    WriteString('  NROW');
    WriteInteger(CrossSection.Count);
    NewLine;

    WriteString('  NCOL');
    if CrossSection.UseManningFraction then
    begin
      WriteInteger(3);
    end
    else
    begin
      WriteInteger(2);
    end;
    NewLine;
  finally
    WriteEndDimensions;
  end;

  WriteString('BEGIN TABLE');
  NewLine;
  try
    MinHeight := 0;
    for Index := 0 to CrossSection.Count - 1 do
    begin
      AnItem := CrossSection[Index];
      WriteFloat(AnItem.XFraction);
      WriteFloat(AnItem.Height);
      if Index = 0  then
      begin
        MinHeight := AnItem.Height;
      end
      else
      begin
        if AnItem.Height < MinHeight then
        begin
          MinHeight := AnItem.Height;
        end;
      end;
      if CrossSection.UseManningFraction then
      begin
        WriteFloat(AnItem.ManningsFraction);
      end;
      NewLine;
    end;
    if MinHeight <> 0 then
    begin
      frmErrorsAndWarnings.AddError(Model, StrInvalidMinimumCros,
        Format(StrTheMinimumHeightI, [ScreenObject.Name]), ScreenObject);
    end;
  finally
    WriteString('END TABLE');
    NewLine;
  end;

  CloseTempFile;
end;

procedure TModflowSFR_MF6_Writer.WriteAdditionalAuxVariables;
var
  SpeciesIndex: Integer;
  ASpecies: TMobileChemSpeciesItem;
begin
  if Model.GwtUsed and (Model.MobileComponents.Count > 0) then
  begin
    WriteString('  AUXILIARY');
    for SpeciesIndex := 0 to Model.MobileComponents.Count - 1 do
    begin
      ASpecies := Model.MobileComponents[SpeciesIndex];
      WriteString(' ' + ASpecies.Name);
    end;
    NewLine;
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteConnections;
var
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ReachIndex: Integer;
  AReach: TSfrMF6ConstantRecord;
  ConnectIndex: Integer;
begin
  WriteBeginConnectionData;
  for SegmentIndex := 0 to FSegments.Count - 1 do
  begin
    ASegment := FSegments[SegmentIndex];
    WriteString(Format('# defined by %s', [ASegment.FScreenObject.Name]));
    NewLine;
    for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
    begin
      AReach := ASegment.SteadyValues[ReachIndex];
      WriteInteger(AReach.ReachNumber);
      for ConnectIndex := 0 to Length(AReach.ConnectedReaches) - 1 do
      begin
        WriteInteger(AReach.ConnectedReaches[ConnectIndex]);
      end;
      NewLine;
    end;
  end;
  WriteEndConnectionData;
end;

procedure TModflowSFR_MF6_Writer.WriteCrossSections;
var
  ScreenObject: TScreenObject;
  Sfr6Boundary: TSfrMf6Boundary;
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ReachNumber: Integer;
  ReachIndex: Integer;
  CrossSectionUsed: Boolean;
  AFileName: string;
  FileIndex: Integer;
  ACellList: TValueCellList;
  ACell: TSfrMf6_Cell;
  CSIndex: Integer;
  CrossSection: TSfr6CrossSection;
begin
  FileIndex := 1;
  try
    CrossSectionUsed := False;
    ReachNumber := 0;
    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      ACellList := ASegment.FReaches[0];
      Assert(ACellList.Count = Length(ASegment.SteadyValues));
      for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
      begin
        Inc(ReachNumber);
        ACell := ACellList[ReachIndex] as TSfrMF6_Cell;

        ScreenObject := ACell.ScreenObject as TScreenObject;
        Assert(ScreenObject <> nil);
        Sfr6Boundary := ScreenObject.ModflowSfr6Boundary;

        if Sfr6Boundary.CrossSectionUsage <> csuNotUsed then
        begin
          if not CrossSectionUsed then
          begin
            CrossSectionUsed := True;
            WriteString('BEGIN CROSSSECTIONS');
            NewLine;
          end;
          CrossSection := (Sfr6Boundary.CrossSections.First as TimeVaryingSfr6CrossSectionItem).CrossSection;
          if not FCrossSectionDictionary.TryGetValue(CrossSection, AFileName) then
          begin
            AFileName := ChangeFileExt(FInputFileName, Format('.xsec%d', [FileIndex]));
            WriteACrossSection(CrossSection, AFileName, ScreenObject);
            Model.AddModelInputFile(AFileName);
            FCrossSectionDictionary.Add(CrossSection, AFileName);
            Inc(FileIndex);
          end;
          WriteInteger(ReachNumber);
          WriteString(' TAB6 FILEIN ');
          WriteString(ExtractFileName(AFileName));
          NewLine;
          if Sfr6Boundary.CrossSectionUsage = csuMultiple then
          begin
            for CSIndex := 1 to Sfr6Boundary.CrossSections.Count - 1 do
            begin
              CrossSection := (Sfr6Boundary.CrossSections.Items[CSIndex] as TimeVaryingSfr6CrossSectionItem).CrossSection;
              if not FCrossSectionDictionary.TryGetValue(CrossSection, AFileName) then
              begin
                AFileName := ChangeFileExt(FInputFileName, Format('.xsec%d', [FileIndex]));
                WriteACrossSection(CrossSection, AFileName, ScreenObject);
                Model.AddModelInputFile(AFileName);
                FCrossSectionDictionary.Add(CrossSection, AFileName);
                Inc(FileIndex);
              end;
            end;
          end;
        end;
      end;
    end;
    if CrossSectionUsed then
    begin
      WriteString('END CROSSSECTIONS');
      NewLine;
      NewLine;
    end;
  finally
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteDimensions;
begin
  WriteBeginDimensions;
  WriteString('    NREACHES ');
  WriteInteger(FReachCount);
  NewLine;
  WriteEndDimensions
end;

procedure TModflowSFR_MF6_Writer.WriteDiversions;
var
  SegIndex: Integer;
  ASegment: TSfr6Segment;
  DiverIndex: Integer;
  ADiversion: TSDiversionItem;
  SegmentDictionary: TDictionary<Integer, TSfr6Segment>;
  OtherSegment: TSfr6Segment;
  AReach: TSfrMF6ConstantRecord;
  OtherReach: TSfrMF6ConstantRecord;
begin

  if FDiversionCount > 0 then
  begin
    SegmentDictionary := TDictionary<Integer, TSfr6Segment>.Create;
    try
      for SegIndex := 0 to FSegments .Count - 1 do
      begin
        ASegment := FSegments[SegIndex];
        if not SegmentDictionary.TryGetValue(ASegment.FSfr6Boundary.SegmentNumber,
          OtherSegment) then
        begin
          SegmentDictionary.Add(ASegment.FSfr6Boundary.SegmentNumber, ASegment);
        end;
      end;

      WriteString('BEGIN DIVERSIONS');
      NewLine;
      for SegIndex := 0 to FSegments.Count - 1 do
      begin
        ASegment := FSegments[SegIndex];
        for DiverIndex := 0 to ASegment.FSfr6Boundary.Diversions.Count - 1 do
        begin
          ADiversion := ASegment.FSfr6Boundary.Diversions[DiverIndex];
          if SegmentDictionary.TryGetValue(ADiversion.DownstreamSegment,
            OtherSegment) then
          begin
            try
              AReach := ASegment.Last;
            except on ERangeError do
              begin
                Beep;
                MessageDlg(Format(StrTheSFRSegmentDefi,
                  [ASegment.ScreenObject.Name]), mtError, [mbOK], 0);
                Exit;
              end;
            end;
            try
              OtherReach := OtherSegment.First;
            except on ERangeError do
              begin
                Beep;
                MessageDlg(Format(StrTheSFRSegmentDefi,
                  [OtherSegment.ScreenObject.Name]), mtError, [mbOK], 0);
                Exit;
              end;
            end;
            WriteInteger(AReach.ReachNumber);
            WriteInteger(DiverIndex+1);
            WriteInteger(OtherReach.ReachNumber);
            case ADiversion.Priority of
              cpFraction: WriteString(' FRACTION');
              cpExcess: WriteString(' EXCESS');
              cpThreshold: WriteString(' THRESHOLD');
              cpUpTo: WriteString(' UPTO');
              else Assert(False);
            end;
            NewLine;
          end;
        end;
      end;
      WriteString('End DIVERSIONS');
      NewLine;
      NewLine;
    finally
      SegmentDictionary.Free;
    end;
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteFile(const AFileName: string);
var
  Abbreviation: string;
  ObsWriter: TSfrObsWriter;
begin
  if not Package.IsSelected then
  begin
    Exit
  end;
  if Model.ModelSelection = msModflow2015 then
  begin
    Abbreviation := 'SFR6';
  end
  else
  begin
    Exit;
  end;
  if Model.PackageGeneratedExternally(Abbreviation) then
  begin
    Exit;
  end;
  FNameOfFile := FileName(AFileName);
  FInputFileName := FNameOfFile;
  WriteToNameFile(Abbreviation, -1, FNameOfFile, foInput, Model, False, StrSfrFlowPackageName);
  frmErrorsAndWarnings.BeginUpdate;
  try

    Evaluate;

    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;
    WriteFileInternal;

    if FObsList.Count > 0 then
    begin
      ObsWriter := TSfrObsWriter.Create(Model, etExport, FObsList);
      try
        ObsWriter.WriteFile(ChangeFileExt(FNameOfFile, ObservationExtension));
      finally
        ObsWriter.Free;
      end;
    end;

    if  Model.PestUsed and FPestParamUsed then
    begin
      frmErrorsAndWarnings.BeginUpdate;
      try
        FNameOfFile := FNameOfFile + '.tpl';
        WritePestTemplateLine(FNameOfFile);
        WritingTemplate := True;
        WriteFileInternal;

      finally
        frmErrorsAndWarnings.EndUpdate;
      end;
    end;

  finally
    frmErrorsAndWarnings.EndUpdate;
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteOptions;
var
  SfrMf6Package: TSfrModflow6PackageSelection;
  stagefile: string;
  budgetfile: string;
  NameOfFile: string;
  CsvFile: string;
  BaseFileName: string;
  budgetCsvFile: string;
begin
  WriteBeginOptions;

  SfrMf6Package := Model.ModflowPackages.SfrModflow6Package;
  if SfrMf6Package.Storage then
  begin
    WriteString('    STORAGE');
    NewLine;
  end;

  if Model.GwtUsed then
  begin
    WriteAdditionalAuxVariables
  end;

  PrintListInputOption;

  if SfrMf6Package.PrintStage then
  begin
    WriteString('    PRINT_STAGE');
    NewLine;
  end;

  if SfrMf6Package.PrintFlows then
  begin
    WriteString('    PRINT_FLOWS');
    NewLine;
  end;

  WriteString('    BOUNDNAMES');
  NewLine;

  WriteTimeSeriesFiles(FInputFileName);

  PrintFlowsOption;
  WriteSaveFlowsOption;

  BaseFileName := ChangeFileExt(FNameOfFile, '');
  if SfrMf6Package.SaveStageFile then
  begin
    WriteString('    STAGE FILEOUT ');
    stagefile := ChangeFileExt(BaseFileName, StrStage);
    Model.AddModelOutputFile(stagefile);
    stagefile := ExtractFileName(stagefile);
    WriteString(stagefile);
    NewLine;
  end;

  if SfrMf6Package.SaveBudgetFile or Model.SeparateGwtUsed then
  begin
    WriteString('    BUDGET FILEOUT ');
    budgetfile := ChangeFileExt(BaseFileName, StrSfrbudget);
    Model.AddModelOutputFile(budgetfile);
    budgetfile := ExtractFileName(budgetfile);
    WriteString(budgetfile);
    NewLine;
  end;

  if SfrMf6Package.SaveGwtBudgetCsv then
  begin
    WriteString('    BUDGETCSV FILEOUT ');
    budgetCsvFile := BaseFileName + '.sfr_budget.csv';
    Model.AddModelOutputFile(budgetCsvFile);
    budgetCsvFile := ExtractFileName(budgetCsvFile);
    WriteString(budgetCsvFile);
    NewLine;
  end;

  if SfrMf6Package.WriteConvergenceData then
  begin
    WriteString('  PACKAGE_CONVERGENCE FILEOUT ');
    CsvFile := ChangeFileExt(BaseFileName, '.SfrConvergence.csv');
    Model.AddModelOutputFile(CsvFile);
    CsvFile := ExtractFileName(CsvFile);
    WriteString(CsvFile);
    NewLine;
  end;

  if SfrMf6Package.MaxPicardIteration <> KSfrDefaultPicardIterations then
  begin
    WriteString('    MAXIMUM_PICARD_ITERATIONS');
    WriteInteger(SfrMf6Package.MaxPicardIteration);
    NewLine;
  end;

  WriteString('    MAXIMUM_ITERATIONS');
  WriteInteger(SfrMf6Package.MaxIteration);
  NewLine;

  WriteString('    MAXIMUM_DEPTH_CHANGE');
  WriteFloat(SfrMf6Package.MaxDepthChange);
  NewLine;

  case Model.ModflowOptions.LengthUnit of
    0:
      begin
        frmErrorsAndWarnings.AddError(Model, StrUndefinedLengthUni,
          StrWhenTheSFRPackageLength);
      end;
    1: // feet
      begin
        WriteString('    LENGTH_CONVERSION');
        WriteFloat(3.28081);
        NewLine;
      end;
    2: // meters
      begin
        // do nothing
      end;
    3: // cm
      begin
        WriteString('    LENGTH_CONVERSION');
        WriteFloat(100);
        NewLine;
      end;
  end;

  case Model.ModflowOptions.TimeUnit of
    0:
      begin
        frmErrorsAndWarnings.AddError(Model, StrUndefinedTimeUnit,
          StrWhenTheSFRPackageTime);
      end;
    1: // seconds
      begin
        // do nothing
      end;
    2: // minutes
      begin
        WriteString('    TIME_CONVERSION');
        WriteFloat(60);
        NewLine;
      end;
    3: // hours
      begin
        WriteString('    TIME_CONVERSION');
        WriteFloat(3600);
        NewLine;
      end;
    4: // days
      begin
        WriteString('    TIME_CONVERSION');
        WriteFloat(86400);
        NewLine;
      end;
    5: // years
      begin
        WriteString('    TIME_CONVERSION');
        WriteFloat(31557600);
        NewLine;
      end;
  end;

  // UNIT_CONVERSION is no longer used.
//  WriteString('    UNIT_CONVERSION');
//  WriteFloat(Model.ModflowOptions.StreamConstant(Model));
//  NewLine;

  if FObsList.Count > 0 then
  begin
    WriteString('    OBS6 FILEIN ');
    NameOfFile := ChangeFileExt(BaseFileName, ObservationExtension);
    Model.AddModelInputFile(NameOfFile);
    NameOfFile := ExtractFileName(NameOfFile);
    WriteString(NameOfFile);
    NewLine;
  end;

  if (MvrWriter <> nil) then
  begin
    if spcSfr in TModflowMvrWriter(MvrWriter).UsedPackages then
    begin
      WriteString('  MOVER');
      NewLine
    end;
  end;

  WriteEndOptions
end;

procedure TModflowSFR_MF6_Writer.WritePackageData;
var
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ReachNumber: Integer;
  ReachIndex: Integer;
  ReachProp: TSfrMF6ConstantRecord;
  ncon: Integer;
  ndiv: Integer;
  ACellList: TValueCellList;
  ACell: TSfrMf6_Cell;
  boundname: string;
  SpeciesIndex: Integer;
begin
  WriteBeginPackageData;
  WriteString('# <rno>   <cellid>  ');
  if not Model.DisvUsed then
  begin
    WriteString('      ');
  end;
  WriteString('<rlen>                <rwid>                <rgrd>                <rtp>                 <rbth>                <rhk>                 <man>                <ncon> <ustrf>                  <ndv> [<aux(naux)>] [<boundname>]');
  NewLine;

  ReachNumber := 0;
  for SegmentIndex := 0 to FSegments.Count - 1 do
  begin
    ASegment := FSegments[SegmentIndex];
    ACellList := ASegment.FReaches[0];
    Assert(ACellList.Count = Length(ASegment.SteadyValues));
    for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
    begin
      if ReachIndex = 0 then
      begin
        WriteString(Format('# defined by %s',
          [ASegment.FScreenObject.Name]));
        NewLine;
      end;
      Inc(ReachNumber);
      WriteInteger(ReachNumber);

      ReachProp := ASegment.SteadyValues[ReachIndex];
      ACell := ACellList[ReachIndex] as TSfrMF6_Cell;

      if not ReachProp.OutsideGridCell then
      begin
        WriteInteger(ReachProp.Cell.Layer+1);
        if not Model.DisvUsed then
        begin
          WriteInteger(ReachProp.Cell.Row+1);
        end;
        WriteInteger(ReachProp.Cell.Column+1);
      end
      else
      begin
        WriteInteger(0);
        if not Model.DisvUsed then
        begin
          WriteInteger(0);
        end;
        WriteInteger(0);
      end;
      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestReachLength,
        ReachProp.ReachLength, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);

      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestReachWidth,
        ReachProp.ReachWidth, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);

      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestGradient,
        ReachProp.Gradient, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);

      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestStreambedTop,
        ReachProp.StreambedTop, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);

      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestStreambedThickness,
        ReachProp.StreambedThickness, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);

      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestHydraulicConductivity,
        ReachProp.HydraulicConductivity, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);

      WriteValueOrFormula(ACell, SfrMf6RoughnessPosition);

      ncon := Length(ReachProp.ConnectedReaches);
      WriteInteger(ncon);

      if ACell.Values.Status <> ssInactive then
      begin
        WriteValueOrFormula(ACell, SfrMf6UpstreamFractionPosition);
      end
      else
      begin
        WriteFloat(0);
      end;

      if ReachIndex = Length(ASegment.SteadyValues) - 1 then
      begin
        ndiv := ASegment.FSfr6Boundary.Diversions.Count;
      end
      else
      begin
        ndiv := 0;
      end;
      WriteInteger(ndiv);

//      if Model.BuoyancyDensityUsed then
//      begin
//        WriteFloat(0);
//      end;

      if Model.GwtUsed then
      begin
        for SpeciesIndex := 0 to Model.MobileComponents.Count - 1 do
        begin
          WriteFloat(0);
        end;
      end;

      boundname := ' ' + Copy(ReachProp.BoundName, 1, MaxBoundNameLength);
      WriteString(boundname);

      NewLine;
    end;
  end;
  WriteEndPackageData;

  Assert(ReachNumber <= FReachCount);
end;

procedure TModflowSFR_MF6_Writer.WriteSftFile(const AFileName: string;
  SpeciesIndex: Integer);
var
  SpeciesName: string;
  Abbreviation: string;
  ObsWriter: TSftObsWriter;
begin
  if not Package.IsSelected then
  begin
    Exit
  end;
  if Model.ModelSelection = msModflow2015 then
  begin
    Abbreviation := 'SFT6';
  end
  else
  begin
    Exit;
  end;
  if Model.PackageGeneratedExternally(Abbreviation) then
  begin
    Exit;
  end;
  if not Model.MobileComponents[SpeciesIndex].UsedForGWT then
  begin
    Exit;
  end;
  if Model.GwtUsed then
  begin
    FSpeciesIndex :=  SpeciesIndex;
    SpeciesName := Model.MobileComponents[FSpeciesIndex].Name;
    FNameOfFile := ChangeFileExt(AFileName, '') + '.' + SpeciesName + '.sft';
    FInputFileName := FNameOfFile;

    WriteToGwtNameFile(Abbreviation, FNameOfFile, SpeciesIndex);
  end;

  FPestParamUsed := False;
  WritingTemplate := False;

  frmErrorsAndWarnings.BeginUpdate;
  try
    WriteGwtFileInternal;

    if FGwtObservations[SpeciesIndex].Count > 0 then
    begin
      ObsWriter := TSftObsWriter.Create(Model, etExport, FGwtObservations[SpeciesIndex], SpeciesIndex);
      try
        ObsWriter.WriteFile(ChangeFileExt(FNameOfFile, GwtObservationExtension));
      finally
        ObsWriter.Free;
      end;
    end;

    if  Model.PestUsed and FPestParamUsed then
    begin
      FNameOfFile := FNameOfFile + '.tpl';
      WritePestTemplateLine(FNameOfFile);
      WritingTemplate := True;
      WriteGwtFileInternal;
    end;

  finally
    frmErrorsAndWarnings.EndUpdate;
  end;

end;

procedure TModflowSFR_MF6_Writer.WriteGwtOptions;
var
  ASpecies: TMobileChemSpeciesItem;
  budgetfile: string;
  BaseFileName: string;
  SfrMf6Package: TSfrModflow6PackageSelection;
  concentrationfile: string;
  budgetCsvFile: string;
  NameOfFile: string;
begin
  WriteBeginOptions;
  try
    WriteString('    FLOW_PACKAGE_NAME ');
    WriteString(StrSfrFlowPackageName);
    NewLine;

    Assert(FSpeciesIndex >= 0);
    Assert(FSpeciesIndex < Model.MobileComponents.Count);
    WriteString('    FLOW_PACKAGE_AUXILIARY_NAME ');
    ASpecies := Model.MobileComponents[FSpeciesIndex];
    WriteString(' ' + ASpecies.Name);
    NewLine;

    WriteString('    BOUNDNAMES');
    NewLine;

    WriteTimeSeriesFiles(FInputFileName, FSpeciesIndex);

    PrintListInputOption;
    PrintConcentrationOption;
    PrintFlowsOption;
    WriteSaveFlowsOption;

    SfrMf6Package := Model.ModflowPackages.SfrModflow6Package;
    BaseFileName := ChangeFileExt(FNameOfFile, '');
    BaseFileName := ChangeFileExt(BaseFileName, '') + '.' + ASpecies.Name;

    if SfrMf6Package.SaveGwtConcentration then
    begin
      WriteString('    CONCENTRATION FILEOUT ');
      concentrationfile := BaseFileName + StrSftconc;
      Model.AddModelOutputFile(concentrationfile);
      concentrationfile := ExtractFileName(concentrationfile);
      WriteString(concentrationfile);
      NewLine;
    end;

    if SfrMf6Package.SaveGwtBudget then
    begin
      WriteString('    BUDGET FILEOUT ');
      budgetfile := BaseFileName + StrSftbudget;
      Model.AddModelOutputFile(budgetfile);
      budgetfile := ExtractFileName(budgetfile);
      WriteString(budgetfile);
      NewLine;
    end;

    if SfrMf6Package.SaveGwtBudgetCsv then
    begin
      WriteString('    BUDGETCSV FILEOUT ');
      budgetCsvFile := BaseFileName + '.sft_budget.csv';
      Model.AddModelOutputFile(budgetCsvFile);
      budgetCsvFile := ExtractFileName(budgetCsvFile);
      WriteString(budgetCsvFile);
      NewLine;
    end;

    if FGwtObservations[FSpeciesIndex].Count > 0 then
    begin
      WriteString('    OBS6 FILEIN ');
      NameOfFile := BaseFileName + GwtObservationExtension;
      Model.AddModelInputFile(NameOfFile);
      NameOfFile := ExtractFileName(NameOfFile);
      WriteString(NameOfFile);
      NewLine;
    end;
  finally
    WriteEndOptions
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteGwtPackageData;
var
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ReachNumber: Integer;
  ReachIndex: Integer;
  ReachProp: TSfrMF6ConstantRecord;
  ACellList: TValueCellList;
  boundname: string;
begin
  WriteBeginPackageData;
  WriteString('# <rno> <strt> <boundname>');
  NewLine;

  ReachNumber := 0;
  for SegmentIndex := 0 to FSegments.Count - 1 do
  begin
    ASegment := FSegments[SegmentIndex];
    ACellList := ASegment.FReaches[0];
    Assert(ACellList.Count = Length(ASegment.SteadyValues));
    for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
    begin
      if ReachIndex = 0 then
      begin
        WriteString(Format('# defined by %s',
          [ASegment.FScreenObject.Name]));
        NewLine;
      end;
      Inc(ReachNumber);
      WriteInteger(ReachNumber);

      ReachProp := ASegment.SteadyValues[ReachIndex];
      WriteFormulaOrValueBasedOnAPestName(
        ReachProp.StartingConcentrations.ValuePestNames[FSpeciesIndex],
        ReachProp.StartingConcentrations.Values[FSpeciesIndex],
        ReachProp.Cell.Layer, ReachProp.Cell.Row, ReachProp.Cell.Column);

      boundname := ' ' + Copy(ReachProp.BoundName, 1, MaxBoundNameLength);
      WriteString(boundname);

      NewLine;
    end;
  end;
  WriteEndPackageData;

  Assert(ReachNumber <= FReachCount);
end;

procedure TModflowSFR_MF6_Writer.WriteGwtStressPeriods;
var
  StressPeriodIndex: Integer;
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ACellList: TValueCellList;
  CellIndex: Integer;
  ACell: TSfrMF6_Cell;
  ReachNumber: Integer;
  ReachCount: Integer;
  MvrReceiver: TMvrReceiver;
  MvrSource: TMvrRegisterKey;
  GwtStatus: TGwtBoundaryStatus;
  DiversionCount: Integer;
  FormulaIndex: Integer;
begin
  for StressPeriodIndex := 0 to Model.ModflowFullStressPeriods.Count -1 do
  begin
    frmProgressMM.AddMessage(Format(
      StrWritingSFRStre, [StressPeriodIndex+1]));
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    ReachCount := 0;

    MvrSource.StressPeriod := StressPeriodIndex;
    MvrReceiver.ReceiverKey.StressPeriod := StressPeriodIndex;

    WriteBeginPeriod(StressPeriodIndex);
    ReachNumber := 0;
    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      MvrReceiver.ReceiverKey.ScreenObject := ASegment.FScreenObject as TScreenObject;

      Assert(ASegment.FReaches.Count = Model.ModflowFullStressPeriods.Count);
      WriteString(Format('# rno sftsetting (defined by %s)',
        [ASegment.FScreenObject.Name]));
      NewLine;

      ACellList := ASegment.FReaches[StressPeriodIndex];
      SetLength(MvrReceiver.ReceiverValues.StreamCells, ACellList.Count);
      SetLength(MvrReceiver.ReceiverValues.StreamReachNumbers, ACellList.Count);

      MvrReceiver.ReceiverValues.Index := ReachCount+1;
      for CellIndex := 0 to ACellList.Count - 1 do
      begin
        Inc(ReachCount);

        ACell := ACellList[CellIndex] as TSfrMF6_Cell;
        MvrReceiver.ReceiverValues.StreamCells[CellIndex] := ACell.Values.Cell;
        Inc(ReachNumber);
        MvrReceiver.ReceiverValues.StreamReachNumbers[CellIndex] := ReachNumber;

        WriteInteger(ReachNumber);
        case ACell.Values.Status of
          ssInactive:
            begin
              GwtStatus := gbsInactive;
            end;
          ssActive, ssSimple:
            begin
              GwtStatus := ACell.GwtStatus[FSpeciesIndex];
            end;
          else
            begin
              GwtStatus := gbsInactive;
              Assert(False);
            end;
        end;
        WriteString(' STATUS');
        case GwtStatus of
          gbsInactive:
            begin
              WriteString(' INACTIVE');
            end;
          gbsActive:
            begin
              WriteString(' ACTIVE');
            end;
          gbsConstant:
            begin
              WriteString(' CONSTANT');
            end;
          else
            Assert(False);
        end;
        NewLine;

        DiversionCount := ASegment.FSfr6Boundary.Diversions.Count;
        if GwtStatus = gbsConstant then
        begin
          WriteInteger(ReachNumber);
          WriteString(' CONCENTRATION');

          FormulaIndex := SfrMf6DiversionStartPosition + 1 + DiversionCount
            + SfrGwtConcCount*FSpeciesIndex + SfrGwtSpecifiedConcentrationPosition;
          WriteValueOrFormula(ACell, FormulaIndex);
          NewLine;
        end;

        if GwtStatus = gbsActive then
        begin
          WriteInteger(ReachNumber);
          WriteString(' RAINFALL');
          FormulaIndex := SfrMf6DiversionStartPosition + 1 + DiversionCount
            + SfrGwtConcCount*FSpeciesIndex + SfrGwtRainfallConcentrationsPosition;
          WriteValueOrFormula(ACell, FormulaIndex);
          NewLine;

          WriteInteger(ReachNumber);
          WriteString(' EVAPORATION');
          FormulaIndex := SfrMf6DiversionStartPosition + 1 + DiversionCount
            + SfrGwtConcCount*FSpeciesIndex + SfrGwtEvapConcentrationsPosition;
          WriteValueOrFormula(ACell, FormulaIndex);
          NewLine;

          WriteInteger(ReachNumber);
          WriteString(' RUNOFF');
          FormulaIndex := SfrMf6DiversionStartPosition + 1 + DiversionCount
            + SfrGwtConcCount*FSpeciesIndex + SfrGwtRunoffConcentrationsPosition;
          WriteValueOrFormula(ACell, FormulaIndex);
          NewLine;

          WriteInteger(ReachNumber);
          WriteString(' INFLOW');
          FormulaIndex := SfrMf6DiversionStartPosition + 1 + DiversionCount
            + SfrGwtConcCount*FSpeciesIndex + SfrGwtInflowConcentrationsPosition;
          WriteValueOrFormula(ACell, FormulaIndex);
          NewLine;
          NewLine;
        end;
      end;
    end;
    WriteEndPeriod;
    Assert(ReachCount <= FReachCount);
  end;
end;

procedure TModflowSFR_MF6_Writer.WriteInitialStages;
var
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ReachNumber: Integer;
  ReachIndex: Integer;
  ReachProp: TSfrMF6ConstantRecord;
begin
  WriteString('BEGIN INITIALSTAGES');
  NewLine;
  WriteString('# <rno>  <initialstage>');
  NewLine;

  ReachNumber := 0;
  for SegmentIndex := 0 to FSegments.Count - 1 do
  begin
    ASegment := FSegments[SegmentIndex];
    for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
    begin
      if ReachIndex = 0 then
      begin
        WriteString(Format('# defined by %s',
          [ASegment.FScreenObject.Name]));
        NewLine;
      end;
      Inc(ReachNumber);
      WriteInteger(ReachNumber);

      ReachProp := ASegment.SteadyValues[ReachIndex];

      WriteFormulaOrValueBasedOnAPestName(ReachProp.PestInitialStage,
        ReachProp.InitialStage, ReachProp.Cell.Layer, ReachProp.Cell.Row,
        ReachProp.Cell.Column);
      NewLine;

    end;
  end;
  WriteString('END INITIALSTAGES');
  NewLine;
  NewLine;

  Assert(ReachNumber <= FReachCount);
end;

procedure TModflowSFR_MF6_Writer.WriteStressPeriods;
const
  // equivalent to DEM6 in MODFLOW 6.
  Epsilon = 1e-6;
var
  StressPeriodIndex: Integer;
  SegmentIndex: Integer;
  ASegment: TSfr6Segment;
  ACellList: TValueCellList;
  CellIndex: Integer;
  ACell: TSfrMF6_Cell;
  ReachNumber: Integer;
  DivIndex: Integer;
  idv: Integer;
  ReachCount: Integer;
  MoverWriter: TModflowMvrWriter;
  MvrReceiver: TMvrReceiver;
  MvrSource: TMvrRegisterKey;
  UpstreamFractions: array of double;
  SumUpstreamFractions: double;
  AssociatedScreenObjects: array of TScreenObject;
  ReachIndex: Integer;
  AReach: TSfrMF6ConstantRecord;
  ConnectIndex: Integer;
  HasDownstreamReaches: Boolean;
  ConnectedStreams: TStringList;
  StatusArray: array of TStreamStatus;
  DownReachIndex: Integer;
  DownstreamReachesDefined: Boolean;
  ACrossSection: TSfr6CrossSection;
  AFileName: string;
begin
  if MvrWriter <> nil then
  begin
    MoverWriter := MvrWriter as TModflowMvrWriter;
  end
  else
  begin
    MoverWriter := nil;
  end;
  MvrReceiver.ReceiverKey.ReceiverPackage := rpcSfr;
  SetLength(UpstreamFractions, FReachCount);
  SetLength(AssociatedScreenObjects, FReachCount);
  SetLength(StatusArray, FReachCount);
  for StressPeriodIndex := 0 to Model.ModflowFullStressPeriods.Count -1 do
  begin
    frmProgressMM.AddMessage(Format(
      StrWritingSFRStre, [StressPeriodIndex+1]));
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    ReachCount := 0;
    for ReachIndex := 0 to FReachCount - 1 do
    begin
      UpstreamFractions[ReachIndex] := 0;
      AssociatedScreenObjects[ReachIndex] := nil;
      StatusArray[ReachIndex] := ssInactive;
    end;

    MvrSource.StressPeriod := StressPeriodIndex;
    MvrReceiver.ReceiverKey.StressPeriod := StressPeriodIndex;

    WriteBeginPeriod(StressPeriodIndex);
    ReachNumber := 0;
    for SegmentIndex := 0 to FSegments.Count - 1 do
    begin
      ASegment := FSegments[SegmentIndex];
      MvrReceiver.ReceiverKey.ScreenObject := ASegment.FScreenObject;

      Assert(ASegment.FReaches.Count = Model.ModflowFullStressPeriods.Count);
      WriteString(Format('# rno sfrsetting (defined by %s)',
        [ASegment.FScreenObject.Name]));
      NewLine;

      ACellList := ASegment.FReaches[StressPeriodIndex];
      SetLength(MvrReceiver.ReceiverValues.StreamCells, ACellList.Count);
      SetLength(MvrReceiver.ReceiverValues.StreamReachNumbers, ACellList.Count);
      SetLength(MvrReceiver.ReceiverValues.SectionIndices, ACellList.Count);

      MvrReceiver.ReceiverValues.Index := ReachCount+1;
      for CellIndex := 0 to ACellList.Count - 1 do
      begin
        Inc(ReachCount);

        ACell := ACellList[CellIndex] as TSfrMF6_Cell;
        MvrReceiver.ReceiverValues.StreamCells[CellIndex] := ACell.Values.Cell;
        Inc(ReachNumber);
        MvrReceiver.ReceiverValues.StreamReachNumbers[CellIndex] := ReachNumber;
        MvrReceiver.ReceiverValues.SectionIndices[CellIndex] := ACell.Values.Cell.Section;

        AssociatedScreenObjects[ReachNumber-1] := ASegment.ScreenObject;
        if ACell.Values.Status <> ssInactive then
        begin
          UpstreamFractions[ReachNumber-1] := ACell.Values.UpstreamFraction;
        end;
        StatusArray[ReachNumber-1] := ACell.Values.Status;

        WriteInteger(ReachNumber);
        WriteString(' STATUS');
        case ACell.Values.Status of
          ssInactive: WriteString(' INACTIVE');
          ssActive: WriteString(' ACTIVE');
          ssSimple: WriteString(' SIMPLE');
        end;
        NewLine;

        WriteInteger(ReachNumber);
        WriteString(' UPSTREAM_FRACTION');

        if FDiversionReaches.IndexOf(ReachNumber) < 0 then
        begin
          WriteValueOrFormula(ACell, SfrMf6UpstreamFractionPosition);
        end
        else
        begin
          WriteFloat(0);
        end;
        NewLine;

        if ACell.Values.Status = ssSimple then
        begin
          WriteInteger(ReachNumber);
          WriteString(' STAGE');
          WriteValueOrFormula(ACell, SfrMf6StagePosition);
          NewLine;
        end;

        if ACell.Values.Status <> ssInactive then
        begin
          WriteInteger(ReachNumber);
          WriteString(' INFLOW');
          WriteValueOrFormula(ACell, SfrMf6InflowPosition);
          NewLine;

          WriteInteger(ReachNumber);
          WriteString(' RAINFALL');
          WriteValueOrFormula(ACell, SfrMf6RainfallPosition);
          NewLine;

          WriteInteger(ReachNumber);
          WriteString(' EVAPORATION');
          WriteValueOrFormula(ACell, SfrMf6EvaporationPosition);
          NewLine;

          WriteInteger(ReachNumber);
          WriteString(' RUNOFF');
          WriteValueOrFormula(ACell, SfrMf6RunoffPosition);
          NewLine;
        end;

        if ACell.Values.Status = ssActive then
        begin
          WriteInteger(ReachNumber);
          WriteString(' MANNING');
          WriteValueOrFormula(ACell, SfrMf6RoughnessPosition);
          NewLine;
        end;

        if Model.BuoyancyDensityUsed then
        begin
          WriteInteger(ReachNumber);
          WriteString(' AUXILIARY DENSITY');
          WriteValueOrFormula(ACell, SfrMf6DensityPosition);
          NewLine;
        end;

        if Model.ViscosityPkgViscUsed then
        begin
          WriteInteger(ReachNumber);
          WriteString(' AUXILIARY VISCOSITY');
          WriteValueOrFormula(ACell, SfrMf6ViscosityPosition);
          NewLine;
        end;

//        if Model.GwtUsed then
//        begin
//          for SpeciesIndex := 0 to Model.MobileComponents.Count - 1 do
//          begin
//            WriteInteger(ReachNumber);
//            WriteString(' AUXILIARY ');
//            ASpecies := Model.MobileComponents[SpeciesIndex];
//            WriteString(' ' + ASpecies.Name);
//            WriteFloat(0);
//            NewLine;
//          end;
//        end;

        if ACell.Values.Status <> ssInactive then
        begin
          if CellIndex = ACellList.Count - 1 then
          begin
            Assert(Length(ACell.Values.Diversions)
              = ASegment.FSfr6Boundary.Diversions.Count);
            for DivIndex := 0 to Length(ACell.Values.Diversions) - 1 do
            begin
              WriteInteger(ReachNumber);
              WriteString(' DIVERSION');
              idv := DivIndex+1;
              WriteInteger(idv);
              WriteFloat(ACell.Values.Diversions[DivIndex]);
              NewLine;
            end;
          end;
        end;

        if ACell.CrossSectionIndex > 0 then
        begin
          WriteInteger(ReachNumber);
          WriteString(' CROSS_SECTION TAB6 FILEIN ');
          ACrossSection := (AssociatedScreenObjects[ReachNumber-1].
            ModflowSfr6Boundary.CrossSections.Items[ACell.CrossSectionIndex]
            as TimeVaryingSfr6CrossSectionItem).CrossSection;
          if not FCrossSectionDictionary.TryGetValue(ACrossSection, AFileName) then
          begin
            Assert(False);
          end;
          WriteString(ExtractFileName(AFileName));
          NewLine;
        end;
        NewLine;

        if ACell.MvrUsed and (MvrWriter <> nil) and not WritingTemplate then
        begin
          MvrSource.Index := ReachNumber;
          MvrSource.SourceKey.MvrIndex := ACell.MvrIndex;
          MvrSource.SourceKey.ScreenObject := ASegment.FScreenObject as TScreenObject;
          TModflowMvrWriter(MvrWriter).AddMvrSource(MvrSource);
        end;

//        if Model.GwtUsed then
//        begin
//          for SpeciesIndex := 0 to Model.MobileComponents.Count - 1 do
//          begin
//            WriteInteger(ReachNumber);
//            WriteString(' AUXILIARY ');
//            ASpecies := Model.MobileComponents[SpeciesIndex];
//            WriteString(' ' + ASpecies.Name);
//            WriteFloat(0);
//            NewLine;
//          end;
//        end;
      end;

      if (MoverWriter <> nil) and not WritingTemplate then
      begin
        MoverWriter.AddMvrReceiver(MvrReceiver);
      end;

    end;
    WriteEndPeriod;
    Assert(ReachCount <= FReachCount);

    ConnectedStreams := TStringList.Create;
    try
      for SegmentIndex := 0 to FSegments.Count - 1 do
      begin
        ASegment := FSegments[SegmentIndex];
        ACellList := ASegment.FReaches[StressPeriodIndex];
        Assert(ACellList.Count = Length(ASegment.SteadyValues));
        for ReachIndex := 0 to Length(ASegment.SteadyValues) - 1 do
        begin
          AReach := ASegment.SteadyValues[ReachIndex];
          ACell := ACellList[ReachIndex] as TSfrMF6_Cell;
          if ACell.Values.Status = ssInactive then
          begin
            Continue;
          end;

          HasDownstreamReaches := False;
          DownstreamReachesDefined := False;
          ConnectedStreams.Clear;
          SumUpstreamFractions := 0;
          if Length(AReach.ConnectedReaches) > 0 then
          begin
            for ConnectIndex := 0 to Length(AReach.ConnectedReaches) - 1 do
            begin
              if AReach.ConnectedReaches[ConnectIndex] < 0 then
              begin
                DownstreamReachesDefined := True;
                DownReachIndex := -AReach.ConnectedReaches[ConnectIndex] -1;
                if StatusArray[DownReachIndex] <> ssInactive then
                begin
                  HasDownstreamReaches := True;
                  SumUpstreamFractions := SumUpstreamFractions
                    + UpstreamFractions[-AReach.ConnectedReaches[ConnectIndex]-1];
                  ConnectedStreams.Add(AssociatedScreenObjects[
                    -AReach.ConnectedReaches[ConnectIndex]-1].Name);
                end;
              end;
            end;
          end;
          if DownstreamReachesDefined and not HasDownstreamReaches then
          begin
            frmErrorsAndWarnings.AddError(Model, StrNoActiveSFRDownst,
              Format(StrTheDownstreamReach,
              [AssociatedScreenObjects[AReach.ReachNumber-1].Name, StressPeriodIndex+1]),
              AssociatedScreenObjects[AReach.ReachNumber-1]);
          end;
          if HasDownstreamReaches and (Abs(SumUpstreamFractions -1) > Epsilon) then
          begin
            frmErrorsAndWarnings.AddError(Model, StrSFRUpstreamValues,
              format(StrTheSumOfTheUpstr,
              [StressPeriodIndex+1, AReach.ReachNumber,
              AssociatedScreenObjects[AReach.ReachNumber-1].Name,
              ConnectedStreams.Text]));
          end;
        end;
      end;
    finally
      ConnectedStreams.Free;
    end;
  end;
end;

{ TSfr6Segment }

procedure TSfr6Segment.AssignReachNumbers(var StartingNumber: Integer);
var
  CellIndex: Integer;
begin
  for CellIndex := 0 to Length(FSteadyValues) - 1 do
  begin
    FSteadyValues[CellIndex].ReachNumber := StartingNumber;
    Inc(StartingNumber);
  end;
end;

constructor TSfr6Segment.Create(Model: TCustomModel);
begin
  FModel := Model;
  FReaches := TObjectList.Create;
end;

destructor TSfr6Segment.Destroy;
begin
  FReaches.Free;
  inherited;
end;

procedure TSfr6Segment.EliminateInactiveReaches;
var
  TimeIndex: Integer;
  ACellList: TValueCellList;
  IDomainArray: TDataArray;
  CellIndex: Integer;
  CellCount: Integer;
  CellLocation: TCellLocation;
  ACell: TSfrMF6_Cell;
begin
  IDomainArray := FModel.DataArrayManager.GetDataSetByName(K_IDOMAIN);
  for TimeIndex := 0 to FReaches.Count - 1 do
  begin
    ACellList := FReaches[TimeIndex];
    for CellIndex := ACellList.Count - 1 downto 0 do
    begin
      ACell := ACellList[CellIndex] as TSfrMF6_Cell;
      if IDomainArray.IntegerData[ACell.Layer, ACell.Row, ACell.Column] <= 0 then
      begin
        ACellList.Delete(CellIndex);
      end;
    end;
  end;

  CellCount := 0;
  for CellIndex := 0 to Length(FSteadyValues) - 1 do
  begin
    if CellCount <> CellIndex then
    begin
      FSteadyValues[CellCount] := FSteadyValues[CellIndex];
    end;
    CellLocation := FSteadyValues[CellIndex].Cell;
    if IDomainArray.IntegerData[
      CellLocation.Layer, CellLocation.Row, CellLocation.Column] >0 then
    begin
      Inc(CellCount);
    end;
  end;
  ReachCount := CellCount;
end;

function TSfr6Segment.GetFirst: TSfrMF6ConstantRecord;
begin
  Result := SteadyValues[0]
end;

function TSfr6Segment.GetLast: TSfrMF6ConstantRecord;
begin
  Result := SteadyValues[Length(SteadyValues)-1]

end;

procedure TSfr6Segment.SetFirst(const Value: TSfrMF6ConstantRecord);
begin
  First;
  FSteadyValues[0] := Value
end;

procedure TSfr6Segment.SetLast(const Value: TSfrMF6ConstantRecord);
begin
  FSteadyValues[Length(SteadyValues)-1] := Value
end;

procedure TSfr6Segment.SetReachCount(const Value: Integer);
begin
  if FReachCount <> Value then
  begin
    FReachCount := Value;
    SetLength(FSteadyValues, Value);
  end;
end;

end.
