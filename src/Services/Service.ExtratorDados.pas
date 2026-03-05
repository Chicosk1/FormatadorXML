unit Service.ExtratorDados;

interface

uses
  System.SysUtils, System.IOUtils, Data.DB, Data.SqlExpr,
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
  Infra.GeradorJSON, Infra.Database.Oracle;

{ TExtratorDados }

constructor TExtratorDados.Create(const AoPythonBridge: IPythonBridge);
begin
  inherited Create;
  FoPythonBridge := AoPythonBridge;
end;

function TExtratorDados.ProcessarNotaFiscal(const AcCaminhoXMLEntrada, AcCaminhoXMLSaida, AcChaveBuscaOracle: string): Boolean;
var
  oGeradorJSON: IGeradorJSON;
  oQuery: TSQLQuery;
  cCaminhoJSONTemp: string;
  bSucessoPython: Boolean;
begin
  Result := False;

  cCaminhoJSONTemp := TPath.Combine(TPath.GetTempPath, 'dados_oracle_' + AcChaveBuscaOracle + '.json');

  try
    try
      oQuery.SQLConnection := DmOracle.DmConexaoOracle;

      oQuery.SQL.Text := '';
      oQuery.ParamByName('CHAVE').AsString := AcChaveBuscaOracle;
      oQuery.Open;

      oGeradorJSON := TGeradorJSON.Create;

      if not oQuery.IsEmpty then
      begin
        oGeradorJSON.AdicionarTag('xNome'  , oQuery.FieldByName('xNome').AsString  )
                    .AdicionarTag('xBairro', oQuery.FieldByName('xBairro').AsString);
      end;

      oGeradorJSON.SalvarEmArquivo(cCaminhoJSONTemp);

      bSucessoPython := FoPythonBridge.FormatarXML(AcCaminhoXMLEntrada, cCaminhoJSONTemp, AcCaminhoXMLSaida);

      Result := bSucessoPython;
    except
      on oErro: Exception do
      begin
        Result := False;
      end;
    end;
  finally
    if oQuery.Active then
      oQuery.Close;

    FreeAndNil(oQuery);

    if TFile.Exists(cCaminhoJSONTemp) then
      TFile.Delete(cCaminhoJSONTemp);
  end;
end;

end.
