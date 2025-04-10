inherited framePackageRip: TframePackageRip
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Height = 59
    Anchors = [akLeft, akTop, akRight, akBottom]
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 59
  end
  object cbWritePlantGroupFlows: TCheckBox [3]
    Left = 16
    Top = 127
    Width = 273
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Caption = 'Write plant group flows (IRIPCB1)'
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
        Control = cbWritePlantGroupFlows
      end>
  end
end
