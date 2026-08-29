inherited framePackageSfrMF6: TframePackageSfrMF6
  Width = 492
  Height = 489
  ExplicitWidth = 492
  ExplicitHeight = 489
  DesignSize = (
    492
    489)
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  object lblMaxIterations: TLabel [2]
    Left = 167
    Top = 325
    Width = 178
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Maximum number of streamflow iterations (maximum_iteration) '
    WordWrap = True
  end
  object lblMaxDepthChange: TLabel [3]
    Left = 167
    Top = 373
    Width = 165
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Stream depth  closure criterion (maximum_depth_change)'
    WordWrap = True
  end
  object lblPicard: TLabel [4]
    Left = 167
    Top = 289
    Width = 154
    Height = 45
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Maximum number of Picard iterations (maximum_picard_iterations)'
    WordWrap = True
  end
  object lblATS_COURANT: TLabel [5]
    Left = 191
    Top = 456
    Width = 277
    Height = 45
    Caption = 'Target Courant number for ATS package (lATS_COURANT)'
    WordWrap = True
  end
  inherited memoComments: TMemo
    Width = 461
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 461
  end
  object cbSaveStage: TCheckBox [7]
    Left = 16
    Top = 210
    Width = 313
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save stage (stagefile)'
    Enabled = False
    TabOrder = 2
  end
  object cbSaveBudget: TCheckBox [8]
    Left = 16
    Top = 236
    Width = 337
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save budget (budgetfile)'
    Enabled = False
    TabOrder = 3
  end
  object seMaxIterations: TJvSpinEdit [9]
    Left = 16
    Top = 330
    Width = 145
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    MaxValue = 2147483647.000000000000000000
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    Enabled = False
    TabOrder = 5
  end
  object rdeMaxDepthChange: TRbwDataEntry [10]
    Left = 16
    Top = 373
    Width = 145
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    Enabled = False
    TabOrder = 4
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cbPrintStage: TCheckBox [11]
    Left = 16
    Top = 157
    Width = 249
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Print stage (PRINT_STAGE)'
    Enabled = False
    TabOrder = 1
  end
  object cbPrintFlows: TCheckBox [12]
    Left = 16
    Top = 187
    Width = 249
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Print flows (PRINT_FLOWS)'
    Enabled = False
    TabOrder = 6
  end
  object cbPackageConvergence: TCheckBox [13]
    Left = 16
    Top = 407
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
  object sePicard: TJvSpinEdit [14]
    Left = 16
    Top = 293
    Width = 145
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    MaxValue = 2147483647.000000000000000000
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    Enabled = False
    TabOrder = 8
  end
  object cbSaveBudgetCsv: TCheckBox [15]
    Left = 16
    Top = 262
    Width = 461
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Save budget in comma-separated values file (BudgetCsv)'
    Enabled = False
    TabOrder = 9
  end
  object cbStorage: TCheckBox [16]
    Left = 16
    Top = 431
    Width = 356
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Kinematic-wave routing (STORAGE)'
    Enabled = False
    TabOrder = 10
  end
  object cbATS_COURANT_Used: TCheckBox [17]
    Left = 16
    Top = 456
    Width = 25
    Height = 17
    Enabled = False
    TabOrder = 11
    OnClick = rcSelectionControllerEnabledChange
  end
  object rdeATS_COURANT: TRbwDataEntry [18]
    Left = 40
    Top = 455
    Width = 145
    Height = 22
    Color = clBtnFace
    Enabled = False
    TabOrder = 12
    Text = '1'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
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
        Control = cbSaveBudget
      end
      item
        Control = cbSaveStage
      end
      item
        Control = rdeMaxDepthChange
      end
      item
        Control = seMaxIterations
      end
      item
        Control = cbPrintStage
      end
      item
        Control = cbPrintFlows
      end
      item
        Control = cbPackageConvergence
      end
      item
        Control = sePicard
      end
      item
        Control = cbSaveBudgetCsv
      end
      item
        Control = cbStorage
      end
      item
        Control = cbATS_COURANT_Used
      end>
    OnEnabledChange = rcSelectionControllerEnabledChange
  end
end
