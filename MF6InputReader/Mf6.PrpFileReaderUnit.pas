unit Mf6.PrpFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections, System.Generics.Defaults, IntListUnit,
  RealListUnit;

type
  TPrpOptions = class(TCustomMf6Persistent)
  private
    BOUNDNAMES: Boolean;
    PRINT_INPUT: Boolean;
    FEXIT_SOLVE_TOLERANCE: TRealOption;
    FLOCAL_Z: Boolean;
    FEXTEND_TRACKING: Boolean;
    FTRACK_FILEOUT: Boolean;
    FTRACKCSV_FILEOUT: Boolean;
    FSTOPTIME: TRealOption;
    FSTOPTRAVELTIME: TRealOption;
    FSTOP_AT_WEAK_SINK: Boolean;
    FISTOPZONE: TIntegerOption;
    FDRAPE: Boolean;
    FDRY_TRACKING_METHOD: string;
    FRELEASE_TIME_TOLERANCE: TRealOption;
    FRELEASE_TIME_FREQUENCY: TRealOption;
    FCOORDINATE_CHECK_METHOD: string;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  public
    property EXIT_SOLVE_TOLERANCE: TRealOption read FEXIT_SOLVE_TOLERANCE;
    property LOCAL_Z: Boolean read FLOCAL_Z;
    property EXTEND_TRACKING: Boolean read FEXTEND_TRACKING;
    property TRACK_FILEOUT: Boolean read FTRACK_FILEOUT;
    property TRACKCSV_FILEOUT: Boolean read FTRACKCSV_FILEOUT;
    property STOPTIME: TRealOption read FSTOPTIME;
    property STOPTRAVELTIME: TRealOption read FSTOPTRAVELTIME;
    property STOP_AT_WEAK_SINK: Boolean read FSTOP_AT_WEAK_SINK;
    property ISTOPZONE: TIntegerOption read FISTOPZONE;
    property DRAPE: Boolean read FDRAPE;
    property DRY_TRACKING_METHOD: string read FDRY_TRACKING_METHOD;
    property RELEASE_TIME_TOLERANCE: TRealOption read FRELEASE_TIME_TOLERANCE;
    property RELEASE_TIME_FREQUENCY: TRealOption read FRELEASE_TIME_FREQUENCY;
    property COORDINATE_CHECK_METHOD: string read FCOORDINATE_CHECK_METHOD;
  end;

  TPrpDimensions = class(TCustomMf6Persistent)
  private
    NRELEASEPTS: Integer;
    NRELEASETIMES: Integer;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  end;

  TPrpPackageItem = class(TObject)
  private
    Firptno: Integer;
    Fboundname: string;
    FZ: Extended;
    Fcellid: TMfCellId;
    FX: Extended;
    FY: Extended;
  public
    constructor Create;
    destructor Destroy; override;
    property irptno: Integer read Firptno;
    property CellId: TMfCellId read Fcellid;
    property X: Extended read FX;
    property Y: Extended read FY;
    property Z: Extended read FZ;
    property boundname: string read Fboundname;
  end;

  TPrpPackageItemList= TObjectList<TPrpPackageItem>;
//  TPrpPackageItemArray = TArray<TPrpPackageItem>;

  TPrpPackageData = class(TCustomMf6Persistent)
  private
    FItems: TPrpPackageItemList;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter;
      Dimensions: TDimensions; BOUNDNAMES: Boolean);
    function GetCount: Integer;
    function GetItem(Index: Integer): TPrpPackageItem;
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPrpPackageItem read GetItem; default;
  end;

  TPrpReleaseTimes = class(TCustomMf6Persistent)
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

  TPrpTimeItem = class(TObject)
  private
    FSettingType: string;
    FSteps: TIntegerList;
    FFrequency: Integer;
    function GetStep(Index: Integer): Integer;
    function GetStepCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property SettingType: string read FSettingType;
    property Frequency: Integer read FFrequency;
    property Steps[Index: Integer]: Integer read GetStep; default;
    property StepCount: Integer read GetStepCount;
  end;

  TPrpTimeItemList = TObjectList<TPrpTimeItem>;

  TPrpPeriod = class(TCustomMf6Persistent)
  private
    IPer: Integer;
    FSettings: TPrpTimeItemList;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter;
      Dimensions: TDimensions; BOUNDNAMES: Boolean);
    function GetSetting(Index: Integer): TPrpTimeItem;
    function GetCount: Integer;
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    property Period: Integer read IPer;
    property Count: Integer read GetCount;
    property Settings[Index: Integer]: TPrpTimeItem read GetSetting; default;
  end;

  TPrpPeriodList = TObjectList<TPrpPeriod>;

  TPrp = class(TDimensionedPackageReader)
  private
    FOptions: TPrpOptions;
    FPrpDimensions: TPrpDimensions;
    FPeriods: TPrpPeriodList;
    FPackageData: TPrpPackageData;
    FReleaseTimes: TPrpReleaseTimes;
    function GetPeriod(Index: Integer): TPrpPeriod;
    function GetPeriodCount: Integer;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer); override;
    property Options: TPrpOptions read FOptions;
    property PackageData: TPrpPackageData read FPackageData;
    property ReleaseTimes: TPrpReleaseTimes read FReleaseTimes;
    property PeriodCount: Integer read GetPeriodCount;
    property Periods[Index: Integer]: TPrpPeriod read GetPeriod;
  end;


implementation

uses
  ModelMuseUtilities, Mf6.TimeSeriesFileReaderUnit, Mf6.ObsFileReaderUnit;

{ TPrpOptions }

procedure TPrpOptions.Initialize;
begin
  inherited;
  BOUNDNAMES := False;
  PRINT_INPUT := False;

  FEXIT_SOLVE_TOLERANCE.Initialize;
  FLOCAL_Z := False;
  FEXTEND_TRACKING := False;
  FTRACK_FILEOUT := False;
  FTRACKCSV_FILEOUT := False;
  FSTOPTIME.Initialize;
  FSTOPTRAVELTIME.Initialize;
  FSTOP_AT_WEAK_SINK := False;
  FISTOPZONE.Initialize;
  FDRAPE := False;
  FDRY_TRACKING_METHOD := '';
  FRELEASE_TIME_TOLERANCE.Initialize;
  FRELEASE_TIME_FREQUENCY.Initialize;
  FCOORDINATE_CHECK_METHOD := '';

end;

procedure TPrpOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
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
    if ReadEndOfSection(ALine, ErrorLine, 'OPTIONS', Unhandled) then
    begin
      Exit
    end;

    CaseSensitiveLine := ALine;
    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'OPTIONS') then
    begin
      // do nothing
    end
    else if FSplitter[0] = 'BOUNDNAMES' then
    begin
      BOUNDNAMES := True;
    end
    else if FSplitter[0] = 'PRINT_INPUT' then
    begin
      PRINT_INPUT := True;
    end
    else if (FSplitter[0] = 'EXIT_SOLVE_TOLERANCE')
      and (FSplitter.Count >= 2)
      and TryFortranStrToFloat(FSplitter[1], FEXIT_SOLVE_TOLERANCE.Value) then
    begin
      FEXIT_SOLVE_TOLERANCE.Used := True;
    end

    else if FSplitter[0] = 'LOCAL_Z' then
    begin
      FLOCAL_Z := True;
    end
    else if FSplitter[0] = 'EXTEND_TRACKING' then
    begin
      FEXTEND_TRACKING := True;
    end
    else if (FSplitter[0] = 'TRACK')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEOUT') then
    begin
      FTRACK_FILEOUT := True;
    end
    else if (FSplitter[0] = 'TRACKCSV')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEOUT') then
    begin
      fTRACKCSV_FILEOUT := True;
    end
    else if (FSplitter[0] = 'STOPTIME')
      and (FSplitter.Count >= 2)
      and TryFortranStrToFloat(FSplitter[1], FSTOPTIME.Value) then
    begin
      FSTOPTIME.Used := True;
    end
    else if (FSplitter[0] = 'STOPTRAVELTIME')
      and (FSplitter.Count >= 2)
      and TryFortranStrToFloat(FSplitter[1], FSTOPTRAVELTIME.Value) then
    begin
      FSTOPTRAVELTIME.Used := True;
    end
    else if FSplitter[0] = 'STOP_AT_WEAK_SINK' then
    begin
      FSTOP_AT_WEAK_SINK := True;
    end
    else if (FSplitter[0] = 'ISTOPZONE')
      and (FSplitter.Count >= 2)
      and TryStrToInt(FSplitter[1], FISTOPZONE.Value) then
    begin
      FISTOPZONE.Used := True;
    end
    else if FSplitter[0] = 'DRAPE' then
    begin
      FDRAPE := True;
    end
    else if (FSplitter[0] = 'DRY_TRACKING_METHOD')
      and (FSplitter.Count >= 2) then
    begin
      FDRY_TRACKING_METHOD := FSplitter[1];
    end
    else if (FSplitter[0] = 'RELEASE_TIME_TOLERANCE')
      and (FSplitter.Count >= 2)
      and TryFortranStrToFloat(FSplitter[1], FRELEASE_TIME_TOLERANCE.Value) then
    begin
      FRELEASE_TIME_TOLERANCE.Used := True;
    end
    else if (FSplitter[0] = 'RELEASE_TIME_FREQUENCY')
      and (FSplitter.Count >= 2)
      and TryFortranStrToFloat(FSplitter[1], FRELEASE_TIME_FREQUENCY.Value) then
    begin
      FRELEASE_TIME_FREQUENCY.Used := True;
    end
    else if (FSplitter[0] = 'COORDINATE_CHECK_METHOD')
      and (FSplitter.Count >= 2) then
    begin
      FCOORDINATE_CHECK_METHOD := FSplitter[1];
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TPrpTimeItem }

constructor TPrpTimeItem.Create;
begin
  FSteps := TIntegerList.Create;
end;

destructor TPrpTimeItem.Destroy;
begin
  FSteps.Free;
  inherited;
end;

function TPrpTimeItem.GetStep(Index: Integer): Integer;
begin
  result := FSteps[Index];
end;

function TPrpTimeItem.GetStepCount: Integer;
begin
  result := FSteps.Count;
end;


{ TPrpDimensions }

procedure TPrpDimensions.Initialize;
begin
  inherited;
  NRELEASEPTS := 0;
  NRELEASETIMES := 0;
end;

procedure TPrpDimensions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
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
    else if (FSplitter[0] = 'NRELEASEPTS') and (FSplitter.Count >= 2)
      and TryStrToInt(FSplitter[1], NRELEASEPTS) then
    begin
    end
    else if (FSplitter[0] = 'NRELEASETIMES') and (FSplitter.Count >= 2)
      and TryStrToInt(FSplitter[1], NRELEASETIMES) then
    begin
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end

end;

{ TPrpPeriod }

constructor TPrpPeriod.Create(PackageType: string);
begin
  FSettings := TPrpTimeItemList.Create;
  inherited;
end;

destructor TPrpPeriod.Destroy;
begin
  FSettings.Free;
  inherited;
end;

function TPrpPeriod.GetSetting(Index: Integer): TPrpTimeItem;
begin
  result := FSettings[Index];
end;

function TPrpPeriod.GetCount: Integer;
begin
  result := FSettings.Count;
end;

procedure TPrpPeriod.Initialize;
begin
  inherited;
  FSettings.Clear;
end;

procedure TPrpPeriod.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  Dimensions: TDimensions; BOUNDNAMES: Boolean);
var
  Setting: TPrpTimeItem;
  ALine: string;
  ErrorLine: string;
  CaseSensitiveLine: string;
  Step: Integer;
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
      Exit;
    end;

    Setting := TPrpTimeItem.Create;
    try
      CaseSensitiveLine := ALine;
      if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'PERIOD') then
      begin
        // do nothing
      end
      else
      begin
        Setting.FSettingType := UpperCase(FSplitter[0]);
        if AnsiSameText(Setting.FSettingType, 'FREQUENCY') then
        begin
          if FSplitter.Count > 1 then
          begin
            if not TryStrToInt(FSplitter[1], Setting.FFrequency) then
            begin
              Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
              Unhandled.WriteLine(ErrorLine);
              Continue;
            end;
          end
          else
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
            Unhandled.WriteLine(ErrorLine);
            Continue;
          end;
        end
        else if AnsiSameText(Setting.FSettingType, 'STEPS') then
        begin
          for var StepIndex := 1 to FSplitter.Count - 1 do
          begin
            if TryStrToInt(FSplitter[StepIndex], Step) then
            begin
              Setting.FSteps.Add(Step)
            end
            else
            begin
              Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
              Unhandled.WriteLine(ErrorLine);
              Continue;
            end;
          end;
        end
        else if not AnsiSameText(Setting.FSettingType, 'All')
          and not AnsiSameText(Setting.FSettingType, 'FIRST')
          and not AnsiSameText(Setting.FSettingType, 'LAST') then
        begin
          Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
          Unhandled.WriteLine(ErrorLine);
          Continue;
        end;
      end;

      FSettings.Add(Setting);
      Setting:= nil;
    finally
      Setting.Free;
    end;
  end;

end;

{ TPrp }

constructor TPrp.Create(PackageType: string);
begin
  inherited;
  FOptions := TPrpOptions.Create(PackageType);
  FPrpDimensions := TPrpDimensions.Create(PackageType);
  FPackageData := TPrpPackageData.Create(PackageType);
  FReleaseTimes := TPrpReleaseTimes.Create(PackageType);
  FPeriods := TPrpPeriodList.Create;

end;

destructor TPrp.Destroy;
begin
  FOptions.Free;
  FPrpDimensions.Free;
  FPackageData.Free;
  FReleaseTimes.Free;
  FPeriods.Free;
  inherited;
end;

function TPrp.GetPeriod(Index: Integer): TPrpPeriod;
begin
  result := FPeriods[Index];
end;

function TPrp.GetPeriodCount: Integer;
begin
  result := FPeriods.Count;
end;

procedure TPrp.Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer);
var
  ALine: string;
  ErrorLine: string;
  IPER: Integer;
  APeriod: TPrpPeriod;
begin
  if Assigned(OnUpdataStatusBar) then
  begin
    OnUpdataStatusBar(self, 'reading PRP package');
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
    if FSplitter[0] = 'BEGIN' then
    begin
      if FSplitter[1] ='OPTIONS' then
      begin
        FOptions.Read(Stream, Unhandled);
      end
      else if FSplitter[1] ='DIMENSIONS' then
      begin
        FPrpDimensions.Read(Stream, Unhandled);
      end
      else if FSplitter[1] ='PACKAGEDATA' then
      begin
        FPackageData.Read(Stream, Unhandled, Dimensions, FOptions.BOUNDNAMES);
      end
      else if FSplitter[1] ='RELEASETIMES' then
      begin
        FReleaseTimes.Read(Stream, Unhandled);
      end
      else if (FSplitter[1] ='PERIOD') and (FSplitter.Count >= 3) then
      begin
        if TryStrToInt(FSplitter[2], IPER) then
        begin
          if IPER > NPER then
          begin
            break;
          end;
          APeriod := TPrpPeriod.Create(FPackageType);
          FPeriods.Add(APeriod);
          APeriod.IPer := IPER;
          APeriod.Read(Stream, Unhandled, FDimensions,
            FOptions.BOUNDNAMES);
        end
        else
        begin
          Unhandled.WriteLine(Format(StrUnrecognizedSData, [FPackageType]));
          Unhandled.WriteLine(ErrorLine);
        end;
      end
      else
      begin
        Unhandled.WriteLine(Format(StrUnrecognizedSData, [FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedSData, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;


{ TPrpPackageItem }

constructor TPrpPackageItem.Create;
begin
  Firptno := 0;
  Fcellid.Initialize;
  FX := 0;
  FY := 0;
  FZ := 0;
  Fboundname := ''
end;

destructor TPrpPackageItem.Destroy;
begin

  inherited;
end;

{ TPrpPackageData }

constructor TPrpPackageData.Create(PackageType: string);
begin
  FItems := TPrpPackageItemList.Create;
  inherited;
end;

destructor TPrpPackageData.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TPrpPackageData.GetCount: Integer;
begin
  result := FItems.Count;
end;

function TPrpPackageData.GetItem(Index: Integer): TPrpPackageItem;
begin
  Result := FItems[Index];
end;

procedure TPrpPackageData.Initialize;
begin
  inherited;
  FItems.Clear;
end;

procedure TPrpPackageData.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  Dimensions: TDimensions; BOUNDNAMES: Boolean);
var
  ALine: string;
  ErrorLine: string;
  Item: TPrpPackageItem;
  CaseSensitiveLine: string;
  NumberOfItems: Integer;
  DimensionCount: Integer;
begin
  DimensionCount := Dimensions.DimensionCount;
  NumberOfItems := 4 + DimensionCount;
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

    if ReadEndOfSection(ALine, ErrorLine, 'PACKAGEDATA', Unhandled) then
    begin
      FItems.Sort(
        TComparer<TPrpPackageItem>.Construct(
          function(const Left, Right: TPrpPackageItem): Integer
          begin
            Result := Left.Firptno - Right.Firptno;
          end
        ));
      Exit;
    end;

    CaseSensitiveLine := ALine;
    Item := TPrpPackageItem.Create;
    try
      if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'PACKAGEDATA') then
      begin
        // do nothing
      end
      else if (FSplitter.Count >= NumberOfItems)
        and TryStrToInt(FSplitter[0],Item.Firptno)
        then
      begin
        if ReadCellID(Item.Fcellid, 1, DimensionCount) then
        begin
          if not TryFortranStrToFloat(FSplitter[DimensionCount + 1], Item.Fx) then
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
            Unhandled.WriteLine(ErrorLine);
            Continue;
          end;
          if not TryFortranStrToFloat(FSplitter[DimensionCount + 2], Item.FY) then
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
            Unhandled.WriteLine(ErrorLine);
            Continue;
          end;
          if not TryFortranStrToFloat(FSplitter[DimensionCount + 3], Item.FZ) then
          begin
            Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
            Unhandled.WriteLine(ErrorLine);
            Continue;
          end;
          if BOUNDNAMES and (FSplitter.Count > NumberOfItems) then
          begin
            Item.Fboundname := FSplitter[DimensionCount + 4];
          end;
        end
        else
        begin
          Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
          Unhandled.WriteLine(ErrorLine);
          Continue;
        end;

        FItems.Add(Item);
        Item := nil;
      end
      else
      begin
        Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
        Unhandled.WriteLine(ErrorLine);
        Continue;
      end;
    finally
      Item.Free
    end;
  end;
end;

{ TPrpReleaseTimes }

constructor TPrpReleaseTimes.Create(PackageType: string);
begin
  FTimes := TRealList.Create;
  inherited;
end;

destructor TPrpReleaseTimes.Destroy;
begin
  FTimes.Free;
  inherited;
end;

function TPrpReleaseTimes.GetCount: Integer;
begin
  result := FTimes.Count;
end;

function TPrpReleaseTimes.GetItem(Index: Integer): double;
begin
  result := FTimes[Index];
end;

procedure TPrpReleaseTimes.Initialize;
begin
  inherited;
  FTimes.Clear;
end;

procedure TPrpReleaseTimes.Read(Stream: TStreamReader;
  Unhandled: TStreamWriter);
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

    if ReadEndOfSection(ALine, ErrorLine, 'RELEASETIMES', Unhandled) then
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
      Unhandled.WriteLine(Format('Unrecognize release time in the %s package', [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;

end;

end.
