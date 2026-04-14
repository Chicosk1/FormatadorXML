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
  oGeradorJSON, oJsonDest, oJsonEnderDest: IGeradorJSON;
  oQueryDest, oQueryEnderDest: TSQLQuery;
  cCaminhoJSONTemp: string;
  bSucessoPython: Boolean;
begin
  Result := False;

  cCaminhoJSONTemp := TPath.Combine(TPath.GetTempPath, 'dados_oracle_' + AcChaveBuscaOracle + '.json');

  oQueryDest      := TSQLQuery.Create(nil);
  oQueryEnderDest := TSQLQuery.Create(nil);

  try
    try
      oQueryDest.SQLConnection      := DmOracle.DmConexaoOracle;
      oQueryEnderDest.SQLConnection := DmOracle.DmConexaoOracle;

      // Consultas no banco de dados

      oGeradorJSON := TGeradorJSON.Create;

      oJsonEnderDest := TGeradorJSON.Create;
      oJsonEnderDest.AdicionarTag('xLgr'   , oQueryEnderDest.FieldByName('LOGRADOURO').AsString   )
                    .AdicionarTag('nro'    , oQueryEnderDest.FieldByName('NUMERO').AsString       )
                    .AdicionarTag('xCpl'   , oQueryEnderDest.FieldByName('COMPLEMENTO').AsString  )
                    .AdicionarTag('xBairro', oQueryEnderDest.FieldByName('BAIRRO').AsString       )
                    .AdicionarTag('cMun'   , oQueryEnderDest.FieldByName('COD_MUNICIPIO').AsString)
                    .AdicionarTag('xMun'   , oQueryEnderDest.FieldByName('MUNICIPIO').AsString    )
                    .AdicionarTag('UF'     , oQueryEnderDest.FieldByName('UF').AsString           )
                    .AdicionarTag('CEP'    , oQueryEnderDest.FieldByName('CEP').AsString          )
                    .AdicionarTag('fone'   , oQueryEnderDest.FieldByName('TELEFONE').AsString     );

      oJsonDest := TGeradorJSON.Create;
      oJsonDest.AdicionarTag    ('CNPJ'     , oQueryDest.FieldByName('CNPJ').AsString              )
                .AdicionarTag   ('xNome'    , oQueryDest.FieldByName('RAZAO_SOCIAL').AsString      )
                .AdicionarTag   ('IE'       , oQueryDest.FieldByName('INSCRICAO_ESTADUAL').AsString)
                .AdicionarTag   ('email'    , oQueryDest.FieldByName('EMAIL_CONTATO').AsString     )
                .AdicionarObjeto('enderDest', oJsonEnderDest                                       );

      oGeradorJSON.AdicionarObjeto('dest', oJsonDest);

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
    if oQueryDest.Active      then oQueryDest.Close;
    if oQueryEnderDest.Active then oQueryEnderDest.Close;

    if TFile.Exists(cCaminhoJSONTemp) then TFile.Delete(cCaminhoJSONTemp);

    FreeAndNil(oQueryDest);
    FreeAndNil(oQueryEnderDest);
  end;
end;

end.
