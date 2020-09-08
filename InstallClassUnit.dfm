object InstallClass: TInstallClass
  Left = 490
  Top = 88
  Width = 537
  Height = 157
  BorderStyle = bsSizeToolWin
  Caption = 'Install Class'
  Color = clBtnFace
  Constraints.MaxHeight = 157
  Constraints.MinHeight = 157
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    519
    112)
  PixelsPerInch = 115
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 29
    Height = 16
    Caption = '&File :'
  end
  object edClassFile: TEdit
    Left = 80
    Top = 24
    Width = 320
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object btnClassfile: TBitBtn
    Left = 415
    Top = 24
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Browse...'
    TabOrder = 1
    OnClick = btnClassfileClick
  end
  object btnOK: TBitBtn
    Left = 418
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Left = 338
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
end
