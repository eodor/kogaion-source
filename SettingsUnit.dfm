object Settings: TSettings
  Left = 412
  Top = 162
  Width = 581
  Height = 466
  BorderStyle = bsSizeToolWin
  Caption = 'Settings'
  Color = clBtnFace
  Constraints.MinHeight = 466
  Constraints.MinWidth = 581
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    563
    421)
  PixelsPerInch = 115
  TextHeight = 16
  object PageControl: TPageControl
    Left = 9
    Top = 3
    Width = 546
    Height = 374
    ActivePage = TabGeneral
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabGeneral: TTabSheet
      Caption = '&General '
      DesignSize = (
        538
        343)
      object LabelFilter: TLabel
        Left = 6
        Top = 294
        Width = 34
        Height = 16
        Anchors = [akLeft, akBottom]
        Caption = '&Filter:'
      end
      object LabelDBMaskFiles: TLabel
        Left = 348
        Top = 89
        Width = 113
        Height = 16
        Anchors = [akTop, akRight]
        Caption = '&DataBase mask file:'
      end
      object cbMinimizeOnRun: TCheckBox
        Left = 9
        Top = 9
        Width = 261
        Height = 22
        Caption = '&Minimize on Run'
        TabOrder = 0
      end
      object cbDisableOnRun: TCheckBox
        Left = 9
        Top = 32
        Width = 261
        Height = 21
        Caption = '&Disable on Run'
        TabOrder = 1
      end
      object cbEditOptionsGlobal: TCheckBox
        Left = 9
        Top = 55
        Width = 261
        Height = 20
        Caption = '&Edit Options are Global'
        TabOrder = 2
      end
      object cbDesignerOptionsGlobal: TCheckBox
        Left = 9
        Top = 78
        Width = 261
        Height = 20
        Caption = '&Designer Options are Global'
        TabOrder = 3
      end
      object btClearMRUFiles: TBitBtn
        Left = 349
        Top = 7
        Width = 171
        Height = 31
        Anchors = [akTop, akRight]
        Caption = 'Clear MRU &Files'
        TabOrder = 4
        OnClick = btClearMRUFilesClick
      end
      object btClearMRUExe: TBitBtn
        Left = 349
        Top = 41
        Width = 171
        Height = 30
        Anchors = [akTop, akRight]
        Caption = 'Clear MRU &Exes'
        TabOrder = 5
        OnClick = btClearMRUExeClick
      end
      object cbxFilters: TComboBox
        Left = 55
        Top = 294
        Width = 467
        Height = 24
        Anchors = [akLeft, akRight, akBottom]
        ItemHeight = 16
        TabOrder = 6
        OnCloseUp = cbxFiltersCloseUp
      end
      object cbResourcesEmbed: TCheckBox
        Left = 9
        Top = 101
        Width = 261
        Height = 20
        Caption = '&Resources embed automaticaly'
        TabOrder = 7
      end
      object cbConjoin: TCheckBox
        Left = 9
        Top = 123
        Width = 261
        Height = 22
        Caption = '&Conjoin with hex or dialog file'
        TabOrder = 8
      end
      object cbAlowMultipleFileInstances: TCheckBox
        Left = 9
        Top = 146
        Width = 261
        Height = 21
        Caption = '&Alow multiple file instances'
        TabOrder = 9
      end
      object cbDataBaseOnLoad: TCheckBox
        Left = 9
        Top = 169
        Width = 261
        Height = 21
        Caption = '&DataBase are scannig on load'
        TabOrder = 10
      end
      object cbxDBMaskFile: TComboBox
        Left = 349
        Top = 111
        Width = 169
        Height = 24
        Anchors = [akTop, akRight]
        ItemHeight = 16
        TabOrder = 11
        Text = '*.*'
        OnKeyDown = cbxDBMaskFileKeyDown
      end
      object cbTerminateOnExit: TCheckBox
        Left = 9
        Top = 192
        Width = 378
        Height = 21
        Caption = '&Terminate on Exit(be aware is fast terminate process)'
        TabOrder = 12
      end
      object cbAlowCompletion: TCheckBox
        Left = 9
        Top = 215
        Width = 377
        Height = 17
        Caption = 'Alow &Completion Proposal'
        TabOrder = 13
      end
      object cbxReadScriptFolder: TCheckBox
        Left = 9
        Top = 238
        Width = 394
        Height = 19
        Caption = '&Read Script Folder'
        TabOrder = 14
      end
      object cbxShowOnlyOneError: TCheckBox
        Left = 9
        Top = 262
        Width = 394
        Height = 19
        Caption = 'Show Only &One Error'
        TabOrder = 15
      end
    end
    object TabDesigner: TTabSheet
      Caption = '&Designer '
      ImageIndex = 1
      object LabelXStep: TLabel
        Left = 7
        Top = 15
        Width = 43
        Height = 16
        Caption = 'Step &X:'
      end
      object LabelYStep: TLabel
        Left = 7
        Top = 59
        Width = 42
        Height = 16
        Caption = 'Step &Y:'
      end
      object LabelColor: TLabel
        Left = 7
        Top = 103
        Width = 39
        Height = 16
        Caption = '&Color :'
      end
      object EditX: TEdit
        Left = 66
        Top = 15
        Width = 68
        Height = 24
        TabOrder = 0
        Text = '0'
      end
      object EditY: TEdit
        Left = 66
        Top = 59
        Width = 68
        Height = 24
        TabOrder = 1
        Text = '0'
      end
      object UpDownX: TUpDown
        Left = 134
        Top = 15
        Width = 20
        Height = 24
        Associate = EditX
        TabOrder = 2
      end
      object UpDownY: TUpDown
        Left = 134
        Top = 59
        Width = 20
        Height = 24
        Associate = EditY
        TabOrder = 3
      end
      object PanelColor: TPanel
        Left = 66
        Top = 103
        Width = 91
        Height = 26
        Cursor = crHandPoint
        ParentBackground = False
        TabOrder = 4
        OnClick = PanelColorClick
      end
      object cbGridVisible: TCheckBox
        Left = 7
        Top = 149
        Width = 150
        Height = 20
        Caption = 'Grid &Visible'
        TabOrder = 5
      end
    end
    object TabCompiler: TTabSheet
      Caption = '&Compiler'
      ImageIndex = 2
      DesignSize = (
        538
        343)
      object LabelPzth: TLabel
        Left = 7
        Top = 22
        Width = 30
        Height = 16
        Caption = '&Path:'
      end
      object LabelSwitch: TLabel
        Left = 7
        Top = 66
        Width = 43
        Height = 16
        Caption = '&Switch:'
      end
      object LabelFileInfo: TLabel
        Left = 15
        Top = 192
        Width = 4
        Height = 16
      end
      object cbxCompilers: TComboBox
        Left = 74
        Top = 22
        Width = 404
        Height = 24
        AutoCloseUp = True
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 0
        OnChange = cbxCompilersChange
      end
      object btCompiler: TBitBtn
        Left = 486
        Top = 21
        Width = 31
        Height = 26
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btCompilerClick
      end
      object cbxSwitches: TComboBox
        Left = 74
        Top = 66
        Width = 404
        Height = 24
        AutoCloseUp = True
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 2
        OnCloseUp = cbxSwitchesCloseUp
      end
      object cbRunWithDebug: TCheckBox
        Left = 74
        Top = 111
        Width = 171
        Height = 22
        Caption = 'Run with Debugger'
        TabOrder = 3
      end
      object btnAddExclusion: TBitBtn
        Left = 342
        Top = 149
        Width = 174
        Height = 29
        Hint = 
          'Add to compiler exclusions list, '#13#10'compiler wont terminate this ' +
          'process'
        Anchors = [akTop, akRight]
        Caption = '&Add to exclusion list'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Visible = False
        OnClick = btnAddExclusionClick
      end
    end
    object TabApplication: TTabSheet
      Caption = '&Application'
      ImageIndex = 3
      DesignSize = (
        538
        343)
      object LabelAppHelpFile: TLabel
        Left = 7
        Top = 112
        Width = 51
        Height = 16
        Caption = '&Help file:'
      end
      object btnIcon: TBitBtn
        Left = 89
        Top = 16
        Width = 92
        Height = 31
        Caption = '&Icon'
        TabOrder = 1
        OnClick = btnIconClick
      end
      object PanelImage: TPanel
        Left = 7
        Top = 14
        Width = 75
        Height = 75
        BevelOuter = bvLowered
        TabOrder = 0
        object Image: TImage
          Left = 0
          Top = 0
          Width = 75
          Height = 75
          Cursor = crHandPoint
          Center = True
          ParentShowHint = False
          ShowHint = True
          OnClick = ImageClick
        end
      end
      object cbxAppHelpFile: TComboBox
        Left = 74
        Top = 112
        Width = 454
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        TabOrder = 2
      end
    end
    object TabSheet1: TTabSheet
      Caption = '&Directories/Conditionals'
      ImageIndex = 4
      DesignSize = (
        538
        343)
      object LabelDirs: TLabel
        Left = 8
        Top = 48
        Width = 66
        Height = 16
        Caption = '&Directories:'
      end
      object ListBoxDirs: TListBox
        Left = 8
        Top = 68
        Width = 521
        Height = 227
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 16
        TabOrder = 0
      end
      object btnAddDir: TBitBtn
        Left = 7
        Top = 302
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&Add...'
        TabOrder = 1
        OnClick = btnAddDirClick
      end
      object btnLibrary: TBitBtn
        Left = 449
        Top = 7
        Width = 75
        Height = 25
        Anchors = [akRight]
        Caption = '&Library'
        TabOrder = 2
        OnClick = btnLibraryClick
      end
      object edLibrary: TEdit
        Left = 8
        Top = 7
        Width = 433
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
      end
    end
  end
  object btCancel: TBitBtn
    Left = 347
    Top = 383
    Width = 92
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 1
    OnClick = btCancelClick
  end
  object btOK: TBitBtn
    Left = 455
    Top = 383
    Width = 92
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btOKClick
  end
end
