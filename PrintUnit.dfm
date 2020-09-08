object PrintAll: TPrintAll
  Left = 568
  Top = 225
  Width = 373
  Height = 300
  BorderStyle = bsSizeToolWin
  Caption = 'Print ...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    355
    255)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 338
    Height = 205
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    MultiSelect = True
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 262
    Top = 221
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 178
    Top = 221
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
end
