inherited framePackagePrp: TframePackagePrp
  Width = 577
  Height = 538
  OnResize = FrameResize
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
    ActivePage = tabOptions
    Align = alBottom
    TabOrder = 1
    object tabOptions: TTabSheet
      Caption = 'Options'
      object lblCOORDINATE_CHECK_METHOD: TLabel
        Left = 316
        Top = 261
        Width = 169
        Height = 15
        Caption = 'COORDINATE_CHECK_METHOD'
      end
      object lblDRY_TRACKING_METHOD: TLabel
        Left = 314
        Top = 204
        Width = 137
        Height = 15
        Caption = 'DRY_TRACKING_METHOD'
      end
      object lblISTOPZONE: TLabel
        Left = 313
        Top = 13
        Width = 61
        Height = 15
        Caption = 'ISTOPZONE'
      end
      object lblTrackOutput: TLabel
        Left = 26
        Top = 106
        Width = 68
        Height = 15
        Caption = 'Track Output'
      end
      object cbDRAPE: TCheckBox
        Left = 26
        Top = 298
        Width = 153
        Height = 17
        Caption = 'DRAPE'
        TabOrder = 10
      end
      object cbEXTEND_TRACKING: TCheckBox
        Left = 25
        Top = 75
        Width = 216
        Height = 17
        Caption = 'EXTEND_TRACKING'
        TabOrder = 2
      end
      object cbSTOP_AT_WEAK_SINK: TCheckBox
        Left = 25
        Top = 275
        Width = 223
        Height = 17
        Caption = 'STOP_AT_WEAK_SINK'
        TabOrder = 8
      end
      object comboCOORDINATE_CHECK_METHOD: TJvImageComboBox
        Left = 315
        Top = 282
        Width = 145
        Height = 25
        Style = csOwnerDrawVariable
        ButtonStyle = fsLighter
        DroppedWidth = 145
        ImageHeight = 0
        ImageWidth = 0
        ItemHeight = 19
        ItemIndex = 0
        TabOrder = 11
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
        Left = 314
        Top = 225
        Width = 145
        Height = 25
        Style = csOwnerDrawVariable
        ButtonStyle = fsLighter
        DroppedWidth = 145
        ImageHeight = 0
        ImageWidth = 0
        ItemHeight = 19
        ItemIndex = 0
        TabOrder = 9
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
        Left = 26
        Top = 127
        Width = 257
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'None'
        Items.Strings = (
          'None'
          'Binary'
          'CSV (Comma-Separated Values)'
          'Binary and CSV')
      end
      inline frameEXIT_SOLVE_TOLERANCE: TframeOptionalValue
        Left = 1
        Top = 13
        Width = 224
        Height = 56
        TabOrder = 0
        ExplicitLeft = 1
        ExplicitTop = 13
        ExplicitWidth = 224
        inherited LblVariableLabel: TLabel
          Left = 25
          Width = 129
          Caption = 'EXIT_SOLVE_TOLERANCE'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 25
          ExplicitWidth = 129
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
        Left = 289
        Top = 142
        Width = 256
        Height = 56
        TabOrder = 6
        ExplicitLeft = 289
        ExplicitTop = 142
        ExplicitWidth = 256
        inherited LblVariableLabel: TLabel
          Left = 25
          Width = 147
          Caption = 'RELEASE_TIME_FREQUENCY'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 25
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
      inline frameRELEASE_TIME_TOLERANCE: TframeOptionalValue
        Left = 289
        Top = 73
        Width = 272
        Height = 56
        TabOrder = 3
        ExplicitLeft = 289
        ExplicitTop = 73
        ExplicitWidth = 272
        inherited LblVariableLabel: TLabel
          Left = 25
          Width = 145
          Caption = 'RELEASE_TIME_TOLERANCE'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 25
          ExplicitWidth = 145
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
        Left = 2
        Top = 164
        Width = 222
        Height = 56
        TabOrder = 5
        ExplicitLeft = 2
        ExplicitTop = 164
        ExplicitWidth = 222
        inherited LblVariableLabel: TLabel
          Width = 53
          Caption = 'STOPTIME'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 53
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
        Top = 213
        Width = 232
        Height = 56
        TabOrder = 7
        ExplicitLeft = -8
        ExplicitTop = 213
        ExplicitWidth = 232
        inherited LblVariableLabel: TLabel
          Left = 33
          Top = 13
          Width = 91
          Caption = 'STOPTRAVELTIME'
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 33
          ExplicitTop = 13
          ExplicitWidth = 91
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
      object rdeISTOPZONE: TRbwDataEntry
        Left = 314
        Top = 34
        Width = 145
        Height = 22
        Color = clBtnFace
        Enabled = False
        TabOrder = 1
        Text = '0'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
    end
    object tabReleaseTimes: TTabSheet
      Caption = 'ReleaseTimes'
      ImageIndex = 1
      object pnlReleaseTimes: TPanel
        Left = 0
        Top = 0
        Width = 569
        Height = 65
        Align = alTop
        TabOrder = 0
        object lblReleaseTimes: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 561
          Height = 57
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
      inline frameReleaseTimes: TframeGrid
        Left = 0
        Top = 65
        Width = 569
        Height = 299
        Align = alClient
        TabOrder = 1
        ExplicitTop = 57
        ExplicitWidth = 569
        ExplicitHeight = 307
        inherited Panel: TPanel
          Top = 258
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
          Height = 258
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
    object tabReleasePeriodData: TTabSheet
      Caption = 'Release Period Data'
      ImageIndex = 2
      inline frameReleasePeriodData: TframeGrid
        Left = 0
        Top = 65
        Width = 569
        Height = 299
        Align = alClient
        TabOrder = 1
        ExplicitTop = 57
        ExplicitWidth = 569
        ExplicitHeight = 307
        inherited Panel: TPanel
          Top = 258
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
          Height = 258
          ColCount = 7
          DefaultColWidth = 50
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
          ExplicitHeight = 258
        end
      end
      object pnlReleasePeriodData: TPanel
        Left = 0
        Top = 0
        Width = 569
        Height = 65
        Align = alTop
        TabOrder = 0
        object lblReleasePeriodData: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 561
          Height = 57
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
  end
  inherited rcSelectionController: TRbwController
    Left = 256
    Top = 32
  end
end
