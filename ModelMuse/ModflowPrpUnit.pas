unit ModflowPrpUnit;

interface

uses ZLib, Classes, SysUtils, RbwParser, GoPhastTypes,
  ModflowBoundaryUnit, SubscriptionUnit,
  FormulaManagerUnit, FormulaManagerInterfaceUnit,
  OrderedCollectionUnit, ModflowCellUnit, RealListUnit,
  Modflow6DynamicTimeSeriesInterfaceUnit, PrtInterfacesUnit;

type
  TPrpBoundary = class(TModflowSteadyBoundary)
  private
    FPrtModelName: string;
    FPrpPackageName: string;
    FZFormula: IFormulaObject;
    FZObserver: TObserver;
    FPrtModel: IPrtModel;
    FPrpPackage: IPrpPackage;
    function GetZ: string;
    function GetZObserver: TObserver;
    procedure SetPrtModelName(const Value: string);
    procedure SetPrpPackageName(const Value: string);
    procedure SetZ(const Value: string);
    function GetPrtModelName: string;
    function GetPrpPackageName: string;
  protected
    procedure HandleChangedValue(Observer: TObserver); override;
    function GetUsedObserver: TObserver; override;
    procedure GetPropertyObserver(Sender: TObject; List: TList); override;
    procedure CreateFormulaObjects; override;
    property ZObserver: TObserver read GetZObserver;
    function BoundaryObserverPrefix: string; override;
    procedure CreateObservers; override;
    procedure CreateObserver(ObserverNameRoot: string; var Observer: TObserver;
      Displayer: TObserver); override;
  public
    Procedure Assign(Source: TPersistent); override;
    Constructor Create(Model: TBaseModel; ScreenObject: TObject);
    destructor Destroy; override;
    procedure InvalidateDisplay;
    procedure Loaded;
    procedure RemoveModelLink(AModel: TBaseModel);
  published
    property PrtModelName: string read GetPrtModelName write SetPrtModelName;
    property PrpPackageName: string read GetPrpPackageName write SetPrpPackageName;
    property ZFormula: string read GetZ write SetZ;
  end;

const
  PrpZPosition = 0;

implementation

uses
  ModflowPackageSelectionUnit, PhastModelUnit, ScreenObjectUnit;

{ TPrpBoundary }

procedure TPrpBoundary.Assign(Source: TPersistent);
var
  SourecPRP: TPrpBoundary;
begin
  if Source is TPrpBoundary then
  begin
    SourecPRP := TPrpBoundary(Source);
    PrtModelName := SourecPRP.PrtModelName;
    PrpPackageName := SourecPRP.PrpPackageName;
    ZFormula := SourecPRP.ZFormula;
  end
  else
  begin
    inherited;
  end;
end;

function TPrpBoundary.BoundaryObserverPrefix: string;
begin
  result := 'PRP_';
end;

constructor TPrpBoundary.Create(Model: TBaseModel; ScreenObject: TObject);
begin
  inherited;
  ZFormula := '1';
  PrtModelName := '';
  PrpPackageName := '';
end;

procedure TPrpBoundary.CreateFormulaObjects;
begin
  inherited;
  FZFormula := CreateFormulaObjectBlocks(dso3D);

end;

procedure TPrpBoundary.CreateObserver(ObserverNameRoot: string;
  var Observer: TObserver; Displayer: TObserver);
var
  LocalScreenObject: TScreenObject;
  Model: TPhastModel;
begin
  inherited;
  LocalScreenObject := ScreenObject as TScreenObject;
  if LocalScreenObject.CanInvalidateModel then
  begin
    Model := ParentModel as TPhastModel;
    Assert(Model <> nil);
//    Model.HfbDisplayer.Invalidate;
  end;

end;

procedure TPrpBoundary.CreateObservers;
begin
  if (ScreenObject <> nil) and (ParentModel <> nil) then
  begin
    FObserverList.Add(ZObserver);
  end;
end;

destructor TPrpBoundary.Destroy;
begin
  ZFormula := '0';

  inherited;
end;

procedure TPrpBoundary.GetPropertyObserver(Sender: TObject; List: TList);
begin
  if (Sender = FZFormula as TObject)
    and (PrpZPosition < List.Count) then
  begin
    List.Add(FObserverList[PrpZPosition]);
  end;
end;

function TPrpBoundary.GetPrtModelName: string;
begin
  if FPrtModel <> nil then
  begin
    result := FPrtModel.ModelName
  end
  else
  begin
    result := FPrtModelName;
  end;
end;

function TPrpBoundary.GetPrpPackageName: string;
begin
  if FPrpPackage <> nil then
  begin
    result := FPrpPackage.PackageName;
  end
  else
  begin
    result := FPrpPackageName;
  end;
end;

function TPrpBoundary.GetUsedObserver: TObserver;
var
  Model: TPhastModel;
  Observer: TObserver;
begin
  if FUsedObserver = nil then
  begin
    if ParentModel <> nil then
    begin
      Model := ParentModel as TPhastModel;
//      Observer := Model.HfbDisplayer;
      Observer := nil;
    end
    else
    begin
      Observer := nil;
    end;
    CreateObserver('Prp_Used_', FUsedObserver, Observer);
  end;
  result := FUsedObserver;
end;

function TPrpBoundary.GetZ: string;
begin
  Result := FZFormula.Formula;
  if ScreenObject <> nil then
  begin
    ResetBoundaryObserver(PrpZPosition);
  end;
end;

function TPrpBoundary.GetZObserver: TObserver;
var
  Model: TPhastModel;
  Observer: TObserver;
begin
  if FZObserver = nil then
  begin
    if ParentModel <> nil then
    begin
      Model := ParentModel as TPhastModel;
//      Observer := Model.HfbDisplayer;
      Observer := nil;
    end
    else
    begin
      Observer := nil;
    end;
    CreateObserver('PRP_Z_', FZObserver, Observer);
//    FObserverList.Add(FZObserver);
  end;
  result := FZObserver;
end;

procedure TPrpBoundary.HandleChangedValue(Observer: TObserver);
var
  Model: TPhastModel;
  ChildIndex: Integer;
  ChildModel: TChildModel;
begin
  Model := ParentModel as TPhastModel;
  if not (csDestroying in Model.ComponentState)
    and not Model.Clearing then
  begin
    Observer.UpToDate := True;
    Observer.UpToDate := False;
//    Model.HfbDisplayer.Invalidate;
    for ChildIndex := 0 to Model.ChildModels.Count - 1 do
    begin
      ChildModel := Model.ChildModels[ChildIndex].ChildModel;
      if ChildModel <> nil then
      begin
//        ChildModel.HfbDisplayer.Invalidate;
      end;
    end;
    Observer.UpToDate := True;
  end;
end;

procedure TPrpBoundary.InvalidateDisplay;
begin
  if Used and (ParentModel <> nil) then
  begin
    HandleChangedValue(ZObserver);
  end;
end;

procedure TPrpBoundary.Loaded;
begin
  PrtModelName := PrtModelName;
  PrpPackageName := PrpPackageName;

end;

procedure TPrpBoundary.RemoveModelLink(AModel: TBaseModel);
begin
  FPrtModel := nil;
  FPrpPackage := nil;
end;

procedure TPrpBoundary.SetPrtModelName(const Value: string);
var
  Model: TPhastModel;
  PrtModels: TPrtModels;
begin
  FPrtModel := nil;
  if ParentModel <> nil then
  begin
    Model := ParentModel as TPhastModel;
    PrtModels := Model.ModflowPackages.PrtModels;
    for var ModelIndex := 0 to PrtModels.Count - 1 do
    begin
      if AnsiSameText(PrtModels[ModelIndex].PrtModel.ModelName, Value) then
      begin
        FPrtModel := PrtModels[ModelIndex].PrtModel;
        FPrtModelName := FPrtModel.ModelName;
        PrpPackageName := PrpPackageName
      end;
    end;
  end
  else
  begin
    FPrtModelName := Value;
  end;
end;

procedure TPrpBoundary.SetPrpPackageName(const Value: string);
var
  Model: TPhastModel;
  PrtModels: TPrtModels;
  APrtModel: TPrtModel;
begin
  FPrpPackage := nil;
  if (ParentModel <> nil) and (FPrtModel <> nil) then
  begin
    Model := ParentModel as TPhastModel;
    PrtModels := Model.ModflowPackages.PrtModels;
    for var ModelIndex := 0 to PrtModels.Count - 1 do
    begin
      APrtModel := PrtModels[ModelIndex].PrtModel;
      if APrtModel = APrtModel then
      begin
        for var PackageIndex := 0 to APrtModel.Count - 1 do
        begin
          if AnsiSameText(APrtModel[PackageIndex].PrpPackage.PackageName, Value) then
          begin
            FPrpPackage := APrtModel[PackageIndex].PrpPackage;
            FPrpPackageName := FPrpPackage.PackageName
          end;
        end;
      end;
    end;
  end
  else
  begin
    FPrpPackageName := Value;
  end;
end;

procedure TPrpBoundary.SetZ(const Value: string);
begin
  UpdateFormulaBlocks(Value, PrpZPosition, FZFormula);

end;

end.
