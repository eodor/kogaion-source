object Association: TAssociation
  Left = 324
  Top = 143
  BorderStyle = bsToolWindow
  Caption = 'Association'
  ClientHeight = 279
  ClientWidth = 806
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 115
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 793
    Height = 225
    Caption = 'GroupBox1'
    TabOrder = 0
    object xxcdr: TLabel
      Left = 376
      Top = 24
      Width = 78
      Height = 16
      Caption = 'File Extension'
    end
    object Label1: TLabel
      Left = 376
      Top = 56
      Width = 107
      Height = 16
      Caption = 'Registry Key Name'
    end
    object Label2: TLabel
      Left = 376
      Top = 83
      Width = 63
      Height = 16
      Caption = 'Description'
    end
    object Label3: TLabel
      Left = 376
      Top = 115
      Width = 24
      Height = 16
      Caption = 'Icon'
    end
    object Label4: TLabel
      Left = 376
      Top = 142
      Width = 28
      Height = 16
      Caption = 'Shell'
    end
    object Label5: TLabel
      Left = 701
      Top = 117
      Width = 51
      Height = 16
      Caption = 'Optional.'
    end
    object Label6: TLabel
      Left = 701
      Top = 58
      Width = 51
      Height = 16
      Caption = 'Optional.'
    end
    object btnRegister: TButton
      Left = 650
      Top = 176
      Width = 129
      Height = 29
      Caption = 'Register'
      ModalResult = 1
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 530
      Top = 24
      Width = 165
      Height = 24
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 530
      Top = 54
      Width = 165
      Height = 24
      TabOrder = 2
    end
    object Edit3: TEdit
      Left = 530
      Top = 83
      Width = 165
      Height = 24
      TabOrder = 3
    end
    object Edit4: TEdit
      Left = 573
      Top = 113
      Width = 122
      Height = 24
      TabOrder = 4
    end
    object Edit5: TEdit
      Left = 573
      Top = 142
      Width = 122
      Height = 24
      TabOrder = 5
    end
    object Button2: TButton
      Left = 530
      Top = 113
      Width = 39
      Height = 24
      Caption = '...'
      TabOrder = 6
    end
    object Button3: TButton
      Left = 530
      Top = 142
      Width = 39
      Height = 25
      Caption = '...'
      TabOrder = 7
    end
    object CheckBox1: TCheckBox
      Left = 376
      Top = 181
      Width = 149
      Height = 20
      Caption = 'ExitOnWarning'
      TabOrder = 8
    end
    object CheckListBox1: TCheckListBox
      Left = 12
      Top = 20
      Width = 337
      Height = 181
      ItemHeight = 16
      TabOrder = 9
    end
  end
  object btnOK: TBitBtn
    Left = 716
    Top = 244
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object BIANCOREGISTER1: TBiancoRegister
    Extension = '.FIC'
    Description = 'FICA'
    ShellCommand = 'C:\WINDOWS\WRITE.EXE'
    Warning = 0
    LastError = 0
    ExitOnWarning = False
    Left = 298
    Top = 130
  end
  object OpenDialogIcns: TOpenDialog
    Filter = 'Icons|*.Ico'
    Left = 302
    Top = 166
  end
  object OpenDialogExe: TOpenDialog
    Filter = 'Executable|*.Exe'
    Left = 246
    Top = 170
  end
end
