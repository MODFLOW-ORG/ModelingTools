object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object SaveDialog1: TSaveDialog
    Filter = '.txt|*.txt'
    Left = 176
    Top = 32
  end
  object RbwQuadTree1: TRbwQuadTree
    MaxPoints = 100
    XMax = 101.000000000000000000
    XMin = -1.000000000000000000
    YMax = 101.000000000000000000
    YMin = -1.000000000000000000
    Left = 256
    Top = 40
  end
end
