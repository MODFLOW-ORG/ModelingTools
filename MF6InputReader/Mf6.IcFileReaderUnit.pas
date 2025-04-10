unit Mf6.IcFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections;

type
  TIcOptions = class(TCustomMf6Persistent)
  private
    FEXPORT_ARRAY_NETCDF: Boolean;
    FEXPORT_ARRAY_ASCII: Boolean;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  public
    property EXPORT_ARRAY_ASCII: Boolean read FEXPORT_ARRAY_ASCII;
    property EXPORT_ARRAY_NETCDF: Boolean read FEXPORT_ARRAY_NETCDF;
  end;

  TIcGridData = class(TCustomMf6Persistent)
  private
    FSTRT: TDArray3D;
    FDimensions: TDimensions;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; Dimensions: TDimensions);
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    property STRT: TDArray3D read FSTRT;
  end;

  TIc = class(TDimensionedPackageReader)
  private
    FOptions: TIcOptions;
    FGridData: TIcGridData;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer); override;
    property Options: TIcOptions read FOptions;
    property GridData: TIcGridData read FGridData;
  end;

implementation

resourcestring
  StrUnrecognizedICOpti = 'Unrecognized IC option in the following line.';

{ TIcGridData }

constructor TIcGridData.Create(PackageType: string);
begin
  FDimensions.Initialize;
  inherited;

end;

procedure TIcGridData.Initialize;
begin
  SetLength(FSTRT, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
  inherited;
end;

procedure TIcGridData.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  Dimensions: TDimensions);
var
  ALine: string;
  ErrorLine: string;
  SectionName: string;
  Layered: Boolean;
  ThreeDReader: TDouble3DArrayReader;
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

    SectionName := 'GRIDDATA';
    if ReadEndOfSection(ALine, ErrorLine, SectionName, Unhandled) then
    begin
      Exit;
    end;

    if SwitchToAnotherFile(Stream, ErrorLine, Unhandled, ALine, SectionName) then
    begin
      // do nothing
    end
    else if FSplitter[0] = 'STRT' then
    begin
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      ThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        ThreeDReader.Read(Stream, Unhandled);
        FSTRT := ThreeDReader.FData;
      finally
        ThreeDReader.Free;
      end;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized IC GRIDDATA in the following line');
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TIc }

constructor TIc.Create(PackageType: string);
begin
  FOptions := TIcOptions.Create(PackageType);;
  FGridData := TIcGridData.Create(PackageType);
  inherited;

end;

destructor TIc.Destroy;
begin
  FOptions.Free;
  FGridData.Free;
  inherited;
end;

procedure TIc.Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer);
var
  ALine: string;
  ErrorLine: string;
begin
  if Assigned(OnUpdataStatusBar) then
  begin
    OnUpdataStatusBar(self, 'reading IC package');
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
        Unhandled.WriteLine(StrUnrecognizedICOpti);
        Unhandled.WriteLine(ErrorLine);
      end;
    end;
  end;
end;

{ TIcOptions }

procedure TIcOptions.Initialize;
begin
  inherited;
  FEXPORT_ARRAY_NETCDF := False;
  FEXPORT_ARRAY_ASCII := False;
end;

procedure TIcOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
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
    else if FSplitter[0] = 'EXPORT_ARRAY_ASCII' then
    begin
      FEXPORT_ARRAY_ASCII := True;
    end
    else if FSplitter[0] = 'EXPORT_ARRAY_NETCDF' then
    begin
      FEXPORT_ARRAY_NETCDF := True;
      Unhandled.WriteLine(Format('The EXPORT_ARRAY_NETCDF in %s is not handled by this program.', [FPackageType]));
    end
    else
    begin
      Unhandled.WriteLine(Format(StrUnrecognizedOpti, [FPackageType]));
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

end.
