unit framePrtModelsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, frameGridUnit,
  framePrpMultiplePackagesUnit, JvPageList, FramePackageNodeLinkUnit,
  ModflowPackageSelectionUnit;

type
  TframePrtModels = class(TFrame)
    framePrtModelsGrid: TframeGrid;
    procedure framePrtModelsGridGridEndUpdate(Sender: TObject);
    procedure framePrtModelsGridseNumberChange(Sender: TObject);
  private
    FMemoWidthDelta: Integer;
    FPackageTreeView: TTreeView;
    FNode: TTreeNode;
    FPageList: TJvPageList;
    FLinkDictionary: TLinkDictionary;
    FFrameNodeLinks: TLinkObjectList;
    function CreateNewPrtFrame: TframePrpMultiplePackages;
    Procedure Initialize;
    { Private declarations }
  public
    procedure ClearFrames;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetData(PrtModels: TPrtModels; PackageTreeView: TTreeView;
      Node: TTreeNode; PageList: TJvPageList; LinkDictionary: TLinkDictionary);
    procedure SetData(PrtModels: TPrtModels);
    { Public declarations }
  end;

implementation

resourcestring
  StrPRTModelName = 'PRT Model Name';
  StrModelUsed = 'Model Used';

{$R *.dfm}

type
  TPrtModelColumns = (pmcName, pmcUsed);

{ TframePrtModels }

procedure TframePrtModels.ClearFrames;
var
  ALink: TFrameNodeLink;
  Page: TJvStandardPage;
begin
  for var Index := 0 to FFrameNodeLinks.Count - 1 do
  begin
     ALink := FFrameNodeLinks[Index];
     FLinkDictionary.Remove(ALink.Frame);
     Page := ALink.Frame.Parent as TJvStandardPage;
     Page.Free;
     ALink.Node.Free;
//     ALink.Free;
  end;
  FFrameNodeLinks.Clear;
end;

constructor TframePrtModels.Create(AOwner: TComponent);
begin
  inherited;
  FFrameNodeLinks := TLinkObjectList.Create;
end;

function TframePrtModels.CreateNewPrtFrame: TframePrpMultiplePackages;
var
  NewPage: TJvStandardPage;
  ChildNode: TTreeNode;
  Link: TFrameNodeLink;
begin
//  Result := TframePrpMultiplePackages.Create(nil);

//  result.pgcControls.Anchors := result.pgcControls.Anchors + [akTop];
//  result.Selected := True;
//  FframePkgSmsObjectList.Add(result);
  NewPage := TJvStandardPage.Create(nil);
  Result := TframePrpMultiplePackages.Create(NewPage);

//  result.pgcControls.Anchors := result.pgcControls.Anchors + [akTop];
//  result.Selected := True;
//  FframePkgSmsObjectList.Add(result);
  NewPage.Name := '';
//  NewPage.HelpKeyword := 'SMS_Sparse_Matrix_Solution_Pac';
  NewPage.PageList := FPageList;
//  NewPage.OnShow := ShowImsPage;
  result.Parent := NewPage;
  result.MemoWidthDelta := result.Width - result.MemoComments.Width;
  result.Align := alClient;
  NewPage.OnResize := result.ResizeFrame;

  ChildNode := FPackageTreeView.Items.AddChild(FNode, 'PRT: Particle Tracking');
  ChildNode.Data := NewPage;

  Link := TFrameNodeLink.Create;
  Link.Frame := Result;
  Link.Node := ChildNode;
  Link.AlternateNode := ChildNode;
  FFrameNodeLinks.Add(Link);
  FLinkDictionary.Add(Link.Frame, Link);
  Result.Initialize(FPackageTreeView, FNode, FPageList, FLinkDictionary);
;
end;

destructor TframePrtModels.Destroy;
begin
  ClearFrames;
  FFrameNodeLinks.Free;
  inherited;
end;

procedure TframePrtModels.framePrtModelsGridGridEndUpdate(Sender: TObject);
begin
  if (ComponentState <> []) then
  begin
    Exit;
  end;

  framePrtModelsGrid.GridEndUpdate(Sender);
end;

procedure TframePrtModels.framePrtModelsGridseNumberChange(Sender: TObject);
var
  NewFrame: TframePrpMultiplePackages;
begin
  if (ControlState <> []) then
  begin
    Exit;
  end;

  framePrtModelsGrid.seNumberChange(Sender);
  for var Index := 0 to framePrtModelsGrid.seNumber.AsInteger - 1 do
  begin
    if framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index+1] = nil then
    begin
      NewFrame := CreateNewPrtFrame;
      framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index+1] := NewFrame;
    end;
  end;
end;

procedure TframePrtModels.GetData(PrtModels: TPrtModels;
  PackageTreeView: TTreeView; Node: TTreeNode; PageList: TJvPageList;
  LinkDictionary: TLinkDictionary);
var
  PrtModel: TPrtModel;
  NewPrtFrame: TframePrpMultiplePackages;
begin
  Initialize;

  FPackageTreeView := PackageTreeView;
  FNode := Node;
  FPageList := PageList;
  FLinkDictionary := LinkDictionary;


  framePrtModelsGrid.Grid.BeginUpdate;
  try
    framePrtModelsGrid.seNumber.AsInteger := PrtModels.Count;
    for var Index := 0 to PrtModels.Count - 1 do
    begin
      PrtModel := PrtModels[Index].PrtModel;
      framePrtModelsGrid.Grid.Cells[Ord(pmcName), Index+1] := PrtModel.ModelName;
      framePrtModelsGrid.Grid.Checked[Ord(pmcUsed), Index+1] := PrtModel.IsSelected;
      framePrtModelsGrid.Grid.Objects[Ord(pmcName), Index+1] := PrtModel;

      NewPrtFrame := CreateNewPrtFrame;
      NewPrtFrame.GetData(PrtModel, PackageTreeView, Node, PageList, LinkDictionary);
      framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index+1] := NewPrtFrame;
    end;

  finally
    framePrtModelsGrid.Grid.EndUpdate;
  end;
end;

procedure TframePrtModels.Initialize;
begin
  ClearFrames;

  framePrtModelsGrid.Grid.BeginUpdate;
  try
    framePrtModelsGrid.Grid.Cells[Ord(pmcName), 0] := StrPRTModelName;
    framePrtModelsGrid.Grid.Cells[Ord(pmcUsed), 0] := StrModelUsed;
  finally
    framePrtModelsGrid.Grid.EndUpdate;
  end;

end;

procedure TframePrtModels.SetData(PrtModels: TPrtModels);
var
  PackageColumn: TStrings;
  PrtModel: TPrtModel;
  PackageIndex: Integer;
  PrtFrame: TframePrpMultiplePackages;
  Link: TFrameNodeLink;
begin
  PackageColumn := framePrtModelsGrid.Grid.Cols[Ord(pmcName)];
  for var Index := PrtModels.Count - 1 downto 0 do
  begin
    PrtModel := PrtModels[Index].PrtModel;
    PackageIndex := PackageColumn.IndexOfObject(PrtModel);
    if (PackageIndex < 0) or (PackageIndex > framePrtModelsGrid.seNumber.AsInteger) then
    begin
      PrtModels.Delete(Index);
    end;
  end;
  for var Index := 0 to framePrtModelsGrid.seNumber.AsInteger - 1 do
  begin
    PrtModel := (framePrtModelsGrid.Grid.Objects[Ord(pmcName), Index + 1] as TPrtModelItem).PrtModel;
    If PrtModel = nil then
    begin
      PrtModel := (PrtModels.Add as TPrtModelItem).PrtModel;
    end;
    PrtFrame := framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index + 1] as TframePrpMultiplePackages;
    Assert(PrtFrame <> nil);

    if FLinkDictionary.TryGetValue(PrtFrame, Link) then
    begin
      PrtFrame.GetData(PrtModel, FPackageTreeView, Link.Node, FPageList, FLinkDictionary);
    end
    else
    begin
      Assert(False);
    end;
  end;
end;

end.
