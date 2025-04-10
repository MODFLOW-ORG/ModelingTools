inherited frameMt3dLktPkg: TframeMt3dLktPkg
  Height = 244
  ExplicitHeight = 244
  DesignSize = (
    422
    244)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    StyleElements = [seFont, seClient, seBorder]
  end
  object cbSoluteEvap: TCheckBox [3]
    Left = 16
    Top = 157
    Width = 391
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Solute leaves system in evaporation (IETLAK)'
    Enabled = False
    TabOrder = 1
  end
  object cbPrintLakeBudget: TCheckBox [4]
    Left = 16
    Top = 184
    Width = 391
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 
      'Print transport information for each lake to .lktobs file (ICBCL' +
      'K)'
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
        Control = cbSoluteEvap
      end
      item
        Control = cbPrintLakeBudget
      end>
  end
end
