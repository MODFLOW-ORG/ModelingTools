unit Mf6.NameFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections, Mf6.AtsFileReaderUnit;

type
  TCustomNameFileOptions = class(TCustomMf6Persistent)
  private
    ListingFileName: string;
    FPRINT_INPUT: Boolean;
    FPRINT_FLOWS: Boolean;
    SAVE_FLOWS: Boolean;
    FNETCDF_STRUCTURED: Boolean;
    Fnetcdf_filename: string;
    FNETCDF_MESH2D: Boolean;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
    procedure HandleAdditionalSingleOptions(ErrorLine: string;
      Unhandled: TStreamWriter); virtual;
    procedure HandleAdditionalDoubleOptions(ErrorLine: string;
      Unhandled: TStreamWriter); virtual;
  protected
    procedure Initialize; override;
    property NETCDF_MESH2D: Boolean read FNETCDF_MESH2D;
    property NETCDF_STRUCTURED: Boolean read FNETCDF_STRUCTURED;
    property netcdf_filename: string read Fnetcdf_filename;
  public
    property PRINT_INPUT: Boolean read FPRINT_INPUT;
    property PRINT_FLOWS: Boolean read FPRINT_FLOWS;
  end;

  TFlowNameFileOptions = class(TCustomNameFileOptions)
  private
    FNEWTON: Boolean;
    FUNDER_RELAXATION: Boolean;
    procedure HandleAdditionalSingleOptions(ErrorLine: string;
      Unhandled: TStreamWriter); override;
    procedure HandleAdditionalDoubleOptions(ErrorLine: string;
      Unhandled: TStreamWriter); override;
  protected
    procedure Initialize; override;
  public
    property NEWTON: Boolean read FNEWTON;
    property UNDER_RELAXATION: Boolean read FUNDER_RELAXATION;
    property NETCDF_MESH2D;
    property NETCDF_STRUCTURED;
    property netcdf_filename;
  end;

  TTransportNameFileOptions = class(TCustomNameFileOptions)
  public
    property NETCDF_MESH2D;
    property NETCDF_STRUCTURED;
    property netcdf_filename;
  end;

  TPrtNameFileOptions = class(TCustomNameFileOptions)

  end;

  TCustomPackages = class(TCustomMf6Persistent)
  private
    FPackages: TPackageList;
    FValidPackageTypes: TStringList;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
    function GetCount: Integer;
    function GetPackage(Index: Integer): TPackage;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Initialize; override;
  public
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPackage read GetPackage; default;
  end;

  TFlowPackages =class(TCustomPackages)
    procedure Initialize; override;
  end;

  TTransportPackages =class(TCustomPackages)
    procedure Initialize; override;
  end;

  TEnergyTransportPackages =class(TCustomPackages)
    procedure Initialize; override;
  end;

  TPrtPackages  =class(TCustomPackages)
    procedure Initialize; override;
  end;

  TCustomNameFile = class(TCustomMf6Persistent)
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter); virtual; abstract;
    procedure ReadInput(Unhandled: TStreamWriter; const NPER: Integer); virtual; abstract;
  end;

  TNameFile<Options: TCustomNameFileOptions; Packages: TCustomPackages> = class(TCustomNameFile)
  private
    const
    StrUnrecognizedNameOption = 'Unrecognized Name file option in the following line.';
    var
    FOptions: Options;
    FPackages: Packages;
    FDimensions: TDimensions;
    FOCPackage: TPackage;
    FFmiPackage: TPackage;
    FSpeciesName: string;
    function GetPackageReader(const PackageName: string): TPackageReader;
  protected
    procedure SetOnUpdataStatusBar(const Value: TOnUpdataStatusBar); override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter); override;
    procedure ReadInput(Unhandled: TStreamWriter; const NPER: Integer); override;
    property Dimensions: TDimensions read FDimensions;
    property NfOptions: Options read FOptions;
    property NfPackages: Packages read FPackages;
    property OCPackage: TPackage read FOCPackage;
    property FmiPackage: TPackage read FFmiPackage;
    property SpeciesName: string read FSpeciesName write FSpeciesName;
    function GetSsmPackage: TPackageReader;
    function GetMwtPackage: TPackageReader;
    function GetMwePackage: TPackageReader;
  end;

  TFlowNameFile = TNameFile<TFlowNameFileOptions, TFlowPackages>;
  TTransportNameFile = class(TNameFile<TTransportNameFileOptions, TTransportPackages>);
  TEnergyTransportNameFile = class(TNameFile<TTransportNameFileOptions, TEnergyTransportPackages>);
  TPrtNameFile = class(TNameFile<TPrtNameFileOptions, TPrtPackages>);

implementation

uses
  Mf6.DisFileReaderUnit, Mf6.DisvFileReaderUnit, Mf6.DisuFileReaderUnit, Mf6.IcFileReaderUnit,
  Mf6.OcFileReaderUnit, Mf6.ObsFileReaderUnit, Mf6.NpfFileReaderUnit, Mf6.HfbFileReaderUnit,
  Mf6.StoFileReaderUnit, Mf6.CSubFileReaderUnit, Mf6.BuyFileReaderUnit, Mf6.VscFileReaderUnit,
  Mf6.ChdFileReaderUnit, Mf6.WelFileReaderUnit, Mf6.DrnFileReaderUnit, Mf6.RivFileReaderUnit,
  Mf6.RchFileReaderUnit, Mf6.EvtFileReaderUnit, Mf6.MawFileReaderUnit, Mf6.SfrFileReaderUnit,
  Mf6.GhbFileReaderUnit, Mf6.LakFileReaderUnit, Mf6.UzfFileReaderUnit, Mf6.MvrFileReaderUnit,
  Mf6.GncFileReaderUnit, Mf6.ExchangeFileReaderUnit, Mf6.AdvFileReaderUnit,
  Mf6.DspFileReaderUnit, Mf6.SsmFileReaderUnit, Mf6.MstFileReaderUnit, Mf6.IstFileReaderUnit,
  Mf6.SrcFileReaderUnit, Mf6.CncFileReaderUnit, Mf6.SftFileReaderUnit, Mf6.LktFileReaderUnit,
  Mf6.MwtFileReaderUnit, Mf6.UztFileReaderUnit, Mf6.FmiFileReaderUnit, Mf6.MvtFileReaderUnit,
  Mf6.CndFileReaderUnit, Mf6.EslFileReaderUnit, MF6.EstFileReaderUnit,
  Mf6.CtpFileReaderUnit, Mf6.SfeFileReaderUnit, Mf6.LkeFileReaderUnit,
  Mf6.MweFileReaderUnit, Mf6.UzeFileReaderUnit, Mf6.MipFileReaderUnit,
  Mf6.PrpFileReaderUnit;

{ TCustomNameFileOptions }

procedure TCustomNameFileOptions.Initialize;
begin
  inherited;
  ListingFileName := '';
  FPRINT_INPUT := False;
  FPRINT_FLOWS := False;
  SAVE_FLOWS := False;
  FNETCDF_STRUCTURED := False;
  Fnetcdf_filename := '';
  FNETCDF_MESH2D := False;

end;

procedure TCustomNameFileOptions.Read(Stream: TStreamReader;
  Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  AValue: string;
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

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'OPTIONS') then
    begin
      // do nothing
    end
    else if FSplitter.Count >= 1 then
    begin
      ALine := UpperCase(ALine);
      FSplitter.DelimitedText := ALine;
      AValue := FSplitter[0];
      if AValue = 'PRINT_INPUT' then
      begin
        FPRINT_INPUT := True;
      end
      else if AValue = 'PRINT_FLOWS' then
      begin
        FPRINT_FLOWS := True;
      end
      else if AValue = 'SAVE_FLOWS' then
      begin
        SAVE_FLOWS := True;
      end
      else if AValue = 'SAVE_FLOWS' then
      begin
        SAVE_FLOWS := True;
      end
      else if FSplitter.Count >= 2 then
      begin
        if UpperCase(FSplitter[0]) = 'LIST' then
        begin
          ListingFileName := FSplitter[1]
        end
        else
        begin
          ALine := UpperCase(ALine);
          FSplitter.DelimitedText := ALine;
          HandleAdditionalDoubleOptions(ErrorLine, Unhandled);
        end;
      end
      else
      begin
//        Unhandled.WriteLine('Unrecognized name file option in the following line.');
        HandleAdditionalSingleOptions(ErrorLine, Unhandled);
      end;
    end
    else
    begin
        Unhandled.WriteLine('Unrecognized name file option in the following line.');
        Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

procedure TCustomNameFileOptions.HandleAdditionalSingleOptions(ErrorLine: string;
  Unhandled: TStreamWriter);
begin
  Unhandled.WriteLine('Unrecognized name file option in the following line.');
  Unhandled.WriteLine(ErrorLine);
end;

procedure TCustomNameFileOptions.HandleAdditionalDoubleOptions(ErrorLine: string; Unhandled: TStreamWriter);
begin
  Unhandled.WriteLine('Unrecognized name file option in the following line.');
  Unhandled.WriteLine(ErrorLine);
end;

{ TFlowNameFileOptions }

procedure TFlowNameFileOptions.HandleAdditionalDoubleOptions(ErrorLine: string;
  Unhandled: TStreamWriter);
var
  AValue: string;
begin
//  inherited;
  AValue := FSplitter[0];
  if AValue = 'NEWTON' then
  begin
    FNEWTON := True;
    if FSplitter[1] = 'UNDER_RELAXATION' then
    begin
      FUNDER_RELAXATION := True;
    end
    else
    begin
      inherited
    end;
  end
  else if (AValue = 'NETCDF_MESH2D') and (FSplitter.Count >= 3) and (FSplitter[1] = 'FILEOUT') then
  begin
    FNETCDF_MESH2D := True;
    Unhandled.WriteLine('NETCDF_MESH2D option is not used in this program.');
  end
  else if (AValue = 'NETCDF_STRUCTURED') and (FSplitter.Count >= 3) and (FSplitter[1] = 'FILEOUT') then
  begin
    FNETCDF_STRUCTURED := True;
    Unhandled.WriteLine('NETCDF_STRUCTURED option is not used in this program.');
  end
  else if (AValue = 'NETCDF') and (FSplitter.Count >= 3) and (FSplitter[1] = 'FILEIN') then
  begin
    Fnetcdf_filename := FSplitter[2];
    Unhandled.WriteLine('NETCDF input file is not handled in this program.');
  end
  else
  begin
    inherited
  end;
end;

procedure TFlowNameFileOptions.HandleAdditionalSingleOptions(ErrorLine: string;
  Unhandled: TStreamWriter);
var
  AValue: string;
begin
  AValue := FSplitter[0];
  if AValue = 'NEWTON' then
  begin
    FNEWTON := True;
  end
  else
  begin
    inherited
  end;

end;

procedure TFlowNameFileOptions.Initialize;
begin
  inherited;
  FNEWTON := False;
  FUNDER_RELAXATION := False;
end;

{ TCustomPackages }

constructor TCustomPackages.Create(PackageType: string);
begin
  FPackages := TPackageList.Create;
  FValidPackageTypes := TStringList.Create;
  inherited;

end;

destructor TCustomPackages.Destroy;
begin
  FValidPackageTypes.Free;
  FPackages.Free;
  inherited;
end;

function TCustomPackages.GetCount: Integer;
begin
  result := FPackages.Count;
end;

function TCustomPackages.GetPackage(Index: Integer): TPackage;
begin
  result := FPackages[Index];
end;

procedure TCustomPackages.Initialize;
begin
  inherited;
  FPackages.Clear;
  FValidPackageTypes.Clear;
end;

procedure TCustomPackages.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  APackage: TPackage;
  SectionName: string;
  PackageIndex: Integer;
  PackageCount: Integer;
  ExistingPackage: TPackage;
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

    SectionName := 'PACKAGES';
    if ReadEndOfSection(ALine, ErrorLine, SectionName, Unhandled) then
    begin
      Exit;
    end;

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, SectionName) then
    begin
      // do nothing
    end
    else if FSplitter.Count >= 2 then
    begin
      APackage := TPackage.Create;
      FPackages.Add(APackage);
      APackage.FileType := UpperCase(FSplitter[0]);
      APackage.FileName := FSplitter[1];
      if FSplitter.Count >= 3 then
      begin
        APackage.PackageName := FSplitter[2];
      end
      else
      begin
        PackageCount := 0;
        for PackageIndex := 0 to FPackages.Count - 1 do
        begin
          ExistingPackage := FPackages[PackageIndex];
          if APackage.FileType = ExistingPackage.FileType then
          begin
            Inc(PackageCount);
          end;
        end;
        APackage.PackageName :=
          Copy(APackage.FileType, 1, Length(APackage.FileType)-1)
          + '-' + IntToStr(PackageCount);
      end;

      if FValidPackageTypes.IndexOf(APackage.FileType) < 0 then
      begin
        Unhandled.WriteLine('Unrecognized package type in the following line.');
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine('Error reading the following model line.');
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TFlowPackages }

procedure TFlowPackages.Initialize;
begin
  inherited;
  FValidPackageTypes.Add('DIS6');
  FValidPackageTypes.Add('DISV6');
  FValidPackageTypes.Add('DISU6');
  FValidPackageTypes.Add('IC6');
  FValidPackageTypes.Add('OC6');
  FValidPackageTypes.Add('NPF6');
  FValidPackageTypes.Add('STO6');
  FValidPackageTypes.Add('CSUB6');
  FValidPackageTypes.Add('BUY6');
  FValidPackageTypes.Add('VSC6');
  FValidPackageTypes.Add('HFB6');
  FValidPackageTypes.Add('CHD6');
  FValidPackageTypes.Add('WEL6');
  FValidPackageTypes.Add('DRN6');
  FValidPackageTypes.Add('RIV6');
  FValidPackageTypes.Add('GHB6');
  FValidPackageTypes.Add('RCH6');
  FValidPackageTypes.Add('EVT6');
  FValidPackageTypes.Add('MAW6');
  FValidPackageTypes.Add('SFR6');
  FValidPackageTypes.Add('LAK6');
  FValidPackageTypes.Add('UZF6');
  FValidPackageTypes.Add('MVR6');
  FValidPackageTypes.Add('GNC6');
  FValidPackageTypes.Add('OBS6');
  FValidPackageTypes.Add('GWF6-GWF6');
end;

{ TTransportPackages }

procedure TTransportPackages.Initialize;
begin
  inherited;
  FValidPackageTypes.Add('DIS6');
  FValidPackageTypes.Add('DISV6');
  FValidPackageTypes.Add('DISU6');
  FValidPackageTypes.Add('FMI6');
  FValidPackageTypes.Add('IC6');
  FValidPackageTypes.Add('OC6');
  FValidPackageTypes.Add('ADV6');
  FValidPackageTypes.Add('DSP6');
  FValidPackageTypes.Add('SSM6');
  FValidPackageTypes.Add('MST6');
  FValidPackageTypes.Add('IST6');
  FValidPackageTypes.Add('CNC6');
  FValidPackageTypes.Add('SRC6');
  FValidPackageTypes.Add('LKT6');
  FValidPackageTypes.Add('SFT6');
  FValidPackageTypes.Add('MWT6');
  FValidPackageTypes.Add('UZT6');
  FValidPackageTypes.Add('MVT6');
  FValidPackageTypes.Add('OBS6');
  FValidPackageTypes.Add('GWT6-GWT6');
end;

{ TNameFile<Options, Packages> }

constructor TNameFile<Options, Packages>.Create(PackageType: string);
begin
  inherited;
  FOptions := Options.Create(PackageType);
  FPackages := Packages.Create(PackageType);
  FOCPackage := nil;
  FFmiPackage := nil;
  FSpeciesName := '';
end;

destructor TNameFile<Options, Packages>.Destroy;
begin
  FPackages.Free;
  FOptions.Free;
  inherited;
end;

function TNameFile<Options, Packages>.GetMwePackage: TPackageReader;
begin
  result := GetPackageReader('MWE6');
end;

function TNameFile<Options, Packages>.GetMwtPackage: TPackageReader;
begin
  result := GetPackageReader('MWT6');
end;

function TNameFile<Options, Packages>.GetPackageReader(
  const PackageName: string): TPackageReader;
var
  APackage: TPackage;
begin
  result := nil;
  for var PackageIndex := 0 to NfPackages.Count  - 1 do
  begin
    APackage := NfPackages.Items[PackageIndex];
    if APackage.FileType = PackageName then
    begin
      Result := APackage.Package;
      Exit;
    end;
  end;
end;

function TNameFile<Options, Packages>.GetSsmPackage: TPackageReader;
begin
  result := GetPackageReader('SSM6');
end;

procedure TNameFile<Options, Packages>.Read(Stream: TStreamReader;
  Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
begin
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
    if Pos('BEGIN', ALine) = 1 then
    begin
      if Trim(Copy(ALine,Length('BEGIN')+1,1)) <> '' then
      begin
        Unhandled.WriteLine(StrUnrecognizedNameOption);
        Unhandled.WriteLine(ErrorLine);
        Continue;
      end;
      ALine := Trim(Copy(ALine, Length('BEGIN')+1, MaxInt)) ;
      if Pos('OPTIONS', ALine) = 1 then
      begin
        if Trim(Copy(ALine,Length('OPTIONS')+1,1)) <> '' then
        begin
          Unhandled.WriteLine(StrUnrecognizedNameOption);
          Unhandled.WriteLine(ErrorLine);
          Continue;
        end;
        FOptions.Read(Stream, Unhandled)
      end
      else if Pos('PACKAGES', ALine) = 1 then
      begin
        if Trim(Copy(ALine,Length('PACKAGES')+1,1)) <> '' then
        begin
          Unhandled.WriteLine(StrUnrecognizedNameOption);
          Unhandled.WriteLine(ErrorLine);
          Continue;
        end;
        FPackages.Read(Stream, Unhandled)
      end
      else
      begin
        Unhandled.WriteLine(StrUnrecognizedNameOption);
        Unhandled.WriteLine(ErrorLine);
      end;
    end;
  end;
end;

procedure TNameFile<Options, Packages>.ReadInput(Unhandled: TStreamWriter; const NPER: Integer);
var
  PackageIndex: Integer;
  APackage: TPackage;
  DisReader: TDis;
  DisvReader: TDisv;
  DisuReader: TDisu;
  IcReader: TIc;
  OcReader: TOc;
  GwfObsReader: TObs;
  NpfReader: TNpf;
  HfbReader: THfb;
  StoReader: TSto;
  CSubReader: TCSub;
  BuyReader: TBuy;
  VscReader: TVsc;
  ChdReader: TChd;
  WelReader: TWel;
  DrnReader: TDrn;
  RivReader: TRiv;
  RchReader: TRch;
  EvtReader: TEvt;
  MawReader: TMaw;
  SfrReader: TSfr;
  GhbReader: TGhb;
  LakReader: TLak;
  UzfReader: TUzf;
  MvrReader: TMvr;
  GncReader: TGnc;
  GwfGwfReader: TGwfGwf;
  GwtGwtReader: TGwtGwt;
  AdvReader: TAdv;
  DspReader: TDsp;
  SsmReader: TSsm;
  MstReader: TMst;
  IstReader: TIst;
  SrcReader: TSrc;
  CncReader: TCnc;
  SftReader: TSft;
  LktReader: TLkt;
  MwtReader: TMwt;
  UzwtReader: TUzt;
  FmiReader: TFmi;
  MvtReader: TMvt;
  CndReader: TCnd;
  EstReader: TEst;
  CtpReader: TCtp;
  EslReader: TEsl;
  SfeReader: TSfe;
  LkeReader: TLke;
  MweReader: TMwe;
  UzeReader: TUze;
  GweGweReader: TGweGwe;
  MipReader: TMip;
  PrpReader: TPrp;
begin
  // First read discretization
  FDimensions.Initialize;
  for PackageIndex := 0 to FPackages.FPackages.Count - 1 do
  begin
    APackage := FPackages.FPackages[PackageIndex];
    if (APackage.FileType = 'DIS6') then
    begin
      DisReader := TDis.Create(APackage.FileType);
      APackage.Package := DisReader;
      DisReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.ReadPackage(Unhandled, NPER);
      FDimensions := DisReader.Dimensions;
      Break;
    end
    else if (APackage.FileType = 'DISV6') then
    begin
      DisvReader := TDisv.Create(APackage.FileType);
      APackage.Package := DisvReader;
      DisvReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.ReadPackage(Unhandled, NPER);
      FDimensions := DisvReader.Dimensions;
      Break;
    end
    else if (APackage.FileType = 'DISU6') then
    begin
      DisuReader := TDisu.Create(APackage.FileType);
      APackage.Package := DisuReader;
      DisuReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.ReadPackage(Unhandled, NPER);
      FDimensions := DisuReader.Dimensions;
      Break;
    end;
  end;
  for PackageIndex := 0 to FPackages.FPackages.Count - 1 do
  begin
    APackage := FPackages.FPackages[PackageIndex];
    if (APackage.FileType = 'DIS6')
      or (APackage.FileType = 'DISV6')
      or (APackage.FileType = 'DISU6') then
    begin
      Continue;
    end;

    if APackage.FileType = 'IC6' then
    begin
      IcReader := TIc.Create(APackage.FileType);
      IcReader.OnUpdataStatusBar := OnUpdataStatusBar;
      IcReader.Dimensions := FDimensions;
      APackage.Package := IcReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'OC6' then
    begin
      OcReader := TOc.Create(APackage.FileType);
      OcReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.Package := OcReader;
      APackage.ReadPackage(Unhandled, NPER);
      FOCPackage := APackage;
    end
    else if APackage.FileType = 'OBS6' then
    begin
      GwfObsReader := TObs.Create(APackage.FileType);
      GwfObsReader.OnUpdataStatusBar := OnUpdataStatusBar;
      GwfObsReader.Dimensions := FDimensions;
      APackage.Package := GwfObsReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'NPF6' then
    begin
      NpfReader := TNpf.Create(APackage.FileType);
      NpfReader.OnUpdataStatusBar := OnUpdataStatusBar;
      NpfReader.Dimensions := FDimensions;
      APackage.Package := NpfReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'HFB6' then
    begin
      HfbReader := THfb.Create(APackage.FileType);
      HfbReader.OnUpdataStatusBar := OnUpdataStatusBar;
      HfbReader.Dimensions := FDimensions;
      APackage.Package := HfbReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'STO6' then
    begin
      StoReader := TSto.Create(APackage.FileType);
      StoReader.OnUpdataStatusBar := OnUpdataStatusBar;
      StoReader.Dimensions := FDimensions;
      APackage.Package := StoReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'CSUB6' then
    begin
      CSubReader := TCSub.Create(APackage.FileType);
      CSubReader.OnUpdataStatusBar := OnUpdataStatusBar;
      CSubReader.Dimensions := FDimensions;
      APackage.Package := CSubReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'BUY6' then
    begin
      BuyReader := TBuy.Create(APackage.FileType);
      BuyReader.OnUpdataStatusBar := OnUpdataStatusBar;
      BuyReader.Dimensions := FDimensions;
      APackage.Package := BuyReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'VSC6' then
    begin
      VscReader := TVsc.Create(APackage.FileType);
      VscReader.OnUpdataStatusBar := OnUpdataStatusBar;
      VscReader.Dimensions := FDimensions;
      APackage.Package := VscReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'CHD6' then
    begin
      ChdReader := TChd.Create(APackage.FileType);
      ChdReader.OnUpdataStatusBar := OnUpdataStatusBar;
      ChdReader.Dimensions := FDimensions;
      APackage.Package := ChdReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'WEL6' then
    begin
      WelReader := TWel.Create(APackage.FileType);
      WelReader.OnUpdataStatusBar := OnUpdataStatusBar;
      WelReader.Dimensions := FDimensions;
      APackage.Package := WelReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'DRN6' then
    begin
      DrnReader := TDrn.Create(APackage.FileType);
      DrnReader.OnUpdataStatusBar := OnUpdataStatusBar;
      DrnReader.Dimensions := FDimensions;
      APackage.Package := DrnReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'GHB6' then
    begin
      GhbReader := TGhb.Create(APackage.FileType);
      GhbReader.OnUpdataStatusBar := OnUpdataStatusBar;
      GhbReader.Dimensions := FDimensions;
      APackage.Package := GhbReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'RIV6' then
    begin
      RivReader := TRiv.Create(APackage.FileType);
      RivReader.OnUpdataStatusBar := OnUpdataStatusBar;
      RivReader.Dimensions := FDimensions;
      APackage.Package := RivReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'RCH6' then
    begin
      RchReader := TRch.Create(APackage.FileType);
      RchReader.OnUpdataStatusBar := OnUpdataStatusBar;
      RchReader.Dimensions := FDimensions;
      APackage.Package := RchReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'EVT6' then
    begin
      EvtReader := TEvt.Create(APackage.FileType);
      EvtReader.OnUpdataStatusBar := OnUpdataStatusBar;
      EvtReader.Dimensions := FDimensions;
      APackage.Package := EvtReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'MAW6' then
    begin
      MawReader := TMaw.Create(APackage.FileType);
      MawReader.OnUpdataStatusBar := OnUpdataStatusBar;
      MawReader.Dimensions := FDimensions;
      APackage.Package := MawReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'SFR6' then
    begin
      SfrReader := TSfr.Create(APackage.FileType);
      SfrReader.OnUpdataStatusBar := OnUpdataStatusBar;
      SfrReader.Dimensions := FDimensions;
      APackage.Package := SfrReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'LAK6' then
    begin
      LakReader := TLak.Create(APackage.FileType);
      LakReader.OnUpdataStatusBar := OnUpdataStatusBar;
      LakReader.Dimensions := FDimensions;
      APackage.Package := LakReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'UZF6' then
    begin
      UzfReader := TUzf.Create(APackage.FileType);
      UzfReader.OnUpdataStatusBar := OnUpdataStatusBar;
      UzfReader.Dimensions := FDimensions;
      APackage.Package := UzfReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'MVR6' then
    begin
      MvrReader := TMvr.Create(APackage.FileType);
      MvrReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.Package := MvrReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'GNC6' then
    begin
      GncReader := TGnc.Create(APackage.FileType);
      GncReader.OnUpdataStatusBar := OnUpdataStatusBar;
      GncReader.Dimensions := FDimensions;
      APackage.Package := GncReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'GWF6-GWF6' then
    begin
      GwfGwfReader := TGwfGwf.Create(APackage.FileType);
      GwfGwfReader.OnUpdataStatusBar := OnUpdataStatusBar;
      GwfGwfReader.Dimensions := FDimensions;
      GwfGwfReader.FDimensions2 := FDimensions;
      APackage.Package := GwfGwfReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'GWT6-GWT6' then
    begin
      GwtGwtReader := TGwtGwt.Create(APackage.FileType);
      GwtGwtReader.OnUpdataStatusBar := OnUpdataStatusBar;
      GwtGwtReader.Dimensions := FDimensions;
      GwtGwtReader.FDimensions2 := FDimensions;
      APackage.Package := GwtGwtReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'ADV6' then
    begin
      AdvReader := TAdv.Create(APackage.FileType);
      AdvReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.Package := AdvReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'DSP6' then
    begin
      DspReader := TDsp.Create(APackage.FileType);
      DspReader.OnUpdataStatusBar := OnUpdataStatusBar;
      DspReader.Dimensions := FDimensions;
      APackage.Package := DspReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'SSM6' then
    begin
      SsmReader := TSsm.Create(APackage.FileType);
      SsmReader.OnUpdataStatusBar := OnUpdataStatusBar;
      SsmReader.Dimensions := FDimensions;
      APackage.Package := SsmReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'MST6' then
    begin
      MstReader := TMst.Create(APackage.FileType);
      MstReader.OnUpdataStatusBar := OnUpdataStatusBar;
      MstReader.Dimensions := FDimensions;
      APackage.Package := MstReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'IST6' then
    begin
      IstReader := TIst.Create(APackage.FileType);
      IstReader.OnUpdataStatusBar := OnUpdataStatusBar;
      IstReader.Dimensions := FDimensions;
      APackage.Package := IstReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'CNC6' then
    begin
      CncReader := TCnc.Create(APackage.FileType);
      CncReader.OnUpdataStatusBar := OnUpdataStatusBar;
      CncReader.Dimensions := FDimensions;
      APackage.Package := CncReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'SRC6' then
    begin
      SrcReader := TSrc.Create(APackage.FileType);
      SrcReader.OnUpdataStatusBar := OnUpdataStatusBar;
      SrcReader.Dimensions := FDimensions;
      APackage.Package := SrcReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'SFT6' then
    begin
      SftReader := TSft.Create(APackage.FileType);
      SftReader.OnUpdataStatusBar := OnUpdataStatusBar;
      SftReader.Dimensions := FDimensions;
      APackage.Package := SftReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'LKT6' then
    begin
      LktReader := TLkt.Create(APackage.FileType);
      LktReader.OnUpdataStatusBar := OnUpdataStatusBar;
      LktReader.Dimensions := FDimensions;
      APackage.Package := LktReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'MWT6' then
    begin
      MwtReader := TMwt.Create(APackage.FileType);
      MwtReader.OnUpdataStatusBar := OnUpdataStatusBar;
      MwtReader.Dimensions := FDimensions;
      APackage.Package := MwtReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'UZT6' then
    begin
      UzwtReader := TUzt.Create(APackage.FileType);
      UzwtReader.OnUpdataStatusBar := OnUpdataStatusBar;
      UzwtReader.Dimensions := FDimensions;
      APackage.Package := UzwtReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'FMI6' then
    begin
      FmiReader := TFmi.Create(APackage.FileType);
      FmiReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.Package := FmiReader;
      APackage.ReadPackage(Unhandled, NPER);
      FFmiPackage := APackage;
    end
    else if APackage.FileType = 'MVT6' then
    begin
      MvtReader := TMvt.Create(APackage.FileType);
      MvtReader.OnUpdataStatusBar := OnUpdataStatusBar;
      APackage.Package := MvtReader;
      APackage.ReadPackage(Unhandled, NPER);
    end

    else if APackage.FileType = 'CND6' then
    begin
      CndReader := TCnd.Create(APackage.FileType);
      CndReader.OnUpdataStatusBar := OnUpdataStatusBar;
      CndReader.Dimensions := FDimensions;
      APackage.Package := CndReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'EST6' then
    begin
      EstReader := TEst.Create(APackage.FileType);
      EstReader.OnUpdataStatusBar := OnUpdataStatusBar;
      EstReader.Dimensions := FDimensions;
      APackage.Package := EstReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'CTP6' then
    begin
      CtpReader := TCtp.Create(APackage.FileType);
      CtpReader.OnUpdataStatusBar := OnUpdataStatusBar;
      CtpReader.Dimensions := FDimensions;
      APackage.Package := CtpReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'ESL6' then
    begin
      EslReader := TEsl.Create(APackage.FileType);
      EslReader.OnUpdataStatusBar := OnUpdataStatusBar;
      EslReader.Dimensions := FDimensions;
      APackage.Package := EslReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'SFE6' then
    begin
      SfeReader := TSfe.Create(APackage.FileType);
      SfeReader.OnUpdataStatusBar := OnUpdataStatusBar;
      SfeReader.Dimensions := FDimensions;
      APackage.Package := SfeReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'LKE6' then
    begin
      LkeReader := TLke.Create(APackage.FileType);
      LkeReader.OnUpdataStatusBar := OnUpdataStatusBar;
      LkeReader.Dimensions := FDimensions;
      APackage.Package := LkeReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'MWE6' then
    begin
      MweReader := TMwe.Create(APackage.FileType);
      MweReader.OnUpdataStatusBar := OnUpdataStatusBar;
      MweReader.Dimensions := FDimensions;
      APackage.Package := MweReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'UZE6' then
    begin
      UzeReader := TUze.Create(APackage.FileType);
      UzeReader.OnUpdataStatusBar := OnUpdataStatusBar;
      UzeReader.Dimensions := FDimensions;
      APackage.Package := UzeReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'GWE6-GWE6' then
    begin
      GweGweReader := TGweGwe.Create(APackage.FileType);
      GweGweReader.OnUpdataStatusBar := OnUpdataStatusBar;
      GweGweReader.Dimensions := FDimensions;
      GweGweReader.FDimensions2 := FDimensions;
      APackage.Package := GweGweReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'MIP6' then
    begin
      MipReader := TMip.Create(APackage.FileType);
      MipReader.OnUpdataStatusBar := OnUpdataStatusBar;
      MipReader.Dimensions := FDimensions;
      APackage.Package := MipReader;
      APackage.ReadPackage(Unhandled, NPER);
    end
    else if APackage.FileType = 'PRP6' then
    begin
      PrpReader := TPrp.Create(APackage.FileType);
      PrpReader.OnUpdataStatusBar := OnUpdataStatusBar;
      PrpReader.Dimensions := FDimensions;
      APackage.Package := PrpReader;
      APackage.ReadPackage(Unhandled, NPER);
    end

    else
    begin
      Unhandled.WriteLine('Unhandled package type');
      Unhandled.WriteLine(APackage.FileType);
    end;
  end;
end;

procedure TNameFile<Options, Packages>.SetOnUpdataStatusBar(
  const Value: TOnUpdataStatusBar);
begin
  inherited;
  FOptions.OnUpdataStatusBar := OnUpdataStatusBar;
  FPackages.OnUpdataStatusBar := OnUpdataStatusBar;
end;

{ TEnergyTransportPackages }

procedure TEnergyTransportPackages.Initialize;
begin
  inherited;
  FValidPackageTypes.Add('DIS6');
  FValidPackageTypes.Add('DISV6');
  FValidPackageTypes.Add('DISU6');
  FValidPackageTypes.Add('FMI6');
  FValidPackageTypes.Add('IC6');
  FValidPackageTypes.Add('OC6');
  FValidPackageTypes.Add('ADV6');
  FValidPackageTypes.Add('CND6');
  FValidPackageTypes.Add('SSM6');
  FValidPackageTypes.Add('EST6');
  FValidPackageTypes.Add('CTP6');
  FValidPackageTypes.Add('ESL6');
  FValidPackageTypes.Add('LKE6');
  FValidPackageTypes.Add('SFE6');
  FValidPackageTypes.Add('MWE6');
  FValidPackageTypes.Add('UZE6');
  FValidPackageTypes.Add('MVE6');
  FValidPackageTypes.Add('OBS6');
  FValidPackageTypes.Add('GWE6-GWE6');
end;

{ TPrtPackages }

procedure TPrtPackages.Initialize;
begin
  inherited;
  FValidPackageTypes.Add('DIS6');
  FValidPackageTypes.Add('DISV6');
  FValidPackageTypes.Add('MIP6');
  FValidPackageTypes.Add('FMI6');
  FValidPackageTypes.Add('PRP6');
  FValidPackageTypes.Add('OC6');
end;

end.
