object ClassModule: TClassModule
  Left = 664
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Registered Classes in Module'
  ClientHeight = 297
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 115
  TextHeight = 16
  object CheckListBox: TCheckListBox
    Left = 8
    Top = 8
    Width = 393
    Height = 249
    ItemHeight = 16
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 328
    Top = 264
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 248
    Top = 264
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
end
