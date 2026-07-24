unit Mfy.MipFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, Mf6.CustomMf6PersistentUnit,
  System.Generics.Collections, System.Generics.Defaults;

type
  TMipOptions = class(TCustomMf6Persistent)
  private
    FEXPORT_ARRAY_ASCII: Boolean;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  public
    property EXPORT_ARRAY_ASCII: Boolean read FEXPORT_ARRAY_ASCII;
  end;

  TMipGridData = class(TCustomMf6Persistent)
  private
    FPOROSITY: TDArray3D;
    FRETFACTOR: TDArray3D;
    FIZONE: TIArray3D;
    FDimensions: TDimensions;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter;
      Dimensions: TDimensions);
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    property POROSITY: TDArray3D read FPOROSITY;
    property RETFACTOR: TDArray3D read FRETFACTOR;
    property IZONE: TIArray3D read FIZONE;
  end;

  TMip = class(TDimensionedPackageReader)
  private
    FOptions: TMipOptions;
    FGridData: TMipGridData;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; const NPER: Integer); override;
    property Options: TMipOptions read FOptions;
    property GridData: TMipGridData read FGridData;
  end;

implementation

{ TMipOptions }

procedure TMipOptions.Initialize;
begin
  inherited;
  FEXPORT_ARRAY_ASCII := False;
end;

procedure TMipOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  CaseSensitiveLine: string;
  TVS6_FileName: string;
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
    else
    begin
      Unhandled.WriteLine('Unrecognized MIP option in the following line.');
      Unhandled.WriteLine(ErrorLine);
    end;
  end

end;

{ TMipGridData }

constructor TMipGridData.Create(PackageType: string);
begin
  FDimensions.Initialize;
  inherited;

end;

procedure TMipGridData.Initialize;
begin
  inherited;
  SetLength(FPOROSITY, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
end;

procedure TMipGridData.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  Dimensions: TDimensions);
var
  ALine: string;
  ErrorLine: string;
  Layered: Boolean;
  DoubleThreeDReader: TDouble3DArrayReader;
  IntThreeDReader: TInteger3DArrayReader;
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
    else if FSplitter[0] = 'IZONE' then
    begin
      SetLength(FIZONE, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      IntThreeDReader := TInteger3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        IntThreeDReader.Read(Stream, Unhandled);
        FIZONE := IntThreeDReader.FData;
      finally
        IntThreeDReader.Free;
      end;
    end
    else if FSplitter[0] = 'POROSITY' then
    begin
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FPOROSITY := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else if FSplitter[0] = 'RETFACTOR' then
    begin
      SetLength(FRETFACTOR, FDimensions.NLay, FDimensions.NRow, FDimensions.NCol);
      Layered := (FSplitter.Count >= 2) and (FSplitter[1] = 'LAYERED');
      DoubleThreeDReader := TDouble3DArrayReader.Create(FDimensions, Layered, FPackageType);
      try
        DoubleThreeDReader.Read(Stream, Unhandled);
        FRETFACTOR := DoubleThreeDReader.FData;
      finally
        DoubleThreeDReader.Free;
      end;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized MIP GRIDDATA in the following line');
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;

{ TMip }

constructor TMip.Create(PackageType: string);
begin
  inherited;
  FOptions := TMipOptions.Create(PackageType);
  FGridData := TMipGridData.Create(PackageType);

end;

destructor TMip.Destroy;
begin
  FOptions.Free;
  FGridData.Free;
  inherited;
end;

procedure TMip.Read(Stream: TStreamReader; Unhandled: TStreamWriter;
  const NPER: Integer);
var
  ALine: string;
  ErrorLine: string;
begin
  if Assigned(OnUpdataStatusBar) then
  begin
    OnUpdataStatusBar(self, 'reading STO package');
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
        Unhandled.WriteLine('Unrecognized MIP data in the following line.');
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized MIP section on the following Line');
      Unhandled.WriteLine(ErrorLine);
    end;
  end;
end;
end.
