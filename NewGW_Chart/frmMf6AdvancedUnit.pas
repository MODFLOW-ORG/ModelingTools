unit frmMf6AdvancedUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MyFormUnit, SetWindowStateUnit,
  VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls, JvExExtCtrls,
  JvNetscapeSplitter, Vcl.Menus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  ReadModflowArrayUnit, System.Generics.Collections, Series,
  JvExCheckLst, JvCheckListBox, VCLTee.TeeEdit;

type
  TMf6AdvancedData = class(TObject)
    Step: Integer;
    Period: Integer;
    PeriodTime: TModflowDouble;
    Totaltime: TModflowDouble;
    Text: string;
    Data: TMf6DoubleArray;
  end;

  TMf6AdvancedDataList = TObjectList<TMf6AdvancedData>;

  TfrmMf6Advanced = class(TMyForm)
    chartMf6Advanced: TChart;
    mmMainMenu: TMainMenu;
    File1: TMenuItem;
    Opendatafile1: TMenuItem;
    Save1: TMenuItem;
    Saveasimage1: TMenuItem;
    Print1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    About1: TMenuItem;
    pnl1: TPanel;
    splttrMain: TJvNetscapeSplitter;
    pnl2: TPanel;
    dlgOpen: TOpenDialog;
    btnOpenFile: TButton;
    chklstItems: TJvCheckListBox;
    ChartEditor1: TChartEditor;
    FormatChart1: TMenuItem;
    dlgSave1: TSaveDialog;
    btnExport: TButton;
    procedure btnOpenFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chklstItemsClickCheck(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormatChart1Click(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    FDataList: TMf6AdvancedDataList;
    FSeriesList: TObjectList<TLineSeries>;
    { Private declarations }
  public
    procedure PlotResults;
    { Public declarations }
  end;

var
  frmMf6Advanced: TfrmMf6Advanced;

implementation

uses
  frmModChartUnit;

{$R *.dfm}

procedure TfrmMf6Advanced.btnExportClick(Sender: TObject);
var
  Lines: TStringList;
  LineBuilder: TStringBuilder;
  Item: TMf6AdvancedData;
  Index: Integer;
  StepIndex: Integer;
  DataIndex: Integer;
begin
  inherited;
  if FDataList.Count = 0 then
  begin
    Beep;
    MessageDlg('There is no data to export', mtWarning, [mbOK], 0);
    Exit;
  end;
  if dlgSave1.Execute then
  begin
    Lines := TStringList.Create();
    LineBuilder := TStringBuilder.Create;
    try
      Lines.BeginUpdate;
      try
        LineBuilder.Append('Step, Period, PeriodTime, TotalTime');
        Item := FDataList[0];
        for Index := 1 to Length(Item.Data) do
        begin
          LineBuilder.Append(', ');
          LineBuilder.Append(Index);
        end;
        Lines.Add(LineBuilder.ToString);

        for StepIndex := 0 to FDataList.Count - 1 do
        begin
          Item := FDataList[StepIndex];
          LineBuilder.Clear;
          LineBuilder.Append(Item.Step);
          LineBuilder.Append(',');
          LineBuilder.Append(Item.Period);
          LineBuilder.Append(',');
          LineBuilder.Append(Item.PeriodTime);
          LineBuilder.Append(',');
          LineBuilder.Append(Item.TotalTime);
          for DataIndex := 0 to Length(Item.Data) - 1 do
          begin
            LineBuilder.Append(',');
            LineBuilder.Append(Item.Data[DataIndex]);
          end;
          Lines.Add(LineBuilder.ToString);
        end;

      finally
        Lines.EndUpdate;
      end;
      Lines.SaveToFile(dlgSave1.FileName);

    finally
      Lines.Free;
      LineBuilder.Free;
    end;
  end;
end;

procedure TfrmMf6Advanced.btnOpenFileClick(Sender: TObject);
var
  FileStream : TFileStream;
  FileSize: Int64;
  Step, Period: Integer;
  PeriodTime, Totaltime: TModflowDouble;
  Text: TModflowDesc;
  Data: TMf6DoubleArray;
  Item: TMf6AdvancedData;
  MaxItems: Integer;
  Index: Integer;
  ColorIndex: Integer;
  AStyle: TSeriesPointerStyle;
  ASeries: TLineSeries;
  SeriesIndex: Integer;
begin
  inherited;
  if dlgOpen.Execute then
  begin
    FDataList.Clear;
    FSeriesList.Clear;
    FileStream := TFileStream.Create(dlgOpen.FileName,
      fmOpenRead or fmShareDenyWrite);
    try
      FileSize := FileStream.Size;
      while FileStream.Position < FileSize do
      begin
        ReadMf6AdvancedPackageList(FileStream, Step, Period,
          PeriodTime, Totaltime, Text, Data);
        Item := TMf6AdvancedData.Create;
        FDataList.Add(Item);
        Item.Step := Step;
        Item.Period := Period;
        Item.PeriodTime := PeriodTime;
        Item.Totaltime := Totaltime;
        Item.Text := Text;
        Item.Data := Data;
      end;

      AStyle := High(TSeriesPointerStyle);
      ColorIndex := -1;
      chklstItems.Clear;
      if FDataList.Count > 0 then
      begin
        MaxItems := Length(FDataList.First.Data);
        chklstItems.Items.BeginUpdate;
        try
          for Index := 1 to MaxItems do
          begin
            ASeries := TLineSeries.Create(self);
            ASeries.XValues.Order := loNone;
            FSeriesList.Add(ASeries);
            ASeries.ParentChart := chartMf6Advanced;
            ASeries.Pointer.HorizSize := 4;
            ASeries.Pointer.VertSize := 4;
            ASeries.Pointer.Visible := True;
            ASeries.Title := IntToStr(Index);
            ASeries.Active := False;
            Inc(ColorIndex);
            if ColorIndex >= Length(ColorPalette) then
            begin
              ColorIndex := 0;
            end;
            ASeries.SeriesColor := ColorPalette[ColorIndex];
            if AStyle = High(TSeriesPointerStyle) then
            begin
              AStyle := Low(TSeriesPointerStyle)
            end
            else
            begin
              Inc(AStyle);
            end;
            while AStyle in [psSmallDot, psNothing] do
            begin
              Inc(AStyle);
            end;
            ASeries.Pointer.Style := AStyle;

            chklstItems.Items.AddObject(IntToStr(Index), ASeries);

          end;
        finally
          chklstItems.Items.EndUpdate;
        end;

        for Index := 0 to FDataList.Count - 1 do
        begin
          Item := FDataList[Index];
          Assert(Length(Item.Data) = FSeriesList.Count);
          for SeriesIndex := 0 to Length(Item.Data) - 1 do
          begin
            ASeries := FSeriesList[SeriesIndex];
            ASeries.AddXY(Item.Totaltime, Item.Data[SeriesIndex]);
          end;
        end;
      end;
    finally
      FileStream.Free;
    end;
  end;
end;

procedure TfrmMf6Advanced.chklstItemsClickCheck(Sender: TObject);
begin
  inherited;
  PlotResults;
end;

procedure TfrmMf6Advanced.FormatChart1Click(Sender: TObject);
begin
  inherited;
  Application.HelpFile := ChartHelpFileName;
  try
    ChartEditor1.Execute;
  finally
    Application.HelpFile := HelpFileName;
  end;
end;

procedure TfrmMf6Advanced.FormCreate(Sender: TObject);
begin
  inherited;
  FDataList := TMf6AdvancedDataList.Create;
  FSeriesList := TObjectList<TLineSeries>.Create;
end;

procedure TfrmMf6Advanced.FormDestroy(Sender: TObject);
begin
  inherited;
  FSeriesList.Free;
  FDataList.Free;
end;

procedure TfrmMf6Advanced.FormShow(Sender: TObject);
begin
  inherited;
  mmMainMenu.Merge(frmModChart.mainMenuFormChoice);
end;

procedure TfrmMf6Advanced.PlotResults;
var
  Index: Integer;
  ASeries: TLineSeries;
begin
  Assert(chklstItems.Items.Count = FSeriesList.Count);

  for Index := 0 to chklstItems.Items.Count - 1 do
  begin
    ASeries := FSeriesList[Index];
    ASeries.Active := chklstItems.Checked[Index];
  end;
end;

end.
