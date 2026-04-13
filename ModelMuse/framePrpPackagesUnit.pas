unit framePrpPackagesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameGridUnit,
  ModflowPackageSelectionUnit, Vcl.ComCtrls;

type
  TPrpPackagedDeletedEvent = procedure (Sender: TObject; frame: TFrame) of Object;

  TframePrpMultiplePackages = class(TFrame)
    framePrpPackages: TframeGrid;
    pcPrt: TPageControl;
    tabOptions: TTabSheet;
    tabPrpPackages: TTabSheet;
    tabTrackTimes: TTabSheet;
  private
    FOnPrpPackageDeleted: TPrpPackagedDeletedEvent;
    FOnPrpPackageAdded: TNotifyEvent;
    Procedure Initialize;
    { Private declarations }
  public
    procedure GetData(PrtModel: TPrtModel);
    procedure SetData(PrtModel: TPrtModel);
    property OnPrpPackageAdded: TNotifyEvent read FOnPrpPackageAdded write FOnPrpPackageAdded;
    property OnPrpPackageDeleted: TPrpPackagedDeletedEvent read FOnPrpPackageDeleted write FOnPrpPackageDeleted;
    { Public declarations }
  end;

implementation

{$R *.dfm}

type
  TPrpColumns = (pcName, ptUsed);

{ TframePrpMultiplePackages }

procedure TframePrpMultiplePackages.GetData(PrtModel: TPrtModel);
begin
  Initialize;
end;

procedure TframePrpMultiplePackages.Initialize;
begin
  framePrpPackages.Grid.Cells[Ord(pcName ), 0] := 'Package Name';
  framePrpPackages.Grid.Cells[Ord(ptUsed ), 0] := 'Package Used';
end;

procedure TframePrpMultiplePackages.SetData(PrtModel: TPrtModel);
begin

end;

end.
