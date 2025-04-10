inherited frameScreenObjectLandUseAreaFraction: TframeScreenObjectLandUseAreaFraction
  Height = 353
  ExplicitHeight = 353
  inherited pnlBottom: TPanel
    Top = 307
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 307
    ExplicitWidth = 406
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited btnDelete: TBitBtn
      ExplicitLeft = 318
    end
    inherited btnInsert: TBitBtn
      ExplicitLeft = 234
    end
  end
  inherited pnlTop: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 406
    inherited pnlCaption: TPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 404
    end
  end
  inherited pnlGrid: TPanel
    Height = 282
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 406
    ExplicitHeight = 282
    inherited pnlEditGrid: TPanel
      StyleElements = [seFont, seClient, seBorder]
      inherited lblFormula: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited rdeFormula: TRbwDataEntry
        StyleElements = [seFont, seClient, seBorder]
      end
    end
    inherited rdgModflowBoundary: TRbwDataGrid4
      Height = 230
      ExplicitHeight = 230
    end
  end
end
