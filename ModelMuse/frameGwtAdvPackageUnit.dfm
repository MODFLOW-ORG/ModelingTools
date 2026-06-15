inherited frameGwtAdvPackage: TframeGwtAdvPackage
  Width = 453
  Height = 375
  ExplicitWidth = 453
  ExplicitHeight = 375
  DesignSize = (
    453
    375)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  object lblAdePercel: TLabel [2]
    Left = 167
    Top = 283
    Width = 141
    Height = 45
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Fractional cell distance for adaptive time stepping (ATS_PERCEL)'
    WordWrap = True
  end
  inherited memoComments: TMemo
    Width = 422
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 422
  end
  object rgScheme: TRadioGroup [4]
    Left = 16
    Top = 157
    Width = 422
    Height = 105
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Advection Scheme'
    Enabled = False
    ItemIndex = 0
    Items.Strings = (
      'Upstream'
      'Central (rarely used)'
      'Total Variation Diminishing (TVD)'
      'Unstructured Total Variation Diminishing (UTVD)')
    TabOrder = 1
  end
  object rdeAdePercel: TRbwDataEntry [5]
    Left = 16
    Top = 280
    Width = 145
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    Enabled = False
    TabOrder = 2
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMax = True
    CheckMin = True
    ChangeDisabledColor = True
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
        Control = rgScheme
      end
      item
        Control = rdeAdePercel
      end>
  end
end
