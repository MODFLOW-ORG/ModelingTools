inherited frameScreenObjectSwr: TframeScreenObjectSwr
  inherited pnlBottom: TPanel
    Top = 232
    Height = 84
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 232
    ExplicitWidth = 444
    ExplicitHeight = 84
    DesignSize = (
      541
      84)
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
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited btnDelete: TBitBtn
      ExplicitLeft = 356
    end
    inherited btnInsert: TBitBtn
      ExplicitLeft = 272
    end
    object comboFormulaInterp: TComboBox
      Left = 262
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
    ExplicitWidth = 444
    inherited pnlCaption: TPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 442
    end
  end
  inherited pnlGrid: TPanel
    Height = 207
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 444
    ExplicitHeight = 207
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
      Height = 155
      ExplicitHeight = 155
    end
  end
end
