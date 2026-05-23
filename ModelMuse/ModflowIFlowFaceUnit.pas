unit ModflowIFlowFaceUnit;

interface

uses ZLib, Classes, SysUtils, RbwParser, GoPhastTypes,
  ModflowBoundaryUnit, SubscriptionUnit,
  FormulaManagerUnit, FormulaManagerInterfaceUnit;

type
  TIFlowFace = class(TPersistent)
  private
    FModel: TBaseModel;
    FScreenObject: TObject;
    FUsed: boolean;
    FIFlowFace: Integer;
    procedure SetIFlowFace(const Value: Integer);
    procedure SetUsed(const Value: boolean);
  public
    Procedure Assign(Source: TPersistent); override;
    Constructor Create(Model: TBaseModel; ScreenObject: TObject);
  published
    property IFlowFace: Integer read FIFlowFace write SetIFlowFace;
    property Used: boolean read FUsed write SetUsed;

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
    Used := IFlowFaceSource.Used;
  end
  else
  begin
    inherited;
  end;
end;

constructor TIFlowFace.Create(Model: TBaseModel; ScreenObject: TObject);
begin
  FModel := Model;
  FScreenObject := ScreenObject;
  inherited Create;
end;

procedure TIFlowFace.SetIFlowFace(const Value: Integer);
begin
  FIFlowFace := Value;
end;

procedure TIFlowFace.SetUsed(const Value: boolean);
begin
  FUsed := Value;
end;

end.
