unit framePrtDisplayUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, RbwDataGrid4,
  Vcl.StdCtrls, Vcl.ExtCtrls, JvSpin, JvExControls, JvxSlider, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.ComCtrls, UndoItems,
  PhastModelUnit, PathlineReader;

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
    cbShowPathlines: TCheckBox;
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
  private
    { Private declarations }
  public
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
  StrImportPathline = 'import Prt Track';
  StrConfigurePathline = 'configure Prt Track';
  StrThereWasAnErrorR = 'There was an error reading the Prt Track file. It ma' +
  'y have been locked or there might have been some other error. The error m' +
  'essage was "%s".';

{ TUndoImportPrtTrack }

constructor TUndoImportPrtTrack.Create(Model: TCustomModel;
  var NewPathLine: TPrtTrackDisplayer; ImportedNewFile: boolean);
var
  InvalidateModelEvent: TNotifyEvent;
begin
  FModel := Model;
  InvalidateModelEvent := nil;
  FImportedNewFile := ImportedNewFile;
  FExistingPathLines:= TPrtTrackDisplayer.Create(InvalidateModelEvent);
  FExistingPathLines.Assign(frmGoPhast.PhastModel.PrtTracks);
  // Take ownership of NewPathLine.
  FNewPathLines := NewPathLine;
  NewPathLine := nil;

end;

function TUndoImportPrtTrack.Description: string;
begin
  if FImportedNewFile then
  begin
    result := StrImportPathline;
  end
  else
  begin
    result := StrConfigurePathline;
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

end.
