inherited frmPrtChoices: TfrmPrtChoices
  Caption = 'PRT Choices'
  ClientHeight = 376
  ClientWidth = 558
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 574
  ExplicitHeight = 415
  TextHeight = 18
  object pnlBottom: TPanel
    Left = 0
    Top = 327
    Width = 558
    Height = 49
    Align = alBottom
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 152
    ExplicitWidth = 414
    DesignSize = (
      558
      49)
    object btnCancel: TBitBtn
      Left = 465
      Top = 2
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
      ExplicitLeft = 321
    end
    object btnOK: TBitBtn
      Left = 376
      Top = 2
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 232
    end
    object btnHelp: TBitBtn
      Left = 287
      Top = 2
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 143
    end
  end
  object rdgChoices: TRbwDataGrid4
    Left = 0
    Top = 0
    Width = 558
    Height = 327
    Align = alClient
    ColCount = 1
    FixedCols = 0
    RowCount = 11
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
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
    ExplicitTop = -4
    ExplicitWidth = 383
    ColWidths = (
      406)
  end
end
