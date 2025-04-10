inherited frameScreenObjectFmpPrecip: TframeScreenObjectFmpPrecip
  inherited pnlBottom: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 541
    inherited lblNumTimes: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited seNumberOfTimes: TJvSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited btnDelete: TBitBtn
      ExplicitLeft = 453
    end
    inherited btnInsert: TBitBtn
      ExplicitLeft = 369
    end
  end
  inherited pnlTop: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 541
    inherited pnlCaption: TPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 539
    end
  end
  inherited pnlGrid: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 541
    inherited pnlEditGrid: TPanel
      StyleElements = [seFont, seClient, seBorder]
      inherited lblFormula: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited rdeFormula: TRbwDataEntry
        StyleElements = [seFont, seClient, seBorder]
      end
    end
  end
end
