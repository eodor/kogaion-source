object SearchInFiles: TSearchInFiles
  Left = 194
  Top = 119
  BorderStyle = bsDialog
  Caption = 'Search in files...'
  ClientHeight = 353
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 115
  TextHeight = 16
  object lbTextToFind: TLabel
    Left = 20
    Top = 10
    Width = 74
    Height = 16
    Caption = 'Text to find :'
  end
  object btnOK: TBitBtn
    Left = 429
    Top = 315
    Width = 93
    Height = 31
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 325
    Top = 315
    Width = 92
    Height = 31
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object TextToFind: TComboBox
    Left = 128
    Top = 10
    Width = 405
    Height = 24
    ItemHeight = 16
    TabOrder = 2
    OnExit = TextToFindExit
  end
  object gbWhere: TGroupBox
    Left = 288
    Top = 52
    Width = 245
    Height = 129
    Caption = '&Where'
    TabOrder = 3
    object rbProject: TRadioButton
      Left = 10
      Top = 30
      Width = 188
      Height = 20
      Caption = 'Search in &project files'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbOpenClick
    end
    object rbOpen: TRadioButton
      Left = 10
      Top = 59
      Width = 188
      Height = 21
      Caption = 'Search in all &open files'
      TabOrder = 1
      OnClick = rbOpenClick
    end
    object rbDirectories: TRadioButton
      Left = 10
      Top = 89
      Width = 188
      Height = 21
      Caption = 'Search in &directories'
      TabOrder = 2
      OnClick = rbOpenClick
    end
  end
  object cbEditor: TCheckBox
    Left = 30
    Top = 315
    Width = 198
    Height = 21
    Caption = 'Display result in &editor'
    TabOrder = 4
    Visible = False
  end
  object gbDirectories: TGroupBox
    Left = 20
    Top = 187
    Width = 513
    Height = 110
    Caption = '&Directories options'
    TabOrder = 5
    object lbMask: TLabel
      Left = 10
      Top = 30
      Width = 38
      Height = 16
      Caption = '&Mask :'
    end
    object Label1: TLabel
      Left = 10
      Top = 69
      Width = 38
      Height = 16
      Caption = '&Filter :'
    end
    object cbFileMask: TComboBox
      Left = 89
      Top = 30
      Width = 306
      Height = 24
      ItemHeight = 16
      TabOrder = 0
      OnExit = cbFileMaskExit
    end
    object btnBrowse: TBitBtn
      Left = 404
      Top = 30
      Width = 92
      Height = 30
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object cbFilter: TComboBox
      Left = 89
      Top = 69
      Width = 178
      Height = 24
      ItemHeight = 16
      TabOrder = 2
      Text = '*.*'
      OnExit = cbFilterExit
    end
  end
  object SynEdit: TSynEdit
    Left = 249
    Top = 145
    Width = 40
    Height = 33
    Hint = 'Click on gutter to get file '#13#10'wirth occurence on it.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Visible = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.Width = 16
    HideSelection = True
    Highlighter = General
  end
  object gbOptions: TGroupBox
    Left = 15
    Top = 52
    Width = 259
    Height = 129
    Caption = '&Options'
    TabOrder = 7
    object cbxCaseSensitive: TCheckBox
      Left = 22
      Top = 30
      Width = 164
      Height = 20
      Caption = 'Case &Sensitive'
      TabOrder = 0
    end
    object cbxMatchWholeWord: TCheckBox
      Left = 22
      Top = 52
      Width = 164
      Height = 21
      Caption = 'Match &Whole Word'
      TabOrder = 1
    end
    object cbxFromCursor: TCheckBox
      Left = 22
      Top = 74
      Width = 164
      Height = 21
      Caption = 'From &Cursor'
      TabOrder = 2
      Visible = False
    end
  end
  object General: TSynGeneralSyn
    Comments = []
    DetectPreprocessor = False
    IdentifierAttri.Foreground = clNavy
    IdentifierChars = 
      '!"#$%&'#39'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`' +
      'abcdefghijklmnopqrstuvwxyz{|}~���'
    KeyWords.Strings = (
      ' FILE'
      'FOUND'
      'OCCURENCE')
    NumberAttri.Foreground = 16711808
    StringAttri.Foreground = clRed
    Left = 202
    Top = 86
  end
end
