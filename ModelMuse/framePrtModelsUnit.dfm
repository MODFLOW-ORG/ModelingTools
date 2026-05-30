object framePrtModels: TframePrtModels
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  inline framePrtModelsGrid: TframeGrid
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 640
    ExplicitHeight = 480
    inherited Panel: TPanel
      Top = 439
      Width = 640
      StyleElements = [seFont, seClient, seBorder]
      ExplicitTop = 439
      ExplicitWidth = 640
      inherited lbNumber: TLabel
        Width = 123
        Caption = 'Number of PRT models'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 123
      end
      inherited sbAdd: TSpeedButton
        Left = 336
        ExplicitLeft = 336
      end
      inherited sbInsert: TSpeedButton
        Left = 397
        ExplicitLeft = 397
      end
      inherited sbDelete: TSpeedButton
        Left = 459
        ExplicitLeft = 459
      end
      inherited seNumber: TJvSpinEdit
        Left = 6
        Top = 8
        StyleElements = [seFont, seClient, seBorder]
        OnChange = framePrtModelsGridseNumberChange
        ExplicitLeft = 6
        ExplicitTop = 8
      end
    end
    inherited Grid: TRbwDataGrid4
      Width = 640
      Height = 439
      ColCount = 2
      OnSetEditText = framePrtModelsGridGridSetEditText
      OnBeforeDrawCell = framePrtModelsGridGridBeforeDrawCell
      OnEndUpdate = framePrtModelsGridGridEndUpdate
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
          WordWrapCaptions = False
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
      ExplicitWidth = 640
      ExplicitHeight = 439
    end
  end
end
