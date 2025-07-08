inherited frmMf6Advanced: TfrmMf6Advanced
  Caption = 'frmMf6Advanced'
  ClientHeight = 581
  Font.Charset = ANSI_CHARSET
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Menu = mmMainMenu
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object splttrMain: TJvNetscapeSplitter [0]
    Left = 659
    Top = 0
    Height = 581
    Align = alRight
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    ExplicitLeft = 88
    ExplicitTop = -32
    ExplicitHeight = 100
  end
  object chartMf6Advanced: TChart [1]
    Left = 0
    Top = 0
    Width = 659
    Height = 581
    BackWall.Brush.Gradient.Direction = gdBottomTop
    BackWall.Brush.Gradient.EndColor = clWhite
    BackWall.Brush.Gradient.StartColor = 15395562
    BackWall.Brush.Gradient.Visible = True
    BackWall.Transparent = False
    Foot.Font.Color = clBlue
    Foot.Font.Name = 'Verdana'
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    Gradient.Visible = True
    LeftWall.Color = 14745599
    Legend.Font.Name = 'Verdana'
    Legend.Shadow.Transparency = 0
    RightWall.Color = 14745599
    Title.Font.Name = 'Verdana'
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Grid.Color = 11119017
    BottomAxis.Grid.Visible = False
    BottomAxis.LabelsFormat.Font.Name = 'Verdana'
    BottomAxis.TicksInner.Color = 11119017
    BottomAxis.Title.Caption = 'Total Time'
    BottomAxis.Title.Font.Height = -16
    BottomAxis.Title.Font.Name = 'Times New Roman'
    DepthAxis.Axis.Color = 4210752
    DepthAxis.Grid.Color = 11119017
    DepthAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthAxis.TicksInner.Color = 11119017
    DepthAxis.Title.Font.Name = 'Verdana'
    DepthTopAxis.Axis.Color = 4210752
    DepthTopAxis.Grid.Color = 11119017
    DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthTopAxis.TicksInner.Color = 11119017
    DepthTopAxis.Title.Font.Name = 'Verdana'
    LeftAxis.Axis.Color = 4210752
    LeftAxis.Grid.Color = 11119017
    LeftAxis.Grid.Visible = False
    LeftAxis.LabelsFormat.Font.Name = 'Verdana'
    LeftAxis.TicksInner.Color = 11119017
    LeftAxis.Title.Caption = 'Values'
    LeftAxis.Title.Font.Height = -16
    LeftAxis.Title.Font.Name = 'Times New Roman'
    RightAxis.Axis.Color = 4210752
    RightAxis.Grid.Color = 11119017
    RightAxis.LabelsFormat.Font.Name = 'Verdana'
    RightAxis.TicksInner.Color = 11119017
    RightAxis.Title.Font.Name = 'Verdana'
    TopAxis.Axis.Color = 4210752
    TopAxis.Grid.Color = 11119017
    TopAxis.LabelsFormat.Font.Name = 'Verdana'
    TopAxis.TicksInner.Color = 11119017
    TopAxis.Title.Font.Name = 'Verdana'
    View3D = False
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 441
    ExplicitHeight = 854
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
  end
  object pnl1: TPanel [2]
    Left = 669
    Top = 0
    Width = 185
    Height = 581
    Align = alRight
    TabOrder = 1
    ExplicitLeft = 568
    ExplicitHeight = 337
    object pnl2: TPanel
      Left = 1
      Top = 1
      Width = 183
      Height = 72
      Align = alTop
      TabOrder = 0
      object btnOpenFile: TButton
        Left = 5
        Top = 8
        Width = 100
        Height = 25
        Caption = 'Open File'
        TabOrder = 0
        OnClick = btnOpenFileClick
      end
      object btnExport: TButton
        Left = 5
        Top = 39
        Width = 100
        Height = 25
        Caption = 'Export to .csv'
        TabOrder = 1
        OnClick = btnExportClick
      end
    end
    object chklstItems: TJvCheckListBox
      Left = 1
      Top = 73
      Width = 183
      Height = 507
      OnClickCheck = chklstItemsClickCheck
      Align = alClient
      DoubleBuffered = False
      ItemHeight = 19
      ParentDoubleBuffered = False
      TabOrder = 1
      ExplicitLeft = 104
      ExplicitTop = 344
      ExplicitWidth = 121
      ExplicitHeight = 97
    end
  end
  inherited RBW_SetWindowState1: TRBW_SetWindowState
    Owner = Owner
  end
  object mmMainMenu: TMainMenu
    Left = 380
    Top = 2
    object File1: TMenuItem
      Caption = 'File'
      object Opendatafile1: TMenuItem
        Caption = 'Open'
      end
      object Save1: TMenuItem
        Caption = 'Save'
      end
      object Saveasimage1: TMenuItem
        Caption = 'Save as image'
      end
      object Print1: TMenuItem
        Caption = 'Print'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
      end
    end
    object FormatChart1: TMenuItem
      Caption = 'Format Chart'
      GroupIndex = 2
      OnClick = FormatChart1Click
    end
    object Help1: TMenuItem
      Caption = 'Help'
      GroupIndex = 2
      object Help2: TMenuItem
        Caption = 'Help'
      end
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 
      'Advanced Package Files|*.lk_stg;*.stage;*.maw_head;*.water_conte' +
      'nt;*.lke_temp;*.lkt_conc;*.sfe_temp;*.sft_conc;*.mwe_temp;*.mwt_' +
      'conc;*.uzee_temp;*.uzt_conc|All Files (*.*)|*.*'
    Left = 152
    Top = 32
  end
  object ChartEditor1: TChartEditor
    Chart = chartMf6Advanced
    Title = 'Editing Flow Rate Plot'
    GalleryHeight = 0
    GalleryWidth = 0
    Height = 0
    Width = 0
    Left = 64
    Top = 20
  end
  object dlgSave1: TSaveDialog
    DefaultExt = '.csv'
    Filter = 'Comma-Separated Values (*.csv)|*.csv'
    Left = 248
    Top = 16
  end
end
