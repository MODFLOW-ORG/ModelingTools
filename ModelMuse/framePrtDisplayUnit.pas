unit framePrtDisplayUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, RbwDataGrid4,
  Vcl.StdCtrls, Vcl.ExtCtrls, JvSpin, JvExControls, JvxSlider, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.ComCtrls, UndoItems,
  PhastModelUnit, PathlineReader, Vcl.CheckLst, PrtTrackReaderUnit;

type
  TTrackLimits = (tlNone, tlColors, tlLayer, tlRow, tlColumn, tlTime,
    tlReleaseTime, tlPrpPackage, tlLineNumber);

resourcestring
  Colorlimits = 'Color limits';
  Layer = 'Layer';
  Row = 'Row';
  Column = 'Column';
  Times = 'Times';
  ReleaseTimes = 'Release Times';
  PrpPackage = 'Prp Package';
  LineNumber = 'Line Number';

const
  TableCaptions: array[Low(TTrackLimits)..High(TTrackLimits)] of string =
    ('', Colorlimits, Layer, Row, Column, Times, ReleaseTimes, PrpPackage, LineNumber);

type
  TUndoImportPrtTrack = class(TCustomUndo)
  private
    FExistingPathLines: TPrtTrackDisplayer;
    FNewPathLines: TPrtTrackDisplayer;
    FImportedNewFile: Boolean;
    FModel: TCustomModel;
    procedure ForceRedraw;
    procedure EnableMenuItems;
  public
    Constructor Create(Model: TCustomModel; var NewPathLine: TPrtTrackDisplayer;
      ImportedNewFile: boolean);
    Destructor Destroy; override;
    function Description: string; override;
    procedure DoCommand; override;
    procedure Undo; override;
  end;


  TframePrtDisplay = class(TFrame)
    pcMain: TPageControl;
    tabBasic: TTabSheet;
    lblPrtTracklineFile: TLabel;
    lblColorScheme: TLabel;
    pbColorScheme: TPaintBox;
    lblColorAdjustment: TLabel;
    lblCycles: TLabel;
    lblMaxTime: TLabel;
    fedPrtTracklineFile: TJvFilenameEdit;
    cbLimitToCurrentIn2D: TCheckBox;
    comboColorScheme: TComboBox;
    jsColorExponent: TJvxSlider;
    seColorExponent: TJvSpinEdit;
    seCycles: TJvSpinEdit;
    btnColorSchemes: TButton;
    tabOptions: TTabSheet;
    rgShow2D: TRadioGroup;
    rgColorBy: TRadioGroup;
    rdgLimits: TRbwDataGrid4;
    chklstPlotTypes: TCheckListBox;
  private
    { Private declarations }
    procedure ReadIntLimit(IntLimits: TShowIntegerLimit;
      ALimitRow: TTrackLimits);
    procedure ReadFloatLimits(FloatLimits: TShowFloatLimit;
      ALimitRow: TTrackLimits);
    procedure SetIntLimit(LimitRow: TTrackLimits; DefaultLimit: integer;
      IntLimit: TShowIntegerLimit);
    procedure SetFloatLimit(LimitRow: TTrackLimits;
      MinLimit, MaxLimit: Double; FloatLimit: TShowFloatLimit);
    procedure ReadByteSetLimit(ByteLimits: TByteSetLimits;
      ALimitRow: TTrackLimits);
    procedure SetByteSetLimit(LimitRow: TTrackLimits;
      ByteLimit: TByteSetLimits);
  protected
    procedure Loaded; override;
  public
    procedure GetData;
    procedure SetData;
    procedure UpdateColorSchemes;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  frmGoPhastUnit, ColorSchemes, ModflowGridUnit,
  LayerStructureUnit, frmCustomGoPhastUnit, frmColorSchemesUnit;

resourcestring
  StrYouMustDefineThe = 'You must define the grid before attempting to impor' +
  't PRT Track results.';
  StrLimitingFactor = 'Limiting factor';
  StrLowerLimit = 'Lower limit';
  StrUpperLimit = 'Upper limit';
  StrMaximumTime = 'Maximum time = ';
  StrThePathlineFileOn = 'The PRT Track file on disk has a different date tha' +
  'n the file that was imported into ModelMuse.  Do you want to import the n' +
  'ew file?';
  StrImportPrtTrack = 'import Prt Track';
  StrConfigurePrtTrack = 'configure Prt Track';
  StrThereWasAnErrorR = 'There was an error reading the Prt Track file. It ma' +
  'y have been locked or there might have been some other error. The error m' +
  'essage was "%s".';

{ TUndoImportPrtTrack }

constructor TUndoImportPrtTrack.Create(Model: TCustomModel;
  var NewPathLine: TPrtTrackDisplayer; ImportedNewFile: boolean);
begin
  FModel := Model;
  FImportedNewFile := ImportedNewFile;
  FExistingPathLines:= TPrtTrackDisplayer.Create(nil);
  FExistingPathLines.Assign(frmGoPhast.PhastModel.PrtTracks);
  // Take ownership of NewPathLine.
  FNewPathLines := NewPathLine;
  NewPathLine := nil;

end;

function TUndoImportPrtTrack.Description: string;
begin
  if FImportedNewFile then
  begin
    result := StrImportPrtTrack;
  end
  else
  begin
    result := StrConfigurePrtTrack;
  end;

end;

destructor TUndoImportPrtTrack.Destroy;
begin
  FExistingPathLines.Free;
  FNewPathLines.Free;
  inherited;
end;

procedure TUndoImportPrtTrack.DoCommand;
begin
  FModel.PrtTracks := FNewPathLines;
  EnableMenuItems;
  ForceRedraw;
end;

procedure TUndoImportPrtTrack.EnableMenuItems;
begin

end;

procedure TUndoImportPrtTrack.ForceRedraw;
begin
//  FModel.PrtTracks.Invalidate;
  frmGoPhast.frame3DView.glWidModelView.Invalidate;

  frmGoPhast.frameTopView.ModelChanged := True;
  frmGoPhast.frameFrontView.ModelChanged := True;
  frmGoPhast.frameSideView.ModelChanged := True;
  frmGoPhast.InvalidateImage32AllViews;
end;

procedure TUndoImportPrtTrack.Undo;
begin
  FModel.PrtTracks := FExistingPathLines;
  EnableMenuItems;
  ForceRedraw;
end;

{ TframePrtDisplay }

procedure TframePrtDisplay.GetData;
var
  PrtTracks: TPrtTrackDisplayer;
  LocalTracksDisplayer: TPrtTrackDisplayer;
  LocalTracks: TPrtTracks;
  MaxTime: double;
  PrtTrackDisplayLimits: TPrtTrackDisplayLimits;
  PlotTypeIndex: TPrtPlotType;
begin
  Handle;
  if frmGoPhast.PhastModel.ColorSchemes.Count > 0 then
  begin
    UpdateColorSchemes;
  end;

  fedPrtTracklineFile.DefaultExt := '.trk';
  PrtTracks := frmGoPhast.PhastModel.PrtTracks;

  LocalTracksDisplayer := TPrtTrackDisplayer.Create(frmGoPhast.PhastModel);
  LocalTracksDisplayer.Assign(PrtTracks);

  fedPrtTracklineFile.FileName := LocalTracksDisplayer.FileName;
  LocalTracks := LocalTracksDisplayer.Tracks;
  if LocalTracks.TestGetMaxTime(MaxTime) then
  begin
    lblMaxTime.Caption := StrMaximumTime
      + FloatToStrF(MaxTime, ffGeneral, 7, 0);
  end
  else
  begin
    lblMaxTime.Caption := StrMaximumTime + '?';
  end;

  PrtTrackDisplayLimits := PrtTracks.PrtTrackDisplayLimits;
  for PlotTypeIndex := Low(TPrtPlotType) to High(TPrtPlotType) do
  begin
    chklstPlotTypes.Checked[Ord(PlotTypeIndex)] := PlotTypeIndex in PrtTrackDisplayLimits.PlotTypes;
  end;

  rgShow2D.ItemIndex := Ord(PrtTrackDisplayLimits.ShowChoice);

  ReadIntLimit(PrtTrackDisplayLimits.ColumnLimits, tlColumn);
  ReadIntLimit(PrtTrackDisplayLimits.RowLimits, tlRow);
  ReadIntLimit(PrtTrackDisplayLimits.LayerLimits, tlLayer);
  ReadByteSetLimit(PrtTrackDisplayLimits.PrpLimits, tlPrpPackage);
  ReadIntLimit(PrtTrackDisplayLimits.LineNumberLimits, tlLineNumber);

  ReadFloatLimits(PrtTrackDisplayLimits.TimeLimits, tlTime);
  ReadFloatLimits(PrtTrackDisplayLimits.ReleaseTimeLimits, tlReleaseTime);


//   TTrackLimits = (tlNone, tlColors, tlLayer, tlRow, tlColumn, tlTime,
//    tlPrpPackage, tlLineNumber);

end;

procedure TframePrtDisplay.Loaded;
var
  Index: TTrackLimits;
begin
  inherited;
  rdgLimits.BeginUpdate;
  try
    rdgLimits.RowCount := Succ(Ord(High(TTrackLimits)));
    for Index := Low(TTrackLimits) to High(TTrackLimits) do
    begin
      rdgLimits.Cells[0,Ord(Index)] := TableCaptions[Index];
    end;
    rdgLimits.Cells[0,0] := StrLimitingFactor;
    rdgLimits.Cells[1,0] := StrLowerLimit;
    rdgLimits.Cells[2,0] := StrUpperLimit;

    Index := tlColors;
    rdgLimits.UseSpecialFormat[1,Ord(Index)] := True;
    rdgLimits.UseSpecialFormat[2,Ord(Index)] := True;
    rdgLimits.SpecialFormat[1,Ord(Index)] := rcf4Real;
    rdgLimits.SpecialFormat[2,Ord(Index)] := rcf4Real;

    Index := tlTime;
    rdgLimits.UseSpecialFormat[1,Ord(Index)] := True;
    rdgLimits.UseSpecialFormat[2,Ord(Index)] := True;
    rdgLimits.SpecialFormat[1,Ord(Index)] := rcf4Real;
    rdgLimits.SpecialFormat[2,Ord(Index)] := rcf4Real;

    Index := tlReleaseTime;
    rdgLimits.UseSpecialFormat[1,Ord(Index)] := True;
    rdgLimits.UseSpecialFormat[2,Ord(Index)] := True;
    rdgLimits.SpecialFormat[1,Ord(Index)] := rcf4Real;
    rdgLimits.SpecialFormat[2,Ord(Index)] := rcf4Real;
  finally
    rdgLimits.EndUpdate;
  end;

  pcMain.ActivePageIndex := 0;
end;

procedure TframePrtDisplay.ReadByteSetLimit(ByteLimits: TByteSetLimits;
  ALimitRow: TTrackLimits);
var
  ARow: Integer;
  AStringList: TStringList;
begin
  ARow := Ord(ALimitRow);
  rdgLimits.Checked[0, ARow] := ByteLimits.UseLimit;
  if ByteLimits.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      for var Index := 0 to ByteLimits.Limits.Count - 1 do
      begin
        AStringList.Add(ByteLimits.Limits[Index].Value.ToString);
      end;
      rdgLimits.Cells[1, ARow] := AStringList.CommaText;
      rdgLimits.Cells[2, ARow] := rdgLimits.Cells[1, ARow]
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.ReadFloatLimits(FloatLimits: TShowFloatLimit;
  ALimitRow: TTrackLimits);
var
  ARow: Integer;
begin
  ARow := Ord(ALimitRow);
  rdgLimits.Checked[0, ARow] := FloatLimits.UseLimit;
  if FloatLimits.UseLimit then
  begin
    rdgLimits.Cells[1, ARow] := FloatToStr(FloatLimits.StartLimit);
    rdgLimits.Cells[2, ARow] := FloatToStr(FloatLimits.EndLimit);
  end;
end;

procedure TframePrtDisplay.ReadIntLimit(IntLimits: TShowIntegerLimit;
  ALimitRow: TTrackLimits);
var
  ARow: Integer;
begin
  ARow := Ord(ALimitRow);
  rdgLimits.Checked[0, ARow] := IntLimits.UseLimit;
  if IntLimits.UseLimit then
  begin
    rdgLimits.Cells[1, ARow] := IntToStr(IntLimits.StartLimit);
    rdgLimits.Cells[2, ARow] := IntToStr(IntLimits.EndLimit);
  end;
end;

procedure TframePrtDisplay.SetByteSetLimit(LimitRow: TTrackLimits;
  ByteLimit: TByteSetLimits);
begin

end;

procedure TframePrtDisplay.SetData;
begin

end;

procedure TframePrtDisplay.SetFloatLimit(LimitRow: TTrackLimits; MinLimit,
  MaxLimit: Double; FloatLimit: TShowFloatLimit);
begin
end;

procedure TframePrtDisplay.SetIntLimit(LimitRow: TTrackLimits;
  DefaultLimit: integer; IntLimit: TShowIntegerLimit);
begin

end;

procedure TframePrtDisplay.UpdateColorSchemes;
begin
  UpdateColorScheme(comboColorScheme, pbColorScheme);
end;

end.
