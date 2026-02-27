unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinWXI, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
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
    gridXMLsDBTableView: TcxGridDBTableView;
    gridXMLsLvl: TcxGridLevel;
    gridXMLs: TcxGrid;
    dlgSelecionarPasta: TFileOpenDialog;
    btnProcessar: TcxButton;
    pbProgresso: TcxProgressBar;
    lblConexao: TcxLabel;
    cbxConexoes: TcxComboBox;
    lblDiretorio: TcxLabel;
    edtDiretorioXML: TcxButtonEdit;
    procedure edtDiretorioXMLPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Infra.LeitorConexoes, Controller.Principal;

{$R *.dfm}

procedure TViewPrincipal.edtDiretorioXMLPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  dlgSelecionarPasta.Title := 'Selecione a pasta com os arquivos XML';

  if dlgSelecionarPasta.Execute then
    edtDiretorioXML.Text := dlgSelecionarPasta.FileName;
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
var
  LCaminhoArquivoConexoes: string;
begin
  FController := TControllerPrincipal.Create(TLeitorConexoes.Create);

  LCaminhoArquivoConexoes := 'E:\FormatadorXML\FormatadorXML.conexoes';

  try
    FController.CarregarConexoesParaComboBox(LCaminhoArquivoConexoes, cbxConexoes.Properties.Items);

    if cbxConexoes.Properties.Items.Count > 0 then
          cbxConexoes.ItemIndex := 0;
  except
    on E: Exception do
      ShowMessage('Não foi possível carregar as conexões: ' + E.Message);
  end;
end;

procedure TViewPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(FController) then
    FController.Free;
end;

end.
