unit ModflowGwfGwtExchangeWriterUnit;

interface

uses
  System.SysUtils, CustomModflowWriterUnit, ModflowPackageSelectionUnit;

type
  TModflowGwfGwtExchangeWriter = class(TCustomPackageWriter)
  protected
    function Package: TModflowPackageSelection; override;
    class function Extension: string; override;
  public
    class function GweExtension: string; override;
    procedure WriteFile(const AFileName: string; SpeciesIndex: Integer);
  end;


implementation

uses
  Mt3dmsChemSpeciesUnit;

{ TModflowGwfGwtExchangeWriter }

class function TModflowGwfGwtExchangeWriter.Extension: string;
begin
  result := '.gwfgwt';
end;

class function TModflowGwfGwtExchangeWriter.GweExtension: string;
begin
  result := '.gwfgwe';
end;

function TModflowGwfGwtExchangeWriter.Package: TModflowPackageSelection;
begin
  result := nil;
end;

procedure TModflowGwfGwtExchangeWriter.WriteFile(
  const AFileName: string; SpeciesIndex: Integer);
var
  SpeciesName: string;
  GwtFile: string;
  Exchange: string;
  Species: TMobileChemSpeciesItem;
begin
  Species := Model.MobileComponents[SpeciesIndex];
  SpeciesName := Species.Name;
  if Species.UsedForGwt then
  begin
    GwtFile := GwtFileName(AFileName, SpeciesIndex);
  end
  else if Species.UsedForGwe then
  begin
    GwtFile := GweFileName(AFileName, SpeciesIndex);
  end
  else
  begin
    Assert(False);
  end;
  FNameOfFile := GwtFile;
  Model.AddModelInputFile(GwtFile);
  FInputFileName := GwtFile;
  if Species.UsedForGwt then
  begin
    Exchange := Format('GWF6-GWT6 %0:s MODFLOW %1:s', [ExtractFileName(GwtFile), SpeciesName]);
  end
  else if Species.UsedForGwe then
  begin
    Exchange := Format('GWF6-GWE6 %0:s MODFLOW %1:s', [ExtractFileName(GwtFile), SpeciesName]);
  end
  else
  begin
    Assert(False);
  end;
  Model.SimNameWriter.AddExchange(Exchange);
  OpenFile(FNameOfFile);
  try
    if Species.UsedForGwt then
    begin
      WriteCommentLine('GWF-GWT file created by ModelMuse');
    end
    else if Species.UsedForGwe then
    begin
      WriteCommentLine('GWF-GWE file created by ModelMuse');
    end
    else
    begin
      Assert(False);
    end;
  finally
    CloseFile;
  end;

end;

end.
