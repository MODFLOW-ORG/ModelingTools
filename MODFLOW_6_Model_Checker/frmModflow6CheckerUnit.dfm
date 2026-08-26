object frmModflow6Checker: TfrmModflow6Checker
  Left = 0
  Top = 0
  Caption = 'MODFLOW 6 Model Checker'
  ClientHeight = 635
  ClientWidth = 1020
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    1020
    635)
  TextHeight = 15
  object lbl1: TLabel
    Left = 16
    Top = 51
    Width = 70
    Height = 15
    Caption = 'MF6 *.lst files'
  end
  object lbl2: TLabel
    Left = 224
    Top = 27
    Width = 96
    Height = 15
    Caption = 'Failed termination'
  end
  object lblWarnings: TLabel
    Left = 224
    Top = 200
    Width = 50
    Height = 15
    Caption = 'Warnings'
  end
  object lblListingAnalyst: TLabel
    Left = 520
    Top = 566
    Width = 77
    Height = 15
    Caption = 'Listing Analyst'
  end
  object lblPercentDiscrepancy: TLabel
    Left = 224
    Top = 368
    Width = 136
    Height = 15
    Caption = 'Percent Discrepancy > 0.1'
  end
  object memoListingFilels: TMemo
    Left = 16
    Top = 72
    Width = 185
    Height = 473
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object memoFailed: TMemo
    Left = 224
    Top = 48
    Width = 788
    Height = 129
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
    ExplicitWidth = 715
  end
  object btn1: TButton
    Left = 8
    Top = 559
    Width = 177
    Height = 25
    Caption = 'Check for issues'
    TabOrder = 2
    OnClick = btn1Click
  end
  object memoWarnings: TMemo
    Left = 224
    Top = 221
    Width = 788
    Height = 129
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
  object btnSelectDirectory: TButton
    Left = 16
    Top = 20
    Width = 113
    Height = 25
    Caption = 'Select Directory'
    TabOrder = 4
    OnClick = btnSelectDirectoryClick
  end
  object fedListingAnalyst: TJvFilenameEdit
    Left = 520
    Top = 587
    Width = 401
    Height = 23
    TabOrder = 5
    Text = 'C:\ModelingTools\ModelMonitor\Release\Win64\ListingAnalyst.exe'
  end
  object btnOpenAll: TButton
    Left = 224
    Top = 559
    Width = 193
    Height = 25
    Caption = 'Open all failed or with warnings'
    TabOrder = 6
    OnClick = btnOpenAllClick
  end
  object btnOpenPercentDiscrepancy: TButton
    Left = 224
    Top = 592
    Width = 233
    Height = 25
    Caption = 'Open files with Percent Discrepancy issues'
    TabOrder = 7
    OnClick = btnOpenPercentDiscrepancyClick
  end
  object stat1: TStatusBar
    Left = 0
    Top = 616
    Width = 1020
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitLeft = 560
    ExplicitTop = 632
    ExplicitWidth = 0
  end
  object rdgPercentDiscrepancy: TRbwDataGrid4
    Left = 224
    Top = 384
    Width = 788
    Height = 161
    Anchors = [akLeft, akTop, akRight]
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    TabOrder = 9
    ExtendedAutoDistributeText = False
    AutoMultiEdit = False
    AutoDistributeText = False
    AutoIncreaseColCount = False
    AutoIncreaseRowCount = False
    SelectedRowOrColumnColor = clAqua
    UnselectableColor = clBtnFace
    OnButtonClick = rdgPercentDiscrepancyButtonClick
    ColorRangeSelection = False
    Columns = <
      item
        AutoAdjustRowHeights = False
        AutoAdjustCaptionRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -12
        ButtonFont.Name = 'Segoe UI'
        ButtonFont.Style = []
        ButtonUsed = True
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        CaseSensitivePicklist = False
        CheckStyle = csCheck
        AutoAdjustColWidths = True
      end
      item
        AutoAdjustRowHeights = False
        AutoAdjustCaptionRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -12
        ButtonFont.Name = 'Segoe UI'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        CaseSensitivePicklist = False
        CheckStyle = csCheck
        AutoAdjustColWidths = True
      end
      item
        AutoAdjustRowHeights = False
        AutoAdjustCaptionRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -12
        ButtonFont.Name = 'Segoe UI'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        CaseSensitivePicklist = False
        CheckStyle = csCheck
        AutoAdjustColWidths = True
      end>
    WordWrapRowCaptions = False
  end
  object jvsdSelectDirectory: TJvSelectDirectory
    Left = 352
    Top = 24
  end
  object jvcpRunListingAnalyst: TJvCreateProcess
    Left = 576
    Top = 16
  end
end
