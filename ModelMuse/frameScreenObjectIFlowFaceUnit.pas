unit frameScreenObjectIFlowFaceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ArgusDataEntry, UndoItemsScreenObjects;

type
  TframeScreenObjectIFlowFace = class(TFrame)
    rdeIFlowFace: TRbwDataEntry;
    lblIFlowFace: TLabel;
    lblExplanation: TLabel;
  private
    procedure InitializeControl;
    procedure FillListOfScreenObjects(ListOfScreenObjects: TList;
      List: TScreenObjectEditCollection);
    { Private declarations }
  public
    procedure GetData(List: TScreenObjectEditCollection);
    procedure SetData(List: TScreenObjectEditCollection; SetAll: boolean;
      ClearAll: boolean);
    { Public declarations }
  end;

implementation

uses
  ScreenObjectUnit;

{$R *.dfm}

{ TframeScreenObjectIFlowFace }

procedure TframeScreenObjectIFlowFace.FillListOfScreenObjects(
  ListOfScreenObjects: TList; List: TScreenObjectEditCollection);
var
  Index: Integer;
  ScreenObject: TScreenObject;
begin
  for Index := 0 to List.Count - 1 do
  begin
    ScreenObject := List[Index].ScreenObject;
    if (ScreenObject.ModflowIFlowFaceLocation <> nil)
      and ScreenObject.ModflowIFlowFaceLocation.Used then
    begin
      ListOfScreenObjects.Add(ScreenObject);
    end;
  end;
end;

procedure TframeScreenObjectIFlowFace.GetData(
  List: TScreenObjectEditCollection);
var
  ListOfScreenObjects: TList;
  AScreenObject: TScreenObject;
  FirstValue: Integer;
begin
  InitializeControl;
  Assert(List.Count > 0);
  ListOfScreenObjects := TList.Create;
  try
    FillListOfScreenObjects(ListOfScreenObjects, List);
    if ListOfScreenObjects.Count > 0 then
    begin
      AScreenObject := ListOfScreenObjects[0];
      FirstValue := AScreenObject.ModflowIFlowFaceLocation.IFlowFace;
      rdeIFlowFace.IntegerValue := FirstValue;
      for var Index := 1 to ListOfScreenObjects.Count - 1 do
      begin
        AScreenObject := ListOfScreenObjects[Index];
        if FirstValue <> AScreenObject.ModflowIFlowFaceLocation.IFlowFace then
        begin
          rdeIFlowFace.Text := '';
          Exit;
        end;

      end;
    end;
  finally
    ListOfScreenObjects.Free;
  end;
end;

procedure TframeScreenObjectIFlowFace.InitializeControl;
begin
  rdeIFlowFace.IntegerValue := 0;

end;

procedure TframeScreenObjectIFlowFace.SetData(List: TScreenObjectEditCollection;
  SetAll, ClearAll: boolean);
var
  AScreenObject: TScreenObject;
begin
  if ClearAll then
  begin
    for var Index := 0 to List.Count - 1 do
    begin
      AScreenObject := List[Index].ScreenObject;
      AScreenObject.ModflowIFlowFaceLocation := nil;
    end;
  end
  else
  begin
    for var Index := 0 to List.Count - 1 do
    begin
      AScreenObject := List[Index].ScreenObject;
      if SetAll and (AScreenObject.ModflowIFlowFaceLocation = nil) then
      begin
        AScreenObject.CreateIFlowFaceLocation;
      end;
      if rdeIFlowFace.Text = '' then
      begin
        Continue;
      end;
      if AScreenObject.ModflowIFlowFaceLocation <> nil then
      begin
        AScreenObject.ModflowIFlowFaceLocation.IsUsed := True;
        AScreenObject.ModflowIFlowFaceLocation.IFlowFace := rdeIFlowFace.IntegerValue;
      end;
    end;
  end;

end;

end.
