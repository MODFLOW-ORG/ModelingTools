inherited frameScreenObjectWel: TframeScreenObjectWel
  Height = 314
  ExplicitHeight = 314
  inherited pnlBottom: TPanel
    Top = 208
    Height = 106
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 208
    ExplicitHeight = 106
    DesignSize = (
      541
      106)
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited lblConductanceInterpretation: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    object lblTabfile: TLabel [2]
      Left = 255
      Top = 83
      Width = 34
      Height = 15
      Caption = 'Tabfile'
    end
    inherited lblTimeSeriesInterpolation: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited comboTimeSeriesInterpolation: TComboBox
      TabOrder = 5
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited comboFormulaInterp: TComboBox
      StyleElements = [seFont, seClient, seBorder]
    end
    object fedTabfile: TJvFilenameEdit
      Left = 8
      Top = 80
      Width = 241
      Height = 23
      Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
      TabOrder = 4
      Text = ''
      OnChange = fedTabfileChange
    end
  end
  inherited pnlTop: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited pnlCaption: TPanel
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited pnlGrid: TPanel
    Height = 116
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 116
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
      Height = 64
      ExplicitHeight = 64
    end
  end
end
