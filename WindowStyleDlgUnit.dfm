object WindowStyleDlg: TWindowStyleDlg
  Left = 562
  Top = 150
  Width = 431
  Height = 379
  Anchors = [akLeft, akBottom]
  BorderStyle = bsSizeToolWin
  Caption = 'Window Style'
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
    413
    334)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 10
    Top = 10
    Width = 390
    Height = 194
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    MultiSelect = True
    PopupMenu = PopupMenu
    TabOrder = 0
  end
  object btOK: TBitBtn
    Left = 309
    Top = 296
    Width = 85
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btOKClick
  end
  object btCancel: TBitBtn
    Left = 221
    Top = 296
    Width = 85
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
    OnClick = btCancelClick
  end
  object cbxAsConstants: TCheckBox
    Left = 8
    Top = 304
    Width = 149
    Height = 21
    Anchors = [akLeft]
    Caption = '&As Constants'
    TabOrder = 3
  end
  object EditStyle: TEdit
    Left = 8
    Top = 256
    Width = 352
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object btnBrowse: TButton
    Left = 365
    Top = 256
    Width = 31
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 5
    OnClick = btnBrowseClick
  end
  object cbClasses: TComboBox
    Left = 8
    Top = 216
    Width = 183
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 6
    OnCloseUp = cbClassesCloseUp
  end
  object PopupMenu: TPopupMenu
    Left = 72
    Top = 80
    object pmenuShowSpecific: TMenuItem
      Caption = 'Show Specific'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmenuShowAll: TMenuItem
      Caption = 'Show &All'
    end
  end
end
