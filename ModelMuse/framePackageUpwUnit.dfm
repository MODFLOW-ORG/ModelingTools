inherited framePackageUpw: TframePackageUpw
  Height = 219
  ExplicitHeight = 219
  DesignSize = (
    422
    219)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    StyleElements = [seFont, seClient, seBorder]
  end
  object cbPrintHDRY: TCheckBox [3]
    Left = 16
    Top = 164
    Width = 285
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Print HDRY in results for dry cells (IPHDRY)'
    Enabled = False
    TabOrder = 1
  end
  object cbNoParCheck: TCheckBox [4]
    Left = 16
    Top = 187
    Width = 121
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'cbNoParCheck'
    Enabled = False
    TabOrder = 2
    WordWrap = True
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
        Control = cbPrintHDRY
      end
      item
        Control = cbNoParCheck
      end>
  end
end
