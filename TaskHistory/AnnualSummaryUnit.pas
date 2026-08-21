unit AnnualSummaryUnit;

interface

uses
  System.Classes, System.Generics.Collections;

type
  TAnnualSummaryItem = Class(TCollectionItem)
  private
    FYear: integer;
    FDaysWorked: Integer;
    procedure SetDaysWorked(const Value: Integer);
    procedure SetYear(const Value: integer);
  published
    property Year: integer read FYear write SetYear;
    property DaysWorked: Integer read FDaysWorked write SetDaysWorked;
  End;

  TAnnualSummaryCollection = class(TCollection)
  private
    function GetItems(Index: Integer): TAnnualSummaryItem;
    procedure SetItems(Index: Integer; const Value: TAnnualSummaryItem);
  public
    Constructor Create;
    property Items[Index: Integer]: TAnnualSummaryItem read GetItems write SetItems; default;
    function Add: TAnnualSummaryItem;
  end;

implementation

{ TAnnualSummaryItem }

procedure TAnnualSummaryItem.SetDaysWorked(const Value: Integer);
begin
  FDaysWorked := Value;
end;

procedure TAnnualSummaryItem.SetYear(const Value: integer);
begin
  FYear := Value;
end;

{ TAnnualSummaryCollection }

function TAnnualSummaryCollection.Add: TAnnualSummaryItem;
begin
  result := inherited Add as TAnnualSummaryItem;
end;

constructor TAnnualSummaryCollection.Create;
begin
  inherited Create(TAnnualSummaryItem);
end;

function TAnnualSummaryCollection.GetItems(Index: Integer): TAnnualSummaryItem;
begin
  result := inherited Items[Index] as TAnnualSummaryItem
end;

procedure TAnnualSummaryCollection.SetItems(Index: Integer;
  const Value: TAnnualSummaryItem);
begin
  inherited Items[Index] := Value;
end;

end.
