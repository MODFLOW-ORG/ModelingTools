unit RunVoroGridGenUnit;

interface

type
  TVorogridGenOptions = record
    BaseFileName: string;
    MaxCentroidSeparation: double;
    MaxCells: Integer;
    PolyGrowthRate: double;
    SearchDimensionsUsed: Boolean;
    SearchDimensions: Integer;
    MaxLloydUsed: Boolean;
    MaxLloyd: Integer;
    EpsLloydUsed: Boolean;
    EpsLloyd: Double;
    LloydFactorUsed: Boolean;
    LloydFactor: double;
    SafetyUsed: Boolean;
    Safety: Integer;
  end;

Procedure RunVorGridGen(const Options: TVorogridGenOptions);

implementation

uses
  frmGoPhastUnit, PhastModelUnit, ScreenObjectUnit;

Procedure RunVorGridGen(const Options: TVorogridGenOptions);
begin

end;


end.
