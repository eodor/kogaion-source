object Associations: TAssociations
  Left = 411
  Top = 220
  Anchors = []
  BorderStyle = bsToolWindow
  Caption = 'Files Type'
  ClientHeight = 180
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    208
    180)
  PixelsPerInch = 115
  TextHeight = 16
  object Bevel1: TBevel
    Left = 8
    Top = 144
    Width = 181
    Height = 2
  end
  object CheckListBox: TCheckListBox
    Left = 10
    Top = 10
    Width = 187
    Height = 99
    Anchors = []
    ItemHeight = 16
    Items.Strings = (
      '.bi'
      '.bas'
      '.fbk'
      '.fbp')
    TabOrder = 0
    OnClick = CheckListBoxClick
  end
  object btnClose: TBitBtn
    Left = 122
    Top = 149
    Width = 75
    Height = 26
    Anchors = []
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 1
  end
  object btnUnregister: TBitBtn
    Left = 23
    Top = 112
    Width = 75
    Height = 26
    Anchors = []
    Caption = '&Unregister'
    Enabled = False
    TabOrder = 2
  end
  object btnRegister: TBitBtn
    Left = 108
    Top = 112
    Width = 75
    Height = 26
    Anchors = []
    Caption = '&Register'
    Enabled = False
    TabOrder = 3
  end
end
