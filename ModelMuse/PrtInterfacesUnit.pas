unit PrtInterfacesUnit;

interface

type
  IPrpPackage   = interface(IInterface)
    ['{156C1F0B-C804-46E3-BFA9-24EBCF0AB4D5}']
    function GetPackageName: string;
    property PackageName: string read GetPackageName;
  end;

  IPrtModel  = interface(IInterface)
    ['{E015104F-B85F-4E4B-A574-102B680DB7A7}']
    function GetModelName: string;
    property ModelName: string read GetModelName;
  end;

implementation

end.
