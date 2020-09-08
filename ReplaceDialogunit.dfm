object ReplaceDialog: TReplaceDialog
  Left = 309
  Top = 179
  BorderStyle = bsDialog
  Caption = 'Replace'
  ClientHeight = 162
  ClientWidth = 461
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
  object Label1: TLabel
    Left = 19
    Top = 19
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
  object Label2: TLabel
    Left = 19
    Top = 47
    Width = 82
    Height = 16
    Caption = 'Replace with :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object editFind: TComboBox
    Left = 112
    Top = 14
    Width = 243
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
    OnExit = editFindExit
  end
  object btnCancel: TBitBtn
    Left = 365
    Top = 84
    Width = 88
    Height = 29
    Caption = '&Cancel'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object Direction: TRadioGroup
    Left = 196
    Top = 70
    Width = 162
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
    TabOrder = 5
  end
  object cbMatchWord: TCheckBox
    Left = 19
    Top = 77
    Width = 155
    Height = 15
    Caption = 'Match whole word only'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object cbbMatchCase: TCheckBox
    Left = 19
    Top = 98
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
  object editReplace: TComboBox
    Left = 112
    Top = 42
    Width = 243
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 1
    OnExit = editReplaceExit
  end
  object btnReplace: TBitBtn
    Left = 364
    Top = 14
    Width = 88
    Height = 29
    Caption = '&Replace'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 7
    OnClick = btnReplaceClick
  end
  object btnReplaceAll: TBitBtn
    Left = 364
    Top = 49
    Width = 88
    Height = 29
    Caption = '&Replace allL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 10
    ParentFont = False
    TabOrder = 6
    OnClick = btnReplaceAllClick
  end
  object cbFromCursor: TCheckBox
    Left = 19
    Top = 119
    Width = 155
    Height = 15
    Caption = 'From cursor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
end
