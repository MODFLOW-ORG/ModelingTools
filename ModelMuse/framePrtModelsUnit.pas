unit framePrtModelsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  frameGridUnit, framePrpMultiplePackagesUnit, JvPageList, FramePackageNodeLinkUnit,
  ModflowPackageSelectionUnit, System.AnsiStrings;

type
  TframePrtModels = class(TFrame)
    framePrtModelsGrid: TframeGrid;
    procedure framePrtModelsGridGridBeforeDrawCell(Sender: TObject; ACol, ARow:
        LongInt);
    procedure framePrtModelsGridGridEndUpdate(Sender: TObject);
    procedure framePrtModelsGridGridSelectCell(Sender: TObject; ACol, ARow:
        LongInt; var CanSelect: Boolean);
    procedure framePrtModelsGridGridSetEditText(Sender: TObject; ACol, ARow:
        LongInt; const Value: string);
    procedure framePrtModelsGridGridStateChange(Sender: TObject; ACol, ARow:
        LongInt; const Value: TCheckBoxState);
    procedure framePrtModelsGridseNumberChange(Sender: TObject);
  private
    FPackageTreeView: TTreeView;
    FNode: TTreeNode;
    FPageList: TJvPageList;
    FLinkDictionary: TLinkDictionary;
    FFrameNodeLinks: TLinkObjectList;
    FGettingData: Boolean;
    function CreateNewPrtFrame: TframePrpMultiplePackages;
    Procedure Initialize;
    procedure ClearFrames;
    procedure SelectedChange(Sender: TObject);
    { Private declarations }
  public
    procedure Finalize;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetData(PrtModels: TPrtModels; PackageTreeView: TTreeView;
      Node: TTreeNode; PageList: TJvPageList; LinkDictionary: TLinkDictionary);
    procedure SetData(PrtModels: TPrtModels);
    { Public declarations }
  end;

implementation

uses
  frmCustomGoPhastUnit;

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
  NewPage := TJvStandardPage.Create(nil);
  Result := TframePrpMultiplePackages.Create(NewPage);
  Result.lblPackage.Caption := 'PRT: Particle Tracking';

  NewPage.Name := '';
  NewPage.HelpKeyword := 'PRT-Particle-Tracking-Model';
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
  Result.Initialize(FPackageTreeView, ChildNode, FPageList, FLinkDictionary);

  if not FGettingData then
  begin
    Result.framePrpPackages.seNumber.AsInteger := 1;
    if Assigned(Result.framePrpPackages.seNumber.OnChange) then
    begin
      Result.framePrpPackages.seNumber.OnChange(nil);
    end;
  end;

end;

destructor TframePrtModels.Destroy;
begin
  ClearFrames;
  FFrameNodeLinks.Free;
  inherited;
end;

procedure TframePrtModels.Finalize;
begin
  ClearFrames;
  ClearGrid(framePrtModelsGrid.Grid);
end;

procedure TframePrtModels.framePrtModelsGridGridBeforeDrawCell(Sender: TObject;
    ACol, ARow: LongInt);
var
  AName: string;
begin
  if framePrtModelsGrid.seNumber.AsInteger <= 0 then
  begin
    framePrtModelsGrid.Grid.Canvas.Brush.Color := clBtnFace;
    Exit;
  end;
  if (ACol = Ord(pmcName)) and (ARow >= 1) then
  begin
    AName := framePrtModelsGrid.Grid.Cells[ACol, ARow];
    for var RowIndex := ARow - 1 downto 1 do
    begin
      if SameText(AName,framePrtModelsGrid.Grid.Cells[ACol, RowIndex]) then
      begin
        framePrtModelsGrid.Grid.Canvas.Brush.Color := clRed;
        Exit;
      end;
    end;
  end;
end;

procedure TframePrtModels.framePrtModelsGridGridEndUpdate(Sender: TObject);
begin
  if (ComponentState <> []) then
  begin
    Exit;
  end;

  framePrtModelsGrid.GridEndUpdate(Sender);
end;

procedure TframePrtModels.framePrtModelsGridGridSelectCell(Sender: TObject;
    ACol, ARow: LongInt; var CanSelect: Boolean);
begin
  CanSelect := framePrtModelsGrid.seNumber.AsInteger >= 1;
end;

procedure TframePrtModels.framePrtModelsGridGridSetEditText(Sender: TObject;
    ACol, ARow: LongInt; const Value: string);
var
  Frame: TframePrpMultiplePackages;
  ALink: TFrameNodeLink;
begin
  if (ACol = Ord(pmcName)) and (ARow >= 1) then
  begin
    if framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), ARow] <> nil then
    begin
      Frame := framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), ARow] as TframePrpMultiplePackages;
      if FLinkDictionary.TryGetValue(Frame, ALink) then
      begin
        ALink.Node.Text := Value + ': (PRT Particle Tracking)';
      end;
    end;
  end;
end;

procedure TframePrtModels.framePrtModelsGridGridStateChange(Sender: TObject;
    ACol, ARow: LongInt; const Value: TCheckBoxState);
var
  PrpModelFrame: TframePrpMultiplePackages;
begin
  PrpModelFrame := framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), ARow] as TframePrpMultiplePackages;
  if PrpModelFrame <> nil then
  begin
    PrpModelFrame.Selected := framePrtModelsGrid.Grid.Checked[ACol, ARow];
  end;
end;

procedure TframePrtModels.framePrtModelsGridseNumberChange(Sender: TObject);
var
  NewFrame: TframePrpMultiplePackages;
begin
  framePrtModelsGrid.seNumberChange(Sender);
  if (ControlState <> []) then
  begin
    Exit;
  end;

  if not FGettingData then
  begin
    for var Index := 0 to framePrtModelsGrid.seNumber.AsInteger - 1 do
    begin
      if framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index+1] = nil then
      begin
        NewFrame := CreateNewPrtFrame;
        framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index+1] := NewFrame;
        FNode.Expanded := True;
        Assert(FPackageTreeView <> nil);
        Assert(Assigned(FPackageTreeView.OnChange));
        FPackageTreeView.OnChange(FPackageTreeView, FNode);

        framePrtModelsGrid.Grid.Cells[Ord(pmcName), Index+1] := Format('PRT%d', [Index+1]);
        framePrtModelsGrid.Grid.Checked[Ord(pmcUsed), Index+1] := True;

        if Assigned(framePrtModelsGrid.Grid.OnSetEditText) then
        begin
          framePrtModelsGrid.Grid.OnSetEditText(framePrtModelsGrid.Grid, Ord(pmcName),
            Index+1, framePrtModelsGrid.Grid.Cells[Ord(pmcName), Index+1])
        end;
      end;
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
  FGettingData := True;
  try
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
        NewPrtFrame.GetData(PrtModel);
        framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index+1] := NewPrtFrame;
        framePrtModelsGridGridSetEditText(framePrtModelsGrid.Grid, Ord(pmcName), Index+1, PrtModel.ModelName);
      end;

    finally
      framePrtModelsGrid.Grid.EndUpdate;
    end;
    SelectedChange(nil);
  finally
    FGettingData := False;
  end;
end;

procedure TframePrtModels.Initialize;
begin
  ClearFrames;

  framePrtModelsGrid.Grid.BeginUpdate;
  try
    ClearGrid(framePrtModelsGrid.Grid);
    framePrtModelsGrid.Grid.Cells[Ord(pmcName), 0] := StrPRTModelName;
    framePrtModelsGrid.Grid.Cells[Ord(pmcUsed), 0] := StrModelUsed;
  finally
    framePrtModelsGrid.Grid.EndUpdate;
  end;

  framePrtModelsGrid.seNumber.AsInteger := 0;
end;

procedure TframePrtModels.SelectedChange(Sender: TObject);
begin
  for var RowIndex := 1 to framePrtModelsGrid.seNumber.AsInteger do
  begin
    framePrtModelsGridGridStateChange(Sender, Ord(pmcUsed), RowIndex,
      framePrtModelsGrid.Grid.State[Ord(pmcUsed), RowIndex]);
  end;
end;

procedure TframePrtModels.SetData(PrtModels: TPrtModels);
var
  PackageColumn: TStrings;
  PrtModel: TPrtModel;
//  PackageIndex: Integer;
  PrtFrame: TframePrpMultiplePackages;
  Link: TFrameNodeLink;
  AnObject: TObject;
  ModelItem: TPrtModelItem;
  ModelFound: Boolean;
  StoredModel: TPrtModel;
begin
  PackageColumn := framePrtModelsGrid.Grid.Cols[Ord(pmcName)];
  for var Index := PrtModels.Count - 1 downto 0 do
  begin
    PrtModel := PrtModels[Index].PrtModel;
    ModelFound := False;
    for var PackageIndex := 1 to PackageColumn.Count - 1 do
    begin
      AnObject := PackageColumn.Objects[PackageIndex];
      if AnObject <> nil then
      begin
        StoredModel := AnObject as TPrtModel;
        if StoredModel.OriginalId = PrtModel.OriginalId then
        begin
          ModelFound := True;
          PackageColumn.Objects[PackageIndex] := PrtModel;
          break;
        end;
      end;
    end;
    if not ModelFound then
    begin
      PrtModels.Delete(Index);
    end;
  end;
  for var Index := 0 to framePrtModelsGrid.seNumber.AsInteger - 1 do
  begin
    AnObject := framePrtModelsGrid.Grid.Objects[Ord(pmcName), Index + 1];
    if AnObject <> nil then
    begin
      PrtModel := AnObject as TPrtModel;
    end
    else
    begin
      ModelItem := PrtModels.Add as TPrtModelItem;
      PrtModel := ModelItem.PrtModel;
      ModelItem.Index := Index;
    end;
    PrtModel.ModelName := framePrtModelsGrid.Grid.Cells[Ord(pmcName), Index + 1];
    PrtModel.IsSelected := framePrtModelsGrid.Grid.Checked[Ord(pmcUsed), Index + 1];
    PrtFrame := framePrtModelsGrid.Grid.Objects[Ord(pmcUsed), Index + 1] as TframePrpMultiplePackages;
    Assert(PrtFrame <> nil);

    if FLinkDictionary.TryGetValue(PrtFrame, Link) then
    begin
      PrtFrame.SetData(PrtModel);
    end
    else
    begin
      Assert(False);
    end;
  end;
end;

end.
