inherited framePackageStr: TframePackageStr
  Height = 215
  ExplicitHeight = 215
  DesignSize = (
    422
    215)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    StyleElements = [seFont, seClient, seBorder]
  end
  object cbCalculateStage: TCheckBox [3]
    Left = 16
    Top = 157
    Width = 273
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Calculate stage (ICALC)'
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
        Control = cbCalculateStage
      end>
  end
end
