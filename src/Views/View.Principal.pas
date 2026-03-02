unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinWXI, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxButtonEdit, cxLabel, cxProgressBar, cxButtons, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxClasses,
  cxGridLevel, cxGrid, dxCore, dxUIAClasses, dxDateRanges, dxScrollbarAnnotations, Data.DB, cxDBData,
  dxCoreGraphics, cxGridDBTableView, dxSkinsForm, Controller.Principal, Model.ArquivoXML;

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
    colNome: TcxGridDBColumn;
    colCaminho: TcxGridDBColumn;
    colStatus: TcxGridDBColumn;
    procedure edtDiretorioXMLPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerPrincipal;
    procedure AtualizarGridXMLs;
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Infra.LeitorConexoes;

{$R *.dfm}

procedure TViewPrincipal.AtualizarGridXMLs;
var
  nIndice: Integer;
  oXML: TModelArquivoXML;
begin
  gridXMLsDBTableView.DataController.RecordCount := 0;

  if not Assigned(FController.ListaXMLs) then
    Exit;

  gridXMLsDBTableView.DataController.BeginUpdate;

  try
    gridXMLsDBTableView.DataController.RecordCount := FController.ListaXMLs.Count;

    for nIndice := 0 to FController.ListaXMLs.Count - 1 do
    begin
      oXML := FController.ListaXMLs[nIndice];

      gridXMLsDBTableView.DataController.Values[nIndice, colNome.Index]    := oXML.NomeArquivo;
      gridXMLsDBTableView.DataController.Values[nIndice, colCaminho.Index] := oXML.CaminhoCompleto;
      gridXMLsDBTableView.DataController.Values[nIndice, colStatus.Index]  := oXML.StatusParaTexto;
    end;
  finally
    gridXMLsDBTableView.DataController.EndUpdate;
  end;
end;

procedure TViewPrincipal.edtDiretorioXMLPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  dlgSelecionarPasta.Title := 'Selecione a pasta com os arquivos XML';

  if dlgSelecionarPasta.Execute then
  begin
    edtDiretorioXML.Text := dlgSelecionarPasta.FileName;

    FController.CarregarArquivosXML(edtDiretorioXML.Text);

    AtualizarGridXMLs;
  end;
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
    FreeAndNil(FController);
end;

end.
