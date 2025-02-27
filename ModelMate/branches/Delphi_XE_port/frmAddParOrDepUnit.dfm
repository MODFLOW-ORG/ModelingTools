object frmAddParOrDep: TfrmAddParOrDep
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add Parameter'
  ClientHeight = 144
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lblName: TLabel
    Left = 20
    Top = 24
    Width = 145
    Height = 16
    Caption = 'Name of new parameter:'
  end
  object lblGroup: TLabel
    Left = 20
    Top = 67
    Width = 102
    Height = 16
    Caption = 'Parameter group:'
  end
  object edtParOrDepName: TEdit
    Left = 203
    Top = 21
    Width = 184
    Height = 24
    MaxLength = 12
    TabOrder = 0
  end
  object cmbGroup: TComboBox
    Left = 203
    Top = 64
    Width = 184
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 211
    Top = 106
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object btnOK: TBitBtn
    Left = 126
    Top = 106
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
end
