unit frameScreenObjectPrpUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameScreenObjectUnit, Vcl.StdCtrls,
  ArgusDataEntry, Vcl.ExtCtrls, SsButtonEd, RbwStringTreeCombo, VirtualTrees,
  UndoItemsScreenObjects, System.Generics.Collections, frameModpathParticlesUnit,
  Vcl.Mask, JvExMask, JvSpin, JvExStdCtrls, JvGroupBox, Vcl.Grids,
  RbwDataGrid4, VirtualTrees.BaseTree;

type
  TPrpPackageRecord = record
    ModelName: string;
    PackageName: string;
  end;
  PPrpPackageRecord = ^TPrpPackageRecord;

  TframeScreenObjectPrp = class(TframeScreenObject)
    pnlTop: TPanel;
    pnlCaption: TPanel;
    lblPackage: TLabel;
    rstcPrpPackage: TRbwStringTreeCombo;
    frameModpathParticles: TframeModpathParticles;
    procedure frameModpathParticlescbLeftFaceClick(Sender: TObject);
    procedure frameModpathParticlesgbParticlesCheckBoxClick(Sender: TObject);
    procedure frameModpathParticlesrdgSpecificSetEditText(Sender: TObject; ACol,
        ARow: LongInt; const Value: string);
    procedure frameModpathParticlesrgChoiceClick(Sender: TObject);
    procedure frameModpathParticlesrgCylinderOrientationClick(Sender: TObject);
    procedure frameModpathParticlesseCylRadiusChange(Sender: TObject);
    procedure frameModpathParticlesseSpecificParticleCountChange(Sender: TObject);
    procedure frameModpathParticlesseXChange(Sender: TObject);
    procedure rstcPrpPackageChange(Sender: TObject);
    procedure rstcPrpPackageTreeGetNodeDataSize(Sender: TBaseVirtualTree; var
        NodeDataSize: Integer);
    procedure rstcPrpPackageTreeGetText(Sender: TBaseVirtualTree; Node:
        PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
        string);
    procedure rstcPrpPackageTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
        Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
    FOnEdited: TNotifyEvent;
    FGettingData: Boolean;
    procedure InitializeControls;
    Procedure GetNodeCaption(Node: PVirtualNode; var CellText: string; Sender: TBaseVirtualTree);
    procedure FillListOfScreenObjects(ListOfScreenObjects: TList;
      List: TScreenObjectEditCollection);
    procedure GetModpathParticles(ListOfScreenObjects: TList);
    procedure StoreParticles(List: TScreenObjectEditCollection; SetAll: Boolean;
      ClearAll: Boolean);
    procedure DoPrpChanged;
    { Private declarations }
  public
    procedure GetData(List: TScreenObjectEditCollection);
    procedure SetData(List: TScreenObjectEditCollection; SetAll: boolean;
      ClearAll: boolean);
    property OnEdited: TNotifyEvent read FOnEdited write FOnEdited;
    { Public declarations }
  end;

var
  frameScreenObjectPrp: TframeScreenObjectPrp;

implementation

uses
  frmGoPhastUnit, ModflowPackageSelectionUnit, ScreenObjectUnit, GoPhastTypes,
  ModpathParticleUnit, IntListUnit;

{$R *.dfm}

const
  KNone = 'none';

procedure TframeScreenObjectPrp.DoPrpChanged;
begin
  if Assigned(OnEdited) and not FGettingData then
  begin
    OnEdited(self);
  end;
end;

procedure TframeScreenObjectPrp.FillListOfScreenObjects(
  ListOfScreenObjects: TList; List: TScreenObjectEditCollection);
var
  Index: Integer;
  ScreenObject: TScreenObject;
begin
  for Index := 0 to List.Count - 1 do
  begin
    ScreenObject := List[Index].ScreenObject;
    if (ScreenObject.ElevationCount in [ecOne, ecTwo])
      and (ScreenObject.ModflowPrpBoundary <> nil)
      and ScreenObject.ModflowPrpBoundary.Used then
    begin
      ListOfScreenObjects.Add(ScreenObject);
    end;
  end;
end;

procedure TframeScreenObjectPrp.frameModpathParticlescbLeftFaceClick(Sender:
    TObject);
begin
  inherited;
//  if IsLoaded then
  begin
    (Sender as TCheckBox).AllowGrayed := False;
    frameModpathParticles.CreateParticles;
    DoPrpChanged;
//    StoreModPath;
  end;
end;

procedure TframeScreenObjectPrp.frameModpathParticlesgbParticlesCheckBoxClick(
    Sender: TObject);
var
  Check: TCheckBox;
  Index: Integer;
  GB: TJvGroupBox;
begin
  inherited;
  frameModpathParticles.gbParticlesCheckBoxClick(Sender);
  GB := frameModpathParticles.gbParticles;
  GB.Handle;
  Check := GB.Components[0] as TCheckBox;
  for Index := 0 to GB.ControlCount - 1 do
  begin
    if GB.Controls[Index] <> Check then
    begin
      GB.Controls[Index].Enabled := Check.State <> cbUnChecked;
    end;
  end;
//  if IsLoaded then
//  begin
    Check.AllowGrayed := False;
    frameModpathParticles.CreateParticles;
    DoPrpChanged;
//    StoreParticles;
//  end;
end;

procedure TframeScreenObjectPrp.frameModpathParticlesrdgSpecificSetEditText(
    Sender: TObject; ACol, ARow: LongInt; const Value: string);
begin
  inherited;
//  if IsLoaded then
  begin
    frameModpathParticles.CreateParticles;
    DoPrpChanged;
  end;
end;

procedure TframeScreenObjectPrp.frameModpathParticlesrgChoiceClick(Sender:
    TObject);
begin
  inherited;
  if frameModpathParticles.rgChoice.ItemIndex >= 0 then
  begin
    frameModpathParticles.plParticlePlacement.ActivePageIndex :=
      frameModpathParticles.rgChoice.ItemIndex;
//    if IsLoaded then
    begin
      frameModpathParticles.CreateParticles;
    end;
  end
  else
  begin
    frameModpathParticles.plParticlePlacement.ActivePage
      := frameModpathParticles.jvspBlank;
  end;
  DoPrpChanged;
end;

procedure
    TframeScreenObjectPrp.frameModpathParticlesrgCylinderOrientationClick(
    Sender: TObject);
begin
  inherited;
//  if isLoaded then
  begin
    frameModpathParticles.CreateParticles;
    DoPrpChanged;
  end;
end;

procedure TframeScreenObjectPrp.frameModpathParticlesseCylRadiusChange(Sender:
    TObject);
begin
  inherited;
//  if IsLoaded then
  begin
    frameModpathParticles.CreateParticles;
    DoPrpChanged;
  end;
end;

procedure
    TframeScreenObjectPrp.frameModpathParticlesseSpecificParticleCountChange(
    Sender: TObject);
begin
  inherited;
  frameModpathParticles.UpdateRowCount;
  frameModpathParticles.seSpecificParticleCount.MinValue := 0;
  frameModpathParticles.CreateParticles;
  DoPrpChanged;
end;

procedure TframeScreenObjectPrp.frameModpathParticlesseXChange(Sender: TObject);
begin
  inherited;
//  if IsLoaded then
  begin
    if Sender = frameModpathParticles.seSphereLayerCount then
    begin
      frameModpathParticles.seSphereLayerCount.MinValue := 2;
    end
    else
    begin
      (Sender as TJvSpinEdit).MinValue := 1;
    end;
    frameModpathParticles.CreateParticles;
    DoPrpChanged;
  end;
end;

procedure TframeScreenObjectPrp.GetData(List: TScreenObjectEditCollection);
var
  ListOfScreenObjects: TList;
  FirstScreenObject: TScreenObject;
  ANode: PVirtualNode;
  ModelName: string;
  NodeData: PPrpPackageRecord;
  PackageName: string;
  ChildNode: PVirtualNode;
  SelectedNode: PVirtualNode;
  AnotherScreenObject: TScreenObject;
  AllTheSamePrpPackage: Boolean;
  ScreenObject: TScreenObject;
begin
  FGettingData := True;
  try
    InitializeControls;
    Assert(List.Count > 0);
    ListOfScreenObjects := TList.Create;
    try
      ANode := rstcPrpPackage.Tree.GetFirst;
      Assert(ANode <> nil);
      FillListOfScreenObjects(ListOfScreenObjects, List);
      if ListOfScreenObjects.Count = 0 then
      begin
        rstcPrpPackage.Tree.Selected[ANode] := True;
        NodeData := rstcPrpPackage.Tree.GetNodeData(ANode);
        rstcPrpPackage.Text := NodeData.ModelName;
      end
      else
      begin
        FirstScreenObject := ListOfScreenObjects[0];
        ModelName := FirstScreenObject.ModflowPrpBoundary.PrtModelName;
        PackageName := FirstScreenObject.ModflowPrpBoundary.PrpPackageName;
        AllTheSamePrpPackage := True;
        for var ObjectIndex := 1 to ListOfScreenObjects.Count - 1 do
        begin
          AnotherScreenObject := ListOfScreenObjects[ObjectIndex];
          if not AnsiSameText(AnotherScreenObject.ModflowPrpBoundary.PrtModelName, ModelName)
            or not AnsiSameText(AnotherScreenObject.ModflowPrpBoundary.PrpPackageName, PackageName) then
          begin
            AllTheSamePrpPackage := False;
            break;
          end;
        end;

        if AllTheSamePrpPackage then
        begin
          ANode := rstcPrpPackage.Tree.GetNextSibling(ANode);
          While ANode <> nil do
          begin
            NodeData := rstcPrpPackage.Tree.GetNodeData(ANode);
            if AnsiSameText(NodeData.ModelName, ModelName) then
            begin
              ChildNode := rstcPrpPackage.Tree.GetFirstChild(ANode);
              while ChildNode <> nil do
              begin
                NodeData := rstcPrpPackage.Tree.GetNodeData(ChildNode);
                if AnsiSameText(NodeData.PackageName, PackageName) then
                begin
                  SelectedNode := ChildNode;
                  rstcPrpPackage.Tree.Selected[SelectedNode] := True;
                  rstcPrpPackage.Text := NodeData.ModelName + '.' + NodeData.PackageName;
                  break;
                end;
                ChildNode := rstcPrpPackage.Tree.GetNextSibling(ChildNode);
              end;
              break;
            end;
            ANode := rstcPrpPackage.Tree.GetNextSibling(ANode);
          end;
        end;

        ListOfScreenObjects.Clear;
        ListOfScreenObjects.Capacity := List.Count;
        for var Index := 0 to List.Count - 1 do
        begin
          ScreenObject := List[Index].ScreenObject;
          ListOfScreenObjects.Add(ScreenObject);
        end;

        GetModpathParticles(ListOfScreenObjects);
      end;
    finally
      ListOfScreenObjects.Free;
    end;
  finally
    FGettingData := False;
  end;
end;

procedure TframeScreenObjectPrp.GetModpathParticles(ListOfScreenObjects: TList);
var
  Frame: TframeModpathParticles;
  Particles: TParticleStorage;
  GridParticles: TGridDistribution;
  CylParticles: TCylSphereDistribution;
  SphereParticles: TCylSphereDistribution;
  CustomParticles: TParticles;
  Index: Integer;
  Item: TParticleLocation;
  ScreenObject : TScreenObject;
  ScreenObjectIndex: Integer;
  UsedDistribution: Set of TParticleDistribution;
  CheckBox: TCheckBox;
  RowIndex: Integer;
  TimeItem: TModpathTimeItem;
  procedure UpdateRadioGroup(RadioGroup: TRadioGroup; Value: integer);
  begin
    if RadioGroup.ItemIndex <> Value then
    begin
      RadioGroup.ItemIndex := -1;
    end;
  end;
  procedure UpdateCheckBox(CheckBox: TCheckBox; Checked: boolean);
  begin
    if CheckBox.Checked <> Checked then
    begin
      CheckBox.AllowGrayed := True;
      CheckBox.State := cbGrayed;
    end;
  end;
  procedure UpdateIntegerSpinEdit(SpinEdit: TJvSpinEdit; Value: integer);
  begin
    if SpinEdit.AsInteger <> Value then
    begin
      SpinEdit.MinValue := 0;
      SpinEdit.AsInteger := 0;
    end;
  end;
  procedure UpdateFloatSpinEdit(SpinEdit: TJvSpinEdit; Value: double);
  begin
    if SpinEdit.Value <> Value then
    begin
      SpinEdit.MinValue := 0;
      SpinEdit.Value := 0;
    end;
  end;
  procedure AssignGridParticles;
  begin
    GridParticles := Particles.GridParticles;
    Frame.cbLeftFace.Checked := GridParticles.LeftFace;
    Frame.cbRightFace.Checked := GridParticles.RightFace;
    Frame.cbBackFace.Checked := GridParticles.BackFace;
    Frame.cbFrontFace.Checked := GridParticles.FrontFace;
    Frame.cbBottomFace.Checked := GridParticles.BottomFace;
    Frame.cbTopFace.Checked := GridParticles.TopFace;
    Frame.cbInternal.Checked := GridParticles.Internal;
    Frame.seX.AsInteger := GridParticles.XCount;
    Frame.seY.AsInteger := GridParticles.YCount;
    Frame.seZ.AsInteger := GridParticles.ZCount;
  end;
  procedure AssignCylinderParticles;
  begin
    CylParticles := Particles.CylinderParticles;
    Frame.rgCylinderOrientation.ItemIndex := Ord(CylParticles.Orientation);
    Frame.seCylParticleCount.AsInteger := CylParticles.CircleParticleCount;
    Frame.seCylLayerCount.AsInteger := CylParticles.LayerCount;
    Frame.seCylRadius.Value := CylParticles.Radius;
  end;
  procedure AssignSphereParticles;
  begin
    SphereParticles := Particles.SphereParticles;
    Frame.rgSphereOrientation.ItemIndex := Ord(SphereParticles.Orientation);
    Frame.seSphereParticleCount.AsInteger := SphereParticles.CircleParticleCount;
    Frame.seSphereLayerCount.AsInteger := SphereParticles.LayerCount;
    Frame.seSphereRadius.Value := SphereParticles.Radius;
  end;
  procedure AssignCustomParticles;
  var
    Index: integer;
    Item: TParticleLocation;
  begin
    CustomParticles := Particles.CustomParticles;
    Frame.seSpecificParticleCount.AsInteger := CustomParticles.Count;
    frameModpathParticlesseSpecificParticleCountChange(nil);
    for Index := 0 to CustomParticles.Count - 1 do
    begin
      Item := CustomParticles.Items[Index] as TParticleLocation;
      Frame.rdgSpecific.Cells[1, Index + 1] := FloatToStr(Item.X);
      Frame.rdgSpecific.Cells[2, Index + 1] := FloatToStr(Item.Y);
      Frame.rdgSpecific.Cells[3, Index + 1] := FloatToStr(Item.Z);
    end;
  end;
begin
  Frame := frameModpathParticles;
  Frame.TrackingDirection := frmGoPhast.PhastModel.
    ModflowPackages.ModPath.TrackingDirection;
  Frame.MPathVersion := frmGoPhast.PhastModel.
    ModflowPackages.ModPath.MPathVersion;
  UsedDistribution := [];
  for ScreenObjectIndex := 0 to ListOfScreenObjects.Count - 1 do
  begin
    ScreenObject := ListOfScreenObjects[ScreenObjectIndex];
    Particles := ScreenObject.ModflowPrpBoundary.ParticleStorage;

    if not Particles.Used then
    begin
      if ScreenObjectIndex = 0 then
      begin
        Frame.gbParticles.Checked := False;
      end
      else
      begin
        CheckBox := Frame.gbParticles.Components[0] as TCheckBox;
        if CheckBox.State = cbChecked then
        begin
          CheckBox.AllowGrayed := True;
          CheckBox.State := cbGrayed;
        end;
      end;
    end
    else
    begin
      if ScreenObjectIndex = 0 then
      begin
        Frame.gbParticles.Checked := True;
      end
      else
      begin
        CheckBox := Frame.gbParticles.Components[0] as TCheckBox;
        if CheckBox.State = cbUnChecked then
        begin
          CheckBox.AllowGrayed := True;
          CheckBox.State := cbGrayed;
        end;
      end;

      if UsedDistribution = [] then
      begin
        Frame.rgChoice.ItemIndex := Ord(Particles.ParticleDistribution);
      end
      else
      begin
        UpdateRadioGroup(Frame.rgChoice, Ord(Particles.ParticleDistribution));
      end;
      if not (Particles.ParticleDistribution in UsedDistribution) then
      begin
        Include(UsedDistribution, Particles.ParticleDistribution);
        case Particles.ParticleDistribution of
          pdGrid: AssignGridParticles;
          pdCylinder: AssignCylinderParticles;
          pdSphere: AssignSphereParticles;
          pdIndividual: AssignCustomParticles;
          pdObjectLocation: ; // do nothing
          else Assert(False);
        end;
        Frame.seTimeCount.AsInteger := Particles.ReleaseTimes.Count;
        Frame.UpdateTimeRowCount;
        for RowIndex := 0 to Particles.ReleaseTimes.Count - 1 do
        begin
          TimeItem := Particles.ReleaseTimes.Items[RowIndex] as TModpathTimeItem;
          Frame.rdgReleaseTimes.Cells[1,RowIndex+1] := FloatToStr(TimeItem.Time);
        end;
      end
      else
      begin
        case Particles.ParticleDistribution of
          pdGrid:
            begin
              GridParticles := Particles.GridParticles;
              UpdateCheckBox(Frame.cbLeftFace, GridParticles.LeftFace);
              UpdateCheckBox(Frame.cbRightFace, GridParticles.RightFace);
              UpdateCheckBox(Frame.cbBackFace, GridParticles.BackFace);
              UpdateCheckBox(Frame.cbFrontFace, GridParticles.FrontFace);
              UpdateCheckBox(Frame.cbBottomFace, GridParticles.BottomFace);
              UpdateCheckBox(Frame.cbTopFace, GridParticles.TopFace);
              UpdateCheckBox(Frame.cbInternal, GridParticles.Internal);
              UpdateIntegerSpinEdit(Frame.seX, GridParticles.XCount);
              UpdateIntegerSpinEdit(Frame.seY, GridParticles.YCount);
              UpdateIntegerSpinEdit(Frame.seZ, GridParticles.ZCount);
            end;
          pdCylinder:
            begin
              CylParticles := Particles.CylinderParticles;
              UpdateRadioGroup(Frame.rgCylinderOrientation, Ord(CylParticles.Orientation));
              UpdateIntegerSpinEdit(Frame.seCylParticleCount, CylParticles.CircleParticleCount);
              UpdateIntegerSpinEdit(Frame.seCylLayerCount, CylParticles.LayerCount);
              UpdateFloatSpinEdit(Frame.seCylRadius, CylParticles.Radius);
            end;
          pdSphere:
            begin
              SphereParticles := Particles.SphereParticles;
              UpdateRadioGroup(Frame.rgSphereOrientation, Ord(SphereParticles.Orientation));
              UpdateIntegerSpinEdit(Frame.seSphereParticleCount, SphereParticles.CircleParticleCount);
              UpdateIntegerSpinEdit(Frame.seSphereLayerCount, SphereParticles.LayerCount);
              UpdateFloatSpinEdit(Frame.seSphereRadius, SphereParticles.Radius);
            end;
          pdIndividual:
            begin
              CustomParticles := Particles.CustomParticles;
              if Frame.seSpecificParticleCount.AsInteger <> CustomParticles.Count then
              begin
                Frame.seSpecificParticleCount.MinValue := -1;
                Frame.seSpecificParticleCount.AsInteger := -1;
                frameModpathParticlesseSpecificParticleCountChange(nil);
              end
              else
              begin
                for Index := 0 to CustomParticles.Count - 1 do
                begin
                  Item := CustomParticles.Items[Index] as TParticleLocation;
                  if Frame.rdgSpecific.Cells[1, Index + 1] <> FloatToStr(Item.X) then
                  begin
                    Frame.rdgSpecific.Cells[1, Index + 1] := '';
                  end;
                  if Frame.rdgSpecific.Cells[2, Index + 1] <> FloatToStr(Item.Y) then
                  begin
                    Frame.rdgSpecific.Cells[2, Index + 1] := '';
                  end;
                  if Frame.rdgSpecific.Cells[3, Index + 1] <> FloatToStr(Item.Z) then
                  begin
                    Frame.rdgSpecific.Cells[4, Index + 1] := '';
                  end;
                end;
              end;
            end;
          pdObjectLocation:
            begin
            end;
          else Assert(False);
        end;
        UpdateIntegerSpinEdit(Frame.seTimeCount,
          Particles.ReleaseTimes.Count);
        Frame.UpdateTimeRowCount;
        if Frame.seTimeCount.AsInteger >= 1 then
        begin
          for RowIndex := 0 to Particles.ReleaseTimes.Count - 1 do
          begin
            TimeItem := Particles.ReleaseTimes.Items[RowIndex] as TModpathTimeItem;
            if Frame.rdgReleaseTimes.Cells[1,RowIndex+1] <>
              FloatToStr(TimeItem.Time) then
            begin
              Frame.rdgReleaseTimes.Cells[1,RowIndex+1] := '';
            end;
          end;
        end;

      end;
    end;
  end;
  frameModpathParticlesgbParticlesCheckBoxClick(nil);
  frameModpathParticles.CreateParticles;
end;

procedure TframeScreenObjectPrp.GetNodeCaption(Node: PVirtualNode;
  var CellText: string; Sender: TBaseVirtualTree);
var
  PrpData: PPrpPackageRecord;
begin
  PrpData := Sender.GetNodeData(Node);

  if rstcPrpPackage.SelectingText then
  begin
    if PrpData.PackageName = '' then
    begin
      CellText := PrpData.ModelName;
    end
    else
    begin
      CellText := PrpData.ModelName + '.' + PrpData.PackageName;
    end;
  end
  else
  begin
    if PrpData.PackageName = '' then
    begin
      CellText := PrpData.ModelName;
    end
    else
    begin
      CellText := PrpData.PackageName;
    end;

  end;
end;

procedure TframeScreenObjectPrp.InitializeControls;
var
  PrtModels: TPrtModels;
begin
  rstcPrpPackage.Tree.Clear;
  PrtModels := frmGoPhast.PhastModel.ModflowPackages.PrtModels;

  rstcPrpPackage.Tree.RootNodeCount := PrtModels.Count + 1;

  frameModpathParticles.InitializeFrame;
  frameModpathParticles.gbParticles.Checked := False;
end;

procedure TframeScreenObjectPrp.rstcPrpPackageChange(Sender: TObject);
begin
  inherited;
  DoPrpChanged;
end;

procedure TframeScreenObjectPrp.rstcPrpPackageTreeGetNodeDataSize(Sender:
    TBaseVirtualTree; var NodeDataSize: Integer);
begin
  inherited;
  NodeDataSize := SizeOf(TPrpPackageRecord);
end;

procedure TframeScreenObjectPrp.rstcPrpPackageTreeGetText(Sender:
    TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType:
    TVSTTextType; var CellText: string);
begin
  inherited;
  GetNodeCaption(Node, CellText, Sender);
end;

procedure TframeScreenObjectPrp.rstcPrpPackageTreeInitNode(Sender:
    TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates:
    TVirtualNodeInitStates);
var
  Data: PPrpPackageRecord;
  ParentData: PPrpPackageRecord;
  PrtModels: TPrtModels;
  PrtModel: TPrtModel;
  Level: Integer;
begin
  inherited;
  PrtModels := frmGoPhast.PhastModel.ModflowPackages.PrtModels;
  Data := Sender.GetNodeData(Node);
  ParentData := Sender.GetNodeData(ParentNode);
  if Assigned(ParentData) then
    Level := 1
  else
    Level := 0;
  if Level = 0 then
  begin
    if Node.Index = 0 then
    begin
      Data.ModelName := KNone;
      Data.PackageName := '';
    end
    else
    begin
      PrtModel := PrtModels[Node.Index-1].PrtModel;
      Data.ModelName := PrtModel.ModelName;
      Data.PackageName := '';
      Sender.ChildCount[Node] := PrtModel.Count;
    end;
  end
  else
  begin
    PrtModel := PrtModels[ParentNode.Index-1].PrtModel;
    Data.ModelName := PrtModel.ModelName;
    Data.PackageName := PrtModel[Node.Index].PrpPackage.PackageName;
  end;
end;

procedure TframeScreenObjectPrp.SetData(List: TScreenObjectEditCollection;
  SetAll, ClearAll: boolean);
var
  SelectedNode: PVirtualNode;
  SelectedData: PPrpPackageRecord;
  AScreenObject: TScreenObject;
begin
  SelectedNode := rstcPrpPackage.Tree.GetFirstSelected(True);
  if SelectedNode = nil then
  begin
    Exit;
  end;
  SelectedData := rstcPrpPackage.Tree.GetNodeData(SelectedNode);
  if (SelectedData.ModelName = KNone) or ClearAll then
  begin
    for var Index := 0 to List.Count - 1 do
    begin
      AScreenObject := List[Index].ScreenObject;
      AScreenObject.ModflowPrpBoundary := nil;
    end;
  end
  else
  begin
    for var Index := 0 to List.Count - 1 do
    begin
      AScreenObject := List[Index].ScreenObject;
      if SetAll and (AScreenObject.ModflowPrpBoundary = nil) then
      begin
        AScreenObject.CreatePrpBoundary;
      end;
      if AScreenObject.ModflowPrpBoundary <> nil then
      begin
        AScreenObject.ModflowPrpBoundary.IsUsed := True;
        AScreenObject.ModflowPrpBoundary.PrtModelName := SelectedData.ModelName;
        AScreenObject.ModflowPrpBoundary.PrpPackageName := SelectedData.PackageName;
      end;
    end;
  end;

  StoreParticles(List, SetAll, ClearAll);
end;

procedure TframeScreenObjectPrp.StoreParticles(List: TScreenObjectEditCollection;
  SetAll, ClearAll: Boolean);
var
  Index: Integer;
  ScreenObject: TScreenObject;
  Particles: TParticleStorage;
  GridParticles: TGridDistribution;
  CylinderParticles: TCylSphereDistribution;
  SphereParticles: TCylSphereDistribution;
  CustomParticles: TParticles;
  RowIndex: Integer;
  Grid: TRbwDataGrid4;
  X: double;
  Y: double;
  Z: double;
  ParticleItem: TParticleLocation;
  TimeItem: TModpathTimeItem;
  DeleteRowList: TIntegerList;
  Time: double;
  RowAdded: Boolean;
  CheckBox: TCheckBox;
  ParticleCount: Integer;
begin
  for Index := 0 to List.Count - 1 do
  begin
    ScreenObject := List[Index].ScreenObject;
    Particles := ScreenObject.ModflowPrpBoundary.ParticleStorage;
    CheckBox := frameModpathParticles.gbParticles.Components[0] as TCheckBox;
    case CheckBox.State of
      cbUnchecked: Particles.Used := False;
      cbChecked: Particles.Used := True;
      cbGrayed: ; // do nothing
      else Assert(False);
    end;
    if Particles.Used then
    begin
      if frameModpathParticles.rgChoice.ItemIndex >= 0 then
      begin
        Particles.ParticleDistribution :=
          TParticleDistribution(frameModpathParticles.rgChoice.ItemIndex);
      end;
      case Particles.ParticleDistribution of
        pdGrid:
          begin
            GridParticles := Particles.GridParticles;
            if frameModpathParticles.cbLeftFace.State <> cbGrayed then
            begin
              GridParticles.LeftFace :=
                frameModpathParticles.cbLeftFace.Checked;
            end;
            if frameModpathParticles.cbRightFace.State <> cbGrayed then
            begin
              GridParticles.RightFace :=
                frameModpathParticles.cbRightFace.Checked;
            end;
            if frameModpathParticles.cbBackFace.State <> cbGrayed then
            begin
              GridParticles.BackFace :=
                frameModpathParticles.cbBackFace.Checked;
            end;
            if frameModpathParticles.cbFrontFace.State <> cbGrayed then
            begin
              GridParticles.FrontFace :=
                frameModpathParticles.cbFrontFace.Checked;
            end;
            if frameModpathParticles.cbBottomFace.State <> cbGrayed then
            begin
              GridParticles.BottomFace :=
                frameModpathParticles.cbBottomFace.Checked;
            end;
            if frameModpathParticles.cbTopFace.State <> cbGrayed then
            begin
              GridParticles.TopFace :=
                frameModpathParticles.cbTopFace.Checked;
            end;
            if frameModpathParticles.cbInternal.State <> cbGrayed then
            begin
              GridParticles.Internal :=
                frameModpathParticles.cbInternal.Checked;
            end;
            if frameModpathParticles.seX.AsInteger > 0 then
            begin
              GridParticles.XCount := frameModpathParticles.seX.AsInteger;
            end;
            if frameModpathParticles.seY.AsInteger > 0 then
            begin
              GridParticles.YCount := frameModpathParticles.seY.AsInteger;
            end;
            if frameModpathParticles.seZ.AsInteger > 0 then
            begin
              GridParticles.ZCount := frameModpathParticles.seZ.AsInteger;
            end;
          end;
        pdCylinder:
          begin
            CylinderParticles := Particles.CylinderParticles;
            if frameModpathParticles.rgCylinderOrientation.ItemIndex >= 0 then
            begin
              CylinderParticles.Orientation :=
                TParticleGroupOrientation(frameModpathParticles.
                rgCylinderOrientation.ItemIndex);
            end;
            if frameModpathParticles.seCylParticleCount.AsInteger > 0 then
            begin
              CylinderParticles.CircleParticleCount :=
                frameModpathParticles.seCylParticleCount.AsInteger;
            end;
            if frameModpathParticles.seCylLayerCount.AsInteger > 0 then
            begin
              CylinderParticles.LayerCount :=
                frameModpathParticles.seCylLayerCount.AsInteger;
            end;
            if frameModpathParticles.seCylRadius.Value > 0 then
            begin
              CylinderParticles.Radius :=
                frameModpathParticles.seCylRadius.Value;
            end;
          end;
        pdSphere:
          begin
            SphereParticles := Particles.SphereParticles;
            if frameModpathParticles.rgSphereOrientation.ItemIndex >= 0 then
            begin
              SphereParticles.Orientation :=
                TParticleGroupOrientation(frameModpathParticles.
                rgSphereOrientation.ItemIndex);
            end;
            if frameModpathParticles.seSphereParticleCount.AsInteger > 0 then
            begin
              SphereParticles.CircleParticleCount :=
                frameModpathParticles.seSphereParticleCount.AsInteger;
            end;
            if frameModpathParticles.seSphereLayerCount.AsInteger > 0 then
            begin
              SphereParticles.LayerCount :=
                frameModpathParticles.seSphereLayerCount.AsInteger;
            end;
            if frameModpathParticles.seSphereRadius.Value > 0 then
            begin
              SphereParticles.Radius :=
                frameModpathParticles.seSphereRadius.Value;
            end;
          end;
        pdIndividual:
          begin
            if frameModpathParticles.seSpecificParticleCount.AsInteger > 0 then
            begin
              CustomParticles := Particles.CustomParticles;
              Grid := frameModpathParticles.rdgSpecific;
              DeleteRowList := TIntegerList.Create;
              try
                for RowIndex := 1 to Grid.RowCount -1 do
                begin
                  RowAdded := False;
                  while RowIndex-1 >= CustomParticles.Count do
                  begin
                    CustomParticles.Add;
                    RowAdded := True;
                  end;

                  if TryStrToFloat(Grid.Cells[1,RowIndex], X)
                    and TryStrToFloat(Grid.Cells[2,RowIndex], Y)
                    and TryStrToFloat(Grid.Cells[3,RowIndex], Z) then
                  begin
                    ParticleItem := CustomParticles.Items[RowIndex-1] as TParticleLocation;
                    ParticleItem.X := X;
                    ParticleItem.Y := Y;
                    ParticleItem.Z := Z;
                  end
                  else if RowAdded then
                  begin
                    DeleteRowList.Add(RowIndex);
                  end;
                end;
                for RowIndex := DeleteRowList.Count - 1 downto 0 do
                begin
                  CustomParticles.Delete(DeleteRowList[RowIndex]-1);
                end;
              finally
                DeleteRowList.Free;
              end;
            end;
          end;
        pdObjectLocation:
          begin

          end
        else Assert(False);
      end;
      if frameModpathParticles.seTimeCount.AsInteger >= 1 then
      begin
        ParticleCount := 0;
        for RowIndex := 0 to frameModpathParticles.seTimeCount.AsInteger - 1 do
        begin
          if tryStrToFloat(frameModpathParticles.rdgReleaseTimes.Cells[1,RowIndex+1], Time) then
          begin
            while ParticleCount >= Particles.ReleaseTimes.Count do
            begin
              Particles.ReleaseTimes.Add;
            end;
            TimeItem := Particles.ReleaseTimes.Items[ParticleCount] as TModpathTimeItem;
            TimeItem.Time := Time;
            Inc(ParticleCount);
          end
        end;
        while Particles.ReleaseTimes.Count > ParticleCount do
        begin
          Particles.ReleaseTimes.Delete(Particles.ReleaseTimes.Count-1);
        end;
      end
      else
      begin
        Particles.ReleaseTimes.Clear;
      end;
    end;
  end;
end;

end.
