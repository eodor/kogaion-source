object Tools: TTools
  Left = 374
  Top = 198
  Width = 431
  Height = 252
  BorderStyle = bsSizeToolWin
  Caption = 'Tools'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    413
    207)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 7
    Top = 7
    Width = 290
    Height = 130
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 0
    OnClick = ListBoxClick
  end
  object EditParams: TEdit
    Left = 7
    Top = 149
    Width = 394
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
  object cbxShowMenu: TCheckBox
    Left = 7
    Top = 181
    Width = 179
    Height = 21
    Anchors = [akLeft]
    Caption = '&Show Menu'
    TabOrder = 2
    OnClick = cbxShowMenuClick
  end
  object btAdd: TBitBtn
    Left = 311
    Top = 7
    Width = 92
    Height = 31
    Anchors = [akTop, akRight]
    Caption = '&Add...'
    TabOrder = 3
    OnClick = btAddClick
  end
  object btRemove: TBitBtn
    Left = 311
    Top = 44
    Width = 92
    Height = 31
    Anchors = [akTop, akRight]
    Caption = '&Remove'
    TabOrder = 4
    OnClick = btRemoveClick
  end
  object btExecute: TBitBtn
    Left = 311
    Top = 81
    Width = 92
    Height = 31
    Anchors = [akTop, akRight]
    Caption = '&Execute'
    TabOrder = 5
    OnClick = btExecuteClick
  end
end
