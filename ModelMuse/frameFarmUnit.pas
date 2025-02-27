unit frameFarmUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, frameScreenObjectUnit, StdCtrls,
  Mask, JvExMask, JvSpin, ExtCtrls, ComCtrls, frameGridUnit,
  frameFormulaGridUnit, JvgPage, frameDeliveryGridUnit, frameFarmDiversionUnit,
  ModflowFmpFarmUnit, RbwDataGrid4, ModflowFmpCropUnit,
  RbwParser, ModflowFmpIrrigationUnit,
  frameMultSemiRoutedUnit, PhastModelInterfaceUnit;

type
  TframeFarm = class(TframeScreenObject)
    tabCrops: TTabSheet;
    tabDiversionLocation: TTabSheet;
    tabReturnFlowLocation: TTabSheet;
    tabNonRoutedDelivery: TTabSheet;
    pnlCaption: TPanel;
    seFarmId: TJvSpinEdit;
    lblFarmId: TLabel;
    tabWaterRights: TTabSheet;
    frameFormulaGridCrops: TframeFormulaGrid;
    frameFormulaGridDiversion: TframeFarmDiversion;
    frameFormulaGridReturnFlow: TframeFarmDiversion;
    frameFormulaGridWaterRights: TframeFormulaGrid;
    tabCosts: TTabSheet;
    pcMain: TJvgPageControl;
    frameFormulaGridCosts: TframeFormulaGrid;
    frameDelivery: TframeDeliveryGrid;
    pnlTop: TPanel;
    tabGW_Allocation: TTabSheet;
    frameGW_Allocation: TframeFormulaGrid;
    rbwprsrFarmParser: TRbwParser;
    edFarmName: TLabeledEdit;
    tabEfficiencyImprovement: TTabSheet;
    frameFormulaGridEfficiencyImprovement: TframeFormulaGrid;
    tabAddedDemandRunoffSplit: TTabSheet;
    frameAddedDemandRunoffSplit: TframeFormulaGrid;
    tabIrrigationUniformity: TTabSheet;
    frameIrrigationUniformity: TframeFormulaGrid;
    tabDeficiencyScenario: TTabSheet;
    frameDeficiencyScenario: TframeFormulaGrid;
    tabWaterSource: TTabSheet;
    frameWaterSource: TframeFormulaGrid;
    tabBareRunoffFractions: TTabSheet;
    frameBareRunoffFractions: TframeFormulaGrid;
    tabAddedCropDemandFlux: TTabSheet;
    tabAddedCropDemandRate: TTabSheet;
    frameAddedCropDemandFlux: TframeFormulaGrid;
    frameAddedCropDemandRate: TframeFormulaGrid;
    tabNoReturnFlow: TTabSheet;
    frameNoReturnFlow: TframeFormulaGrid;
    tabDiversionsOwhm2: TTabSheet;
    frameDiversionsOwhm2: TframeMultSemiRouted;
    tabReturnFlowOwhm2: TTabSheet;
    frameReturnFlowsOwhm2: TframeMultSemiRouted;
    tabSwAllotment: TTabSheet;
    frameSwAllotment: TframeFormulaGrid;
    tabWaterSupplyConcentration: TTabSheet;
    frameWaterSupplyConcentration: TframeFormulaGrid;
    tabName: TTabSheet;
    PanelOwhm2: TPanel;
    comboPumpSpread: TComboBox;
    lblPumpSpread: TLabel;
    procedure frameFormulaGridCropsedFormulaChange(Sender: TObject);
    procedure frameFormulaGridCropsGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameFormulaGridCropsseNumberChange(Sender: TObject);
    procedure frameFormulaGridCropssbAddClick(Sender: TObject);
    procedure frameFormulaGridCropssbInsertClick(Sender: TObject);
    procedure frameFormulaGridCropssbDeleteClick(Sender: TObject);
    procedure frameFormulaGridCostsedFormulaChange(Sender: TObject);
    procedure frameFormulaGridCostsseNumberChange(Sender: TObject);
    procedure frameFormulaGridCostsGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameFormulaGridCostssbAddClick(Sender: TObject);
    procedure frameFormulaGridCostssbInsertClick(Sender: TObject);
    procedure frameFormulaGridCostssbDeleteClick(Sender: TObject);
    procedure frameFormulaGridWaterRightsedFormulaChange(Sender: TObject);
    procedure frameFormulaGridWaterRightsGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameFormulaGridWaterRightsseNumberChange(Sender: TObject);
    procedure frameFormulaGridWaterRightssbAddClick(Sender: TObject);
    procedure frameFormulaGridWaterRightssbInsertClick(Sender: TObject);
    procedure frameFormulaGridWaterRightssbDeleteClick(Sender: TObject);
    procedure seFarmIdChange(Sender: TObject);
    procedure frameDeliveryGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure frameFormulaGridDiversionGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameFormulaGridReturnFlowGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameGW_AllocationGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameGW_AllocationseNumberChange(Sender: TObject);
    procedure frameGW_AllocationedFormulaChange(Sender: TObject);
    procedure frameGW_AllocationsbAddClick(Sender: TObject);
    procedure frameGW_AllocationsbInsertClick(Sender: TObject);
    procedure frameGW_AllocationsbDeleteClick(Sender: TObject);
    procedure frameFormulaGridCropsGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameFormulaGridCostsGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameDeliveryGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameFormulaGridWaterRightsGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameGW_AllocationGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameFormulaGridEfficiencyImprovementedFormulaChange(
      Sender: TObject);
    procedure frameFormulaGridEfficiencyImprovementGridSetEditText(
      Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure frameFormulaGridEfficiencyImprovementsbAddClick(Sender: TObject);
    procedure frameFormulaGridEfficiencyImprovementsbDeleteClick(
      Sender: TObject);
    procedure frameFormulaGridEfficiencyImprovementsbInsertClick(
      Sender: TObject);
    procedure frameFormulaGridEfficiencyImprovementseNumberChange(
      Sender: TObject);
    procedure frameFormulaGridEfficiencyImprovementGridButtonClick(
      Sender: TObject; ACol, ARow: Integer);
    procedure frameAddedDemandRunoffSplitedFormulaChange(Sender: TObject);
    procedure frameAddedDemandRunoffSplitsbAddClick(Sender: TObject);
    procedure frameAddedDemandRunoffSplitsbInsertClick(Sender: TObject);
    procedure frameAddedDemandRunoffSplitsbDeleteClick(Sender: TObject);
    procedure frameAddedDemandRunoffSplitseNumberChange(Sender: TObject);
    procedure frameAddedDemandRunoffSplitGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameAddedDemandRunoffSplitGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameIrrigationUniformitysbAddClick(Sender: TObject);
    procedure frameIrrigationUniformitysbDeleteClick(Sender: TObject);
    procedure frameIrrigationUniformitysbInsertClick(Sender: TObject);
    procedure frameIrrigationUniformityseNumberChange(Sender: TObject);
    procedure frameIrrigationUniformityedFormulaChange(Sender: TObject);
    procedure frameIrrigationUniformityGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameIrrigationUniformityGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameDeficiencyScenarioGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameDeficiencyScenarioGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameDeficiencyScenarioseNumberChange(Sender: TObject);
    procedure frameDeficiencyScenariosbAddClick(Sender: TObject);
    procedure frameDeficiencyScenariosbInsertClick(Sender: TObject);
    procedure frameDeficiencyScenariosbDeleteClick(Sender: TObject);
    procedure frameDeficiencyScenarioedFormulaChange(Sender: TObject);
    procedure frameWaterSourceGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameWaterSourceGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameWaterSourceseNumberChange(Sender: TObject);
    procedure frameWaterSourceedFormulaChange(Sender: TObject);
    procedure frameWaterSourcesbAddClick(Sender: TObject);
    procedure frameWaterSourcesbInsertClick(Sender: TObject);
    procedure frameWaterSourcesbDeleteClick(Sender: TObject);
    procedure frameBareRunoffFractionsGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameBareRunoffFractionsGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameBareRunoffFractionsedFormulaChange(Sender: TObject);
    procedure frameBareRunoffFractionsseNumberChange(Sender: TObject);
    procedure frameBareRunoffFractionssbAddClick(Sender: TObject);
    procedure frameBareRunoffFractionssbInsertClick(Sender: TObject);
    procedure frameBareRunoffFractionssbDeleteClick(Sender: TObject);
    procedure frameAddedCropDemandFluxGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameAddedCropDemandFluxGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameAddedCropDemandFluxseNumberChange(Sender: TObject);
    procedure frameAddedCropDemandFluxedFormulaChange(Sender: TObject);
    procedure frameAddedCropDemandFluxsbAddClick(Sender: TObject);
    procedure frameAddedCropDemandFluxsbInsertClick(Sender: TObject);
    procedure frameAddedCropDemandFluxsbDeleteClick(Sender: TObject);
    procedure frameAddedCropDemandRateGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameAddedCropDemandRateGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameAddedCropDemandRateedFormulaChange(Sender: TObject);
    procedure frameAddedCropDemandRateseNumberChange(Sender: TObject);
    procedure frameAddedCropDemandRatesbAddClick(Sender: TObject);
    procedure frameAddedCropDemandRatesbInsertClick(Sender: TObject);
    procedure frameAddedCropDemandRatesbDeleteClick(Sender: TObject);
    procedure frameFarmDiversionsGridButtonClick(Sender: TObject; ACol, ARow:
        Integer);
    procedure frameFormulaGridCropsGridSelectCell(Sender: TObject; ACol, ARow:
        Integer; var CanSelect: Boolean);
    procedure frameNoReturnFlowcomboChoiceChange(Sender: TObject);
    procedure frameNoReturnFlowGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameNoReturnFlowseNumberChange(Sender: TObject);
    procedure frameNoReturnFlowsbAddClick(Sender: TObject);
    procedure frameNoReturnFlowsbInsertClick(Sender: TObject);
    procedure frameNoReturnFlowsbDeleteClick(Sender: TObject);
    procedure frameFormulaGridDiversionGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameFormulaGridEfficiencyImprovementGridSelectCell(Sender: TObject;
        ACol, ARow: Integer; var CanSelect: Boolean);
    procedure frameFormulaGridReturnFlowGridButtonClick(Sender: TObject; ACol,
        ARow: Integer);
    procedure frameSwAllotmentedFormulaChange(Sender: TObject);
    procedure frameSwAllotmentseNumberChange(Sender: TObject);
    procedure frameSwAllotmentsbAddClick(Sender: TObject);
    procedure frameSwAllotmentsbInsertClick(Sender: TObject);
    procedure frameSwAllotmentsbDeleteClick(Sender: TObject);
    procedure frameSwAllotmentGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure frameSwAllotmentGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure frameWaterSupplyConcentrationedFormulaChange(Sender: TObject);
    procedure frameWaterSupplyConcentrationGridButtonClick(Sender: TObject; ACol,
        ARow: Integer);
    procedure frameWaterSupplyConcentrationGridSetEditText(Sender: TObject; ACol,
        ARow: Integer; const Value: string);
    procedure frameWaterSupplyConcentrationsbAddClick(Sender: TObject);
    procedure frameWaterSupplyConcentrationsbDeleteClick(Sender: TObject);
    procedure frameWaterSupplyConcentrationsbInsertClick(Sender: TObject);
    procedure frameWaterSupplyConcentrationseNumberChange(Sender: TObject);
  private
    FChangedCrops: boolean;
    FChangedCosts: boolean;
    FChangedWaterRights: boolean;
    FOnChange: TNotifyEvent;
    FChangedID: Boolean;
    FChanging: Boolean;
    FChangedSwAllotment: Boolean;
    FChangedGwAllotment: Boolean;
    FEfficiencyImprovementChanged: Boolean;
    FAddedDemandRunoffSplitChanged: Boolean;
    FIrrigationUniformityChanged: Boolean;
    FDeficiencyScenarioChanged: Boolean;
    FWaterSourceChanged: Boolean;
    FBareRunoffFractionsChanged: Boolean;
    FAddedCropDemandFluxChanged: Boolean;
    FAddedCropDemandRateChanged: Boolean;
    FNoReturnFlowChanged: Boolean;
    FChangedWaterSupplyConcentrations: Boolean;
    procedure GetCropEffForFirstFarm(FirstFarm: TFarm);
    procedure GetCropEffImproveForFirstFarm(FirstFarm: TFarm);
    procedure GetAddedDemandRunoffSplitForFirstFarm(FirstFarm: TFarm);
    procedure GetIrrigationUniformityForFirstFarm(FirstFarm: TFarm);
    procedure GetDeficiencyScenarioForFirstFarm(FirstFarm: TFarm);
    procedure GetWaterSourceForFirstFarm(FirstFarm: TFarm);
    procedure GetBareRunoffFractonForFirstFarm(FirstFarm: TFarm);
    procedure GetAddedCropDemandFluxForFirstFarm(FirstFarm: TFarm);
    procedure GetAddedCropDemandRateForFirstFarm(FirstFarm: TFarm);
    procedure GetNoReturnFlowFirstFarm(FirstFarm: TFarm);

    procedure GetCostsForFirstFarm(FirstFarm: TFarm);
    procedure GetWaterRightsForFirstFarm(FirstFarm: TFarm);
    procedure GetGwAllotmentForFirstFarm(FirstFarm: TFarm);
    procedure GetSwAllotmentForFirstFarm(FirstFarm: TFarm);
    procedure GetWaterSupplyConcentrationForFirstFarm(FirstFarm: TFarm);
    procedure GetMaxTimeAndCountForCrops(var MaxIndex, MaxTimeCount: Integer;
      AFarm: TFarm);
    procedure SetCropEfficiencies(Farm: TFarm; Crops: TCropCollection;
      IrrigationTypes: TIrrigationCollection);
    procedure SetCropEfficiencyImprove(Farm: TFarm;
      IrrigationTypes: TIrrigationCollection);
    procedure SetAddedDemandRunoffSplit(Farm: TFarm;
      IrrigationTypes: TIrrigationCollection);
    procedure SetIrrigationUniformity(Farm: TFarm;
      IrrigationTypes: TIrrigationCollection);
    procedure SetDeficiencyScenario(Farm: TFarm);
    procedure SetWaterSource(Farm: TFarm);
    procedure SetBareRunoffFractions(Farm: TFarm);
    procedure SetAddedCropDemandFlux(Farm: TFarm);
    procedure SetAddedCropDemandRate(Farm: TFarm);
    procedure SetNoReturnFlow(Farm: TFarm);

    procedure SetFarmCosts(Farm: TFarm);
    procedure SetWaterRights(Farm: TFarm);
    procedure SetGwAllotment(Farm: TFarm);
    procedure SetSwAllotment(Farm: TFarm);
    procedure SetSaltSupplyConcentration(Farm: TFarm);

    procedure Change(Sender: TObject);
    property Changing: Boolean read FChanging write FChanging;
    procedure DoChange;

    procedure EditFormula(Grid: TRbwDataGrid4; ACol, ARow: Integer);
    procedure SetAnEfficiencyCollection(
      EfficiencyCollection: TFarmEfficiencyCollection;
      AFrame: TframeFormulaGrid; IrrigationTypes: TIrrigationCollection);
    procedure InitializeEfficiencyCollectionFrame(
      StartTimes, EndTimes: TStringList; IrrigationTypes: TIrrigationCollection;
      AFrame: TframeFormulaGrid; CaptionFormatString: string);
    procedure InitializeSingleValueFrame(StartTimes, EndTimes: TStringList;
      AFrame: TframeFormulaGrid; ValueCaption: string);

    procedure InitializeDeficiencyScenarioFrame(StartTimes, EndTimes: TStringList);
    procedure InitializeWaterSourceFrame(StartTimes, EndTimes: TStringList;
      AFrame: TframeFormulaGrid; ValueCaptions: array of string);
    procedure InitializeBareRunoffFractionsFrame(StartTimes, EndTimes: TStringList);
    procedure InitializeEfficiencyCollectionByCropFrame(
      StartTimes, EndTimes: TStringList; Crops: TCropCollection;
      AFrame: TframeFormulaGrid; CaptionFormatString: string);
    procedure InitializeAddedCropDemandFluxFrame(StartTimes, EndTimes: TStringList);
    procedure InitializeAddedCropDemandRateFrame(StartTimes, EndTimes: TStringList);
//    procedure InitializeSaltSupplyConcentrationFrame(StartTimes, EndTimes: TStringList);

    procedure GetAnEfficiencyCollection(AFarm: TFarm; AFrame: TframeFormulaGrid;
      EfficiencyCollection: TFarmEfficiencyCollection);
    procedure UpdateEndTime(Sender: TObject; ACol: Integer; ARow: Integer);
    procedure GetMaxTimeAndCountForEfficiencyCollection(
      AFrame: TframeFormulaGrid; EffCollection: TFarmEfficiencyCollection;
      var MaxTimeCount: Integer; var MaxIndex: Integer);
    procedure GetEfficiencyDataForFirstFarm(AFrame: TframeFormulaGrid;
      EffCollection: TFarmEfficiencyCollection);
    procedure SetAddedCropDemand(EfficiencyCollection: TFarmEfficiencyCollection;
      AFrame: TframeFormulaGrid);
    procedure GetPumpSpreadForFirstFarm(FirstFarm: TFarm);

    { Private declarations }
  public
    procedure InitializeControls;
    procedure GetData(FarmList: TFarmList);
    procedure SetData(FarmList: TFarmList);
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    { Public declarations }
  end;

var
  frameFarm: TframeFarm;

implementation

uses
  GoPhastTypes, frmGoPhastUnit,
  ModflowTimeUnit, Generics.Collections,
  PhastModelUnit, ModflowPackagesUnit, ModflowPackageSelectionUnit,
  ModflowFmpAllotmentUnit, frmFormulaUnit, frmConvertChoiceUnit,
  ModflowFmpBaseClasses, ModflowParameterInterfaceUnit;

resourcestring
  StrGWBaseMaintenance = 'GW base maintenance costs / volume (GWCost1)';
  StrGWPumpingCostsV = 'GW pumping costs / (volume * lift) (GWCost2)';
  StrGWVerticalLiftCos = 'GW vertical lift costs / (volume * lift) (GWCost3)';
  StrGWDeliveryCosts = 'GW delivery costs / (volume * distance) (GWCost4)';
  StrFixedPriceOfSemi = 'Fixed price of (semi-) routed SW / volume (SWCost1)';
  StrVerticalLiftCosts = 'Vertical lift costs of (semi-) routed SW / (volume ' +
  '* lift) (SWCost2)';
  StrDeliveryCostsOfS = 'Delivery costs of (semi-) routed SW / (volume * dist' +
  'ance) (SWCost3)';
  StrFixedPriceOfNonr = 'Fixed price of non-routed SW / volume (SWCost4)';
  StrWaterRightsCallC = 'Water Rights Call (CALL)';
  StrCropEfficiency = '%s on-farm efficiency (OFE)';

type
  TCropColumns = (ccStartTime, ccEndTime, ccCrop);
  TWaterCostColumns = (wccStartTime, wccEndTime, wccGWCost1, wccGWCost2,
    wccGWCost3, wccGWCost4, wccSWCost1, wccSWCost2, wccSWCost3, wccSWCost4);
  TWaterRightsCallColumns = (wrccStartTime, wrccEndTime, wrccCall);
  TGwAllocationColumns = (gacStartTime, gacEndTime, gacAllotment);
  TDeficiencyColumns = (dcStartTime, dcEndTime, dcValue);
  TWaterSourceColumns = (wscStartTime, wscEndTime, wscGroundwater,
    wscSurfaceWater, wscNonRouted);
  TBareRunoffFractionsColumns = (brfcStartTime, brfcEndTime, brfcValue);
  TNoReturnFlowColumns = (nrfcStartTime, nrfcEndTime, nrfcValue);
  TSourceConcentrationColumns = (sccStartTime, sccEndTime, sccNonRouted,
    sccSurfaceWater, sccGroundWater, sccExternal);

{$R *.dfm}

{ TframeFarm }

resourcestring
  StrErrorInFormulaS = 'Error in formula: %s';


procedure TframeFarm.DoChange;
begin
  if Changing then
  begin
    Exit;
  end;
  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

procedure TframeFarm.EditFormula(Grid: TRbwDataGrid4; ACol, ARow: Integer);
var
  AFormula: string;
  CompiledFormula: TExpression;
  ParentControl: TWinControl;
  ValidTypes: TRbwDataTypes;
  RequiredType: TRbwDataType;
  Parameter: IModflowParameter;
begin

  ValidTypes := [rdtDouble, rdtInteger];
  RequiredType := rdtDouble;
  if (Grid = frameFormulaGridEfficiencyImprovement.Grid)
    or (Grid = frameWaterSource.Grid) then
  begin
    ValidTypes := [rdtBoolean];
    RequiredType := rdtBoolean;
  end
  else if Grid = frameDeficiencyScenario.Grid then
  begin
    ValidTypes := [rdtBoolean];
    RequiredType := rdtBoolean;
  end
  else if Grid = frameDelivery.Grid then
  begin
    if ((ACol -2) mod 4) = 1 then
    begin
      ValidTypes := [rdtInteger];
      RequiredType := rdtInteger;
    end;
  end;

  AFormula := Grid.Cells[ACol, ARow];
  if AFormula = '' then
  begin
    AFormula := '0';
  end;

  begin
    try
      frmFormula.Initialize;
      // GIS functions are not included and
      // Data sets are not included
      // because the variables will be evaluated for screen objects and
      // not at specific locations.

      ParentControl := Parent;
      while ParentControl <> nil do
      begin
        if ParentControl is TCustomForm then
        begin
          break;
        end;
        ParentControl := ParentControl.Parent;
      end;

      if (ParentControl <> nil) and (ParentControl is TCustomForm) then
      begin
        frmFormula.PopupParent := TCustomForm(ParentControl);
      end;

      // Show the functions and global variables.
      frmFormula.IncludeTimeSeries := False;
      frmFormula.UpdateTreeList;

      // put the formula in the TfrmFormula.
      frmFormula.Formula := AFormula;
      // The user edits the formula.
      frmFormula.ShowModal;
      if frmFormula.ResultSet then
      begin
        try
          AFormula := frmFormula.Formula;
          rbwprsrFarmParser.Compile(AFormula);

        except on E: ERbwParserError do
          begin
            Beep;
            raise ERbwParserError.Create(Format(StrErrorInFormulaS,
              [E.Message]));
            Exit;
          end
        end;
        CompiledFormula := rbwprsrFarmParser.CurrentExpression;

        Parameter := nil;
        if rdtDouble in ValidTypes then
        begin
          Parameter := IGlobalModelForOrderedCollection.GetPestParameterByNameI(AFormula);
        end;

        if (CompiledFormula.ResultType in ValidTypes) or (Parameter <> nil) then
        begin
          Grid.Cells[ACol, ARow] := CompiledFormula.DecompileDisplay;
        end
        else
        begin
          AFormula := AdjustFormula(AFormula, CompiledFormula.ResultType, RequiredType);
          rbwprsrFarmParser.Compile(AFormula);
          CompiledFormula := rbwprsrFarmParser.CurrentExpression;
          Grid.Cells[ACol, ARow] := CompiledFormula.DecompileDisplay;
        end;
        if Assigned(Grid.OnSetEditText) then
        begin
          Grid.OnSetEditText(Grid, ACol, ARow, Grid.Cells[ACol, ARow]);
        end;
      end;
    finally
      frmFormula.Initialize;
//      frmFormula.Free;
    end;
  end
end;

procedure TframeFarm.Change(Sender: TObject);
begin
  DoChange;
end;

procedure TframeFarm.GetData(FarmList: TFarmList);
var
  ItemIndex: Integer;
  AFarm: TFarm;
  FirstFarm: TFarm;
  FarmProcess: TFarmProcess;
  Packages: TModflowPackages;
  FarmProcess4: TFarmProcess4;
  SalinityFlush: TFarmProcess4SalinityFlush;
  FarmSurfaceWater4: TFarmProcess4SurfaceWater;
  MnwPumpSpread: TOwhmV2PumpSpreadChoice;
  PumpSpreadUsed: Boolean;
  ModflowPackages: TModflowPackages;
begin
  Changing := True;
  FrameLoaded := False;
  try
    ModflowPackages  := frmGoPhast.PhastModel.ModflowPackages;
    MnwPumpSpread := ModflowPackages.FarmWells4.MnwPumpSpread;
    PumpSpreadUsed := (MnwPumpSpread = pscByWbs)
      and ModflowPackages.Mnw2Package.IsSelected;
    comboPumpSpread.Enabled := PumpSpreadUsed;

    if FarmList.count = 0 then
    begin
      seFarmId.AsInteger := 0;
      frameFormulaGridCrops.ClearGrid;
      ClearGrid(frameFormulaGridCosts.Grid);
      ClearGrid(frameFormulaGridWaterRights.Grid);
      frameGW_Allocation.ClearGrid;
      frameSwAllotment.ClearGrid;
      ClearGrid(frameFormulaGridEfficiencyImprovement.Grid);
      frameAddedDemandRunoffSplit.ClearGrid;
      ClearGrid(frameIrrigationUniformity.Grid);
      ClearGrid(frameDeficiencyScenario.Grid);
      ClearGrid(frameWaterSource.Grid);
      frameBareRunoffFractions.ClearGrid;
      frameAddedCropDemandFlux.ClearGrid;
      ClearGrid(frameAddedCropDemandRate.Grid);
      frameWaterSupplyConcentration.ClearGrid;
      Enabled := False;
      Exit;
    end;
    Enabled := True;
    Packages := frmGoPhast.PhastModel.ModflowPackages;
    FarmProcess := Packages.FarmProcess;
    FarmProcess4 := Packages.FarmProcess4;
    SalinityFlush := Packages.FarmSalinityFlush;
    FarmSurfaceWater4 := Packages.FarmSurfaceWater4;

    tabCrops.TabVisible := (frmGoPhast.ModelSelection = msModflowFmp)
      or  ((frmGoPhast.ModelSelection = msModflowOwhm2)
      and (FarmProcess4.EfficiencyOptions.FarmOption <> foNotUsed)
      and (FarmProcess4.EfficiencyOptions.ArrayList = alList));
    tabCrops.HelpKeyword := 'Irrigation-Efficiencies';

    tabCosts.TabVisible := (frmGoPhast.ModelSelection = msModflowFmp)
      and (FarmProcess.DeficiencyPolicy in
      [dpAcreageOptimization, dpAcreageOptimizationWithConservationPool])
      and (FarmProcess.DeficiencyPolicy in
      [dpAcreageOptimization, dpAcreageOptimizationWithConservationPool]);

    tabNoReturnFlow.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
      and FarmSurfaceWater4.IsSelected
      and (FarmSurfaceWater4.NoReturnFlow.FarmOption <> foNotUsed);

    tabWaterRights.TabVisible := (frmGoPhast.ModelSelection = msModflowFmp)
      and (FarmProcess.SurfaceWaterAllotment = swaPriorWithCalls);

    tabWaterSupplyConcentration.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
      and SalinityFlush.IsSelected
      and (SalinityFlush.FarmSaltConcentrationsChoice.FarmOption <> foNotUsed);

    try
      frameFormulaGridCrops.Grid.BeginUpdate;
      frameFormulaGridCosts.Grid.BeginUpdate;
      frameFormulaGridWaterRights.Grid.BeginUpdate;
      frameGW_Allocation.Grid.BeginUpdate;
      frameSwAllotment.Grid.BeginUpdate;
      frameFormulaGridEfficiencyImprovement.Grid.BeginUpdate;
      frameAddedDemandRunoffSplit.Grid.BeginUpdate;
      frameIrrigationUniformity.Grid.BeginUpdate;
      frameDeficiencyScenario.Grid.BeginUpdate;
      frameWaterSource.Grid.BeginUpdate;
      frameBareRunoffFractions.Grid.BeginUpdate;
      frameAddedCropDemandFlux.Grid.BeginUpdate;
      frameAddedCropDemandRate.Grid.BeginUpdate;
      frameNoReturnFlow.Grid.BeginUpdate;
      frameWaterSupplyConcentration.Grid.BeginUpdate;
      try
        frameFormulaGridCrops.ClearGrid;
        ClearGrid(frameFormulaGridCosts.Grid);
        ClearGrid(frameFormulaGridWaterRights.Grid);
        frameGW_Allocation.ClearGrid;
        frameSwAllotment.ClearGrid;
        ClearGrid(frameFormulaGridEfficiencyImprovement.Grid);
        frameAddedDemandRunoffSplit.ClearGrid;
        ClearGrid(frameIrrigationUniformity.Grid);
        ClearGrid(frameDeficiencyScenario.Grid);
        ClearGrid(frameWaterSource.Grid);
        frameBareRunoffFractions.ClearGrid;
        frameAddedCropDemandFlux.ClearGrid;
        ClearGrid(frameAddedCropDemandRate.Grid);
        ClearGrid(frameNoReturnFlow.Grid);
        frameWaterSupplyConcentration.ClearGrid;

        FirstFarm := FarmList[0];
        GetCropEffForFirstFarm(FirstFarm);
        GetCropEffImproveForFirstFarm(FirstFarm);
        GetAddedDemandRunoffSplitForFirstFarm(FirstFarm);
        GetIrrigationUniformityForFirstFarm(FirstFarm);
        GetDeficiencyScenarioForFirstFarm(FirstFarm);
        GetWaterSourceForFirstFarm(FirstFarm);
        GetBareRunoffFractonForFirstFarm(FirstFarm);
        GetAddedCropDemandFluxForFirstFarm(FirstFarm);
        GetAddedCropDemandRateForFirstFarm(FirstFarm);
        GetNoReturnFlowFirstFarm(FirstFarm);

        GetCostsForFirstFarm(FirstFarm);
        GetWaterRightsForFirstFarm(FirstFarm);
        GetGwAllotmentForFirstFarm(FirstFarm);
        GetSwAllotmentForFirstFarm(FirstFarm);
        GetWaterSupplyConcentrationForFirstFarm(FirstFarm);
        GetPumpSpreadForFirstFarm(FirstFarm);

        if FarmList.Count = 1 then
        begin
          seFarmId.AsInteger := FirstFarm.FarmId;
          seFarmId.Enabled := True;
          edFarmName.Text := FirstFarm.FarmName;
          edFarmName.Enabled := True;
        end
        else
        begin
          seFarmId.AsInteger := 0;
          seFarmId.Enabled := False;
          edFarmName.Text := '';
          edFarmName.Enabled := False;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if AFarm.PumpSpreadChoice <> FirstFarm.PumpSpreadChoice then
          begin
            comboPumpSpread.ItemIndex := -1;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.CurrentFarmEfficiencyCollection.IsSame(
            FirstFarm.CurrentFarmEfficiencyCollection) then
          begin
            frameFormulaGridCrops.ClearGrid;
            frameFormulaGridCrops.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.FarmIrrigationEfficiencyImprovementCollection.IsSame(
            FirstFarm.FarmIrrigationEfficiencyImprovementCollection) then
          begin
            ClearGrid(frameFormulaGridEfficiencyImprovement.Grid);
            frameFormulaGridEfficiencyImprovement.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.FarmCostsCollection.IsSame(
            FirstFarm.FarmCostsCollection) then
          begin
            ClearGrid(frameFormulaGridCosts.Grid);
            frameFormulaGridCosts.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.WaterRights.IsSame(
            FirstFarm.WaterRights) then
          begin
            ClearGrid(frameFormulaGridWaterRights.Grid);
            frameFormulaGridWaterRights.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.GwAllotment.IsSame(
            FirstFarm.GwAllotment) then
          begin
            frameGW_Allocation.ClearGrid;
            frameGW_Allocation.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.SWAllotment.IsSame(
            FirstFarm.SWAllotment) then
          begin
            frameSwAllotment.ClearGrid;
            frameSwAllotment.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.AddedDemandRunoffSplitCollection.IsSame(
            FirstFarm.AddedDemandRunoffSplitCollection) then
          begin
            frameAddedDemandRunoffSplit.ClearGrid;
            frameAddedDemandRunoffSplit.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.IrrigationUniformity.IsSame(
            FirstFarm.IrrigationUniformity) then
          begin
            ClearGrid(frameIrrigationUniformity.Grid);
            frameIrrigationUniformity.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.DeficiencyScenario.IsSame(
            FirstFarm.DeficiencyScenario) then
          begin
            ClearGrid(frameDeficiencyScenario.Grid);
            frameDeficiencyScenario.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.WaterSource.IsSame(
            FirstFarm.WaterSource) then
          begin
            ClearGrid(frameWaterSource.Grid);
            frameWaterSource.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.BareRunoffFraction.IsSame(
            FirstFarm.BareRunoffFraction) then
          begin
            frameBareRunoffFractions.ClearGrid;
            frameBareRunoffFractions.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.AddedCropDemandFlux.IsSame(
            FirstFarm.AddedCropDemandFlux) then
          begin
            frameAddedCropDemandFlux.ClearGrid;
            frameAddedCropDemandFlux.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.AddedCropDemandRate.IsSame(
            FirstFarm.AddedCropDemandRate) then
          begin
            ClearGrid(frameAddedCropDemandRate.Grid);
            frameAddedCropDemandRate.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.NoReturnFlow.IsSame(
            FirstFarm.NoReturnFlow) then
          begin
            ClearGrid(frameNoReturnFlow.Grid);
            frameNoReturnFlow.seNumber.AsInteger := 0;
            break;
          end;
        end;

        for ItemIndex := 1 to FarmList.Count - 1 do
        begin
          AFarm := FarmList[ItemIndex];
          if not AFarm.SaltSupplyConcentrationCollection.IsSame(
            FirstFarm.SaltSupplyConcentrationCollection) then
          begin
            frameWaterSupplyConcentration.ClearGrid;
            frameWaterSupplyConcentration.seNumber.AsInteger := 0;
            break;
          end;
        end;

      finally
        frameFormulaGridCrops.Grid.EndUpdate;
        frameFormulaGridEfficiencyImprovement.Grid.EndUpdate;
        frameFormulaGridCosts.Grid.EndUpdate;
        frameFormulaGridWaterRights.Grid.EndUpdate;
        frameGW_Allocation.Grid.EndUpdate;
        frameSwAllotment.Grid.EndUpdate;
        frameAddedDemandRunoffSplit.Grid.EndUpdate;
        frameIrrigationUniformity.Grid.EndUpdate;
        frameDeficiencyScenario.Grid.EndUpdate;
        frameWaterSource.Grid.EndUpdate;
        frameBareRunoffFractions.Grid.EndUpdate;
        frameAddedCropDemandFlux.Grid.EndUpdate;
        frameAddedCropDemandRate.Grid.EndUpdate;
        frameNoReturnFlow.Grid.EndUpdate;
        frameWaterSupplyConcentration.Grid.EndUpdate;
      end;

      frameFormulaGridDiversion.GetData(FarmList, dtDiversion);
      frameFormulaGridReturnFlow.GetData(FarmList, dtReturnFlow);

      frameDelivery.GetData_OwhmV1(FarmList);
      tabNonRoutedDelivery.tabVisible := ((frmGoPhast.ModelSelection = msModflowFmp)
        and FarmProcess.IsSelected)
        or ((frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected and FarmSurfaceWater4.IsSelected
        and (FarmSurfaceWater4.Non_Routed_Delivery.FarmOption <> foNotUsed));

      frameDiversionsOwhm2.GetData(FarmList, dtDiversion);
      frameReturnFlowsOwhm2.GetData(FarmList, dtReturnFlow);

      tabEfficiencyImprovement.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and (FarmProcess4.EfficiencyImprovement.FarmOption <> foNotUsed)
        and (FarmProcess4.EfficiencyImprovement.ArrayList = alList);

      tabAddedDemandRunoffSplit.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and (FarmProcess4.Added_Demand_Runoff_Split.FarmOption <> foNotUsed)
        and (FarmProcess4.Added_Demand_Runoff_Split.ArrayList = alList);

      tabIrrigationUniformity.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and SalinityFlush.IsSelected
        and (SalinityFlush.FarmIrrigationUniformityChoice.FarmOption <> foNotUsed);

      tabDeficiencyScenario.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and (FarmProcess4.DeficiencyScenario.FarmOption <> foNotUsed);

      tabWaterSource.TabVisible :=  (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and (FarmProcess4.WaterSource.FarmOption <> foNotUsed);

      tabBareRunoffFractions.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and (FarmProcess4.Bare_Runoff_Fraction.FarmOption <> foNotUsed)
        and (FarmProcess4.Bare_Runoff_Fraction.ArrayList = alList);

      tabAddedCropDemandFlux.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and FarmProcess4.IsSelected
        and (FarmProcess4.Added_Crop_Demand_Flux.FarmOption <> foNotUsed);

      tabAddedCropDemandRate.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
        and  FarmProcess4.IsSelected
        and (FarmProcess4.Added_Crop_Demand_Rate.FarmOption <> foNotUsed);
    finally
      FChangedCrops := False;
      FChangedCosts := False;
      FChangedWaterRights := False;
      FChangedID := False;
      FChangedGwAllotment := false;
      FChangedSwAllotment := False;
      FEfficiencyImprovementChanged := False;
      FAddedDemandRunoffSplitChanged := False;
      FIrrigationUniformityChanged := False;
      FDeficiencyScenarioChanged := False;
      FWaterSourceChanged := False;
      FBareRunoffFractionsChanged := False;
      FAddedCropDemandFluxChanged := False;
      FAddedCropDemandRateChanged := False;
      FNoReturnFlowChanged := False;
      FChangedWaterSupplyConcentrations := False;
    end;
  finally
    Changing := False;
    FrameLoaded := True;
  end;
end;

procedure TframeFarm.GetDeficiencyScenarioForFirstFarm(FirstFarm: TFarm);
var
  AFarm: TFarm;
  Frame: TframeFormulaGrid;
  Grid: TRbwDataGrid4;
  DeficiencyScenario: TDeficiencyScenarioCollection;
  ATimeItem: TOwhmItem;
  TimeIndex: Integer;
begin
  AFarm := FirstFarm;
  Frame := frameDeficiencyScenario;
  Grid := Frame.Grid;
  DeficiencyScenario := AFarm.DeficiencyScenario;

  Frame.seNumber.AsInteger := DeficiencyScenario.Count;
  Frame.seNumber.OnChange(Frame.seNumber);
  for TimeIndex := 0 to DeficiencyScenario.Count - 1 do
  begin
    ATimeItem := DeficiencyScenario[TimeIndex];
    Grid.Cells[Ord(wrccStartTime), TimeIndex+1] := FloatToStr(ATimeItem.StartTime);
    Grid.Cells[Ord(wrccEndTime), TimeIndex+1] := FloatToStr(ATimeItem.EndTime);
    Grid.Cells[Ord(wrccCall), TimeIndex+1] := ATimeItem.OwhmValue;
  end;
end;

procedure TframeFarm.GetGwAllotmentForFirstFarm(FirstFarm: TFarm);
var
  AFarm: TFarm;
  Grid: TRbwDataGrid4;
  TimeIndex: Integer;
  ATimeItem: TAllotmentItem;
begin
  AFarm := FirstFarm;
  frameGW_Allocation.seNumber.AsInteger := AFarm.GwAllotment.Count;
  frameGW_Allocation.seNumber.OnChange(frameGW_Allocation.seNumber);
  frameGW_Allocation.InitializePestParameters;

  Grid := frameGW_Allocation.Grid;
  Grid.BeginUpdate;
  try
    for TimeIndex := 0 to AFarm.GwAllotment.Count - 1 do
    begin
      ATimeItem := AFarm.GwAllotment[TimeIndex];
      Grid.Cells[Ord(wrccStartTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.StartTime);
      Grid.Cells[Ord(wrccEndTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.EndTime);
      Grid.Cells[Ord(wrccCall), TimeIndex+1+PestRowOffset] := ATimeItem.Allotment;
    end;

    frameGW_Allocation.PestUsedOnCol[Ord(wrccStartTime)] := False;
    frameGW_Allocation.PestUsedOnCol[Ord(wrccEndTime)] := False;
    frameGW_Allocation.PestUsedOnCol[Ord(wrccCall)] := True;
    frameGW_Allocation.PestModifier[Ord(wrccCall)] := AFarm.GwAllotment.PestSeriesParameter;
    frameGW_Allocation.PestMethod[Ord(wrccCall)] := AFarm.GwAllotment.PestParamMethod;
  finally
    Grid.EndUpdate;
  end;

end;

procedure TframeFarm.GetIrrigationUniformityForFirstFarm(FirstFarm: TFarm);
begin
  GetAnEfficiencyCollection(FirstFarm, frameIrrigationUniformity,
    FirstFarm.IrrigationUniformity);
end;

procedure TframeFarm.frameAddedDemandRunoffSplitGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameAddedDemandRunoffSplitGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameAddedDemandRunoffSplit.Grid, ACol, ARow);
  DoChange;
  FAddedDemandRunoffSplitChanged := True;
end;

procedure TframeFarm.frameAddedDemandRunoffSplitsbAddClick(Sender: TObject);
begin
  inherited;
  frameAddedDemandRunoffSplit.sbAddClick(Sender);
  FAddedDemandRunoffSplitChanged := True;
  DoChange
end;

procedure TframeFarm.frameAddedDemandRunoffSplitsbDeleteClick(Sender: TObject);
begin
  inherited;
  frameAddedDemandRunoffSplit.sbDeleteClick(Sender);
  FAddedDemandRunoffSplitChanged := True;
  DoChange
end;

procedure TframeFarm.frameAddedDemandRunoffSplitsbInsertClick(Sender: TObject);
begin
  inherited;
  frameAddedDemandRunoffSplit.sbInsertClick(Sender);
  FAddedDemandRunoffSplitChanged := True;
  DoChange
end;

procedure TframeFarm.frameAddedDemandRunoffSplitseNumberChange(Sender: TObject);
begin
  inherited;
  frameAddedDemandRunoffSplit.seNumberChange(Sender);
  FAddedDemandRunoffSplitChanged := True;
  DoChange
end;

procedure TframeFarm.frameBareRunoffFractionsedFormulaChange(Sender: TObject);
begin
  inherited;
  frameBareRunoffFractions.edFormulaChange(Sender);
  DoChange;
  FBareRunoffFractionsChanged := True;
end;

procedure TframeFarm.frameBareRunoffFractionsGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameBareRunoffFractionsGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  DoChange;
  UpdateEndTime(Sender, ACol, ARow);
  FBareRunoffFractionsChanged := True;
end;

procedure TframeFarm.frameBareRunoffFractionssbAddClick(Sender: TObject);
begin
  inherited;
  frameBareRunoffFractions.sbAddClick(Sender);
  DoChange;
  FBareRunoffFractionsChanged := True;
end;

procedure TframeFarm.frameBareRunoffFractionssbDeleteClick(Sender: TObject);
begin
  inherited;
  frameBareRunoffFractions.sbDeleteClick(Sender);
  DoChange;
  FBareRunoffFractionsChanged := True;
end;

procedure TframeFarm.frameBareRunoffFractionssbInsertClick(Sender: TObject);
begin
  inherited;
  frameBareRunoffFractions.sbInsertClick(Sender);
  DoChange;
  FBareRunoffFractionsChanged := True;
end;

procedure TframeFarm.frameBareRunoffFractionsseNumberChange(Sender: TObject);
begin
  inherited;
  frameBareRunoffFractions.seNumberChange(Sender);
  DoChange;
  FBareRunoffFractionsChanged := True;
end;

procedure TframeFarm.frameDeficiencyScenarioedFormulaChange(Sender: TObject);
begin
  inherited;
  frameDeficiencyScenario.edFormulaChange(Sender);
  DoChange;
  FDeficiencyScenarioChanged := True;
end;

procedure TframeFarm.frameDeficiencyScenarioGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameDeficiencyScenarioGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameDeficiencyScenario.Grid, ACol, ARow);
  DoChange;
  FDeficiencyScenarioChanged := True;
end;

procedure TframeFarm.frameDeficiencyScenariosbAddClick(Sender: TObject);
begin
  inherited;
  frameDeficiencyScenario.sbAddClick(Sender);
  DoChange;
  FDeficiencyScenarioChanged := True;
end;

procedure TframeFarm.frameDeficiencyScenariosbDeleteClick(Sender: TObject);
begin
  inherited;
  frameDeficiencyScenario.sbDeleteClick(Sender);
  DoChange;
  FDeficiencyScenarioChanged := True;
end;

procedure TframeFarm.frameDeficiencyScenariosbInsertClick(Sender: TObject);
begin
  inherited;
  frameDeficiencyScenario.sbInsertClick(Sender);
  DoChange;
  FDeficiencyScenarioChanged := True;
end;

procedure TframeFarm.frameDeficiencyScenarioseNumberChange(Sender: TObject);
begin
  inherited;
  frameDeficiencyScenario.seNumberChange(Sender);
  DoChange;
  FDeficiencyScenarioChanged := True;
end;

procedure TframeFarm.frameDeliveryGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameDeliveryGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  frameDelivery.GridSetEditText(Sender, ACol, ARow, Value);
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameDelivery.Grid, ACol, ARow);

end;

procedure TframeFarm.frameAddedCropDemandFluxedFormulaChange(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandFlux.edFormulaChange(Sender);
  DoChange;
  FAddedCropDemandFluxChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandFluxGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameAddedCropDemandFluxGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  DoChange;
  UpdateEndTime(Sender, ACol, ARow);
  FAddedCropDemandFluxChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandFluxsbAddClick(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandFlux.sbAddClick(Sender);
  DoChange;
  FAddedCropDemandFluxChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandFluxsbDeleteClick(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandFlux.sbDeleteClick(Sender);
  DoChange;
  FAddedCropDemandFluxChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandFluxsbInsertClick(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandFlux.sbInsertClick(Sender);
  DoChange;
  FAddedCropDemandFluxChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandFluxseNumberChange(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandFlux.seNumberChange(Sender);
  DoChange;
  FAddedCropDemandFluxChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandRateedFormulaChange(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandRate.edFormulaChange(Sender);
  DoChange;
  FAddedCropDemandRateChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandRateGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameAddedCropDemandRateGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  DoChange;
  UpdateEndTime(Sender, ACol, ARow);
  FAddedCropDemandRateChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandRatesbAddClick(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandRate.sbAddClick(Sender);
  DoChange;
  FAddedCropDemandRateChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandRatesbDeleteClick(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandRate.sbDeleteClick(Sender);
  DoChange;
  FAddedCropDemandRateChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandRatesbInsertClick(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandRate.sbInsertClick(Sender);
  DoChange;
  FAddedCropDemandRateChanged := True;
end;

procedure TframeFarm.frameAddedCropDemandRateseNumberChange(Sender: TObject);
begin
  inherited;
  frameAddedCropDemandRate.seNumberChange(Sender);
  DoChange;
  FAddedCropDemandRateChanged := True;
end;

procedure TframeFarm.frameAddedDemandRunoffSplitedFormulaChange(Sender: TObject);
begin
  inherited;
  frameAddedDemandRunoffSplit.edFormulaChange(Sender);
  FAddedDemandRunoffSplitChanged := True;
end;

procedure TframeFarm.frameFarmDiversionsGridButtonClick(Sender: TObject; ACol,
    ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridCostsedFormulaChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCosts.edFormulaChange(Sender);
  FChangedCosts := True;
end;

procedure TframeFarm.frameFormulaGridCostsGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridCostsGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  FChangedCosts := True;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameFormulaGridCosts.Grid, ACol, ARow);
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCostssbAddClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCosts.sbAddClick(Sender);
  FChangedCosts := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCostssbDeleteClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCosts.sbDeleteClick(Sender);
  FChangedCosts := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCostssbInsertClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCosts.sbInsertClick(Sender);
  FChangedCosts := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCostsseNumberChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCosts.seNumberChange(Sender);
  FChangedCosts := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCropsedFormulaChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCrops.edFormulaChange(Sender);
  FChangedCrops := True;
end;

procedure TframeFarm.frameFormulaGridCropsGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridCropsGridSelectCell(Sender: TObject; ACol,
    ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  frameFormulaGridCrops.GridSelectCell(Sender, ACol, ARow, CanSelect);
end;

procedure TframeFarm.frameFormulaGridCropsGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  FChangedCrops := True;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameFormulaGridCrops.Grid, ACol, ARow);
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCropssbAddClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCrops.sbAddClick(Sender);
  FChangedCrops := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCropssbDeleteClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCrops.sbDeleteClick(Sender);
  FChangedCrops := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCropssbInsertClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCrops.sbInsertClick(Sender);
  FChangedCrops := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridCropsseNumberChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridCrops.seNumberChange(Sender);
  FChangedCrops := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridDiversionGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridDiversionGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  frameFormulaGridDiversion.GridSetEditText(Sender, ACol, ARow, Value);
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameFormulaGridDiversion.Grid, ACol, ARow);

end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementedFormulaChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridEfficiencyImprovement.edFormulaChange(Sender);
  FEfficiencyImprovementChanged := True;
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementGridButtonClick(
  Sender: TObject; ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementGridSelectCell(
    Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  frameFormulaGridEfficiencyImprovement.GridSelectCell(Sender, ACol, ARow,
    CanSelect);
  if ARow <= PestRowOffset then
  begin
    CanSelect := False;
  end;
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  FEfficiencyImprovementChanged := True;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameFormulaGridEfficiencyImprovement.Grid, ACol, ARow);
  DoChange;
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementsbAddClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridEfficiencyImprovement.sbAddClick(Sender);
  FEfficiencyImprovementChanged := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementsbDeleteClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridEfficiencyImprovement.sbDeleteClick(Sender);
  FEfficiencyImprovementChanged := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementsbInsertClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridEfficiencyImprovement.sbInsertClick(Sender);
  FEfficiencyImprovementChanged := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridEfficiencyImprovementseNumberChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridEfficiencyImprovement.seNumberChange(Sender);
  FEfficiencyImprovementChanged := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridReturnFlowGridButtonClick(Sender: TObject;
    ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridReturnFlowGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  frameFormulaGridReturnFlow.GridSetEditText(Sender, ACol, ARow, Value);
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameFormulaGridReturnFlow.Grid, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridWaterRightsedFormulaChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridWaterRights.edFormulaChange(Sender);
  FChangedWaterRights := True;
end;

procedure TframeFarm.frameFormulaGridWaterRightsGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameFormulaGridWaterRightsGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  FChangedWaterRights := True;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameFormulaGridWaterRights.Grid, ACol, ARow);
  DoChange;
end;

procedure TframeFarm.frameFormulaGridWaterRightssbAddClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridWaterRights.sbAddClick(Sender);
  FChangedWaterRights := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridWaterRightssbDeleteClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridWaterRights.sbDeleteClick(Sender);
  FChangedWaterRights := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridWaterRightssbInsertClick(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridWaterRights.sbInsertClick(Sender);
  FChangedWaterRights := True;
  DoChange;
end;

procedure TframeFarm.frameFormulaGridWaterRightsseNumberChange(
  Sender: TObject);
begin
  inherited;
  frameFormulaGridWaterRights.seNumberChange(Sender);
  FChangedWaterRights := True;
  DoChange;
end;

procedure TframeFarm.frameGW_AllocationedFormulaChange(Sender: TObject);
begin
  inherited;
  frameGW_Allocation.edFormulaChange(Sender);
  FChangedGwAllotment := True;
end;

procedure TframeFarm.frameGW_AllocationGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameGW_AllocationGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  FChangedGwAllotment := True;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameGW_Allocation.Grid, ACol, ARow);
  DoChange;
end;

procedure TframeFarm.frameGW_AllocationsbAddClick(Sender: TObject);
begin
  inherited;
  frameGW_Allocation.sbAddClick(Sender);
  FChangedGwAllotment := True;
  DoChange;
end;

procedure TframeFarm.frameGW_AllocationsbDeleteClick(Sender: TObject);
begin
  inherited;
  frameGW_Allocation.sbDeleteClick(Sender);
  FChangedGwAllotment := True;
  DoChange;
end;

procedure TframeFarm.frameGW_AllocationsbInsertClick(Sender: TObject);
begin
  inherited;
  frameGW_Allocation.sbInsertClick(Sender);
  FChangedGwAllotment := True;
  DoChange;
end;

procedure TframeFarm.frameGW_AllocationseNumberChange(Sender: TObject);
begin
  inherited;
  frameGW_Allocation.seNumberChange(Sender);
  FChangedGwAllotment := True;
  DoChange;
end;

procedure TframeFarm.frameIrrigationUniformityedFormulaChange(Sender: TObject);
begin
  inherited;
  frameIrrigationUniformity.edFormulaChange(Sender);
  FIrrigationUniformityChanged := True;
  DoChange
end;

procedure TframeFarm.frameIrrigationUniformityGridButtonClick(Sender: TObject;
  ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameIrrigationUniformityGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
begin
  inherited;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameIrrigationUniformity.Grid, ACol, ARow);
  DoChange;
  FIrrigationUniformityChanged := True;
end;

procedure TframeFarm.frameIrrigationUniformitysbAddClick(Sender: TObject);
begin
  inherited;
  frameIrrigationUniformity.sbAddClick(Sender);
  FIrrigationUniformityChanged := True;
  DoChange
end;

procedure TframeFarm.frameIrrigationUniformitysbDeleteClick(Sender: TObject);
begin
  inherited;
  frameIrrigationUniformity.sbDeleteClick(Sender);
  FIrrigationUniformityChanged := True;
  DoChange
end;

procedure TframeFarm.frameIrrigationUniformitysbInsertClick(Sender: TObject);
begin
  inherited;
  FIrrigationUniformityChanged := True;
  DoChange;
  frameIrrigationUniformity.sbInsertClick(Sender);

end;

procedure TframeFarm.frameIrrigationUniformityseNumberChange(Sender: TObject);
begin
  inherited;
  frameIrrigationUniformity.seNumberChange(Sender);
  FIrrigationUniformityChanged := True;
  DoChange
end;

procedure TframeFarm.frameNoReturnFlowcomboChoiceChange(Sender: TObject);
begin
  inherited;
  frameNoReturnFlow.comboChoiceChange(Sender);
  FNoReturnFlowChanged := True;
  DoChange;
end;

procedure TframeFarm.frameNoReturnFlowGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  FNoReturnFlowChanged := True;
  DoChange;
end;

procedure TframeFarm.frameNoReturnFlowsbAddClick(Sender: TObject);
begin
  inherited;
  frameNoReturnFlow.sbAddClick(Sender);
  FNoReturnFlowChanged := True;
  DoChange;
end;

procedure TframeFarm.frameNoReturnFlowsbDeleteClick(Sender: TObject);
begin
  inherited;
  frameNoReturnFlow.sbDeleteClick(Sender);
  FNoReturnFlowChanged := True;
  DoChange;
end;

procedure TframeFarm.frameNoReturnFlowsbInsertClick(Sender: TObject);
begin
  inherited;
  frameNoReturnFlow.sbInsertClick(Sender);
  FNoReturnFlowChanged := True;
  DoChange;
end;

procedure TframeFarm.frameNoReturnFlowseNumberChange(Sender: TObject);
begin
  inherited;
  frameNoReturnFlow.seNumberChange(Sender);
  FNoReturnFlowChanged := True;
  DoChange;
end;

procedure TframeFarm.frameSwAllotmentedFormulaChange(Sender: TObject);
begin
  inherited;
  frameSwAllotment.edFormulaChange(Sender);
  FChangedSwAllotment := True;
end;

procedure TframeFarm.frameSwAllotmentGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameSwAllotmentGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  FChangedSwAllotment := True;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameGW_Allocation.Grid, ACol, ARow);
  DoChange;

end;

procedure TframeFarm.frameSwAllotmentsbAddClick(Sender: TObject);
begin
  inherited;
  frameSwAllotment.sbAddClick(Sender);
  FChangedSwAllotment := True;

end;

procedure TframeFarm.frameSwAllotmentsbDeleteClick(Sender: TObject);
begin
  inherited;
  frameSwAllotment.sbDeleteClick(Sender);
  FChangedSwAllotment := True;
end;

procedure TframeFarm.frameSwAllotmentsbInsertClick(Sender: TObject);
begin
  inherited;
  frameSwAllotment.sbInsertClick(Sender);
  FChangedSwAllotment := True;
end;

procedure TframeFarm.frameSwAllotmentseNumberChange(Sender: TObject);
begin
  inherited;
  frameSwAllotment.seNumberChange(Sender);
  FChangedSwAllotment := True;

end;

procedure TframeFarm.frameWaterSourceedFormulaChange(Sender: TObject);
begin
  inherited;
  frameWaterSource.edFormulaChange(Sender);
  DoChange;
  FWaterSourceChanged := True;
end;

procedure TframeFarm.frameWaterSourceGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameWaterSourceGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  UpdateEndTime(Sender, ACol, ARow);
//  UpdateNextTimeCell(frameWaterSource.Grid, ACol, ARow);
  DoChange;
  FWaterSourceChanged := True;

end;

procedure TframeFarm.frameWaterSourcesbAddClick(Sender: TObject);
begin
  inherited;
  frameWaterSource.sbAddClick(Sender);
  DoChange;
  FWaterSourceChanged := True;
end;

procedure TframeFarm.frameWaterSourcesbDeleteClick(Sender: TObject);
begin
  inherited;
  frameWaterSource.sbDeleteClick(Sender);
  DoChange;
  FWaterSourceChanged := True;
end;

procedure TframeFarm.frameWaterSourcesbInsertClick(Sender: TObject);
begin
  inherited;
  frameWaterSource.sbInsertClick(Sender);
  DoChange;
  FWaterSourceChanged := True;
end;

procedure TframeFarm.frameWaterSourceseNumberChange(Sender: TObject);
begin
  inherited;
  frameWaterSource.seNumberChange(Sender);
  DoChange;
  FWaterSourceChanged := True;
end;

procedure TframeFarm.frameWaterSupplyConcentrationedFormulaChange(Sender:
    TObject);
begin
  inherited;
  frameWaterSupplyConcentration.edFormulaChange(Sender);
  FChangedWaterSupplyConcentrations := True;
end;

procedure TframeFarm.frameWaterSupplyConcentrationGridButtonClick(Sender:
    TObject; ACol, ARow: Integer);
begin
  inherited;
  EditFormula(Sender as TRbwDataGrid4, ACol, ARow);
end;

procedure TframeFarm.frameWaterSupplyConcentrationGridSetEditText(Sender:
    TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  FChangedWaterSupplyConcentrations := True;
  UpdateEndTime(Sender, ACol, ARow);
  DoChange;
end;

procedure TframeFarm.frameWaterSupplyConcentrationsbAddClick(Sender: TObject);
begin
  inherited;
  frameWaterSupplyConcentration.sbAddClick(Sender);
  FChangedWaterSupplyConcentrations := True;
end;

procedure TframeFarm.frameWaterSupplyConcentrationsbDeleteClick(Sender:
    TObject);
begin
  inherited;
  frameWaterSupplyConcentration.sbDeleteClick(Sender);
  FChangedWaterSupplyConcentrations := True;
end;

procedure TframeFarm.frameWaterSupplyConcentrationsbInsertClick(Sender:
    TObject);
begin
  inherited;
  frameWaterSupplyConcentration.sbInsertClick(Sender);
  FChangedWaterSupplyConcentrations := True;
end;

procedure TframeFarm.frameWaterSupplyConcentrationseNumberChange(Sender:
    TObject);
begin
  inherited;
  frameWaterSupplyConcentration.seNumberChange(Sender);
  FChangedWaterSupplyConcentrations := True;
end;

procedure TframeFarm.GetAddedCropDemandFluxForFirstFarm(FirstFarm: TFarm);
begin
  GetEfficiencyDataForFirstFarm(frameAddedCropDemandFlux, FirstFarm.AddedCropDemandFlux);
end;

procedure TframeFarm.GetAddedCropDemandRateForFirstFarm(FirstFarm: TFarm);
begin
  GetEfficiencyDataForFirstFarm(frameAddedCropDemandRate, FirstFarm.AddedCropDemandRate);
end;

procedure TframeFarm.GetAddedDemandRunoffSplitForFirstFarm(FirstFarm: TFarm);
begin
  GetAnEfficiencyCollection(FirstFarm, frameAddedDemandRunoffSplit,
    FirstFarm.AddedDemandRunoffSplitCollection);
end;

procedure TframeFarm.GetCostsForFirstFarm(
  FirstFarm: TFarm);
var
  AFarm: TFarm;
  TimeIndex: Integer;
  Grid: TRbwDataGrid4;
  TimeItem: TFarmCostsItem;
begin
  AFarm := FirstFarm;
  frameFormulaGridCosts.seNumber.AsInteger := AFarm.FarmCostsCollection.Count;
  frameFormulaGridCosts.seNumber.OnChange(frameFormulaGridCosts.seNumber);
  Grid := frameFormulaGridCosts.Grid;
  for TimeIndex := 0 to AFarm.FarmCostsCollection.Count - 1 do
  begin
    TimeItem := AFarm.FarmCostsCollection[TimeIndex];
    Grid.Cells[Ord(wccStartTime), TimeIndex+1] := FloatToStr(TimeItem.StartTime);
    Grid.Cells[Ord(wccEndTime), TimeIndex+1] := FloatToStr(TimeItem.EndTime);
    Grid.Cells[Ord(wccGWCost1), TimeIndex+1] := TimeItem.GWCost1;
    Grid.Cells[Ord(wccGWCost2), TimeIndex+1] := TimeItem.GWCost2;
    Grid.Cells[Ord(wccGWCost3), TimeIndex+1] := TimeItem.GWCost3;
    Grid.Cells[Ord(wccGWCost4), TimeIndex+1] := TimeItem.GWCost4;
    Grid.Cells[Ord(wccSWCost1), TimeIndex+1] := TimeItem.SWCost1;
    Grid.Cells[Ord(wccSWCost2), TimeIndex+1] := TimeItem.SWCost2;
    Grid.Cells[Ord(wccSWCost3), TimeIndex+1] := TimeItem.SWCost3;
    Grid.Cells[Ord(wccSWCost4), TimeIndex+1] := TimeItem.SWCost4;
  end;
end;

procedure TframeFarm.GetCropEffForFirstFarm(
  FirstFarm: TFarm);
var
  AFarm: TFarm;
  CropIndex: Integer;
  FarmEff: TFarmEfficienciesItem;
  MaxIndex: Integer;
  TimeIndex: Integer;
  TimeItem: TCropEfficiencyItem;
  Grid: TRbwDataGrid4;
  MaxTimeCount: Integer;
  CropEfficiency: TCropEfficiencyCollection;
  ColIndex: Integer;
begin
  AFarm := FirstFarm;
  GetMaxTimeAndCountForCrops(MaxIndex, MaxTimeCount, AFarm);
  frameFormulaGridCrops.seNumber.AsInteger := MaxTimeCount;
  frameFormulaGridCrops.seNumber.OnChange(frameFormulaGridCrops.seNumber);
  frameFormulaGridCrops.InitializePestParameters;

  if MaxIndex >= 0 then
  begin
    FarmEff := AFarm.CurrentFarmEfficiencyCollection[MaxIndex];
    Grid := frameFormulaGridCrops.Grid;
    for TimeIndex := 0 to FarmEff.CropEfficiency.Count - 1 do
    begin
      TimeItem := FarmEff.CropEfficiency[TimeIndex];
      Grid.Cells[Ord(ccStartTime), TimeIndex+1+PestRowOffset] := FloatToStr(TimeItem.StartTime);
      Grid.Cells[Ord(ccEndTime), TimeIndex+1+PestRowOffset] := FloatToStr(TimeItem.EndTime);
    end;

    frameFormulaGridCrops.PestUsedOnCol[Ord(ccStartTime)] := False;
    frameFormulaGridCrops.PestUsedOnCol[Ord(ccEndTime)] := False;

    for CropIndex := 0 to AFarm.CurrentFarmEfficiencyCollection.Count - 1 do
    begin
      FarmEff := AFarm.CurrentFarmEfficiencyCollection[CropIndex];
      CropEfficiency := FarmEff.CropEfficiency;
      ColIndex := Ord(ccCrop) + CropIndex;

      frameFormulaGridCrops.PestUsedOnCol[ColIndex] := True;
      frameFormulaGridCrops.PestModifier[ColIndex] := CropEfficiency.PestSeriesParameter;
      frameFormulaGridCrops.PestMethod[ColIndex] := CropEfficiency.PestParamMethod;

      for TimeIndex := 0 to CropEfficiency.Count - 1 do
      begin
        TimeItem := FarmEff.CropEfficiency[TimeIndex];
        Grid.Cells[ColIndex, TimeIndex+1+PestRowOffset] := TimeItem.Efficiency;
      end;
    end;
  end;
end;

procedure TframeFarm.GetCropEffImproveForFirstFarm(FirstFarm: TFarm);
begin
  GetAnEfficiencyCollection(FirstFarm, frameFormulaGridEfficiencyImprovement,
    FirstFarm.FarmIrrigationEfficiencyImprovementCollection);
end;

procedure TframeFarm.GetWaterRightsForFirstFarm(
  FirstFarm: TFarm);
var
  AFarm: TFarm;
  TimeIndex: Integer;
  ATimeItem: TWaterRightsItem;
  Grid: TRbwDataGrid4;
begin
  AFarm := FirstFarm;
  frameFormulaGridWaterRights.seNumber.AsInteger := AFarm.WaterRights.Count;
  frameFormulaGridWaterRights.seNumber.OnChange(frameFormulaGridWaterRights.seNumber);
  Grid := frameFormulaGridWaterRights.Grid;
  for TimeIndex := 0 to AFarm.WaterRights.Count - 1 do
  begin
    ATimeItem := AFarm.WaterRights[TimeIndex];
    Grid.Cells[Ord(wrccStartTime), TimeIndex+1] := FloatToStr(ATimeItem.StartTime);
    Grid.Cells[Ord(wrccEndTime), TimeIndex+1] := FloatToStr(ATimeItem.EndTime);
    Grid.Cells[Ord(wrccCall), TimeIndex+1] := ATimeItem.WaterRights;
  end;
end;

procedure TframeFarm.GetWaterSourceForFirstFarm(FirstFarm: TFarm);
var
  AFarm: TFarm;
  Frame: TframeFormulaGrid;
  Grid: TRbwDataGrid4;
//  ATimeItem: TOwhmItem;
  TimeIndex: Integer;
  WaterSource: TWaterSourceCollection;
  ATimeItem: TWaterSourceItem;
begin
  AFarm := FirstFarm;
  Frame := frameWaterSource;
  Grid := Frame.Grid;
  WaterSource := AFarm.WaterSource;

  Frame.seNumber.AsInteger := WaterSource.Count;
  Frame.seNumber.OnChange(Frame.seNumber);
  for TimeIndex := 0 to WaterSource.Count - 1 do
  begin
    ATimeItem := WaterSource[TimeIndex];
    Grid.Cells[Ord(wscStartTime), TimeIndex+1] := FloatToStr(ATimeItem.StartTime);
    Grid.Cells[Ord(wscEndTime), TimeIndex+1] := FloatToStr(ATimeItem.EndTime);
    Grid.Cells[Ord(wscGroundwater), TimeIndex+1] := ATimeItem.Groundwater;
    Grid.Cells[Ord(wscSurfaceWater), TimeIndex+1] := ATimeItem.SurfaceWater;
    Grid.Cells[Ord(wscNonRouted), TimeIndex+1] := ATimeItem.NonRoutedDelivery;
  end;
end;

procedure TframeFarm.GetWaterSupplyConcentrationForFirstFarm(FirstFarm: TFarm);
var
  AFarm: TFarm;
  Grid: TRbwDataGrid4;
  TimeIndex: Integer;
  ATimeItem: TSaltSupplyConcentrationItem;
begin
  AFarm := FirstFarm;
  frameWaterSupplyConcentration.seNumber.AsInteger :=
    AFarm.SaltSupplyConcentrationCollection.Count;
  frameWaterSupplyConcentration.seNumber.OnChange(frameWaterSupplyConcentration.seNumber);
  frameWaterSupplyConcentration.InitializePestParameters;
  Grid := frameWaterSupplyConcentration.Grid;
  Grid.BeginUpdate;
  try
    for TimeIndex := 0 to AFarm.SaltSupplyConcentrationCollection.Count - 1 do
    begin
      ATimeItem := AFarm.SaltSupplyConcentrationCollection[TimeIndex] as TSaltSupplyConcentrationItem;
      Grid.Cells[Ord(sccStartTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.StartTime);
      Grid.Cells[Ord(sccEndTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.EndTime);
      Grid.Cells[Ord(sccNonRouted), TimeIndex+1+PestRowOffset] := ATimeItem.NonRoutedConcentration;
      Grid.Cells[Ord(sccSurfaceWater), TimeIndex+1+PestRowOffset] := ATimeItem.SurfaceWaterConcentration;
      Grid.Cells[Ord(sccGroundWater), TimeIndex+1+PestRowOffset] := ATimeItem.GroundwaterConcentration;
      Grid.Cells[Ord(sccExternal), TimeIndex+1+PestRowOffset] := ATimeItem.ExternalConcentration;
    end;

    frameWaterSupplyConcentration.PestUsedOnCol[Ord(sccStartTime)] := False;
    frameWaterSupplyConcentration.PestUsedOnCol[Ord(sccEndTime)] := False;

    frameWaterSupplyConcentration.PestUsedOnCol[Ord(sccNonRouted)] := True;
    frameWaterSupplyConcentration.PestModifier[Ord(sccNonRouted)] := AFarm.SaltSupplyConcentrationCollection.PestSeriesParameter;
    frameWaterSupplyConcentration.PestMethod[Ord(sccNonRouted)] := AFarm.SaltSupplyConcentrationCollection.PestParamMethod;

    frameWaterSupplyConcentration.PestUsedOnCol[Ord(sccSurfaceWater)] := True;
    frameWaterSupplyConcentration.PestModifier[Ord(sccSurfaceWater)] := AFarm.SaltSupplyConcentrationCollection.SWConcPestSeriesParameter;
    frameWaterSupplyConcentration.PestMethod[Ord(sccSurfaceWater)] := AFarm.SaltSupplyConcentrationCollection.SWConcPestParamMethod;

    frameWaterSupplyConcentration.PestUsedOnCol[Ord(sccGroundWater)] := True;
    frameWaterSupplyConcentration.PestModifier[Ord(sccGroundWater)] := AFarm.SaltSupplyConcentrationCollection.GWConcPestSeriesParameter;
    frameWaterSupplyConcentration.PestMethod[Ord(sccGroundWater)] := AFarm.SaltSupplyConcentrationCollection.GWConcPestParamMethod;

    frameWaterSupplyConcentration.PestUsedOnCol[Ord(sccExternal)] := True;
    frameWaterSupplyConcentration.PestModifier[Ord(sccExternal)] := AFarm.SaltSupplyConcentrationCollection.ExtConcPestSeriesParameter;
    frameWaterSupplyConcentration.PestMethod[Ord(sccExternal)] := AFarm.SaltSupplyConcentrationCollection.ExtConcPestParamMethod;

  finally
    Grid.EndUpdate;
  end;

//  TSourceConcentrationColumns = (sccStartTime, sccEndTime, sccNonRouted,
//    sccSurfaceWater, sccGroundWater, sccExternal);

end;

procedure TframeFarm.InitializeAddedCropDemandFluxFrame(StartTimes,
  EndTimes: TStringList);
begin
  InitializeEfficiencyCollectionByCropFrame(
    StartTimes, EndTimes, frmGoPhast.PhastModel.FmpCrops,
    frameAddedCropDemandFlux, 'Added Crop Demand Flux (L/T) %s');
end;

procedure TframeFarm.InitializeAddedCropDemandRateFrame(StartTimes,
  EndTimes: TStringList);
begin
  InitializeEfficiencyCollectionByCropFrame(
    StartTimes, EndTimes, frmGoPhast.PhastModel.FmpCrops,
    frameAddedCropDemandRate, 'Added Crop Demand Rate (L^3/T) %s');
end;

procedure TframeFarm.InitializeBareRunoffFractionsFrame(StartTimes,
  EndTimes: TStringList);
begin
  InitializeSingleValueFrame(StartTimes, EndTimes,
    frameBareRunoffFractions, 'Bare Runoff Fraction');
end;

procedure TframeFarm.InitializeControls;
var
  Grid: TRbwDataGrid4;
  Crops: TCropCollection;
  CropIndex: integer;
  ACrop: TCropItem;
  StressPeriods: TModflowStressPeriods;
  StartTimes: TStringList;
  EndTimes: TStringList;
  ColIndex: Integer;
  IrrigationType: TIrrigationItem;
  IrrigationTypes: TIrrigationCollection;
  Packages: TModflowPackages;
  Units: string;
begin
  seFarmId.AsInteger := 0;
  edFarmName.Text := '';

  frameFormulaGridCrops.IncludePestAdjustment := True;
  frameBareRunoffFractions.IncludePestAdjustment := True;
  frameAddedDemandRunoffSplit.IncludePestAdjustment := True;
  frameFormulaGridEfficiencyImprovement.IncludePestAdjustment := True;
  frameIrrigationUniformity.IncludePestAdjustment := True;
  frameAddedCropDemandFlux.IncludePestAdjustment := True;
  frameAddedCropDemandRate.IncludePestAdjustment := True;
  frameGW_Allocation.IncludePestAdjustment := True;
  frameSwAllotment.IncludePestAdjustment := True;
  frameWaterSupplyConcentration.IncludePestAdjustment := True;
//  frameDiversionsOwhm2.frameFarmDiversions.IncludePestAdjustment := True;
//  frameReturnFlowsOwhm2.frameFarmDiversions.IncludePestAdjustment := True;

  frameFormulaGridDiversion.OnChange := Change;
  frameFormulaGridReturnFlow.OnChange := Change;
  frameDelivery.OnChange := Change;

  Packages := frmGoPhast.PhastModel.ModflowPackages;

  tabDiversionLocation.TabVisible :=  (frmGoPhast.ModelSelection = msModflowFmp)
    and frmGoPhast.PhastModel.SfrIsSelected
    and (frmGoPhast.ModelSelection = msModflowFmp);
  tabReturnFlowLocation.TabVisible := tabDiversionLocation.TabVisible;

  tabDiversionsOwhm2.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
    and frmGoPhast.PhastModel.SfrIsSelected
    and Packages.FarmSurfaceWater4.IsSelected and
    (Packages.FarmSurfaceWater4.Semi_Routed_Delivery.FarmOption <> foNotUsed);
  tabReturnFlowOwhm2.TabVisible := (frmGoPhast.ModelSelection = msModflowOwhm2)
    and frmGoPhast.PhastModel.SfrIsSelected
    and Packages.FarmSurfaceWater4.IsSelected and
    (Packages.FarmSurfaceWater4.SemiRoutedReturn.FarmOption <> foNotUsed);
  frameDiversionsOwhm2.InitializeControls;
  frameReturnFlowsOwhm2.InitializeControls;

  if frmGoPhast.ModelSelection = msModflowFmp then
  begin
    tabGW_Allocation.Caption := 'GW Allocation';
    tabGW_Allocation.TabVisible := Packages.FarmProcess.
      GroundwaterAllotmentsUsed;
  end
  else
  begin
    Assert(frmGoPhast.ModelSelection = msModflowOwhm2);
    tabGW_Allocation.Caption := 'GW Allotment';
    tabGW_Allocation.TabVisible := Packages.FarmAllotments.IsSelected
      and (Packages.FarmAllotments.GroundWater.FarmOption <> foNotUsed);
  end;


  tabSwAllotment.TabVisible := Packages.FarmAllotments.IsSelected
      and (Packages.FarmAllotments.SurfaceWater.FarmOption <> foNotUsed);

  pcMain.ActivePageIndex := 0;
  StressPeriods := frmGoPhast.PhastModel.ModflowStressPeriods;

  StartTimes := TStringList.Create;
  EndTimes := TStringList.Create;
  IrrigationTypes := frmGoPhast.PhastModel.IrrigationTypes;
  try
    // set up Crops grid.
    StressPeriods.FillStringsWithStartTimes(StartTimes);
    StressPeriods.FillStringsWithEndTimes(EndTimes);
    frameFormulaGridCrops.FirstFormulaColumn := Ord(ccCrop);
    frameFormulaGridCrops.ClearGrid;
    Grid := frameFormulaGridCrops.Grid;
    if frmGoPhast.ModelSelection = msModflowFmp then
    begin
      Crops := frmGoPhast.PhastModel.FmpCrops;
      Grid.ColCount := Crops.Count + 2;
      Grid.BeginUpdate;
      try
        Grid.Cells[Ord(ccStartTime), 0] := StrStartingTime;
        Grid.Cells[Ord(ccEndTime), 0] := StrEndingTime;
        Grid.Columns[Ord(ccStartTime)].PickList := StartTimes;
        Grid.Columns[Ord(ccEndTime)].PickList := EndTimes;
        for CropIndex := 0 to Crops.Count - 1 do
        begin
          ACrop := Crops[CropIndex];
          Grid.Cells[Ord(ccCrop) + CropIndex, 0] :=
            Format(StrCropEfficiency, [ACrop.CropName]);
          Grid.Columns[Ord(ccCrop) + CropIndex].ButtonUsed := True;
          Grid.Columns[Ord(ccCrop) + CropIndex].ButtonCaption := StrF;
          Grid.Columns[Ord(ccCrop) + CropIndex].ButtonWidth := 35;
          Grid.Columns[Ord(ccCrop) + CropIndex].WordWrapCaptions := True;
          Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := True;
          Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustRowHeights := True;
        end;
      finally
        Grid.EndUpdate;
      end;
      Grid.BeginUpdate;
      try
        for CropIndex := 0 to Crops.Count - 1 do
        begin
          Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := False;
        end;
      finally
        Grid.EndUpdate;
      end;
    end
    else
    begin
      Assert(frmGoPhast.ModelSelection = msModflowOwhm2);
      Grid.ColCount := IrrigationTypes.Count + 2;
      Grid.BeginUpdate;
      try
        Grid.Cells[Ord(ccStartTime), 0] := StrStartingTime;
        Grid.Cells[Ord(ccEndTime), 0] := StrEndingTime;
        Grid.Columns[Ord(ccStartTime)].PickList := StartTimes;
        Grid.Columns[Ord(ccEndTime)].PickList := EndTimes;
        for CropIndex := 0 to IrrigationTypes.Count - 1 do
        begin
          IrrigationType := IrrigationTypes[CropIndex];
          Grid.Cells[Ord(ccCrop) + CropIndex, 0] :=
            Format(StrCropEfficiency, [IrrigationType.Name]);
          Grid.Columns[Ord(ccCrop) + CropIndex].ButtonUsed := True;
          Grid.Columns[Ord(ccCrop) + CropIndex].ButtonCaption := StrF;
          Grid.Columns[Ord(ccCrop) + CropIndex].ButtonWidth := 35;
          Grid.Columns[Ord(ccCrop) + CropIndex].WordWrapCaptions := True;
          Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := True;
          Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustRowHeights := True;
        end;
      finally
        Grid.EndUpdate;
      end;
      Grid.BeginUpdate;
      try
        for CropIndex := 0 to IrrigationTypes.Count - 1 do
        begin
          Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := False;
        end;
      finally
        Grid.EndUpdate;
      end;
    end;
    frameFormulaGridCrops.LayoutMultiRowEditControls;

    InitializeEfficiencyCollectionFrame(StartTimes, EndTimes,
      IrrigationTypes, frameFormulaGridEfficiencyImprovement,
      '%s efficiency improvement (True/False)');

    InitializeEfficiencyCollectionFrame(StartTimes, EndTimes,
      IrrigationTypes, frameAddedDemandRunoffSplit,
      '%s added demanand runoff split');

    InitializeEfficiencyCollectionFrame(StartTimes, EndTimes,
      IrrigationTypes, frameIrrigationUniformity,
      '%s irrigation uniformity');

    InitializeDeficiencyScenarioFrame(StartTimes, EndTimes);

    InitializeWaterSourceFrame(StartTimes, EndTimes,
      frameWaterSource,
      ['Use Groundwater (True/False)', 'Use Surface Water (True/False)', 'Use Non-Routed Deliveries (True/False)']);

    InitializeBareRunoffFractionsFrame(StartTimes, EndTimes);
    InitializeAddedCropDemandFluxFrame(StartTimes, EndTimes);
    InitializeAddedCropDemandRateFrame(StartTimes, EndTimes);

    InitializeSingleValueFrame(StartTimes, EndTimes,
      frameNoReturnFlow, 'Runoff Choice');
    frameNoReturnFlow.FirstChoiceColumn := 2;
    frameNoReturnFlow.LayoutMultiRowEditControls;
    frameNoReturnFlow.Grid.Columns[Ord(nrfcValue)].ComboUsed := True;

    Grid := frameFormulaGridCosts.Grid;
    ClearGrid(Grid);
    Grid.BeginUpdate;
    try
      frameFormulaGridCosts.FirstFormulaColumn := Ord(wccGWCost1);
      Grid.Cells[Ord(wccStartTime), 0] := StrStartingTime;
      Grid.Cells[Ord(wccEndTime), 0] := StrEndingTime;
      Grid.Cells[Ord(wccGWCost1), 0] := StrGWBaseMaintenance;
      Grid.Cells[Ord(wccGWCost2), 0] := StrGWPumpingCostsV;
      Grid.Cells[Ord(wccGWCost3), 0] := StrGWVerticalLiftCos;
      Grid.Cells[Ord(wccGWCost4), 0] := StrGWDeliveryCosts;
      Grid.Cells[Ord(wccSWCost1), 0] := StrFixedPriceOfSemi;
      Grid.Cells[Ord(wccSWCost2), 0] := StrVerticalLiftCosts;
      Grid.Cells[Ord(wccSWCost3), 0] := StrDeliveryCostsOfS;
      Grid.Cells[Ord(wccSWCost4), 0] := StrFixedPriceOfNonr;

      Grid.Columns[Ord(wccStartTime)].ComboUsed := True;
      Grid.Columns[Ord(wccEndTime)].ComboUsed := True;
      Grid.Columns[Ord(ccStartTime)].PickList := StartTimes;
      Grid.Columns[Ord(ccEndTime)].PickList := EndTimes;

      for ColIndex := Ord(wccGWCost1) to Grid.ColCount - 1 do
      begin
        Grid.Columns[ColIndex].ButtonUsed := True;
        Grid.Columns[ColIndex].ButtonCaption := StrF;
        Grid.Columns[ColIndex].ButtonWidth := 35;
      end;

      for ColIndex := 0 to Grid.ColCount - 1 do
      begin
        Grid.Columns[ColIndex].AutoAdjustColWidths := True;
        Grid.Columns[ColIndex].AutoAdjustRowHeights := True;
        Grid.Columns[ColIndex].WordWrapCaptions := True;
      end;

    finally
      Grid.EndUpdate;
    end;
    frameFormulaGridCosts.LayoutMultiRowEditControls;

    frameFormulaGridDiversion.InitializeControls;
    frameFormulaGridReturnFlow.InitializeControls;

//    frameDelivery
    frameDelivery.InitializeControls;

    Grid := frameFormulaGridWaterRights.Grid;
    ClearGrid(Grid);
    Grid.BeginUpdate;
    try
      frameFormulaGridWaterRights.FirstFormulaColumn := Ord(wrccCall);
      Grid.Cells[Ord(wrccStartTime), 0] := StrStartingTime;
      Grid.Cells[Ord(wrccEndTime), 0] := StrEndingTime;
      Grid.Cells[Ord(wrccCall), 0] := StrWaterRightsCallC;
      Grid.Columns[Ord(wrccStartTime)].PickList := StartTimes;
      Grid.Columns[Ord(wrccEndTime)].PickList := EndTimes;
      Grid.Columns[Ord(wrccStartTime)].ComboUsed := True;
      Grid.Columns[Ord(wrccEndTime)].ComboUsed := True;

    //wrccStartTime, wrccEndTime, wrccCall
    finally
      Grid.EndUpdate;
    end;
    frameFormulaGridWaterRights.LayoutMultiRowEditControls;

    Units := '';
    case Packages.FarmAllotments.GroundWaterAllotmentMethod of
      amHeight: Units := ' (L)';
      amVolume: Units := ' (L^3)';
      amRate: Units := ' (L^3/T)';
    end;
    Grid := frameGW_Allocation.Grid;
    ClearGrid(Grid);
    Grid.BeginUpdate;
    try
      frameGW_Allocation.FirstFormulaColumn := Ord(gacAllotment);
      Grid.Cells[Ord(gacStartTime), 0] := StrStartingTime;
      Grid.Cells[Ord(gacEndTime), 0] := StrEndingTime;
      Grid.Cells[Ord(gacAllotment), 0] := 'Groundwater allotment' + Units;
      Grid.Columns[Ord(gacStartTime)].PickList := StartTimes;
      Grid.Columns[Ord(gacEndTime)].PickList := EndTimes;
      Grid.Columns[Ord(gacStartTime)].ComboUsed := True;
      Grid.Columns[Ord(gacEndTime)].ComboUsed := True;
    finally
      Grid.EndUpdate;
    end;
    frameGW_Allocation.LayoutMultiRowEditControls;

    Units := '';
    case Packages.FarmAllotments.SurfaceWaterAllotmentMethod of
      amHeight: Units := ' (L)';
      amVolume: Units := ' (L^3)';
      amRate: Units := ' (L^3/T)';
    end;
    Grid := frameSwAllotment.Grid;
    ClearGrid(Grid);
    Grid.BeginUpdate;
    try
      frameSwAllotment.FirstFormulaColumn := Ord(gacAllotment);
      Grid.Cells[Ord(gacStartTime), 0] := StrStartingTime;
      Grid.Cells[Ord(gacEndTime), 0] := StrEndingTime;
      Grid.Cells[Ord(gacAllotment), 0] := 'Surface-water allotment' + Units;
      Grid.Columns[Ord(gacStartTime)].PickList := StartTimes;
      Grid.Columns[Ord(gacEndTime)].PickList := EndTimes;
      Grid.Columns[Ord(gacStartTime)].ComboUsed := True;
      Grid.Columns[Ord(gacEndTime)].ComboUsed := True;
    finally
      Grid.EndUpdate;
    end;
    frameSwAllotment.LayoutMultiRowEditControls;

    Grid := frameWaterSupplyConcentration.Grid;
    ClearGrid(Grid);
    Grid.BeginUpdate;
    try
      frameWaterSupplyConcentration.FirstFormulaColumn := Ord(sccNonRouted);
      Grid.Cells[Ord(sccStartTime), 0] := StrStartingTime;
      Grid.Cells[Ord(sccEndTime), 0] := StrEndingTime;
      Grid.Columns[Ord(sccStartTime)].PickList := StartTimes;
      Grid.Columns[Ord(sccEndTime)].PickList := EndTimes;
      Grid.Columns[Ord(sccStartTime)].ComboUsed := True;
      Grid.Columns[Ord(sccEndTime)].ComboUsed := True;
      Grid.Cells[Ord(sccNonRouted), 0] := 'Non-Routed Delivery Concentration';
      Grid.Cells[Ord(sccSurfaceWater), 0] := 'Surface-Water Delivery Concentration';
      Grid.Cells[Ord(sccGroundWater), 0] := 'Groundwater Pumpage Concentration';
      Grid.Cells[Ord(sccExternal), 0] := 'External Source Concentration';

    finally
      Grid.EndUpdate;
    end;
    frameWaterSupplyConcentration.LayoutMultiRowEditControls;

  finally
    EndTimes.Free;
    StartTimes.Free;
  end;
end;

procedure TframeFarm.InitializeDeficiencyScenarioFrame(StartTimes,
  EndTimes: TStringList);
begin
  InitializeSingleValueFrame(StartTimes, EndTimes,
    frameDeficiencyScenario, 'Deficiency Scenario (True/False)');
end;

//procedure TframeFarm.InitializeSaltSupplyConcentrationFrame(StartTimes,
//  EndTimes: TStringList);
//begin
//
//end;

procedure TframeFarm.InitializeSingleValueFrame(StartTimes,
  EndTimes: TStringList; AFrame: TframeFormulaGrid;
  ValueCaption: string);
var
  Grid: TRbwDataGrid4;
begin
  Grid := AFrame.Grid;
  Grid.ColCount := 3;
  Grid.BeginUpdate;
  try
    Grid.Cells[Ord(dcStartTime), 0] := StrStartingTime;
    Grid.Cells[Ord(dcEndTime), 0] := StrEndingTime;
    Grid.Columns[Ord(dcStartTime)].PickList := StartTimes;
    Grid.Columns[Ord(dcEndTime)].PickList := EndTimes;
    Grid.Columns[Ord(dcStartTime)].ComboUsed := True;
    Grid.Columns[Ord(dcEndTime)].ComboUsed := True;
    Grid.Columns[Ord(dcStartTime)].WordWrapCaptions := True;
    Grid.Columns[Ord(dcEndTime)].WordWrapCaptions := True;

    Grid.Cells[Ord(dcValue), 0] := ValueCaption;
    Grid.Columns[Ord(dcValue)].ButtonUsed := True;
    Grid.Columns[Ord(dcValue)].ButtonCaption := StrF;
    Grid.Columns[Ord(dcValue)].ButtonWidth := 35;
    Grid.Columns[Ord(dcValue)].WordWrapCaptions := True;
    Grid.Columns[Ord(dcValue)].AutoAdjustColWidths := True;
    Grid.Columns[Ord(dcValue)].AutoAdjustRowHeights := True;
  finally
    Grid.EndUpdate;
  end
end;

procedure TframeFarm.seFarmIdChange(Sender: TObject);
begin
  inherited;
  FChangedID := True;
  DoChange;
end;


procedure TframeFarm.SetData(FarmList: TFarmList);
var
  index: Integer;
  Farm: TFarm;
  Crops: TCropCollection;
  IntValue: Integer;
  IrrigationTypes: TIrrigationCollection;
  PumpSpreadChoice: TOwhmV2PumpSpreadChoice;
begin
  if FChangedID then
  begin
    IntValue := seFarmId.AsInteger;
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      Farm.FarmId := IntValue;
      Farm.FarmName := edFarmName.Text;
    end;
  end;

  if comboPumpSpread.ItemIndex >= 0 then
  begin
    PumpSpreadChoice := TOwhmV2PumpSpreadChoice(comboPumpSpread.ItemIndex);
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      Farm.PumpSpreadChoice := PumpSpreadChoice;
    end;
  end;

  IrrigationTypes := frmGoPhast.PhastModel.IrrigationTypes;
  if FChangedCrops then
  begin
    Crops := frmGoPhast.PhastModel.FmpCrops;
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetCropEfficiencies(Farm, Crops, IrrigationTypes);
      end;
    end;
  end;

  if FEfficiencyImprovementChanged then
  begin
//    IrrigationTypes := frmGoPhast.PhastModel.IrrigationTypes;
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetCropEfficiencyImprove(Farm, IrrigationTypes);
      end;
    end;
  end;

  if FAddedDemandRunoffSplitChanged then
  begin
//    IrrigationTypes := frmGoPhast.PhastModel.IrrigationTypes;
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetAddedDemandRunoffSplit(Farm, IrrigationTypes);
      end;
    end;
  end;

  if FIrrigationUniformityChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetIrrigationUniformity(Farm, IrrigationTypes);
      end;
    end;
  end;

  if FDeficiencyScenarioChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetDeficiencyScenario(Farm);
      end;
    end;
  end;

  if FWaterSourceChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetWaterSource(Farm);
      end;
    end;
  end;

  if FBareRunoffFractionsChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetBareRunoffFractions(Farm);
      end;
    end;
  end;

  if FAddedCropDemandFluxChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetAddedCropDemandFlux(Farm);
      end;
    end;
  end;

  if FAddedCropDemandRateChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetAddedCropDemandRate(Farm);
      end;
    end;
  end;

  if FChangedCosts then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetFarmCosts(Farm);
      end;
    end;
  end;
  if FChangedWaterRights then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetWaterRights(Farm);
      end;
    end;
  end;

  if FChangedGwAllotment then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetGwAllotment(Farm);
      end;
    end;
  end;

  if FChangedSwAllotment then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetSwAllotment(Farm);
      end;
    end;
  end;

  if {FarmCreated or} frameFormulaGridDiversion.DataChanged then
  begin
    frameFormulaGridDiversion.SetData(FarmList, dtDiversion);
  end;
  if {FarmCreated or} frameFormulaGridReturnFlow.DataChanged then
  begin
    frameFormulaGridReturnFlow.SetData(FarmList, dtReturnFlow);
  end;
  if {FarmCreated or} frameDelivery.DataChanged then
  begin
    frameDelivery.SetData_OwhmV1(FarmList);
  end;

  frameDiversionsOwhm2.SetData(FarmList, dtDiversion);
  frameReturnFlowsOwhm2.SetData(FarmList, dtReturnFlow);

  if FNoReturnFlowChanged then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetNoReturnFlow(Farm);
      end;
    end;
  end;

  if FChangedWaterSupplyConcentrations then
  begin
    for index := 0 to FarmList.Count - 1 do
    begin
      Farm := FarmList[index];
      if Farm <> nil then
      begin
        SetSaltSupplyConcentration(Farm);
      end;
    end;
  end;
end;

procedure TframeFarm.GetPumpSpreadForFirstFarm(FirstFarm: TFarm);
begin
  comboPumpSpread.ItemIndex := Ord(FirstFarm.PumpSpreadChoice);
end;

procedure TframeFarm.SetAddedCropDemand(
  EfficiencyCollection: TFarmEfficiencyCollection; AFrame: TframeFormulaGrid);
var
  Crops: TCropCollection;
  CropIndex: Integer;
  EfficienciesItem: TFarmEfficienciesItem;
  StartTimes: System.Generics.Collections.TList<Double>;
  EndTimes: System.Generics.Collections.TList<Double>;
  Rows: TGenericIntegerList;
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
  StartTime: Double;
  EndTime: Double;
  CropEfficiency: TCropEfficiencyCollection;
  ColIndex: Integer;
  ARow: Integer;
  EfficiencyItem: TCropEfficiencyItem;
begin
  Crops := frmGoPhast.PhastModel.FmpCrops;
  begin
    for CropIndex := EfficiencyCollection.Count to Crops.Count - 1 do
    begin
      EfficienciesItem := EfficiencyCollection.Add;
      EfficienciesItem.CropEfficiency.CropName := Crops[CropIndex].CropName;
    end;
    while EfficiencyCollection.Count > Crops.Count do
    begin
      EfficiencyCollection.Last.Free;
    end;
  end;
  StartTimes := TList<Double>.Create;
  EndTimes := TList<Double>.Create;
  Rows := TGenericIntegerList.Create;
  try
    Grid := AFrame.Grid;
    for RowIndex := 1 to AFrame.seNumber.AsInteger do
    begin
      if TryStrToFloat(Grid.Cells[Ord(ccStartTime), RowIndex+PestRowOffset], StartTime)
        and TryStrToFloat(Grid.Cells[Ord(ccEndTime), RowIndex+PestRowOffset], EndTime) then
      begin
        Rows.Add(RowIndex+PestRowOffset);
        StartTimes.Add(StartTime);
        EndTimes.Add(EndTime);
      end;
    end;
    for CropIndex := 0 to EfficiencyCollection.Count - 1 do
    begin
      EfficienciesItem := EfficiencyCollection[CropIndex];
      CropEfficiency := EfficienciesItem.CropEfficiency;
      while CropEfficiency.Count > Rows.Count do
      begin
        CropEfficiency.Last.Free;
      end;
      while CropEfficiency.Count < Rows.Count do
      begin
        CropEfficiency.Add;
      end;
      ColIndex := CropIndex + Ord(ccCrop);
      for RowIndex := 0 to Rows.Count - 1 do
      begin
        ARow := Rows[RowIndex];
        EfficiencyItem := CropEfficiency[RowIndex];
        EfficiencyItem.StartTime := StartTimes[RowIndex];
        EfficiencyItem.EndTime := EndTimes[RowIndex];
        EfficiencyItem.Efficiency := Grid.Cells[ColIndex, ARow];
      end;
    end;
  finally
    StartTimes.Free;
    EndTimes.Free;
    Rows.Free;
  end;

  for CropIndex := 0 to EfficiencyCollection.Count - 1 do
  begin
    EfficienciesItem := EfficiencyCollection[CropIndex];
    CropEfficiency := EfficienciesItem.CropEfficiency;
    ColIndex := CropIndex + Ord(ccCrop);
    if AFrame.PestMethodAssigned[ColIndex] then
    begin
      CropEfficiency.PestParamMethod := AFrame.PestMethod[ColIndex];
    end;
    if AFrame.PestModifierAssigned[ColIndex] then
    begin
      CropEfficiency.PestSeriesParameter := AFrame.PestModifier[ColIndex];
    end;
  end;

end;

procedure TframeFarm.GetEfficiencyDataForFirstFarm(AFrame: TframeFormulaGrid; EffCollection: TFarmEfficiencyCollection);
var
  MaxTimeCount: Integer;
  MaxIndex: Integer;
  FarmEff: TFarmEfficienciesItem;
  Grid: TRbwDataGrid4;
  TimeIndex: Integer;
  TimeItem: TCropEfficiencyItem;
  CropIndex: Integer;
  CropEfficiency: TCropEfficiencyCollection;
  ColIndex: Integer;
begin
  GetMaxTimeAndCountForEfficiencyCollection(AFrame, EffCollection, MaxTimeCount, MaxIndex);
  AFrame.seNumber.AsInteger := MaxTimeCount;
  if Assigned(AFrame.seNumber.OnChange) then
  begin
    AFrame.seNumber.OnChange(AFrame.seNumber);
  end;
  AFrame.InitializePestParameters;

  AFrame.PestUsedOnCol[Ord(ccStartTime)] := False;
  AFrame.PestUsedOnCol[Ord(ccEndTime)] := False;

  AFrame.seNumber.OnChange(AFrame.seNumber);
  if MaxIndex >= 0 then
  begin
    FarmEff := EffCollection[MaxIndex];
    Grid := AFrame.Grid;
    for TimeIndex := 0 to FarmEff.CropEfficiency.Count - 1 do
    begin
      TimeItem := FarmEff.CropEfficiency[TimeIndex];
      Grid.Cells[Ord(ccStartTime), TimeIndex + 1+PestRowOffset] := FloatToStr(TimeItem.StartTime);
      Grid.Cells[Ord(ccEndTime), TimeIndex + 1+PestRowOffset] := FloatToStr(TimeItem.EndTime);
    end;
    for CropIndex := 0 to EffCollection.Count - 1 do
    begin
      FarmEff := EffCollection[CropIndex];
      CropEfficiency := FarmEff.CropEfficiency;
      ColIndex := Ord(ccCrop) + CropIndex;

      AFrame.PestUsedOnCol[ColIndex] := True;
      AFrame.PestModifier[ColIndex] := CropEfficiency.PestSeriesParameter;
      AFrame.PestMethod[ColIndex] := CropEfficiency.PestParamMethod;

      for TimeIndex := 0 to CropEfficiency.Count - 1 do
      begin
        TimeItem := CropEfficiency[TimeIndex];
        Grid.Cells[ColIndex, TimeIndex + 1+PestRowOffset] := TimeItem.Efficiency;
      end;
    end;
  end;

//    frameFormulaGridCrops.PestUsedOnCol[Ord(ccStartTime)] := False;
//    frameFormulaGridCrops.PestUsedOnCol[Ord(ccEndTime)] := False;
//    frameFormulaGridCrops.PestUsedOnCol[ColIndex] := True;
//    frameFormulaGridCrops.PestModifier[ColIndex] := CropEfficiency.PestSeriesParameter;
//    frameFormulaGridCrops.PestMethod[ColIndex] := CropEfficiency.PestParamMethod;

end;

procedure TframeFarm.GetMaxTimeAndCountForEfficiencyCollection(
  AFrame: TframeFormulaGrid; EffCollection: TFarmEfficiencyCollection;
  var MaxTimeCount: Integer; var MaxIndex: Integer);
var
  CropIndex: Integer;
  FarmEff: TFarmEfficienciesItem;
begin
  Assert(AFrame.Grid.ColCount = EffCollection.Count + 2);
  MaxTimeCount := 0;
//  Assert(EffCollection.Count > 0);
  MaxIndex := -1;
  for CropIndex := 0 to EffCollection.Count - 1 do
  begin
    FarmEff := EffCollection[CropIndex];
    if MaxTimeCount <= FarmEff.CropEfficiency.Count then
    begin
      MaxTimeCount := FarmEff.CropEfficiency.Count;
      MaxIndex := CropIndex;
    end;
  end;
end;

procedure TframeFarm.GetNoReturnFlowFirstFarm(FirstFarm: TFarm);
var
  Index: Integer;
  Grid: TRbwDataGrid4;
  Row: Integer;
  Item: TNoReturnItem;
begin
  frameNoReturnFlow.seNumber.AsInteger := FirstFarm.NoReturnFlow.Count;
  Grid :=  frameNoReturnFlow.Grid;
  for Index := 0 to FirstFarm.NoReturnFlow.Count - 1 do
  begin
    Row := Index + 1;
    Item := FirstFarm.NoReturnFlow[Index] as TNoReturnItem;
    Grid.RealValue[Ord(nrfcStartTime), Row] := Item.StartTime;
    Grid.RealValue[Ord(nrfcEndTime), Row] := Item.EndTime;
    Grid.ItemIndex[Ord(nrfcValue), Row] := Ord(Item.NoReturnOption);
  end;
end;

procedure TframeFarm.GetSwAllotmentForFirstFarm(FirstFarm: TFarm);
var
  AFarm: TFarm;
  Grid: TRbwDataGrid4;
  TimeIndex: Integer;
  ATimeItem: TAllotmentItem;
begin
  AFarm := FirstFarm;
  frameSwAllotment.seNumber.AsInteger := AFarm.SWAllotment.Count;
  frameSwAllotment.seNumber.OnChange(frameSwAllotment.seNumber);
  frameSwAllotment.InitializePestParameters;

  Grid := frameSwAllotment.Grid;
  Grid.BeginUpdate;
  try
    for TimeIndex := 0 to AFarm.SWAllotment.Count - 1 do
    begin
      ATimeItem := AFarm.SWAllotment[TimeIndex];
      Grid.Cells[Ord(wrccStartTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.StartTime);
      Grid.Cells[Ord(wrccEndTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.EndTime);
      Grid.Cells[Ord(wrccCall), TimeIndex+1+PestRowOffset] := ATimeItem.Allotment;
    end;

    frameSwAllotment.PestUsedOnCol[Ord(wrccStartTime)] := False;
    frameSwAllotment.PestUsedOnCol[Ord(wrccEndTime)] := False;
    frameSwAllotment.PestUsedOnCol[Ord(wrccCall)] := True;
    frameSwAllotment.PestModifier[Ord(wrccCall)] := AFarm.SWAllotment.PestSeriesParameter;
    frameSwAllotment.PestMethod[Ord(wrccCall)] := AFarm.SWAllotment.PestParamMethod;

  finally
    Grid.EndUpdate;
  end;
end;

procedure TframeFarm.UpdateEndTime(Sender: TObject; ACol: Integer; ARow: Integer);
var
  Grid: TRbwDataGrid4;
  ItemIndex: Integer;
begin
  if Sender is TRbwDataGrid4 then
  begin
    Grid := TRbwDataGrid4(Sender);
    if (ACol = 0) and (ARow >= Grid.FixedRows) and (Grid.Cells[1, ARow] = '') then
    begin
      ItemIndex := Grid.ItemIndex[ACol, ARow];
      if ItemIndex >= 0 then
      begin
        Grid.ItemIndex[1, ARow] := ItemIndex;
      end;
    end;
  end;
end;

procedure TframeFarm.SetDeficiencyScenario(Farm: TFarm);
var
  AFrame: TframeFormulaGrid;
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
  StartTimes: TList<Double>;
  EndTimes: TList<Double>;
  Rows: TGenericIntegerList;
  DeficiencyItem: TOwhmItem;
  StartTime: double;
  EndTime: double;
  ARow: Integer;
begin
  AFrame := frameDeficiencyScenario;
  Grid := AFrame.Grid;
  StartTimes := TList<Double>.Create;
  EndTimes := TList<Double>.Create;
  Rows := TGenericIntegerList.Create;
  try
    for RowIndex := 1 to AFrame.seNumber.AsInteger do
    begin
      if TryStrToFloat(Grid.Cells[Ord(dcStartTime), RowIndex], StartTime)
        and TryStrToFloat(Grid.Cells[Ord(dcEndTime), RowIndex], EndTime) then
      begin
        Rows.Add(RowIndex);
        StartTimes.Add(StartTime);
        EndTimes.Add(EndTime);
      end;
    end;
    for RowIndex := 0 to Rows.Count - 1 do
    begin
      ARow := Rows[RowIndex];
      if RowIndex < Farm.DeficiencyScenario.Count then
      begin
        DeficiencyItem := Farm.DeficiencyScenario[RowIndex];
      end
      else
      begin
        DeficiencyItem := Farm.DeficiencyScenario.Add as TOwhmItem;
      end;
      DeficiencyItem.OwhmValue := Grid.Cells[Ord(dcValue),ARow];
      DeficiencyItem.StartTime := StartTimes[RowIndex];
      DeficiencyItem.EndTime := EndTimes[RowIndex];
    end;
    while Farm.DeficiencyScenario.Count > StartTimes.Count do
    begin
      Farm.DeficiencyScenario.Last.Free;
    end;
  finally
    Rows.Free;
    StartTimes.Free;
    EndTimes.Free;
  end;
end;

procedure TframeFarm.GetAnEfficiencyCollection(AFarm: TFarm;
  AFrame: TframeFormulaGrid; EfficiencyCollection: TFarmEfficiencyCollection);
var
  MaxIndex: Integer;
  MaxTimeCount: Integer;
  FarmEff: TFarmEfficienciesItem;
  Grid: TRbwDataGrid4;
  TimeIndex: Integer;
  TimeItem: TCropEfficiencyItem;
  CropIndex: Integer;
  CropEfficiency: TCropEfficiencyCollection;
  ColIndex: Integer;
begin
  GetMaxTimeAndCountForCrops(MaxIndex, MaxTimeCount, AFarm);
  AFrame.seNumber.AsInteger := MaxTimeCount;
  AFrame.seNumber.OnChange(AFrame.seNumber);

  AFrame.InitializePestParameters;

  AFrame.PestUsedOnCol[Ord(ccStartTime)] := False;
  AFrame.PestUsedOnCol[Ord(ccEndTime)] := False;

  if MaxIndex >= 0 then
  begin
    FarmEff := EfficiencyCollection[MaxIndex];
    Grid := AFrame.Grid;
    for TimeIndex := 0 to FarmEff.CropEfficiency.Count - 1 do
    begin
      TimeItem := FarmEff.CropEfficiency[TimeIndex];
      Grid.Cells[Ord(ccStartTime), TimeIndex + 1+PestRowOffset] := FloatToStr(TimeItem.StartTime);
      Grid.Cells[Ord(ccEndTime), TimeIndex + 1+PestRowOffset] := FloatToStr(TimeItem.EndTime);
    end;
    for CropIndex := 0 to EfficiencyCollection.Count - 1 do
    begin
      FarmEff := EfficiencyCollection[CropIndex];
      CropEfficiency := FarmEff.CropEfficiency;
      ColIndex := Ord(ccCrop) + CropIndex;

      AFrame.PestUsedOnCol[ColIndex] := True;
      AFrame.PestModifier[ColIndex] := CropEfficiency.PestSeriesParameter;
      AFrame.PestMethod[ColIndex] := CropEfficiency.PestParamMethod;

      for TimeIndex := 0 to CropEfficiency.Count - 1 do
      begin
        TimeItem := CropEfficiency[TimeIndex];
        Grid.Cells[ColIndex, TimeIndex + 1+PestRowOffset] := TimeItem.Efficiency;
      end;
    end;
  end;
end;

procedure TframeFarm.GetBareRunoffFractonForFirstFarm(FirstFarm: TFarm);
var
  AFarm: TFarm;
  Frame: TframeFormulaGrid;
  Grid: TRbwDataGrid4;
  ATimeItem: TOwhmItem;
  TimeIndex: Integer;
  BareRunoffFraction: TBareRunoffFractionCollection;
begin
  AFarm := FirstFarm;
  Frame := frameBareRunoffFractions;
  Frame.InitializePestParameters;

  Grid := Frame.Grid;
  BareRunoffFraction := AFarm.BareRunoffFraction;

  Grid.BeginUpdate;
  try
    Frame.seNumber.AsInteger := BareRunoffFraction.Count;
    Frame.seNumber.OnChange(Frame.seNumber);
    for TimeIndex := 0 to BareRunoffFraction.Count - 1 do
    begin
      ATimeItem := BareRunoffFraction[TimeIndex];
      Grid.Cells[Ord(brfcStartTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.StartTime);
      Grid.Cells[Ord(brfcEndTime), TimeIndex+1+PestRowOffset] := FloatToStr(ATimeItem.EndTime);
      Grid.Cells[Ord(brfcValue), TimeIndex+1+PestRowOffset] := ATimeItem.OwhmValue;
    end;

    Frame.PestUsedOnCol[Ord(brfcStartTime)] := False;
    Frame.PestUsedOnCol[Ord(brfcEndTime)] := False;
    Frame.PestUsedOnCol[Ord(brfcValue)] := True;
    Frame.PestModifier[Ord(brfcValue)] := BareRunoffFraction.PestSeriesParameter;
    Frame.PestMethod[Ord(brfcValue)] := BareRunoffFraction.PestParamMethod;
  finally
    Grid.EndUpdate;
  end;

end;

procedure TframeFarm.InitializeEfficiencyCollectionByCropFrame(StartTimes,
  EndTimes: TStringList; Crops: TCropCollection; AFrame: TframeFormulaGrid;
  CaptionFormatString: string);
var
  CropIndex: Integer;
  Grid: TRbwDataGrid4;
  ACrop: TCropItem;
begin
  Grid := AFrame.Grid;
  Grid.ColCount := Crops.Count + 2;
  Grid.BeginUpdate;
  try
    Grid.Cells[Ord(ccStartTime), 0] := StrStartingTime;
    Grid.Cells[Ord(ccEndTime), 0] := StrEndingTime;
    Grid.Columns[Ord(ccStartTime)].PickList := StartTimes;
    Grid.Columns[Ord(ccEndTime)].PickList := EndTimes;
    Grid.Columns[Ord(ccStartTime)].ComboUsed := True;
    Grid.Columns[Ord(ccEndTime)].ComboUsed := True;
    Grid.Columns[Ord(ccStartTime)].WordWrapCaptions := True;
    Grid.Columns[Ord(ccEndTime)].WordWrapCaptions := True;
    for CropIndex := 0 to Crops.Count - 1 do
    begin
      ACrop := Crops[CropIndex];
      Grid.Cells[Ord(ccCrop) + CropIndex, 0] := Format(CaptionFormatString, [ACrop.CropName]);
      Grid.Columns[Ord(ccCrop) + CropIndex].ButtonUsed := True;
      Grid.Columns[Ord(ccCrop) + CropIndex].ButtonCaption := StrF;
      Grid.Columns[Ord(ccCrop) + CropIndex].ButtonWidth := 35;
      Grid.Columns[Ord(ccCrop) + CropIndex].WordWrapCaptions := True;
      Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := True;
      Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustRowHeights := True;
    end;
  finally
    Grid.EndUpdate;
  end;
  Grid.BeginUpdate;
  try
    for CropIndex := 0 to Crops.Count - 1 do
    begin
      Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := False;
    end;
  finally
    Grid.EndUpdate;
  end;
  AFrame.LayoutMultiRowEditControls;
end;

procedure TframeFarm.InitializeEfficiencyCollectionFrame
  (StartTimes, EndTimes: TStringList; IrrigationTypes: TIrrigationCollection;
  AFrame: TframeFormulaGrid; CaptionFormatString: string);
var
  CropIndex: Integer;
  Grid: TRbwDataGrid4;
  IrrigationType: TIrrigationItem;
begin
  Grid := AFrame.Grid;
  IrrigationTypes := frmGoPhast.PhastModel.IrrigationTypes;
  Grid.ColCount := IrrigationTypes.Count + 2;
  Grid.BeginUpdate;
  try
    Grid.Cells[Ord(ccStartTime), 0] := StrStartingTime;
    Grid.Cells[Ord(ccEndTime), 0] := StrEndingTime;
    Grid.Columns[Ord(ccStartTime)].PickList := StartTimes;
    Grid.Columns[Ord(ccEndTime)].PickList := EndTimes;
    Grid.Columns[Ord(ccStartTime)].ComboUsed := True;
    Grid.Columns[Ord(ccEndTime)].ComboUsed := True;
    Grid.Columns[Ord(ccStartTime)].WordWrapCaptions := True;
    Grid.Columns[Ord(ccEndTime)].WordWrapCaptions := True;
    for CropIndex := 0 to IrrigationTypes.Count - 1 do
    begin
      IrrigationType := IrrigationTypes[CropIndex];
      Grid.Cells[Ord(ccCrop) + CropIndex, 0] := Format(CaptionFormatString, [IrrigationType.Name]);
      Grid.Columns[Ord(ccCrop) + CropIndex].ButtonUsed := True;
      Grid.Columns[Ord(ccCrop) + CropIndex].ButtonCaption := StrF;
      Grid.Columns[Ord(ccCrop) + CropIndex].ButtonWidth := 35;
      Grid.Columns[Ord(ccCrop) + CropIndex].WordWrapCaptions := True;
      Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := True;
      Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustRowHeights := True;
    end;
  finally
    Grid.EndUpdate;
  end;
  Grid.BeginUpdate;
  try
    for CropIndex := 0 to IrrigationTypes.Count - 1 do
    begin
      Grid.Columns[Ord(ccCrop) + CropIndex].AutoAdjustColWidths := False;
    end;
  finally
    Grid.EndUpdate;
  end;
  AFrame.LayoutMultiRowEditControls;
end;

procedure TframeFarm.InitializeWaterSourceFrame(StartTimes,
  EndTimes: TStringList; AFrame: TframeFormulaGrid; ValueCaptions: array of string);
var
  Grid: TRbwDataGrid4;
  Index: TWaterSourceColumns;
begin
  Grid := AFrame.Grid;
  Grid.ColCount := 5;
  Grid.BeginUpdate;
  try
    Grid.Cells[Ord(wscStartTime), 0] := StrStartingTime;
    Grid.Cells[Ord(wscEndTime), 0] := StrEndingTime;
    Grid.Columns[Ord(wscStartTime)].PickList := StartTimes;
    Grid.Columns[Ord(wscEndTime)].PickList := EndTimes;
    Grid.Columns[Ord(wscStartTime)].ComboUsed := True;
    Grid.Columns[Ord(wscEndTime)].ComboUsed := True;
    Grid.Columns[Ord(wscStartTime)].WordWrapCaptions := True;
    Grid.Columns[Ord(wscEndTime)].WordWrapCaptions := True;

    for Index := wscGroundwater to wscNonRouted do
    begin
      Grid.Cells[Ord(Index), 0] := ValueCaptions[Ord(Index)-2];
      Grid.Columns[Ord(Index)].ButtonUsed := True;
      Grid.Columns[Ord(Index)].ButtonCaption := StrF;
      Grid.Columns[Ord(Index)].ButtonWidth := 35;
      Grid.Columns[Ord(Index)].WordWrapCaptions := True;
      Grid.Columns[Ord(Index)].AutoAdjustColWidths := True;
      Grid.Columns[Ord(Index)].AutoAdjustRowHeights := True;
    end;
  finally
    Grid.EndUpdate;
  end
end;

procedure TframeFarm.SetAddedCropDemandFlux(Farm: TFarm);
begin
  SetAddedCropDemand(Farm.AddedCropDemandFlux, frameAddedCropDemandFlux);
end;

procedure TframeFarm.SetAddedCropDemandRate(Farm: TFarm);
begin
  SetAddedCropDemand(Farm.AddedCropDemandRate, frameAddedCropDemandRate);
end;

procedure TframeFarm.SetAddedDemandRunoffSplit(Farm: TFarm;
  IrrigationTypes: TIrrigationCollection);
begin
  SetAnEfficiencyCollection(Farm.AddedDemandRunoffSplitCollection,
    frameAddedDemandRunoffSplit, IrrigationTypes);
end;

procedure TframeFarm.SetAnEfficiencyCollection(EfficiencyCollection: TFarmEfficiencyCollection;
  AFrame: TframeFormulaGrid; IrrigationTypes: TIrrigationCollection);
var
  CropIndex: Integer;
  EfficienciesItem: TFarmEfficienciesItem;
  StartTimes: System.Generics.Collections.TList<Double>;
  EndTimes: System.Generics.Collections.TList<Double>;
  Rows: TGenericIntegerList;
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
  StartTime: Double;
  EndTime: Double;
  CropEfficiency: TCropEfficiencyCollection;
  ColIndex: Integer;
  ARow: Integer;
  EfficiencyItem: TCropEfficiencyItem;
begin
  for CropIndex := EfficiencyCollection.Count to IrrigationTypes.Count - 1 do
  begin
    EfficienciesItem := EfficiencyCollection.Add;
    EfficienciesItem.CropEfficiency.CropName := IrrigationTypes[CropIndex].Name;
  end;
  while EfficiencyCollection.Count > IrrigationTypes.Count do
  begin
    EfficiencyCollection.Last.Free;
  end;
  StartTimes := TList<Double>.Create;
  EndTimes := TList<Double>.Create;
  Rows := TGenericIntegerList.Create;
  try
    Grid := AFrame.Grid;
    for RowIndex := 1 to AFrame.seNumber.AsInteger do
    begin
      if TryStrToFloat(Grid.Cells[Ord(ccStartTime), RowIndex+PestRowOffset], StartTime)
        and TryStrToFloat(Grid.Cells[Ord(ccEndTime), RowIndex+PestRowOffset], EndTime) then
      begin
        Rows.Add(RowIndex+PestRowOffset);
        StartTimes.Add(StartTime);
        EndTimes.Add(EndTime);
      end;
    end;
    for CropIndex := 0 to EfficiencyCollection.Count - 1 do
    begin
      EfficienciesItem := EfficiencyCollection[CropIndex];
      CropEfficiency := EfficienciesItem.CropEfficiency;
      while CropEfficiency.Count > Rows.Count do
      begin
        CropEfficiency.Last.Free;
      end;
      while CropEfficiency.Count < Rows.Count do
      begin
        CropEfficiency.Add;
      end;
      ColIndex := CropIndex + Ord(ccCrop);
      for RowIndex := 0 to Rows.Count - 1 do
      begin
        ARow := Rows[RowIndex];
        EfficiencyItem := CropEfficiency[RowIndex];
        EfficiencyItem.StartTime := StartTimes[RowIndex];
        EfficiencyItem.EndTime := EndTimes[RowIndex];
        EfficiencyItem.Efficiency := Grid.Cells[ColIndex, ARow];
      end;
    end;
  finally
    StartTimes.Free;
    EndTimes.Free;
    Rows.Free;
  end;

  for CropIndex := 0 to EfficiencyCollection.Count - 1 do
  begin
    EfficienciesItem := EfficiencyCollection[CropIndex];
    CropEfficiency := EfficienciesItem.CropEfficiency;
    ColIndex := CropIndex + Ord(ccCrop);
    if AFrame.PestMethodAssigned[ColIndex] then
    begin
      CropEfficiency.PestParamMethod := AFrame.PestMethod[ColIndex];
    end;
    if AFrame.PestModifierAssigned[ColIndex] then
    begin
      CropEfficiency.PestSeriesParameter := AFrame.PestModifier[ColIndex];
    end;
  end;

end;

procedure TframeFarm.SetBareRunoffFractions(Farm: TFarm);
var
  AFrame: TframeFormulaGrid;
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
  StartTimes: TList<Double>;
  EndTimes: TList<Double>;
  Rows: TGenericIntegerList;
  OwhmItem: TOwhmItem;
  StartTime: double;
  EndTime: double;
  ARow: Integer;
begin
  AFrame := frameBareRunoffFractions;
  Grid := AFrame.Grid;
  StartTimes := TList<Double>.Create;
  EndTimes := TList<Double>.Create;
  Rows := TGenericIntegerList.Create;
  try
    for RowIndex := 1 to AFrame.seNumber.AsInteger do
    begin
      if TryStrToFloat(Grid.Cells[Ord(brfcStartTime), RowIndex+PestRowOffset], StartTime)
        and TryStrToFloat(Grid.Cells[Ord(brfcEndTime), RowIndex+PestRowOffset], EndTime) then
      begin
        Rows.Add(RowIndex+PestRowOffset);
        StartTimes.Add(StartTime);
        EndTimes.Add(EndTime);
      end;
    end;
    for RowIndex := 0 to Rows.Count - 1 do
    begin
      ARow := Rows[RowIndex];
      if RowIndex < Farm.BareRunoffFraction.Count then
      begin
        OwhmItem := Farm.BareRunoffFraction[RowIndex];
      end
      else
      begin
        OwhmItem := Farm.BareRunoffFraction.Add as TOwhmItem;
      end;
      OwhmItem.OwhmValue := Grid.Cells[Ord(brfcValue),ARow];
      OwhmItem.StartTime := StartTimes[RowIndex];
      OwhmItem.EndTime := EndTimes[RowIndex];
    end;
    while Farm.BareRunoffFraction.Count > StartTimes.Count do
    begin
      Farm.BareRunoffFraction.Last.Free;
    end;
  finally
    Rows.Free;
    StartTimes.Free;
    EndTimes.Free;
  end;

  if AFrame.PestMethodAssigned[Ord(brfcValue)] then
  begin
    Farm.BareRunoffFraction.PestParamMethod := AFrame.PestMethod[Ord(brfcValue)];
  end;
  if AFrame.PestModifierAssigned[Ord(brfcValue)] then
  begin
    Farm.BareRunoffFraction.PestSeriesParameter := AFrame.PestModifier[Ord(brfcValue)];
  end;

end;

procedure TframeFarm.SetWaterRights(Farm: TFarm);
var
  Grid: TRbwDataGrid4;
  WaterRightsItem: TWaterRightsItem;
  WaterRights: TWaterRightsCollection;
  StartTime: Double;
  Count: Integer;
  RowIndex: Integer;
  EndTime: Double;
begin
  WaterRights := Farm.WaterRights;
  Grid := frameFormulaGridWaterRights.Grid;
  Count := 0;
  for RowIndex := 1 to frameFormulaGridWaterRights.seNumber.AsInteger do
  begin
    if TryStrToFloat(Grid.Cells[Ord(wrccStartTime), RowIndex], StartTime) and TryStrToFloat(Grid.Cells[Ord(wrccEndTime), RowIndex], EndTime) then
    begin
      if Count < WaterRights.Count then
      begin
        WaterRightsItem := WaterRights[Count];
      end
      else
      begin
        WaterRightsItem := WaterRights.Add;
      end;
      Inc(Count);
      WaterRightsItem.StartTime := StartTime;
      WaterRightsItem.EndTime := EndTime;
      WaterRightsItem.WaterRights := Grid.Cells[Ord(wrccCall), RowIndex];
    end;
  end;
  while WaterRights.Count > Count do
  begin
    WaterRights.Last.Free;
  end;
end;

procedure TframeFarm.SetWaterSource(Farm: TFarm);
var
  AFrame: TframeFormulaGrid;
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
  StartTimes: TList<Double>;
  EndTimes: TList<Double>;
  Rows: TGenericIntegerList;
  StartTime: double;
  EndTime: double;
  ARow: Integer;
  WaterSourceItem: TWaterSourceItem;
begin
  AFrame := frameWaterSource;
  Grid := AFrame.Grid;
  StartTimes := TList<Double>.Create;
  EndTimes := TList<Double>.Create;
  Rows := TGenericIntegerList.Create;
  try
    for RowIndex := 1 to AFrame.seNumber.AsInteger do
    begin
      if TryStrToFloat(Grid.Cells[Ord(ccStartTime), RowIndex], StartTime)
        and TryStrToFloat(Grid.Cells[Ord(ccEndTime), RowIndex], EndTime) then
      begin
        Rows.Add(RowIndex);
        StartTimes.Add(StartTime);
        EndTimes.Add(EndTime);
      end;
    end;
    for RowIndex := 0 to Rows.Count - 1 do
    begin
      ARow := Rows[RowIndex];
      if RowIndex < Farm.WaterSource.Count then
      begin
        WaterSourceItem := Farm.WaterSource[RowIndex];
      end
      else
      begin
        WaterSourceItem := Farm.WaterSource.Add as TWaterSourceItem;
      end;
      WaterSourceItem.StartTime := StartTimes[RowIndex];
      WaterSourceItem.EndTime := EndTimes[RowIndex];
      WaterSourceItem.Groundwater := Grid.Cells[Ord(wscGroundwater), ARow];
      WaterSourceItem.SurfaceWater := Grid.Cells[Ord(wscSurfaceWater), ARow];
      WaterSourceItem.NonRoutedDelivery := Grid.Cells[Ord(wscNonRouted), ARow];
    end;
    while Farm.WaterSource.Count > StartTimes.Count do
    begin
      Farm.WaterSource.Last.Free;
    end;
  finally
    Rows.Free;
    StartTimes.Free;
    EndTimes.Free;
  end;
end;

procedure TframeFarm.SetFarmCosts(Farm: TFarm);
var
  EndTime: Double;
  Grid: TRbwDataGrid4;
  FarmCosts: TFarmCostsCollection;
  CostItem: TFarmCostsItem;
  RowIndex: Integer;
  Count: Integer;
  StartTime: Double;
begin
  FarmCosts := Farm.FarmCostsCollection;
  Grid := frameFormulaGridCosts.Grid;
  Count := 0;
  for RowIndex := 1 to frameFormulaGridCosts.seNumber.AsInteger do
  begin
    if TryStrToFloat(Grid.Cells[Ord(wccStartTime), RowIndex], StartTime)
      and TryStrToFloat(Grid.Cells[Ord(wccEndTime), RowIndex], EndTime) then
    begin
      if Count < FarmCosts.Count then
      begin
        CostItem := FarmCosts[Count];
      end
      else
      begin
        CostItem := FarmCosts.Add;
      end;
      Inc(Count);
      CostItem.StartTime := StartTime;
      CostItem.EndTime := EndTime;
      CostItem.GWcost1 := Grid.Cells[Ord(wccGWCost1), RowIndex];
      CostItem.GWcost2 := Grid.Cells[Ord(wccGWCost2), RowIndex];
      CostItem.GWcost3 := Grid.Cells[Ord(wccGWCost3), RowIndex];
      CostItem.GWcost4 := Grid.Cells[Ord(wccGWCost4), RowIndex];
      CostItem.SWcost1 := Grid.Cells[Ord(wccSWCost1), RowIndex];
      CostItem.SWcost2 := Grid.Cells[Ord(wccSWCost2), RowIndex];
      CostItem.SWcost3 := Grid.Cells[Ord(wccSWCost3), RowIndex];
      CostItem.SWcost4 := Grid.Cells[Ord(wccSWCost4), RowIndex];
    end;
  end;
  while FarmCosts.Count > Count do
  begin
    FarmCosts.Last.Free;
  end;
end;

procedure TframeFarm.SetGwAllotment(Farm: TFarm);
var
  GwAllotment: TAllotmentCollection;
  Grid: TRbwDataGrid4;
  Count: Integer;
  RowIndex: Integer;
  StartTime: double;
  EndTime: double;
  AllotmentItem: TAllotmentItem;
begin
  GwAllotment := Farm.GwAllotment;
  Grid := frameGW_Allocation.Grid;
  Count := 0;
  for RowIndex := 1 to frameGW_Allocation.seNumber.AsInteger do
  begin
    if TryStrToFloat(Grid.Cells[Ord(gacStartTime), RowIndex+PestRowOffset], StartTime)
      and TryStrToFloat(Grid.Cells[Ord(gacEndTime), RowIndex+PestRowOffset], EndTime) then
    begin
      if Count < GwAllotment.Count then
      begin
        AllotmentItem := GwAllotment[Count];
      end
      else
      begin
        AllotmentItem := GwAllotment.Add;
      end;
      Inc(Count);
      AllotmentItem.StartTime := StartTime;
      AllotmentItem.EndTime := EndTime;
      AllotmentItem.Allotment := Grid.Cells[Ord(gacAllotment), RowIndex+PestRowOffset];
    end;
  end;
  while GwAllotment.Count > Count do
  begin
    GwAllotment.Last.Free;
  end;

  if frameGW_Allocation.PestMethodAssigned[Ord(gacAllotment)] then
  begin
    GwAllotment.PestParamMethod := frameGW_Allocation.PestMethod[Ord(gacAllotment)];
  end;
  if frameGW_Allocation.PestModifierAssigned[Ord(gacAllotment)] then
  begin
    GwAllotment.PestSeriesParameter := frameGW_Allocation.PestModifier[Ord(gacAllotment)];
  end;
end;

procedure TframeFarm.SetIrrigationUniformity(Farm: TFarm;
  IrrigationTypes: TIrrigationCollection);
begin
  SetAnEfficiencyCollection(Farm.IrrigationUniformity,
    frameIrrigationUniformity, IrrigationTypes);
end;

procedure TframeFarm.SetNoReturnFlow(Farm: TFarm);
var
  Grid: TRbwDataGrid4;
  StartTime: Double;
  EndTime: Double;
  ItemCount: Integer;
  Item: TNoReturnItem;
  RowIndex: Integer;
begin
  Grid := frameNoReturnFlow.Grid;
  for RowIndex := 1 to frameNoReturnFlow.Grid.RowCount - 1 do
  begin
    ItemCount := 0;
    if TryStrToFloat(Grid.Cells[Ord(nrfcStartTime), RowIndex], StartTime)
      and TryStrToFloat(Grid.Cells[Ord(nrfcEndTime), RowIndex], EndTime)
      and (Grid.ItemIndex[Ord(nrfcValue), RowIndex] >= 0) then
    begin
      if ItemCount < Farm.NoReturnFlow.Count then
      begin
        Item := Farm.NoReturnFlow[ItemCount] as TNoReturnItem;
      end
      else
      begin
        Item := Farm.NoReturnFlow.Add as TNoReturnItem;
      end;
      Item.StartTime := StartTime;
      Item.EndTime := EndTime;
      Item.NoReturnOption := TNoReturnOption(Grid.ItemIndex[Ord(nrfcValue), RowIndex]);
      Inc(ItemCount);
    end;
    Farm.NoReturnFlow.Count := ItemCount;
  end;
end;

procedure TframeFarm.SetSaltSupplyConcentration(Farm: TFarm);
var
  SaltSupplyConcentrationCollection: TSaltSupplyConcentrationCollection;
  Grid: TRbwDataGrid4;
  Count: Integer;
  RowIndex: Integer;
  StartTime: double;
  EndTime: double;
  SupplyItem: TSaltSupplyConcentrationItem;
begin
  SaltSupplyConcentrationCollection := Farm.SaltSupplyConcentrationCollection;
  Grid := frameWaterSupplyConcentration.Grid;
  Count := 0;
  for RowIndex := 1 to frameWaterSupplyConcentration.seNumber.AsInteger do
  begin

    if TryStrToFloat(Grid.Cells[Ord(sccStartTime), RowIndex+PestRowOffset], StartTime)
      and TryStrToFloat(Grid.Cells[Ord(sccEndTime), RowIndex+PestRowOffset], EndTime) then
    begin
      if Count < SaltSupplyConcentrationCollection.Count then
      begin
        SupplyItem := SaltSupplyConcentrationCollection[Count] as TSaltSupplyConcentrationItem;
      end
      else
      begin
        SupplyItem := SaltSupplyConcentrationCollection.Add as TSaltSupplyConcentrationItem;
      end;
      Inc(Count);
      SupplyItem.StartTime := StartTime;
      SupplyItem.EndTime := EndTime;
      SupplyItem.NonRoutedConcentration := Grid.Cells[Ord(sccNonRouted), RowIndex+PestRowOffset];
      SupplyItem.SurfaceWaterConcentration := Grid.Cells[Ord(sccSurfaceWater), RowIndex+PestRowOffset];
      SupplyItem.GroundwaterConcentration := Grid.Cells[Ord(sccGroundWater), RowIndex+PestRowOffset];
      SupplyItem.ExternalConcentration := Grid.Cells[Ord(sccExternal), RowIndex+PestRowOffset];
    end;
  end;
  SaltSupplyConcentrationCollection.Count := Count;

  if frameWaterSupplyConcentration.PestMethodAssigned[Ord(sccNonRouted)] then
  begin
    SaltSupplyConcentrationCollection.PestParamMethod := frameWaterSupplyConcentration.PestMethod[Ord(sccNonRouted)];
  end;
  if frameWaterSupplyConcentration.PestModifierAssigned[Ord(sccNonRouted)] then
  begin
    SaltSupplyConcentrationCollection.PestSeriesParameter := frameWaterSupplyConcentration.PestModifier[Ord(sccNonRouted)];
  end;

  if frameWaterSupplyConcentration.PestMethodAssigned[Ord(sccSurfaceWater)] then
  begin
    SaltSupplyConcentrationCollection.SWConcPestParamMethod := frameWaterSupplyConcentration.PestMethod[Ord(sccSurfaceWater)];
  end;
  if frameWaterSupplyConcentration.PestModifierAssigned[Ord(sccSurfaceWater)] then
  begin
    SaltSupplyConcentrationCollection.SWConcPestSeriesParameter := frameWaterSupplyConcentration.PestModifier[Ord(sccSurfaceWater)];
  end;

  if frameWaterSupplyConcentration.PestMethodAssigned[Ord(sccGroundWater)] then
  begin
    SaltSupplyConcentrationCollection.GWConcPestParamMethod := frameWaterSupplyConcentration.PestMethod[Ord(sccGroundWater)];
  end;
  if frameWaterSupplyConcentration.PestModifierAssigned[Ord(sccGroundWater)] then
  begin
    SaltSupplyConcentrationCollection.GWConcPestSeriesParameter := frameWaterSupplyConcentration.PestModifier[Ord(sccGroundWater)];
  end;

  if frameWaterSupplyConcentration.PestMethodAssigned[Ord(sccExternal)] then
  begin
    SaltSupplyConcentrationCollection.ExtConcPestParamMethod := frameWaterSupplyConcentration.PestMethod[Ord(sccExternal)];
  end;
  if frameWaterSupplyConcentration.PestModifierAssigned[Ord(sccExternal)] then
  begin
    SaltSupplyConcentrationCollection.ExtConcPestSeriesParameter := frameWaterSupplyConcentration.PestModifier[Ord(sccExternal)];
  end;

end;

procedure TframeFarm.SetSwAllotment(Farm: TFarm);
var
  Allotment: TAllotmentCollection;
  Grid: TRbwDataGrid4;
  Count: Integer;
  RowIndex: Integer;
  StartTime: double;
  EndTime: double;
  AllotmentItem: TAllotmentItem;
begin
  Allotment := Farm.SWAllotment;
  Grid := frameSwAllotment.Grid;
  Count := 0;
  for RowIndex := 1 to frameSwAllotment.seNumber.AsInteger do
  begin
    if TryStrToFloat(Grid.Cells[Ord(gacStartTime), RowIndex+PestRowOffset], StartTime)
      and TryStrToFloat(Grid.Cells[Ord(gacEndTime), RowIndex+PestRowOffset], EndTime) then
    begin
      if Count < Allotment.Count then
      begin
        AllotmentItem := Allotment[Count];
      end
      else
      begin
        AllotmentItem := Allotment.Add;
      end;
      Inc(Count);
      AllotmentItem.StartTime := StartTime;
      AllotmentItem.EndTime := EndTime;
      AllotmentItem.Allotment := Grid.Cells[Ord(gacAllotment), RowIndex+PestRowOffset];
    end;
  end;
  while Allotment.Count > Count do
  begin
    Allotment.Last.Free;
  end;

  if frameSwAllotment.PestMethodAssigned[Ord(gacAllotment)] then
  begin
    Allotment.PestParamMethod := frameSwAllotment.PestMethod[Ord(gacAllotment)];
  end;
  if frameSwAllotment.PestModifierAssigned[Ord(gacAllotment)] then
  begin
    Allotment.PestSeriesParameter := frameSwAllotment.PestModifier[Ord(gacAllotment)];
  end;

end;

procedure TframeFarm.SetCropEfficiencies(Farm: TFarm; Crops: TCropCollection;
  IrrigationTypes: TIrrigationCollection);
var
  EndTime: Double;
  EfficienciesItem: TFarmEfficienciesItem;
  ColIndex: Integer;
  StartTime: Double;
  Grid: TRbwDataGrid4;
  EfficiencyItem: TCropEfficiencyItem;
  Rows: TGenericIntegerList;
  EfficiencyCollection: TFarmEfficiencyCollection;
  CropEfficiency: TCropEfficiencyCollection;
  StartTimes: Generics.Collections.TList<Double>;
  CropIndex: Integer;
  EndTimes: Generics.Collections.TList<Double>;
  RowIndex: Integer;
  ARow: Integer;
begin
  EfficiencyCollection := Farm.CurrentFarmEfficiencyCollection;

  if frmGoPhast.ModelSelection = msModflowFmp then
  begin
    for CropIndex := EfficiencyCollection.Count to Crops.Count - 1 do
    begin
      EfficienciesItem := EfficiencyCollection.Add;
      EfficienciesItem.CropEfficiency.CropName := Crops[CropIndex].CropName;
    end;
    while EfficiencyCollection.Count > Crops.Count do
    begin
      EfficiencyCollection.Last.Free;
    end;
  end
  else
  begin
    for CropIndex := EfficiencyCollection.Count to IrrigationTypes.Count - 1 do
    begin
      EfficienciesItem := EfficiencyCollection.Add;
      EfficienciesItem.CropEfficiency.CropName := IrrigationTypes[CropIndex].Name;
    end;
    while EfficiencyCollection.Count > IrrigationTypes.Count do
    begin
      EfficiencyCollection.Last.Free;
    end;
  end;
  StartTimes := TList<Double>.Create;
  EndTimes := TList<Double>.Create;
  Rows := TGenericIntegerList.Create;
  try
    Grid := frameFormulaGridCrops.Grid;
    for RowIndex := 1 to frameFormulaGridCrops.seNumber.AsInteger do
    begin
      if TryStrToFloat(Grid.Cells[Ord(ccStartTime), RowIndex+PestRowOffset], StartTime)
        and TryStrToFloat(Grid.Cells[Ord(ccEndTime), RowIndex+PestRowOffset], EndTime) then
      begin
        Rows.Add(RowIndex+PestRowOffset);
        StartTimes.Add(StartTime);
        EndTimes.Add(EndTime);
      end;
    end;
    for CropIndex := 0 to EfficiencyCollection.Count - 1 do
    begin
      EfficienciesItem := EfficiencyCollection[CropIndex];
      CropEfficiency := EfficienciesItem.CropEfficiency;
      while CropEfficiency.Count > Rows.Count do
      begin
        CropEfficiency.Last.Free;
      end;
      while CropEfficiency.Count < Rows.Count do
      begin
        CropEfficiency.Add;
      end;
      ColIndex := CropIndex + Ord(ccCrop);
      for RowIndex := 0 to Rows.Count - 1 do
      begin
        ARow := Rows[RowIndex];
        EfficiencyItem := CropEfficiency[RowIndex];
        EfficiencyItem.StartTime := StartTimes[RowIndex];
        EfficiencyItem.EndTime := EndTimes[RowIndex];
        EfficiencyItem.Efficiency := Grid.Cells[ColIndex, ARow];
      end;
    end;
  finally
    StartTimes.Free;
    EndTimes.Free;
    Rows.Free;
  end;

  for CropIndex := 0 to EfficiencyCollection.Count - 1 do
  begin
    EfficienciesItem := EfficiencyCollection[CropIndex];
    CropEfficiency := EfficienciesItem.CropEfficiency;
    ColIndex := CropIndex + Ord(ccCrop);
    if frameFormulaGridCrops.PestMethodAssigned[ColIndex] then
    begin
      CropEfficiency.PestParamMethod := frameFormulaGridCrops.PestMethod[ColIndex];
    end;
    if frameFormulaGridCrops.PestModifierAssigned[ColIndex] then
    begin
      CropEfficiency.PestSeriesParameter := frameFormulaGridCrops.PestModifier[ColIndex];
    end;
  end;
end;

procedure TframeFarm.SetCropEfficiencyImprove(Farm: TFarm;
  IrrigationTypes: TIrrigationCollection);
begin
  SetAnEfficiencyCollection(Farm.FarmIrrigationEfficiencyImprovementCollection,
    frameFormulaGridEfficiencyImprovement, IrrigationTypes);
end;

procedure TframeFarm.GetMaxTimeAndCountForCrops(
  var MaxIndex: Integer; var MaxTimeCount: Integer; AFarm: TFarm);
var
  AFrame: TframeFormulaGrid;
  EffCollection: TFarmEfficiencyCollection;
begin
  AFrame := frameFormulaGridCrops;
  EffCollection := AFarm.CurrentFarmEfficiencyCollection;
  GetMaxTimeAndCountForEfficiencyCollection(AFrame, EffCollection,
    MaxTimeCount, MaxIndex);
end;

end.
