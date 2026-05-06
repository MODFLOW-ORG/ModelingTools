unit frameScreenObjectPrpUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameScreenObjectUnit, Vcl.StdCtrls,
  ArgusDataEntry, Vcl.ExtCtrls, SsButtonEd, RbwStringTreeCombo, VirtualTrees,
  UndoItemsScreenObjects, System.Generics.Collections;

type
  TPrpPackageRecord = record
    ModelName: string;
    PackageName: string;
  end;
  PPrpPackageRecord = ^TPrpPackageRecord;
//  TPrpList = TList<TPrpPackageRecord>;

  TframeScreenObjectPrp = class(TframeScreenObject)
    pnlTop: TPanel;
    pnlCaption: TPanel;
    lblPackage: TLabel;
    rstcPrpPackage: TRbwStringTreeCombo;
    procedure rstcPrpPackageTreeGetNodeDataSize(Sender: TBaseVirtualTree; var
        NodeDataSize: Integer);
    procedure rstcPrpPackageTreeGetText(Sender: TBaseVirtualTree; Node:
        PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
        string);
    procedure rstcPrpPackageTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
        Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
//    FPrpList: TPrpList;
    procedure InitializeControls;
    Procedure GetNodeCaption(Node: PVirtualNode; CellText: string; Sender: TBaseVirtualTree);
    procedure FillListOfScreenObjects(ListOfScreenObjects: TList;
      List: TScreenObjectEditCollection);

    { Private declarations }
  public
//    Constructor Create(Owner: TComponent); Override;
//    destructor Destroy; override;
    procedure GetData(List: TScreenObjectEditCollection);
    procedure SetData(List: TScreenObjectEditCollection; SetAll: boolean;
      ClearAll: boolean);
    { Public declarations }
  end;

var
  frameScreenObjectPrp: TframeScreenObjectPrp;

implementation

uses
  frmGoPhastUnit, ModflowPackageSelectionUnit, ScreenObjectUnit, GoPhastTypes;

{$R *.dfm}

const
  KNone = 'none';

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
      and (ScreenObject.ModflowPrpBoundary <> nil) then
    begin
      ListOfScreenObjects.Add(ScreenObject);
    end;
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
  AllTheSame: Boolean;
begin
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
    end
    else
    begin
      FirstScreenObject := ListOfScreenObjects[0];
      ModelName := FirstScreenObject.ModflowPrpBoundary.PrtModelName;
      PackageName := FirstScreenObject.ModflowPrpBoundary.PrpPackageName;
      AllTheSame := True;
      for var ObjectIndex := 1 to ListOfScreenObjects.Count - 1 do
      begin
        AnotherScreenObject := ListOfScreenObjects[ObjectIndex];
        if not AnsiSameText(AnotherScreenObject.ModflowPrpBoundary.PrtModelName, ModelName)
          or not AnsiSameText(AnotherScreenObject.ModflowPrpBoundary.PrpPackageName, PackageName) then
        begin
          AllTheSame := False;
          break;
        end;
      end;

      if AllTheSame then
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
                break;
              end;
              ChildNode := rstcPrpPackage.Tree.GetNextSibling(ChildNode);
            end;
            break;
          end;
          ANode := rstcPrpPackage.Tree.GetNextSibling(ANode);
        end;
      end;
    end;
  finally
    ListOfScreenObjects.Free;
  end;
end;

procedure TframeScreenObjectPrp.GetNodeCaption(Node: PVirtualNode;
  CellText: string; Sender: TBaseVirtualTree);
var
  PrpData: PPrpPackageRecord;
begin
  PrpData := Sender.GetNodeData(Node);

  if PrpData.PackageName = '' then
  begin
    CellText := PrpData.ModelName;
  end
  else
  begin
    CellText := PrpData.PackageName;
  end;
end;

procedure TframeScreenObjectPrp.InitializeControls;
var
  PrtModels: TPrtModels;
begin
  rstcPrpPackage.Tree.Clear;
  PrtModels := frmGoPhast.PhastModel.ModflowPackages.PrtModels;

  rstcPrpPackage.Tree.RootNodeCount := PrtModels.Count + 1;
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
      PrtModel := PrtModels[ParentNode.Index-1].PrtModel;
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
        AScreenObject.ModflowPrpBoundary.PrtModelName := SelectedData.ModelName;
        AScreenObject.ModflowPrpBoundary.PrpPackageName := SelectedData.PackageName;
      end;
    end;
  end;
end;

end.
