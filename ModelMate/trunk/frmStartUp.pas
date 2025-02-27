unit frmStartUp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit,
  Buttons, GlobalBasicData, Utilities;

type
  TFormStartUp = class(TForm)
    fedProjFile: TJvFilenameEdit;
    Label1: TLabel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure fedProjFileChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FShownOnce: Boolean;
    procedure AssignFileName;
    procedure CheckOpenMainForm;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormStartUp: TFormStartUp;

implementation

{$R *.dfm}

var
  FNameLocal: string = '';
  ReadyToGo: boolean = False;

procedure GoToMainForm;
begin
  if ReadyToGo then
    begin
//      FormStartUp.Visible := False;
//      FormStartUp.Close;
      OpenMainForm := True;
    end;
end;

procedure TFormStartUp.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormStartUp.btnOKClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := ExtractFileDir(FNameLocal);
  if DirectoryExists(Dir) then
    begin
      GlobalBasicData.FileToBeOpened := FNameLocal;
      GlobalBasicData.StartNewProject := not FileExists(FNameLocal);
      ReadyToGo := True;
      // Make intro form invisible and open main form
      GoToMainForm;
    end
  else
    begin
      ShowMessage('Directory is invalid!');
      btnOK.Enabled := False;
    end;
end;

procedure TFormStartUp.fedProjFileChange(Sender: TObject);
begin
  FNameLocal := fedProjFile.FileName;
  btnOK.Enabled := True;
  btnOK.SetFocus;
end;

procedure TFormStartUp.FormCreate(Sender: TObject);
begin
  CenterForm(self);
  OpenMainForm := False;
  AssignFileName;
  CheckOpenMainForm;
end;

procedure TFormStartUp.CheckOpenMainForm;
begin
  if GlobalBasicData.FileToBeOpened <> '' then
    begin
      GoToMainForm;
    end;
end;

procedure TFormStartUp.FormShow(Sender: TObject);
begin
  if not FShownOnce then
  begin
    fedProjFile.Text := GlobalBasicData.FileToBeOpened;
    FShownOnce := True;
  end;
end;

procedure TFormStartUp.AssignFileName;
var
  Dir, TempStr: string;
begin
  TempStr := '';
  if ParamStr(1) <> '' then
    begin
      TempStr := ParamStr(1);
    end;
  if TempStr <> '' then
    begin
      if TempStr[2] <> ':' then
        begin
          // TempStr is not a full path name
          Dir := GetCurrentDir;
          TempStr := Dir + PathDelimiter + TempStr;
        end;
      FNameLocal := TempStr;
      GlobalBasicData.FileToBeOpened := FNameLocal;
//      fedProjFile.Text := FNameLocal;
      GlobalBasicData.StartNewProject := not FileExists(FNameLocal);
      ReadyToGo := True;
    end
  else
    begin
      fedProjFile.Text := '';
      btnOK.Enabled := False;
      ReadyToGo := False;
    end;
end;

end.
