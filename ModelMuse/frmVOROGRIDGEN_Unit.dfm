inherited frmVOROGRIDGEN: TfrmVOROGRIDGEN
  Caption = 'Run VOROGRIDGEN'
  ClientHeight = 377
  ClientWidth = 865
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 881
  ExplicitHeight = 416
  TextHeight = 18
  object lblOutFileBase: TLabel
    Left = 1
    Top = 87
    Width = 410
    Height = 18
    Caption = 'Base name for VOROGRIDGEN output files (out_file_base)'
  end
  object lblMaxCentroidSeparation: TLabel
    Left = 1
    Top = 143
    Width = 396
    Height = 18
    Caption = 'Maximum centroid separation (max_centroid_separation)'
  end
  object lblMaxCells: TLabel
    Left = 1
    Top = 199
    Width = 312
    Height = 18
    Caption = 'Maximum number of cells in model (maxcells)'
  end
  object lblPolyGrowthRate: TLabel
    Left = 1
    Top = 259
    Width = 265
    Height = 18
    Caption = 'Growth rate of cells (poly_growth_rate)'
  end
  object lblNsdim: TLabel
    Left = 441
    Top = 60
    Width = 414
    Height = 18
    Caption = 'Dimension of search grid  (nsdim, odd number '#8805' 5, optional)'
  end
  object lblMaxLloyd: TLabel
    Left = 441
    Top = 116
    Width = 395
    Height = 18
    Caption = 'Maximum number of Lloyd iterations (max_lloyd, optional)'
  end
  object lblEpsLloyd: TLabel
    Left = 441
    Top = 172
    Width = 414
    Height = 18
    Caption = 'Termination criterion for Lloyd iterations (eps_lloyd, optional)'
  end
  object lblLloydFac: TLabel
    Left = 441
    Top = 228
    Width = 376
    Height = 18
    Caption = 'Damping factor for Lloyd iterations (lloyd_fac, optional)'
  end
  object lblMaxCells1: TLabel
    Left = 441
    Top = 276
    Width = 349
    Height = 18
    Caption = 'Safety factor for emplacing seeds (safety, optional)'
  end
  object lblVoroGridGen: TLabel
    Left = 1
    Top = 31
    Width = 176
    Height = 18
    Caption = 'VOROGRIDGEN location'
  end
  object jvhtlblVoroGridGet: TJvHTLabel
    Left = 8
    Top = 8
    Width = 278
    Height = 19
    Caption = 
      '<a href="https://hydrosymple.com/en/vorogridgen/">https://hydros' +
      'ymple.com/en/vorogridgen/</a>'
    SuperSubScriptRatio = 0.666666666666666600
  end
  object fedOutFileBase: TJvFilenameEdit
    Left = 1
    Top = 111
    Width = 410
    Height = 26
    TabOrder = 0
    Text = ''
  end
  object rdeCentroidSeparation: TRbwDataEntry
    Left = 1
    Top = 167
    Width = 177
    Height = 22
    TabOrder = 1
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object seMaxCells: TJvSpinEdit
    Left = 1
    Top = 223
    Width = 177
    Height = 26
    CheckMaxValue = False
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    TabOrder = 2
  end
  object rdePolyGrowthRate: TRbwDataEntry
    Left = 1
    Top = 283
    Width = 177
    Height = 22
    TabOrder = 3
    Text = '1.1'
    DataType = dtReal
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object rdeNsdim: TRbwDataEntry
    Left = 473
    Top = 84
    Width = 145
    Height = 22
    TabOrder = 4
    Text = '31'
    DataType = dtInteger
    Max = 1E18
    Min = 5.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cbNsdim: TCheckBox
    Left = 441
    Top = 88
    Width = 17
    Height = 17
    TabOrder = 5
  end
  object cbMaxLloyd: TCheckBox
    Left = 441
    Top = 144
    Width = 17
    Height = 17
    TabOrder = 6
  end
  object rdeMaxLloyd: TRbwDataEntry
    Left = 473
    Top = 140
    Width = 145
    Height = 22
    TabOrder = 7
    Text = '30'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cbEpsLloyd: TCheckBox
    Left = 441
    Top = 200
    Width = 17
    Height = 17
    TabOrder = 8
  end
  object rdeEpsLloyd: TRbwDataEntry
    Left = 473
    Top = 196
    Width = 145
    Height = 22
    TabOrder = 9
    Text = '1E-10'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cblLloydFac: TCheckBox
    Left = 441
    Top = 256
    Width = 17
    Height = 17
    TabOrder = 10
  end
  object rdeEpsLloyd1: TRbwDataEntry
    Left = 473
    Top = 252
    Width = 145
    Height = 22
    TabOrder = 11
    Text = '0.2'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMax = True
    CheckMin = True
    ChangeDisabledColor = True
  end
  object seSafety: TJvSpinEdit
    Left = 473
    Top = 300
    Width = 145
    Height = 26
    CheckMaxValue = False
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    TabOrder = 12
  end
  object cbSafety: TCheckBox
    Left = 441
    Top = 304
    Width = 17
    Height = 17
    TabOrder = 13
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 335
    Width = 865
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 14
    ExplicitTop = 558
    ExplicitWidth = 764
    DesignSize = (
      865
      42)
    object btnHelp: TBitBtn
      Left = 594
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 493
    end
    object btnOK: TBitBtn
      Left = 683
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnOKClick
      ExplicitLeft = 582
    end
    object btnCancel: TBitBtn
      Left = 772
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
      ExplicitLeft = 671
    end
  end
  object fedVorogridGen: TJvFilenameEdit
    Left = 1
    Top = 55
    Width = 410
    Height = 26
    Filter = 'Executables (*.exe)|*.exe'
    TabOrder = 15
    Text = 'fedVorogridGen'
  end
end
