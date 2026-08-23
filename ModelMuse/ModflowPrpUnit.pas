unit ModflowPrpUnit;

interface

uses ZLib, Classes, SysUtils, RbwParser, GoPhastTypes,
  ModflowBoundaryUnit, SubscriptionUnit,
  FormulaManagerUnit, FormulaManagerInterfaceUnit,
  OrderedCollectionUnit, ModflowCellUnit, RealListUnit,
  Modflow6DynamicTimeSeriesInterfaceUnit, PrtInterfacesUnit,
  ModpathParticleUnit, ModflowPrpInterfaceUnit;

type
  TPrpBoundary = class(TModflowSteadyBoundary, IPrpBoundaryInterface)
  private
    FPrtModelName: string;
    FPrpPackageName: string;
    FPrtModel: IPrtModel;
    FPrpPackage: IPrpPackage;
    FParticleStorage: TParticleStorage;
    procedure SetPrtModelName(const Value: string);
    procedure SetPrpPackageName(const Value: string);
    function GetPrtModelName: string;
    function GetPrpPackageName: string;
    procedure SetParticleStorage(const Value: TParticleStorage);
    procedure RemovePrtModelLink;
    Procedure RemovePrpPackageLink;
  protected
    procedure HandleChangedValue(Observer: TObserver); override;
    function GetUsedObserver: TObserver; override;
    procedure GetPropertyObserver(Sender: TObject; List: TList); override;
    procedure CreateFormulaObjects; override;
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
    function Used: boolean; override;
  published
    property PrtModelName: string read GetPrtModelName write SetPrtModelName;
    property PrpPackageName: string read GetPrpPackageName write SetPrpPackageName;
    property ParticleStorage: TParticleStorage read FParticleStorage write SetParticleStorage;
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
    IsUsed := SourecPRP.IsUsed;
    PrtModelName := SourecPRP.PrtModelName;
    PrpPackageName := SourecPRP.PrpPackageName;
    ParticleStorage := SourecPRP.ParticleStorage;
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
  PrtModelName := '';
  PrpPackageName := '';
  FParticleStorage := TParticleStorage.Create(Model);
end;

procedure TPrpBoundary.CreateFormulaObjects;
begin
  inherited;

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
end;

destructor TPrpBoundary.Destroy;
begin
  RemovePrtModelLink;
  FParticleStorage.Free;
  inherited;
end;

procedure TPrpBoundary.GetPropertyObserver(Sender: TObject; List: TList);
begin
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
//    HandleChangedValue(ZObserver);
  end;
end;

procedure TPrpBoundary.Loaded;
begin
  PrtModelName := PrtModelName;
  PrpPackageName := PrpPackageName;

end;

procedure TPrpBoundary.RemoveModelLink(AModel: TBaseModel);
begin
  PrtModelName := '';
  PrpPackageName := '';
end;

procedure TPrpBoundary.RemovePrtModelLink;
begin
  if FPrtModel <> nil then
  begin
    FPrtModel.RemoveFreeNotification(self);
    FPrtModel := nil;
  end;
  if FPrpPackage <> nil then
  begin
    FPrpPackage.RemoveFreeNotification(self);
    FPrpPackage := nil;
  end;
end;

procedure TPrpBoundary.RemovePrpPackageLink;
begin
  FPrpPackage := nil;
end;

procedure TPrpBoundary.SetPrtModelName(const Value: string);
var
  Model: TPhastModel;
  PrtModels: TPrtModels;
begin
  if FPrtModel <> nil then
  begin
    FPrtModel.RemoveFreeNotification(self);
  end;
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
        FPrtModel.FreeNotification(self);
        FPrtModelName := FPrtModel.ModelName;
        PrpPackageName := PrpPackageName;
        break;
      end;
    end;
  end
  else
  begin
    FPrtModelName := Value;
  end;
end;

function TPrpBoundary.Used: boolean;
begin
  result := inherited Used
    and (PrtModelName <> '')
    and (PrpPackageName <> '')
end;

procedure TPrpBoundary.SetParticleStorage(const Value: TParticleStorage);
begin
  FParticleStorage.Assign(Value);
end;

procedure TPrpBoundary.SetPrpPackageName(const Value: string);
var
  Model: TPhastModel;
  PrtModels: TPrtModels;
  APrtModel: TPrtModel;
begin
  if FPrpPackage <> nil then
  begin
    FPrpPackage.RemoveFreeNotification(self);
  end;
  FPrpPackage := nil;
  if (ParentModel <> nil) and (FPrtModel <> nil) then
  begin
    Model := ParentModel as TPhastModel;
    PrtModels := Model.ModflowPackages.PrtModels;
//    for var ModelIndex := 0 to PrtModels.Count - 1 do
    begin
      if PrtModelName = '' then
      begin
        Exit;
      end;
      APrtModel := PrtModels.GetModelByName(PrtModelName);
      if APrtModel = nil then
      begin
        Exit;
      end;
//      if APrtModel = APrtModel then
      begin
        for var PackageIndex := 0 to APrtModel.Count - 1 do
        begin
          if AnsiSameText(APrtModel[PackageIndex].PrpPackage.PackageName, Value) then
          begin
            FPrpPackage := APrtModel[PackageIndex].PrpPackage;
            FPrpPackage.FreeNotification(self);
            FPrpPackageName := FPrpPackage.PackageName;
            break;
          end;
        end;
//        break;
      end;
    end;
  end
  else
  begin
    FPrpPackageName := Value;
  end;
end;

end.
