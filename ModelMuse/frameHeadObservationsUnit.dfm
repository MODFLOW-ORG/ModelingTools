inherited frameHeadObservations: TframeHeadObservations
  inherited pcData: TJvPageControl
    Top = 134
    Height = 216
    ActivePage = tabTimes
    ExplicitTop = 134
    ExplicitHeight = 216
    inherited tabTimes: TTabSheet
      ExplicitHeight = 186
      inherited Panel5: TPanel
        StyleElements = [seFont, seClient, seBorder]
        inherited rdeMultiValueEdit: TRbwDataEntry
          StyleElements = [seFont, seClient, seBorder]
          OnChange = rdeMultiValueEditChange
        end
        object comboMultiStatFlag: TJvImageComboBox
          Left = 99
          Top = 5
          Width = 89
          Height = 25
          Style = csOwnerDrawVariable
          ButtonStyle = fsLighter
          DroppedWidth = 145
          ImageHeight = 0
          ImageWidth = 0
          ItemHeight = 19
          ItemIndex = -1
          TabOrder = 1
          OnChange = comboMultiStatFlagChange
          Items = <
            item
              Brush.Style = bsClear
              Indent = 0
              Text = 'Variance'
            end
            item
              Brush.Style = bsClear
              Indent = 0
              Text = 'Standard dev.'
            end
            item
              Brush.Style = bsClear
              Indent = 0
              Text = 'Coef. of var.'
            end
            item
              Brush.Style = bsClear
              Indent = 0
              Text = 'Weight'
            end
            item
              Brush.Style = bsClear
              Indent = 0
              Text = 'Sq. rt. of weight'
            end>
        end
      end
      inherited Panel2: TPanel
        Top = 147
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 110
        inherited lblNumberOfTimes: TLabel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited seTimes: TJvSpinEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
      inherited rdgObservations: TRbwDataGrid4
        Height = 112
        OnBeforeDrawCell = rdgObservationsBeforeDrawCell
        Columns = <
          item
            AutoAdjustRowHeights = False
            AutoAdjustCaptionRowHeights = False
            ButtonCaption = 'F()'
            ButtonFont.Charset = DEFAULT_CHARSET
            ButtonFont.Color = clWindowText
            ButtonFont.Height = -11
            ButtonFont.Name = 'Tahoma'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 35
            CheckMax = False
            CheckMin = False
            ComboUsed = False
            Format = rcf4Real
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
            AutoAdjustRowHeights = True
            AutoAdjustCaptionRowHeights = False
            ButtonCaption = 'F()'
            ButtonFont.Charset = DEFAULT_CHARSET
            ButtonFont.Color = clWindowText
            ButtonFont.Height = -11
            ButtonFont.Name = 'Tahoma'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 35
            CheckMax = False
            CheckMin = False
            ComboUsed = False
            Format = rcf4Real
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
            AutoAdjustRowHeights = False
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
            CheckMin = True
            ComboUsed = False
            Format = rcf4Real
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
            ButtonFont.Height = -11
            ButtonFont.Name = 'Tahoma'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 20
            CheckMax = False
            CheckMin = False
            ComboUsed = True
            Format = rcf4String
            LimitToList = True
            MaxLength = 0
            ParentButtonFont = False
            PickList.Strings = (
              'Variance (0)'
              'Standard dev. (1)'
              'Coef. of var. (2)'
              'Weight (3)'
              'Sq. rt. of weight (4)')
            WordWrapCaptions = False
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
            Format = rcf4String
            LimitToList = False
            MaxLength = 0
            ParentButtonFont = False
            WordWrapCaptions = False
            WordWrapCells = True
            CaseSensitivePicklist = False
            CheckStyle = csCheck
            AutoAdjustColWidths = False
          end>
        ExplicitHeight = 112
      end
    end
    inherited tabLayers: TTabSheet
      ExplicitHeight = 186
      inherited Panel4: TPanel
        Top = 147
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 110
        inherited lblNumberOfLayers: TLabel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited seLayers: TJvSpinEdit
          Left = 9
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 9
        end
      end
      inherited Panel6: TPanel
        StyleElements = [seFont, seClient, seBorder]
        inherited rdeMultiLayerEdit: TRbwDataEntry
          StyleElements = [seFont, seClient, seBorder]
        end
      end
      inherited rdgLayers: TRbwDataGrid4
        Height = 112
        ExplicitWidth = 533
        ExplicitHeight = 112
      end
    end
  end
  inherited pnlCaption: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnlName: TPanel
    Height = 109
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 109
    inherited lblTreatment: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited edObsName: TLabeledEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited comboTreatment: TComboBox
      StyleElements = [seFont, seClient, seBorder]
    end
    object rgMultiObsMethod: TRadioGroup
      Left = 9
      Top = 49
      Width = 368
      Height = 56
      Caption = 'How will observations be analyzed? (ITT)'
      Enabled = False
      ItemIndex = 1
      Items.Strings = (
        'All heads (1)'
        'Calculate drawdown relative to first head (2)')
      TabOrder = 2
      OnClick = rgMultiObsMethodClick
    end
  end
end
