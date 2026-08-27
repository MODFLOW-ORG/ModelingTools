object framePrtDisplay: TframePrtDisplay
  Left = 0
  Top = 0
  Width = 502
  Height = 486
  TabOrder = 0
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 502
    Height = 486
    ActivePage = tabBasic
    Align = alClient
    TabOrder = 0
    object tabBasic: TTabSheet
      Caption = 'Basic'
      DesignSize = (
        494
        456)
      object lblPrtTracklineFile: TLabel
        Left = 8
        Top = 8
        Width = 70
        Height = 15
        Caption = 'PRT Track file'
      end
      object lblColorScheme: TLabel
        Left = 3
        Top = 175
        Width = 73
        Height = 15
        Caption = 'Color scheme'
      end
      object pbColorScheme: TPaintBox
        Left = 3
        Top = 239
        Width = 475
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        OnPaint = pbColorSchemePaint
      end
      object lblColorAdjustment: TLabel
        Left = 8
        Top = 278
        Width = 92
        Height = 15
        Caption = 'Color adjustment'
      end
      object lblCycles: TLabel
        Left = 342
        Top = 311
        Width = 34
        Height = 15
        Anchors = [akTop, akRight]
        Caption = 'Cycles'
        ExplicitLeft = 305
      end
      object lblMaxTime: TLabel
        Left = 192
        Top = 8
        Width = 62
        Height = 15
        Caption = 'lblMaxTime'
      end
      object lblSinglePointSize: TLabel
        Left = 3
        Top = 340
        Width = 125
        Height = 15
        Anchors = [akTop, akRight]
        Caption = 'Single point size (pixels)'
      end
      object fedPrtTracklineFile: TJvFilenameEdit
        Left = 3
        Top = 29
        Width = 475
        Height = 23
        OnBeforeDialog = fedPrtTracklineFileBeforeDialog
        DefaultExt = '.trk'
        Filter = 
          'PRT Track files (*.trk;*.trk.csv)|*.trk;*.trk.csv|All files (*.*' +
          ')|*.*'
        DialogOptions = [ofHideReadOnly, ofFileMustExist]
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = ''
        OnChange = fedPrtTracklineFileChange
      end
      object cbLimitToCurrentIn2D: TCheckBox
        Left = 3
        Top = 152
        Width = 377
        Height = 17
        Caption = 'Limit to current column, row and layer in 2D views'
        TabOrder = 1
      end
      object comboColorScheme: TComboBox
        Left = 3
        Top = 196
        Width = 337
        Height = 23
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 12
        ItemIndex = 0
        TabOrder = 2
        Text = 'Rainbow'
        OnChange = comboColorSchemeChange
        Items.Strings = (
          'Rainbow'
          'Green to Magenta'
          'Blue to Red'
          'Blue to Dark Orange'
          'Blue to Green'
          'Brown to Blue'
          'Blue to Gray'
          'Blue to Orange'
          'Blue to Orange-Red'
          'Light Blue to Dark Blue'
          'Modified Spectral Scheme'
          'Stepped Sequential')
      end
      object jsColorExponent: TJvxSlider
        Left = 3
        Top = 299
        Width = 150
        Height = 40
        Increment = 2
        MaxValue = 200
        TabOrder = 3
        Value = 40
        OnChange = jsColorExponentChange
      end
      object seColorExponent: TJvSpinEdit
        Left = 159
        Top = 308
        Width = 65
        Height = 23
        ButtonKind = bkClassic
        Increment = 0.010000000000000000
        MaxValue = 2.000000000000000000
        ValueType = vtFloat
        Value = 0.400000000000000000
        TabOrder = 4
        OnChange = seColorExponentChange
      end
      object seCycles: TJvSpinEdit
        Left = 382
        Top = 308
        Width = 101
        Height = 23
        ButtonKind = bkClassic
        MaxValue = 2147483647.000000000000000000
        MinValue = 1.000000000000000000
        Value = 1.000000000000000000
        Anchors = [akTop, akRight]
        TabOrder = 5
        OnChange = seCyclesChange
      end
      object btnColorSchemes: TButton
        Left = 351
        Top = 180
        Width = 132
        Height = 41
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Edit custom color schemes'
        TabOrder = 6
        WordWrap = True
        OnClick = btnColorSchemesClick
      end
      object chklstPlotTypes: TCheckListBox
        Left = 3
        Top = 58
        Width = 201
        Height = 87
        ItemHeight = 17
        Items.Strings = (
          'Start Points'
          'End Points'
          'Track Line'
          'Specified Track Times')
        TabOrder = 7
      end
      object seSinglePointSize: TJvSpinEdit
        Left = 3
        Top = 361
        Width = 100
        Height = 23
        MaxValue = 2147483647.000000000000000000
        MinValue = 1.000000000000000000
        Value = 1.000000000000000000
        Anchors = [akTop, akRight]
        TabOrder = 8
      end
    end
    object tabOptions: TTabSheet
      Caption = 'Options'
      ImageIndex = 1
      object rgShow2D: TRadioGroup
        Left = 0
        Top = 0
        Width = 494
        Height = 102
        Align = alTop
        Caption = 'What to show'
        ItemIndex = 0
        Items.Strings = (
          'Show all'
          'Specify criteria to show points'
          'Specify criteria at starting points to show points'
          'Specify criteria at ending points to show points')
        TabOrder = 0
        OnClick = rgShow2DClick
      end
      object rgColorBy: TRadioGroup
        Left = 0
        Top = 102
        Width = 177
        Height = 354
        Align = alLeft
        Caption = 'Color by'
        ItemIndex = 0
        Items.Strings = (
          'None'
          'Particle Number'
          'X'#39
          'Y'#39
          'Z'
          'Starting X'#39
          'Starting Y'#39
          'Starting Z'
          'Ending X'#39
          'Ending Y'#39
          'Ending Z'
          'PRP Number'
          'Release Time'
          'Time '
          'log(Time)'
          'Status'
          'Reason'
          'Zone'
          'Line through Zone')
        TabOrder = 1
        OnClick = rgColorByClick
      end
      object pnl1: TPanel
        Left = 177
        Top = 102
        Width = 317
        Height = 354
        Align = alClient
        Caption = 'pnl1'
        TabOrder = 2
        object spl2: TSplitter
          Left = 1
          Top = 1
          Width = 5
          Height = 352
          ExplicitTop = 6
          ExplicitHeight = 347
        end
        object pnl2: TPanel
          Left = 6
          Top = 1
          Width = 310
          Height = 352
          Align = alClient
          Caption = 'pnl2'
          TabOrder = 0
          object spl1: TSplitter
            Left = 1
            Top = 193
            Width = 308
            Height = 5
            Cursor = crVSplit
            Align = alTop
            ExplicitTop = 10
            ExplicitWidth = 315
          end
          object rdgLimits: TRbwDataGrid4
            Left = 1
            Top = 1
            Width = 308
            Height = 192
            Align = alTop
            ColCount = 3
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
            TabOrder = 0
            OnSelectCell = rdgLimitsSelectCell
            OnSetEditText = rdgLimitsSetEditText
            ExtendedAutoDistributeText = False
            AutoMultiEdit = True
            AutoDistributeText = False
            AutoIncreaseColCount = False
            AutoIncreaseRowCount = False
            SelectedRowOrColumnColor = clAqua
            UnselectableColor = clBtnFace
            OnStateChange = rdgLimitsStateChange
            ColorRangeSelection = False
            Columns = <
              item
                AutoAdjustRowHeights = True
                AutoAdjustCaptionRowHeights = False
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4Boolean
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                AutoAdjustCaptionRowHeights = False
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4Integer
                LimitToList = False
                Max = 1.000000000000000000
                MaxLength = 0
                Min = 1.000000000000000000
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                AutoAdjustCaptionRowHeights = False
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4Integer
                LimitToList = False
                Max = 1.000000000000000000
                MaxLength = 0
                Min = 1.000000000000000000
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end>
            WordWrapRowCaptions = False
          end
          object rdgSetLimits: TRbwDataGrid4
            Left = 1
            Top = 198
            Width = 308
            Height = 153
            Align = alClient
            ColCount = 2
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
            TabOrder = 1
            OnSelectCell = rdgSetLimitsSelectCell
            ExtendedAutoDistributeText = False
            AutoMultiEdit = True
            AutoDistributeText = False
            AutoIncreaseColCount = False
            AutoIncreaseRowCount = False
            SelectedRowOrColumnColor = clAqua
            UnselectableColor = clBtnFace
            OnButtonClick = rdgSetLimitsButtonClick
            OnStateChange = rdgSetLimitsStateChange
            ColorRangeSelection = False
            Columns = <
              item
                AutoAdjustRowHeights = True
                AutoAdjustCaptionRowHeights = False
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4Boolean
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                AutoAdjustCaptionRowHeights = False
                ButtonCaption = 'Edit'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 40
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                Max = 1.000000000000000000
                MaxLength = 0
                Min = 1.000000000000000000
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end>
            WordWrapRowCaptions = False
          end
        end
      end
    end
  end
end
