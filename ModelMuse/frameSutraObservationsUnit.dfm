inherited frameSutraObservations: TframeSutraObservations
  Height = 281
  ExplicitHeight = 281
  inherited pnlBottom: TPanel
    Top = 235
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 235
    ExplicitWidth = 347
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited seNumberOfTimes: TJvSpinEdit
      Left = 9
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 9
    end
    inherited btnDelete: TBitBtn
      ExplicitLeft = 263
    end
    inherited btnInsert: TBitBtn
      ExplicitLeft = 175
    end
  end
  inherited pnlGrid: TPanel
    Top = 193
    Height = 42
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 193
    ExplicitWidth = 347
    ExplicitHeight = 42
    inherited rdgSutraFeature: TRbwDataGrid4
      Height = 40
      ColCount = 1
      OnSetEditText = rdgSutraFeatureSetEditText
      OnEndUpdate = rdgSutraFeatureEndUpdate
      Columns = <
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
      ExplicitHeight = 40
      ColWidths = (
        64)
    end
  end
  inherited pnlTop: TPanel
    Height = 193
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 347
    ExplicitHeight = 193
    DesignSize = (
      565
      193)
    inherited lblSchedule: TLabel
      Width = 104
      Caption = 'Schedule (OBSSCH)'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 104
    end
    object lblObservationFormat: TLabel [1]
      Left = 5
      Top = 131
      Width = 159
      Height = 15
      Caption = 'Observation format (OBSFMT)'
    end
    object lblName: TLabel [2]
      Left = 5
      Top = 30
      Width = 93
      Height = 15
      Caption = 'Name (OBSNAM)'
    end
    inherited pnlCaption: TPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 345
    end
    inherited comboSchedule: TComboBox
      TabOrder = 2
      StyleElements = [seFont, seClient, seBorder]
    end
    object comboObservationFormat: TComboBox
      Left = 5
      Top = 151
      Width = 551
      Height = 23
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnChange = comboObservationFormatChange
      Items.Strings = (
        'Multiple observations per line (OBS)'
        'One observation per line (OBC)')
      ExplicitWidth = 333
    end
    object edName: TEdit
      Left = 5
      Top = 52
      Width = 551
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 40
      TabOrder = 1
      OnChange = edNameChange
      OnExit = edNameExit
      ExplicitWidth = 333
    end
  end
end
