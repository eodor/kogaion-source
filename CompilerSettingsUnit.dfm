object CompilerSettings: TCompilerSettings
  Left = 372
  Top = 266
  BorderStyle = bsDialog
  Caption = 'Compiler Settings'
  ClientHeight = 216
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 115
  TextHeight = 16
  object LabelCompiler: TLabel
    Left = 18
    Top = 6
    Width = 56
    Height = 16
    Caption = '&Compiler:'
  end
  object LabelSwitch: TLabel
    Left = 18
    Top = 60
    Width = 43
    Height = 16
    Caption = '&Switch:'
  end
  object LabelTarget: TLabel
    Left = 18
    Top = 116
    Width = 43
    Height = 16
    Caption = '&Target:'
  end
  object cbxSwitches: TComboBox
    Left = 18
    Top = 80
    Width = 349
    Height = 24
    ItemHeight = 16
    TabOrder = 0
  end
  object cbxCompilers: TComboBox
    Left = 18
    Top = 26
    Width = 349
    Height = 24
    ItemHeight = 16
    TabOrder = 1
  end
  object btnBrowseCompler: TButton
    Left = 372
    Top = 24
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 2
    OnClick = btnBrowseComplerClick
  end
  object btnBrowseSwitch: TButton
    Left = 372
    Top = 78
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = btnBrowseSwitchClick
  end
  object btnOK: TButton
    Left = 324
    Top = 182
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 240
    Top = 182
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object cbxTargets: TComboBox
    Left = 18
    Top = 136
    Width = 349
    Height = 24
    ItemHeight = 16
    TabOrder = 6
    OnChange = cbxTargetsChange
    Items.Strings = (
      'windows'
      'linux'
      'cygwin'
      'darwin'
      'freebsd'
      'netbsd'
      'openbsd')
  end
end
