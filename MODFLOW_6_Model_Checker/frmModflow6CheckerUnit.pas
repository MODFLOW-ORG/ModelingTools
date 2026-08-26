unit frmModflow6CheckerUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvBaseDlg,
  JvSelectDirectory, System.IOUtils, System.Types, Vcl.Mask, JvExMask,
  JvToolEdit, Winapi.ShellAPI, JvComponentBase, JvCreateProcess, Vcl.ComCtrls,
  Vcl.Grids, RbwDataGrid4;

type
  TfrmModflow6Checker = class(TForm)
    memoListingFilels: TMemo;
    lbl1: TLabel;
    memoFailed: TMemo;
    lbl2: TLabel;
    btn1: TButton;
    lblWarnings: TLabel;
    memoWarnings: TMemo;
    jvsdSelectDirectory: TJvSelectDirectory;
    btnSelectDirectory: TButton;
    fedListingAnalyst: TJvFilenameEdit;
    lblListingAnalyst: TLabel;
    btnOpenAll: TButton;
    jvcpRunListingAnalyst: TJvCreateProcess;
    btnOpenPercentDiscrepancy: TButton;
    stat1: TStatusBar;
    rdgPercentDiscrepancy: TRbwDataGrid4;
    lblPercentDiscrepancy: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure btnOpenAllClick(Sender: TObject);
    procedure btnOpenPercentDiscrepancyClick(Sender: TObject);
    procedure btnSelectDirectoryClick(Sender: TObject);
    procedure rdgPercentDiscrepancyButtonClick(Sender: TObject; ACol, ARow:
        LongInt);
  private
    procedure RunProgram(const FileName, Params: string);
    function EncloseQuotes(const AString: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmModflow6Checker: TfrmModflow6Checker;

implementation

{$R *.dfm}

function TfrmModflow6Checker.EncloseQuotes(const AString: string): string;
begin
  if Pos(' ', AString) > 0 then
  begin
    result := '"' + AString + '"';
  end
  else
  begin
    result := AString;
  end;
end;


procedure TfrmModflow6Checker.RunProgram(const FileName, Params: string);
begin
  jvcpRunListingAnalyst.ApplicationName := FileName;

    jvcpRunListingAnalyst.CommandLine := EncloseQuotes(FileName)
    + ' ' + EncloseQuotes(Params) ;
  jvcpRunListingAnalyst.Run;
  jvcpRunListingAnalyst.StopWaiting;
end;


procedure TfrmModflow6Checker.btn1Click(Sender: TObject);
var
  AFile: TStringList;
  FileName: string;
  Splitter: TStringList;
  Value: double;
  WarningRow: Integer;
  LargestDiscrepancy: double;
  LargestDRow: Integer;
begin
  memoFailed.Lines.Clear;
  memoWarnings.Lines.Clear;
  for var RowIndex := 1 to rdgPercentDiscrepancy.RowCount - 1 do
  begin
    for var ColIndex := 0 to rdgPercentDiscrepancy.ColCount - 1 do
    begin
      rdgPercentDiscrepancy.Cells[ColIndex,RowIndex] := '';
    end;
  end;
  memoFailed.Lines.BeginUpdate;
  memoWarnings.Lines.BeginUpdate;
  rdgPercentDiscrepancy.BeginUpdate;
  AFile := TStringList.Create;
  Splitter := TStringList.Create;
  try
    rdgPercentDiscrepancy.Cells[0,0] := 'File Name';
    rdgPercentDiscrepancy.Cells[1,0] := 'Row';
    rdgPercentDiscrepancy.Cells[2,0] := 'Percent Discrepancy';
    WarningRow := 1;
    for var FileIndex := 0 to memoListingFilels.Lines.Count - 1 do
    begin
      FileName := ExtractFileName(memoListingFilels.Lines[FileIndex]);
      stat1.SimpleText := FileName;
      Application.ProcessMessages;
      AFile.LoadFromFile(memoListingFilels.Lines[FileIndex]);
      if AFile.Count > 0 then
      begin
        if AnsiSameText(FileName, 'mfsim.lst') then
        begin
          if Pos('Normal termination of simulation.', AFile[AFile.Count-1]) <= 0 then
          begin
            memoFailed.Lines.Add(memoListingFilels.Lines[FileIndex]);
          end;
        end;

        for var LineIndex := 0 to AFile.Count - 1 do
        begin
          if AFile[LineIndex].Contains('WARNING') then
          begin
            memoWarnings.Lines.Add(memoListingFilels.Lines[FileIndex]);
            Break;
          end;
        end;

        LargestDiscrepancy := 0;
        LargestDRow := 0;
        for var LineIndex := 0 to AFile.Count - 1 do
        begin
          if AFile[LineIndex].Contains('PERCENT DISCREPANCY =') then
          begin
            Splitter.DelimitedText := Trim(AFile[LineIndex]);
            if TryStrToFloat(Splitter[7], Value) then
            begin
              if (Abs(Value) >= 0.1) and (Abs(Value) > Abs(LargestDiscrepancy)) then
              begin
                LargestDiscrepancy := Value;
                LargestDRow := LineIndex;
//                Break;
              end;
            end
            else
            begin
              Assert(False);
            end;
          end;
        end;
        if LargestDiscrepancy > 0 then
        begin
          rdgPercentDiscrepancy.RowCount := WarningRow + 1;
          rdgPercentDiscrepancy.Cells[0, WarningRow] := memoListingFilels.Lines[FileIndex];
          rdgPercentDiscrepancy.Cells[1, WarningRow] := LargestDRow.ToString;
          rdgPercentDiscrepancy.Cells[2, WarningRow] := LargestDiscrepancy.ToString;
          Inc(WarningRow);
        end;

      end
      else
      begin
        memoFailed.Lines.Add(memoListingFilels.Lines[FileIndex]);
      end;
    end;
  finally
    AFile.Free;
    Splitter.Free;
    memoFailed.Lines.EndUpdate;
    memoWarnings.Lines.EndUpdate;
    rdgPercentDiscrepancy.EndUpdate;

  end;
  ShowMessage('Done');
end;

procedure TfrmModflow6Checker.btnOpenAllClick(Sender: TObject);
var
  AFileName: string;
begin
  for var FileIndex := 0 to memoFailed.Lines.Count - 1 do
  begin
    AFileName := memoFailed.Lines[FileIndex];
    RunProgram(fedListingAnalyst.FileName, AFileName);
  end;
  for var FileIndex := 0 to memoWarnings.Lines.Count - 1 do
  begin
    AFileName := memoWarnings.Lines[FileIndex];
    RunProgram(fedListingAnalyst.FileName, AFileName);
  end;
end;

procedure TfrmModflow6Checker.btnOpenPercentDiscrepancyClick(Sender: TObject);
var
  AFileName: string;
begin
  for var FileIndex := 1 to rdgPercentDiscrepancy.RowCount - 1 do
  begin
    AFileName := rdgPercentDiscrepancy.Cells[0, FileIndex];
    RunProgram(fedListingAnalyst.FileName, AFileName);
  end;
end;

procedure TfrmModflow6Checker.btnSelectDirectoryClick(Sender: TObject);
var
  ListFiles: TStringDynArray;
begin
  if jvsdSelectDirectory.Execute then
  begin
    ListFiles := TDirectory.GetFiles(jvsdSelectDirectory.Directory, '*.lst',
      TSearchOption.soAllDirectories);
    memoListingFilels.Lines.BeginUpdate;
    try
      memoListingFilels.Lines.Clear;
      memoListingFilels.Lines.AddStrings(ListFiles);
    finally
      memoListingFilels.Lines.EndUpdate;
    end;
  end;
end;

procedure TfrmModflow6Checker.rdgPercentDiscrepancyButtonClick(Sender: TObject; ACol, ARow:
    LongInt);
var
  AFileName: string;
begin
  AFileName := rdgPercentDiscrepancy.Cells[ACol, ARow];
  RunProgram(fedListingAnalyst.FileName, AFileName);
end;

end.
