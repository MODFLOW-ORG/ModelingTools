object framePrpMultiplePackages: TframePrpMultiplePackages
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object pcPrt: TPageControl
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    ActivePage = tabTrackByStressPeriod
    Align = alClient
    TabOrder = 0
    object tabOptions: TTabSheet
      Caption = 'Options'
      object grpMIP: TGroupBox
        Left = 3
        Top = 3
        Width = 246
        Height = 86
        Caption = 'MIP Package'
        TabOrder = 0
        object cbRetardationFactor: TCheckBox
          Left = 16
          Top = 24
          Width = 169
          Height = 17
          Caption = 'Use retardation factor'
          TabOrder = 0
        end
        object cbUseParticleStopZones: TCheckBox
          Left = 16
          Top = 48
          Width = 169
          Height = 17
          Caption = 'Use particle stop zones'
          TabOrder = 1
        end
      end
      object grpOutputControl: TGroupBox
        Left = 8
        Top = 96
        Width = 369
        Height = 201
        Caption = 'Output Control (OC) Package'
        TabOrder = 1
        object lblOutputFiles: TLabel
          Left = 11
          Top = 24
          Width = 64
          Height = 15
          Caption = 'Output Files'
        end
        object lblTrackEvents: TLabel
          Left = 160
          Top = 24
          Width = 65
          Height = 15
          Caption = 'Track Events'
        end
        object chklstOutputFiles: TJvCheckListBox
          Left = 11
          Top = 45
          Width = 137
          Height = 89
          DoubleBuffered = False
          ItemHeight = 17
          Items.Strings = (
            'Binary budget file'
            'CSV budget file'
            'Binary track file'
            'CSV track file')
          ParentDoubleBuffered = False
          ScrollWidth = 121
          TabOrder = 0
        end
        object chklstTrackEvents: TJvCheckListBox
          Left = 160
          Top = 48
          Width = 185
          Height = 145
          DoubleBuffered = False
          ItemHeight = 17
          Items.Strings = (
            'TRACK_RELEASE'
            'TRACK_EXIT'
            'TRACK_SUBFEATURE_EXIT'
            'TRACK_TIMESTEP'
            'TRACK_TERMINATE'
            'TRACK_WEAKSINK'
            'TRACK_USERTIME'
            'TRACK_DROPPED')
          ParentDoubleBuffered = False
          ScrollWidth = 167
          TabOrder = 1
        end
      end
    end
    object tabPrpPackages: TTabSheet
      Caption = 'PRP Packages'
      ImageIndex = 1
      inline framePrpPackages: TframeGrid
        Left = 0
        Top = 0
        Width = 632
        Height = 450
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 632
        ExplicitHeight = 450
        inherited Panel: TPanel
          Top = 409
          Width = 632
          StyleElements = [seFont, seClient, seBorder]
          ExplicitTop = 409
          ExplicitWidth = 632
          inherited lbNumber: TLabel
            Width = 184
            Caption = 'Number of PRP packages in model'
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 184
          end
          inherited sbAdd: TSpeedButton
            Left = 332
            ExplicitLeft = 241
          end
          inherited sbInsert: TSpeedButton
            Left = 393
            ExplicitLeft = 286
          end
          inherited sbDelete: TSpeedButton
            Left = 452
            ExplicitLeft = 330
          end
          inherited seNumber: TJvSpinEdit
            Left = 6
            Top = 8
            StyleElements = [seFont, seClient, seBorder]
            MinValue = 1.000000000000000000
            Value = 1.000000000000000000
            ExplicitLeft = 6
            ExplicitTop = 8
          end
        end
        inherited Grid: TRbwDataGrid4
          Width = 632
          Height = 409
          ColCount = 2
          Columns = <
            item
              AutoAdjustRowHeights = False
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
              WordWrapCaptions = False
              WordWrapCells = False
              CaseSensitivePicklist = False
              CheckStyle = csCheck
              AutoAdjustColWidths = True
            end>
          ExplicitWidth = 632
          ExplicitHeight = 409
        end
      end
    end
    object tabTrackTimes: TTabSheet
      Caption = 'Track Times'
      ImageIndex = 2
      inline frameTrackTimes: TframeGrid
        Left = 0
        Top = 57
        Width = 632
        Height = 393
        Align = alClient
        TabOrder = 0
        ExplicitTop = 57
        ExplicitWidth = 632
        ExplicitHeight = 393
        inherited Panel: TPanel
          Top = 352
          Width = 632
          StyleElements = [seFont, seClient, seBorder]
          ExplicitTop = 352
          ExplicitWidth = 632
          inherited lbNumber: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited sbAdd: TSpeedButton
            Left = 331
            ExplicitLeft = 331
          end
          inherited sbInsert: TSpeedButton
            Left = 392
            ExplicitLeft = 392
          end
          inherited sbDelete: TSpeedButton
            Left = 453
            ExplicitLeft = 453
          end
          inherited seNumber: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited Grid: TRbwDataGrid4
          Width = 632
          Height = 352
          ExplicitWidth = 632
          ExplicitHeight = 352
        end
      end
      object pnlTrackTime: TPanel
        Left = 0
        Top = 0
        Width = 632
        Height = 57
        Align = alTop
        TabOrder = 1
        object lblTrackTime: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 624
          Height = 49
          Align = alClient
          Caption = 
            'Tracking times can be specified as specific times or by specific' +
            ' period. '
          WordWrap = True
          ExplicitWidth = 370
          ExplicitHeight = 15
        end
      end
    end
    object tabTrackByStressPeriod: TTabSheet
      Caption = 'Track By Stress Period'
      ImageIndex = 3
      object pnlTrackPeriodData: TPanel
        Left = 0
        Top = 0
        Width = 632
        Height = 57
        Align = alTop
        TabOrder = 0
        object lblTrackPeriodData: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 624
          Height = 49
          Align = alClient
          Caption = 
            'Tracking times can be specified as specific times or by specific' +
            ' period. '
          WordWrap = True
          ExplicitWidth = 370
          ExplicitHeight = 15
        end
      end
      inline frameReleasePeriodData: TframeGrid
        Left = 0
        Top = 57
        Width = 632
        Height = 393
        Align = alClient
        TabOrder = 1
        ExplicitTop = 57
        ExplicitWidth = 632
        ExplicitHeight = 393
        inherited Panel: TPanel
          Top = 352
          Width = 632
          StyleElements = [seFont, seClient, seBorder]
          ExplicitTop = 352
          ExplicitWidth = 632
          inherited lbNumber: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited sbAdd: TSpeedButton
            Left = 331
            ExplicitLeft = 181
          end
          inherited sbInsert: TSpeedButton
            Left = 392
            ExplicitLeft = 215
          end
          inherited sbDelete: TSpeedButton
            Left = 453
            ExplicitLeft = 249
          end
          inherited seNumber: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited Grid: TRbwDataGrid4
          Width = 632
          Height = 352
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
          ExplicitTop = -2
          ExplicitWidth = 632
          ExplicitHeight = 352
        end
      end
    end
  end
end
