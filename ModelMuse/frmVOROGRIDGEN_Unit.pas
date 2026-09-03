unit frmVOROGRIDGEN_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCustomGoPhastUnit, Vcl.StdCtrls,
  ArgusDataEntry, Vcl.Mask, JvExMask, JvToolEdit, JvSpin, Vcl.Buttons,
  Vcl.ExtCtrls;

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
    procedure btnOKClick(Sender: TObject);
  private
    procedure SetData;
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
  RunVoroGridGenUnit;

{$R *.dfm}

procedure TfrmVOROGRIDGEN.btnOKClick(Sender: TObject);
begin
  SetData;
  inherited;
end;

procedure TfrmVOROGRIDGEN.SetData;
var
  Options: TVorogridGenOptions;
begin
  Options.BaseFileName := fedOutFileBase.FileName;
  Options.MaxCentroidSeparation := rdeCentroidSeparation.RealValue;
  Options.MaxCells := seMaxCells.AsInteger;
  Options.PolyGrowthRate := rdePolyGrowthRate.RealValue;
  Options.SearchDimensionsUsed := cbNsdim.Checked;
  Options.SearchDimensions := rdeNsdim.IntegerValue;
  Options.MaxLloydUsed := cbMaxLloyd.Checked;
  Options.MaxLloyd := rdeMaxLloyd.IntegerValue;
  Options.EpsLloydUsed := cbEpsLloyd.Checked;
  Options.EpsLloyd := rdeEpsLloyd.RealValue;
  Options.LloydFactorUsed := cblLloydFac.Checked;
  Options.LloydFactor := rdeEpsLloyd1.RealValue;
  Options.SafetyUsed := cbSafety.Checked;
  Options.Safety := seSafety.AsInteger;

  RunVorGridGen(Options);
end;

end.
