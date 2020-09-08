object ExportFiles: TExportFiles
  Left = 260
  Top = 236
  Width = 343
  Height = 259
  BorderStyle = bsSizeToolWin
  Caption = 'Export Files...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    325
    214)
  PixelsPerInch = 115
  TextHeight = 16
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 306
    Height = 163
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    MultiSelect = True
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 237
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 157
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
  object cbJpeg: TCheckBox
    Left = 16
    Top = 176
    Width = 137
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Pictures as &Jpeg'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
end
