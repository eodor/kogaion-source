object ExWindowStyleDlg: TExWindowStyleDlg
  Left = 19
  Top = 148
  Width = 517
  Height = 391
  BorderStyle = bsSizeToolWin
  Caption = 'Window Extended Style'
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
    499
    346)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 10
    Top = 10
    Width = 479
    Height = 231
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    MultiSelect = True
    TabOrder = 0
  end
  object btOK: TBitBtn
    Left = 408
    Top = 304
    Width = 83
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    Visible = False
    OnClick = btOKClick
  end
  object btCancel: TBitBtn
    Left = 312
    Top = 304
    Width = 88
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
    Visible = False
    OnClick = btCancelClick
  end
  object EditStyle: TEdit
    Left = 15
    Top = 258
    Width = 434
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object cbxAsConstants: TCheckBox
    Left = 15
    Top = 298
    Width = 149
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&As Constants'
    TabOrder = 4
  end
  object btnBrowse: TButton
    Left = 458
    Top = 258
    Width = 31
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 5
    OnClick = btnBrowseClick
  end
end
