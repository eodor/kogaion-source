object ActiveX: TActiveX
  Left = 609
  Top = 157
  Width = 571
  Height = 390
  BorderStyle = bsSizeToolWin
  Caption = 'ActiveX'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    553
    345)
  PixelsPerInch = 115
  TextHeight = 16
  object ldDLL: TLabel
    Left = 15
    Top = 7
    Width = 31
    Height = 16
    Caption = '&DLLs:'
  end
  object ListBox: TListBox
    Left = 7
    Top = 30
    Width = 533
    Height = 198
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 0
    OnClick = ListBoxClick
  end
  object ListBoxClasses: TListBox
    Left = 7
    Top = 240
    Width = 534
    Height = 91
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 16
    PopupMenu = PopupMenu
    TabOrder = 1
  end
  object PopupMenu: TPopupMenu
    Left = 146
    Top = 86
    object menuSave: TMenuItem
      Caption = '&Save'
      OnClick = menuSaveClick
    end
  end
end
