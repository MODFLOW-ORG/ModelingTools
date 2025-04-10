inherited framePackageRes: TframePackageRes
  Height = 236
  ExplicitHeight = 236
  DesignSize = (
    477
    236)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Anchors = [akLeft, akTop, akRight, akBottom]
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnLayerOption: TPanel
    Height = 76
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 76
    inherited lblLayerOption: TLabel
      Top = 9
      Width = 132
      Caption = 'Reservoir location option'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitTop = 9
      ExplicitWidth = 132
    end
    object lblTableSize: TLabel [1]
      Left = 72
      Top = 51
      Width = 358
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 
        'Number of values in printed table of stage, volume, and area (NP' +
        'TS)'
      Enabled = False
    end
    inherited comboLayerOption: TComboBox
      StyleElements = [seFont, seClient, seBorder]
      OnChange = nil
    end
    inherited cbTimeVaryingLayers: TCheckBox
      Visible = False
    end
    object cbPrintStage: TCheckBox
      Left = 16
      Top = 28
      Width = 446
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 
        'Print reservoir stage, area, and volume at each time step (IRESP' +
        'T)'
      Enabled = False
      TabOrder = 2
    end
    object seTableSize: TJvSpinEdit
      Left = 16
      Top = 48
      Width = 50
      Height = 23
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      CheckMinValue = True
      ButtonKind = bkClassic
      Value = 15.000000000000000000
      Enabled = False
      TabOrder = 3
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
      end
      item
        Control = cbPrintStage
      end
      item
        Control = seTableSize
      end
      item
        Control = lblTableSize
      end>
  end
end
