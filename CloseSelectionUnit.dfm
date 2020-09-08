object CloseSelection: TCloseSelection
  Left = 408
  Top = 226
  Width = 409
  Height = 298
  BorderStyle = bsSizeToolWin
  Caption = 'Close Selection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    391
    253)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 17
    Top = 5
    Width = 361
    Height = 210
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 14
    MultiSelect = True
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 285
    Top = 220
    Width = 86
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 185
    Top = 220
    Width = 86
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cbxWithoutCheck: TCheckBox
    Left = 17
    Top = 223
    Width = 156
    Height = 20
    Anchors = [akLeft, akBottom]
    Caption = '&Without Check'
    TabOrder = 3
  end
end
