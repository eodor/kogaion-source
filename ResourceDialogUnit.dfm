object ResourcesDialog: TResourcesDialog
  Left = 378
  Top = 197
  Width = 774
  Height = 385
  BorderStyle = bsSizeToolWin
  Caption = 'Resources Dialog'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    756
    340)
  PixelsPerInch = 115
  TextHeight = 16
  object lbKind: TLabel
    Left = 124
    Top = 296
    Width = 24
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = '&Kind'
  end
  object btnLoad: TBitBtn
    Left = 10
    Top = 295
    Width = 92
    Height = 31
    Anchors = [akLeft, akBottom]
    Caption = '&Load...'
    TabOrder = 0
    OnClick = btnLoadClick
  end
  object cbKinds: TComboBox
    Left = 158
    Top = 296
    Width = 203
    Height = 24
    Anchors = [akLeft, akBottom]
    Enabled = False
    ItemHeight = 16
    TabOrder = 1
    OnChange = cbKindsChange
    OnCloseUp = cbKindsCloseUp
    Items.Strings = (
      'ACCELERATOR'
      'ANICURSOR'
      'ANIICON'
      'BITMAP'
      'CURSOR'
      'DIALOG'
      'DLGINCLUDE'
      'FONT'
      'FONTDIR'
      'GROUP_CURSOR'
      'GROUP_ICON'
      'GROUP_ICON'
      'MENU'
      'MESSAGETABLE'
      'RCDATA'
      'STRING'
      'PLUGPLAY'
      'VXD'
      'HTML'
      '24'
      'ICON')
  end
  object btOK: TBitBtn
    Left = 654
    Top = 294
    Width = 87
    Height = 31
    Anchors = [akRight]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btOKClick
  end
  object btCancel: TBitBtn
    Left = 559
    Top = 294
    Width = 87
    Height = 31
    Anchors = [akRight]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 3
    OnClick = btCancelClick
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 734
    Height = 272
    ActivePage = TabItems
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
    OnChange = PageControlChange
    object TabItems: TTabSheet
      Caption = '&Items'
      object ListView: TListView
        Left = 0
        Top = 0
        Width = 726
        Height = 241
        Align = alClient
        Columns = <
          item
            Caption = 'Name :'
            Width = 172
          end
          item
            Caption = 'Kind :'
            Width = 172
          end
          item
            Caption = 'File :'
            Width = 172
          end>
        MultiSelect = True
        RowSelect = True
        PopupMenu = PopupMenu
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListViewClick
        OnColumnClick = ListViewColumnClick
        OnDblClick = ListViewDblClick
        OnEdited = ListViewEdited
        OnResize = ListViewResize
      end
    end
    object TabSource: TTabSheet
      Caption = '&Source'
      ImageIndex = 1
      object RCSource: TSynEdit
        Left = 0
        Top = 0
        Width = 726
        Height = 241
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -13
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Highlighter = RC
      end
    end
    object TabView: TTabSheet
      Caption = '&View'
      ImageIndex = 2
      object ImageEdit: TImage
        Left = 8
        Top = 16
        Width = 209
        Height = 201
        Stretch = True
      end
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 260
    Top = 138
    object menuLoad: TMenuItem
      Caption = '&Load...'
      OnClick = menuLoadClick
    end
    object menuRemove: TMenuItem
      Caption = '&Remove'
      OnClick = menuRemoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuClear: TMenuItem
      Caption = '&Clear'
      OnClick = menuClearClick
    end
  end
  object RC: TSynRCSyn
    Left = 324
    Top = 139
  end
end
