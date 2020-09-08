object Projects: TProjects
  Left = 190
  Top = 166
  Width = 282
  Height = 237
  BorderStyle = bsSizeToolWin
  Caption = 'Projects'
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
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 264
    Height = 29
    Caption = 'ToolBar'
    Images = ImageList
    TabOrder = 0
    object s3: TToolButton
      Left = 0
      Top = 2
      Width = 8
      Caption = 's3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object tbNewProject: TToolButton
      Left = 8
      Top = 2
      Hint = 'New Project'
      Caption = 'tbNewProject'
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = tbNewProjectClick
    end
    object tbRemoveProject: TToolButton
      Left = 31
      Top = 2
      Hint = 'Remove Project'
      Caption = 'tbRemoveProject'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = tbRemoveProjectClick
    end
    object s1: TToolButton
      Left = 54
      Top = 2
      Width = 8
      Caption = 's1'
      Style = tbsSeparator
    end
    object tbAddInProject: TToolButton
      Left = 62
      Top = 2
      Hint = 'Add file to Project'
      Caption = 'tbAddInProject'
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = tbAddInProjectClick
    end
    object tbRemoveFromProject: TToolButton
      Left = 85
      Top = 2
      Hint = 'Remove file from Project'
      Caption = 'tbRemoveFromProject'
      ImageIndex = 3
      ParentShowHint = False
      ShowHint = True
      OnClick = tbRemoveFromProjectClick
    end
    object s4: TToolButton
      Left = 108
      Top = 2
      Width = 8
      Caption = 's4'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object tbViewSource: TToolButton
      Left = 116
      Top = 2
      Hint = 'View Project source'
      Caption = 'tbViewSource'
      ImageIndex = 4
      ParentShowHint = False
      ShowHint = True
      OnClick = tbViewSourceClick
    end
    object s2: TToolButton
      Left = 139
      Top = 2
      Width = 8
      Caption = 's2'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object tbProjectProperties: TToolButton
      Left = 147
      Top = 2
      Hint = 'Project properties'
      Caption = 'tbProjectProperties'
      ImageIndex = 5
      ParentShowHint = False
      ShowHint = True
    end
  end
  object TreeView: TTreeView
    Left = 0
    Top = 29
    Width = 264
    Height = 163
    Align = alClient
    HideSelection = False
    Images = ImageList
    Indent = 21
    PopupMenu = PopupMenu
    TabOrder = 1
    OnClick = TreeViewClick
    OnEdited = TreeViewEdited
    OnEditing = TreeViewEditing
  end
  object ImageList: TImageList
    Left = 98
    Top = 56
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D8D8D800BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00D9D9D90000000000000000000000000000000000E2E2E200CFCFCF00CFCF
      CF00CFCFCF00CFCFCF00CFCFCF00CFCFCF00CFCFCF00CFCFCF00CFCFCF00CFCF
      CF00E3E3E300EEEEEE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEEEEE002CCBDD002CCADC002CCA
      DC002CCADC002CCADC002CCADC002CCADC002CCADC002CCADC0022C5D80035BE
      CB009A7E6A00D9D9D9000000000000000000F9F9F900A87655009F6742009F67
      42009F6742009F6742009F6742009F6742009F6742009F6742009F6742009F67
      4200C19D8500E3E3E30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC002DCBDC0082E8F80079E7
      F70079E7F70070E5F60066E3F6005DE1F5005DE1F5003DD7EC001DCADF005EE2
      F50037C0CC00A6A6A600F4F4F40000000000EBEBEB00BF784C00FEE9DC00FEDB
      C600FEDBC600FDDAC300FECDAF00FECDAF00FECCAE00FECBAC00FECBAC00FECA
      A9009F674200CFCFCF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC002DCBDC008CEAF80082E8
      F80079E7F70079E7F70070E5F60066E3F6005DE1F50043D8EC001DCADF0063E3
      F50063E3F5003DCEDF00CCCCCC00F4F4F400EBEBEB00BF784C00FEEBDE009F53
      34009F533400FEE1CF009F5130009F5130009F4F2D009F4E2D009F4E2D00FECB
      AC009F674200CFCFCF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC0034CCDE008CEAF8008CEA
      F80082E8F80079E7F70070E5F60070E5F60066E3F60043D8EC001DCADF0079E8
      F70063E3F5005EE2F50044D5E600E9E9E900EBEBEB00BF784C00FEECE000FEEB
      DE00FEE9DC00FEE9DC00FEE8DA00FDDAC300FDDAC300FDD9C100FECCAE00FECC
      AE009F674200CFCFCF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC003CCEDF0095ECF9007F7F
      7F007F7F7F0082E8F8007F7F7F0070E5F6007F7F7F007F7F7F007F7F7F001DCA
      DF001DCADF001DCADF0030D1E400E0E0E000EBEBEB00BF784C00FEECE0009F53
      35009F533500FEE9DC009F5334009F5334009F5132009F5130009F503000FECC
      AE009F674200CFCFCF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC004AD2E1009EEEFA0095EC
      F9008CEAF8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8
      EC003DD7EC003DD7EC0030D1E400E0E0E000EBEBEB00BF784C00FEEEE300FEEC
      E000FEECE000FEEBDE00FEE9DC00FEE9DC00FEE8DA00F2C3AB00FDDAC300FDD9
      C1009F674200CFCFCF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC004AD2E1009EEEFA007F7F
      7F0095ECF9007F7F7F007F7F7F007F7F7F0079E7F7007F7F7F007F7F7F0066E3
      F6005DE1F50053E0F50030D1E400E0E0E000EBEBEB00BF784C00FEEFE500BC82
      6A00BC826A00FEECE000BC826800BC816700BA7A600006090B00C07C5E00FDDA
      C3009F674200CFCFCF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC004AD2E100A6EFFA009EEE
      FA009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60066E3
      F60066E3F6005DE1F50030D1E400D4D4D400EBEBEB00BF784C00FEF1E7000000
      000006090B00FEEEE300FEECE000F8DBCB000000000022A0DF0006090B00E9B3
      99005D331900CFCFCF00F9F9F900F1F1F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC0060D8E500A6EFFA007F7F
      7F007F7F7F007F7F7F0095ECF9007F7F7F0082E8F8007F7F7F007F7F7F0070E5
      F60066E3F60066E3F6002ECFE30000008900EBEBEB00BF784C00FEF1E7003048
      570057B8EC0006090B00F8DECF000000000022A0DF000000000022A0DF000609
      0B0006090B002D2F3100CFCFEB0000009C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDCDC0060D8E500A6EFFA00B4F0
      FA00A6EFFA009EEEFA0095ECF90095ECF9008CEAF80082E8F80082E8F80079E7
      F70070E5F60066E3F60025C6DB0003039400EBEBEB00BF784C00FEF2EA00FEF1
      E7003048570057B8EC000B111500959497000000000022A0DF00000000002090
      CA00208FC800208FC800000033000303A9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E8E8E80072DDE900A6EFFA007F7F
      7F00ACF0FA007F7F7F007F7F7F0095ECF9007F7F7F007F7F7F007F7F7F0079E7
      F70079E7F70070E5F60025CAE1000707A000F7F7F700C5845C00BF784C00BF78
      4C00BF784C003048570057B8EC000B1115009A847800000000002096D1002096
      D1002096D1002096D1000061C4000808B6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF0075E2F000A6EFFA00B2F0
      FA00AEF0FA00B0F0FA00AEF0FA00AAF0FA0095ECF90095ECF9008CEAF80082E8
      F80079E7F70079E7F70025CAE1001A1ACE0000000000F7F7F700EBEBEB00EBEB
      EB00EBEBEB00EBEBEB003048570057B8EC000B11150030A6E10030A6E10030A6
      E10030A6E10030A6E1000061C4001E1EEB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF0081E5F200A6EFFA00A6EF
      FA00A6EFFA00A6EFFA00A6EFFA00A6EFFA009EEEFA0095ECF90095ECF9008CEA
      F80082E8F80079E7F70025C6DB002121E0000000000000000000000000000000
      00000000000000000000EBEBEB004B606D004380A10053ADDD0057B8EC0057B8
      EC0057B8EC0057B8EC00000033002525FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F4F40099EAF50081E5F20075E2
      F00075E2F00063DEED0063DEED004DD8E90047D2E40045D1E30043CEDF0035CA
      DD002DC8DC0026C7DA002ECFE3002323F4000000000000000000000000000000
      0000000000000000000000000000F4F4F400697A8500475C6A0010181D001018
      1D0010181D0010181D00CFCFEB002525FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F4F4F400EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00F4F4F400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D8D8D800BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00D9D9D90000000000000000000000000000000000241CED00241CED00BDBD
      BD00BDBDBD00BDBDBD00241CED00241CED00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00D9D9D90000000000000000000000000000000000D8D8D800BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00D9D9D90000000000000000000000000000000000D8D8D800BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00D9D9D900000000000000000000000000EEEEEE002CCBDD002CCADC002CCA
      DC002CCADC002CCADC002CCADC002CCADC002CCADC002CCADC0022C5D80035BE
      CB009A7E6A00D9D9D9000000000000000000EEEEEE002CCBDD00241CED00241C
      ED002CCADC00241CED00241CED002CCADC002CCADC002CCADC0022C5D80035BE
      CB009A7E6A00D9D9D9000000000000000000EEEEEE002CCBDD002CCADC002CCA
      DC002CCADC002CCADC002CCADC002CCADC002CCADC002CCADC0022C5D80035BE
      CB009A7E6A00D9D9D9000000000000000000EEEEEE002CCBDD002CCADC002CCA
      DC002CCADC002CCADC002CCADC002CCADC002CCADC002CCADC0022C5D80035BE
      CB009A7E6A00D9D9D9000000000000000000DCDCDC002DCBDC0082E8F80079E7
      F70079E7F70070E5F60066E3F6005DE1F5005DE1F5003DD7EC001DCADF005EE2
      F50037C0CC00A6A6A600F4F4F40000000000DCDCDC002DCBDC0082E8F800241C
      ED00241CED00241CED0066E3F6005DE1F5005DE1F5003DD7EC001DCADF005EE2
      F50037C0CC00A6A6A600F4F4F40000000000DCDCDC002DCBDC0082E8F80079E7
      F70079E7F70070E5F60066E3F6005DE1F5005DE1F5003DD7EC001DCADF005EE2
      F50037C0CC00A6A6A600F4F4F40000000000DCDCDC002DCBDC0082E8F80079E7
      F70079E7F70070E5F60066E3F6005DE1F5005DE1F5003DD7EC001DCADF005EE2
      F50037C0CC00A6A6A600F4F4F40000000000DCDCDC002DCBDC008CEAF80082E8
      F80079E7F70079E7F70070E5F60066E3F6005DE1F50043D8EC001DCADF0063E3
      F50063E3F5003DCEDF00CCCCCC00F4F4F400DCDCDC002DCBDC008CEAF800241C
      ED00241CED00241CED0070E5F60066E3F6005DE1F50043D8EC001DCADF0063E3
      F50063E3F5003DCEDF00CCCCCC00F4F4F400DCDCDC002DCBDC008CEAF80082E8
      F80079E7F70079E7F70070E5F60066E3F6005DE1F50043D8EC001DCADF0063E3
      F50063E3F5003DCEDF00CCCCCC00F4F4F400DCDCDC002DCBDC008CEAF80082E8
      F80079E7F70079E7F70070E5F60066E3F6005DE1F50043D8EC001DCADF0063E3
      F50063E3F5003DCEDF00CCCCCC00F4F4F400DCDCDC0034CCDE008CEAF8008CEA
      F80082E8F80079E7F70070E5F60070E5F60066E3F60043D8EC001DCADF0079E8
      F70063E3F5005EE2F50044D5E600E9E9E900DCDCDC0034CCDE00241CED00241C
      ED0082E8F800241CED00241CED0070E5F60066E3F60043D8EC001DCADF0079E8
      F70063E3F5005EE2F50044D5E600E9E9E900DCDCDC0034CCDE008CEAF8008CEA
      F80082E8F80079E7F70070E5F60070E5F60066E3F60043D8EC001DCADF0079E8
      F70063E3F5005EE2F50044D5E600E9E9E900DCDCDC0034CCDE008CEAF8008CEA
      F80082E8F80079E7F70070E5F60070E5F60066E3F60043D8EC001DCADF0079E8
      F70063E3F5005EE2F50044D5E600E9E9E900DCDCDC003CCEDF0095ECF9008CEA
      F8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8EC001DCA
      DF001DCADF001DCADF0030D1E400E0E0E000DCDCDC00241CED00241CED008CEA
      F8008CEAF80082E8F800241CED00241CED0070E5F60055DDF00043D8EC001DCA
      DF001DCADF001DCADF0030D1E400E0E0E000DCDCDC003CCEDF0095ECF9008CEA
      F8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8EC001DCA
      DF001DCADF001DCADF0030D1E400E0E0E000DCDCDC003CCEDF0095ECF9008CEA
      F8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8EC001DCA
      DF001DCADF001DCADF0030D1E400E0E0E000DCDCDC004AD2E1009EEEFA0095EC
      F9008CEAF8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8
      EC003DD7EC003DD7EC0030D1E400E0E0E000241CED00241CED009EEEFA0095EC
      F9008CEAF8008CEAF80082E8F800241CED00241CED0070E5F60055DDF00043D8
      EC003DD7EC003DD7EC0030D1E400E0E0E000DCDCDC004AD2E1009EEEFA0095EC
      F9008CEAF8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8
      EC003DD7EC003DD7EC0030D1E400E0E0E000DCDCDC004AD2E1009EEEFA0095EC
      F9008CEAF8008CEAF80082E8F80079E7F70070E5F60070E5F60055DDF00043D8
      EC003DD7EC003DD7EC0030D1E400E0E0E000DCDCDC004AD2E1009EEEFA009EEE
      FA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60070E5F60066E3
      F6005DE1F50053E0F50030D1E400E0E0E000241CED004AD2E1009EEEFA009EEE
      FA0095ECF9008CEAF80082E8F80082E8F800241CED0070E5F60070E5F60066E3
      F6005DE1F50053E0F50030D1E400E0E0E000DCDCDC004AD2E1009EEEFA009EEE
      FA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60070E5F60066E3
      F6005DE1F50053E0F50030D1E400E0E0E000DCDCDC004AD2E1009EEEFA009EEE
      FA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60070E5F60066E3
      F6005DE1F50053E0F50030D1E400E0E0E000DCDCDC004AD2E100A6EFFA009EEE
      FA009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60066E3
      F60066E3F6005DE1F50030D1E400D4D4D400DCDCDC004AD2E100A6EFFA009EEE
      FA009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60066E3
      F60066E3F6005DE1F50030D1E400D4D4D400DCDCDC004AD2E100A6EFFA004CB1
      22004CB1220095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60066E3
      F60066E3F6005DE1F50030D1E400D4D4D400DCDCDC004AD2E100A6EFFA009EEE
      FA009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5F60066E3
      F60066E3F6005DE1F50030D1E400D4D4D400DCDCDC0060D8E500A6EFFA00ACF0
      FA009EEEFA009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5
      F60066E3F60066E3F6002ECFE30000008900DCDCDC0060D8E500A6EFFA00ACF0
      FA009EEEFA009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5
      F60066E3F60066E3F6002ECFE30000008900DCDCDC0060D8E500A6EFFA004CB1
      22004CB122009EEEFA0095ECF9008CEAF80082E8F80082E8F80079E7F70070E5
      F60066E3F60066E3F6002ECFE30000008900241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED00241CED00241CED0082E8F80079E7F70070E5
      F60066E3F60066E3F6002ECFE30000008900DCDCDC0060D8E500A6EFFA00B4F0
      FA00A6EFFA009EEEFA0095ECF90095ECF9008CEAF80082E8F80082E8F80079E7
      F70070E5F60066E3F60025C6DB0003039400DCDCDC0060D8E500A6EFFA00B4F0
      FA00A6EFFA009EEEFA0095ECF90095ECF9008CEAF80082E8F80082E8F80079E7
      F70070E5F60066E3F60025C6DB0003039400DCDCDC0060D8E500A6EFFA004CB1
      22004CB122009EEEFA0095ECF90095ECF9008CEAF80082E8F80082E8F80079E7
      F70070E5F60066E3F60025C6DB0003039400241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED00241CED00241CED0082E8F80082E8F80079E7
      F70070E5F60066E3F60025C6DB0003039400E8E8E80072DDE900A6EFFA00B0F0
      FA00ACF0FA00A6EFFA009EEEFA0095ECF90095ECF9008CEAF80082E8F80079E7
      F70079E7F70070E5F60025CAE1000707A000E8E8E80072DDE900A6EFFA00B0F0
      FA00ACF0FA00A6EFFA009EEEFA0095ECF90095ECF9008CEAF80082E8F80079E7
      F70079E7F70070E5F60025CAE1000707A0004CB122004CB122004CB122004CB1
      22004CB122004CB122004CB122004CB1220095ECF9008CEAF80082E8F80079E7
      F70079E7F70070E5F60025CAE1000707A000241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED00241CED00241CED008CEAF80082E8F80079E7
      F70079E7F70070E5F60025CAE1000707A000EFEFEF0075E2F000A6EFFA00B2F0
      FA00AEF0FA00B0F0FA00AEF0FA00AAF0FA0095ECF90095ECF9008CEAF80082E8
      F80079E7F70079E7F70025CAE1001A1ACE00EFEFEF0075E2F000A6EFFA00B2F0
      FA00AEF0FA00B0F0FA00AEF0FA00AAF0FA0095ECF90095ECF9008CEAF80082E8
      F80079E7F70079E7F70025CAE1001A1ACE004CB122004CB122004CB122004CB1
      22004CB122004CB122004CB122004CB122008CEAF8008CEAF8008CEAF80082E8
      F80079E7F70079E7F70025CAE1001A1ACE00EFEFEF0075E2F000A6EFFA00B2F0
      FA00AEF0FA00B0F0FA00AEF0FA00AAF0FA0095ECF90095ECF9008CEAF80082E8
      F80079E7F70079E7F70025CAE1001A1ACE00EFEFEF0081E5F200A6EFFA00A6EF
      FA00A6EFFA00A6EFFA00A6EFFA00A6EFFA009EEEFA0095ECF90095ECF9008CEA
      F80082E8F80079E7F70025C6DB002121E000EFEFEF0081E5F200A6EFFA00A6EF
      FA00A6EFFA00A6EFFA00A6EFFA00A6EFFA009EEEFA0095ECF90095ECF9008CEA
      F80082E8F80079E7F70025C6DB002121E000EFEFEF0081E5F200A6EFFA004CB1
      22004CB12200A6EFFA00A6EFFA00A6EFFA009EEEFA0095ECF90095ECF9008CEA
      F80082E8F80079E7F70025C6DB002121E000EFEFEF0081E5F200A6EFFA00A6EF
      FA00A6EFFA00A6EFFA00A6EFFA00A6EFFA009EEEFA0095ECF90095ECF9008CEA
      F80082E8F80079E7F70025C6DB002121E000F4F4F40099EAF50081E5F20075E2
      F00075E2F00063DEED0063DEED004DD8E90047D2E40045D1E30043CEDF0035CA
      DD002DC8DC0026C7DA002ECFE3002323F400F4F4F40099EAF50081E5F20075E2
      F00075E2F00063DEED0063DEED004DD8E90047D2E40045D1E30043CEDF0035CA
      DD002DC8DC0026C7DA002ECFE3002323F400F4F4F40099EAF50081E5F2004CB1
      22004CB1220063DEED0063DEED004DD8E90047D2E40045D1E30043CEDF0035CA
      DD002DC8DC0026C7DA002ECFE3002323F400F4F4F40099EAF50081E5F20075E2
      F00075E2F00063DEED0063DEED004DD8E90047D2E40045D1E30043CEDF0035CA
      DD002DC8DC0026C7DA002ECFE3002323F40000000000F4F4F400EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00F4F4F4000000000000000000F4F4F400EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00F4F4F4000000000000000000F4F4F400EEEEEE004CB1
      22004CB12200EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00F4F4F4000000000000000000F4F4F400EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00F4F4F40000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080078003000000000003000300000000
      0001000300000000000000030000000000000003000000000000000300000000
      0000000300000000000000030000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000FC0000000000
      0000FE00000000008001FFFF0000000080078007800780070003000300030003
      0001000100010001000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000800180018001800100000000000000000000000000000000
      000000000000}
  end
  object PopupMenu: TPopupMenu
    Left = 48
    Top = 56
    object menuAddProject: TMenuItem
      Caption = '&Add Project'
      OnClick = menuAddProjectClick
    end
    object menuDeleteProject: TMenuItem
      Caption = '&Delete Project'
      OnClick = menuDeleteProjectClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuAddinProject: TMenuItem
      Caption = 'Add in &Project...'
      OnClick = menuAddinProjectClick
    end
    object menuRemovefromProject: TMenuItem
      Caption = 'Remove from &Project...'
      OnClick = menuRemovefromProjectClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object menuViewSource: TMenuItem
      Caption = '&View Source'
      OnClick = menuViewSourceClick
    end
  end
end