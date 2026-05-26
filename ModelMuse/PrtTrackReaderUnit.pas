unit PrtTrackReaderUnit;

interface

uses
  System.Classes, GoPhastTypes, System.AnsiStrings, System.IOUtils,
  System.SysUtils;

type
  TPrtTrackPointRecord = record
    KPER: Integer;
    KSTP: Integer;
    IMDL: Integer;
    IPRP: Integer;
    IRPT: Integer;
    ILAY: Integer;
    ICELL: Integer;
    IZONE: Integer;
    ISTATUS: Integer;
    IREASON: Integer;
    TRELEASE: double;
    T: double;
    X: double;
    Y: double;
    Z: double;
    NAME: array[0..39] of AnsiChar;
  end;

  TPrtTrackPoint = class(TCollectionItem)
  private
    FICELL: Integer;
    FILAY: Integer;
    FIZONE: Integer;
    FStoredT: TRealStorage;
    FIPRP: Integer;
    FKSTP: Integer;
    FIRPT: Integer;
    FISTATUS: integer;
    FStoredTRELEASE: TRealStorage;
    FIREASON: Integer;
    FStoredZ: TRealStorage;
    FIMDL: Integer;
    FStoredX: TRealStorage;
    FStoredY: TRealStorage;
    FKPER: Integer;
    FNAME: string;
    procedure SetICELL(const Value: Integer);
    procedure SetILAY(const Value: Integer);
    procedure SetIMDL(const Value: Integer);
    procedure SetIPRP(const Value: Integer);
    procedure SetIREASON(const Value: Integer);
    procedure SetIRPT(const Value: Integer);
    procedure SetISTATUS(const Value: Integer);
    procedure SetIZONE(const Value: Integer);
    procedure SetKSTP(const Value: Integer);
    procedure SetNAME(const Value: string);
    procedure SetStoredT(const Value: TRealStorage);
    procedure SetStoredTRELEASE(const Value: TRealStorage);
    procedure SetStoredX(const Value: TRealStorage);
    procedure SetStoredY(const Value: TRealStorage);
    procedure SetStoredZ(const Value: TRealStorage);
    function GetT: double;
    function GetX: double;
    function GetY: double;
    function GetZ: double;
    procedure SetKPER(const Value: Integer);
    procedure SetT(const Value: double);
    procedure SetX(const Value: double);
    procedure SetY(const Value: double);
    procedure SetZ(const Value: double);
    function GetTRELEASE: double;
    procedure SetTRELEASE(const Value: double);
  public
    Constructor Create(Collection: TCollection); override;
    Destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignRecord(ATrkPoint: TPrtTrackPointRecord);
    property TRELEASE: double read GetTRELEASE write SetTRELEASE;
    property T: double read GetT write SetT;
    property X: double read GetX write SetX;
    property Y: double read GetY write SetY;
    property Z: double read GetZ write SetZ;
  published
    property KPER: Integer read FKPER write SetKPER;
    property KSTP: Integer read FKSTP write SetKSTP;
    property IMDL: Integer read FIMDL write SetIMDL;
    property IPRP: Integer read FIPRP write SetIPRP;
    property IRPT: Integer read FIRPT write SetIRPT;
    property ILAY: Integer read FILAY write SetILAY;
    property ICELL: Integer read FICELL write SetICELL;
    property IZONE: Integer read FIZONE write SetIZONE;
    property ISTATUS: Integer read FISTATUS write SetISTATUS;
    property IREASON: Integer read FIREASON write SetIREASON;
    property StoredTRELEASE: TRealStorage read FStoredTRELEASE write SetStoredTRELEASE;
    property StoredT: TRealStorage read FStoredT write SetStoredT;
    property StoredX: TRealStorage read FStoredX write SetStoredX;
    property StoredY: TRealStorage read FStoredY write SetStoredY;
    property StoredZ: TRealStorage read FStoredZ write SetStoredZ;
    // maximum 40 characters as of MODFLOW 6.7.0
    property NAME: string read FNAME write SetName;
  end;

  TPrtTrack = class(TCollection)
  private
    function GetTrackPoint(Index: Integer): TPrtTrackPoint;
    procedure SetTrackPoint(Index: Integer; const Value: TPrtTrackPoint);
  public
    Constructor Create;
    function Add: TPrtTrackPoint;
    property Items[Index: Integer]: TPrtTrackPoint read GetTrackPoint write SetTrackPoint; default;
    procedure ReadFromCsv(const FileName: string);
    procedure ReadFromBinary(const FileName: string);
  end;

implementation

uses
  ModelMuseUtilities;

{ TPrtTrackPoint }

procedure TPrtTrackPoint.Assign(Source: TPersistent);
var
  TrackPoint: TPrtTrackPoint;
begin
  if Source is TPrtTrackPoint then
  begin
    TrackPoint := TPrtTrackPoint(Source);
    KPER := TrackPoint.KPER;
    KSTP := TrackPoint.KSTP;
    IMDL := TrackPoint.IMDL;
    IPRP := TrackPoint.IPRP;
    IRPT := TrackPoint.IRPT;
    ILAY := TrackPoint.ILAY;
    ICELL := TrackPoint.ICELL;
    IZONE := TrackPoint.IZONE;
    ISTATUS := TrackPoint.ISTATUS;
    IREASON := TrackPoint.IREASON;
    TRELEASE := TrackPoint.TRELEASE;
    T := TrackPoint.T;
    X := TrackPoint.X;
    Y := TrackPoint.Y;
    Z := TrackPoint.Z;
    NAME := TrackPoint.NAME;
  end
  else
  begin
    inherited;
  end;
end;

procedure TPrtTrackPoint.AssignRecord(ATrkPoint: TPrtTrackPointRecord);
begin
  KPER := ATrkPoint.KPER;
  KSTP := ATrkPoint.KSTP;
  IMDL := ATrkPoint.IMDL;
  IPRP := ATrkPoint.IPRP;
  IRPT := ATrkPoint.IRPT;
  ILAY := ATrkPoint.ILAY;
  ICELL := ATrkPoint.ICELL;
  IZONE := ATrkPoint.IZONE;
  ISTATUS := ATrkPoint.ISTATUS;
  IREASON := ATrkPoint.IREASON;
  TRELEASE := ATrkPoint.TRELEASE;
  T := ATrkPoint.T;
  X := ATrkPoint.X;
  Y := ATrkPoint.Y;
  Z := ATrkPoint.Z;
  NAME := string(ATrkPoint.NAME);
end;

constructor TPrtTrackPoint.Create(Collection: TCollection);
var
  OnChangeEvent: TNotifyEvent;
begin
  inherited;
  OnChangeEvent := nil;
  FStoredT := TRealStorage.Create(OnChangeEvent);
  FStoredTRELEASE := TRealStorage.Create(OnChangeEvent);
  FStoredX := TRealStorage.Create(OnChangeEvent);
  FStoredY := TRealStorage.Create(OnChangeEvent);
  FStoredZ := TRealStorage.Create(OnChangeEvent);
end;

destructor TPrtTrackPoint.Destroy;
begin
  FStoredT.Free;
  FStoredTRELEASE.Free;
  FStoredX.Free;
  FStoredY.Free;
  FStoredZ.Free;
  inherited;
end;

function TPrtTrackPoint.GetT: double;
begin
  result := StoredT.Value;
end;

function TPrtTrackPoint.GetTRELEASE: double;
begin
  result := StoredTRELEASE.Value;
end;

function TPrtTrackPoint.GetX: double;
begin
  result := StoredX.Value;
end;

function TPrtTrackPoint.GetY: double;
begin
  result := StoredY.Value;
end;

function TPrtTrackPoint.GetZ: double;
begin
  result := StoredZ.Value;
end;

procedure TPrtTrackPoint.SetICELL(const Value: Integer);
begin
  FICELL := Value;
end;

procedure TPrtTrackPoint.SetILAY(const Value: Integer);
begin
  FILAY := Value;
end;

procedure TPrtTrackPoint.SetIMDL(const Value: Integer);
begin
  FIMDL := Value;
end;

procedure TPrtTrackPoint.SetIPRP(const Value: Integer);
begin
  FIPRP := Value;
end;

procedure TPrtTrackPoint.SetIREASON(const Value: Integer);
begin
  FIREASON := Value;
end;

procedure TPrtTrackPoint.SetIRPT(const Value: Integer);
begin
  FIRPT := Value;
end;

procedure TPrtTrackPoint.SetISTATUS(const Value: Integer);
begin
  FISTATUS := Value;
end;

procedure TPrtTrackPoint.SetIZONE(const Value: Integer);
begin
  FIZONE := Value;
end;

procedure TPrtTrackPoint.SetKPER(const Value: Integer);
begin
  FKPER := Value;
end;

procedure TPrtTrackPoint.SetKSTP(const Value: Integer);
begin
  FKSTP := Value;
end;

procedure TPrtTrackPoint.SetNAME(const Value: string);
begin
  FNAME := Value;
end;

procedure TPrtTrackPoint.SetStoredT(const Value: TRealStorage);
begin
  FStoredT.Assign(Value);
end;

procedure TPrtTrackPoint.SetStoredTRELEASE(const Value: TRealStorage);
begin
  FStoredTRELEASE.Assign(Value);
end;

procedure TPrtTrackPoint.SetStoredX(const Value: TRealStorage);
begin
  FStoredX.Assign(Value);
end;

procedure TPrtTrackPoint.SetStoredY(const Value: TRealStorage);
begin
  FStoredY.Assign(Value);
end;

procedure TPrtTrackPoint.SetStoredZ(const Value: TRealStorage);
begin
  FStoredZ.Assign(Value);
end;

procedure TPrtTrackPoint.SetT(const Value: double);
begin
  StoredT.Value := Value;
end;

procedure TPrtTrackPoint.SetTRELEASE(const Value: double);
begin
  StoredTRELEASE.Value := Value;
end;

procedure TPrtTrackPoint.SetX(const Value: double);
begin
  StoredX.Value := Value;
end;

procedure TPrtTrackPoint.SetY(const Value: double);
begin
  StoredY.Value := Value;
end;

procedure TPrtTrackPoint.SetZ(const Value: double);
begin
  StoredZ.Value := Value;
end;

{ TPrtTrack }

function TPrtTrack.Add: TPrtTrackPoint;
begin
  result := inherited Add as TPrtTrackPoint;
end;

constructor TPrtTrack.Create;
begin
  inherited Create(TPrtTrackPoint);
end;

function TPrtTrack.GetTrackPoint(Index: Integer): TPrtTrackPoint;
begin
  result := inherited Items[Index] as TPrtTrackPoint;
end;

procedure TPrtTrack.ReadFromBinary(const FileName: string);
var
  ABinaryFile: TFileStream;
  PrtTrackPointRecord: TPrtTrackPointRecord;
  ATrackPoint: TPrtTrackPoint;
begin
  Assert(TFile.Exists(FileName));
  ABinaryFile := TFile.OpenRead(FileName);
  try
    While ABinaryFile.Read(PrtTrackPointRecord, SizeOf(TPrtTrackPointRecord)) > 0 do
    begin
      ATrackPoint := Add;
      ATrackPoint.AssignRecord(PrtTrackPointRecord);
    end;
  finally
    ABinaryFile.Free;
  end;
end;

procedure TPrtTrack.ReadFromCsv(const FileName: string);
var
  ACsvFile: TStreamReader;
  Splitter: TStringList;
  AString: string;
  ATrackPoint: TPrtTrackPoint;
begin
  Assert(TFile.Exists(FileName));
  Splitter := TStringList.Create;
  ACsvFile := TFile.OpenText(FileName);
  try
    AString := ACsvFile.ReadLine;
    repeat
      begin
        Splitter.CommaText := AString;
        Assert(Splitter.Count >= 15);
        ATrackPoint := Add;

        ATrackPoint.KPER := StrToInt(Splitter[0]);
        ATrackPoint.KSTP := StrToInt(Splitter[1]);
        ATrackPoint.IMDL := StrToInt(Splitter[2]);
        ATrackPoint.IPRP := StrToInt(Splitter[3]);
        ATrackPoint.IRPT := StrToInt(Splitter[4]);
        ATrackPoint.ILAY := StrToInt(Splitter[5]);
        ATrackPoint.ICELL := StrToInt(Splitter[6]);
        ATrackPoint.IZONE := StrToInt(Splitter[7]);
        ATrackPoint.ISTATUS := StrToInt(Splitter[8]);
        ATrackPoint.IREASON := StrToInt(Splitter[9]);
        ATrackPoint.TRELEASE := FortranStrToFloat(Splitter[10]);
        ATrackPoint.T := FortranStrToFloat(Splitter[11]);
        ATrackPoint.X := FortranStrToFloat(Splitter[12]);
        ATrackPoint.Y := FortranStrToFloat(Splitter[13]);
        ATrackPoint.Z := FortranStrToFloat(Splitter[14]);
        if Splitter.Count > 15 then
        begin
          ATrackPoint.NAME := Splitter[15]
        end;

        AString := ACsvFile.ReadLine;
      end;
    until AString = '';
  finally
    ACsvFile.Free;
    Splitter.Free;
  end;

end;

procedure TPrtTrack.SetTrackPoint(Index: Integer; const Value: TPrtTrackPoint);
begin
  inherited Items[Index] := Value;
end;

end.
