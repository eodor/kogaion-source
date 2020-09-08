object CreationOrder: TCreationOrder
  Left = 629
  Top = 294
  Width = 387
  Height = 225
  BorderStyle = bsSizeToolWin
  Caption = 'Creation Order'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    369
    180)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 315
    Height = 132
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 0
  end
  object btnUp: TBitBtn
    Left = 334
    Top = 8
    Width = 25
    Height = 23
    Anchors = [akTop, akRight]
    TabOrder = 1
  end
  object btnDown: TBitBtn
    Left = 334
    Top = 40
    Width = 25
    Height = 23
    Anchors = [akTop, akRight]
    TabOrder = 2
  end
  object btnOK: TBitBtn
    Left = 282
    Top = 148
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TBitBtn
    Left = 202
    Top = 148
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 4
  end
end
