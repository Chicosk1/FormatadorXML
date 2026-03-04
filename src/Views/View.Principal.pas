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
    procedure btnProcessarClick(Sender: TObject);
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
  Infra.LeitorConexoes,
  Model.Conexao,
  Controller.Processamento;

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

procedure TViewPrincipal.btnProcessarClick(Sender: TObject);
var
  oConexaoSelecionada: TModelConexao;
  oControllerProcessamento: TControllerProcessamento;
begin
  if (not Assigned(FController.ListaXMLs)) or (FController.ListaXMLs.Count = 0) then
  begin
    ShowMessage('Não há arquivos XMLs carregados para processar.');
    Exit;
  end;

  oConexaoSelecionada := FController.ObterConexaoSelecionada(cbxConexoes.Text);
  if not Assigned(oConexaoSelecionada) then
  begin
    ShowMessage('Selecione uma conexão de banco de dados válida no topo da tela.');
    Exit;
  end;

  btnProcessar.Enabled := False;
  Screen.Cursor        := crHourGlass;

  pbProgresso.Properties.Max := FController.ListaXMLs.Count;
  pbProgresso.Position := 0;

  oControllerProcessamento := TControllerProcessamento.Create;
  try
    oControllerProcessamento.ProcessarLote(
      FController.ListaXMLs,
      oConexaoSelecionada,
      procedure(AnIndiceLinha: Integer; AcStatusTexto: string)
      begin
        gridXMLsDBTableView.DataController.Values[AnIndiceLinha, colStatus.Index] := AcStatusTexto;

        if (AcStatusTexto = 'Formatado com Sucesso') or (AcStatusTexto = 'Erro na Validação') then
          pbProgresso.Position := pbProgresso.Position + 1;

        Application.ProcessMessages;
      end
    );

    ShowMessage('Processamento em lote concluído com sucesso!');

  finally
    oControllerProcessamento.Free;

    btnProcessar.Enabled := True;
    Screen.Cursor        := crDefault;
    pbProgresso.Position := 0;
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
