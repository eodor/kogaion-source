object FindDialog: TFindDialog
  Left = 306
  Top = 161
  BorderStyle = bsDialog
  Caption = 'Find'
  ClientHeight = 130
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 115
  TextHeight = 14
  object lblTextToFind: TLabel
    Left = 14
    Top = 8
    Width = 74
    Height = 16
    Caption = 'Text to find :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object editFindText: TComboBox
    Left = 108
    Top = 8
    Width = 257
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
    OnExit = editFindTextExit
  end
  object btnFind: TBitBtn
    Left = 371
    Top = 7
    Width = 88
    Height = 29
    Caption = '&Find'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 5
    OnClick = btnFindClick
  end
  object btnCancel: TBitBtn
    Left = 371
    Top = 42
    Width = 88
    Height = 29
    Caption = '&Cancel'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object Direction: TRadioGroup
    Left = 196
    Top = 42
    Width = 169
    Height = 71
    Caption = '&Direction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'down'
      'up')
    ParentFont = False
    TabOrder = 4
  end
  object cbMatchWord: TCheckBox
    Left = 19
    Top = 49
    Width = 155
    Height = 15
    Caption = 'Match whole word only'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object cbbMatchCase: TCheckBox
    Left = 19
    Top = 70
    Width = 155
    Height = 15
    Caption = 'Match case'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object cbFromCursor: TCheckBox
    Left = 19
    Top = 93
    Width = 155
    Height = 16
    Caption = 'From cursor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
