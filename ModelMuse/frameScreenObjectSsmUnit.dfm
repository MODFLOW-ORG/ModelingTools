inherited frameScreenObjectSsm: TframeScreenObjectSsm
  inherited pnlBottom: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited pnlTop: TPanel
    Height = 76
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 76
    inherited pnlCaption: TPanel
      Align = alTop
      StyleElements = [seFont, seClient, seBorder]
    end
    object cbSpecifiedConcentration: TCheckBox
      Left = 8
      Top = 31
      Width = 306
      Height = 17
      Caption = 'Specified concentration (ITYPE = -1)'
      TabOrder = 1
      OnClick = cbSpecifiedConcentrationClick
    end
    object cbMassLoading: TCheckBox
      Left = 8
      Top = 54
      Width = 297
      Height = 17
      Caption = 'Mass-loading (ITYPE = 15)'
      TabOrder = 2
      OnClick = cbMassLoadingClick
    end
  end
  inherited pnlGrid: TPanel
    Top = 76
    Height = 194
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 76
    ExplicitHeight = 194
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
      Height = 142
      ExplicitHeight = 142
    end
  end
end
