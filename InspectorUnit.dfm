object Inspector: TInspector
  Left = 8
  Top = 316
  Width = 317
  Height = 373
  BorderStyle = bsSizeToolWin
  Caption = #39
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 115
  TextHeight = 16
  object Splitter: TSplitter
    Left = 0
    Top = 301
    Width = 299
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object ObjectsBox: TComboBoxAx
    Left = 0
    Top = 0
    Width = 299
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 0
    OnChange = ObjectsBoxChange
    Align = alTop
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 309
    Width = 299
    Height = 19
    Panels = <>
  end
  object PageControl: TPageControl
    Left = 0
    Top = 24
    Width = 299
    Height = 277
    ActivePage = TabProperties
    Align = alClient
    TabOrder = 2
    object TabProperties: TTabSheet
      Caption = '&Properties'
      object Properties: TELPropertyInspector
        Left = 0
        Top = 0
        Width = 291
        Height = 246
        Splitter = 84
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        OnFilterProp = PropertiesFilterProp
        OnModified = PropertiesModified
      end
    end
    object TabEvents: TTabSheet
      Caption = '&Events'
      ImageIndex = 1
      object ListView: TListView
        Left = 0
        Top = 0
        Width = 291
        Height = 246
        Align = alClient
        Checkboxes = True
        Color = clBtnFace
        Columns = <
          item
            MinWidth = 50
            Width = 200
          end
          item
            AutoSize = True
          end>
        RowSelect = True
        ShowColumnHeaders = False
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = ListViewDblClick
      end
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 305
    Width = 299
    Height = 4
    Align = alBottom
    Color = clMenuBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object PopupMenu: TPopupMenu
    Left = 188
    Top = 139
    object menuFont: TMenuItem
      Caption = '&Font...'
      OnClick = menuFontClick
    end
  end
end
