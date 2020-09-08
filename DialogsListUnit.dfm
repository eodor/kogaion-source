object DialogList: TDialogList
  Left = 238
  Top = 195
  Width = 336
  Height = 206
  BorderStyle = bsSizeToolWin
  Caption = 'Dialogs'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    318
    161)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 16
    Top = 8
    Width = 210
    Height = 144
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 0
    OnClick = ListBoxClick
  end
  object btnShow: TBitBtn
    Left = 233
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Show'
    Enabled = False
    TabOrder = 1
    OnClick = btnShowClick
  end
  object btnHide: TBitBtn
    Left = 233
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Hide'
    Enabled = False
    TabOrder = 2
    OnClick = btnHideClick
  end
  object btnFree: TBitBtn
    Left = 233
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Free'
    Enabled = False
    TabOrder = 3
    OnClick = btnFreeClick
  end
end
