inherited framePackageUzfMf6: TframePackageUzfMf6
  Width = 595
  Height = 526
  ExplicitWidth = 595
  ExplicitHeight = 526
  DesignSize = (
    595
    526)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  object lblNumberOfTrailingWaves: TLabel [2]
    Left = 16
    Top = 128
    Width = 203
    Height = 15
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Number of trailing waves (ntrailwaves)'
    Enabled = False
  end
  object lblNumberOfWaveSets: TLabel [3]
    Left = 16
    Top = 175
    Width = 176
    Height = 15
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Number of wave sets (nwavesets)'
    Enabled = False
  end
  inherited memoComments: TMemo
    Width = 285
    Height = 60
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 285
    ExplicitHeight = 60
  end
  object rgEvapotranspiration: TRadioGroup [5]
    Left = 16
    Top = 237
    Width = 564
    Height = 172
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Evapotranspiration (ET)'
    Enabled = False
    Items.Strings = (
      'Don'#39't simulate ET'
      'Simuate ET only in unsaturated zone (SIMULATE_ET)'
      
        'Simulate unsaturated ET and linear saturated ET (SIMULATE_ET and' +
        ' LINEAR_GWET)'
      
        'Simulate unsaturated ET and squared saturated ET (SIMULATE_ET an' +
        'd SQUARE_GWET)')
    TabOrder = 1
    WordWrap = True
    OnClick = rgEvapotranspirationClick
  end
  object rgUnsatEt: TRadioGroup [6]
    Left = 16
    Top = 415
    Width = 564
    Height = 66
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Unsaturated ET method'
    Enabled = False
    Items.Strings = (
      'Calculate based on water content (UNSAT ETWC)'
      'Calculate based on capillary pressure (UNSAT ETAE)')
    TabOrder = 2
  end
  object cbSeepage: TCheckBox [7]
    Left = 323
    Top = 72
    Width = 257
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Simulate groundwater seepage (SIMULATE_GWSEEP)'
    Enabled = False
    TabOrder = 3
    WordWrap = True
  end
  object cbSaveBudget: TCheckBox [8]
    Left = 323
    Top = 114
    Width = 257
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save binary UZF budget file (.uzf_budget)'
    Enabled = False
    TabOrder = 4
    WordWrap = True
  end
  object rdeNumberOfTrailingWaves: TRbwDataEntry [9]
    Left = 16
    Top = 147
    Width = 145
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    Enabled = False
    TabOrder = 5
    Text = '7'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object rdeNumberOfWaveSets: TRbwDataEntry [10]
    Left = 16
    Top = 194
    Width = 145
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    Enabled = False
    TabOrder = 6
    Text = '40'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cbPackageConvergence: TCheckBox [11]
    Left = 16
    Top = 487
    Width = 455
    Height = 18
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Write package convergence (PACKAGE_CONVERGENCE)'
    Enabled = False
    TabOrder = 7
  end
  object cbBudgetCsv: TCheckBox [12]
    Left = 323
    Top = 158
    Width = 222
    Height = 35
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save text UZF budget file (.uzf_budget.csv)'
    Enabled = False
    TabOrder = 8
    WordWrap = True
  end
  object cbSaveWaterContent: TCheckBox [13]
    Left = 323
    Top = 198
    Width = 257
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save binary water content (WATER_CONTENT)'
    Enabled = False
    TabOrder = 9
    WordWrap = True
  end
  object cbUseMultiplierMODFLOW6: TCheckBox [14]
    Left = 323
    Top = 39
    Width = 273
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Use Multiplier (MODFLOW 6)'
    Enabled = False
    TabOrder = 10
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
        Control = rgEvapotranspiration
      end
      item
        Control = cbSeepage
      end
      item
        Control = cbSaveBudget
      end
      item
        Control = lblNumberOfTrailingWaves
      end
      item
        Control = rdeNumberOfTrailingWaves
      end
      item
        Control = lblNumberOfWaveSets
      end
      item
        Control = rdeNumberOfWaveSets
      end
      item
        Control = cbPackageConvergence
      end
      item
        Control = cbBudgetCsv
      end
      item
        Control = cbSaveWaterContent
      end
      item
        Control = cbUseMultiplierMODFLOW6
      end>
    OnEnabledChange = rcSelectionControllerEnabledChange
  end
end
