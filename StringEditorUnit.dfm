object StringEditor: TStringEditor
  Left = 447
  Top = 138
  Width = 477
  Height = 301
  BorderStyle = bsSizeToolWin
  Caption = 'StringEditor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    459
    256)
  PixelsPerInch = 115
  TextHeight = 16
  object Memo: TMemo
    Left = 15
    Top = 7
    Width = 433
    Height = 202
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 358
    Top = 215
    Width = 92
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 255
    Top = 215
    Width = 92
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnHelp: TButton
    Left = 15
    Top = 215
    Width = 92
    Height = 31
    Anchors = [akLeft, akBottom]
    Caption = '&Help'
    TabOrder = 3
    Visible = False
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 48
    Top = 60
    object menuLoad: TMenuItem
      Caption = '&Load...'
      OnClick = menuLoadClick
    end
    object menuSave: TMenuItem
      Caption = '&Save...'
      OnClick = menuSaveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuUndo: TMenuItem
      Caption = '&Undo'
      OnClick = menuUndoClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object menuPaste: TMenuItem
      Caption = '&Paste'
      OnClick = menuPasteClick
    end
    object menuCut: TMenuItem
      Caption = '&Cut'
      OnClick = menuCutClick
    end
    object menuCopy: TMenuItem
      Caption = '&Copy'
      OnClick = menuCopyClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object menuSelectAll: TMenuItem
      Caption = '&Select All'
      OnClick = menuSelectAllClick
    end
  end
end
