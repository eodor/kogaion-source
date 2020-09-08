object ProjectProperties: TProjectProperties
  Left = 485
  Top = 189
  Width = 487
  Height = 327
  BorderStyle = bsSizeToolWin
  Caption = 'Project Properties'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    469
    283)
  PixelsPerInch = 110
  TextHeight = 14
  object PageControl: TPageControl
    Left = 8
    Top = 4
    Width = 457
    Height = 239
    ActivePage = TabGeneral
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabGeneral: TTabSheet
      Caption = '&General'
      DesignSize = (
        449
        210)
      object LabelHelpFile: TLabel
        Left = 12
        Top = 160
        Width = 49
        Height = 14
        Caption = '&Help File:'
      end
      object PanelIcon: TPanel
        Left = 8
        Top = 16
        Width = 129
        Height = 129
        BevelOuter = bvNone
        BorderStyle = bsSingle
        TabOrder = 0
        object ImageIcon: TImage
          Left = 0
          Top = 0
          Width = 125
          Height = 125
          Align = alClient
          Center = True
          ParentShowHint = False
          ShowHint = True
        end
      end
      object btnIcon: TBitBtn
        Left = 148
        Top = 20
        Width = 113
        Height = 25
        Caption = '&Browse Icon...'
        TabOrder = 1
        OnClick = btnIconClick
      end
      object cbxHelpFiles: TComboBox
        Left = 12
        Top = 180
        Width = 393
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 14
        TabOrder = 2
      end
      object btnBrowseHelp: TBitBtn
        Left = 405
        Top = 180
        Width = 29
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 3
        OnClick = btnBrowseHelpClick
      end
    end
    object TabDirectories: TTabSheet
      Caption = '&Directories/Conditionals'
      ImageIndex = 1
      DesignSize = (
        449
        210)
      object CheckListBox: TCheckListBox
        Left = 0
        Top = 0
        Width = 449
        Height = 180
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 14
        TabOrder = 0
      end
      object btnAdd: TBitBtn
        Left = 8
        Top = 183
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&Add..'
        TabOrder = 1
        OnClick = btnAddClick
      end
    end
  end
  object btnOK: TBitBtn
    Left = 384
    Top = 250
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 300
    Top = 250
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
end
