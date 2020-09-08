object SearchFile: TSearchFile
  Left = 179
  Top = 291
  Width = 573
  Height = 198
  BorderStyle = bsSizeToolWin
  Caption = 'Search File'
  Color = clBtnFace
  Constraints.MaxHeight = 198
  Constraints.MinHeight = 198
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    555
    153)
  PixelsPerInch = 115
  TextHeight = 16
  object lbFileName: TLabel
    Left = 15
    Top = 15
    Width = 62
    Height = 16
    Caption = 'FileName :'
  end
  object lbFile: TLabel
    Left = 15
    Top = 118
    Width = 4
    Height = 17
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbWhere: TLabel
    Left = 15
    Top = 52
    Width = 47
    Height = 16
    Caption = '&Where :'
  end
  object Bevel: TBevel
    Left = 10
    Top = 98
    Width = 531
    Height = 2
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object cbFiles: TComboBox
    Left = 111
    Top = 15
    Width = 334
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 16
    TabOrder = 0
    OnExit = cbFilesExit
  end
  object btnSearch: TBitBtn
    Left = 452
    Top = 17
    Width = 89
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&Search'
    Default = True
    TabOrder = 1
    OnClick = btnSearchClick
  end
  object cbWhere: TComboBox
    Left = 111
    Top = 52
    Width = 334
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 16
    TabOrder = 2
  end
  object btnWhere: TBitBtn
    Left = 453
    Top = 54
    Width = 35
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 3
    OnClick = btnWhereClick
  end
  object btnClose: TBitBtn
    Left = 449
    Top = 110
    Width = 89
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 4
    OnClick = btnCloseClick
  end
end
