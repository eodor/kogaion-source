object WindowsConstants: TWindowsConstants
  Left = 470
  Top = 274
  Width = 577
  Height = 488
  BorderStyle = bsSizeToolWin
  Caption = 'Windows Constants'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    559
    443)
  PixelsPerInch = 115
  TextHeight = 14
  object ListBox: TListBox
    Left = 6
    Top = 11
    Width = 547
    Height = 383
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 14
    TabOrder = 0
    OnClick = ListBoxClick
    OnDblClick = ListBoxDblClick
  end
  object EditSearch: TEdit
    Left = 8
    Top = 400
    Width = 272
    Height = 22
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
  object btSearch: TBitBtn
    Left = 473
    Top = 400
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Search'
    Default = True
    TabOrder = 2
    OnClick = btSearchClick
  end
  object EditValue: TEdit
    Left = 289
    Top = 400
    Width = 182
    Height = 22
    Anchors = [akRight, akBottom]
    TabOrder = 3
  end
end
