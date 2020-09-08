object CustomizeClasses: TCustomizeClasses
  Left = 243
  Top = 138
  Width = 501
  Height = 433
  BorderStyle = bsSizeToolWin
  Caption = 'Customize Classes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    483
    388)
  PixelsPerInch = 115
  TextHeight = 16
  object btOK: TBitBtn
    Left = 377
    Top = 351
    Width = 93
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btOKClick
  end
  object btCancel: TBitBtn
    Left = 275
    Top = 352
    Width = 93
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 465
    Height = 333
    Anchors = [akLeft, akTop, akRight, akBottom]
    PopupMenu = PopupMenu
    TabOrder = 2
  end
  object PopupMenu: TPopupMenu
    Left = 104
    Top = 112
    object menuAddClass: TMenuItem
      Caption = '&Add Class(es)...'
      OnClick = menuAddClassClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuPalette: TMenuItem
      Caption = '&Palette'
      object menuAddPalette: TMenuItem
        Caption = '&Add...'
        OnClick = menuAddPaletteClick
      end
      object menuRemove: TMenuItem
        Caption = '&Remove'
        OnClick = menuRemoveClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object menuHide: TMenuItem
        Caption = '&Hide'
        OnClick = menuHideClick
      end
    end
  end
end
