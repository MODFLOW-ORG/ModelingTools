inherited framePackageLayerChoice: TframePackageLayerChoice
  Width = 477
  Height = 201
  ExplicitWidth = 477
  ExplicitHeight = 201
  DesignSize = (
    477
    201)
  inherited lblComments: TLabel
    Top = 31
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 31
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited memoComments: TMemo
    Width = 446
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 446
  end
  object pnLayerOption: TPanel [3]
    Left = 0
    Top = 160
    Width = 477
    Height = 41
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblLayerOption: TLabel
      Left = 16
      Top = 6
      Width = 86
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Location Option'
      Enabled = False
    end
    object comboLayerOption: TComboBox
      Left = 207
      Top = 3
      Width = 145
      Height = 23
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      Enabled = False
      ItemIndex = 0
      TabOrder = 0
      Text = 'Top layer'
      Items.Strings = (
        'Top layer'
        'Specified layer'
        'Top active cell')
    end
  end
end
