unit Mf6.SfeFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections;

type
  TSfeOptions = class(TCustomMf6Persistent)
  private
    FFLOW_PACKAGE_NAME: string;
    AUXILIARY: TStringList;
    FLOW_PACKAGE_AUXILIARY_NAME: string;
    BOUNDNAMES: Boolean;
    PRINT_INPUT: Boolean;
    FPRINT_TEMPERATURE: Boolean;
    FPRINT_FLOWS: Boolean;
    FSAVE_FLOWS: Boolean;
    FTEMPERATURE: Boolean;
    FBUDGET: Boolean;
    FBUDGETCSV: Boolean;
    TS6_FileNames: TStringList;
    Obs6_FileNames: TStringList;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    property FLOW_PACKAGE_NAME: string read FFLOW_PACKAGE_NAME;
    property PRINT_TEMPERATURE: Boolean read FPRINT_TEMPERATURE;
    property PRINT_FLOWS: Boolean read FPRINT_FLOWS;
    property SAVE_FLOWS: Boolean read FSAVE_FLOWS;
    property TEMPERATURE: Boolean read FTEMPERATURE;
    property BUDGET: Boolean read FBUDGET;
    property BUDGETCSV: Boolean read FBUDGETCSV;
  end;

  TSfePackageItem = class(TObject)
  private
    Frno: Integer;
    Fstrt: TMf6BoundaryValue;
    aux: TBoundaryValueList;
    Fboundname: string;
    Fktf: Extended;
    Frbthcnd: Extended;
  public
    constructor Create;
    destructor Destroy; override;
    property rno: Integer read Frno;
    property strt: TMf6BoundaryValue read Fstrt;
    property ktf: Extended read Fktf;
    property rbthcnd: Extended read Frbthcnd;
    property boundname: string read Fboundname;
  end;

  TSfePackageItemList= TObjectList<TSfePackageItem>;
  TSfePackageItemDictionary = TDictionary<Integer, TSfePackageItem>;

  TSfePackageData = class(TCustomMf6Persistent)
  private
    FItems: TSfePackageItemList;
    FItemDictionary: TSfePackageItemDictionary;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; naux: Integer;
      BOUNDNAMES: Boolean);
    function GetItem(Index: Integer): TSfePackageItem;
    function GetCount: Integer;
    function GetItemByID(ID: Integer): TSfePackageItem;
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSfePackageItem read GetItem;
    property ItemByID[ID: Integer]: TSfePackageItem read GetItemByID;
  end;

  TSfePeriod = class(TCustomMf6Persistent)
  private
    IPER: Integer;
    FItems: TNumberedItemList;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
    function GetCount: Integer;
    function GetItem(Index: Integer): TNumberedItem;
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    property Period: Integer read IPER;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TNumberedItem read GetItem; default;
  end;

  TSfePeriodList = TObjectList<TSfePeriod>;
  TSfePeriodArray = TArray<TSfePeriod>;

  TSfe = class(TDimensionedPackageReader)
  private
    FOptions: TSfeOptions;
    FPackageData: TSfePackageData;
    FPeriods: TSfePeriodList;
    FTimeSeriesPackages: TPackageList;
    FObservationsPackages: TPackageList;
    function GetObservation(Index: Integer): TPackage;
    function GetObservationCount: Integer;
    function GetPeriod(Index: Integer): TSfePeriod;
    function GetPeriodCount: Integer;
    function GetTimeSeries(Index: Integer): TPackage;
    function GetTimeSeriesCount: Integer;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter;
      const NPER: Integer); override;
    property Options: TSfeOptions read FOptions;
    property PackageData: TSfePackageData read FPackageData;
    property PeriodCount: Integer read GetPeriodCount;
    property Periods[Index: Integer]: TSfePeriod read GetPeriod;
    property TimeSeriesCount: Integer read GetTimeSeriesCount;
    property TimeSeries[Index: Integer]: TPackage read GetTimeSeries;
    property ObservationCount: Integer read GetObservationCount;
    property Observations[Index: Integer]: TPackage read GetObservation;
  end;

  TSfeList = TList<TSfe>;

implementation

uses
  System.Generics.Defaults, ModelMuseUtilities, Mf6.TimeSeriesFileReaderUnit,
  Mf6.ObsFileReaderUnit;

{ TSfeOptions }

constructor TSfeOptions.Create(PackageType: string);
begin
  AUXILIARY := TStringList.Create;
  AUXILIARY.CaseSensitive := False;
  TS6_FileNames := TStringList.Create;
  Obs6_FileNames := TStringList.Create;
  inherited;
end;

destructor TSfeOptions.Destroy;
begin
  AUXILIARY.Free;
  TS6_FileNames.Free;
  Obs6_FileNames.Free;
  inherited;
end;

procedure TSfeOptions.Initialize;
begin
  inherited;
  inherited;
  FFLOW_PACKAGE_NAME := '';
  AUXILIARY.Clear;
  FLOW_PACKAGE_AUXILIARY_NAME := '';
  BOUNDNAMES := False;
  PRINT_INPUT := False;
  FPRINT_TEMPERATURE := False;
  FPRINT_FLOWS := False;
  FSAVE_FLOWS := False;
  FTEMPERATURE := False;
  FBUDGET := False;
  FBUDGETCSV := False;
  TS6_FileNames.Clear;
  Obs6_FileNames.Clear;
end;

procedure TSfeOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  CaseSensitiveLine: string;
  TS6_FileName: string;
  Obs_FileName: string;
  AuxIndex: Integer;
  AUXILIARY_Name: string;
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
    else if (FSplitter[0] = 'FLOW_PACKAGE_NAME')
      and (FSplitter.Count >= 2) then
    begin
      FSplitter.DelimitedText := CaseSensitiveLine;
      FFLOW_PACKAGE_NAME := FSplitter[1];
    end
    else if (FSplitter[0] = 'AUXILIARY')
      and (FSplitter.Count >= 2) then
    begin
      FSplitter.DelimitedText := CaseSensitiveLine;
      for AuxIndex := 1 to FSplitter.Count - 1 do
      begin
        AUXILIARY_Name := FSplitter[AuxIndex];
        AUXILIARY.Add(AUXILIARY_Name);
      end;
    end
    else if (FSplitter[0] = 'FLOW_PACKAGE_AUXILIARY_NAME')
      and (FSplitter.Count >= 2) then
    begin
      FSplitter.DelimitedText := CaseSensitiveLine;
      FLOW_PACKAGE_AUXILIARY_NAME := FSplitter[1];
    end
    else if FSplitter[0] = 'BOUNDNAMES' then
    begin
      BOUNDNAMES := True;
    end
    else if FSplitter[0] = 'PRINT_INPUT' then
    begin
      PRINT_INPUT := True;
    end
    else if FSplitter[0] = 'PRINT_TEMPERATURE' then
    begin
      FPRINT_TEMPERATURE := True;
    end
    else if FSplitter[0] = 'PRINT_FLOWS' then
    begin
      FPRINT_FLOWS := True;
    end
    else if FSplitter[0] = 'SAVE_FLOWS' then
    begin
      FSAVE_FLOWS := True;
    end
    else if (FSplitter[0] = 'TEMPERATURE')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEOUT') then
    begin
      FTEMPERATURE := True;
    end
    else if (FSplitter[0] = 'BUDGET')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEOUT') then
    begin
      FBUDGET := True;
    end
    else if (FSplitter[0] = 'BUDGETCSV')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEOUT') then
    begin
      FBUDGETCSV := True;
    end
    else if (FSplitter[0] = 'TS6')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEIN') then
    begin
      FSplitter.DelimitedText := CaseSensitiveLine;
      TS6_FileName := FSplitter[2];
      TS6_FileNames.Add(TS6_FileName);
    end
    else if (FSplitter[0] = 'OBS6')
      and (FSplitter.Count >= 3)
      and (FSplitter[1] = 'FILEIN') then
    begin
      FSplitter.DelimitedText := CaseSensitiveLine;
      Obs_FileName := FSplitter[2];
      Obs6_FileNames.Add(Obs_FileName);
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ TSfePackageItem }

constructor TSfePackageItem.Create;
begin
  Frno := 0;
  Fktf := 0;
  Frbthcnd := 0;
  Fstrt.Initialize;
  aux := TBoundaryValueList.Create;
  Fboundname := ''

end;

destructor TSfePackageItem.Destroy;
begin
  aux.Free;
  inherited;
end;

{ TSfePackageData }

constructor TSfePackageData.Create(PackageType: string);
begin
  FItems := TSfePackageItemList.Create;
  FItemDictionary := TSfePackageItemDictionary.Create;
  inherited;
end;

destructor TSfePackageData.Destroy;
begin
  FItemDictionary.Free;
  FItems.Free;
  inherited;
end;

function TSfePackageData.GetCount: Integer;
begin
  result := FItems.Count;
end;

function TSfePackageData.GetItem(Index: Integer): TSfePackageItem;
begin
  result := FItems[Index];
end;

function TSfePackageData.GetItemByID(ID: Integer): TSfePackageItem;
begin
  if not FItemDictionary.TryGetValue(ID, result) then
  begin
    result := nil;
  end;
end;

procedure TSfePackageData.Initialize;
begin
  inherited;
  FItems.Clear;
end;

procedure TSfePackageData.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  naux: Integer; BOUNDNAMES: Boolean);
var
  ALine: string;
  ErrorLine: string;
  Item: TSfePackageItem;
  ItemStart: Integer;
  AuxIndex: Integer;
  AValue: TMf6BoundaryValue;
  CaseSensitiveLine: string;
  NumberOfItems: Integer;
begin
  NumberOfItems := 4 + naux;
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
        TComparer<TSfePackageItem>.Construct(
          function(const Left, Right: TSfePackageItem): Integer
          begin
            Result := Left.rno - Right.rno;
          end
        ));
      for var ItemIndex:= 0 to FItems.Count - 1 do
      begin
        Item := FItems[ItemIndex];
        FItemDictionary.Add(Item.rno, Item)
      end;
      Exit;
    end;

    CaseSensitiveLine := ALine;
    Item := TSfePackageItem.Create;
    try
      if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'PACKAGEDATA') then
      begin
        // do nothing
      end
      else if (FSplitter.Count >= NumberOfItems)
        and TryStrToInt(FSplitter[0],Item.Frno)
        then
      begin
        if TryFortranStrToFloat(FSplitter[1],Item.Fstrt.NumericValue) then
        begin
          Item.Fstrt.ValueType := vtNumeric;
        end
        else
        begin
          Item.Fstrt.ValueType := vtString;
          Item.Fstrt.StringValue := FSplitter[1];
        end;

        if not TryFortranStrToFloat(FSplitter[2],Item.Fktf) then
        begin
          Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
          Unhandled.WriteLine(ErrorLine);
        end;

        if not TryFortranStrToFloat(FSplitter[3],Item.Frbthcnd) then
        begin
          Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
          Unhandled.WriteLine(ErrorLine);
        end;

        ItemStart := 4;
        for AuxIndex := 0 to naux - 1 do
        begin
          AValue.Initialize;
          if TryFortranStrToFloat(FSplitter[ItemStart],AValue.NumericValue) then
          begin
            AValue.ValueType := vtNumeric
          end
          else
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            AValue.ValueType := vtString;
            AValue.StringValue := FSplitter[ItemStart]
          end;
          Item.aux.Add(AVAlue);
          Inc(ItemStart);
        end;
        if BOUNDNAMES and (FSplitter.Count >= NumberOfItems+1) then
        begin
          FSplitter.DelimitedText := CaseSensitiveLine;
          Item.Fboundname := FSplitter[ItemStart];
        end;
        FItems.Add(Item);
        Item := nil;
      end
      else
      begin
        Unhandled.WriteLine(Format(StrUnrecognizedSPACK, [FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    finally
      Item.Free
    end;
  end;
end;

{ TSfePeriod }

constructor TSfePeriod.Create(PackageType: string);
begin
  FItems := TNumberedItemList.Create;
  inherited;
end;

destructor TSfePeriod.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TSfePeriod.GetCount: Integer;
begin
  result := FItems.Count;
end;

function TSfePeriod.GetItem(Index: Integer): TNumberedItem;
begin
  result := FItems[Index];
end;

procedure TSfePeriod.Initialize;
begin
  inherited;
  FItems.Clear;
end;

procedure TSfePeriod.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  SfeItem: TNumberedItem;
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

    if ReadEndOfSection(ALine, ErrorLine, 'PERIOD', Unhandled) then
    begin
      Exit;
    end;

    SfeItem.Initialize;
    CaseSensitiveLine := ALine;
    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'PERIOD') then
    begin
      // do nothing
    end
    else if FSplitter.Count >= 3 then
    begin
      if TryStrToInt(FSplitter[0], SfeItem.IdNumber) then
      begin
        SfeItem.Name := FSplitter[1];
        if SfeItem.Name = 'STATUS' then
        begin
          SfeItem.StringValue := FSplitter[2];
        end
        else if (SfeItem.Name = 'TEMPERATURE')
          or (SfeItem.Name = 'RAINFALL')
          or (SfeItem.Name = 'EVAPORATION')
          or (SfeItem.Name = 'RUNOFF')
          or (SfeItem.Name = 'INFLOW')
          then
        begin
          if not TryFortranStrToFloat(FSplitter[2], SfeItem.FloatValue) then
          begin
            SfeItem.StringValue := FSplitter[2]
          end;
        end
        else if (SfeItem.Name = 'AUXILIARY')
          then
        begin
          if not TryFortranStrToFloat(FSplitter[3], SfeItem.FloatValue) then
          begin
            FSplitter.DelimitedText := CaseSensitiveLine;
            SfeItem.StringValue := FSplitter[3]
          end;
          FSplitter.DelimitedText := CaseSensitiveLine;
          SfeItem.AuxName := FSplitter[2];
        end
        else
        begin
          Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
          Unhandled.WriteLine(ErrorLine);
        end;
        FItems.Add(SfeItem);
      end
      else
      begin
        Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedSPERI, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TSfe }

constructor TSfe.Create(PackageType: string);
begin
  inherited;
  FOptions := TSfeOptions.Create(PackageType);
  FPackageData := TSfePackageData.Create(PackageType);
  FPeriods := TSfePeriodList.Create;
  FTimeSeriesPackages := TPackageList.Create;
  FObservationsPackages := TPackageList.Create;
end;

destructor TSfe.Destroy;
begin
  FOptions.Free;
  FPackageData.Free;
  FPeriods.Free;
  FTimeSeriesPackages.Free;
  FObservationsPackages.Free;
  inherited;
end;

function TSfe.GetObservation(Index: Integer): TPackage;
begin
  result:= FObservationsPackages[Index];
end;

function TSfe.GetObservationCount: Integer;
begin
  result:= FObservationsPackages.Count;
end;

function TSfe.GetPeriod(Index: Integer): TSfePeriod;
begin
  result:= FPeriods[Index];
end;

function TSfe.GetPeriodCount: Integer;
begin
  result:= FPeriods.Count;
end;

function TSfe.GetTimeSeries(Index: Integer): TPackage;
begin
  result:= FTimeSeriesPackages[Index];
end;

function TSfe.GetTimeSeriesCount: Integer;
begin
  result:= FTimeSeriesPackages.Count;
end;

procedure TSfe.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  const NPER: Integer);
var
  ALine: string;
  ErrorLine: string;
  IPER: Integer;
  APeriod: TSfePeriod;
  TsPackage: TPackage;
  PackageIndex: Integer;
  TsReader: TTimeSeries;
  ObsReader: TObs;
  ObsPackage: TPackage;
begin
  if Assigned(OnUpdataStatusBar) then
  begin
    OnUpdataStatusBar(self, 'reading SFE package');
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
      else if FSplitter[1] ='PACKAGEDATA' then
      begin
        FPackageData.Read(Stream, Unhandled, FOptions.AUXILIARY.Count,
          FOptions.BOUNDNAMES);
      end
      else if (FSplitter[1] ='PERIOD') and (FSplitter.Count >= 3) then
      begin
        if TryStrToInt(FSplitter[2], IPER) then
        begin
          if IPER > NPER then
          begin
            break;
          end;
          APeriod := TSfePeriod.Create(FPackageType);
          FPeriods.Add(APeriod);
          APeriod.IPer := IPER;
          APeriod.Read(Stream, Unhandled);
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
  for PackageIndex := 0 to FOptions.TS6_FileNames.Count - 1 do
  begin
    TsPackage := TPackage.Create;
    FTimeSeriesPackages.Add(TsPackage);
    TsPackage.FileType := FPackageType;
    TsPackage.FileName := FOptions.TS6_FileNames[PackageIndex];
    TsPackage.PackageName := '';

    TsReader := TTimeSeries.Create(FPackageType);
    TsPackage.Package := TsReader;
    TsPackage.ReadPackage(Unhandled, NPER);
  end;
  for PackageIndex := 0 to FOptions.Obs6_FileNames.Count - 1 do
  begin
    ObsPackage := TPackage.Create;
    FObservationsPackages.Add(ObsPackage);
    ObsPackage.FileType := FPackageType;
    ObsPackage.FileName := FOptions.Obs6_FileNames[PackageIndex];
    ObsPackage.PackageName := '';

    ObsReader := TObs.Create(FPackageType);
    ObsReader.Dimensions := FDimensions;
    ObsPackage.Package := ObsReader;
    ObsPackage.ReadPackage(Unhandled, NPER);
  end;
end;

end.
