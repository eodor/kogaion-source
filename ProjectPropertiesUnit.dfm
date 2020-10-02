object ProjectProperties: TProjectProperties
  Left = 468
  Top = 194
  BorderStyle = bsToolWindow
  Caption = 'Project Properties'
  ClientHeight = 318
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 115
  TextHeight = 16
  object PageControl: TPageControl
    Left = 9
    Top = 5
    Width = 528
    Height = 273
    ActivePage = TabGeneral
    TabOrder = 0
    object TabGeneral: TTabSheet
      Caption = '&General'
      DesignSize = (
        520
        242)
      object LabelHelpFile: TLabel
        Left = 14
        Top = 143
        Width = 54
        Height = 16
        Caption = '&Help File:'
      end
      object PanelIcon: TPanel
        Left = 9
        Top = 18
        Width = 128
        Height = 119
        BevelOuter = bvNone
        BorderStyle = bsSingle
        TabOrder = 0
        object ImageIcon: TImage
          Left = 0
          Top = 0
          Width = 124
          Height = 115
          Align = alClient
          Center = True
          ParentShowHint = False
          ShowHint = True
        end
      end
      object btnIcon: TBitBtn
        Left = 169
        Top = 23
        Width = 129
        Height = 28
        Caption = '&Browse Icon...'
        TabOrder = 1
        OnClick = btnIconClick
      end
      object cbxHelpFiles: TComboBox
        Left = 14
        Top = 166
        Width = 455
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        TabOrder = 2
      end
      object btnBrowseHelp: TBitBtn
        Left = 469
        Top = 166
        Width = 33
        Height = 22
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
        520
        242)
      object CheckListBox: TCheckListBox
        Left = 0
        Top = 0
        Width = 519
        Height = 206
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 16
        TabOrder = 0
      end
      object btnAdd: TBitBtn
        Left = 104
        Top = 208
        Width = 86
        Height = 29
        Hint = 'Set an include file to each file from project'
        Anchors = [akLeft, akBottom]
        Caption = '&Add File..'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnAddPath: TBitBtn
        Left = 8
        Top = 208
        Width = 86
        Height = 29
        Hint = 'Set an search global search path'
        Anchors = [akLeft, akBottom]
        Caption = '&Add Path..'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnAddPathClick
      end
    end
    object TabCompiler: TTabSheet
      Caption = '&Compiler'
      ImageIndex = 2
      object LabelOutExt: TLabel
        Left = 260
        Top = 4
        Width = 117
        Height = 16
        Caption = 'Output file extension'
      end
      object LabelDefInfo: TLabel
        Left = 260
        Top = 88
        Width = 117
        Height = 16
        Caption = 'without '#39'#'#39
      end
      object cbxDebugInfo: TCheckBox
        Left = 16
        Top = 8
        Width = 241
        Height = 17
        Caption = 'Compile with debuginfo'
        TabOrder = 0
      end
      object cbxCompileOnly: TCheckBox
        Left = 16
        Top = 28
        Width = 241
        Height = 17
        Caption = 'Compile only, do not link'
        TabOrder = 1
      end
      object cbxPreserveO: TCheckBox
        Left = 16
        Top = 48
        Width = 241
        Height = 17
        Caption = 'Preserve temporary .o files'
        TabOrder = 2
      end
      object cbxGlobalDef: TCheckBox
        Left = 16
        Top = 68
        Width = 241
        Height = 17
        Caption = 'Add a global #define'
        TabOrder = 3
      end
      object gdefName: TEdit
        Left = 260
        Top = 64
        Width = 121
        Height = 24
        Hint = 'Global define name'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object gdefValue: TEdit
        Left = 388
        Top = 64
        Width = 121
        Height = 24
        Hint = 'Global define value'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object cbxErrorCheck: TCheckBox
        Left = 16
        Top = 88
        Width = 241
        Height = 17
        Caption = 'Enable runtime error checking'
        TabOrder = 6
      end
      object cbxFBDebug: TCheckBox
        Left = 16
        Top = 108
        Width = 241
        Height = 17
        Caption = 'Enable __FB_DEBUG_'
        TabOrder = 7
      end
      object cbxNullPtr: TCheckBox
        Left = 16
        Top = 148
        Width = 241
        Height = 17
        Caption = '-ex plus array bounds/null-pointer checking'
        TabOrder = 8
      end
      object cbxAddDebug: TCheckBox
        Left = 16
        Top = 188
        Width = 241
        Height = 17
        Caption = 'Add debug info, enable __FB_DEBUG__, and enable assert()'
        TabOrder = 9
      end
      object cbxResumeError: TCheckBox
        Left = 16
        Top = 128
        Width = 241
        Height = 17
        Caption = '-e plus RESUME support'
        TabOrder = 10
      end
      object cbxPrefixPath: TCheckBox
        Left = 16
        Top = 208
        Width = 241
        Height = 17
        Caption = 'Set the compiler prefix path'
        TabOrder = 11
      end
      object edOutExt: TEdit
        Left = 260
        Top = 20
        Width = 121
        Height = 24
        TabOrder = 12
      end
      object cbxArrayCheck: TCheckBox
        Left = 16
        Top = 168
        Width = 241
        Height = 17
        Caption = '-earray plus array bounds checking'
        TabOrder = 13
      end
    end
  end
  object btnOK: TBitBtn
    Left = 447
    Top = 284
    Width = 86
    Height = 28
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 351
    Top = 284
    Width = 86
    Height = 28
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
end
