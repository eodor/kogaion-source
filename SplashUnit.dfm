object Splash: TSplash
  Left = 189
  Top = 211
  Hint = 'the Carpathian sphinx, the Bucegi mountains'
  BorderStyle = bsNone
  Caption = 'Splash'
  ClientHeight = 425
  ClientWidth = 895
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClick = FormClick
  OnClose = FormClose
  PixelsPerInch = 115
  TextHeight = 16
  object LabelFile: TLabel
    Left = 0
    Top = 409
    Width = 895
    Height = 16
    Align = alBottom
    Caption = '...'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object Kind: TLabel
    Left = 16
    Top = 138
    Width = 607
    Height = 31
    Caption = 'is time to stop joking, and start doing things...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -26
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Logo: TLabel
    Left = 20
    Top = 96
    Width = 478
    Height = 39
    Caption = 'the power of men...his mind...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Prog: TLabel
    Left = 12
    Top = 0
    Width = 597
    Height = 70
    Caption = 'Kogaion (RqWork 7)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -58
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object version: TLabel
    Left = 24
    Top = 72
    Width = 6
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Copyright: TLabel
    Left = 608
    Top = 384
    Width = 274
    Height = 17
    Caption = 'Copyright (c02020 vasile eodor nastasa'
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object LabelLegal: TLabel
    Left = 8
    Top = 384
    Width = 240
    Height = 19
    Caption = 'Legal TradeMark: FREEWARE'
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object LabelVersion: TLabel
    Left = 16
    Top = 76
    Width = 157
    Height = 23
    Caption = 'version 7 BETA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
end
