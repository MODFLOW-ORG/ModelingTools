inherited framePackageMvr: TframePackageMvr
  Height = 218
  ExplicitHeight = 218
  DesignSize = (
    422
    218)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    StyleElements = [seFont, seClient, seBorder]
  end
  object cbSaveBudget: TCheckBox [3]
    Left = 16
    Top = 168
    Width = 353
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save MVR budget to a binary file'
    Enabled = False
    TabOrder = 1
  end
  object chSaveCsv: TCheckBox [4]
    Left = 16
    Top = 191
    Width = 353
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save MVR budget to a CSV file'
    Enabled = False
    TabOrder = 2
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
        Control = cbSaveBudget
      end
      item
        Control = chSaveCsv
      end>
  end
end
