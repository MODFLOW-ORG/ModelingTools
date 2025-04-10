inherited framePackageFmi: TframePackageFmi
  Width = 476
  Height = 386
  ExplicitWidth = 476
  ExplicitHeight = 386
  DesignSize = (
    476
    386)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Width = 445
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 445
  end
  object cbFlowImbalance: TCheckBox [3]
    Left = 16
    Top = 284
    Width = 445
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Use flow imbalance correction (FLOW_IMBALANCE_CORRECTION)'
    Enabled = False
    TabOrder = 1
  end
  object rgSimulationChoice: TRadioGroup [4]
    Left = 16
    Top = 157
    Width = 445
    Height = 121
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Simulation choice (FMI6)'
    Enabled = False
    Items.Strings = (
      '(1) Flow and solute transport in the same simulation'
      
        '(2) Separate flow simulation and separate simulations for each c' +
        'hemical species')
    TabOrder = 2
    WordWrap = True
    OnClick = rcSelectionControllerEnabledChange
  end
  inherited rcSelectionController: TRbwController
    ControlList = <
      item
        Control = lblComments
      end
      item
        Control = memoComments
      end
      item
        Control = rgSimulationChoice
      end>
    OnEnabledChange = rcSelectionControllerEnabledChange
  end
end
