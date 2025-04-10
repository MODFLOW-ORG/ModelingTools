unit MF6.EstFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections;

type
  TEstOptions = class(TCustomMf6Persistent)
  private
    SAVE_FLOWS: Boolean;
    FZERO_ORDER_DECAY_WATER: Boolean;
    FZERO_ORDER_DECAY_SOLID: Boolean;
    FDENSITY_WATER: Extended;
    FLATENT_HEAT_VAPORIZATION: Extended;
    FHEAT_CAPACITY_WATER: Extended;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  public
    property ZERO_ORDER_DECAY_WATER: Boolean read FZERO_ORDER_DECAY_WATER;
    property ZERO_ORDER_DECAY_SOLID: Boolean read FZERO_ORDER_DECAY_SOLID;
    property DENSITY_WATER: Extended read FDENSITY_WATER;
    property HEAT_CAPACITY_WATER: Extended read FHEAT_CAPACITY_WATER;
    property LATENT_HEAT_VAPORIZATION: Extended read FLATENT_HEAT_VAPORIZATION;
  end;

  TEstGridData = class(TCustomMf6Persistent)
  private
    FDimensions: TDimensions;
    FPOROSITY: TDArray3D;
    FDECAY_SOLID: TDArray3D;
    FDENSITY_SOLID: TDArray3D;
    FDECAY_WATER: TDArray3D;
    FHEAT_CAPACITY_SOLID: TDArray3D;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; Dimensions: TDimensions);
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    property POROSITY: TDArray3D read FPOROSITY;
    property DECAY_WATER: TDArray3D read FDECAY_WATER;
    property DECAY_SOLID: TDArray3D read FDECAY_SOLID;
    property HEAT_CAPACITY_SOLID: TDArray3D read FHEAT_CAPACITY_SOLID;
    property DENSITY_SOLID: TDArray3D read FDENSITY_SOLID;
  end;

  TEst = class(TDimensionedPackageReader)
  private
    FOptions: TEstOptions;
    FGridData: TEstGridData;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter;
      const NPER: Integer); override;
    property Options: TEstOptions read FOptions;
    property GridData: TEstGridData read FGridData;
  end;


implementation

uses
  ModelMuseUtilities;

{ TEstOptions }

procedure TEstOptions.Initialize;
begin
  inherited;
  SAVE_FLOWS := False;
  FZERO_ORDER_DECAY_WATER := False;
  FZERO_ORDER_DECAY_SOLID := False;
  FDENSITY_WATER := 1000;
  FHEAT_CAPACITY_WATER := 4184;
  FLATENT_HEAT_VAPORIZATION := 2453500;

end;

procedure TEstOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
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
    if ReadEndOfSection(ALine, ErrorLine, 'OPTIONS', Unhandled) then
    begin
      Exit
    end;

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'OPTIONS') then
    begin
      // do nothing
    end
    else if FSplitter[0] = 'SAVE_FLOWS' then
    begin
      SAVE_FLOWS := True;
    end
    else if FSplitter[0] = 'ZERO_ORDER_DECAY_WATER' then
    begin
      FZERO_ORDER_DECAY_WATER := True;
    end
    else if FSplitter[0] = 'ZERO_ORDER_DECAY_SOLID' then
    begin
      FZERO_ORDER_DECAY_SOLID := True;
    end
    else if (FSplitter[0] = 'DENSITY_WATER') and (FSplitter.Count >= 2) then
    begin
      if not TryFortranStrToFloat(FSplitter[1], FDENSITY_WATER) then
      begin
        Unhandled.WriteLine(Format('Invalid value for %s in %s', ['DENSITY_WATER', FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else if (FSplitter[0] = 'HEAT_CAPACITY_WATER') and (FSplitter.Count >= 2) then
    begin
      if not TryFortranStrToFloat(FSplitter[1], FHEAT_CAPACITY_WATER) then
      begin
        Unhandled.WriteLine(Format('Invalid value for %s in %s', ['HEAT_CAPACITY_WATER', FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else if (FSplitter[0] = 'LATENT_HEAT_VAPORIZATION') and (FSplitter.Count >= 2) then
    begin
      if not TryFortranStrToFloat(FSplitter[1], FLATENT_HEAT_VAPORIZATION) then
      begin
        Unhandled.WriteLine(Format('Invalid value for %s in %s', ['LATENT_HEAT_VAPORIZATION', FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ TEstGridData }

constructor TEstGridData.Create(PackageType: string);
begin
  inherited;
  FDimensions.Initialize;
end;

procedure TEstGridData.Initialize;
begin
  inherited;
  SetLength(FPOROSITY, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
  SetLength(FDENSITY_SOLID, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
  SetLength(FHEAT_CAPACITY_SOLID, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
  SetLength(FDECAY_SOLID, 0);
  SetLength(FDECAY_WATER, 0);
end;

procedure TEstGridData.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  Dimensions: TDimensions);
var
  ALine: string;
  ErrorLine: string;
  Layered: Boolean;
  DoubleThreeDReader: TDouble3DArrayReader;
begin
  FDimensions := Dimensions;
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

    if ReadEndOfSection(ALine, ErrorLine, 'GRIDDATA', Unhandled) then
    begin
      Exit;
    end;

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, 'GRIDDATA') then
    begin
      // do nothing
    end
    else if FSplitter[0] = 'POROSITY' then
    begin
//      SetLength(POROSITY, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FPOROSITY := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else if FSplitter[0] = 'DECAY_WATER' then
    begin
      SetLength(FDECAY_WATER, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FDECAY_WATER := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else if FSplitter[0] = 'DECAY_SOLID' then
    begin
      SetLength(FDECAY_SOLID, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FDECAY_SOLID := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else if FSplitter[0] = 'HEAT_CAPACITY_SOLID' then
    begin
//      SetLength(FHEAT_CAPACITY_SOLID, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FHEAT_CAPACITY_SOLID := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else if FSplitter[0] = 'DENSITY_SOLID' then
    begin
//      SetLength(FDENSITY_SOLID, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FDENSITY_SOLID := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedSGRID, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TEst }

constructor TEst.Create(PackageType: string);
begin
  inherited;
  FOptions := TEstOptions.Create(PackageType);
  FGridData := TEstGridData.Create(PackageType);
end;

destructor TEst.Destroy;
begin
  FOptions.Free;
  FGridData.Free;
  inherited;
end;

procedure TEst.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  const NPER: Integer);
var
  ALine: string;
  ErrorLine: string;
begin
  if Assigned(OnUpdataStatusBar) then
  begin
    OnUpdataStatusBar(self, 'reading EST package');
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
      else if FSplitter[1] ='GRIDDATA' then
      begin
        FGridData.Read(Stream, Unhandled, FDimensions);
      end
      else
      begin
        Unhandled.WriteLine(Format(StrUnrecognizedSSect, [FPackageType]));
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedSSect, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

end.
