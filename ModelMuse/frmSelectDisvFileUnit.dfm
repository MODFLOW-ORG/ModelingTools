object frmSelectDisvFile: TfrmSelectDisvFile
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSelectDisvFile'
  ClientHeight = 92
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object rgImportChoice: TRadioGroup
    Left = 0
    Top = 8
    Width = 273
    Height = 81
    Caption = 'What to import'
    ItemIndex = 0
    Items.Strings = (
      'Import cell outlines, cell centers and options'
      
        'mport cell outlines, cell centers, options, layer elevations and' +
        ' IDOMAIN')
    TabOrder = 0
    WordWrap = True
  end
end
