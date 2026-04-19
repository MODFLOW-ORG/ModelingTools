unit framePrpPackagesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameGridUnit,
  ModflowPackageSelectionUnit, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst, JvExCheckLst, JvCheckListBox;

type
  // frame should be a @link(TframePackagePrp).
  TPrpPackagedDeletedEvent = procedure (Sender: TObject; frame: TFrame) of Object;

  TframePrpMultiplePackages = class(TFrame)
    framePrpPackages: TframeGrid;
    pcPrt: TPageControl;
    tabOptions: TTabSheet;
    tabPrpPackages: TTabSheet;
    tabTrackTimes: TTabSheet;
    frameTrackTimes: TframeGrid;
    tabTrackByStressPeriod: TTabSheet;
    pnlTrackPeriodData: TPanel;
    lblTrackPeriodData: TLabel;
    pnlTrackTime: TPanel;
    lblTrackTime: TLabel;
    frameReleasePeriodData: TframeGrid;
    grpMIP: TGroupBox;
    cbRetardationFactor: TCheckBox;
    cbUseParticleStopZones: TCheckBox;
    grpOutputControl: TGroupBox;
    chklstOutputFiles: TJvCheckListBox;
    lblOutputFiles: TLabel;
    chklstTrackEvents: TJvCheckListBox;
    lblTrackEvents: TLabel;
  private
    FOnPrpPackageDeleted: TPrpPackagedDeletedEvent;
    FOnPrpPackageAdded: TNotifyEvent;
    Procedure Initialize;
    { Private declarations }
  public
    procedure GetData(PrtModel: TPrtModel);
    procedure SetData(PrtModel: TPrtModel);
    property OnPrpPackageAdded: TNotifyEvent read FOnPrpPackageAdded write FOnPrpPackageAdded;
    property OnPrpPackageDeleted: TPrpPackagedDeletedEvent read FOnPrpPackageDeleted write FOnPrpPackageDeleted;
    { Public declarations }
  end;

implementation

uses
  frmCustomGoPhastUnit, GoPhastTypes;

resourcestring
  StrPackageName = 'Package Name';
  StrPackageUsed = 'Package Used';
  StrAllSteps = 'All steps';
  StrFirstSteps = 'First steps';
  StrLastSteps = 'Last steps';
  StrStepFrequency = 'Step frequency';
  StrSteps = 'Steps';
  StrTrackingTime = 'Tracking Time';

{$R *.dfm}

type
  TPrpColumns = (pcName, pcUsed);

type
  TPackagePeriodDataColumns = (ppdcStartTime, ppdcEndTime, ppdcAll, ppdcFirst, ppdcLast,
  ppdcFrequency, ppdcSteps);


{ TframePrpMultiplePackages }

procedure TframePrpMultiplePackages.GetData(PrtModel: TPrtModel);
var
  FileItem: TPrtOutputFile;
  TrackingOption: TPrtTrackingOption;
  PrpPackage: TPrpPackage;
  PeriodData: TPrpPeriodDataItem;
  StepList: TStringList;
begin
  Initialize;
  cbRetardationFactor.Checked := PrtModel.RetardationFactorUsed;
  cbUseParticleStopZones.Checked := PrtModel.ZoneUsed;

  for FileItem in PrtModel.PrtOutputFiles do
  begin
    chklstOutputFiles.Checked[Ord(FileItem)] := True;
  end;

  for TrackingOption in PrtModel.PrtTrackingOptions do
  begin
    chklstTrackEvents.Checked[Ord(TrackingOption)] := True;
  end;

  framePrpPackages.Grid.BeginUpdate;
  try
    framePrpPackages.seNumber.AsInteger := PrtModel.Count;
    for var Index := 0 to PrtModel.Count - 1 do
    begin
      PrpPackage := PrtModel[Index].PrpPackage;
      framePrpPackages.Grid.Cells[Ord(pcName), Index+1] := PrpPackage.PackageName;
      framePrpPackages.Grid.Checked[Ord(pcUsed), Index+1] := PrpPackage.isSelected;
    end;
  finally
    framePrpPackages.Grid.EndUpdate;
  end;

  frameTrackTimes.Grid.BeginUpdate;
  try
    frameTrackTimes.seNumber.AsInteger := PrtModel.TrackTimes.Count;
    for var Index := 0 to PrtModel.TrackTimes.Count - 1 do
    begin
      frameTrackTimes.Grid.RealValue[0, Index+1] := PrtModel.TrackTimes[Index].Value;
    end;
  finally
    frameTrackTimes.Grid.EndUpdate;
  end;

  frameReleasePeriodData.Grid.BeginUpdate;
  try
    frameReleasePeriodData.seNumber.AsInteger := PrtModel.PeriodData.Count;
    for var Index := 0 to PrtModel.PeriodData.Count - 1 do
    begin
      PeriodData := PrtModel.PeriodData[Index];
      frameReleasePeriodData.Grid.RealValue[Ord(ppdcStartTime), Index+1] := PeriodData.StartTime;
      frameReleasePeriodData.Grid.RealValue[Ord(ppdcEndTime), Index+1] := PeriodData.EndTime;
      frameReleasePeriodData.Grid.Checked[Ord(ppdcAll), Index+1] := PeriodData.All;
      frameReleasePeriodData.Grid.Checked[Ord(ppdcFirst), Index+1] := PeriodData.First;
      frameReleasePeriodData.Grid.Checked[Ord(ppdcLast), Index+1] := PeriodData.Last;
      frameReleasePeriodData.Grid.IntegerValue[Ord(ppdcFrequency), Index+1] := PeriodData.Frequency;
      StepList := TStringList.Create;
      try
        for var StepIndex := 0 to PeriodData.Steps.Count - 1 do
        begin
          StepList.Add(PeriodData.Steps[StepIndex].ToString);
        end;
        frameReleasePeriodData.Grid.Cells[Ord(ppdcSteps), Index+1] := StepList.commaText;
      finally
        StepList.Free;
      end;
    end;
  finally
    frameReleasePeriodData.Grid.EndUpdate;
  end;

  {
  TPackagePeriodDataColumns = (ppdcStartTime, ppdcEndTime, ppdcAll, ppdcFirst, ppdcLast,
  ppdcFrequency, ppdcSteps);
  }
end;

procedure TframePrpMultiplePackages.Initialize;
begin
  framePrpPackages.Grid.BeginUpdate;
  try
    framePrpPackages.Grid.Cells[Ord(pcName ), 0] := StrPackageName;
    framePrpPackages.Grid.Cells[Ord(pcUsed ), 0] := StrPackageUsed;
  finally
    framePrpPackages.Grid.EndUpdate;
  end;

  frameReleasePeriodData.Grid.BeginUpdate;
  try
    ClearGrid(frameReleasePeriodData.Grid);
    frameReleasePeriodData.Grid.Cells[Ord(ppdcStartTime), 0] := StrStartingTime;
    frameReleasePeriodData.Grid.Cells[Ord(ppdcEndTime), 0] := StrEndingTime;
    frameReleasePeriodData.Grid.Cells[Ord(ppdcAll), 0] := StrAllSteps;
    frameReleasePeriodData.Grid.Cells[Ord(ppdcFirst), 0] := StrFirstSteps;
    frameReleasePeriodData.Grid.Cells[Ord(ppdcLast), 0] := StrLastSteps;
    frameReleasePeriodData.Grid.Cells[Ord(ppdcFrequency), 0] := StrStepFrequency;
    frameReleasePeriodData.Grid.Cells[Ord(ppdcSteps), 0] := StrSteps;
  finally
    frameReleasePeriodData.Grid.EndUpdate;
  end;

  frameTrackTimes.Grid.BeginUpdate;
  try
    ClearGrid(frameTrackTimes.Grid);
    frameTrackTimes.Grid.Cells[0,0] := StrTrackingTime
  finally
    frameTrackTimes.Grid.EndUpdate;
  end;

  chklstOutputFiles.UnCheckAll;
  chklstTrackEvents.UnCheckAll;



end;

procedure TframePrpMultiplePackages.SetData(PrtModel: TPrtModel);
var
  PeriodData: TPrpPeriodDataItem;
  StepList: TStringList;
  PrtOutputFiles: TPrtOutputFiles;
  StartTime: Extended;
  EndTime: Extended;
  PeriodIndex: Integer;
  Steps: TGenericIntegerList;
  AnInt: Integer;
  StepCount: Integer;
  PrtTrackingOptions: TPrtTrackingOptions;
begin
  PrtModel.RetardationFactorUsed := cbRetardationFactor.Checked;
  PrtModel.ZoneUsed := cbUseParticleStopZones.Checked;

  PrtOutputFiles := [];
  for var Index := 0 to chklstOutputFiles.Items.Count -1 do
  begin
    if chklstOutputFiles.Checked[Index] then
    begin
      Include(PrtOutputFiles, TPrtOutputFile(Index));
    end;
  end;
  PrtModel.PrtOutputFiles := PrtOutputFiles;

  PrtTrackingOptions := [];
  for var Index := 0 to chklstTrackEvents.Items.Count -1 do
  begin
    if chklstTrackEvents.Checked[Index] then
    begin
      Include(PrtTrackingOptions, TPrtTrackingOption(Index));
    end;
  end;
  PrtModel.PrtTrackingOptions := PrtTrackingOptions;

//  framePrpPackages.Grid.BeginUpdate;
//  try
//    framePrpPackages.seNumber.AsInteger := PrtModel.Count;
//    for var Index := 0 to PrtModel.Count - 1 do
//    begin
//      PrpPackage := PrtModel[Index].PrpPackage;
//      framePrpPackages.Grid.Cells[Ord(pcName), Index+1] := PrpPackage.PackageName;
//      framePrpPackages.Grid.Checked[Ord(pcUsed), Index+1] := PrpPackage.isSelected;
//    end;
//  finally
//    framePrpPackages.Grid.EndUpdate;
//  end;

  PrtModel.TrackTimes.Count := frameTrackTimes.seNumber.AsInteger;
  for var Index := 0 to frameTrackTimes.seNumber.AsInteger - 1 do
  begin
    PrtModel.TrackTimes[Index].Value := frameTrackTimes.Grid.RealValueDefault[0, Index+1, 0];
  end;

  PeriodIndex := 0;
  for var Index := 0 to frameReleasePeriodData.seNumber.AsInteger  - 1 do
  begin
    if TryStrToFloat(frameReleasePeriodData.Grid.Cells[Ord(ppdcStartTime), Index+1], StartTime)
      and TryStrToFloat(frameReleasePeriodData.Grid.Cells[Ord(ppdcEndTime), Index+1], EndTime) then
    begin
      if PeriodIndex < PrtModel.PeriodData.Count then
      begin
        PeriodData := PrtModel.PeriodData[PeriodIndex];
      end
      else
      begin
        PeriodData := PrtModel.PeriodData.Add;
      end;

      PeriodData.All := frameReleasePeriodData.Grid.Checked[Ord(ppdcAll), Index+1];
      PeriodData.First := frameReleasePeriodData.Grid.Checked[Ord(ppdcFirst), Index+1];
      PeriodData.Last := frameReleasePeriodData.Grid.Checked[Ord(ppdcLast), Index+1];
      PeriodData.Frequency := frameReleasePeriodData.Grid.IntegerValue[Ord(ppdcFrequency), Index+1];
      StepList := TStringList.Create;
      try
        StepList.commaText := frameReleasePeriodData.Grid.Cells[Ord(ppdcSteps), Index+1];
        Steps := PeriodData.Steps;
        StepCount := 0;
        Steps.Capacity := StepList.Count;
        for var StepIndex := 0 to StepList.Count - 1 do
        begin
          if TryStrToInt(StepList[StepIndex], AnInt) then
          begin
            if StepCount < Steps.Count then
            begin
               Steps[StepCount] := AnInt;
            end
            else
            begin
              Steps.Add(AnInt);
            end;
            Inc(StepCount);
          end;
        end;
        Steps.Count := StepCount;
      finally
        StepList.Free;
      end;
      Inc(PeriodIndex);
    end;
  end;
end;

end.
