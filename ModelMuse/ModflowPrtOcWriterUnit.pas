unit ModflowPrtOcWriterUnit;

interface

uses
 CustomModflowWriterUnit, ModflowPackageSelectionUnit, Vcl.Forms,
  System.SysUtils;

Type
  TPrtOcWriter = class(TCustomFlowPackageWriter)
  private
    FPrtModel: TPrtModel;
    procedure WriteOptions;
    procedure WriteDimensions;
    procedure WriteTrackTimes;
  protected
    class function Extension: string; override;
  public
    property PrtModel: TPrtModel read FPrtModel write FPrtModel;
    procedure WriteFile(const AFileName: string);
  end;

implementation

uses
  frmErrorsAndWarningsUnit;

resourcestring
  STRACK_USERTIMENotSelected = 'TRACK_USERTIME not selected';
  SAlthoughTracktimesHaveBeenSelect = 'Although tracktimes have been selected '
  + 'in model: "%s", TRACK_USERTIME was not selected so they will not be used.';

{ TPrtOcWriter }

class function TPrtOcWriter.Extension: string;
begin
  result := '.oc';
end;

procedure TPrtOcWriter.WriteDimensions;
begin
  WriteBeginDimensions;
  try
    WriteString('  NTRACKTIMES ');
    WriteInteger(PrtModel.TrackTimes.Count);
    NewLine;
  finally
    WriteEndDimensions;
  end;
end;

procedure TPrtOcWriter.WriteFile(const AFileName: string);
begin
  Assert(PrtModel <> nil);
  if not PrtModel.IsSelected then
  begin
    Exit;
  end;
end;

procedure TPrtOcWriter.WriteOptions;
var
  BaseNameOfFile: string;
  BudgetFileOut: string;
  BudgetCsvFileOut: string;
  TrackFileOut: string;
  TrackCsvFileOut: string;
  procedure WriteSingleQuoteMF6;
  begin
    WriteString('''');
  end;
begin
  BaseNameOfFile := ChangeFileExt(FNameOfFile, '') + '.' + PrtModel.ModelName;
  WriteBeginOptions;
  try
    if pofBinaryBudget in PrtModel.PrtOutputFiles then
    begin
      BudgetFileOut := BaseNameOfFile + '.cbb';
      Model.AddModelOutputFile(BudgetFileOut);
      WriteString('  BUDGET FILEOUT ');
      WriteSingleQuoteMF6;
      WriteString(ExtractFileName(BudgetFileOut));
      WriteSingleQuoteMF6;
      NewLine
    end;

    if pofoCsvBudget in PrtModel.PrtOutputFiles then
    begin
      BudgetCsvFileOut := BaseNameOfFile + '.bud.csv';
      Model.AddModelOutputFile(BudgetCsvFileOut);
      WriteString('  BUDGETCSV FILEOUT ');
      WriteSingleQuoteMF6;
      WriteString(ExtractFileName(BudgetCsvFileOut));
      WriteSingleQuoteMF6;
      NewLine
    end;

    if pofBinaryTrack in PrtModel.PrtOutputFiles then
    begin
      TrackFileOut := BaseNameOfFile + '.trk';
      Model.AddModelOutputFile(TrackFileOut);
      WriteString('  TRACK FILEOUT ');
      WriteSingleQuoteMF6;
      WriteString(ExtractFileName(TrackFileOut));
      WriteSingleQuoteMF6;
      NewLine
    end;

    if pofCsvTrack in PrtModel.PrtOutputFiles then
    begin
      TrackCsvFileOut := BaseNameOfFile + '.trk.csv';
      Model.AddModelOutputFile(TrackCsvFileOut);
      WriteString('  TRACKCSV FILEOUT ');
      WriteSingleQuoteMF6;
      WriteString(ExtractFileName(TrackCsvFileOut));
      WriteSingleQuoteMF6;
      NewLine
    end;

    if ptoRelease in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_RELEASE');
      NewLine
    end;

    if ptoExit in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_EXIT');
      NewLine
    end;

    if ptoSubFeatureExit in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_SUBFEATURE_EXIT');
      NewLine
    end;

    if ptoTimeStep in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_TIMESTEP');
      NewLine
    end;

    if ptoTerminate in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_TERMINATE');
      NewLine
    end;

    if ptoWeakSink in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_WEAKSINK');
      NewLine
    end;

    if (ptoUserTime in PrtModel.PrtTrackingOptions)  then
    begin
      WriteString('  TRACK_USERTIME');
      NewLine
    end
    else
    begin
      if (PrtModel.TrackTimes.Count > 0) then
      begin
        frmErrorsAndWarnings.AddWarning(Model, STRACK_USERTIMENotSelected,
          Format(SAlthoughTracktimesHaveBeenSelect, [PrtModel.ModelName]));
      end;
    end;

    if ptoDropped in PrtModel.PrtTrackingOptions then
    begin
      WriteString('  TRACK_DROPPED');
      NewLine
    end;
  finally
    WriteEndOptions;
  end;
end;

procedure TPrtOcWriter.WriteTrackTimes;
begin

end;

end.
