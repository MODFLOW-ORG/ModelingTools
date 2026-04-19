inherited framePackagePrp: TframePackagePrp
  Width = 577
  Height = 538
  ExplicitWidth = 577
  ExplicitHeight = 538
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Width = 546
    Height = 75
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 546
    ExplicitHeight = 75
  end
  object pgcPRP: TPageControl [3]
    Left = 0
    Top = 144
    Width = 577
    Height = 394
    ActivePage = tabReleasePeriodData
    Align = alBottom
    TabOrder = 1
    object tabOptions: TTabSheet
      Caption = 'Options'
      object lblCOORDINATE_CHECK_METHOD: TLabel
        Left = 223
        Top = 323
        Width = 171
        Height = 15
        Caption = 'COORDINATE_CHECK_METHOD'
      end
      object lblDRY_TRACKING_METHOD: TLabel
        Left = 221
        Top = 266
        Width = 139
        Height = 15
        Caption = 'DRY_TRACKING_METHOD'
      end
      object lblISTOPZONE: TLabel
        Left = 221
        Top = 39
        Width = 62
        Height = 15
        Caption = 'ISTOPZONE'
      end
      object lblTrackOutput: TLabel
        Left = 25
        Top = 122
        Width = 69
        Height = 15
        Caption = 'Track Output'
      end
      object cbDRAPE: TCheckBox
        Left = 24
        Top = 344
        Width = 153
        Height = 17
        Caption = 'DRAPE'
        TabOrder = 11
      end
      object cbEXTEND_TRACKING: TCheckBox
        Left = 24
        Top = 99
        Width = 153
        Height = 17
        Caption = 'EXTEND_TRACKING'
        TabOrder = 3
      end
      object cbSTOP_AT_WEAK_SINK: TCheckBox
        Left = 25
        Top = 283
        Width = 153
        Height = 17
        Caption = 'STOP_AT_WEAK_SINK'
        TabOrder = 9
      end
      object comboCOORDINATE_CHECK_METHOD: TJvImageComboBox
        Left = 222
        Top = 344
        Width = 145
        Height = 25
        Style = csOwnerDrawVariable
        ButtonStyle = fsLighter
        DroppedWidth = 145
        ImageHeight = 0
        ImageWidth = 0
        ItemHeight = 19
        ItemIndex = 0
        TabOrder = 12
        Items = <
          item
            Brush.Style = bsClear
            Indent = 0
            Text = 'EAGER'
          end
          item
            Brush.Style = bsClear
            Indent = 0
            Text = 'NONE'
          end>
      end
      object comboDryTrackingMethod: TJvImageComboBox
        Left = 221
        Top = 287
        Width = 145
        Height = 25
        Style = csOwnerDrawVariable
        ButtonStyle = fsLighter
        DroppedWidth = 145
        ImageHeight = 0
        ImageWidth = 0
        ItemHeight = 19
        ItemIndex = 0
        TabOrder = 10
        Items = <
          item
            Brush.Style = bsClear
            Indent = 0
            Text = 'DROP'
          end
          item
            Brush.Style = bsClear
            Indent = 0
            Text = 'STOP'
          end
          item
            Brush.Style = bsClear
            Indent = 0
            Text = 'STAY'
          end>
      end
      object comboTrackOutput: TComboBox
        Left = 25
        Top = 143
        Width = 145
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = 'None'
        Items.Strings = (
          'None'
          'Binary'
          'CSV (Comma-Separated Values)'
          'Binary and CSV')
      end
      inline frameEXIT_SOLVE_TOLERANCE: TframeOptionalValue
        Left = 1
        Top = 45
        Width = 176
        Height = 56
        TabOrder = 1
        ExplicitLeft = 1
        ExplicitTop = 45
        inherited LblVariableLabel: TLabel
          Left = 25
          Width = 131
          Caption = 'EXIT_SOLVE_TOLERANCE'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 25
          ExplicitWidth = 131
        end
        inherited cbUsed: TCheckBox
          Left = 3
          Top = 21
          ExplicitLeft = 3
          ExplicitTop = 21
        end
        inherited RdeValue: TRbwDataEntry
          StyleElements = [seFont, seClient, seBorder]
        end
      end
      inline frameRELEASE_TIME_FREQUENCY: TframeOptionalValue
        Left = 197
        Top = 174
        Width = 176
        Height = 56
        TabOrder = 7
        ExplicitLeft = 197
        ExplicitTop = 174
        inherited LblVariableLabel: TLabel
          Left = 25
          Width = 148
          Caption = 'RELEASE_TIME_FREQUENCY'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 25
          ExplicitWidth = 148
        end
        inherited cbUsed: TCheckBox
          TabOrder = 1
        end
        inherited RdeValue: TRbwDataEntry
          TabOrder = 0
          StyleElements = [seFont, seClient, seBorder]
          CheckMin = True
        end
      end
      inline frameRELEASE_TIME_TOLERANCE: TframeOptionalValue
        Left = 197
        Top = 105
        Width = 176
        Height = 56
        TabOrder = 4
        ExplicitLeft = 197
        ExplicitTop = 105
        inherited LblVariableLabel: TLabel
          Left = 26
          Width = 147
          Caption = 'RELEASE_TIME_TOLERANCE'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 26
          ExplicitWidth = 147
        end
        inherited cbUsed: TCheckBox
          TabOrder = 1
        end
        inherited RdeValue: TRbwDataEntry
          TabOrder = 0
          StyleElements = [seFont, seClient, seBorder]
          CheckMin = True
        end
      end
      inline frameStopTime: TframeOptionalValue
        Left = 1
        Top = 172
        Width = 176
        Height = 56
        TabOrder = 6
        ExplicitLeft = 1
        ExplicitTop = 172
        inherited LblVariableLabel: TLabel
          Width = 55
          Caption = 'STOPTIME'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 55
        end
        inherited cbUsed: TCheckBox
          TabOrder = 1
          OnClick = frameStopTimecbUsedClick
        end
        inherited RdeValue: TRbwDataEntry
          TabOrder = 0
          StyleElements = [seFont, seClient, seBorder]
          OnChange = frameStopTimeRdeValueChange
        end
      end
      inline frameStopTravelTime: TframeOptionalValue
        Left = -8
        Top = 221
        Width = 176
        Height = 56
        TabOrder = 8
        ExplicitLeft = -8
        ExplicitTop = 221
        inherited LblVariableLabel: TLabel
          Left = 33
          Top = 13
          Width = 94
          Caption = 'STOPTRAVELTIME'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 33
          ExplicitTop = 13
          ExplicitWidth = 94
        end
        inherited cbUsed: TCheckBox
          Left = 9
          Top = 34
          TabOrder = 1
          ExplicitLeft = 9
          ExplicitTop = 34
        end
        inherited RdeValue: TRbwDataEntry
          Left = 33
          Top = 31
          TabOrder = 0
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 33
          ExplicitTop = 31
        end
      end
      object lbledtPackageName: TLabeledEdit
        Left = 25
        Top = 16
        Width = 121
        Height = 23
        EditLabel.Width = 79
        EditLabel.Height = 15
        EditLabel.Caption = 'Package Name'
        TabOrder = 0
        Text = ''
      end
      object rdeISTOPZONE: TRbwDataEntry
        Left = 221
        Top = 60
        Width = 145
        Height = 22
        Color = clBtnFace
        Enabled = False
        TabOrder = 2
        Text = '0'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
    end
    object tabReleasePeriodData: TTabSheet
      Caption = 'Release Period Data'
      ImageIndex = 2
      inline frameReleasePeriodData: TframeGrid
        Left = 0
        Top = 57
        Width = 569
        Height = 307
        Align = alClient
        TabOrder = 1
        ExplicitTop = 57
        ExplicitWidth = 569
        ExplicitHeight = 307
        inherited Panel: TPanel
          Top = 266
          Width = 569
          StyleElements = [seFont, seClient, seBorder]
          ExplicitTop = 266
          ExplicitWidth = 569
          inherited lbNumber: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited sbAdd: TSpeedButton
            Left = 297
            ExplicitLeft = 181
          end
          inherited sbInsert: TSpeedButton
            Left = 352
            ExplicitLeft = 215
          end
          inherited sbDelete: TSpeedButton
            Left = 407
            ExplicitLeft = 249
          end
          inherited seNumber: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameReleasePeriodDataseNumberChange
          end
        end
        inherited Grid: TRbwDataGrid4
          Width = 569
          Height = 266
          ColCount = 7
          Columns = <
            item
              AutoAdjustRowHeights = True
              AutoAdjustCaptionRowHeights = True
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
              AutoAdjustRowHeights = True
              AutoAdjustCaptionRowHeights = True
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
              ComboUsed = True
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
              AutoAdjustCaptionRowHeights = True
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
              AutoAdjustRowHeights = False
              AutoAdjustCaptionRowHeights = True
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
              AutoAdjustRowHeights = False
              AutoAdjustCaptionRowHeights = True
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
              AutoAdjustCaptionRowHeights = True
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
              Format = rcf4Integer
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
              AutoAdjustCaptionRowHeights = True
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
              WordWrapCaptions = True
              WordWrapCells = False
              CaseSensitivePicklist = False
              CheckStyle = csCheck
              AutoAdjustColWidths = True
            end>
          ExplicitWidth = 569
          ExplicitHeight = 266
        end
      end
      object pnlReleasePeriodData: TPanel
        Left = 0
        Top = 0
        Width = 569
        Height = 57
        Align = alTop
        TabOrder = 0
        object lblReleasePeriodData: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 561
          Height = 49
          Align = alClient
          Caption = 
            'Release times can be specified as specific times or by specific ' +
            'period. If no release times are specified, particles will be rel' +
            'eased at the beginning of the first stress period.'
          WordWrap = True
          ExplicitWidth = 534
          ExplicitHeight = 30
        end
      end
    end
    object tabReleaseTimes: TTabSheet
      Caption = 'ReleaseTimes'
      ImageIndex = 1
      object pnlReleaseTimes: TPanel
        Left = 0
        Top = 0
        Width = 569
        Height = 57
        Align = alTop
        TabOrder = 0
        object lblReleaseTimes: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 534
          Height = 30
          Align = alClient
          Caption = 
            'Release times can be specified as specific times or by specific ' +
            'period. If no release times are specified, particles will be rel' +
            'eased at the beginning of the first stress period.'
          WordWrap = True
        end
      end
      inline frameReleaseTimes: TframeGrid
        Left = 0
        Top = 57
        Width = 569
        Height = 307
        Align = alClient
        TabOrder = 1
        ExplicitTop = 57
        ExplicitWidth = 569
        ExplicitHeight = 307
        inherited Panel: TPanel
          Top = 266
          Width = 569
          StyleElements = [seFont, seClient, seBorder]
          ExplicitTop = 266
          ExplicitWidth = 569
          inherited lbNumber: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited sbAdd: TSpeedButton
            Left = 408
            Top = 8
            ExplicitLeft = 169
            ExplicitTop = 8
          end
          inherited sbInsert: TSpeedButton
            Left = 462
            Top = 8
            ExplicitLeft = 192
            ExplicitTop = 8
          end
          inherited sbDelete: TSpeedButton
            Left = 520
            Top = 8
            ExplicitLeft = 216
            ExplicitTop = 8
          end
          inherited seNumber: TJvSpinEdit
            Left = 6
            Top = 8
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameReleaseTimesseNumberChange
            ExplicitLeft = 6
            ExplicitTop = 8
          end
        end
        inherited Grid: TRbwDataGrid4
          Width = 569
          Height = 266
          Columns = <
            item
              AutoAdjustRowHeights = True
              AutoAdjustCaptionRowHeights = True
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
              Format = rcf4Real
              LimitToList = False
              MaxLength = 0
              ParentButtonFont = False
              WordWrapCaptions = True
              WordWrapCells = False
              CaseSensitivePicklist = False
              CheckStyle = csCheck
              AutoAdjustColWidths = True
            end>
          ExplicitWidth = 569
          ExplicitHeight = 266
        end
      end
    end
  end
  inherited rcSelectionController: TRbwController
    Left = 256
    Top = 32
  end
end
