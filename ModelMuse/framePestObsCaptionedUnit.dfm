inherited framePestObsCaptioned: TframePestObsCaptioned
  inherited grpDirectObs: TGroupBox
    Top = 41
    Height = 202
    ExplicitTop = 40
    ExplicitHeight = 202
    inherited frameObservations: TframeGrid
      Height = 183
      ExplicitHeight = 184
      inherited Panel: TPanel
        Top = 151
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 146
        inherited lbNumber: TLabel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited seNumber: TJvSpinEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
      inherited Grid: TRbwDataGrid4
        Height = 151
        ExplicitHeight = 151
      end
    end
  end
  inherited grpObsComparisons: TGroupBox
    inherited frameObsComparisons: TframeGrid
      inherited Panel: TPanel
        StyleElements = [seFont, seClient, seBorder]
        inherited lbNumber: TLabel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited seNumber: TJvSpinEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
  end
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 41
    Align = alTop
    TabOrder = 2
    ExplicitLeft = 312
    ExplicitTop = 8
    ExplicitWidth = 185
  end
end
