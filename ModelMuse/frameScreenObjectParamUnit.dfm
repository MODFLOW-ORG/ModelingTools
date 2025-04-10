inherited frameScreenObjectParam: TframeScreenObjectParam
  object splitHorizontal: TSplitter [0]
    Left = 0
    Top = 89
    Width = 541
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -239
    ExplicitTop = 129
    ExplicitWidth = 559
  end
  inherited pnlBottom: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 541
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    object lblTimeSeriesInterpolation: TLabel [1]
      Left = 88
      Top = 8
      Width = 131
      Height = 15
      Caption = 'Time-series interpolation'
      Visible = False
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited btnDelete: TBitBtn
      ExplicitLeft = 453
    end
    inherited btnInsert: TBitBtn
      ExplicitLeft = 369
    end
    object comboTimeSeriesInterpolation: TComboBox
      Left = 64
      Top = 16
      Width = 145
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'STEPWISE'
      Visible = False
      Items.Strings = (
        'STEPWISE'
        'LINEAR'
        'LINEAR-END')
    end
  end
  inherited pnlTop: TPanel
    Height = 89
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 541
    ExplicitHeight = 89
    inherited pnlCaption: TPanel
      Height = 24
      Align = alTop
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 539
      ExplicitHeight = 24
    end
    object clbParameters: TJvxCheckListBox
      Left = 1
      Top = 25
      Width = 539
      Height = 63
      AllowGrayed = True
      Align = alClient
      AutoScroll = False
      Columns = 4
      ItemHeight = 15
      TabOrder = 1
      OnStateChange = clbParametersStateChange
      OnClickCheck = clbParametersClickCheck
      ExplicitWidth = 318
      InternalVersion = 202
    end
  end
  inherited pnlGrid: TPanel
    Top = 92
    Height = 178
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 92
    ExplicitWidth = 541
    ExplicitHeight = 178
    inherited pnlEditGrid: TPanel
      StyleElements = [seFont, seClient, seBorder]
      inherited lblFormula: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited rdeFormula: TRbwDataEntry
        Top = 22
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 22
      end
    end
    inherited rdgModflowBoundary: TRbwDataGrid4
      Height = 126
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
      ExplicitHeight = 126
    end
  end
end
