inherited frmVOROGRIDGEN: TfrmVOROGRIDGEN
  Caption = 'Run VOROGRIDGEN'
  ClientHeight = 600
  StyleElements = [seFont, seClient, seBorder]
  ExplicitHeight = 639
  TextHeight = 18
  object lblOutFileBase: TLabel
    Left = 8
    Top = 64
    Width = 410
    Height = 18
    Caption = 'Base name for VOROGRIDGEN output files (out_file_base)'
  end
  object lblMaxCentroidSeparation: TLabel
    Left = 8
    Top = 120
    Width = 396
    Height = 18
    Caption = 'Maximum centroid separation (max_centroid_separation)'
  end
  object lblMaxCells: TLabel
    Left = 8
    Top = 176
    Width = 312
    Height = 18
    Caption = 'Maximum number of cells in model (maxcells)'
  end
  object lblPolyGrowthRate: TLabel
    Left = 8
    Top = 236
    Width = 265
    Height = 18
    Caption = 'Growth rate of cells (poly_growth_rate)'
  end
  object lblNsdim: TLabel
    Left = 8
    Top = 288
    Width = 414
    Height = 18
    Caption = 'Dimension of search grid  (nsdim, odd number '#8805' 5, optional)'
  end
  object lblMaxLloyd: TLabel
    Left = 8
    Top = 344
    Width = 395
    Height = 18
    Caption = 'Maximum number of Lloyd iterations (max_lloyd, optional)'
  end
  object lblEpsLloyd: TLabel
    Left = 8
    Top = 400
    Width = 414
    Height = 18
    Caption = 'Termination criterion for Lloyd iterations (eps_lloyd, optional)'
  end
  object lblLloydFac: TLabel
    Left = 8
    Top = 456
    Width = 376
    Height = 18
    Caption = 'Damping factor for Lloyd iterations (lloyd_fac, optional)'
  end
  object lblMaxCells1: TLabel
    Left = 8
    Top = 504
    Width = 349
    Height = 18
    Caption = 'Safety factor for emplacing seeds (safety, optional)'
  end
  object lblVoroGridGen: TLabel
    Left = 8
    Top = 8
    Width = 176
    Height = 18
    Caption = 'VOROGRIDGEN location'
  end
  object fedOutFileBase: TJvFilenameEdit
    Left = 8
    Top = 88
    Width = 748
    Height = 26
    TabOrder = 0
    Text = ''
  end
  object rdeCentroidSeparation: TRbwDataEntry
    Left = 8
    Top = 144
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
    Left = 8
    Top = 200
    Width = 177
    Height = 26
    CheckMaxValue = False
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    TabOrder = 2
  end
  object rdePolyGrowthRate: TRbwDataEntry
    Left = 8
    Top = 260
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
    Left = 40
    Top = 312
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
    Left = 8
    Top = 316
    Width = 17
    Height = 17
    TabOrder = 5
  end
  object cbMaxLloyd: TCheckBox
    Left = 8
    Top = 372
    Width = 17
    Height = 17
    TabOrder = 6
  end
  object rdeMaxLloyd: TRbwDataEntry
    Left = 40
    Top = 368
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
    Left = 8
    Top = 428
    Width = 17
    Height = 17
    TabOrder = 8
  end
  object rdeEpsLloyd: TRbwDataEntry
    Left = 40
    Top = 424
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
    Left = 8
    Top = 484
    Width = 17
    Height = 17
    TabOrder = 10
  end
  object rdeEpsLloyd1: TRbwDataEntry
    Left = 40
    Top = 480
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
    Left = 40
    Top = 528
    Width = 145
    Height = 26
    CheckMaxValue = False
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    TabOrder = 12
  end
  object cbSafety: TCheckBox
    Left = 8
    Top = 532
    Width = 17
    Height = 17
    TabOrder = 13
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 558
    Width = 764
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 14
    ExplicitTop = 513
    DesignSize = (
      764
      42)
    object btnHelp: TBitBtn
      Left = 493
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 0
    end
    object btnOK: TBitBtn
      Left = 582
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      Left = 671
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
    end
  end
  object fedVorogridGen: TJvFilenameEdit
    Left = 8
    Top = 32
    Width = 748
    Height = 26
    Filter = 'Executables (*.exe)|*.exe'
    TabOrder = 15
    Text = 'fedVorogridGen'
  end
end
