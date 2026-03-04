unit Service.ExtratorDados;

interface

uses
  System.SysUtils, System.IOUtils,
  Interfaces.ExtratorDados, Interfaces.PythonBridge, Interfaces.GeradorJSON;

type
  TExtratorDados = class(TInterfacedObject, IExtratorDados)
  private
    FoPythonBridge: IPythonBridge;
  public
    constructor Create(const AoPythonBridge: IPythonBridge);

    function ProcessarNotaFiscal(const AcCaminhoXMLEntrada, AcCaminhoXMLSaida, AcChaveBuscaOracle: string): Boolean;
  end;

implementation

uses
  Infra.GeradorJSON;

{ TExtratorDados }

constructor TExtratorDados.Create(const AoPythonBridge: IPythonBridge);
begin
  inherited Create;
  FoPythonBridge := AoPythonBridge;
end;

function TExtratorDados.ProcessarNotaFiscal(const AcCaminhoXMLEntrada, AcCaminhoXMLSaida, AcChaveBuscaOracle: string): Boolean;
var
  oGeradorJSON: IGeradorJSON;
  cCaminhoJSONTemp: string;
  bSucessoPython: Boolean;

  // Variáveis para receber os dados do banco (Exemplos)
  cNomeClienteOracle: string;
  cBairroClienteOracle: string;
  // cValorProdutoOracle: string;
begin
  Result := False;

  cCaminhoJSONTemp := TPath.Combine(TPath.GetTempPath, 'dados_oracle_' + AcChaveBuscaOracle + '.json');

  try
    // =========================================================================
    // 2. BUSCA NO ORACLE (Aqui você conecta o seu TDataModule)
    // =========================================================================
    // Exemplo de como ficará o seu código:
    // oMeuDataModule.QueryNota.Close;
    // oMeuDataModule.QueryNota.ParamByName('CHAVE').AsString := AcChaveBuscaOracle;
    // oMeuDataModule.QueryNota.Open;

    // Simulando o retorno do banco para o nosso teste:
    cNomeClienteOracle := 'CLIENTE NOVO VINDO DO ORACLE LTDA';
    cBairroClienteOracle := 'BAIRRO INDUSTRIAL';

    oGeradorJSON := TGeradorJSON.Create;

    oGeradorJSON
      .AdicionarTag('xNome', cNomeClienteOracle)
      .AdicionarTag('xBairro', cBairroClienteOracle)
      // Se houvessem vários produtos: .AdicionarTagLista('vProd', oDataModule.RetornarArrayDePrecos)
      .SalvarEmArquivo(cCaminhoJSONTemp);

    bSucessoPython := FoPythonBridge.FormatarXML(AcCaminhoXMLEntrada, cCaminhoJSONTemp, AcCaminhoXMLSaida);

    Result := bSucessoPython;

  finally
    if TFile.Exists(cCaminhoJSONTemp) then
      TFile.Delete(cCaminhoJSONTemp);
  end;
end;

end.
