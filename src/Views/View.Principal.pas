unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinWXI, dxSkinController, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxButtonEdit, cxLabel, cxProgressBar, cxButtons, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxClasses,
  cxGridLevel, cxGrid, Controller.Principal, dxCore, dxUIAClasses, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, dxCoreGraphics, cxGridDBTableView,
  dxSkinsForm;

type
  TViewPrincipal = class(TForm)
    SkinControllerPrincipal: TdxSkinController;
    pnlTopo: TPanel;
    pnlRodape: TPanel;
    gridXMLsDBTableView1: TcxGridDBTableView;
    gridXMLsLevel1: TcxGridLevel;
    gridXMLs: TcxGrid;
    dlgSelecionarPasta: TFileOpenDialog;
    btnProcessar: TcxButton;
    pbProgresso: TcxProgressBar;
    lblConexao: TcxLabel;
    cbxConexoes: TcxComboBox;
    lblDiretorio: TcxLabel;
    edtDiretorioXML: TcxButtonEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

end.
