inherited framePackageUseMultiplier: TframePackageUseMultiplier
  Height = 179
  ExplicitHeight = 179
  DesignSize = (
    422
    179)
  inherited lblComments: TLabel
    Top = 57
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 57
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Top = 78
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 78
  end
  object cbUseMultiplierMODFLOW6: TCheckBox [3]
    Left = 16
    Top = 33
    Width = 273
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Use Multiplier (MODFLOW 6)'
    Enabled = False
    TabOrder = 1
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
        Control = cbUseMultiplierMODFLOW6
      end>
  end
end
