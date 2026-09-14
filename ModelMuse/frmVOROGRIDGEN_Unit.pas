unit frmVOROGRIDGEN_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCustomGoPhastUnit, Vcl.StdCtrls,
  ArgusDataEntry, Vcl.Mask, JvExMask, JvToolEdit, JvSpin, Vcl.Buttons,
  Vcl.ExtCtrls, RunVoroGridGenUnit, JvExStdCtrls, JvHtControls, System.UITypes;

type
  TfrmVOROGRIDGEN = class(TfrmCustomGoPhast)
    fedOutFileBase: TJvFilenameEdit;
    lblOutFileBase: TLabel;
    rdeCentroidSeparation: TRbwDataEntry;
    lblMaxCentroidSeparation: TLabel;
    seMaxCells: TJvSpinEdit;
    lblMaxCells: TLabel;
    lblPolyGrowthRate: TLabel;
    rdePolyGrowthRate: TRbwDataEntry;
    lblNsdim: TLabel;
    rdeNsdim: TRbwDataEntry;
    cbNsdim: TCheckBox;
    cbMaxLloyd: TCheckBox;
    lblMaxLloyd: TLabel;
    rdeMaxLloyd: TRbwDataEntry;
    lblEpsLloyd: TLabel;
    cbEpsLloyd: TCheckBox;
    rdeEpsLloyd: TRbwDataEntry;
    lblLloydFac: TLabel;
    cblLloydFac: TCheckBox;
    rdeEpsLloyd1: TRbwDataEntry;
    seSafety: TJvSpinEdit;
    lblMaxCells1: TLabel;
    cbSafety: TCheckBox;
    pnlBottom: TPanel;
    btnHelp: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    fedVorogridGen: TJvFilenameEdit;
    lblVoroGridGen: TLabel;
    jvhtlblVoroGridGet: TJvHTLabel;
    procedure FormDestroy(Sender: TObject); override;
    procedure FormCreate(Sender: TObject); override;
    procedure btnOKClick(Sender: TObject);
    procedure fedVorogridGenChange(Sender: TObject);
  private
    FVorogridGenOptions: TVorogridGenOptions;
    procedure GetData;
    procedure SetData;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  System.IOUtils, UndoItems, frmGoPhastUnit;

{$R *.dfm}

resourcestring
  SNewerVersionOfVOROGRIDGEN = 'There is a newer version of VOROGRIDGEN. Do you want to use your existing copy of VOROGRIDGEN anyway?';

var
  VoroGridGenDate: TDate;

type
  TUndoVorogridGenOptions = class(TCustomUndo)
  private
    FNewVorogridGenOptions: TVorogridGenOptions;
    FOldVorogridGenOptions: TVorogridGenOptions;
  protected
    // See TCustomUndo.@link(TCustomUndo.Description).
    function Description: string; override;
  public
    constructor Create(var NewVorogridGenOptions: TVorogridGenOptions);
    destructor Destroy; override;
    procedure DoCommand; override;
    procedure Undo; override;
  end;

procedure TfrmVOROGRIDGEN.FormDestroy(Sender: TObject);
begin
  FVorogridGenOptions.Free;
  inherited;
end;

procedure TfrmVOROGRIDGEN.GetData;
begin
  FVorogridGenOptions.Assign(frmGoPhast.PhastModel.VorogridGenOptions);
  fedVorogridGen.FileName := FVorogridGenOptions.VoroGridGenLocation;
  fedOutFileBase.FileName := FVorogridGenOptions.BaseFileName;
  rdeCentroidSeparation.RealValue := FVorogridGenOptions.MaxCentroidSeparation;
  seMaxCells.AsInteger := FVorogridGenOptions.MaxCells;
  rdePolyGrowthRate.RealValue := FVorogridGenOptions.PolyGrowthRate;
  cbNsdim.Checked := FVorogridGenOptions.SearchDimensionsUsed;
  rdeNsdim.IntegerValue := FVorogridGenOptions.SearchDimensions;
  cbMaxLloyd.Checked := FVorogridGenOptions.MaxLloydUsed;
  rdeMaxLloyd.IntegerValue := FVorogridGenOptions.MaxLloyd;
  cbEpsLloyd.Checked := FVorogridGenOptions.EpsLloydUsed;
  rdeEpsLloyd.RealValue := FVorogridGenOptions.EpsLloyd;
  cblLloydFac.Checked := FVorogridGenOptions.LloydFactorUsed;
  rdeEpsLloyd1.RealValue := FVorogridGenOptions.LloydFactor;
  cbSafety.Checked := FVorogridGenOptions.SafetyUsed;
  seSafety.AsInteger := FVorogridGenOptions.Safety;
end;

procedure TfrmVOROGRIDGEN.FormCreate(Sender: TObject);
var
  NullNotify: TNotifyEvent;
begin
  inherited;
  NullNotify := nil;
  FVorogridGenOptions := TVorogridGenOptions.Create(NullNotify);
  GetData;
end;

procedure TfrmVOROGRIDGEN.btnOKClick(Sender: TObject);
var
  VoroDate: TDate;
  BaseDirectory: string;
begin
  if not TFile.Exists(fedVorogridGen.FileName) then
  begin
    Beep;
    MessageDlg(Format('%s does not exist.', [fedVorogridGen.FileName]), mtWarning, [mbOK], 0);
    Exit;
  end;
  VoroDate := Trunc(TFile.GetLastWriteTime(fedVorogridGen.FileName));
  if VoroDate < VoroGridGenDate then
  begin
    if (MessageDlg(SNewerVersionOfVOROGRIDGEN, mtConfirmation, [mbYes, mbNo], 0, mbNo) <> mrYes) then
    begin
      Exit;
    end;
  end;
  BaseDirectory := ExtractFilePath(fedOutFileBase.FileName);
  if not TDirectory.Exists(BaseDirectory) then
  begin
    Beep;
    MessageDlg(Format('%s does not exist.', [BaseDirectory]), mtWarning, [mbOK], 0);
    Exit;
  end;
  SetData;
  inherited;
end;

procedure TfrmVOROGRIDGEN.fedVorogridGenChange(Sender: TObject);
begin
  inherited;
  if TFile.Exists(fedVorogridGen.FileName) then
  begin
    fedVorogridGen.Color := clWindow;
  end
  else
  begin
    fedVorogridGen.Color := clRed;
  end;
end;

procedure TfrmVOROGRIDGEN.SetData;
begin
  FVorogridGenOptions.VoroGridGenLocation := fedVorogridGen.FileName;
  FVorogridGenOptions.BaseFileName := fedOutFileBase.FileName;
  FVorogridGenOptions.MaxCentroidSeparation := rdeCentroidSeparation.RealValue;
  FVorogridGenOptions.MaxCells := seMaxCells.AsInteger;
  FVorogridGenOptions.PolyGrowthRate := rdePolyGrowthRate.RealValue;
  FVorogridGenOptions.SearchDimensionsUsed := cbNsdim.Checked;
  FVorogridGenOptions.SearchDimensions := rdeNsdim.IntegerValue;
  FVorogridGenOptions.MaxLloydUsed := cbMaxLloyd.Checked;
  FVorogridGenOptions.MaxLloyd := rdeMaxLloyd.IntegerValue;
  FVorogridGenOptions.EpsLloydUsed := cbEpsLloyd.Checked;
  FVorogridGenOptions.EpsLloyd := rdeEpsLloyd.RealValue;
  FVorogridGenOptions.LloydFactorUsed := cblLloydFac.Checked;
  FVorogridGenOptions.LloydFactor := rdeEpsLloyd1.RealValue;
  FVorogridGenOptions.SafetyUsed := cbSafety.Checked;
  FVorogridGenOptions.Safety := seSafety.AsInteger;

  RunVorGridGen(FVorogridGenOptions);

  frmGoPhast.UndoStack.Submit(TUndoVorogridGenOptions.Create(FVorogridGenOptions));
end;

{ TUndoVorogridGenOptions }

constructor TUndoVorogridGenOptions.Create(
  var NewVorogridGenOptions: TVorogridGenOptions);
var
  NilNotify: TNotifyEvent;
begin
  FNewVorogridGenOptions := NewVorogridGenOptions;
  NewVorogridGenOptions := nil;
  NilNotify := nil;
  FOldVorogridGenOptions := TVorogridGenOptions.Create(NilNotify);
  FOldVorogridGenOptions.Assign(frmGoPhast.PhastModel.VorogridGenOptions);
end;

function TUndoVorogridGenOptions.Description: string;
begin
  result := 'Change VOROGRIDGEN Options';
end;

destructor TUndoVorogridGenOptions.Destroy;
begin
  FNewVorogridGenOptions.Free;
  FOldVorogridGenOptions.Free;
  inherited;
end;

procedure TUndoVorogridGenOptions.DoCommand;
begin
  inherited;
  frmGoPhast.PhastModel.VorogridGenOptions.Assign(FNewVorogridGenOptions);
end;

procedure TUndoVorogridGenOptions.Undo;
begin
  frmGoPhast.PhastModel.VorogridGenOptions.Assign(FOldVorogridGenOptions);
  inherited;

end;

initialization
  VoroGridGenDate := EncodeDate(2026, 2,8);

end.
