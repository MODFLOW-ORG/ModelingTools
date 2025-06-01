unit Mt3dmsChemSpeciesInterfaceUnit;

interface

type
  IChemSpeciesItem = interface(IInterface)
    function GetName: string;
    procedure SetName(Value: string);
    property Name: string read GetName write SetName;
  end;


implementation

end.
