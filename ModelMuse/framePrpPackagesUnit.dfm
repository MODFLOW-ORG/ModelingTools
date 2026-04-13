object framePrpMultiplePackages: TframePrpMultiplePackages
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object pcPrt: TPageControl
    Left = 32
    Top = 183
    Width = 473
    Height = 266
    ActivePage = tabPrpPackages
    TabOrder = 0
    object tabOptions: TTabSheet
      Caption = 'Options'
    end
    object tabPrpPackages: TTabSheet
      Caption = 'PRP Packages'
      ImageIndex = 1
      inline framePrpPackages: TframeGrid
        Left = 0
        Top = 0
        Width = 465
        Height = 236
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 112
        ExplicitTop = 64
        inherited Panel: TPanel
          Top = 195
          Width = 465
          StyleElements = [seFont, seClient, seBorder]
          inherited lbNumber: TLabel
            Width = 184
            Caption = 'Number of PRP packages in model'
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 184
          end
          inherited sbAdd: TSpeedButton
            Left = 241
          end
          inherited sbInsert: TSpeedButton
            Left = 286
          end
          inherited sbDelete: TSpeedButton
            Left = 330
          end
          inherited seNumber: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited Grid: TRbwDataGrid4
          Width = 465
          Height = 195
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
        end
      end
    end
    object tabTrackTimes: TTabSheet
      Caption = 'Track Times'
      ImageIndex = 2
    end
  end
end
