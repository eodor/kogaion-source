object SetModule: TSetModule
  Left = 483
  Top = 165
  Width = 425
  Height = 271
  BorderStyle = bsSizeToolWin
  Caption = 'Set Module'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    407
    226)
  PixelsPerInch = 115
  TextHeight = 16
  object CheckListBox: TCheckListBox
    Left = 7
    Top = 7
    Width = 392
    Height = 166
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 305
    Top = 185
    Width = 93
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 201
    Top = 185
    Width = 94
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
