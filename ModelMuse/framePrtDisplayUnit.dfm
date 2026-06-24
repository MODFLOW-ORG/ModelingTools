object framePrtDisplay: TframePrtDisplay
  Left = 0
  Top = 0
  Width = 465
  Height = 486
  TabOrder = 0
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 465
    Height = 486
    ActivePage = tabOptions
    Align = alClient
    TabOrder = 0
    object tabBasic: TTabSheet
      Caption = 'Basic'
      DesignSize = (
        457
        456)
      object lblPrtTracklineFile: TLabel
        Left = 8
        Top = 8
        Width = 70
        Height = 15
        Caption = 'PRT Track file'
      end
      object lblColorScheme: TLabel
        Left = 8
        Top = 175
        Width = 73
        Height = 15
        Caption = 'Color scheme'
      end
      object pbColorScheme: TPaintBox
        Left = 8
        Top = 234
        Width = 438
        Height = 33
        Anchors = [akLeft, akTop, akRight]
      end
      object lblColorAdjustment: TLabel
        Left = 8
        Top = 278
        Width = 92
        Height = 15
        Caption = 'Color adjustment'
      end
      object lblCycles: TLabel
        Left = 305
        Top = 311
        Width = 34
        Height = 15
        Anchors = [akTop, akRight]
        Caption = 'Cycles'
      end
      object lblMaxTime: TLabel
        Left = 192
        Top = 8
        Width = 62
        Height = 15
        Caption = 'lblMaxTime'
      end
      object fedPrtTracklineFile: TJvFilenameEdit
        Left = 3
        Top = 29
        Width = 438
        Height = 23
        DefaultExt = '.trk'
        Filter = 
          'MODPATH Pathline files (*.path;*.path_bin;*.pathline)|*.path;*.p' +
          'ath_bin;*.pathline|All files (*.*)|*.*'
        DialogOptions = [ofHideReadOnly, ofFileMustExist]
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = ''
      end
      object cbLimitToCurrentIn2D: TCheckBox
        Left = 8
        Top = 152
        Width = 377
        Height = 17
        Caption = 'Limit to current column, row and layer in 2D views'
        TabOrder = 1
      end
      object comboColorScheme: TComboBox
        Left = 8
        Top = 195
        Width = 335
        Height = 23
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 12
        ItemIndex = 0
        TabOrder = 2
        Text = 'Rainbow'
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
        Top = 294
        Width = 150
        Height = 40
        Increment = 2
        MaxValue = 200
        TabOrder = 3
        Value = 40
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
      end
      object seCycles: TJvSpinEdit
        Left = 345
        Top = 308
        Width = 101
        Height = 23
        ButtonKind = bkClassic
        MaxValue = 2147483647.000000000000000000
        MinValue = 1.000000000000000000
        Value = 1.000000000000000000
        Anchors = [akTop, akRight]
        TabOrder = 5
      end
      object btnColorSchemes: TButton
        Left = 349
        Top = 175
        Width = 97
        Height = 41
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Edit custom color schemes'
        TabOrder = 6
        WordWrap = True
      end
      object chklstPlotTypes: TCheckListBox
        Left = 8
        Top = 58
        Width = 169
        Height = 87
        ItemHeight = 17
        Items.Strings = (
          'Start Points'
          'End Points'
          'Track Line'
          'Specified Track Times')
        TabOrder = 7
      end
    end
    object tabOptions: TTabSheet
      Caption = 'Options'
      ImageIndex = 1
      DesignSize = (
        457
        456)
      object rgShow2D: TRadioGroup
        Left = 3
        Top = 3
        Width = 449
        Height = 116
        Caption = 'What to show'
        ItemIndex = 0
        Items.Strings = (
          'Show all'
          'Specify columns, rows, layers, and/or times to show'
          'Specify starting columns, rows, layers, and/or times to show'
          'Specify ending columns, rows, layers, and/or times to show')
        TabOrder = 0
      end
      object rgColorBy: TRadioGroup
        Left = 3
        Top = 125
        Width = 137
        Height = 180
        Caption = 'Color by'
        ItemIndex = 0
        Items.Strings = (
          'None'
          'Time'
          'log(Time)'
          'X'#39
          'Y'#39
          'Z'
          'Group')
        TabOrder = 1
      end
      object rdgLimits: TRbwDataGrid4
        Left = 146
        Top = 125
        Width = 306
        Height = 332
        Anchors = [akLeft, akTop, akBottom]
        ColCount = 3
        FixedCols = 0
        RowCount = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 2
        ExtendedAutoDistributeText = False
        AutoMultiEdit = True
        AutoDistributeText = False
        AutoIncreaseColCount = False
        AutoIncreaseRowCount = False
        SelectedRowOrColumnColor = clAqua
        UnselectableColor = clBtnFace
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
    end
  end
end
