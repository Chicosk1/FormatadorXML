object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Formatador de XML'
  ClientHeight = 600
  ClientWidth = 850
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 850
    Height = 85
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      850
      85)
    object lblConexao: TcxLabel
      Left = 16
      Top = 20
      Caption = 'Conex'#227'o de Banco:'
      TabOrder = 0
    end
    object cbxConexoes: TcxComboBox
      Left = 16
      Top = 40
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 1
      Width = 250
    end
    object lblDiretorio: TcxLabel
      Left = 285
      Top = 20
      Caption = 'Diret'#243'rio dos XMLs:'
      TabOrder = 2
    end
    object edtDiretorioXML: TcxButtonEdit
      Left = 285
      Top = 40
      Anchors = [akLeft, akTop, akRight]
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 545
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 540
    Width = 850
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ShowCaption = False
    TabOrder = 1
    object btnProcessar: TcxButton
      Left = 680
      Top = 10
      Width = 160
      Height = 40
      Cursor = crHandPoint
      Align = alRight
      Caption = 'Processar XMLs'
      TabOrder = 0
    end
    object pbProgresso: TcxProgressBar
      AlignWithMargins = True
      Left = 10
      Top = 10
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 1
      Width = 655
    end
  end
  object gridXMLs: TcxGrid
    AlignWithMargins = True
    Left = 10
    Top = 95
    Width = 830
    Height = 435
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    TabOrder = 2
    object gridXMLsDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object gridXMLsLevel1: TcxGridLevel
      GridView = gridXMLsDBTableView1
    end
  end
  object SkinControllerPrincipal: TdxSkinController
    SkinName = 'WXI'
    Left = 48
    Top = 408
  end
  object dlgSelecionarPasta: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 152
    Top = 408
  end
end
