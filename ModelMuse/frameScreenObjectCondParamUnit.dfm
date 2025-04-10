inherited frameScreenObjectCondParam: TframeScreenObjectCondParam
  inherited pnlBottom: TPanel
    Top = 235
    Height = 81
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 235
    ExplicitHeight = 81
    DesignSize = (
      541
      81)
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    object lblConductanceInterpretation: TLabel [1]
      Left = 8
      Top = 51
      Width = 146
      Height = 15
      Caption = 'Conductance interpretation'
    end
    inherited lblTimeSeriesInterpolation: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited comboTimeSeriesInterpolation: TComboBox
      TabOrder = 4
      StyleElements = [seFont, seClient, seBorder]
    end
    object comboFormulaInterp: TComboBox
      Left = 174
      Top = 48
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'Calculated'
        'Direct'
        'Total per layer')
    end
  end
  inherited pnlTop: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited pnlCaption: TPanel
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited pnlGrid: TPanel
    Height = 143
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 143
    inherited pnlEditGrid: TPanel
      StyleElements = [seFont, seClient, seBorder]
      inherited lblFormula: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited rdeFormula: TRbwDataEntry
        StyleElements = [seFont, seClient, seBorder]
      end
    end
    inherited rdgModflowBoundary: TRbwDataGrid4
      Height = 91
      ExplicitHeight = 91
    end
  end
end
