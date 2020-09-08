object MenuEditorDlg: TMenuEditorDlg
  Left = 844
  Top = 165
  Width = 482
  Height = 246
  Caption = 'Menu Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  PopupMenu = PopupMenu
  OnClose = FormClose
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 115
  TextHeight = 16
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 464
    Height = 16
    Align = alTop
    Caption = '  use shortcut F3 to reselect thr MainMenu'
    Color = 8454143
    ParentColor = False
    Transparent = False
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 182
    Width = 464
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object MainMenu: TMainMenu
    Left = 24
    Top = 18
  end
  object PopupMenu: TPopupMenu
    Left = 72
    Top = 18
    object menuAdd: TMenuItem
      Caption = '&Add...'
      OnClick = menuAddClick
    end
    object menuRemove: TMenuItem
      Caption = '&Remove'
      OnClick = menuRemoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuClear: TMenuItem
      Caption = '&Clear'
      OnClick = menuClearClick
    end
  end
end
