inherited framePackageTvs: TframePackageTvs
  Height = 256
  ExplicitHeight = 256
  DesignSize = (
    422
    256)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Height = 139
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 139
  end
  object cbEnableStorageChangeIntegration: TCheckBox [3]
    Left = 16
    Top = 208
    Width = 391
    Height = 45
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 
      'Enable storage change integration (Inverse of DISABLE_STORAGE_CH' +
      'ANGE_INTEGRATION)'
    Enabled = False
    TabOrder = 1
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
        Control = cbEnableStorageChangeIntegration
      end>
  end
end
