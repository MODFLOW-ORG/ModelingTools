unit frmPrtChoicesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCustomGoPhastUnit, Vcl.Grids,
  RbwDataGrid4, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, GoPhastTypes;

type
  TfrmPrtChoices = class(TfrmCustomGoPhast)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnHelp: TBitBtn;
    rdgChoices: TRbwDataGrid4;
  private
    FSelection: TIntegerCollection;
    procedure SetChoices(const Value: TStrings);
    procedure SetSelection(const Value: TIntegerCollection);
    function GetChoices: TStrings;
    function GetSelection: TIntegerCollection;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Choices: TStrings read GetChoices write SetChoices;
    property Selection: TIntegerCollection read GetSelection write SetSelection;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TfrmPrtChoices }

constructor TfrmPrtChoices.Create(AOwner: TComponent);
begin
  inherited;
  FSelection := TIntegerCollection.Create(nil);
end;

destructor TfrmPrtChoices.Destroy;
begin
  FSelection.Free;
  inherited;
end;

function TfrmPrtChoices.GetChoices: TStrings;
begin
  result := rdgChoices.Cols[0]
end;

function TfrmPrtChoices.GetSelection: TIntegerCollection;
begin
  FSelection.Clear;
  for var Index := 0 to rdgChoices.RowCount - 1 do
  begin
    if rdgChoices.Checked[0, Index] then
    begin
      FSelection.Add.Value := index;
    end;
  end;
  result := FSelection;
end;

procedure TfrmPrtChoices.SetChoices(const Value: TStrings);
begin
  rdgChoices.Cols[0].Assign(Value);
end;

procedure TfrmPrtChoices.SetSelection(const Value: TIntegerCollection);
begin
  for var Index := 0 to Value.Count - 1 do
  begin
    rdgChoices.Checked[0, Value[Index].Value] := True;
  end;
end;

end.
