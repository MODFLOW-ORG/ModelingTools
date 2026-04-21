unit FramePackageNodeLinkUnit;

interface

uses
  Vcl.ComCtrls, framePackageUnit, System.Generics.Collections;

type
  TFrameNodeLink = class(TObject)
  private
    FNode: TTreeNode;
    FFrame: TframePackage;
    procedure SetNode(const Value: TTreeNode);
    procedure SetFrame(const Value: TframePackage);
  public
    AlternateNode: TTreeNode;
    property Node: TTreeNode read FNode write SetNode;
    property Frame: TframePackage read FFrame write SetFrame;
  end;

  TLinkDictionary = TDictionary<TframePackage, TFrameNodeLink>;
  TLinkObjectList = TObjectList<TFrameNodeLink>;

implementation

{ TFrameNodeLink }

procedure TFrameNodeLink.SetFrame(const Value: TframePackage);
begin
  FFrame := Value;
end;

procedure TFrameNodeLink.SetNode(const Value: TTreeNode);
begin
  FNode := Value;
end;

end.
