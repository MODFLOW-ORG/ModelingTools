unit framePackageIstUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, framePackageUnit, RbwController,
  Vcl.StdCtrls, frameRowGridUnit, ModflowPackageSelectionUnit,
  System.Generics.Collections;

type
  TIbsRow = (IrName, irSaveBudget, irBudgetText, irSorption, irDecay,
    irSaveConc, irPrintConc, IrPrintCols, irWidth, IrDigits, irFormat);

  TframePackageIst = class(TframePackage)
    frameIst: TframeRowGrid;
    procedure frameIstseNumberChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    procedure InitializeGrid;
    { Private declarations }
  public
    procedure GetData(Package: TModflowPackageSelection); override;
    procedure SetData(Package: TModflowPackageSelection); override;
    { Public declarations }
  end;

  TframePackageIstObjectList = TObjectList<TframePackageIst>;

var
  framePackageIst: TframePackageIst;

implementation

uses
  System.Math;

{$R *.dfm}

{ TframePackageIst }

procedure TframePackageIst.frameIstseNumberChange(Sender: TObject);
var
  ColIndex: Integer;
begin
  inherited;
  frameIst.Grid.BeginUpdate;
  try
    frameIst.seNumberChange(Sender);
    for ColIndex := 1 to frameIst.Grid.ColCount - 1 do
    begin
      frameIst.Grid.Cells[ColIndex, Ord(IrName)] := IntToStr(ColIndex);
      if ColIndex >= 2 then
      begin
        frameIst.Grid.Columns[ColIndex] := frameIst.Grid.Columns[1];
      end;
    end;
  finally
    frameIst.Grid.EndUpdate;
  end;
end;

procedure TframePackageIst.FrameResize(Sender: TObject);
begin
  inherited;
  memoComments.Width := Width -23;
end;

procedure TframePackageIst.GetData(Package: TModflowPackageSelection);
var
  IstPackage: TGwtIstPackage;
  PropIndex: Integer;
  PackageProp: TIstPackageItem;
  ColIndex: Integer;
begin
  inherited;
  InitializeGrid;
  IstPackage := Package as TGwtIstPackage;
  frameIst.seNumber.AsInteger := IstPackage.IstPackageProperties.Count;
  if Assigned(frameIst.seNumber.OnChange) then
  begin
    frameIst.seNumber.OnChange(self);
  end;
  for PropIndex := 0 to IstPackage.IstPackageProperties.Count - 1 do
  begin
    PackageProp := IstPackage.IstPackageProperties[PropIndex];
    ColIndex := PropIndex + 1;
    frameIst.Grid.Cells[ColIndex, Ord(IrName)] := IntToStr(ColIndex);
    frameIst.Grid.Checked[ColIndex, Ord(irSaveBudget)] := PackageProp.BinaryBudgetFileOut;
    frameIst.Grid.Checked[ColIndex, Ord(irBudgetText)] := PackageProp.TextBudgetFileOut;

    frameIst.Grid.ItemIndex[ColIndex, Ord(irSorption)] := Ord(PackageProp.SorptionType);
//    frameIst.Grid.Checked[ColIndex, Ord(irSorption)] := PackageProp.Sorption;
    if PackageProp.ZeroOrderDecay then
    begin
      frameIst.Grid.ItemIndex[ColIndex, Ord(irDecay)] := 1;
    end
    else if PackageProp.FirstOrderDecay then
    begin
      frameIst.Grid.ItemIndex[ColIndex, Ord(irDecay)] := 2;
    end
    else
    begin
      frameIst.Grid.ItemIndex[ColIndex, Ord(irDecay)] := 0;
    end;
    frameIst.Grid.Checked[ColIndex, Ord(irSaveConc)] := PackageProp.SaveConcentrations;
    frameIst.Grid.Checked[ColIndex, Ord(irPrintConc)] := PackageProp.SpecifyPrintFormat;
    frameIst.Grid.IntegerValue[ColIndex, Ord(IrPrintCols)] := PackageProp.Columns;
    frameIst.Grid.IntegerValue[ColIndex, Ord(irWidth)] := PackageProp.Width;
    frameIst.Grid.IntegerValue[ColIndex, Ord(IrDigits)] := PackageProp.Digits;
    frameIst.Grid.ItemIndex[ColIndex, Ord(irFormat)] := Ord(PackageProp.PrintFormat);
  end;
end;

procedure TframePackageIst.InitializeGrid;
begin
  frameIst.Grid.Cells[0, Ord(IrName)] := 'ISB number';
  frameIst.Grid.Cells[0, Ord(irSaveBudget)] := 'Save binary budget file';
  frameIst.Grid.Cells[0, Ord(irBudgetText)] := 'Save CSV budget file';
  frameIst.Grid.Cells[0, Ord(irSorption)] := 'Sorption';
  frameIst.Grid.Cells[0, Ord(irDecay)] := 'Decay';
  frameIst.Grid.Cells[0, Ord(irSaveConc)] := 'Save concentration';
  frameIst.Grid.Cells[0, Ord(irPrintConc)] := 'Print concentration';
  frameIst.Grid.Cells[0, Ord(IrPrintCols)] := 'Concentration print columns';
  frameIst.Grid.Cells[0, Ord(irWidth)] := 'width for writing number';
  frameIst.Grid.Cells[0, Ord(IrDigits)] := 'digits';
  frameIst.Grid.Cells[0, Ord(irFormat)] := 'format';
end;

procedure TframePackageIst.SetData(Package: TModflowPackageSelection);
var
  IstPackage: TGwtIstPackage;
  PropIndex: Integer;
  PackageProp: TIstPackageItem;
  ColIndex: Integer;
  PrintItemIndex: Integer;
begin
  inherited;
  IstPackage := Package as TGwtIstPackage;
  IstPackage.IstPackageProperties.Count := frameIst.seNumber.AsInteger;
  for PropIndex := 0 to IstPackage.IstPackageProperties.Count - 1 do
  begin
    PackageProp := IstPackage.IstPackageProperties[PropIndex];
    ColIndex := PropIndex + 1;
    PackageProp.BinaryBudgetFileOut := frameIst.Grid.Checked[ColIndex, Ord(irSaveBudget)];
    PackageProp.TextBudgetFileOut := frameIst.Grid.Checked[ColIndex, Ord(irBudgetText)];
    if frameIst.Grid.ItemIndex[ColIndex, Ord(irSorption)] >= 0 then
    begin
      PackageProp.SorptionType := TGwtSorptionChoice(frameIst.Grid.ItemIndex[ColIndex, Ord(irSorption)]);
    end;
    case frameIst.Grid.ItemIndex[ColIndex, Ord(irDecay)] of
      0:
        begin
          PackageProp.ZeroOrderDecay := False;
          PackageProp.FirstOrderDecay := False;
        end;
      1:
        begin
          PackageProp.ZeroOrderDecay := True;
          PackageProp.FirstOrderDecay := False;
        end;
      2:
        begin
          PackageProp.ZeroOrderDecay := False;
          PackageProp.FirstOrderDecay := True;
        end;
      else
        begin
          PackageProp.ZeroOrderDecay := False;
          PackageProp.FirstOrderDecay := False;
        end;
    end;
    PackageProp.SaveConcentrations := frameIst.Grid.Checked[ColIndex, Ord(irSaveConc)];
    PackageProp.SpecifyPrintFormat := frameIst.Grid.Checked[ColIndex, Ord(irPrintConc)];
    PackageProp.Columns := frameIst.Grid.IntegerValueDefault[ColIndex, Ord(IrPrintCols), 10];
    PackageProp.Width := frameIst.Grid.IntegerValueDefault[ColIndex, Ord(irWidth), 15];
    PackageProp.Digits := frameIst.Grid.IntegerValueDefault[ColIndex, Ord(IrDigits), 20];
    PrintItemIndex := frameIst.Grid.ItemIndex[ColIndex, Ord(irFormat)];
    if PrintItemIndex >= 0 then
    begin
      PackageProp.PrintFormat := TPrintFormat(PrintItemIndex);
    end
    else
    begin
      PackageProp.PrintFormat := pfGeneral;
    end;
  end;
end;

end.
