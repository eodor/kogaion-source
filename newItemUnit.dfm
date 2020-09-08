object newItems: TnewItems
  Left = 299
  Top = 209
  Width = 481
  Height = 341
  BorderStyle = bsSizeToolWin
  Caption = 'New Items'
  Color = clBtnFace
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
    463
    296)
  PixelsPerInch = 115
  TextHeight = 16
  object PageControl: TPageControl
    Left = 7
    Top = 7
    Width = 447
    Height = 240
    Anchors = [akLeft, akTop, akRight, akBottom]
    PopupMenu = PopupMenu
    TabOrder = 0
  end
  object btAdd: TBitBtn
    Left = 7
    Top = 254
    Width = 93
    Height = 30
    Anchors = [akLeft, akBottom]
    Caption = '&Add...'
    TabOrder = 1
    OnClick = btAddClick
  end
  object btClose: TBitBtn
    Left = 359
    Top = 254
    Width = 93
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    Default = True
    TabOrder = 2
    OnClick = btCloseClick
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 78
    Top = 42
    object menuNewItem: TMenuItem
      Caption = '&New Item...'
      OnClick = menuNewItemClick
    end
    object menuDeleteItem: TMenuItem
      Caption = '&Delete Item'
      OnClick = menuDeleteItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuNewTab: TMenuItem
      Caption = '&New Tab...'
      OnClick = menuNewTabClick
    end
    object menuRemoveTab: TMenuItem
      Caption = '&Remove Tab'
      OnClick = menuRemoveTabClick
    end
  end
end
