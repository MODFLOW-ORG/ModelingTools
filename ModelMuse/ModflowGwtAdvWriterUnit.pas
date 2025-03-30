unit ModflowGwtAdvWriterUnit;

interface

uses
  CustomModflowWriterUnit, ModflowPackageSelectionUnit, GoPhastTypes,
  PhastModelUnit;

type
  TModflowGwtAdvWriter = class(TCustomPackageWriter)
  private
    FAdvPackage: TGwtAdvectionPackage;
    FSpeciesIndex: Integer;
    procedure WriteOptions;
  protected
    function Package: TModflowPackageSelection; override;
    class function Extension: string; override;
  public
    procedure WriteFile(AFileName: string; SpeciesIndex: Integer);
  end;

implementation

uses
  System.IOUtils;

{ TModflowGwtAdvWriter }

class function TModflowGwtAdvWriter.Extension: string;
begin
  result := '.adv';
end;

function TModflowGwtAdvWriter.Package: TModflowPackageSelection;
begin
  result := nil;

  if Model.MobileComponents[FSpeciesIndex].UsedForGWT then
  begin
    result := Model.ModflowPackages.GwtAdvectionPackage;
  end
  else if Model.MobileComponents[FSpeciesIndex].UsedForGWE then
  begin
    result := Model.ModflowPackages.GweAdvectionPackage;
  end
  else
  begin
    Assert(False);
  end;
end;

procedure TModflowGwtAdvWriter.WriteFile(AFileName: string; SpeciesIndex: Integer);
var
  Abbreviation: string;
  GwtFile: string;
  SpeciesGwtFile: string;
begin
  FSpeciesIndex := SpeciesIndex;
  if not Package.IsSelected then
  begin
    Exit
  end;
  if not (Model.MobileComponents[SpeciesIndex].UsedForGwt
    or Model.MobileComponents[SpeciesIndex].UsedForGwE) then
  begin
    Exit
  end;
  FAdvPackage := Package as TGwtAdvectionPackage;

  Abbreviation := 'ADV6';
  GwtFile := GwtFileName(AFileName, SpeciesIndex);
  FNameOfFile := GwtFile;
  FInputFileName := GwtFile;

  WriteToGwtNameFile(Abbreviation, FNameOfFile, SpeciesIndex);

  FPestParamUsed := False;
  WritingTemplate := False;

  OpenFile(FNameOfFile);
  try
    WriteDataSet0;
    WriteOptions;
  finally
    CloseFile;
  end;
end;

procedure TModflowGwtAdvWriter.WriteOptions;
begin
  WriteBeginOptions;

  WriteString('  SCHEME ');
  case FAdvPackage.Scheme of
    gsUpstream:
      begin
        WriteString('upstream');
      end;
    gsCentral:
      begin
        WriteString('central');
      end;
    gsTVD:
      begin
        WriteString('tvd');
      end;
    else
      Assert(False);
  end;
  NewLine;

  if FAdvPackage.AtsPercel <> 0 then
  begin
    WriteString('  ATS_PERCEL');
    WriteFloat(FAdvPackage.AtsPercel);
    NewLine;
  end;

  WriteEndOptions;
end;

end.
