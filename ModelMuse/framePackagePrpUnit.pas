unit framePackagePrpUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, framePackageUnit, RbwController,
  Vcl.StdCtrls, ArgusDataEntry, frameOptionalValueUnit, ModflowPackageSelectionUnit,
  JvExStdCtrls, JvCombobox, JvListComb, Vcl.Mask, Vcl.ExtCtrls, frameGridUnit,
  Vcl.ComCtrls;

type
  TframePackagePrp = class(TframePackage)
    cbEXTEND_TRACKING: TCheckBox;
    comboTrackOutput: TComboBox;
    frameStopTime: TframeOptionalValue;
    lblTrackOutput: TLabel;
    frameStopTravelTime: TframeOptionalValue;
    cbSTOP_AT_WEAK_SINK: TCheckBox;
    cbDRAPE: TCheckBox;
    comboDryTrackingMethod: TJvImageComboBox;
    lblDRY_TRACKING_METHOD: TLabel;
    frameRELEASE_TIME_TOLERANCE: TframeOptionalValue;
    frameEXIT_SOLVE_TOLERANCE: TframeOptionalValue;
    frameRELEASE_TIME_FREQUENCY: TframeOptionalValue;
    lblCOORDINATE_CHECK_METHOD: TLabel;
    comboCOORDINATE_CHECK_METHOD: TJvImageComboBox;
    lblISTOPZONE: TLabel;
    rdeISTOPZONE: TRbwDataEntry;
    lbledtPackageName: TLabeledEdit;
    pgcPRP: TPageControl;
    tabOptions: TTabSheet;
    tabReleaseTimes: TTabSheet;
    frameReleaseTimes: TframeGrid;
    pnlReleaseTimes: TPanel;
    lblReleaseTimes: TLabel;
    tabReleasePeriodData: TTabSheet;
    frameReleasePeriodData: TframeGrid;
    pnlReleasePeriodData: TPanel;
    lblReleasePeriodData: TLabel;
    procedure frameReleasePeriodDataseNumberChange(Sender: TObject);
    procedure frameReleaseTimesseNumberChange(Sender: TObject);
    procedure frameStopTimecbUsedClick(Sender: TObject);
    procedure frameStopTimeRdeValueChange(Sender: TObject);
  private
    procedure InitializeGrids;
    { Private declarations }
  public
    procedure GetData(Package: TModflowPackageSelection); override;
    procedure SetData(Package: TModflowPackageSelection); override;
  end;

var
  framePackagePrp: TframePackagePrp;

implementation

uses
  frmCustomGoPhastUnit, frmGoPhastUnit, GoPhastTypes;

{$R *.dfm}

resourcestring
  SReleaseTimes = 'Release times';
  SSteps = 'Steps';
  SStepFrequency = 'Step frequency';
  SLastSteps = 'Last steps';
  SFirstSteps = 'First steps';
  SAllSteps = 'All steps';

type
  TPeriodDataColumns = (pdcStartTime, pdcEndTime, pdcAll, pdcFirst, pdcLast,
  pdcFrequency, pdcSteps);

procedure TframePackagePrp.frameReleasePeriodDataseNumberChange(Sender:
    TObject);
begin
  inherited;
  frameReleasePeriodData.seNumberChange(Sender);
end;

procedure TframePackagePrp.frameReleaseTimesseNumberChange(Sender: TObject);
begin
  inherited;
  frameReleaseTimes.seNumberChange(Sender);
end;

procedure TframePackagePrp.frameStopTimecbUsedClick(Sender: TObject);
begin
  inherited;
  frameStopTime.cbUsedClick(Sender);
end;

procedure TframePackagePrp.frameStopTimeRdeValueChange(Sender: TObject);
begin
  inherited;
end;

{ TframePackagePrp }

procedure TframePackagePrp.GetData(Package: TModflowPackageSelection);
var
  PrpPackage: TPrpPackage;
  Steps: TStringList;
begin
  inherited;
  InitializeGrids;

  PrpPackage := Package as TPrpPackage;

  lbledtPackageName.Text := PrpPackage.PackageName;

  frameEXIT_SOLVE_TOLERANCE.RdeValue.RealValue := PrpPackage.SolverTolerance;
  frameEXIT_SOLVE_TOLERANCE.cbUsed.Checked := PrpPackage.SolverToleranceUsed;

  cbEXTEND_TRACKING.Checked := PrpPackage.ExtendTracking;

  comboTrackOutput.ItemIndex := Ord(PrpPackage.PrtTrackingOutput);

  frameStopTime.cbUsed.Checked := PrpPackage.StopTimeUsed;
  frameStopTime.RdeValue.RealValue := PrpPackage.StopTime;

  frameStopTravelTime.cbUsed.Checked := PrpPackage.StopTravelTimeUsed;
  frameStopTravelTime.RdeValue.RealValue := PrpPackage.StopTravelTime;

  cbSTOP_AT_WEAK_SINK.Checked := PrpPackage.StopAtWeakSinks;

  cbDRAPE.Checked := PrpPackage.Drape;

  rdeISTOPZONE.IntegerValue := PrpPackage.StopZone;

  frameRELEASE_TIME_TOLERANCE.cbUsed.Checked := PrpPackage.ReleaseTimeToleranceUsed;
  frameRELEASE_TIME_TOLERANCE.RdeValue.RealValue := PrpPackage.ReleaseTimeTolerance;

  frameRELEASE_TIME_FREQUENCY.cbUsed.Checked := PrpPackage.ReleaseTimeToleranceUsed;
  frameRELEASE_TIME_FREQUENCY.RdeValue.RealValue := PrpPackage.ReleaseTimeTolerance;

  comboDryTrackingMethod.ItemIndex := Ord(PrpPackage.DryTrackingMethod);

  comboCOORDINATE_CHECK_METHOD.ItemIndex := Ord(PrpPackage.CoordinateCheckMethod);

  frameReleaseTimes.Grid.BeginUpdate;
  try
   frmGoPhast.PhastModel.ModflowStressPeriods.FillPickListWithStartTimes(frameReleaseTimes.Grid, 0);
   frameReleaseTimes.seNumber.Value := PrpPackage.ReleaseTimes.Count;
   frameReleaseTimesseNumberChange(nil);
   for var Index := 0 to PrpPackage.ReleaseTimes.Count - 1 do
   begin
     frameReleaseTimes.Grid.RealValue[0, Index+1] := PrpPackage.ReleaseTimes[Index].Value;
   end;
  finally
   frameReleaseTimes.Grid.EndUpdate;
  end;

  frameReleasePeriodData.Grid.BeginUpdate;
  try
   frmGoPhast.PhastModel.ModflowStressPeriods.FillPickListWithStartTimes(frameReleasePeriodData.Grid, Ord(pdcStartTime));
   frmGoPhast.PhastModel.ModflowStressPeriods.FillPickListWithEndTimes(frameReleasePeriodData.Grid, Ord(pdcEndTime));
   frameReleasePeriodData.seNumber.Value := PrpPackage.PeriodData.Count;
   frameReleasePeriodDataseNumberChange(nil);
   for var Index := 0 to PrpPackage.PeriodData.Count - 1 do
   begin
     frameReleasePeriodData.Grid.RealValue[Ord(pdcStartTime), Index+1] := PrpPackage.PeriodData[Index].StartTime;
     frameReleasePeriodData.Grid.RealValue[Ord(pdcEndTime), Index+1] := PrpPackage.PeriodData[Index].EndTime;
     frameReleasePeriodData.Grid.Checked[Ord(pdcAll), Index+1] := PrpPackage.PeriodData[Index].All;
     frameReleasePeriodData.Grid.Checked[Ord(pdcFirst), Index+1] := PrpPackage.PeriodData[Index].First;
     frameReleasePeriodData.Grid.Checked[Ord(pdcLast), Index+1] := PrpPackage.PeriodData[Index].Last;
     frameReleasePeriodData.Grid.IntegerValue[Ord(pdcFrequency), Index+1] := PrpPackage.PeriodData[Index].Frequency;
     frameReleasePeriodData.Grid.RealValue[Ord(pdcStartTime), Index+1] := PrpPackage.PeriodData[Index].StartTime;
     Steps := TStringList.Create;
     try
       for var StepIndex := 0 to PrpPackage.PeriodData[Index].Steps.Count - 1 do
       begin
         Steps.Add(PrpPackage.PeriodData[Index].Steps[StepIndex].ToString);
       end;
       frameReleasePeriodData.Grid.Cells[Ord(pdcSteps), Index+1] := Steps.CommaText;
     finally
       Steps.Free;
     end;

   end;

   //   TPeriodDataColumns = (pdcStartTime, pdcEndTime, pdcAll, pdcFirst, pdcLast,
  //  pdcFrequency, pdcSteps);


  finally
   frameReleasePeriodData.Grid.EndUpdate;
  end;
end;

procedure TframePackagePrp.InitializeGrids;
begin
  pgcPRP.ActivePageIndex := 0;

  frameReleasePeriodData.Grid.BeginUpdate;
  try
    ClearGrid(frameReleasePeriodData.Grid);
    frameReleasePeriodData.Grid.Cells[Ord(pdcStartTime), 0] := StrStartingTime;
    frameReleasePeriodData.Grid.Cells[Ord(pdcEndTime), 0] := StrEndingTime;
    frameReleasePeriodData.Grid.Cells[Ord(pdcAll), 0] := SAllSteps;
    frameReleasePeriodData.Grid.Cells[Ord(pdcFirst), 0] := SFirstSteps;
    frameReleasePeriodData.Grid.Cells[Ord(pdcLast), 0] := SLastSteps;
    frameReleasePeriodData.Grid.Cells[Ord(pdcFrequency), 0] := SStepFrequency;
    frameReleasePeriodData.Grid.Cells[Ord(pdcSteps), 0] := SSteps;
  finally
    frameReleasePeriodData.Grid.EndUpdate;
  end;

  frameReleaseTimes.Grid.BeginUpdate;
  try
    ClearGrid(frameReleaseTimes.Grid);
    frameReleaseTimes.Grid.Cells[0,0] := SReleaseTimes;
  finally
    frameReleaseTimes.Grid.EndUpdate;
  end;
end;

procedure TframePackagePrp.SetData(Package: TModflowPackageSelection);
var
  PrpPackage: TPrpPackage;
  AnInt: Integer;
  StepCount: Integer;
  Steps: TStringList;
  PrpSteps: TGenericIntegerList;
  PeriodCount: Integer;
  StartTime: Double;
  EndTime: Double;
begin
  inherited;
  PrpPackage := Package as TPrpPackage;

  PrpPackage.PackageName := lbledtPackageName.Text;

  PrpPackage.SolverTolerance := frameEXIT_SOLVE_TOLERANCE.RdeValue.RealValue;
  PrpPackage.SolverToleranceUsed := frameEXIT_SOLVE_TOLERANCE.cbUsed.Checked;

  PrpPackage.ExtendTracking := cbEXTEND_TRACKING.Checked;

  PrpPackage.PrtTrackingOutput := TPrtTrackingOutput(comboTrackOutput.ItemIndex);

  PrpPackage.StopTimeUsed := frameStopTime.cbUsed.Checked;
  PrpPackage.StopTime := frameStopTime.RdeValue.RealValue;

  PrpPackage.StopTravelTimeUsed := frameStopTravelTime.cbUsed.Checked;
  PrpPackage.StopTravelTime := frameStopTravelTime.RdeValue.RealValue;

  PrpPackage.StopAtWeakSinks := cbSTOP_AT_WEAK_SINK.Checked;

  PrpPackage.Drape := cbDRAPE.Checked;

  PrpPackage.StopZone := rdeISTOPZONE.IntegerValue;

  PrpPackage.ReleaseTimeToleranceUsed := frameRELEASE_TIME_TOLERANCE.cbUsed.Checked;
  PrpPackage.ReleaseTimeTolerance := frameRELEASE_TIME_TOLERANCE.RdeValue.RealValue;

  PrpPackage.ReleaseTimeToleranceUsed := frameRELEASE_TIME_FREQUENCY.cbUsed.Checked;
  PrpPackage.ReleaseTimeTolerance := frameRELEASE_TIME_FREQUENCY.RdeValue.RealValue;

  PrpPackage.DryTrackingMethod := TPrtDryTracking(comboDryTrackingMethod.ItemIndex);

  PrpPackage.CoordinateCheckMethod := TPrtCoordinateCheckMethod(comboCOORDINATE_CHECK_METHOD.ItemIndex);

  PrpPackage.ReleaseTimes.Count := frameReleaseTimes.seNumber.AsInteger;
  for var Index := 0 to PrpPackage.ReleaseTimes.Count - 1 do
  begin
    PrpPackage.ReleaseTimes[Index].Value := frameReleaseTimes.Grid.RealValueDefault[0, Index+1, 0];
  end;

  PeriodCount := 0;
  PrpPackage.PeriodData.Count := frameReleasePeriodData.seNumber.AsInteger;
  for var Index := 0 to PrpPackage.PeriodData.Count - 1 do
  begin
    if TryStrToFloat(frameReleasePeriodData.Grid.Cells[Ord(pdcStartTime), Index+1], StartTime)
      and TryStrToFloat(frameReleasePeriodData.Grid.Cells[Ord(pdcEndTime), Index+1], EndTime) then
    begin
      Inc(PeriodCount);
      PrpPackage.PeriodData[Index].StartTime := StartTime;
      PrpPackage.PeriodData[Index].EndTime := EndTime;
      PrpPackage.PeriodData[Index].All := frameReleasePeriodData.Grid.Checked[Ord(pdcAll), Index+1];
      PrpPackage.PeriodData[Index].First := frameReleasePeriodData.Grid.Checked[Ord(pdcFirst), Index+1];
      PrpPackage.PeriodData[Index].Last := frameReleasePeriodData.Grid.Checked[Ord(pdcLast), Index+1];
      PrpPackage.PeriodData[Index].Frequency := frameReleasePeriodData.Grid.IntegerValueDefault[Ord(pdcFrequency), Index+1, -1];
      PrpPackage.PeriodData[Index].StartTime := frameReleasePeriodData.Grid.RealValueDefault[Ord(pdcStartTime), Index+1, 0];
      Steps := TStringList.Create;
      try
        Steps.CommaText := frameReleasePeriodData.Grid.Cells[Ord(pdcSteps), Index+1];
        PrpSteps := PrpPackage.PeriodData[Index].Steps;
        StepCount := 0;
        PrpSteps.Capacity := Steps.Count;
        for var StepIndex := 0 to Steps.Count - 1 do
        begin
          if TryStrToInt(Steps[StepIndex], AnInt) then
          begin
            if StepCount < PrpSteps.Count then
            begin
               PrpSteps[StepCount] := AnInt;
            end
            else
            begin
              PrpSteps.Add(AnInt);
            end;
            Inc(StepCount);
          end;
        end;
        PrpSteps.Count := StepCount;
      finally
       Steps.Free;
      end;
    end;

  end;
  PrpPackage.PeriodData.Count := PeriodCount;

   //   TPeriodDataColumns = (pdcStartTime, pdcEndTime, pdcAll, pdcFirst, pdcLast,
  //  pdcFrequency, pdcSteps);



end;

end.
