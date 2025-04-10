inherited framePkgHydmod: TframePkgHydmod
  Height = 209
  ExplicitHeight = 209
  DesignSize = (
    422
    209)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  object lblHYDNOH: TLabel [2]
    Left = 16
    Top = 157
    Width = 307
    Height = 15
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Caption = 'Value printed when no value can be computed (HYDNOH)'
    Enabled = False
  end
  inherited memoComments: TMemo
    Anchors = [akLeft, akTop, akRight, akBottom]
    StyleElements = [seFont, seClient, seBorder]
  end
  object rdeHYDNOH: TRbwDataEntry [4]
    Left = 16
    Top = 176
    Width = 145
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Color = clBtnFace
    Enabled = False
    TabOrder = 1
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
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
        Control = lblHYDNOH
      end
      item
        Control = rdeHYDNOH
      end>
  end
end
