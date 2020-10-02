object Frame: TFrame
  Left = 229
  Top = 187
  Width = 928
  Height = 480
  Caption = 'Frame'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 115
  TextHeight = 16
  object Edit: TELSuperEdit
    Left = 0
    Top = 0
    Width = 910
    Height = 435
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    PopupMenu = PopupMenu
    TabOrder = 0
    OnKeyDown = EditKeyDown
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -13
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = FreeBasic
    SearchEngine = EditSearch
    OnChange = EditChange
  end
  object EditSearch: TSynEditSearch
    Left = 336
    Top = 84
  end
  object EditPrint: TSynEditPrint
    Copies = 1
    Header.DefaultFont.Charset = DEFAULT_CHARSET
    Header.DefaultFont.Color = clBlack
    Header.DefaultFont.Height = -16
    Header.DefaultFont.Name = 'Arial'
    Header.DefaultFont.Style = []
    Footer.DefaultFont.Charset = DEFAULT_CHARSET
    Footer.DefaultFont.Color = clBlack
    Footer.DefaultFont.Height = -16
    Footer.DefaultFont.Name = 'Arial'
    Footer.DefaultFont.Style = []
    Margins.Left = 25.000000000000000000
    Margins.Right = 15.000000000000000000
    Margins.Top = 25.000000000000000000
    Margins.Bottom = 25.000000000000000000
    Margins.Header = 15.000000000000000000
    Margins.Footer = 15.000000000000000000
    Margins.LeftHFTextIndent = 2.000000000000000000
    Margins.RightHFTextIndent = 2.000000000000000000
    Margins.HFInternalMargin = 0.500000000000000000
    Margins.MirrorMargins = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Highlighter = FreeBasic
    TabWidth = 8
    Color = clWhite
    Left = 380
    Top = 68
  end
  object PopupMenu: TPopupMenu
    Left = 370
    Top = 126
    object menuUndo: TMenuItem
      Caption = '&Undo'
    end
    object menuRedo: TMenuItem
      Caption = '&Redo'
    end
    object PN2: TMenuItem
      Caption = '-'
    end
    object menuPaste: TMenuItem
      Caption = '&Paste'
    end
    object menuCut: TMenuItem
      Caption = '&Cut'
    end
    object menuCopy: TMenuItem
      Caption = '&Copy'
    end
    object menuDelete: TMenuItem
      Caption = '&Delete'
    end
    object PN3: TMenuItem
      Caption = '-'
    end
    object menuSelectAll: TMenuItem
      Caption = '&Select All'
    end
    object PN4: TMenuItem
      Caption = '-'
    end
    object menuNormalizeText: TMenuItem
      Caption = '&Normalize Text...'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuBlock: TMenuItem
      Caption = '&Comment Block'
      object menuComment: TMenuItem
        Caption = '&Comment'
      end
      object menuUncomment: TMenuItem
        Caption = '&Uncomment'
      end
    end
    object PN5: TMenuItem
      Caption = '-'
    end
    object menuProperties: TMenuItem
      Caption = '&Properties...'
    end
  end
  object URIOpener: TSynURIOpener
    Editor = Edit
    URIHighlighter = URI
    Left = 436
    Top = 92
  end
  object EditOptionsDialog: TSynEditOptionsDialog
    UseExtendedStrings = False
    Left = 492
    Top = 52
  end
  object CompletionProposal: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        BiggestWord = 'CONSTRUCTOR'
      end
      item
        BiggestWord = 'CONSTRUCTOR'
        DefaultFontStyle = [fsBold]
      end
      item
        BiggestWord = 'CONSTRUCTOR'
      end>
    ShortCut = 16416
    Editor = Edit
    Left = 492
    Top = 92
  end
  object ExporterRTF: TSynExporterRTF
    Color = clWindow
    DefaultFilter = 'Rich Text Format Documents (*.rtf)|*.rtf'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    Highlighter = FreeBasic
    Title = 'Untitled'
    UseBackground = False
    Left = 540
    Top = 92
  end
  object URI: TSynURISyn
    Left = 556
    Top = 132
  end
  object RC: TSynRCSyn
    CommentAttri.Background = 16777132
    CommentAttri.Foreground = 8404992
    DirecAttri.Foreground = 4227072
    KeyAttri.Foreground = 16711808
    NumberAttri.Foreground = 8388863
    StringAttri.Foreground = clRed
    SymbolAttri.Foreground = 4194432
    Left = 500
    Top = 132
  end
  object ExporterHTML: TSynExporterHTML
    Color = clWindow
    DefaultFilter = 'HTML Documents (*.htm;*.html)|*.htm;*.html'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    Highlighter = FreeBasic
    Title = 'Untitled'
    UseBackground = False
    Left = 540
    Top = 52
  end
  object css: TSynCssSyn
    Left = 68
    Top = 148
  end
  object HTML: TSynHTMLSyn
    Left = 108
    Top = 148
  end
  object XML: TSynXMLSyn
    WantBracesParsed = False
    Left = 140
    Top = 148
  end
  object VBScript: TSynVBScriptSyn
    Left = 148
    Top = 188
  end
  object PHP: TSynPHPSyn
    Left = 108
    Top = 188
  end
  object JScript: TSynJScriptSyn
    Left = 68
    Top = 188
  end
  object Python: TSynPythonSyn
    Left = 112
    Top = 216
  end
  object FreeBasic: TSynAnySyn
    CommentAttri.Background = 13041663
    CommentAttri.Foreground = 4227072
    Comments = [csFBStyle]
    DetectPreprocessor = True
    KeyAttri.Foreground = 13789440
    ObjectAttri.Foreground = 16711808
    KeyWords.Strings = (
      'ABS'
      'ABSTRACT'
      'ACCESS'
      'ACOS'
      'ALIAS'
      'ALLOCATE'
      'APPEND'
      'AS'
      'ASC'
      'ASIN'
      'ASM'
      'ATAN2'
      'ATN'
      'BASE'
      'BEEP'
      'BIN'
      'BINARY'
      'BLOAD'
      'BSAVE'
      'BYREF'
      'BYVAL'
      'CALL'
      'CALLOCATE'
      'CASE'
      'CDECL'
      'CHAIN'
      'CHDIR'
      'CHR'
      'CIRCLE'
      'CLEAR'
      'CLOSE'
      'CLS'
      'COLOR'
      'COM'
      'COMMAND'
      'COMMON'
      'CONDBROADCAST'
      'CONDCREATE'
      'CONDDESTROY'
      'CONDSIGNAL'
      'CONDWAIT'
      'CONS'
      'CONSTRUCTOR'
      'CONTINUE'
      'COS'
      'CSRLIN'
      'CURDIR'
      'CVD'
      'CVI'
      'CVL'
      'CVLONGINT'
      'CVS'
      'CVSHORT'
      'DATA'
      'DATE'
      'DATEADD'
      'DATEDIFF'
      'DATEPART'
      'DATESERIAL'
      'DATEVALUE'
      'DAY'
      'DAYNAME'
      'DAYWEEK'
      'DEALLOCATE'
      'DECLARE'
      'DELETE'
      'DESTRUCTOR'
      'DIM'
      'DIR'
      'DO'
      'DRAW'
      'DYLIBFREE'
      'DYLIBLOAD'
      'DYLIBSYMBOL'
      'DYNAMIC'
      'ELSE'
      'ELSEIF'
      'ENCODING'
      'END'
      'ENUM'
      'ENVIRON'
      'EOF'
      'ERASE'
      'ERFN'
      'ERL'
      'ERMN'
      'ERR'
      'ERROR'
      'ESCAPE'
      'EXEC'
      'EXEPATH'
      'EXIT'
      'EXP'
      'EXPLICIT'
      'EXPORT'
      'EXTENDS'
      'EXTERN'
      'FIELD'
      'FILEATTR'
      'FILECOPY'
      'FILEDATETIME'
      'FILEEXISTS'
      'FILELEN'
      'FIX'
      'FLIP'
      'FOR'
      'FORMAT'
      'FRAC'
      'FRE'
      'FREEFILE'
      'FUNCTION'
      'GET'
      'GETJOYSTICK'
      'GETKEY'
      'GETMOUSE'
      'GOSUB'
      'GOTO'
      'HEX'
      'HOUR'
      'IF'
      'IIF'
      'IMAGECONVERTROW'
      'IMAGECREATE'
      'IMAGEDESTROY'
      'IMAGEINFO'
      'IMPORT'
      'INKEY'
      'INP'
      'INPUT'
      'INSTR'
      'INSTRREV'
      'INT'
      'IS'
      'ISDATE'
      'KILL'
      'LANG'
      'LBOUND'
      'LCASE'
      'LEFT'
      'LEN'
      'LIB'
      'LINE'
      'LOC'
      'LOCAL'
      'LOCATE'
      'LOCK'
      'LOF'
      'LOG'
      'LOOP'
      'LPOS'
      'LPRINT'
      'LPT'
      'LSET'
      'LTRIM'
      'MID'
      'MINUTE'
      'MKD'
      'MKDIR'
      'MKI'
      'MKL'
      'MKLONGINT'
      'MKS'
      'MKSHORT'
      'MONTH'
      'MONTHNAME'
      'MULTIKEY'
      'MUTEXCREATE'
      'MUTEXDESTROY'
      'MUTEXLOCK'
      'MUTEXUNLOCK'
      'NAKED'
      'NAME'
      'NAMESPACE'
      'NEW'
      'NEXT'
      'NOGOSUB'
      'NOKEYWORD'
      'NOW'
      'OBJECT'
      'OCT'
      'ON'
      'OPEN'
      'OPERATOR'
      'OPTION'
      'OUT'
      'OUTPUT'
      'OVERLOAD'
      'PAINT'
      'PALETTE'
      'PASCAL'
      'PCOPY'
      'PEEK'
      'PIPE'
      'PMAP'
      'POINT'
      'POKE'
      'POS'
      'PRESERVE'
      'PRESET'
      'PRINT'
      'PRIVATE'
      'PROPERTY'
      'PROTECTED'
      'PSET'
      'PUBLIC'
      'PUT'
      'RANDOM'
      'RANDOMIZE'
      'READ'
      'REALLOCATE'
      'REDIM'
      'RESET'
      'RESTORE'
      'RESUME'
      'RETURN'
      'RIGHT'
      'RMDIR'
      'RND'
      'RSET'
      'RTRIM'
      'RUN'
      'SCOPE'
      'SCREEN'
      'SCREENCONTROL'
      'SCREENCOPY'
      'SCREENEVENT'
      'SCREENGLPROC'
      'SCREENINFO'
      'SCREENLIST'
      'SCREENLOCK'
      'SCREENPTR'
      'SCREENRES'
      'SCREENSET'
      'SCREENSYNC'
      'SCREENUNLOCK'
      'SCRN'
      'SECOND'
      'SEEK'
      'SELECT'
      'SETDATE'
      'SETENVIRON'
      'SETMOUSE'
      'SETTIME'
      'SGN'
      'SHELL'
      'SIN'
      'SIZEOF'
      'SLEEP'
      'SPACE'
      'SPC'
      'SQR'
      'STATIC'
      'STDCALL'
      'STEP'
      'STICK'
      'STR'
      'STRIG'
      'SUB'
      'SWAP'
      'SYSTEM'
      'TAB'
      'TAN'
      'THEN'
      'THIS'
      'THREADCREATE'
      'THREADWAIT'
      'TIME'
      'TIMER'
      'TIMESERIAL'
      'TIMEVALUE'
      'TO'
      'TRIM'
      'TYPE'
      'TYPEOF'
      'UBOUND'
      'UCASE'
      'UNION'
      'UNLOCK'
      'UNTIL'
      'USING'
      'VAL'
      'VALINT'
      'VALLNG'
      'VALUINT'
      'VALULNG'
      'VAR'
      'VIEW'
      'VIRTUAL'
      'WAIT'
      'WBIN'
      'WCHR'
      'WEEK'
      'WEND'
      'WHEX'
      'WHILE'
      'WIDTH'
      'WINDOW'
      'WINDOWTITLE'
      'WINPUT'
      'WITH'
      'WOCT'
      'WRITE'
      'WSPACE'
      'WSTRYEAR')
    Constants.Strings = (
      'CAST'
      'LET'
      'SHARED')
    Objects.Strings = (
      'ANY'
      'BYTE'
      'CAST'
      'CINT'
      'CLONG'
      'CPTR'
      'DOUBLE'
      'DWORD'
      'INTEGER'
      'LONG'
      'PTR'
      'SHORT'
      'SINGLE'
      'STRING'
      'UINT'
      'WORD'
      'ZSTRING')
    NumberAttri.Foreground = 8388863
    PreprocessorAttri.Foreground = clTeal
    StringAttri.Foreground = clRed
    SymbolAttri.Foreground = clFuchsia
    StringDelim = sdDoubleQuote
    Markup = False
    Entity = False
    DollarVariables = False
    ActiveDot = False
    Left = 432
    Top = 128
  end
end
