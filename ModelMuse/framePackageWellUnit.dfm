inherited framePackageWell: TframePackageWell
  Width = 429
  Height = 207
  ExplicitWidth = 429
  ExplicitHeight = 207
  DesignSize = (
    429
    207)
  inherited lblComments: TLabel
    Top = 106
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 106
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  object lblPhiRamp: TLabel [2]
    Left = 104
    Top = 34
    Width = 292
    Height = 15
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Cell adjustment fraction (PHIRAMP - MODFLOW-NWT)'
  end
  inherited memoComments: TMemo
    Top = 125
    Width = 398
    Height = 71
    TabOrder = 2
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 125
    ExplicitWidth = 398
    ExplicitHeight = 71
  end
  object rdePhiRamp: TRbwDataEntry [4]
    Left = 16
    Top = 31
    Width = 73
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    Enabled = False
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMax = True
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cbTabfiles: TCheckBox [5]
    Left = 16
    Top = 59
    Width = 398
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Use tabfiles to define well pumpage (TABFILES) (MODFLOW-NWT 1.1)'
    Enabled = False
    TabOrder = 3
  end
  inherited cbUseMultiplierMODFLOW6: TCheckBox
    Top = 82
    ExplicitTop = 82
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
        Control = rdePhiRamp
      end
      item
        Control = cbTabfiles
      end
      item
        Control = cbUseMultiplierMODFLOW6
      end>
  end
end
