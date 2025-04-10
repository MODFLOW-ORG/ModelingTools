inherited frameScreenObjectFhbFlow: TframeScreenObjectFhbFlow
  inherited pnlBottom: TPanel
    Top = 240
    Height = 76
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 240
    ExplicitHeight = 76
    DesignSize = (
      541
      76)
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    object lblConductanceInterpretation: TLabel [1]
      Left = 8
      Top = 51
      Width = 123
      Height = 15
      Caption = 'Flow rate interpretation'
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    object comboFormulaInterp: TComboBox
      Left = 174
      Top = 48
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 3
      OnChange = comboFormulaInterpChange
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
    Height = 215
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 215
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
      Height = 163
      ExplicitHeight = 163
    end
  end
end
