object NewClass: TNewClass
  Left = 302
  Top = 151
  BorderStyle = bsDialog
  Caption = 'New Class'
  ClientHeight = 353
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 115
  TextHeight = 16
  object LabelClassOrDLL: TLabel
    Left = 15
    Top = 22
    Width = 129
    Height = 16
    Caption = 'ClassName or DLL file:'
  end
  object LabelPalette: TLabel
    Left = 15
    Top = 51
    Width = 48
    Height = 16
    Caption = '&Palette :'
  end
  object LabelAncestor: TLabel
    Left = 16
    Top = 80
    Width = 55
    Height = 16
    Caption = '&Ancestor:'
  end
  object EditClassName: TEdit
    Left = 162
    Top = 22
    Width = 304
    Height = 22
    TabOrder = 0
  end
  object btnDLLFile: TButton
    Left = 473
    Top = 22
    Width = 30
    Height = 26
    Caption = '-'
    TabOrder = 1
    OnClick = btnDLLFileClick
  end
  object ListBox: TListBox
    Left = 15
    Top = 120
    Width = 489
    Height = 177
    ItemHeight = 16
    PopupMenu = PopupMenu
    TabOrder = 2
  end
  object btnOK: TBitBtn
    Left = 414
    Top = 310
    Width = 92
    Height = 31
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 310
    Top = 310
    Width = 92
    Height = 31
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 4
  end
  object ComboBoxPalette: TComboBox
    Left = 162
    Top = 51
    Width = 245
    Height = 24
    ItemHeight = 16
    TabOrder = 5
    OnCloseUp = ComboBoxPaletteCloseUp
  end
  object cbxAncestor: TComboBox
    Left = 160
    Top = 80
    Width = 249
    Height = 24
    ItemHeight = 16
    TabOrder = 6
    OnCloseUp = cbxAncestorCloseUp
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 86
    Top = 144
    object menuDelete: TMenuItem
      Caption = '&Delete'
      OnClick = menuDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuInfo: TMenuItem
      Caption = '&Info...'
      OnClick = menuInfoClick
    end
  end
end
