unit ModflowPrpInterfaceUnit;

interface



uses
  System.Generics.Collections;

type
  IPrpBoundaryInterface = interface(IInterface)
    procedure RemovePrtModelLink;
    Procedure RemovePrpPackageLink;
  end;
  TPrpBoundaryInterfaceList = TList<IPrpBoundaryInterface>;

implementation

end.
