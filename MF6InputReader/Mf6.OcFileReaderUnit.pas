unit Mf6.OcFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections, RealListUnit;

type
  TOcOptions = class(TCustomMf6Persistent)
  private
    FBudgetFile: string;
    FBudgetCsvFile: string;
    FTrackFile: string;
    FTrackCsvFile: string;
    FHeadFile: string;
    FHeadPrintFormat: TPrintFormat;
    FConcentrationFile: string;
    FConcentrationPrintFormat: TPrintFormat;
    FFullBudgetFileName: string;
    FFullHeadFileName: string;
    FTRACK_RELEASE: Boolean;
    FTRACK_USERTIME: Boolean;
    FTRACK_TIMESTEP: Boolean;
    FTRACK_WEAKSINK: Boolean;
    FTRACK_SUBFEATURE_EXIT: Boolean;
    FTRACK_DROPPED: Boolean;
    FTRACK_EXIT: Boolean;
    FTRACK_TERMINATE: Boolean;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
    function GeConcentrationFile: Boolean;
    function GetBudgetCsvFile: Boolean;
    function GetBudgetFile: Boolean;
    function GetHeadFile: Boolean;
    function GetTrackCsvFile: Boolean;
    function GetTrackFile: Boolean;
  protected
    procedure Initialize; override;
  public
    // The name of the budget file in this file can be used
    // to identify the corresponding model in the flow model interface file (*.fmi).
    property BudgetFile: Boolean read GetBudgetFile;
    property BudgetCsvFile: Boolean read GetBudgetCsvFile;
    property TrackFile: Boolean read GetTrackFile;
    property TrackCsvFile: Boolean read GetTrackCsvFile;
    // The name of the head file in this file can be used
    // to identify the corresponding model in the flow model interface file (*.fmi).
    property HeadFile: Boolean read GetHeadFile;
    property HeadPrintFormat: TPrintFormat read FHeadPrintFormat;
    property ConcentrationFile: Boolean read GeConcentrationFile;
    property ConcecntrationPrintFormat: TPrintFormat read FConcentrationPrintFormat;
    property FullBudgetFileName: string read FFullBudgetFileName;
    property FullHeadFileName: string read FFullHeadFileName;
    property TRACK_RELEASE: Boolean read FTRACK_RELEASE;
    property TRACK_EXIT: Boolean read FTRACK_EXIT;
    property TRACK_SUBFEATURE_EXIT: Boolean read FTRACK_SUBFEATURE_EXIT;
    property TRACK_TIMESTEP: Boolean read FTRACK_TIMESTEP;
    property TRACK_TERMINATE: Boolean read FTRACK_TERMINATE;
    property TRACK_WEAKSINK: Boolean read FTRACK_WEAKSINK;
    property TRACK_USERTIME: Boolean read FTRACK_USERTIME;
    property TRACK_DROPPED: Boolean read FTRACK_DROPPED;
  end;

  TOcDimensions = class(TCustomMf6Persistent)
  private
    NTRACKTIMES: Integer;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  end;

  TOcTrackTimes = class(TCustomMf6Persistent)
  private
    FTimes: TRealList;
    function GetCount: Integer;
    function GetItem(Index: Integer): double;
  protected
    procedure Initialize; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: double read GetItem; default;
  end;


  TPrintSaveOption = (psoAll, psoFirst, psoLast, psoFrequency, psoStep, psoUndefined);

  TPrintSave = record
    FPS_Option: TPrintSaveOption;
    FFrequency: Integer;
    FSteps: TArray<Integer>;
    procedure Initialize;
  end;

  TPrintSaveList = TList<TPrintSave>;

  TOcPeriod = class(TCustomMf6Persistent)
  private
    IPer: Integer;
    FPrintBudget: TPrintSaveList;
    FSaveBudget: TPrintSaveList;
    FPrintHead: TPrintSaveList;
    FSaveHead: TPrintSaveList;
    FPrintConcentration: TPrintSaveList;
    FSaveConcentration: TPrintSaveList;
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
    Property Period: Integer read IPer;
    property PrintBudget: TPrintSaveList read FPrintBudget;
    property SaveBudget: TPrintSaveList read FSaveBudget;
    property PrintHead: TPrintSaveList read FPrintHead;
    property SaveHead: TPrintSaveList read FSaveHead;
    property PrintConcentration: TPrintSaveList read FPrintConcentration;
    property SaveConcentration: TPrintSaveList read FSaveConcentration;
  end;

  TOcPeriodList = TObjectList<TOcPeriod>;

  TOc = class(TPackageReader)
  private
    FOptions: TOcOptions;
    FPeriods: TOcPeriodList;
    FOcDimensions: TOcDimensions;
    FTrackTimes: TOcTrackTimes;
    function GetFullBudgetFileName: string;
    function GetPeriod(Index: Integer): TOcPeriod;
    function GetPeriodCount: Integer;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer); override;
    property OcDimensions: TOcDimensions read FOcDimensions;
    property Options: TOcOptions read FOptions;
    property TrackTimes: TOcTrackTimes Read FTrackTimes;
    property FullBudgetFileName: string read GetFullBudgetFileName;
    property PeriodCount: Integer read GetPeriodCount;
    property Periods[Index: Integer]: TOcPeriod read GetPeriod;
  end;



implementation

uses
  ModelMuseUtilities;

resourcestring
  StrUnrecognizedOCPERI = 'Unrecognized OC PERIOD data in the following line' +
  '.';

{ TOcOptions }

function TOcOptions.GeConcentrationFile: Boolean;
begin
  result := FConcentrationFile <> ''
end;

function TOcOptions.GetBudgetCsvFile: Boolean;
begin
  result := FBudgetCsvFile <> ''
end;

function TOcOptions.GetBudgetFile: Boolean;
begin
  result := FBudgetFile <> ''
end;

function TOcOptions.GetHeadFile: Boolean;
begin
  result := FHeadFile <> ''
end;

function TOcOptions.GetTrackCsvFile: Boolean;
begin
  Result := FTrackCsvFile <> '';
end;

function TOcOptions.GetTrackFile: Boolean;
begin
  result := FTrackFile <> '';
end;

procedure TOcOptions.Initialize;
begin
  FHeadPrintFormat.Initialize;
  FConcentrationPrintFormat.Initialize;
  inherited;
end;

procedure TOcOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  PackageName: string;
  CaseSensitiveLine: string;
begin
  Initialize;
  PackageName := 'OC';
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    RestoreStream(Stream);
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;
    if ReadEndOfSection(ALine, ErrorLine, 'OPTIONS', Unhandled) then
    begin
      Exit
    end;

    CaseSensitiveLine := ALine;
    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'OPTIONS') then
    begin
      // do nothing
    end
else if FSplitter.Count >= 1 then
    begin
      if FSplitter[0] = 'TRACK_RELEASE' then
      begin
        FTRACK_RELEASE := True;
      end
      else if FSplitter[0] = 'TRACK_EXIT' then
      begin
        FTRACK_EXIT := True;
      end
      else if FSplitter[0] = 'TRACK_SUBFEATURE_EXIT' then
      begin
        FTRACK_SUBFEATURE_EXIT := True;
      end
      else if FSplitter[0] = 'TRACK_TIMESTEP' then
      begin
        FTRACK_TIMESTEP := True;
      end
      else if FSplitter[0] = 'TRACK_TERMINATE' then
      begin
        FTRACK_TERMINATE := True;
      end
      else if FSplitter[0] = 'TRACK_WEAKSINK' then
      begin
        FTRACK_WEAKSINK := True;
      end
      else if FSplitter[0] = 'TRACK_USERTIME' then
      begin
        FTRACK_USERTIME := True;
      end
      else if FSplitter[0] = 'TRACK_DROPPED' then
      begin
        FTRACK_DROPPED := True;
      end
      else if FSplitter.Count >= 3 then
      begin
        if FSplitter[0] = 'BUDGET' then
        begin
          if FSplitter[1] = 'FILEOUT' then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            FBudgetFile := FSplitter[2];
            FFullBudgetFileName := ExpandFileName(FBudgetFile);
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else if FSplitter[0] = 'BUDGETCSV' then
        begin
          if FSplitter[1] = 'FILEOUT' then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            FBudgetCsvFile := FSplitter[2];
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else if FSplitter[0] = 'TRACK' then
        begin
          if FSplitter[1] = 'FILEOUT' then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            FTrackFile := FSplitter[2];
  //          FFullBudgetFileName := ExpandFileName(FBudgetFile);
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else if FSplitter[0] = 'TRACKCSV' then
        begin
          if FSplitter[1] = 'FILEOUT' then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            FTrackCsvFile := FSplitter[2];
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else if FSplitter[0] = 'HEAD' then
        begin
          if FSplitter[1] = 'FILEOUT' then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            FHeadFile := FSplitter[2];
            FFullHeadFileName := ExpandFileName(FHeadFile);
          end
          else if FSplitter[1] = 'PRINT_FORMAT' then
          begin
            ReadPrintFormat(ErrorLine, Unhandled, PackageName, FHeadPrintFormat);
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else if (FSplitter[0] = 'CONCENTRATION') or (FSplitter[0] = 'TEMPERATURE') then
        begin
          if FSplitter[1] = 'FILEOUT' then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            FConcentrationFile := FSplitter[2];
          end
          else if FSplitter[1] = 'PRINT_FORMAT' then
          begin
            ReadPrintFormat(ErrorLine, Unhandled, PackageName, FConcentrationPrintFormat);
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
            Unhandled.WriteLine(ErrorLine);
          end;
        end
      end
      else
      begin
        Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [PackageName]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ TOcPeriod }

constructor TOcPeriod.Create(PackageType: string);
begin
  FPrintBudget := TPrintSaveList.Create;
  FSaveBudget := TPrintSaveList.Create;
  FPrintHead := TPrintSaveList.Create;
  FSaveHead := TPrintSaveList.Create;
  FPrintConcentration := TPrintSaveList.Create;
  FSaveConcentration := TPrintSaveList.Create;
  inherited;

end;

destructor TOcPeriod.Destroy;
begin
  FPrintBudget.Free;
  FSaveBudget.Free;
  FPrintHead.Free;
  FSaveHead.Free;
  FPrintConcentration.Free;
  FSaveConcentration.Free;
  inherited;
end;

procedure TOcPeriod.Initialize;
begin
  inherited;
  FPrintBudget.Clear;
  FSaveBudget.Clear;
  FPrintHead.Clear;
  FSaveHead.Clear;
  FPrintConcentration.Clear;
  FSaveConcentration.Clear;
end;

procedure TOcPeriod.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  List: TPrintSaveList;
  PrintSave: TPrintSave;
  Steps: TList<Integer>;
  StepIndex: Integer;
  AStep: Integer;
begin
  Initialize;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    RestoreStream(Stream);
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;
    if ReadEndOfSection(ALine, ErrorLine, 'PERIOD', Unhandled) then
    begin
      Exit
    end;

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'PERIOD') then
    begin
      // do nothing
    end
    else if FSplitter.Count >= 3 then
    begin
      List := nil;
      if FSplitter[0] = 'SAVE' then
      begin
        if FSplitter[1] = 'BUDGET' then
        begin
          List := FSaveBudget;
        end
        ELSE if FSplitter[1] = 'HEAD' then
        begin
          List := FSaveHead;
        end
        ELSE if (FSplitter[1] = 'CONCENTRATION') or (FSplitter[1] = 'TEMPERATURE') then
        begin
          List := FSaveConcentration;
        end
        else
        begin
          Unhandled.WriteLine(StrUnrecognizedOCPERI);
          Unhandled.WriteLine(ErrorLine);
        end;
      end
      else if FSplitter[0] = 'PRINT' then
      begin
        if FSplitter[1] = 'BUDGET' then
        begin
          List := FPrintBudget;
        end
        ELSE if FSplitter[1] = 'HEAD' then
        begin
          List := FPrintHead;
        end
        ELSE if (FSplitter[1] = 'CONCENTRATION') or (FSplitter[1] = 'TEMPERATURE') then
        begin
          List := FPrintConcentration;
        end
        else
        begin
          Unhandled.WriteLine(StrUnrecognizedOCPERI);
          Unhandled.WriteLine(ErrorLine);
        end;
      end
      else
      begin
        Unhandled.WriteLine(StrUnrecognizedOCPERI);
        Unhandled.WriteLine(ErrorLine);
      end;
      if List <> nil then
      begin
        PrintSave.Initialize;
        if FSplitter[2] = 'ALL' then
        begin
          PrintSave.FPS_Option := psoAll;
        end
        else if FSplitter[2] = 'FIRST' then
        begin
          PrintSave.FPS_Option := psoFirst;
        end
        else if FSplitter[2] = 'LAST' then
        begin
          PrintSave.FPS_Option := psoLast;
        end
        else if FSplitter[2] = 'FREQUENCY' then
        begin
          PrintSave.FPS_Option := psoFrequency;
          if FSplitter.Count >= 4 then
          begin
            PrintSave.FFrequency := StrToInt(FSplitter[3]);
          end
          else
          begin
            Unhandled.WriteLine(StrUnrecognizedOCPERI);
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else if FSplitter[2] = 'STEPS' then
        begin
          PrintSave.FPS_Option := psoStep;
          Steps := TList<Integer>.Create;
          try
            Steps.Capacity := FSplitter.Count -3;
            for StepIndex := 3 to FSplitter.Count - 1 do
            begin
              if TryStrToInt(FSplitter[StepIndex], AStep) then
              begin
                Steps.Add(AStep)
              end
              else
              begin
                Break;
              end;
            end;
            PrintSave.FSteps := Steps.ToArray;
          finally
            Steps.Free;
          end;
        end
        else
        begin
          Unhandled.WriteLine(StrUnrecognizedOCPERI);
          Unhandled.WriteLine(ErrorLine);
          Continue;
        end;
        List.Add(PrintSave);
      end;
    end
    else
    begin
      Unhandled.WriteLine(StrUnrecognizedOCPERI);
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TPrintSave }

procedure TPrintSave.Initialize;
begin
  FPS_Option := psoUndefined;
  FFrequency := -1;
  SetLength(FSteps, 0);
end;

{ TOc }

constructor TOc.Create(PackageType: string);
begin
  FOptions := TOcOptions.Create(PackageType);
  FOcDimensions := TOcDimensions.Create(PackageType);
  FTrackTimes := TOcTrackTimes.Create(PackageType);
  FPeriods := TOcPeriodList.Create;
  inherited;

end;

destructor TOc.Destroy;
begin
  FOptions.Free;
  FOcDimensions.Free;
  FTrackTimes.Free;
  FPeriods.Free;
  inherited;
end;

function TOc.GetFullBudgetFileName: string;
begin
  result := FOptions.FullBudgetFileName;
end;

function TOc.GetPeriod(Index: Integer): TOcPeriod;
begin
  result := FPeriods[Index];
end;

function TOc.GetPeriodCount: Integer;
begin
  result := FPeriods.Count;
end;

procedure TOc.Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer);
var
  ALine: string;
  ErrorLine: string;
  IPer: Integer;
  APeriod: TOcPeriod;
begin
  if Assigned(OnUpdataStatusBar) then
  begin
    OnUpdataStatusBar(self, 'reading OC package');
  end;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;

    ALine := UpperCase(ALine);
    FSplitter.DelimitedText := ALine;

    if FSplitter.Count >= 2 then
    begin
      if FSplitter[0] = 'BEGIN' then
      begin
        if FSplitter[1] = 'OPTIONS' then
        begin
          FOptions.Read(Stream, Unhandled);
        end
        else if FSplitter[1] = 'DIMENSIONS' then
        begin
          FOcDimensions.Read(Stream, Unhandled);
        end
        else if FSplitter[1] = 'TRACKTIMES' then
        begin
          FTrackTimes.Read(Stream, Unhandled);
        end
        else if FSplitter[1] = 'PERIOD' then
        begin
          if (FSplitter.Count >= 3)
            and TryStrToInt(FSplitter[2], IPer) then
          begin
            if IPER > NPER then
            begin
              break;
            end;
            APeriod := TOcPeriod.Create(FPackageType);
            FPeriods.Add(APeriod);
            APeriod.IPer := IPer;
            APeriod.Read(Stream, Unhandled);
          end
          else
          begin
            Unhandled.WriteLine('Unrecognized OC data in the following line.');
            Unhandled.WriteLine(ErrorLine);
          end;
        end
        else
        begin
          Unhandled.WriteLine('Unrecognized OC data in the following line.');
          Unhandled.WriteLine(ErrorLine);
        end;
      end;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized OC data in the following line.');
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ TOcDimensions }

procedure TOcDimensions.Initialize;
begin
  inherited;
  NTRACKTIMES := 0;
end;

procedure TOcDimensions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
begin
  Initialize;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    RestoreStream(Stream);
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;
    if ReadEndOfSection(ALine, ErrorLine, 'DIMENSIONS', Unhandled) then
    begin
      Exit
    end;

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'DIMENSIONS') then
    begin
      // do nothing
    end
    else if (FSplitter[0] = 'NTRACKTIMES') and (FSplitter.Count >= 2)
      and TryStrToInt(FSplitter[1], NTRACKTIMES) then
    begin
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end

end;

{ TOcTrackTimes }

constructor TOcTrackTimes.Create(PackageType: string);
begin
  FTimes := TRealList.Create;
  inherited;
end;

destructor TOcTrackTimes.Destroy;
begin
  FTimes.Free;
  inherited;
end;

function TOcTrackTimes.GetCount: Integer;
begin
  result := FTimes.Count;
end;

function TOcTrackTimes.GetItem(Index: Integer): double;
begin
  result := FTimes[Index];
end;

procedure TOcTrackTimes.Initialize;
begin
  inherited;
  FTimes.Clear;
end;

procedure TOcTrackTimes.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  AValue: Extended;
  CaseSensitiveLine: string;
begin
  Initialize;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    RestoreStream(Stream);
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;

    if ReadEndOfSection(ALine, ErrorLine, 'TRACKTIMES', Unhandled) then
    begin
      Exit;
    end;

    CaseSensitiveLine := ALine;
    if TryFortranStrToFloat(ALine, AValue) then
    begin
      FTimes.Add(AValue)
    end
    else
    begin
      Unhandled.WriteLine(Format('Unrecognize track time in the %s package', [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

end.
