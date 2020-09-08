object LanguagesDlg: TLanguagesDlg
  Left = 537
  Top = 295
  BorderStyle = bsDialog
  Caption = 'Languages'
  ClientHeight = 277
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 115
  TextHeight = 14
  object btClose: TBitBtn
    Left = 203
    Top = 240
    Width = 88
    Height = 30
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 1
    OnClick = btCloseClick
  end
  object Panel: TPanel
    Left = 7
    Top = 7
    Width = 293
    Height = 218
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object ListBox: TListBox
      Left = 14
      Top = 7
      Width = 169
      Height = 197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      PopupMenu = PopupMenuLangs
      TabOrder = 0
      OnClick = ListBoxClick
    end
    object btnLoad: TBitBtn
      Left = 196
      Top = 7
      Width = 88
      Height = 29
      Caption = 'L&oad...'
      TabOrder = 1
      OnClick = btnLoadClick
    end
    object btnSet: TBitBtn
      Left = 196
      Top = 44
      Width = 88
      Height = 30
      Caption = '&Set'
      Enabled = False
      TabOrder = 2
      OnClick = btnSetClick
    end
    object btnShow: TBitBtn
      Left = 196
      Top = 82
      Width = 88
      Height = 29
      Caption = '&Show'
      Enabled = False
      TabOrder = 3
      OnClick = btnShowClick
    end
  end
  object PopupMenuLangs: TPopupMenu
    OnPopup = PopupMenuLangsPopup
    Left = 86
    Top = 70
    object pmenuRemove: TMenuItem
      Caption = 'Remove'
      OnClick = pmenuRemoveClick
    end
  end
end
