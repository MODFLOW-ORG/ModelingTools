inherited framePackageTransientLayerChoice: TframePackageTransientLayerChoice
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnLayerOption: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited lblLayerOption: TLabel
      Width = 84
      Caption = 'Location option'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 84
    end
    inherited comboLayerOption: TComboBox
      StyleElements = [seFont, seClient, seBorder]
      OnChange = comboLayerOptionChange
    end
    object cbTimeVaryingLayers: TCheckBox
      Left = 358
      Top = 5
      Width = 235
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Time varying layers'
      Enabled = False
      TabOrder = 1
    end
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
        Control = cbTimeVaryingLayers
      end
      item
        Control = comboLayerOption
      end
      item
        Control = lblLayerOption
      end>
  end
end
