object AlignmentInWindow: TAlignmentInWindow
  Left = 250
  Top = 207
  BorderStyle = bsToolWindow
  Caption = 'Alignment In Window'
  ClientHeight = 220
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 115
  TextHeight = 16
  object rgHorizontal: TRadioGroup
    Left = 8
    Top = 8
    Width = 185
    Height = 169
    Caption = '&Horizontal'
    ItemIndex = 0
    Items.Strings = (
      '&no changes'
      '&left side'
      '&center'
      '&right side'
      '&space equaly'
      'center in &window')
    TabOrder = 0
  end
  object rgVertical: TRadioGroup
    Left = 200
    Top = 8
    Width = 185
    Height = 169
    Caption = '&Vertical'
    ItemIndex = 0
    Items.Strings = (
      '&no changes'
      '&left side'
      '&center'
      '&right side'
      '&space equaly'
      'center in &window')
    TabOrder = 1
  end
  object btnOK: TBitBtn
    Left = 304
    Top = 184
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 216
    Top = 184
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
end
