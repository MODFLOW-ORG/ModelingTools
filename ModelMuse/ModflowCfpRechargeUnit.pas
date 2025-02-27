unit ModflowCfpRechargeUnit;

interface

uses Windows, ZLib, SysUtils, Classes, OrderedCollectionUnit,
  ModflowBoundaryUnit, DataSetUnit, ModflowCellUnit,
  FormulaManagerUnit, FormulaManagerInterfaceUnit,
  SubscriptionUnit, GoPhastTypes, System.Math;

type
  TCfpRchFractionRecord = record
    Cell: TCellLocation;
    //P_CRCH
    CfpRechargeFraction: double;
    // P_CDSRCH in MODFLOW-OWHM
    CfpCadsRechargeFraction: Double;
    StartingTime: double;
    EndingTime: double;
    CfpRechargeFractionAnnotation: string;
    CfpCadsRechargeFractionAnnotation: string;
    procedure Cache(Comp: TCompressionStream; Strings: TStringList);
    procedure Restore(Decomp: TDecompressionStream; Annotations: TStringList);
    procedure RecordStrings(Strings: TStringList);
  end;

  TCfpRchFractionArray = array of TCfpRchFractionRecord;

  TCfpRchFractionStorage = class(TCustomBoundaryStorage)
  private
    FCfpRchFractionArray: TCfpRchFractionArray;
    function GetCfpRchFractionArray: TCfpRchFractionArray;
  protected
    procedure Restore(DecompressionStream: TDecompressionStream;
      Annotations: TStringList); override;
    procedure Store(Compressor: TCompressionStream); override;
    procedure Clear; override;
  public
    property CfpRchFractionArray: TCfpRchFractionArray read GetCfpRchFractionArray;
  end;

  TCfpRchFractionItem = class(TCustomModflowBoundaryItem)
  private
    // See @link(CfpRechargeFraction).
    FCfpRechargeFraction: IFormulaObject;
    FCfpCadsRechargeFraction: IFormulaObject;
    // See @link(CfpRechargeFraction).
    procedure SetCfpRechargeFraction(const Value: string);
    function GetCfpRechargeFraction: string;
    function GetCfpCadsRechargeFraction: string;
    procedure SetCfpCadsRechargeFraction(const Value: string);
  protected
    procedure AssignObserverEvents(Collection: TCollection); override;
    procedure CreateFormulaObjects; override;
    procedure GetPropertyObserver(Sender: TObject; List: TList); override;
    procedure RemoveFormulaObjects; override;
    // See @link(BoundaryFormula).
    function GetBoundaryFormula(Index: integer): string; override;
    // See @link(BoundaryFormula).
    procedure SetBoundaryFormula(Index: integer; const Value: string); override;
    // @name checks whether AnotherItem is the same as the current @classname.
    function IsSame(AnotherItem: TOrderedItem): boolean; override;
    function BoundaryFormulaCount: integer; override;
  public
    Destructor Destroy; override;
  published
    // @name copies Source to this @classname.
    procedure Assign(Source: TPersistent);override;
    // @name is the formula used to set the recharge rate
    // or the recharge rate multiplier of this boundary.
    property CfpRechargeFraction: string read GetCfpRechargeFraction
      write SetCfpRechargeFraction;
    property CfpCadsRechargeFraction: string read GetCfpCadsRechargeFraction
      write SetCfpCadsRechargeFraction;
  end;

  TCfpRchFractionTimeListLink = class(TTimeListsModelLink)
  private
    // @name is used to compute the recharge rates for a series of
    // cells over a series of time intervals.
    FCfpRechargeFractionData: TModflowTimeList;
    FCfpCadsRechargeFractionData: TModflowTimeList;
  protected
    procedure CreateTimeLists; override;
    property CfpRechargeFractionData: TModflowTimeList read FCfpRechargeFractionData;
    property CfpCadsRechargeFractionData: TModflowTimeList read FCfpCadsRechargeFractionData;
  public
    Destructor Destroy; override;
  end;

  TCfpRchFractionCollection = class(TCustomMF_ArrayBoundColl)
  private
    procedure InvalidateRechargeData(Sender: TObject);
    procedure InvalidateCadsRechargeData(Sender: TObject);
  protected
    function PackageAssignmentMethod(AModel: TBaseModel): TUpdateMethod; virtual;
    class function GetTimeListLinkClass: TTimeListsModelLinkClass; override;
    procedure AddSpecificBoundary(AModel: TBaseModel); override;
    // See @link(TCustomListArrayBoundColl.AssignArrayCellValues
    // TCustomListArrayBoundColl.AssignArrayCellValues)
    procedure AssignArrayCellValues(DataSets: TList; ItemIndex: Integer;
      AModel: TBaseModel; PestSeries: TStringList;
      PestMethods: TPestMethodList;
      PestItemNames, TimeSeriesNames: TStringListObjectList); override;
    // See @link(TCustomListArrayBoundColl.InitializeTimeLists
    // TCustomListArrayBoundColl.InitializeTimeLists)
    procedure InitializeTimeLists(ListOfTimeLists: TList; AModel: TBaseModel;
      PestSeries: TStringList; PestMethods: TPestMethodList;
      PestItemNames, TimeSeriesNames: TStringListObjectList; Writer: TObject); override;
    // See @link(TCustomNonSpatialBoundColl.ItemClass
    // TCustomNonSpatialBoundColl.ItemClass)
    class function ItemClass: TBoundaryItemClass; override;
    // @name calls inherited @name and then sets the length of
    // the @link(TCfpRchFractionStorage.CfpRchFractionArray) at ItemIndex in
    // @link(TCustomMF_BoundColl.Boundaries) to BoundaryCount.
    // @SeeAlso(TCustomMF_BoundColl.SetBoundaryStartAndEndTime
    // TCustomMF_BoundColl.SetBoundaryStartAndEndTime)
    procedure SetBoundaryStartAndEndTime(BoundaryCount: Integer;
      Item: TCustomModflowBoundaryItem; ItemIndex: Integer; AModel: TBaseModel); override;
  end;

  TCfpRchFraction_Cell = class(TValueCell)
  private
    FValues: TCfpRchFractionRecord;
    FStressPeriod: integer;
    function GetCfpRechargeFraction: double;
    function GetCfpRechargeFractionAnnotation: string;
    function GetCadsCfpRechargeFractionAnnotation: string;
    function GetCfpCadsRechargeFraction: double;
  protected
    function GetColumn: integer; override;
    function GetLayer: integer; override;
    function GetRow: integer; override;
    procedure SetColumn(const Value: integer); override;
    procedure SetLayer(const Value: integer); override;
    procedure SetRow(const Value: integer); override;
    function GetIntegerValue(Index: integer; AModel: TBaseModel): integer; override;
    function GetRealValue(Index: integer; AModel: TBaseModel): double; override;
    function GetRealAnnotation(Index: integer; AModel: TBaseModel): string; override;
    function GetIntegerAnnotation(Index: integer; AModel: TBaseModel): string; override;
    procedure Cache(Comp: TCompressionStream; Strings: TStringList); override;
    procedure Restore(Decomp: TDecompressionStream; Annotations: TStringList); override;
    function GetSection: integer; override;
    procedure RecordStrings(Strings: TStringList); override;
  public
    property StressPeriod: integer read FStressPeriod write FStressPeriod;
    property Values: TCfpRchFractionRecord read FValues write FValues;
    property CfpRechargeFraction: double read GetCfpRechargeFraction;
    property CfpRechargeFractionAnnotation: string read GetCfpRechargeFractionAnnotation;
    property CfpCadsRechargeFraction: double read GetCfpCadsRechargeFraction;
    property CfpCadsRechargeFractionAnnotation: string read GetCadsCfpRechargeFractionAnnotation;
  end;

  // @name is used to specify data set 2 in the CRCH in the
  // Conduit Flow Process.
  TCfpRchFractionBoundary = class(TModflowBoundary)
  private
    FDrainableStorageWidth: IFormulaObject;
    FDrainableStorageWidthObserver: TObserver;
    function GetDrainableStorageWidth: string;
    procedure SetDrainableStorageWidth(const Value: string);
    function GetBoundaryFormula(Index: Integer): string;
    procedure SetBoundaryFormula(Index: Integer; const Value: string);
    function GetDrainableStorageWidthObserver: TObserver;
  protected
    // @name fills ValueTimeList with a series of TObjectLists - one for
    // each stress period.  Each such TObjectList is filled with
    // @link(TCfpRchFraction_Cell)s for that stress period.
    procedure AssignCells(BoundaryStorage: TCustomBoundaryStorage;
      ValueTimeList: TList; AModel: TBaseModel); override;
    // See @link(TModflowBoundary.BoundaryCollectionClass
    // TModflowBoundary.BoundaryCollectionClass).
    class function BoundaryCollectionClass: TMF_BoundCollClass; override;
    procedure GetPropertyObserver(Sender: TObject; List: TList); override;
    procedure CreateFormulaObjects;
    property DrainableStorageWidthObserver: TObserver read GetDrainableStorageWidthObserver;
    function BoundaryObserverPrefix: string; override;
    procedure CreateObservers;
  public
    Procedure Assign(Source: TPersistent); override;
    Constructor Create(Model: TBaseModel; ScreenObject: TObject);
    destructor Destroy; override;
    property BoundaryFormula[Index: Integer]: string read GetBoundaryFormula
      write SetBoundaryFormula;
    // @name fills ValueTimeList via a call to AssignCells for each
    // link  @link(TCfpRchFractionStorage) in
    // @link(TCustomMF_BoundColl.Boundaries Values.Boundaries);
    // Those represent non-parameter boundary conditions.
    // @name fills ParamList with the names of the
    // MODFLOW Recharge parameters that are in use.
    // The Objects property of ParamList has TObjectLists
    // Each such TObjectList is filled via a call to AssignCells
    // with each @link(TCfpRchFractionStorage) in @link(TCustomMF_BoundColl.Boundaries
    // Param.Param.Boundaries)
    // Those represent parameter boundary conditions.
    procedure GetCellValues(ValueTimeList: TList; ParamList: TStringList;
      AModel: TBaseModel; Writer: TObject); override;
    procedure InvalidateDisplay; override;
  published
    property DrainableStorageWidthX: string read GetDrainableStorageWidth
      write SetDrainableStorageWidth stored False;
  end;


implementation

uses RbwParser, ScreenObjectUnit, PhastModelUnit, ModflowTimeUnit,
  frmGoPhastUnit,
  AbstractGridUnit, DataSetNamesUnit, ModflowPackageSelectionUnit;

resourcestring
  StrCADSRechargeFracti = 'CADS Recharge Fraction';

const
  RechPosition = 0;
  CadsRechPosition = 1;

  StrRechargeFraction = 'Recharge fraction';
  StrRechargeFractionMulti = ' recharge fraction multiplier';

  DrainableStorageWidthPosition = 0;


{ TCfpRchFractionRecord }

procedure TCfpRchFractionRecord.Cache(Comp: TCompressionStream;
  Strings: TStringList);
begin
  WriteCompCell(Comp, Cell);
  WriteCompReal(Comp, CfpRechargeFraction);
  WriteCompReal(Comp, CfpCadsRechargeFraction);
  WriteCompReal(Comp, StartingTime);
  WriteCompReal(Comp, EndingTime);
  WriteCompInt(Comp, Strings.IndexOf(CfpRechargeFractionAnnotation));
  WriteCompInt(Comp, Strings.IndexOf(CfpCadsRechargeFractionAnnotation));
end;

procedure TCfpRchFractionRecord.RecordStrings(Strings: TStringList);
begin
  Strings.Add(CfpRechargeFractionAnnotation);
  Strings.Add(CfpCadsRechargeFractionAnnotation);
end;

procedure TCfpRchFractionRecord.Restore(Decomp: TDecompressionStream;
  Annotations: TStringList);
begin
  Cell := ReadCompCell(Decomp);
  CfpRechargeFraction := ReadCompReal(Decomp);
  CfpCadsRechargeFraction := ReadCompReal(Decomp);
  StartingTime := ReadCompReal(Decomp);
  EndingTime := ReadCompReal(Decomp);
  CfpRechargeFractionAnnotation := Annotations[ReadCompInt(Decomp)];
  CfpCadsRechargeFractionAnnotation := Annotations[ReadCompInt(Decomp)];
end;

{ TCfpRchFractionStorage }

procedure TCfpRchFractionStorage.Clear;
begin
  SetLength(FCfpRchFractionArray, 0);
  FCleared := True;
end;

function TCfpRchFractionStorage.GetCfpRchFractionArray: TCfpRchFractionArray;
begin
  if FCached and FCleared then
  begin
    RestoreData;
  end;
  result := FCfpRchFractionArray;
end;

procedure TCfpRchFractionStorage.Restore(
  DecompressionStream: TDecompressionStream; Annotations: TStringList);
var
  Index: Integer;
  Count: Integer;
begin
  DecompressionStream.Read(Count, SizeOf(Count));
  SetLength(FCfpRchFractionArray, Count);
  for Index := 0 to Count - 1 do
  begin
    FCfpRchFractionArray[Index].Restore(DecompressionStream, Annotations);
  end;
end;

procedure TCfpRchFractionStorage.Store(Compressor: TCompressionStream);
var
  Count: Integer;
  Index: Integer;
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    InitializeStrings(Strings);
    Count := Length(FCfpRchFractionArray);
    for Index := 0 to Count - 1 do
    begin
      FCfpRchFractionArray[Index].RecordStrings(Strings);
    end;
    WriteCompInt(Compressor, Strings.Count);

    for Index := 0 to Strings.Count - 1 do
    begin
      WriteCompString(Compressor, Strings[Index]);
    end;

    Compressor.Write(Count, SizeOf(Count));
    for Index := 0 to Count - 1 do
    begin
      FCfpRchFractionArray[Index].Cache(Compressor, Strings);
    end;

  finally
    Strings.Free;
  end;
end;

{ TCfpRchFractionItem }

procedure TCfpRchFractionItem.Assign(Source: TPersistent);
var
  CfpSource: TCfpRchFractionItem;
begin
  // if Assign is updated, update IsSame too.
  if Source is TCfpRchFractionItem then
  begin
    CfpSource := TCfpRchFractionItem(Source);
    CfpRechargeFraction := CfpSource.CfpRechargeFraction;
    CfpCadsRechargeFraction := CfpSource.CfpCadsRechargeFraction;
  end;
  inherited;

end;

procedure TCfpRchFractionItem.AssignObserverEvents(Collection: TCollection);
var
  ParentCollection: TCfpRchFractionCollection;
  RechObserver: TObserver;
  CadsRechObserver: TObserver;
begin
  ParentCollection := Collection as TCfpRchFractionCollection;
  RechObserver := FObserverList[RechPosition];
  RechObserver.OnUpToDateSet := ParentCollection.InvalidateRechargeData;
  CadsRechObserver := FObserverList[CadsRechPosition];
  CadsRechObserver.OnUpToDateSet := ParentCollection.InvalidateCadsRechargeData;
end;

function TCfpRchFractionItem.BoundaryFormulaCount: integer;
begin
  result := 2;
end;

procedure TCfpRchFractionItem.CreateFormulaObjects;
begin
  inherited;
  FCfpRechargeFraction := CreateFormulaObject(dso3D);
  FCfpCadsRechargeFraction := CreateFormulaObject(dso3D);
end;

destructor TCfpRchFractionItem.Destroy;
begin
  CfpRechargeFraction := '0';
  CfpCadsRechargeFraction := '0';
  inherited;
end;

function TCfpRchFractionItem.GetBoundaryFormula(Index: integer): string;
begin
  case Index of
    RechPosition: result := CfpRechargeFraction;
    CadsRechPosition: result := CfpCadsRechargeFraction;
    else Assert(False);
  end;
end;

procedure TCfpRchFractionItem.GetPropertyObserver(Sender: TObject; List: TList);
begin
  if Sender = FCfpRechargeFraction as TObject then
  begin
    List.Add(FObserverList[RechPosition]);
  end
  else if Sender = FCfpCadsRechargeFraction as TObject then
  begin
    List.Add(FObserverList[CadsRechPosition]);
  end
  else
  begin
    Assert(False);
  end;
end;

function TCfpRchFractionItem.GetCfpCadsRechargeFraction: string;
begin
  Result := FCfpCadsRechargeFraction.Formula;
  ResetItemObserver(CadsRechPosition);

end;

function TCfpRchFractionItem.GetCfpRechargeFraction: string;
begin
  Result := FCfpRechargeFraction.Formula;
  ResetItemObserver(RechPosition);
end;

function TCfpRchFractionItem.IsSame(AnotherItem: TOrderedItem): boolean;
var
  Item: TCfpRchFractionItem;
begin
  result := (AnotherItem is TCfpRchFractionItem) and inherited IsSame(AnotherItem);
  if result then
  begin
    Item := TCfpRchFractionItem(AnotherItem);
    result := (Item.CfpRechargeFraction = CfpRechargeFraction)
      and (Item.CfpCadsRechargeFraction = CfpCadsRechargeFraction)
  end;
end;

procedure TCfpRchFractionItem.RemoveFormulaObjects;
begin
  frmGoPhast.PhastModel.FormulaManager.Remove(FCfpRechargeFraction,
    GlobalRemoveModflowBoundaryItemSubscription,
    GlobalRestoreModflowBoundaryItemSubscription, self);
  frmGoPhast.PhastModel.FormulaManager.Remove(FCfpCadsRechargeFraction,
    GlobalRemoveModflowBoundaryItemSubscription,
    GlobalRestoreModflowBoundaryItemSubscription, self);
end;

procedure TCfpRchFractionItem.SetBoundaryFormula(Index: integer;
  const Value: string);
begin
  case Index of
    RechPosition: CfpRechargeFraction := Value;
    CadsRechPosition: CfpCadsRechargeFraction := Value;
    else Assert(False);
  end;
end;

procedure TCfpRchFractionItem.SetCfpCadsRechargeFraction(const Value: string);
begin
  UpdateFormulaBlocks(Value, CadsRechPosition, FCfpCadsRechargeFraction);
end;

procedure TCfpRchFractionItem.SetCfpRechargeFraction(const Value: string);
begin
  UpdateFormulaBlocks(Value, RechPosition, FCfpRechargeFraction);
end;

{ TCfpRchFractionTimeListLink }

procedure TCfpRchFractionTimeListLink.CreateTimeLists;
begin
  inherited;
  FCfpRechargeFractionData := TModflowTimeList.Create(Model, Boundary.ScreenObject);
  FCfpRechargeFractionData.NonParamDescription := StrRechargeFraction;
  FCfpRechargeFractionData.ParamDescription := StrRechargeFractionMulti;
  AddTimeList(FCfpRechargeFractionData);
  if Model <> nil then
  begin
    FCfpRechargeFractionData.OnInvalidate := (Model as TCustomModel).InvalidateMfConduitRecharge;
  end;
  FCfpCadsRechargeFractionData := TModflowTimeList.Create(Model, Boundary.ScreenObject);
  FCfpCadsRechargeFractionData.NonParamDescription := StrCADSRechargeFracti;
  FCfpCadsRechargeFractionData.ParamDescription := StrCADSRechargeFracti;
  AddTimeList(FCfpCadsRechargeFractionData);
  if Model <> nil then
  begin
    FCfpCadsRechargeFractionData.OnInvalidate := (Model as TCustomModel).InvalidateMfConduitCadsRecharge;
  end;
end;

destructor TCfpRchFractionTimeListLink.Destroy;
begin
  FCfpRechargeFractionData.Free;
  FCfpCadsRechargeFractionData.Free;
  inherited;
end;

{ TCfpRchFractionCollection }

procedure TCfpRchFractionCollection.AddSpecificBoundary(AModel: TBaseModel);
begin
  AddBoundary(TCfpRchFractionStorage.Create(AModel));
end;

procedure TCfpRchFractionCollection.AssignArrayCellValues(DataSets: TList;
  ItemIndex: Integer; AModel: TBaseModel; PestSeries: TStringList;
  PestMethods: TPestMethodList;
  PestItemNames, TimeSeriesNames: TStringListObjectList);
var
  RechargeRateArray: TDataArray;
  Boundary: TCfpRchFractionStorage;
  LayerIndex: Integer;
  RowIndex: Integer;
  ColIndex: Integer;
  BoundaryIndex: Integer;
  LocalModel: TCustomModel;
  LayerMin: Integer;
  RowMin: Integer;
  ColMin: Integer;
  LayerMax: Integer;
  RowMax: Integer;
  ColMax: Integer;
  CadsRechargeRateArray: TDataArray;
begin
  LocalModel := AModel as TCustomModel;
  BoundaryIndex := 0;
  RechargeRateArray := DataSets[RechPosition];
  CadsRechargeRateArray := DataSets[CadsRechPosition];
  Boundary := Boundaries[ItemIndex, AModel] as TCfpRchFractionStorage;
  RechargeRateArray.GetMinMaxStoredLimits(LayerMin, RowMin, ColMin,
    LayerMax, RowMax, ColMax);
  if LayerMin >= 0 then
  begin
    for LayerIndex := LayerMin to LayerMax do
    begin
      if LocalModel.IsLayerSimulated(LayerIndex) then
      begin
        for RowIndex := RowMin to RowMax do
        begin
          for ColIndex := ColMin to ColMax do
          begin
            if RechargeRateArray.IsValue[LayerIndex, RowIndex, ColIndex] then
            begin
              Assert(CadsRechargeRateArray.IsValue[LayerIndex, RowIndex, ColIndex]);
              with Boundary.CfpRchFractionArray[BoundaryIndex] do
              begin
                Cell.Layer := LayerIndex;
                Cell.Row := RowIndex;
                Cell.Column := ColIndex;
//                Cell.Section := Sections[LayerIndex, RowIndex, ColIndex];
                CfpRechargeFraction := RechargeRateArray.
                  RealData[LayerIndex, RowIndex, ColIndex];
                CfpRechargeFractionAnnotation := RechargeRateArray.
                  Annotation[LayerIndex, RowIndex, ColIndex];
                CfpCadsRechargeFraction := CadsRechargeRateArray.
                  RealData[LayerIndex, RowIndex, ColIndex];
                CfpCadsRechargeFractionAnnotation := CadsRechargeRateArray.
                  Annotation[LayerIndex, RowIndex, ColIndex];
              end;
              Inc(BoundaryIndex);
            end;
          end;
        end;
      end;
    end;
  end;
  RechargeRateArray.CacheData;
  CadsRechargeRateArray.CacheData;
  Boundary.CacheData;
end;

class function TCfpRchFractionCollection.GetTimeListLinkClass: TTimeListsModelLinkClass;
begin
  result := TCfpRchFractionTimeListLink;
end;

procedure TCfpRchFractionCollection.InitializeTimeLists(ListOfTimeLists: TList;
  AModel: TBaseModel; PestSeries: TStringList; PestMethods: TPestMethodList;
  PestItemNames, TimeSeriesNames: TStringListObjectList; Writer: TObject);
var
  TimeIndex: Integer;
  BoundaryValues: TBoundaryValueArray;
  Index: Integer;
  Item: TCfpRchFractionItem;
  ScreenObject: TScreenObject;
  ALink: TCfpRchFractionTimeListLink;
  RechargeRateData: TModflowTimeList;
  DataArrayIndex: Integer;
  DataArray: TTransientRealSparseDataSet;
  Grid: TCustomModelGrid;
  RowIndex: Integer;
  ColIndex: Integer;
  LayerIndex: Integer;
  ShouldRemove: Boolean;
  CadsRechargeRateData: TModflowTimeList;
  ConduitFlowProcess: TConduitFlowProcess;
begin
  ScreenObject := BoundaryGroup.ScreenObject as TScreenObject;
  SetLength(BoundaryValues, Count);
  for Index := 0 to Count - 1 do
  begin
    Item := Items[Index] as TCfpRchFractionItem;
    BoundaryValues[Index].Time := Item.StartTime;
    BoundaryValues[Index].Formula := Item.CfpRechargeFraction;
  end;
  ALink := TimeListLink.GetLink(AModel) as TCfpRchFractionTimeListLink;
  RechargeRateData := ALink.FCfpRechargeFractionData;
  RechargeRateData.Initialize(BoundaryValues, ScreenObject, lctUse);
  Assert(RechargeRateData.Count = Count);

  for Index := 0 to Count - 1 do
  begin
    Item := Items[Index] as TCfpRchFractionItem;
    BoundaryValues[Index].Time := Item.StartTime;
    BoundaryValues[Index].Formula := Item.CfpCadsRechargeFraction;
  end;
  CadsRechargeRateData := ALink.FCfpCadsRechargeFractionData;
  CadsRechargeRateData.Initialize(BoundaryValues, ScreenObject, lctUse);
  Assert(CadsRechargeRateData.Count = Count);

  if PackageAssignmentMethod(AModel) = umAdd then
  begin
    Grid := (AModel as TCustomModel).Grid;
    for DataArrayIndex := 0 to RechargeRateData.Count - 1 do
    begin
      DataArray := RechargeRateData[DataArrayIndex] as TTransientRealSparseDataSet;
      for RowIndex := 0 to Grid.RowCount - 1 do
      begin
        for ColIndex := 0 to Grid.ColumnCount - 1 do
        begin
          ShouldRemove := False;
          for LayerIndex := Grid.LayerCount -1 downto 0 do
          begin
            if ShouldRemove then
            begin
              DataArray.RemoveValue(LayerIndex, RowIndex, ColIndex);
            end
            else
            begin
              ShouldRemove := DataArray.IsValue[LayerIndex, RowIndex, ColIndex];
            end;
          end;
        end;
      end;
    end;
  end;

  ConduitFlowProcess := (AModel as TCustomModel).ModflowPackages.ConduitFlowProcess;
  if (PackageAssignmentMethod(AModel) = umAdd) and (Model.ModelSelection = msModflowOwhm2)
    and ConduitFlowProcess.UseCads and ConduitFlowProcess.UseCadsRecharge then
  begin
    Grid := (AModel as TCustomModel).Grid;
    for DataArrayIndex := 0 to CadsRechargeRateData.Count - 1 do
    begin
      DataArray := CadsRechargeRateData[DataArrayIndex] as TTransientRealSparseDataSet;
      for RowIndex := 0 to Grid.RowCount - 1 do
      begin
        for ColIndex := 0 to Grid.ColumnCount - 1 do
        begin
          ShouldRemove := False;
          for LayerIndex := Grid.LayerCount -1 downto 0 do
          begin
            if ShouldRemove then
            begin
              DataArray.RemoveValue(LayerIndex, RowIndex, ColIndex);
            end
            else
            begin
              ShouldRemove := DataArray.IsValue[LayerIndex, RowIndex, ColIndex];
            end;
          end;
        end;
      end;
    end;
  end;

  ClearBoundaries(AModel);
  SetBoundaryCapacity(RechargeRateData.Count, AModel);
  for TimeIndex := 0 to RechargeRateData.Count - 1 do
  begin
    AddBoundary(TCfpRchFractionStorage.Create(AModel));
  end;
  ListOfTimeLists.Add(RechargeRateData);
  ListOfTimeLists.Add(CadsRechargeRateData);
end;

procedure TCfpRchFractionCollection.InvalidateCadsRechargeData(Sender: TObject);
var
  PhastModel: TPhastModel;
  Link: TCfpRchFractionTimeListLink;
  ChildIndex: Integer;
  ChildModel: TChildModel;
begin
  if not (Sender as TObserver).UpToDate then
  begin
    PhastModel := frmGoPhast.PhastModel;
    if PhastModel.Clearing then
    begin
      Exit;
    end;
    Link := TimeListLink.GetLink(PhastModel) as TCfpRchFractionTimeListLink;
    Link.FCfpCadsRechargeFractionData.Invalidate;
    for ChildIndex := 0 to PhastModel.ChildModels.Count - 1 do
    begin
      ChildModel := PhastModel.ChildModels[ChildIndex].ChildModel;
      if ChildModel <> nil then
      begin
        Link := TimeListLink.GetLink(ChildModel) as TCfpRchFractionTimeListLink;
        Link.FCfpCadsRechargeFractionData.Invalidate;
      end;
    end;
  end;
end;

procedure TCfpRchFractionCollection.InvalidateRechargeData(Sender: TObject);
var
  PhastModel: TPhastModel;
  Link: TCfpRchFractionTimeListLink;
  ChildIndex: Integer;
  ChildModel: TChildModel;
begin
  if not (Sender as TObserver).UpToDate then
  begin
    PhastModel := frmGoPhast.PhastModel;
    if PhastModel.Clearing then
    begin
      Exit;
    end;
    Link := TimeListLink.GetLink(PhastModel) as TCfpRchFractionTimeListLink;
    Link.FCfpRechargeFractionData.Invalidate;
    for ChildIndex := 0 to PhastModel.ChildModels.Count - 1 do
    begin
      ChildModel := PhastModel.ChildModels[ChildIndex].ChildModel;
      if ChildModel <> nil then
      begin
        Link := TimeListLink.GetLink(ChildModel) as TCfpRchFractionTimeListLink;
        Link.FCfpRechargeFractionData.Invalidate;
      end;
    end;
  end;
end;

class function TCfpRchFractionCollection.ItemClass: TBoundaryItemClass;
begin
  result := TCfpRchFractionItem;
end;

function TCfpRchFractionCollection.PackageAssignmentMethod(
  AModel: TBaseModel): TUpdateMethod;
begin
  result := umAssign;
end;

procedure TCfpRchFractionCollection.SetBoundaryStartAndEndTime(
  BoundaryCount: Integer; Item: TCustomModflowBoundaryItem; ItemIndex: Integer;
  AModel: TBaseModel);
begin
  SetLength((Boundaries[ItemIndex, AModel] as TCfpRchFractionStorage).FCfpRchFractionArray, BoundaryCount);
  inherited;
end;

{ TCfpRchFraction_Cell }

procedure TCfpRchFraction_Cell.Cache(Comp: TCompressionStream;
  Strings: TStringList);
begin
  inherited;
  Values.Cache(Comp, Strings);
  WriteCompInt(Comp, StressPeriod);
end;

function TCfpRchFraction_Cell.GetColumn: integer;
begin
  result := Values.Cell.Column;
end;

function TCfpRchFraction_Cell.GetIntegerAnnotation(Index: integer;
  AModel: TBaseModel): string;
begin
  result := '';
  Assert(False);
end;

function TCfpRchFraction_Cell.GetIntegerValue(Index: integer;
  AModel: TBaseModel): integer;
begin
  result := 0;
  Assert(False);
end;

function TCfpRchFraction_Cell.GetLayer: integer;
begin
  result := Values.Cell.Layer;
end;

function TCfpRchFraction_Cell.GetRealAnnotation(Index: integer;
  AModel: TBaseModel): string;
begin
  result := '';
  case Index of
    RechPosition: result := CfpRechargeFractionAnnotation;
    CadsRechPosition: result := CfpCadsRechargeFractionAnnotation;
    else Assert(False);
  end;
end;

function TCfpRchFraction_Cell.GetRealValue(Index: integer;
  AModel: TBaseModel): double;
begin
  result := 0;
  case Index of
    RechPosition: result := CfpRechargeFraction;
    CadsRechPosition: result := CfpCadsRechargeFraction;
    else Assert(False);
  end;
end;

function TCfpRchFraction_Cell.GetCadsCfpRechargeFractionAnnotation: string;
begin
  result := Values.CfpCadsRechargeFractionAnnotation;
end;

function TCfpRchFraction_Cell.GetCfpCadsRechargeFraction: double;
begin
  result := Values.CfpCadsRechargeFraction;
end;

function TCfpRchFraction_Cell.GetCfpRechargeFraction: double;
begin
  result := Values.CfpRechargeFraction;
end;

function TCfpRchFraction_Cell.GetCfpRechargeFractionAnnotation: string;
begin
  result := Values.CfpRechargeFractionAnnotation;
end;

function TCfpRchFraction_Cell.GetRow: integer;
begin
  result := Values.Cell.Row;
end;

function TCfpRchFraction_Cell.GetSection: integer;
begin
  result := Values.Cell.Section;
end;

procedure TCfpRchFraction_Cell.RecordStrings(Strings: TStringList);
begin
  inherited;
  Values.RecordStrings(Strings);
end;

procedure TCfpRchFraction_Cell.Restore(Decomp: TDecompressionStream;
  Annotations: TStringList);
begin
  inherited;
  Values.Restore(Decomp, Annotations);
  StressPeriod := ReadCompInt(Decomp);
end;

procedure TCfpRchFraction_Cell.SetColumn(const Value: integer);
begin
  FValues.Cell.Column := Value;
end;

procedure TCfpRchFraction_Cell.SetLayer(const Value: integer);
begin
  FValues.Cell.Layer := Value;
end;

procedure TCfpRchFraction_Cell.SetRow(const Value: integer);
begin
  FValues.Cell.Row := Value;
end;

{ TCfpRchFractionBoundary }

procedure TCfpRchFractionBoundary.Assign(Source: TPersistent);
var
  SourceCfpRchFraction: TCfpRchFractionBoundary;
begin
  if Source is TCfpRchFractionBoundary then
  begin
    SourceCfpRchFraction := TCfpRchFractionBoundary(Source);
    DrainableStorageWidthX := SourceCfpRchFraction.DrainableStorageWidthX;
  end;
  inherited;
end;

procedure TCfpRchFractionBoundary.AssignCells(
  BoundaryStorage: TCustomBoundaryStorage; ValueTimeList: TList;
  AModel: TBaseModel);
var
  Cell: TCfpRchFraction_Cell;
  BoundaryValues: TCfpRchFractionRecord;
  BoundaryIndex: Integer;
  StressPeriod: TModflowStressPeriod;
  TimeIndex: Integer;
  Cells: TValueCellList;
  LocalBoundaryStorage: TCfpRchFractionStorage;
  LocalModel: TCustomModel;
begin
  LocalModel := AModel as TCustomModel;
  LocalBoundaryStorage := BoundaryStorage as TCfpRchFractionStorage;
  for TimeIndex := 0 to
    LocalModel.ModflowFullStressPeriods.Count - 1 do
  begin
    if TimeIndex < ValueTimeList.Count then
    begin
      Cells := ValueTimeList[TimeIndex];
    end
    else
    begin
      Cells := TValueCellList.Create(TCfpRchFraction_Cell);
      ValueTimeList.Add(Cells);
    end;
    StressPeriod := LocalModel.ModflowFullStressPeriods[TimeIndex];
    // Check if the stress period is completely enclosed within the times
    // of the LocalBoundaryStorage;
    if (StressPeriod.StartTime + LocalModel.SP_Epsilon >= LocalBoundaryStorage.StartingTime)
      and (StressPeriod.EndTime - LocalModel.SP_Epsilon <= LocalBoundaryStorage.EndingTime) then
    begin
      if Cells.Capacity < Cells.Count + Length(LocalBoundaryStorage.CfpRchFractionArray) then
      begin
        Cells.Capacity := Cells.Count + Max(Length(LocalBoundaryStorage.CfpRchFractionArray), Cells.Count div 4);
      end;
//      Cells.CheckRestore;
      for BoundaryIndex := 0 to Length(LocalBoundaryStorage.CfpRchFractionArray) - 1 do
      begin
        BoundaryValues := LocalBoundaryStorage.CfpRchFractionArray[BoundaryIndex];
        Cell := TCfpRchFraction_Cell.Create;
        Cells.Add(Cell);
        Cell.StressPeriod := TimeIndex;
        Cell.Values := BoundaryValues;
        Cell.ScreenObject := ScreenObjectI;
//        LocalModel.AdjustCellPosition(Cell);
      end;
      Cells.Cache;
    end;
  end;
  LocalBoundaryStorage.CacheData;
end;

class function TCfpRchFractionBoundary.BoundaryCollectionClass: TMF_BoundCollClass;
begin
  result := TCfpRchFractionCollection;
end;

function TCfpRchFractionBoundary.BoundaryObserverPrefix: string;
begin
  result := 'CfpRechargeBoundary_';
end;

constructor TCfpRchFractionBoundary.Create(Model: TBaseModel;
  ScreenObject: TObject);
begin
  inherited;
  CreateFormulaObjects;
  CreateBoundaryObserver;
  CreateObservers;
  DrainableStorageWidthX := '1';
end;

procedure TCfpRchFractionBoundary.CreateFormulaObjects;
begin
  FDrainableStorageWidth := CreateFormulaObjectBlocks(dso3D);
end;

procedure TCfpRchFractionBoundary.CreateObservers;
begin
  if ScreenObject <> nil then
  begin
    FObserverList.Add(DrainableStorageWidthObserver);
  end;
end;

destructor TCfpRchFractionBoundary.Destroy;
begin
  DrainableStorageWidthX := '0';
  inherited;
end;

function TCfpRchFractionBoundary.GetBoundaryFormula(Index: Integer): string;
begin
  case Index of
    DrainableStorageWidthPosition: result := DrainableStorageWidthX;
    else Assert(False);
  end;
end;

procedure TCfpRchFractionBoundary.GetCellValues(ValueTimeList: TList;
  ParamList: TStringList; AModel: TBaseModel; Writer: TObject);
var
  ValueIndex: Integer;
  BoundaryStorage: TCfpRchFractionStorage;
//  ParamIndex: Integer;
//  Param: TModflowParamItem;
//  Times: TList;
//  Position: integer;
//  ParamName: string;
//  Model: TCustomModel;
begin
  EvaluateArrayBoundaries(AModel, Writer);
//  Model := ParentModel as TCustomModel;
  for ValueIndex := 0 to Values.Count - 1 do
  begin
    if ValueIndex < Values.BoundaryCount[AModel] then
    begin
      BoundaryStorage := Values.Boundaries[ValueIndex, AModel] as TCfpRchFractionStorage;
      AssignCells(BoundaryStorage, ValueTimeList, AModel);
    end;
  end;
  ClearBoundaries(AModel);

end;

function TCfpRchFractionBoundary.GetDrainableStorageWidth: string;
begin
  Result := FDrainableStorageWidth.Formula;
  if ScreenObject <> nil then
  begin
    ResetBoundaryObserver(DrainableStorageWidthPosition);
  end;
end;

function TCfpRchFractionBoundary.GetDrainableStorageWidthObserver: TObserver;
var
  Model: TPhastModel;
  DataArray: TDataArray;
begin
  if FDrainableStorageWidthObserver = nil then
  begin
    if ParentModel <> nil then
    begin
      Model := ParentModel as TPhastModel;
      DataArray := Model.DataArrayManager.GetDataSetByName(KDrainableStorageWidth);
    end
    else
    begin
      DataArray := nil;
    end;
    CreateObserver('Cfp_DrainableStorageWidth_', FDrainableStorageWidthObserver, DataArray);
  end;
  result := FDrainableStorageWidthObserver;
end;

procedure TCfpRchFractionBoundary.GetPropertyObserver(Sender: TObject;
  List: TList);
begin
  if Sender = FDrainableStorageWidth as TObject then
  begin
    List.Add(FObserverList[DrainableStorageWidthPosition]);
  end;
end;

procedure TCfpRchFractionBoundary.InvalidateDisplay;
var
  Model: TCustomModel;
begin
  if Used and (ParentModel <> nil) then
  begin
    Model := ParentModel as TCustomModel;
    Model.InvalidateMfConduitRecharge(self);
    Model.InvalidateMfConduitCadsRecharge(self);
  end;

end;

procedure TCfpRchFractionBoundary.SetBoundaryFormula(Index: Integer;
  const Value: string);
begin
  case Index of
    DrainableStorageWidthPosition:
      DrainableStorageWidthX := Value;
    else Assert(False);
  end;
end;

procedure TCfpRchFractionBoundary.SetDrainableStorageWidth(const Value: string);
begin
  UpdateFormulaBlocks(Value, DrainableStorageWidthPosition, FDrainableStorageWidth);

end;

end.
