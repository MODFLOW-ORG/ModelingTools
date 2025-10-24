inherited frameMawGwtConcentrations: TframeMawGwtConcentrations
  inherited rdgConcentrations: TRbwDataGrid4
    FixedCols = 0
    AutoMultiEdit = True
    AutoDistributeText = True
    AutoIncreaseRowCount = True
  end
  inherited pnl1: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited lblInitialConcentration: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited btnedInitialConcentration: TssButtonEdit
      Height = 23
      ExplicitHeight = 23
    end
  end
end
