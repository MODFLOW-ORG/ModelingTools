inherited frmPrtChoices: TfrmPrtChoices
  Caption = 'PRT Choices'
  ClientWidth = 414
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 430
  TextHeight = 18
  object pnlBottom: TPanel
    Left = 0
    Top = 152
    Width = 414
    Height = 49
    Align = alBottom
    ParentColor = True
    TabOrder = 0
    ExplicitWidth = 573
    DesignSize = (
      414
      49)
    object btnCancel: TBitBtn
      Left = 321
      Top = 2
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
      ExplicitLeft = 480
    end
    object btnOK: TBitBtn
      Left = 232
      Top = 2
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 391
    end
    object btnHelp: TBitBtn
      Left = 143
      Top = 2
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 302
    end
  end
  object rdgChoices: TRbwDataGrid4
    Left = 0
    Top = 0
    Width = 414
    Height = 152
    Align = alClient
    ColCount = 1
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    TabOrder = 1
    ExtendedAutoDistributeText = False
    AutoMultiEdit = False
    AutoDistributeText = False
    AutoIncreaseColCount = False
    AutoIncreaseRowCount = False
    SelectedRowOrColumnColor = clAqua
    UnselectableColor = clBtnFace
    ColorRangeSelection = False
    Columns = <
      item
        AutoAdjustRowHeights = False
        AutoAdjustCaptionRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -12
        ButtonFont.Name = 'Segoe UI'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4Boolean
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        CaseSensitivePicklist = False
        CheckStyle = csCheck
        AutoAdjustColWidths = False
      end>
    WordWrapRowCaptions = False
    ExplicitLeft = 176
    ExplicitTop = 40
    ExplicitWidth = 320
    ExplicitHeight = 120
    ColWidths = (
      406)
  end
end
