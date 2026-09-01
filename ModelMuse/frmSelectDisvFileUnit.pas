unit frmSelectDisvFileUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, CustomExtendedDialogForm,
  Vcl.ExtCtrls;

type
  TfrmSelectDisvFile = class(TCustomExtendedDialog)
    rgImportChoice: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectDisvFile: TfrmSelectDisvFile;

implementation

{$R *.dfm}

end.
