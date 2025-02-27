unit PestObservationResults;

interface

uses DataSetUnit, Graphics, GR32, Classes, System.SysUtils,
  Vcl.Dialogs, ObsInterfaceUnit, System.Generics.Collections, ScreenObjectUnit,
  ZoomBox2, GoPhastTypes, GR32_Polygons, PestObsUnit;

type
  TDrawChoice = (dcResidual, dcWeightedResidual);

  TPestObsCollection = class;

  TPestObsResult = class(TPhastCollectionItem)
  private
    FName: string;
    FOriginalOrder: Integer;
    FGroupName: string;
    FObjectName: string;
    FScreenObject: TScreenObject;
    FStoredMeasured: TRealStorage;
    FStoredWeightedModeled: TRealStorage;
    FStoredWeight: TRealStorage;
    FStoredMeasurementStdDeviation: TRealStorage;
    FStoredWeightedMeasured: TRealStorage;
    FStoredResidual: TRealStorage;
    FStoredNaturalWeight: TRealStorage;
    FStoredModeled: TRealStorage;
    FStoredWeightedResidual: TRealStorage;
    FVisible: Boolean;
    FStoredTime: TRealStorage;
    Fx: double;
    Fy: double;
    FPestObsCollection: TPestObsCollection;
    FMeasurementStdDeviationText: string;
    FNaturalWeightText: string;
    FWeightedResidualText: string;
    FWeightedModeledText: string;
    FWeightText: string;
    FWeightedMeasuredText: string;
    FResidualText: string;
    FPlotLabel: Boolean;
    procedure SetGroupName(const Value: string);
    procedure SetMeasured(const Value: double);
    procedure SetMeasurementStdDeviation(const Value: double);
    procedure SetModeled(const Value: double);
    procedure SetName(const Value: string);
    procedure SetNaturalWeight(const Value: double);
    procedure SetOriginalOrder(const Value: Integer);
    procedure SetResidual(const Value: double);
    procedure SetWeight(const Value: double);
    procedure SetWeightedMeasured(const Value: double);
    procedure SetWeightedModeled(const Value: double);
    procedure SetWeightedResidual(const Value: double);
    procedure SetObjectName(const Value: string);
    function GetObjectName: string;
    function GetScreenObject: TScreenObject;
    procedure SetStoredMeasured(const Value: TRealStorage);
    function GetMeasured: double;
    procedure SetStoredMeasurementStdDeviation(const Value: TRealStorage);
    procedure SetStoredModeled(const Value: TRealStorage);
    procedure SetStoredNaturalWeight(const Value: TRealStorage);
    procedure SetStoredResidual(const Value: TRealStorage);
    procedure SetStoredWeight(const Value: TRealStorage);
    procedure SetStoredWeightedMeasured(const Value: TRealStorage);
    procedure SetStoredWeightedModeled(const Value: TRealStorage);
    procedure SetStoredWeightedResidual(const Value: TRealStorage);
    function GetModeled: double;
    function GetResidual: double;
    function GetWeight: double;
    function GetWeightedMeasured: double;
    function GetWeightedModeled: double;
    function GetWeightedResidual: double;
    function GetMeasurementStdDeviation: double;
    function GetNaturalWeight: double;
    procedure SetVisible(const Value: Boolean);
    procedure SetStoredTime(const Value: TRealStorage);
    function GetTime: double;
    procedure SetTime(const Value: double);
    procedure Draw(const BitMap: TPersistent; const ZoomBox: TQrbwZoomBox2);
    procedure SetMeasurementStdDeviationText(const Value: string);
    procedure SetNaturalWeightText(const Value: string);
    procedure SetWeightedMeasuredText(const Value: string);
    procedure SetWeightedModeledText(const Value: string);
    procedure SetWeightedResidualText(const Value: string);
    procedure SetWeightText(const Value: string);
    procedure SetResidualText(const Value: string);
    procedure SetPlotLabel(const Value: Boolean);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property ScreenObject: TScreenObject read GetScreenObject;
    property Measured: double read GetMeasured write SetMeasured;
    property Modeled: double read GetModeled write SetModeled;
    property Residual: double read GetResidual write SetResidual;
    property Weight: double read GetWeight write SetWeight;
    property WeightedMeasured: double read GetWeightedMeasured write SetWeightedMeasured;
    property WeightedModeled: double read GetWeightedModeled write SetWeightedModeled;
    property WeightedResidual: double read GetWeightedResidual write SetWeightedResidual;
    property MeasurementStdDeviation: double read GetMeasurementStdDeviation write SetMeasurementStdDeviation;
    property NaturalWeight: double read GetNaturalWeight write SetNaturalWeight;
    property Time: double read GetTime Write SetTime;
    property X: double read Fx;
    property Y: double read Fy;
  published
    property Name: string read FName write SetName;
    property GroupName: string read FGroupName write SetGroupName;
    property StoredMeasured: TRealStorage read FStoredMeasured write SetStoredMeasured;
    property StoredModeled: TRealStorage read FStoredModeled write SetStoredModeled;
    property StoredResidual: TRealStorage read FStoredResidual write SetStoredResidual;
    property StoredWeight: TRealStorage read FStoredWeight write SetStoredWeight;
    property StoredWeightedMeasured: TRealStorage read FStoredWeightedMeasured write SetStoredWeightedMeasured;
    property StoredWeightedModeled: TRealStorage read FStoredWeightedModeled write SetStoredWeightedModeled;
    property StoredWeightedResidual: TRealStorage read FStoredWeightedResidual write SetStoredWeightedResidual;
    property StoredMeasurementStdDeviation: TRealStorage read FStoredMeasurementStdDeviation write SetStoredMeasurementStdDeviation;
    property StoredNaturalWeight: TRealStorage read FStoredNaturalWeight write SetStoredNaturalWeight;
    property OriginalOrder: Integer read FOriginalOrder write SetOriginalOrder;
    property ObjectName: string read GetObjectName write SetObjectName;
    property StoredTime: TRealStorage read FStoredTime write SetStoredTime;
    property ResidualText: string read FResidualText write SetResidualText;
    property WeightText: string read FWeightText write SetWeightText;
    property WeightedMeasuredText: string read FWeightedMeasuredText write SetWeightedMeasuredText;
    property WeightedModeledText: string read FWeightedModeledText write SetWeightedModeledText;
    property WeightedResidualText: string read FWeightedResidualText write SetWeightedResidualText;
    property MeasurementStdDeviationText: string read FMeasurementStdDeviationText write SetMeasurementStdDeviationText;
    property NaturalWeightText: string read FNaturalWeightText write SetNaturalWeightText;
    property Visible: Boolean read FVisible write SetVisible;
    property PlotLabel: Boolean read FPlotLabel write SetPlotLabel stored True;
  end;

  TPestObsCollection = class(TPhastCollection)
  strict private
    FUsedObservations : TDictionary<string, IObservationItem>;
    FGuidObs : TDictionary<string, IObservationItem>;
  private
    { TODO -cRefactor : Consider replacing FModel with a TNotifyEvent or interface. }
    //
    FModel: TBaseModel;
    FMaxTimeLimit: TColoringLimit;
    FMinWeightedResidualLimit: TColoringLimit;
    FFileName: string;
    FFileDate: TDateTime;
    FMaxResidualLimit: TColoringLimit;
    FMinTimeLimit: TColoringLimit;
    FMinResidualLimit: TColoringLimit;
    FVisible: boolean;
    FMaxWeightedResidualLimit: TColoringLimit;
    FMaxSymbolSize: integer;
    FPositiveColor: TColor;
    FNegativeColor: TColor;
    FPositiveColor32: TColor32;
    FNegativeColor32: TColor32;
    FMaxObjectResidual: double;
    FMaxObjectWeightedResidual: double;
    FDrawChoice: TDrawChoice;
//    FObsItemDictionary: TObsItemDictionary;
    procedure SetVisible(const Value: boolean);
    procedure SetFileDate(const Value: TDateTime);
    procedure SetFileName(const Value: string);
    procedure SetMaxResidualLimit(const Value: TColoringLimit);
    procedure SetMaxSymbolSize(const Value: integer);
    procedure SetMaxTimeLimit(const Value: TColoringLimit);
    procedure SetMaxWeightedResidualLimit(const Value: TColoringLimit);
    procedure SetMinResidualLimit(const Value: TColoringLimit);
    procedure SetMinTimeLimit(const Value: TColoringLimit);
    procedure SetMinWeightedResidualLimit(const Value: TColoringLimit);
    procedure SetNegativeColor(const Value: TColor);
    procedure SetPositiveColor(const Value: TColor);
    procedure InitializeVariables;
    function GetItems(Index: Integer): TPestObsResult;
    procedure SetItems(Index: Integer; const Value: TPestObsResult);
    procedure GetExistingObservations;
//    procedure UpdateVisibleItems;
    procedure SetDrawChoice(const Value: TDrawChoice);
  public
    constructor Create(Model: TBaseModel);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function ReadFromFile(const AFileName: string): boolean;
    function Add: TPestObsResult;
    procedure Clear;
    property Items[Index: Integer]: TPestObsResult read GetItems
      write SetItems; default;
    procedure Draw(const BitMap: TPersistent; const ZoomBox: TQrbwZoomBox2);
    function RootMeanSquareResidual: double;
    function RootMeanSquareWeightedResidual: double;
    property MaxObjectResidual: double read FMaxObjectResidual;
    property MaxObjectWeightedResidual: double read FMaxObjectWeightedResidual;
    procedure CalculateMaxValues;
  published
    property FileName: string read FFileName write SetFileName;
    property FileDate: TDateTime read FFileDate write SetFileDate;
    property MaxResidualLimit: TColoringLimit read FMaxResidualLimit
      write SetMaxResidualLimit;
    property MinResidualLimit: TColoringLimit read FMinResidualLimit
      write SetMinResidualLimit;
    property MaxWeightedResidualLimit: TColoringLimit read FMaxWeightedResidualLimit
      write SetMaxWeightedResidualLimit;
    property MinWeightedResidualLimit: TColoringLimit read FMinWeightedResidualLimit
      write SetMinWeightedResidualLimit;
    property MaxTimeLimit: TColoringLimit read FMaxTimeLimit
      write SetMaxTimeLimit;
    property MinTimeLimit: TColoringLimit read FMinTimeLimit
      write SetMinTimeLimit;
    property NegativeColor: TColor read FNegativeColor
      write SetNegativeColor default clRed;
    property PositiveColor: TColor read FPositiveColor
      write SetPositiveColor default clBlue;
    property MaxSymbolSize: integer read FMaxSymbolSize
      write SetMaxSymbolSize default 20;
    property Visible: boolean read FVisible write SetVisible default True;
    property DrawChoice: TDrawChoice read FDrawChoice
      write SetDrawChoice default dcWeightedResidual;
  end;

implementation

uses RbwParser, System.IOUtils, frmErrorsAndWarningsUnit, ModelMuseUtilities,
  PhastModelUnit, frmGoPhastUnit, BigCanvasMethods, System.Math,
  System.StrUtils, ObservationComparisonsUnit, System.Character;

resourcestring
  StrTheFileFromWhich = 'The file from which you are attempting to read ' +
  'residuals, %s, does not exist.';
  StrNotRecorded = 'Not recorded';

{ TPestObsResult }

function CompareAbsWeightedResiduals(Item1, Item2: Pointer): Integer;
var
  P1, P2: TPestObsResult;
  Value1: Double;
  Value2: Double;
begin
  P1 := Item1;
  P2 := Item2;
  Value1 := Abs(P1.WeightedResidual);
  Value2 := Abs(P2.WeightedResidual);
  result := -Sign(Value1 - Value2);
end;

function CompareAbsResiduals(Item1, Item2: Pointer): Integer;
var
  P1, P2: TPestObsResult;
  Value1: Double;
  Value2: Double;
begin
  P1 := Item1;
  P2 := Item2;
  Value1 := Abs(P1.Residual);
  Value2 := Abs(P2.Residual);
  result := -Sign(Value1 - Value2);
end;


procedure TPestObsResult.Assign(Source: TPersistent);
var
  ObsSource: TPestObsResult;
begin
  if Source is TPestObsResult then
  begin
    ObsSource := TPestObsResult(Source);
    Name := ObsSource.Name;
    GroupName := ObsSource.GroupName;
    Measured := ObsSource.Measured;
    Modeled := ObsSource.Modeled;
    Residual := ObsSource.Residual;
    Weight := ObsSource.Weight;
    WeightedMeasured := ObsSource.WeightedMeasured;
    WeightedModeled := ObsSource.WeightedModeled;
    WeightedResidual := ObsSource.WeightedResidual;
    MeasurementStdDeviation := ObsSource.MeasurementStdDeviation;
    NaturalWeight := ObsSource.NaturalWeight;
    Time := ObsSource.Time;
    OriginalOrder := ObsSource.OriginalOrder;
    ObjectName := ObsSource.ObjectName;
    WeightText := ObsSource.WeightText;
    WeightedMeasuredText := ObsSource.WeightedMeasuredText;
    WeightedModeledText := ObsSource.WeightedModeledText;
    WeightedResidualText := ObsSource.WeightedResidualText;
    MeasurementStdDeviationText := ObsSource.MeasurementStdDeviationText;
    NaturalWeightText := ObsSource.NaturalWeightText;
    FScreenObject := ObsSource.ScreenObject;
    PlotLabel := ObsSource.PlotLabel;
  end
  else
  begin
    inherited;
  end;
end;

constructor TPestObsResult.Create(Collection: TCollection);
var
  InvalidateModelEvent: TNotifyEvent;
  LocalModel: TBaseModel;
begin
  inherited;
  FPestObsCollection := Collection as TPestObsCollection;
  LocalModel := FPestObsCollection.FModel;
  if LocalModel = nil then
  begin
    InvalidateModelEvent := nil;
  end
  else
  begin
    InvalidateModelEvent := LocalModel.DoInvalidate;
  end;
  FStoredMeasured := TRealStorage.Create(InvalidateModelEvent);
  FStoredWeightedModeled := TRealStorage.Create(InvalidateModelEvent);
  FStoredWeight := TRealStorage.Create(InvalidateModelEvent);
  FStoredMeasurementStdDeviation := TRealStorage.Create(InvalidateModelEvent);
  FStoredWeightedMeasured := TRealStorage.Create(InvalidateModelEvent);
  FStoredResidual := TRealStorage.Create(InvalidateModelEvent);
  FStoredNaturalWeight := TRealStorage.Create(InvalidateModelEvent);
  FStoredModeled := TRealStorage.Create(InvalidateModelEvent);
  FStoredWeightedResidual := TRealStorage.Create(InvalidateModelEvent);
  FStoredTime := TRealStorage.Create(InvalidateModelEvent);
end;

destructor TPestObsResult.Destroy;
begin
  FStoredTime.Free;
  FStoredWeightedResidual.Free;
  FStoredModeled.Free;
  FStoredNaturalWeight.Free;
  FStoredResidual.Free;
  FStoredWeightedMeasured.Free;
  FStoredMeasurementStdDeviation.Free;
  FStoredWeight.Free;
  FStoredWeightedModeled.Free;
  FStoredMeasured.Free;
  inherited;
end;

procedure TPestObsResult.Draw(const BitMap: TPersistent;
  const ZoomBox: TQrbwZoomBox2);
const
  MaxPoints = 12;
  PointsPerHalfCircle = MaxPoints div 2;
var
  XCenter: Integer;
  YCenter: Integer;
  Radius: Double;
  Points: TPointArray;
  PointIndex: Integer;
  Angle: double;
  Color: TColor32;
  APolygon: TPolygon32;
  ClipRect: TRect;
  MaxValue: double;
  Value: Double;
  function GetClipRect(Graphic: TPersistent): TRect;
  begin
    if Graphic is TBitmap32 then
    begin
      result := TBitmap32(Graphic).Canvas.ClipRect;
    end
    else
    begin
      result := (Graphic as TCanvas).ClipRect;
    end;
  end;
begin
  if not Visible then
  begin
    Exit;
  end;
  XCenter := ZoomBox.XCoord(X);
  YCenter := ZoomBox.YCoord(Y);
  if Residual > 0 then
  begin
    Color := FPestObsCollection.FPositiveColor32;
  end
  else
  begin
    Color := FPestObsCollection.FNegativeColor32;
  end;
  MaxValue := 1;
  Value := 0;
  case FPestObsCollection.DrawChoice of
    dcResidual:
      begin
        MaxValue := FPestObsCollection.MaxObjectResidual;
        Value := Residual;
      end;
    dcWeightedResidual:
      begin
        MaxValue := FPestObsCollection.MaxObjectWeightedResidual;
        Value := WeightedResidual;
      end;
    else
      begin
        Assert(False);
      end;
  end;
  Radius :=
    Sqrt(Abs(Value)/MaxValue)
    * (FPestObsCollection.MaxSymbolSize / 2);

  ClipRect := GetClipRect(BitMap);
  if XCenter + Radius < ClipRect.Left then
  begin
    Exit;
  end;
  if XCenter - Radius > ClipRect.Right then
  begin
    Exit;
  end;
  if YCenter + Radius < ClipRect.Top then
  begin
    Exit;
  end;
  if YCenter - Radius > ClipRect.Bottom then
  begin
    Exit;
  end;

  SetLength(Points, MaxPoints);
  for PointIndex := 0 to MaxPoints - 1 do
  begin
    Angle := PointIndex * Pi / PointsPerHalfCircle;
    Points[PointIndex].X := Round(XCenter + Cos(Angle)*Radius);
    Points[PointIndex].Y := Round(YCenter + Sin(Angle)*Radius);
  end;
  APolygon := nil;
  DrawBigPolygon32(BitMap, Color, Color, 0.1, Points, APolygon, False, True);
  if PlotLabel then
  begin
    DrawBigText(BitMap, Point(XCenter, YCenter), Name);
  end;
end;

function TPestObsResult.GetMeasured: double;
begin
  result := FStoredMeasured.Value;
end;

function TPestObsResult.GetMeasurementStdDeviation: double;
begin
  result := StoredMeasurementStdDeviation.Value;
end;

function TPestObsResult.GetModeled: double;
begin
  result := StoredModeled.Value;
end;

function TPestObsResult.GetNaturalWeight: double;
begin
  result := StoredNaturalWeight.Value;
end;

function TPestObsResult.GetObjectName: string;
begin
  if FScreenObject <> nil then
  begin
    result := FScreenObject.Name
  end
  else
  begin
    result := FObjectName;
  end;
end;

function TPestObsResult.GetResidual: double;
begin
  result := StoredResidual.Value;
end;

function TPestObsResult.GetScreenObject: TScreenObject;
begin
  if (FScreenObject = nil) and (ObjectName <> '') then
  begin
    FScreenObject := frmGoPhast.PhastModel.GetScreenObjectByName(ObjectName);
  end;
  if (FScreenObject = nil) or FScreenObject.Deleted then
  begin
    result := nil;
  end
  else
  begin
    result := FScreenObject as TScreenObject;
  end;
end;

function TPestObsResult.GetTime: double;
begin
  result := StoredTime.Value;
end;

function TPestObsResult.GetWeight: double;
begin
  result := StoredWeight.Value;
end;

function TPestObsResult.GetWeightedMeasured: double;
begin
  result := StoredWeightedMeasured.Value;
end;

function TPestObsResult.GetWeightedModeled: double;
begin
  result := StoredWeightedModeled.Value;
end;

function TPestObsResult.GetWeightedResidual: double;
begin
  result := StoredWeightedResidual.Value;
end;

procedure TPestObsResult.SetGroupName(const Value: string);
begin
  SetStringProperty(FGroupName, Value);
end;

procedure TPestObsResult.SetMeasured(const Value: double);
begin
  FStoredMeasured.Value := Value;
end;

procedure TPestObsResult.SetMeasurementStdDeviation(const Value: double);
begin
  StoredMeasurementStdDeviation.Value := Value;
end;

procedure TPestObsResult.SetMeasurementStdDeviationText(const Value: string);
begin
  FMeasurementStdDeviationText := Value;
end;

procedure TPestObsResult.SetModeled(const Value: double);
begin
  StoredModeled.Value := Value;
end;

procedure TPestObsResult.SetName(const Value: string);
begin
  SetStringProperty(FName, Value);
end;

procedure TPestObsResult.SetNaturalWeight(const Value: double);
begin
  StoredNaturalWeight.Value := Value;
end;

procedure TPestObsResult.SetNaturalWeightText(const Value: string);
begin
  FNaturalWeightText := Value;
end;

procedure TPestObsResult.SetObjectName(const Value: string);
begin
  FObjectName := Value;
end;

procedure TPestObsResult.SetOriginalOrder(const Value: Integer);
begin
  SetIntegerProperty(FOriginalOrder, Value);
end;

procedure TPestObsResult.SetPlotLabel(const Value: Boolean);
begin
  FPlotLabel := Value;
end;

procedure TPestObsResult.SetResidual(const Value: double);
begin
  StoredResidual.Value := Value;
end;

procedure TPestObsResult.SetResidualText(const Value: string);
begin
  FResidualText := Value;
end;

procedure TPestObsResult.SetStoredMeasured(const Value: TRealStorage);
begin
  FStoredMeasured.Assign(Value);
end;

procedure TPestObsResult.SetStoredMeasurementStdDeviation(
  const Value: TRealStorage);
begin
  FStoredMeasurementStdDeviation.Assign(Value);
end;

procedure TPestObsResult.SetStoredModeled(const Value: TRealStorage);
begin
  FStoredModeled.Assign(Value);
end;

procedure TPestObsResult.SetStoredNaturalWeight(const Value: TRealStorage);
begin
  FStoredNaturalWeight.Assign(Value);
end;

procedure TPestObsResult.SetStoredResidual(const Value: TRealStorage);
begin
  FStoredResidual.Assign(Value);
end;

procedure TPestObsResult.SetStoredTime(const Value: TRealStorage);
begin
  FStoredTime.Assign(Value);
end;

procedure TPestObsResult.SetStoredWeight(const Value: TRealStorage);
begin
  FStoredWeight.Assign(Value);
end;

procedure TPestObsResult.SetStoredWeightedMeasured(const Value: TRealStorage);
begin
  FStoredWeightedMeasured.Assign(Value);
end;

procedure TPestObsResult.SetStoredWeightedModeled(const Value: TRealStorage);
begin
  FStoredWeightedModeled.Assign(Value);
end;

procedure TPestObsResult.SetStoredWeightedResidual(const Value: TRealStorage);
begin
  FStoredWeightedResidual.Assign(Value);
end;

procedure TPestObsResult.SetTime(const Value: double);
begin
  StoredTime.Value := Value;
end;

procedure TPestObsResult.SetVisible(const Value: Boolean);
begin
  SetBooleanProperty(FVisible, Value);
end;

procedure TPestObsResult.SetWeight(const Value: double);
begin
  StoredWeight.Value := Value;
end;

procedure TPestObsResult.SetWeightedMeasured(const Value: double);
begin
  StoredWeightedMeasured.Value := Value;
end;

procedure TPestObsResult.SetWeightedMeasuredText(const Value: string);
begin
  FWeightedMeasuredText := Value;
end;

procedure TPestObsResult.SetWeightedModeled(const Value: double);
begin
  StoredWeightedModeled.Value := Value;
end;

procedure TPestObsResult.SetWeightedModeledText(const Value: string);
begin
  FWeightedModeledText := Value;
end;

procedure TPestObsResult.SetWeightedResidual(const Value: double);
begin
  StoredWeightedResidual.Value := Value;
end;

procedure TPestObsResult.SetWeightedResidualText(const Value: string);
begin
  FWeightedResidualText := Value;
end;

procedure TPestObsResult.SetWeightText(const Value: string);
begin
  FWeightText := Value;
end;

{ TPestObsCollection }

function TPestObsCollection.Add: TPestObsResult;
begin
  result := inherited Add as TPestObsResult;
end;

procedure TPestObsCollection.Assign(Source: TPersistent);
var
  SourceCollection: TPestObsCollection;
begin
  if Source is TPestObsCollection then
  begin
    SourceCollection := TPestObsCollection(Source);
    FileName := SourceCollection.FileName;
    FileDate := SourceCollection.FileDate;
    MaxResidualLimit := SourceCollection.MaxResidualLimit;
    MinResidualLimit := SourceCollection.MinResidualLimit;
    MaxWeightedResidualLimit := SourceCollection.MaxWeightedResidualLimit;
    MinWeightedResidualLimit := SourceCollection.MinWeightedResidualLimit;
    MaxTimeLimit := SourceCollection.MaxTimeLimit;
    MinTimeLimit := SourceCollection.MinTimeLimit;
//    MaxLayerLimit := SourceCollection.MaxLayerLimit;
//    MinLayerLimit := SourceCollection.MinLayerLimit;
    NegativeColor := SourceCollection.NegativeColor;
    PositiveColor := SourceCollection.PositiveColor;
    MaxSymbolSize := SourceCollection.MaxSymbolSize;
    Visible := SourceCollection.Visible;
    DrawChoice := SourceCollection.DrawChoice;
  end;
  inherited;
end;

procedure TPestObsCollection.Clear;
begin
  inherited;
  InitializeVariables;
end;

procedure TPestObsCollection.InitializeVariables;
begin
  NegativeColor := clRed;
  PositiveColor := clBlue;
  FMaxSymbolSize := 20;
  FVisible := True;
  FFileName := '';
  FFileDate := 0;
  FMaxResidualLimit.UseLimit := False;
  FMinResidualLimit.UseLimit := False;
  FMaxWeightedResidualLimit.UseLimit := False;
  FMinWeightedResidualLimit.UseLimit := False;
  FMaxTimeLimit.UseLimit := False;
  FMinTimeLimit.UseLimit := False;
  FDrawChoice := dcWeightedResidual;
//  FMaxLayerLimit.UseLimit := False;
//  FMinLayerLimit.UseLimit := False;
end;

constructor TPestObsCollection.Create(Model: TBaseModel);
var
  InvalidateModelEvent: TNotifyEvent;
begin
  FModel := Model;
  if Model = nil then
  begin
    InvalidateModelEvent := nil;
  end
  else
  begin
    InvalidateModelEvent := Model.DoInvalidate;
  end;
  inherited Create(TPestObsResult, InvalidateModelEvent);
  FMaxTimeLimit := TColoringLimit.Create;
  FMaxResidualLimit := TColoringLimit.Create;
  FMinTimeLimit := TColoringLimit.Create;
  FMinResidualLimit := TColoringLimit.Create;
  FMaxWeightedResidualLimit := TColoringLimit.Create;
  FMinWeightedResidualLimit := TColoringLimit.Create;
//  if FModel <> nil then
  begin
    FUsedObservations := TDictionary<string, IObservationItem>.Create;
    FGuidObs := TDictionary<string, IObservationItem>.Create;
  end;

//  FMaxLayerLimit.DataType := rdtInteger;
//  FMinLayerLimit.DataType := rdtInteger;
  InitializeVariables;
end;

destructor TPestObsCollection.Destroy;
begin
  FGuidObs.Free;
  FUsedObservations.Free;
  FMinWeightedResidualLimit.Free;
  FMaxWeightedResidualLimit.Free;

//  FMinLayerLimit.Free;
//  FMaxLayerLimit.Free;
  FMaxTimeLimit.Free;
  FMaxResidualLimit.Free;
  FMinTimeLimit.Free;
  FMinResidualLimit.Free;

  inherited;
end;

procedure TPestObsCollection.CalculateMaxValues;
var
  Obs: TPestObsResult;
  ObsIndex: Integer;
begin
  FMaxObjectResidual := 0;
  FMaxObjectWeightedResidual := 0;
  try
    for ObsIndex := 0 to Count - 1 do
    begin
      Obs := Items[ObsIndex];
      if (Obs.ScreenObject <> nil) and (Obs.ScreenObject.Count = 1) then
      begin
        Obs.Visible := True;
        Obs.FX := Obs.FScreenObject.Points[0].X;
        Obs.Fy := Obs.FScreenObject.Points[0].Y;
        if MaxResidualLimit.UseLimit
          and (Obs.Residual > MaxResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MinResidualLimit.UseLimit
          and (Obs.Residual < MinResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MaxWeightedResidualLimit.UseLimit
          and (Obs.WeightedResidual > MaxWeightedResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MinWeightedResidualLimit.UseLimit
          and (Obs.WeightedResidual < MinWeightedResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MaxTimeLimit.UseLimit
          and (Obs.Time > MaxTimeLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MinTimeLimit.UseLimit
          and (Obs.Time < MinTimeLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end;
        if Obs.Visible then
        begin
//          UsedObs.Add(Obs);
          if Abs(Obs.Residual) > FMaxObjectResidual then
          begin
            FMaxObjectResidual := Abs(Obs.Residual);
          end;
          if Abs(Obs.WeightedResidual) > FMaxObjectWeightedResidual then
          begin
            FMaxObjectWeightedResidual := Abs(Obs.WeightedResidual);
          end;
        end;
      end;
    end;
//    for ObsIndex := 0 to UsedObs.Count - 1 do
//    begin
//      Obs := UsedObs[ObsIndex];
//      Obs.Draw(BitMap, ZoomBox);
//    end;
  finally
//    UsedObs.Free;
  end;
end;

procedure TPestObsCollection.Draw(const BitMap: TPersistent;
  const ZoomBox: TQrbwZoomBox2);
var
  Obs: TPestObsResult;
  UsedObs: TList<TPestObsResult>;
  ObsIndex: Integer;
begin
  FMaxObjectResidual := 0;
  FMaxObjectWeightedResidual := 0;
  UsedObs := TList<TPestObsResult>.Create;
  try
    for ObsIndex := 0 to Count - 1 do
    begin
      Obs := Items[ObsIndex];
      if (Obs.ScreenObject <> nil) and (Obs.ScreenObject.Count = 1) then
      begin
        Obs.Visible := True;
        Obs.FX := Obs.FScreenObject.Points[0].X;
        Obs.Fy := Obs.FScreenObject.Points[0].Y;
        if MaxResidualLimit.UseLimit
          and (Obs.Residual > MaxResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MinResidualLimit.UseLimit
          and (Obs.Residual < MinResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MaxWeightedResidualLimit.UseLimit
          and (Obs.WeightedResidual > MaxWeightedResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MinWeightedResidualLimit.UseLimit
          and (Obs.WeightedResidual < MinWeightedResidualLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MaxTimeLimit.UseLimit
          and (Obs.Time > MaxTimeLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end
        else if MinTimeLimit.UseLimit
          and (Obs.Time < MinTimeLimit.RealLimitValue) then
        begin
          Obs.Visible := False;
        end;
        if Obs.Visible then
        begin
          UsedObs.Add(Obs);
          if Abs(Obs.Residual) > FMaxObjectResidual then
          begin
            FMaxObjectResidual := Abs(Obs.Residual);
          end;
          if Abs(Obs.WeightedResidual) > FMaxObjectWeightedResidual then
          begin
            FMaxObjectWeightedResidual := Abs(Obs.WeightedResidual);
          end;
        end;
      end;
    end;
    for ObsIndex := 0 to UsedObs.Count - 1 do
    begin
      Obs := UsedObs[ObsIndex];
      Obs.Draw(BitMap, ZoomBox);
    end;
  finally
    UsedObs.Free;
  end;
end;

procedure TPestObsCollection.GetExistingObservations;
var
  TempList: TObservationInterfaceList;
  ObsIndex: Integer;
  IObs: IObservationItem;
  AnObs: TCustomObservationItem;
begin
  FUsedObservations.Clear;
  FGuidObs.Clear;
  TempList := TObservationInterfaceList.Create;
  try
    frmGoPhast.PhastModel.FillObsInterfaceItemList(TempList, True);
  {$IF CompilerVersion > 28}
    FUsedObservations.Capacity := TempList.Count;
    FGuidObs.Capacity := TempList.Count;
  {$ENDIF}
    for ObsIndex := 0 to TempList.Count - 1 do
    begin
      IObs := TempList[ObsIndex];
      FGuidObs.Add(IObs.GUID, IObs);
      if IObs is TCustomObservationItem then
      begin
        AnObs := TCustomObservationItem(IObs);
        if AnObs.Print then
        begin
          if IObs.ExportedName <> '' then
          begin
            FUsedObservations.Add(LowerCase(IObs.ExportedName), IObs);
          end
          else
          begin
            FUsedObservations.Add(LowerCase(IObs.Name), IObs);
          end;
        end;
      end
      else
      begin
        if IObs.ExportedName <> '' then
        begin
          FUsedObservations.Add(LowerCase(IObs.ExportedName), IObs);
        end
        else
        begin
          FUsedObservations.Add(LowerCase(IObs.Name), IObs);
        end;
      end;
    end;
  finally
    TempList.Free;
  end;
end;

function TPestObsCollection.GetItems(Index: Integer): TPestObsResult;
begin
  result := inherited Items[Index] as TPestObsResult;
end;

function TPestObsCollection.ReadFromFile(const AFileName: string): boolean;
var
  ShowErrors: Boolean;
  ResidualsFile: TStringList;
  LineIndex: Integer;
  Splitter: TStringList;
  Item: TPestObsResult;
  Obs: IObservationItem;
  TimeObs: ITimeObservationItem;
  AList: TList;
  Index: Integer;
  AValue: Extended;
  ALine: string;
  CompItem: TGlobalObsComparisonItem;
  OtherObs: IObservationItem;
  NameFound: Boolean;
  IsResidFile: Boolean;
  Extension: string;
  Observed: IObservationItem;
  IsObsExtractFile: Boolean;
begin
  GetExistingObservations;
  result := False;
  ShowErrors := False;
  try
    if not TFile.Exists(AFileName) then
    begin
      Beep;
      MessageDlg(Format(StrTheFileFromWhich, [AFileName]), mtError, [mbOK], 0);
      Exit;
    end;
    Extension := ExtractFileExt(AFileName);
    if (Extension[2].IsDigit) then
    begin
      Extension :=ExtractFileExt(ChangeFileExt(AFileName, ''));
    end;
    IsResidFile := SameText('.res', Extension)
      or SameText('.rei', Extension);
    IsObsExtractFile := SameText('.Mf2005Values', Extension);
    ResidualsFile := TStringList.Create;
    Splitter := TStringList.Create;
    try
      Clear;
      FileName := AFileName;
      ResidualsFile.LoadFromFile(FileName);
      NameFound := False;
      for LineIndex := 0 to ResidualsFile.Count - 1 do
      begin
        if (LineIndex = 0) and IsObsExtractFile then
        begin
          Continue;
        end;
        ALine := ResidualsFile[LineIndex];
        ALine := ReplaceStr(ALine, 'Cov. Mat.', 'Covariance_Matrix');
        Splitter.DelimitedText := ResidualsFile[LineIndex];
        if Splitter.Count > 0 then
        begin
          if IsResidFile and not NameFound then
          begin
            if (Splitter[0] = 'Name') then
            begin
              NameFound := True;
            end;
            Continue;
          end;
          if IsResidFile then
          begin
            Assert(Splitter.Count >= 6);
          end
          else if IsObsExtractFile then
          begin
            Assert(Splitter.Count >= 4);
          end
          else
          begin
            // MF 6 or SUTRA
            Assert(Splitter.Count >= 2);
          end;

//          if Splitter.Count > 6 then
//          begin
//            Assert(Splitter.Count >= 9);
//          end;
          Item := Add;
          Item.Name := Splitter[0];
          if IsResidFile then
          begin
            Item.GroupName := Splitter[1];
            Item.Measured := FortranStrToFloat(Splitter[2]);
            Item.Modeled := FortranStrToFloat(Splitter[3]);
            Item.Residual := FortranStrToFloat(Splitter[4]);

            if TryFortranStrToFloat(Splitter[5], AValue) then
            begin
              Item.Weight := AValue;
              Item.WeightText := '';
            end
            else
            begin
              Item.Weight := 0;
              Item.WeightText := Splitter[5];
            end;

            if  (Splitter.Count > 6) then
            begin
              if TryFortranStrToFloat(Splitter[6], AValue) then
              begin
                Item.WeightedMeasured := AValue;
                Item.WeightedMeasuredText := '';
              end
              else
              begin
                Item.WeightedMeasured := 0;
                Item.WeightedMeasuredText := Splitter[6];
              end;
            end
            else
            begin
                Item.WeightedMeasured := 0;
                Item.WeightedMeasuredText := StrNotRecorded;
            end;

            if  (Splitter.Count > 7) then
            begin
              if TryFortranStrToFloat(Splitter[7], AValue) then
              begin
                Item.WeightedModeled := AValue;
                Item.WeightedModeledText := '';
              end
              else
              begin
                Item.WeightedModeled := 0;
                Item.WeightedModeledText := Splitter[7];
              end;
            end
            else
            begin
                Item.WeightedModeled := 0;
                Item.WeightedModeledText := StrNotRecorded;
            end;

            if  (Splitter.Count > 8) then
            begin
              if TryFortranStrToFloat(Splitter[8], AValue) then
              begin
                Item.WeightedResidual := AValue;
                Item.WeightedResidualText := '';
              end
              else
              begin
                Item.WeightedResidual := 0;
                Item.WeightedResidualText := Splitter[8];
              end;
            end
            else
            begin
                Item.WeightedResidual := 0;
                Item.WeightedResidualText := StrNotRecorded;
            end;

            if Splitter.Count > 9 then
            begin
              if TryFortranStrToFloat(Splitter[9], AValue) then
              begin
                Item.MeasurementStdDeviation := AValue;
                Item.MeasurementStdDeviationText := '';
              end
              else
              begin
                Item.MeasurementStdDeviation := 0;
                Item.MeasurementStdDeviationText := Splitter[9];
              end;
            end
            else
            begin
                Item.MeasurementStdDeviation := 0;
                Item.MeasurementStdDeviationText := StrNotRecorded;
            end;

            if Splitter.Count > 10 then
            begin
              if TryFortranStrToFloat(Splitter[10], AValue) then
              begin
                Item.NaturalWeight := AValue;
                Item.NaturalWeightText := '';
              end
              else
              begin
                Item.NaturalWeight := 0;
                Item.NaturalWeightText := Splitter[10];
              end;
            end
            else
            begin
              Item.NaturalWeight := 0;
              Item.NaturalWeightText := StrNotRecorded;
            end;
          end
          else
          begin
            Item.GroupName := StrNotRecorded;
            Item.Modeled := FortranStrToFloat(Splitter[1]);
            Item.Residual := 0;
            Item.ResidualText := StrNotRecorded;
            Item.Weight := 0;
            Item.WeightText := StrNotRecorded;
            Item.WeightedMeasured := 0;
            Item.WeightedMeasuredText := StrNotRecorded;

            Item.WeightedModeled := 0;
            Item.WeightedModeledText := StrNotRecorded;

            Item.WeightedResidual := 0;
            Item.WeightedResidualText := StrNotRecorded;

            if FUsedObservations.TryGetValue(LowerCase(Item.Name), Observed) then
            begin
              Item.Weight := Observed.Weight;
              Item.WeightText := '';

              Item.Measured := Observed.ObservedValue;
              Item.Residual := Item.Measured - Item.Modeled;
              Item.ResidualText := '';
              Item.WeightedMeasured := Item.Weight * Item.Measured;
              Item.WeightedMeasuredText := '';
              Item.WeightedModeled := Item.Weight * Item.Modeled;
              Item.WeightedModeledText := '';
              Item.WeightedResidual := Item.Weight * Item.Residual;
              Item.ResidualText := '';
            end;

            Item.MeasurementStdDeviation := 0;
            Item.MeasurementStdDeviationText := StrNotRecorded;

            Item.NaturalWeight := 0;
            Item.NaturalWeightText := StrNotRecorded;
          end;

          if FUsedObservations.TryGetValue(LowerCase(Item.Name), Obs) then
          begin
            if Obs is TGlobalObsComparisonItem then
            begin
              CompItem := TGlobalObsComparisonItem(Obs);
              if FGuidObs.TryGetValue(CompItem.Guid1, OtherObs) then
              begin
                Item.FScreenObject := OtherObs.ScreenObject as TScreenObject;
              end;
            end
            else
            begin
              Item.FScreenObject := Obs.ScreenObject as TScreenObject;
            end;
            if Item.FScreenObject <> nil then
            begin
              Item.ObjectName := Item.FScreenObject.Name;
            end
            else
            begin
              Item.ObjectName := ''
            end;
            if Supports(Obs, ITimeObservationItem, TimeObs) then
            begin
              Item.Time := TimeObs.Time;
            end
            else
            begin
              Item.Time := 0;
            end;
          end
          else
          begin
            Item.FScreenObject := nil;
            Item.ObjectName := '';
            Item.Time := 0;
          end;
        end;
      end;

      AList := TList.Create;
      try
        for Index := 0 to Count - 1 do
        begin
          AList.Add(Items[Index]);
        end;
        if (Splitter.Count > 6) then
        begin
          AList.Sort(CompareAbsWeightedResiduals);
        end
        else
        begin
          AList.Sort(CompareAbsResiduals);
        end;
        for Index := 0 to AList.Count - 1 do
        begin
          Item := AList[Index];
          Item.Index := Index;
          Item.OriginalOrder := Index;
        end;
      finally
        AList.Free;
      end;

      FileDate := TFile.GetLastWriteTime(FileName);
    finally
      Splitter.Free;
      ResidualsFile.Free;
    end;
  finally
    if ShowErrors then
    begin
      frmErrorsAndWarnings.ShowAfterDelay;
    end;
  end;
  result := True;
end;

function TPestObsCollection.RootMeanSquareResidual: double;
var
  ItemIndex: Integer;
  Item: TPestObsResult;
begin
  result := 0;
  for ItemIndex := 0 to Count - 1 do
  begin
    Item := Items[ItemIndex];
    result := result + Sqr(Item.Residual);
  end;
  Result := Sqrt(result/Count);
end;

function TPestObsCollection.RootMeanSquareWeightedResidual: double;
var
  ItemIndex: Integer;
  Item: TPestObsResult;
begin
  result := 0;
  for ItemIndex := 0 to Count - 1 do
  begin
    Item := Items[ItemIndex];
    result := result + Sqr(Item.WeightedResidual);
  end;
  Result := Sqrt(result/Count);
end;

procedure TPestObsCollection.SetVisible(const Value: boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    InvalidateModel;
  end;
end;

procedure TPestObsCollection.SetDrawChoice(const Value: TDrawChoice);
begin
  if FDrawChoice <> Value then
  begin
    FDrawChoice := Value;
    InvalidateModel;
  end;
end;

//procedure TPestObsCollection.UpdateVisibleItems;
//begin
//
//end;
//
procedure TPestObsCollection.SetFileDate(const Value: TDateTime);
begin
  FFileDate := Value;
end;

procedure TPestObsCollection.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    InvalidateModel;
  end;
end;

procedure TPestObsCollection.SetItems(Index: Integer;
  const Value: TPestObsResult);
begin
  inherited Items[Index] := Value;
end;

//procedure TPestObsCollection.SetMaxLayerLimit(const Value: TColoringLimit);
//begin
//  FMaxLayerLimit.Assign(Value);
//end;

procedure TPestObsCollection.SetMaxResidualLimit(const Value: TColoringLimit);
begin
  FMaxResidualLimit.Assign(Value)
end;

procedure TPestObsCollection.SetMaxSymbolSize(const Value: integer);
begin
  if FMaxSymbolSize <> Value then
  begin
    FMaxSymbolSize := Value;
    InvalidateModel;
  end;
end;

procedure TPestObsCollection.SetMaxTimeLimit(const Value: TColoringLimit);
begin
  FMaxTimeLimit.Assign(Value)
end;

procedure TPestObsCollection.SetMaxWeightedResidualLimit(
  const Value: TColoringLimit);
begin
  FMaxWeightedResidualLimit.Assign(Value)
end;

//procedure TPestObsCollection.SetMinLayerLimit(const Value: TColoringLimit);
//begin
//  FMinLayerLimit.Assign(Value)
//end;

procedure TPestObsCollection.SetMinResidualLimit(const Value: TColoringLimit);
begin
  FMinResidualLimit.Assign(Value)
end;

procedure TPestObsCollection.SetMinTimeLimit(const Value: TColoringLimit);
begin
  FMinTimeLimit.Assign(Value)
end;

procedure TPestObsCollection.SetMinWeightedResidualLimit(
  const Value: TColoringLimit);
begin
  FMinWeightedResidualLimit.Assign(Value)
end;

procedure TPestObsCollection.SetNegativeColor(const Value: TColor);
begin
  if FNegativeColor <> Value then
  begin
    FNegativeColor := Value;
    FNegativeColor32 := Color32(FNegativeColor);
    InvalidateModel;
  end;
end;

procedure TPestObsCollection.SetPositiveColor(const Value: TColor);
begin
  if FPositiveColor <> Value then
  begin
    FPositiveColor := Value;
    FPositiveColor32 := Color32(FPositiveColor);
    InvalidateModel;
  end;
end;

end.
