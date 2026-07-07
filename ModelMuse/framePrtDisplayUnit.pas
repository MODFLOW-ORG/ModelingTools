unit framePrtDisplayUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, RbwDataGrid4,
  Vcl.StdCtrls, Vcl.ExtCtrls, JvSpin, JvExControls, JvxSlider, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.ComCtrls, UndoItems,
  PhastModelUnit, PathlineReader, Vcl.CheckLst, PrtTrackReaderUnit,
  System.IOUtils, System.UITypes;

type
  TTrackLimits = (tlNone, tlColors, tlLayer, tlRow, tlColumn, tlTime,
    tlReleaseTime, tlLineNumber);

  TTrackSetLimits = (tlsNone, tlPrpPackage, tlReason, tlZone, tlStatus,
    tlSelectedTimes);

resourcestring
  Colorlimits = 'Color limits';
  Layer = 'Layer';
  Row = 'Row';
  Column = 'Column';
  Times = 'Times';
  ReleaseTimes = 'Release Times';
  LineNumber = 'Line Number';

  PrpPackage = 'Prp Package';
  Reason = 'Reason';
  Zone = 'Zone';
  Status = 'Status';
  SelectedTimes = 'Selected Times';

const
  TableCaptions: array[Low(TTrackLimits)..High(TTrackLimits)] of string =
    ('', Colorlimits, Layer, Row, Column, Times, ReleaseTimes, LineNumber);

  TableSetCaptions: array[Low(TTrackSetLimits)..High(TTrackSetLimits)] of string =
    ('', PrpPackage, Reason, Zone, Status, SelectedTimes);

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
    pnl1: TPanel;
    rdgSetLimits: TRbwDataGrid4;
    spl1: TSplitter;
    lblSinglePointSize: TLabel;
    seSinglePointSize: TJvSpinEdit;
    procedure btnColorSchemesClick(Sender: TObject);
    procedure comboColorSchemeChange(Sender: TObject);
    procedure fedPrtTracklineFileBeforeDialog(Sender: TObject; var AName: string;
        var AAction: Boolean);
    procedure fedPrtTracklineFileChange(Sender: TObject); overload;
    procedure jsColorExponentChange(Sender: TObject);
    procedure pbColorSchemePaint(Sender: TObject);
    procedure rdgLimitsSelectCell(Sender: TObject; ACol, ARow: LongInt; var
        CanSelect: Boolean);
    procedure rdgLimitsSetEditText(Sender: TObject; ACol, ARow: LongInt; const
        Value: string);
    procedure rdgLimitsStateChange(Sender: TObject; ACol, ARow: LongInt; const
        Value: TCheckBoxState);
    procedure rdgSetLimitsButtonClick(Sender: TObject; ACol, ARow: LongInt);
    procedure rdgSetLimitsSelectCell(Sender: TObject; ACol, ARow: LongInt; var
        CanSelect: Boolean);
    procedure rdgSetLimitsStateChange(Sender: TObject; ACol, ARow: LongInt; const
        Value: TCheckBoxState);
    procedure rgColorByClick(Sender: TObject);
    procedure rgShow2DClick(Sender: TObject);
    procedure seColorExponentChange(Sender: TObject);
    procedure seCyclesChange(Sender: TObject);
  private
    { Private declarations }
    FLocalTracksDisplayer: TPrtTrackDisplayer;
    procedure ReadIntLimit(IntLimits: TShowIntegerLimit;
      ALimitRow: TTrackLimits);
    procedure ReadFloatLimits(FloatLimits: TShowFloatLimit;
      ALimitRow: TTrackLimits);
    procedure SetIntLimit(LimitRow: TTrackLimits; DefaultLimit: integer;
      IntLimit: TShowIntegerLimit);
    procedure SetFloatLimit(LimitRow: TTrackLimits;
      MinLimit, MaxLimit: Double; FloatLimit: TShowFloatLimit);
    procedure ReadByteSetLimit(ByteLimits: TByteSetLimits;
      ALimitRow: TTrackSetLimits);
    procedure SetByteSetLimit(LimitRow: TTrackSetLimits;
      ByteLimit: TByteSetLimits);
    procedure ReadReasonLimit(ReasonLimit: TReasonLimit; LimitRow: TTrackSetLimits);
    procedure SetReasonLimit(ReasonLimit: TReasonLimit; LimitRow: TTrackSetLimits);
    procedure ReadStatusLimit(StatusLimit: TStatusLimit; LimitRow: TTrackSetLimits);
    procedure SetStatusLimit(StatusLimit: TStatusLimit; LimitRow: TTrackSetLimits);
    procedure ReadSelectedTimeLimit(SelectedTimeLimits: TSelectedTimeLimit; LimitRow: TTrackSetLimits);
    procedure SetSelectedTimeLimit(SelectedTimeLimits: TSelectedTimeLimit; LimitRow: TTrackSetLimits);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetData;
    procedure SetData;
    procedure UpdateColorSchemes;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  frmGoPhastUnit, ColorSchemes, ModflowGridUnit,
  LayerStructureUnit, frmCustomGoPhastUnit, frmColorSchemesUnit,
  frmPrtChoicesUnit, GoPhastTypes, ModelMuseUtilities;

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

constructor TframePrtDisplay.Create(AOwner: TComponent);
begin
  inherited;
  FLocalTracksDisplayer := TPrtTrackDisplayer.Create(nil);
end;

destructor TframePrtDisplay.Destroy;
begin
  FLocalTracksDisplayer.Free;
  inherited;
end;

procedure TframePrtDisplay.btnColorSchemesClick(Sender: TObject);
begin
  ShowAForm(TfrmColorSchemes)
end;

procedure TframePrtDisplay.comboColorSchemeChange(Sender: TObject);
begin
  pbColorScheme.Invalidate;
end;

procedure TframePrtDisplay.fedPrtTracklineFileBeforeDialog(Sender: TObject; var
    AName: string; var AAction: Boolean);
begin
  if AName = '' then
  begin
//    if frmGoPhast.sdModpathInput.FileName <> '' then
//    begin
//      AName := ChangeFileExt(frmGoPhast.sdModpathInput.FileName,
//        fedPrtTracklineFile.DefaultExt);
//    end
    {else} if frmGoPhast.sdModflowInput.FileName <> '' then
    begin
      AName := ChangeFileExt(frmGoPhast.sdModflowInput.FileName,
        fedPrtTracklineFile.DefaultExt);
    end
    else if frmGoPhast.sdSaveDialog.FileName <> '' then
    begin
      AName := ChangeFileExt(frmGoPhast.sdSaveDialog.FileName,
        fedPrtTracklineFile.DefaultExt);
    end;
  end;
end;

procedure TframePrtDisplay.fedPrtTracklineFileChange(Sender: TObject);
var
  Extension: string;
begin
  if TFile.Exists(fedPrtTracklineFile.FileName) then
  begin
    Extension := ExtractFileExt(fedPrtTracklineFile.FileName);
    if SameText(Extension, '.csv') then
    begin
      FLocalTracksDisplayer.Tracks.ReadFromCsv(fedPrtTracklineFile.FileName)
    end
    else
    begin
      FLocalTracksDisplayer.Tracks.ReadFromBinary(fedPrtTracklineFile.FileName)
    end;
  end;
end;

procedure TframePrtDisplay.GetData;
var
  PrtTracks: TPrtTrackDisplayer;
  LocalTracks: TPrtTracks;
  MaxTime: double;
  MinTime: double;
  PrtTrackDisplayLimits: TPrtTrackDisplayLimits;
  PlotTypeIndex: TPrtPlotType;
  ALimitRow: TTrackLimits;
  ARow: Integer;
  ColorParameters: TColorParameters;
begin
  Handle;
  if frmGoPhast.PhastModel.ColorSchemes.Count > 0 then
  begin
    UpdateColorSchemes;
  end;

  fedPrtTracklineFile.DefaultExt := '.trk';
  PrtTracks := frmGoPhast.PhastModel.PrtTracks;

  FLocalTracksDisplayer.Assign(PrtTracks);

  fedPrtTracklineFile.FileName := FLocalTracksDisplayer.Tracks.FileName;
  LocalTracks := FLocalTracksDisplayer.Tracks;

  if LocalTracks.TestGetMinMaxTime(MinTime, MaxTime) then
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

  seSinglePointSize.AsInteger := PrtTrackDisplayLimits.EndPointSize;

  rgShow2D.ItemIndex := Ord(PrtTrackDisplayLimits.ShowChoice);

  ReadIntLimit(PrtTrackDisplayLimits.ColumnLimits, tlColumn);
  ReadIntLimit(PrtTrackDisplayLimits.RowLimits, tlRow);
  ReadIntLimit(PrtTrackDisplayLimits.LayerLimits, tlLayer);
  ReadIntLimit(PrtTrackDisplayLimits.LineNumberLimits, tlLineNumber);
  ReadFloatLimits(PrtTrackDisplayLimits.TimeLimits, tlTime);
  ReadFloatLimits(PrtTrackDisplayLimits.ReleaseTimeLimits, tlReleaseTime);

  ReadByteSetLimit(PrtTrackDisplayLimits.PrpLimits, tlPrpPackage);
  ReadReasonLimit(PrtTrackDisplayLimits.ReasonLimits, tlReason);
  ReadByteSetLimit(PrtTrackDisplayLimits.ZoneLimits, tlZone);
  ReadStatusLimit(PrtTrackDisplayLimits.StatusLimit, tlStatus);
  ReadSelectedTimeLimit(PrtTrackDisplayLimits.SelectedTimeLimits, tlSelectedTimes);

  rgColorBy.ItemIndex := Ord(PrtTrackDisplayLimits.ColorLimits.ColoringChoice);

  ALimitRow := tlColors;
  ARow := Ord(ALimitRow);
  rdgLimits.Checked[0, ARow] := PrtTrackDisplayLimits.ColorLimits.UseLimit;
  if PrtTrackDisplayLimits.ColorLimits.UseLimit then
  begin
    rdgLimits.Cells[1, ARow] := FloatToStr(PrtTrackDisplayLimits.ColorLimits.MinColorLimit);
    rdgLimits.Cells[2, ARow] := FloatToStr(PrtTrackDisplayLimits.ColorLimits.MaxColorLimit);
  end;


  ColorParameters := PrtTrackDisplayLimits.ColorParameters;
  comboColorScheme.ItemIndex := ColorParameters.ColorScheme;
  seCycles.AsInteger := ColorParameters.ColorCycles;
  seColorExponent.Value := ColorParameters.ColorExponent;
  jsColorExponent.Value := Round(ColorParameters.ColorExponent*100);
end;

procedure TframePrtDisplay.jsColorExponentChange(Sender: TObject);
begin
  if Sender <> seColorExponent then
  begin
    seColorExponent.Value := jsColorExponent.Value / 100
  end;
  pbColorScheme.Invalidate;
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

procedure TframePrtDisplay.pbColorSchemePaint(Sender: TObject);
var
  X: integer;
  Fraction: Real;
  AColor: TColor;
  ColorAdjustmentFactor: Real;
begin
  for X := 0 to pbColorScheme.Width - 1 do
  begin
    Fraction := 1 - X / pbColorScheme.Width;
    ColorAdjustmentFactor := seColorExponent.Value;

    AColor := FracAndSchemeToColor(comboColorScheme.ItemIndex,
      Fraction, ColorAdjustmentFactor, seCycles.AsInteger);

    with pbColorScheme.Canvas do
    begin
      Pen.Color := AColor;
      MoveTo(X, 0);
      LineTo(X, pbColorScheme.Height - 1);
    end;
  end;
end;

procedure TframePrtDisplay.rdgLimitsSelectCell(Sender: TObject; ACol, ARow:
    LongInt; var CanSelect: Boolean);
begin
  if (ARow >= rdgLimits.FixedRows) then
  begin
    if ARow = Ord(tlColors) then
    begin
      CanSelect := rgColorBy.ItemIndex <> 0;
    end
    else
    begin
      CanSelect := rgShow2D.ItemIndex <> 0;
    end;
    if CanSelect then
    begin
      case ACol of
        0:
          begin
            // do nothing.
          end;
        1,2:
          begin
            CanSelect := rdgLimits.Checked[0,ARow];
          end;
        else Assert(False);
      end;
    end;
  end;
end;

procedure TframePrtDisplay.rdgLimitsSetEditText(Sender: TObject; ACol, ARow:
    LongInt; const Value: string);
begin
  if (ARow in [Ord(tlLayer)..Ord(tlColumn),
    Ord(tlLineNumber)]) and (ACol in [1,2]) then
  begin
    rdgLimits.Columns[ACol].CheckACell(ACol, ARow, False, True, 0, 1);
  end;
end;

procedure TframePrtDisplay.rdgLimitsStateChange(Sender: TObject; ACol, ARow:
    LongInt; const Value: TCheckBoxState);
begin
  rdgLimits.Invalidate;
end;

procedure TframePrtDisplay.rdgSetLimitsButtonClick(Sender: TObject; ACol, ARow:
    LongInt);
var
  Row: TTrackSetLimits;
  Choices: TStringList;
  Selection: TIntegerCollection;
  SelectedChoices: TStringList;
  NewSelectedChoices: TStringList;
  frmPrtChoices: TfrmPrtChoices;
  Tracks: TPrtTracks;
  SelectedIndex: Integer;
  SpecifiedTimes: TRealCollection;
begin
  Row := TTrackSetLimits(ARow);
  if Row = tlsNone then
  begin
    Exit;
  end;
  frmPrtChoices := TfrmPrtChoices.Create(nil);
  Choices := TStringList.Create;
  SelectedChoices := TStringList.Create;
  NewSelectedChoices := TStringList.Create;
  Selection := TIntegerCollection.Create(nil);
  try
    Tracks := FLocalTracksDisplayer.Tracks;
    SelectedChoices.CommaText := rdgSetLimits.Cells[ACol, ARow];
    case Row of
      tlPrpPackage:
        begin
          for var Index := 0 to Tracks.IprpCount - 1 do
          begin
            Choices.Add(Index.ToString);
          end;
          for var Index := 0 to SelectedChoices.Count - 1 do
          begin
            SelectedIndex := Choices.IndexOf(SelectedChoices[Index]);
            Selection.Add.Value := SelectedIndex;
          end;
        end;
      tlReason:
        begin
          Choices.Add('0: particle was released');
          Choices.Add('1: particle exited a grid feature');
          Choices.Add('2: time step ended');
          Choices.Add('3: particle terminated');
          Choices.Add('4: particle entered a weak sink cell');
          Choices.Add('5: user-specified tracking time');
          Choices.Add('6: particle dropped to water table');
          for var Index := 0 to SelectedChoices.Count - 1 do
          begin
            SelectedIndex := SelectedChoices[Index].ToInteger;
            Selection.Add.Value := SelectedIndex;
          end;
         end;
      tlZone:
        begin
          Choices.Assign(Tracks.Zones);
          for var Index := 0 to SelectedChoices.Count - 1 do
          begin
            SelectedIndex := SelectedChoices[Index].ToInteger;
            Selection.Add.Value := SelectedIndex;
          end;
        end;
      tlStatus:
        begin
          Choices.Add('0: particle was released');
          Choices.Add('1: particle is being actively tracked');
          Choices.Add('2: particle terminated at a boundary face');
          Choices.Add('3: particle terminated in a weak sink cell');
          Choices.Add('4: unused');
          Choices.Add('5: particle terminated in a cell with no exit face');
          Choices.Add('6: particle terminated in a stop zone');
          Choices.Add('7: particle terminated in an inactive cell');
          Choices.Add('8: particle terminated immediately upon attempted release into an inactive cell');
          Choices.Add('9: particle terminated in a subcell with no exit face');
          Choices.Add('10: particle terminated at stop time or end of simulation');
          for var Index := 0 to SelectedChoices.Count - 1 do
          begin
            SelectedIndex := SelectedChoices[Index].ToInteger;
            Selection.Add.Value := SelectedIndex;
          end;
        end;
      tlSelectedTimes:
        begin
          SpecifiedTimes := Tracks.SpecifiedTimes;
          for var TimeIndex := 0 to SpecifiedTimes.Count - 1 do
          begin
            Choices.Add(SpecifiedTimes[TimeIndex].ToString);
          end;
          for var Index := 0 to SelectedChoices.Count - 1 do
          begin
            SelectedIndex := Choices.IndexOf(SelectedChoices[Index]);
            Selection.Add.Value := SelectedIndex;
          end;
        end;
      else
        Assert(False);
    end;
    frmPrtChoices.Choices := Choices;
    frmPrtChoices.Selection := Selection;
    if frmPrtChoices.ShowModal = mrOK then
    begin
      Selection.Assign(frmPrtChoices.Selection);

      case Row of
        tlPrpPackage:
          begin
            for var SelectIndex := 0 to Selection.Count - 1 do
            begin
              NewSelectedChoices.Add(Choices[Selection[SelectIndex].Value]);
            end;
          end;
        tlReason:
          begin
            for var SelectIndex := 0 to Selection.Count - 1 do
            begin
              NewSelectedChoices.Add(Selection[SelectIndex].Value.ToString);
            end;
          end;
        tlZone:
          begin
            for var SelectIndex := 0 to Selection.Count - 1 do
            begin
              NewSelectedChoices.Add(Selection[SelectIndex].Value.ToString);
            end;
          end;
        tlStatus:
          begin
            for var SelectIndex := 0 to Selection.Count - 1 do
            begin
              NewSelectedChoices.Add(Selection[SelectIndex].Value.ToString);
            end;
          end;
        tlSelectedTimes:
          begin
            for var SelectIndex := 0 to Selection.Count - 1 do
            begin
              NewSelectedChoices.Add(Choices[Selection[SelectIndex].Value]);
            end;
          end;
        else
          Assert(False);
      end;
      rdgSetLimits.Cells[ACol, ARow] := NewSelectedChoices.CommaText;
    end;
  finally
    frmPrtChoices.Free;
    Choices.Free;
    Selection.Free;
    SelectedChoices.Free;
    NewSelectedChoices.Free;
  end;

end;

procedure TframePrtDisplay.rdgSetLimitsSelectCell(Sender: TObject; ACol, ARow:
    LongInt; var CanSelect: Boolean);
begin
  case ACol of
    0:
      begin
        // do nothing.
      end;
    1:
      begin
        CanSelect := rdgLimits.Checked[0,ARow];
      end;
    else Assert(False);
  end;
end;

procedure TframePrtDisplay.rdgSetLimitsStateChange(Sender: TObject; ACol, ARow:
    LongInt; const Value: TCheckBoxState);
begin
  rdgLimits.Invalidate;
end;

procedure TframePrtDisplay.ReadByteSetLimit(ByteLimits: TByteSetLimits;
  ALimitRow: TTrackSetLimits);
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
      rdgSetLimits.Cells[1, ARow] := AStringList.CommaText;
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

procedure TframePrtDisplay.ReadReasonLimit(ReasonLimit: TReasonLimit;
  LimitRow: TTrackSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
begin
  ARow := Ord(LimitRow);
  rdgLimits.Checked[0, ARow] := ReasonLimit.UseLimit;
  if ReasonLimit.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      for var Reason in ReasonLimit.UsedReasons do
      begin
        AStringList.Add(Ord(Reason).ToString);
      end;
      rdgSetLimits.Cells[1, ARow] := AStringList.CommaText;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.ReadSelectedTimeLimit(
  SelectedTimeLimits: TSelectedTimeLimit; LimitRow: TTrackSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
begin
  ARow := Ord(LimitRow);
  rdgLimits.Checked[0, ARow] := SelectedTimeLimits.UseLimit;
  if SelectedTimeLimits.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      for var Index := 0 to SelectedTimeLimits.UsedTimes.Count -1 do
      begin
        AStringList.Add(FortranFloatToStr(SelectedTimeLimits.UsedTimes[Index].Value));
      end;
      rdgSetLimits.Cells[1, ARow] := AStringList.CommaText;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.ReadStatusLimit(StatusLimit: TStatusLimit;
  LimitRow: TTrackSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
begin
  ARow := Ord(LimitRow);
  rdgLimits.Checked[0, ARow] := StatusLimit.UseLimit;
  if StatusLimit.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      for var Status in StatusLimit.UsedStatus do
      begin
        AStringList.Add(Ord(Status).ToString);
      end;
      rdgSetLimits.Cells[1, ARow] := AStringList.CommaText;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.rgColorByClick(Sender: TObject);
begin
  rdgLimits.Invalidate;
end;

procedure TframePrtDisplay.rgShow2DClick(Sender: TObject);
begin
  rdgLimits.Invalidate;
end;

procedure TframePrtDisplay.seColorExponentChange(Sender: TObject);
begin
  jsColorExponent.Value := Round(seColorExponent.Value * 100);
  pbColorScheme.Invalidate
end;

procedure TframePrtDisplay.seCyclesChange(Sender: TObject);
begin
  pbColorScheme.Invalidate;
end;

procedure TframePrtDisplay.SetByteSetLimit(LimitRow: TTrackSetLimits;
  ByteLimit: TByteSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
begin
  ARow := Ord(LimitRow);
  ByteLimit.UseLimit := rdgLimits.Checked[0, ARow];
  if ByteLimit.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      ByteLimit.Limits.Clear;
      AStringList.CommaText := rdgSetLimits.Cells[1, ARow];
      for var Index := 0 to AStringList.Count - 1 do
      begin
        ByteLimit.Limits.Add.Value := AStringList[Index].ToInteger;
      end;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.SetData;
var
  TrackDisplayer: TPrtTrackDisplayer;
  ColorParameters: TColorParameters;
  ExistingTrackDisplayer: TPrtTrackDisplayer;
  ADate: TDateTime;
  Undo: TUndoImportPrtTrack;
  ColorLimits: TPrtColorLimits;
  ImportedNewFile: Boolean;
  ARow: Integer;
  LocalModel: TCustomModel;
  PlotTypes: TPrtPlotTypes;
  PrtTrackDisplayLimits: TPrtTrackDisplayLimits;
  MinTime: double;
  MaxTime: double;
begin
  inherited;

  if (frmGoPhast.PhastModel.ColumnCount <= 0) then
  begin
    Beep;
    MessageDlg('You must define the grid or DISV mesh before attempting to import PRT Tracklilne results.', mtError, [mbOK], 0);
    Exit;
  end;

  ImportedNewFile := False;

  LocalModel := frmGoPhast.PhastModel;

  ExistingTrackDisplayer := LocalModel.PrtTracks;
  TrackDisplayer := TPrtTrackDisplayer.Create(LocalModel);
  try
    TrackDisplayer.Assign(ExistingTrackDisplayer);

    TrackDisplayer.FileName := fedPrtTracklineFile.FileName;
    if TrackDisplayer.FileName = '' then
    begin
      TrackDisplayer.Clear;
    end
    else
    begin
      if FileExists(TrackDisplayer.FileName) then
      begin

        if(TrackDisplayer.FileName <> ExistingTrackDisplayer.FileName) then
        begin
          try
            TrackDisplayer.ReadFile;
          except
            on E: EInvalidLayer do
            begin
              Beep;
              MessageDlg(E.message, mtError, [mbOK], 0);
              TrackDisplayer.FileName := '';
              Exit;
            end;
            on E: EInOutError do
            begin
              Beep;
              MessageDlg(Format(StrThereWasAnErrorR, [E.message]), mtError, [mbOK], 0);
              TrackDisplayer.FileName := '';
              Exit;
            end;
          end;
          ImportedNewFile := True;
        end
        else
        begin
          if FileAge(TrackDisplayer.FileName, ADate)
            and (TrackDisplayer.FileDate <> ADate) then
          begin
            if (MessageDlg(StrThePathlineFileOn,
              mtInformation, [mbYes, mbNo], 0) = mrYes) then
            begin
              TrackDisplayer.ReadFile;
              ImportedNewFile := True;
            end;
          end;
        end;
      end;

      PrtTrackDisplayLimits := TrackDisplayer.PrtTrackDisplayLimits;
      PrtTrackDisplayLimits.EndPointSize := seSinglePointSize.AsInteger;
      PlotTypes := [];
      for var PlotTypeIndex := Low(TPrtPlotType) to High(TPrtPlotType) do
      begin
        if chklstPlotTypes.Checked[Ord(PlotTypeIndex)] then
        begin
          Include(PlotTypes, PlotTypeIndex);
        end;
      end;
      PrtTrackDisplayLimits.PlotTypes := PlotTypes;

//      Limits := TrackDisplayer.DisplayLimits;

      PrtTrackDisplayLimits.LimitToCurrentIn2D := cbLimitToCurrentIn2D.Checked;
      PrtTrackDisplayLimits.ShowChoice := TShowChoice(rgShow2D.ItemIndex);

      if PrtTrackDisplayLimits.ShowChoice <> scAll then
      begin
        SetIntLimit(tlColumn, LocalModel.ColumnCount, PrtTrackDisplayLimits.ColumnLimits);
        SetIntLimit(tlRow, LocalModel.RowCount, PrtTrackDisplayLimits.RowLimits);
        SetIntLimit(tlLayer, LocalModel.LayerCount, PrtTrackDisplayLimits.LayerLimits);
//        SetIntLimit(tlLineNumber, LocalModel.ColumnCount, PrtTrackDisplayLimits.ParticleGroupLimits);
        SetIntLimit(tlLineNumber, TrackDisplayer.Tracks.MaxLineNumber, PrtTrackDisplayLimits.LineNumberLimits);

        if not TrackDisplayer.Tracks.TestGetMinMaxTime(MinTime, MaxTime) then
        begin
          MinTime := 0;
          MaxTime := 0;
        end;

        SetFloatLimit(tlTime, MinTime, MaxTime, PrtTrackDisplayLimits.TimeLimits);
        SetFloatLimit(tlReleaseTime, MinTime, MaxTime, PrtTrackDisplayLimits.ReleaseTimeLimits);

        SetByteSetLimit(tlPrpPackage, PrtTrackDisplayLimits.PrpLimits);
        SetByteSetLimit(tlZone, PrtTrackDisplayLimits.ZoneLimits);
        SetStatusLimit(PrtTrackDisplayLimits.StatusLimit, tlStatus);
        SetReasonLimit(PrtTrackDisplayLimits.ReasonLimits, tlSelectedTimes);
        SetSelectedTimeLimit(PrtTrackDisplayLimits.SelectedTimeLimits, tlSelectedTimes);
     end;

      ColorLimits := PrtTrackDisplayLimits.ColorLimits;
      ColorLimits.ColoringChoice :=
        TPrtColorLimitChoice(rgColorBy.ItemIndex);

      if ColorLimits.ColoringChoice <> pcNone then
      begin
        ARow := Ord(tlColors);
        ColorLimits.UseLimit := rdgLimits.Checked[0, ARow];
        if ColorLimits.UseLimit then
        begin
          ColorLimits.MinColorLimit := StrToFloatDef(rdgLimits.Cells[1, ARow], 0);
          ColorLimits.MaxColorLimit := StrToFloatDef(rdgLimits.Cells[2, ARow], 1);
        end;

      end;

      ColorParameters := PrtTrackDisplayLimits.ColorParameters;
      ColorParameters.ColorScheme := comboColorScheme.ItemIndex;
      ColorParameters.ColorCycles := seCycles.AsInteger;
      ColorParameters.ColorExponent := seColorExponent.Value;
    end;

    Undo := TUndoImportPrtTrack.Create(LocalModel, TrackDisplayer, ImportedNewFile);
    frmGoPhast.UndoStack.Submit(Undo);
  finally
    TrackDisplayer.Free;
  end;
end;

procedure TframePrtDisplay.SetFloatLimit(LimitRow: TTrackLimits; MinLimit,
  MaxLimit: Double; FloatLimit: TShowFloatLimit);
var
  ARow: Integer;
begin
  ARow := Ord(LimitRow);
  FloatLimit.UseLimit := rdgLimits.Checked[0, ARow];
  if FloatLimit.UseLimit then
  begin
    FloatLimit.StartLimit := StrToFloatDef(rdgLimits.Cells[1, ARow], MinLimit);
    FloatLimit.EndLimit := StrToFloatDef(rdgLimits.Cells[2, ARow], MaxLimit);
  end;
end;

procedure TframePrtDisplay.SetIntLimit(LimitRow: TTrackLimits;
  DefaultLimit: integer; IntLimit: TShowIntegerLimit);
var
  ARow: Integer;
begin
  ARow := Ord(LimitRow);
  IntLimit.UseLimit := rdgLimits.Checked[0, ARow];
  if IntLimit.UseLimit then
  begin
    IntLimit.StartLimit := StrToIntDef(rdgLimits.Cells[1, ARow], 1);
    IntLimit.EndLimit := StrToIntDef(rdgLimits.Cells[2, ARow], DefaultLimit);
  end;
end;

procedure TframePrtDisplay.SetReasonLimit(ReasonLimit: TReasonLimit;
  LimitRow: TTrackSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
  Reasons: TReasons;
  AReason: TReason;
begin
  ARow := Ord(LimitRow);
  ReasonLimit.UseLimit := rdgLimits.Checked[0, ARow];
  if ReasonLimit.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      Reasons := [];
      AStringList.CommaText := rdgSetLimits.Cells[1, ARow];
      for var Index := 0 to AStringList.Count -1 do
      begin
        AReason := TReason(AStringList[Index].ToInteger);
        Include(Reasons, AReason);
      end;
      ReasonLimit.UsedReasons := Reasons;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.SetSelectedTimeLimit(
  SelectedTimeLimits: TSelectedTimeLimit; LimitRow: TTrackSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
begin
  ARow := Ord(LimitRow);
  SelectedTimeLimits.UseLimit := rdgLimits.Checked[0, ARow];
  if SelectedTimeLimits.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      SelectedTimeLimits.UsedTimes.Clear;
      AStringList.CommaText := rdgSetLimits.Cells[1, ARow];
      for var Index := 0 to AStringList.Count - 1 do
      begin
        SelectedTimeLimits.UsedTimes.Add.Value := FortranStrToFloat(AStringList[Index]);
      end;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.SetStatusLimit(StatusLimit: TStatusLimit;
  LimitRow: TTrackSetLimits);
var
  ARow: Integer;
  AStringList: TStringList;
  Statuses: TStatuses;
  Status: TStatus;
begin
  ARow := Ord(LimitRow);
  StatusLimit.UseLimit := rdgLimits.Checked[0, ARow];
  if StatusLimit.UseLimit then
  begin
    AStringList := TStringList.Create;
    try
      Statuses := [];
      AStringList.CommaText := rdgSetLimits.Cells[1, ARow];
      for var Index := 0 to AStringList.Count -1 do
      begin
        Status := TStatus(AStringList[Index].ToInteger);
        Include(Statuses, Status);
      end;
      StatusLimit.UsedStatus := Statuses;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TframePrtDisplay.UpdateColorSchemes;
begin
  UpdateColorScheme(comboColorScheme, pbColorScheme);
end;

end.
