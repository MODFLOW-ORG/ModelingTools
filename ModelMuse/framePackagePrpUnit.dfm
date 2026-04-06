inherited framePackagePrp: TframePackagePrp
  Width = 577
  Height = 513
  ExplicitWidth = 577
  ExplicitHeight = 513
  inherited lblComments: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited lblPackage: TLabel
    StyleElements = [seFont, seClient, seBorder]
  end
  object LblSolverTolerance: TLabel [2]
    Left = 25
    Top = 161
    Width = 228
    Height = 15
    Caption = 'Solver Tolerance (EXIT_SOLVE_TOLERANCE)'
  end
  object lblPrpTrack: TLabel [3]
    Left = 25
    Top = 210
    Width = 69
    Height = 15
    Caption = 'Track Output'
  end
  inherited memoComments: TMemo
    Width = 546
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 546
  end
  object RdeSolverTolerance: TRbwDataEntry [5]
    Left = 25
    Top = 182
    Width = 145
    Height = 22
    TabOrder = 1
    Text = 'RdeSolverTolerance'
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
  object cbEXTEND_TRACKING: TCheckBox [6]
    Left = 360
    Top = 224
    Width = 153
    Height = 17
    Caption = 'EXTEND_TRACKING'
    TabOrder = 2
  end
  object ComboBox1: TComboBox [7]
    Left = 25
    Top = 231
    Width = 145
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'None'
    Items.Strings = (
      'None'
      'Binary'
      'CSV (Comma-Separated Values)'
      'Binary and CSV')
  end
  inline frameStopTime: TframeOptionalValue [8]
    Left = 0
    Top = 260
    Width = 176
    Height = 56
    TabOrder = 4
    ExplicitTop = 260
    inherited LblVariableLabel: TLabel
      Width = 120
      Caption = 'Stop Time (STOPTIME)'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 120
    end
    inherited RdeValue: TRbwDataEntry
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inline frameStopTravelTime: TframeOptionalValue
    Left = 0
    Top = 322
    Width = 217
    Height = 56
    TabOrder = 5
    ExplicitTop = 322
    ExplicitWidth = 217
    inherited LblVariableLabel: TLabel
      Width = 193
      Caption = 'Stop Travel Time (STOPTRAVELTIME)'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 193
    end
    inherited RdeValue: TRbwDataEntry
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  object cbSTOP_AT_WEAK_SINK: TCheckBox
    Left = 360
    Top = 260
    Width = 153
    Height = 17
    Caption = 'STOP_AT_WEAK_SINK'
    TabOrder = 6
  end
  inline frameStopZone: TframeOptionalValue
    Left = 0
    Top = 384
    Width = 217
    Height = 56
    TabOrder = 7
    ExplicitTop = 384
    ExplicitWidth = 217
    inherited LblVariableLabel: TLabel
      Left = 25
      Width = 125
      Caption = 'Stop zone (ISTOPZONE)'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 25
      ExplicitWidth = 125
    end
    inherited RdeValue: TRbwDataEntry
      StyleElements = [seFont, seClient, seBorder]
      DataType = dtInteger
    end
  end
  object cbDRAPE: TCheckBox
    Left = 360
    Top = 299
    Width = 153
    Height = 17
    Caption = 'DRAPE'
    TabOrder = 8
  end
  inherited rcSelectionController: TRbwController
    Left = 256
    Top = 32
  end
end
