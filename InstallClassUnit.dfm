object InstallClass: TInstallClass
  Left = 414
  Top = 238
  Width = 534
  Height = 129
  BorderStyle = bsSizeToolWin
  Caption = 'Install Class'
  Color = clBtnFace
  Constraints.MaxHeight = 129
  Constraints.MinHeight = 129
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    516
    84)
  PixelsPerInch = 115
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 29
    Height = 16
    Caption = '&File :'
  end
  object Bevel: TBevel
    Left = 12
    Top = 40
    Width = 481
    Height = 2
  end
  object edClassFile: TEdit
    Left = 80
    Top = 8
    Width = 317
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object btnClassfile: TBitBtn
    Left = 412
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Browse...'
    TabOrder = 1
    OnClick = btnClassfileClick
  end
  object btnOK: TBitBtn
    Left = 415
    Top = 48
    Width = 75
    Height = 25
    Anchors = [akTop]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Left = 335
    Top = 48
    Width = 75
    Height = 25
    Anchors = [akTop]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
end
