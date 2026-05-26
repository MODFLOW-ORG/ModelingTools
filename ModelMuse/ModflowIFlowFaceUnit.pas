unit ModflowIFlowFaceUnit;

interface

uses ZLib, Classes, SysUtils, RbwParser, GoPhastTypes,
  ModflowBoundaryUnit, SubscriptionUnit,
  FormulaManagerUnit, FormulaManagerInterfaceUnit;

type
  TIFlowFace = class(TFormulaProperty)
  private
    FUsed: boolean;
    FIFlowFace: Integer;
    procedure SetIFlowFace(const Value: Integer);
    procedure SetUsed(const Value: boolean);
  public
    procedure CreateObserver(ObserverNameRoot: string; var Observer: TObserver;
      Displayer: TObserver); override;
    Procedure Assign(Source: TPersistent); override;
    function Used: boolean; override;
  published
    property IFlowFace: Integer read FIFlowFace write SetIFlowFace;
    property IsUsed: boolean read FUsed write SetUsed;

  end;

implementation

{ TIFlowFace }

procedure TIFlowFace.Assign(Source: TPersistent);
var
  IFlowFaceSource: TIFlowFace;
begin
  if Source is TIFlowFace then
  begin
    IFlowFaceSource := TIFlowFace(Source);
    IFlowFace := IFlowFaceSource.IFlowFace;
    IsUsed := IFlowFaceSource.IsUsed;
  end
  else
  begin
    inherited;
  end;
end;

procedure TIFlowFace.CreateObserver(ObserverNameRoot: string;
  var Observer: TObserver; Displayer: TObserver);
begin
  Assert(False);
end;

procedure TIFlowFace.SetIFlowFace(const Value: Integer);
begin
  FIFlowFace := Value;
end;

procedure TIFlowFace.SetUsed(const Value: boolean);
begin
  FUsed := Value;
end;

function TIFlowFace.Used: boolean;
begin
  result := IsUsed;
end;

end.
