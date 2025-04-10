inherited framePackageGNC: TframePackageGNC
  Height = 234
  ExplicitHeight = 234
  DesignSize = (
    422
    234)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    StyleElements = [seFont, seClient, seBorder]
  end
  object rgFormulation: TRadioGroup [3]
    Left = 16
    Top = 151
    Width = 391
    Height = 74
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Formulation'
    Enabled = False
    Items.Strings = (
      'Implicit'
      'Explicit')
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
        Control = rgFormulation
      end>
  end
end
