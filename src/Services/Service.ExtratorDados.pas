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
  oGeradorJSON, oJsonDest, oJsonEnderDest, oJsonEmit, oJsonEnderEmit: IGeradorJSON;
  oQueryDest, oQueryEnderDest, oQueryEmit: TSQLQuery;
  cCaminhoJSONTemp, cCaminhoConsultas: string;
  bSucessoPython: Boolean;
begin
  Result := False;

  cCaminhoJSONTemp  := TPath.Combine(TPath.GetTempPath, 'dados_oracle_' + AcChaveBuscaOracle + '.json');
  cCaminhoConsultas := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'consultas');

  oQueryDest      := TSQLQuery.Create(nil);
  oQueryEnderDest := TSQLQuery.Create(nil);
  oQueryEmit      := TSQLQuery.Create(nil);

  try
    try
      oQueryDest.SQLConnection      := DmOracle.DmConexaoOracle;
      oQueryEnderDest.SQLConnection := DmOracle.DmConexaoOracle;
      oQueryEmit.SQLConnection      := DmOracle.DmConexaoOracle;

      oQueryDest.SQL.Text := TFile.ReadAllText(TPath.Combine(cCaminhoConsultas, 'SEL_DEST.txt'), TEncoding.UTF8);
      oQueryDest.ParamByName('ESTAB').AsString := AcChaveBuscaOracle;
      oQueryDest.Open;

      oQueryEnderDest.SQL.Text := TFile.ReadAllText(TPath.Combine(cCaminhoConsultas, 'SEL_ENDER_DEST.txt'), TEncoding.UTF8);
      oQueryEnderDest.ParamByName('ESTAB').AsString := AcChaveBuscaOracle;
      oQueryEnderDest.Open;

      oQueryEmit.SQL.Text := TFile.ReadAllText(TPath.Combine(cCaminhoConsultas, 'SEL_EMIT.txt'), TEncoding.UTF8);
      oQueryEmit.ParamByName('ESTAB').AsString := AcChaveBuscaOracle;
      oQueryEmit.Open;

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
                    .AdicionarTag('cPais'  , '1058'                                               )
                    .AdicionarTag('xPais'  , 'BRASIL'                                             )
                    .AdicionarTag('fone'   , oQueryEnderDest.FieldByName('TELEFONE').AsString     );

      oJsonDest := TGeradorJSON.Create;
      oJsonDest.AdicionarTag    ('CNPJ'      , oQueryDest.FieldByName('CNPJ').AsString              )
                .AdicionarTag   ('xNome'     , oQueryDest.FieldByName('RAZAO_SOCIAL').AsString      )
                .AdicionarObjeto('enderDest' , oJsonEnderDest                                       )
                .AdicionarTag   ('indIEDest' , '1'                                                  )
                .AdicionarTag   ('IE'        , oQueryDest.FieldByName('INSCRICAO_ESTADUAL').AsString)
                .AdicionarTag   ('email'     , oQueryDest.FieldByName('EMAIL_CONTATO').AsString     );

      oJsonEnderEmit := TGeradorJSON.Create;
      oJsonEnderEmit.AdicionarTag('xLgr'   , oQueryEnderDest.FieldByName('LOGRADOURO').AsString   )
                    .AdicionarTag('nro'    , oQueryEnderDest.FieldByName('NUMERO').AsString       )
                    .AdicionarTag('xBairro', oQueryEnderDest.FieldByName('BAIRRO').AsString       )
                    .AdicionarTag('cMun'   , oQueryEnderDest.FieldByName('COD_MUNICIPIO').AsString)
                    .AdicionarTag('xMun'   , oQueryEnderDest.FieldByName('MUNICIPIO').AsString    )
                    .AdicionarTag('UF'     , oQueryEnderDest.FieldByName('UF').AsString           )
                    .AdicionarTag('CEP'    , oQueryEnderDest.FieldByName('CEP').AsString          )
                    .AdicionarTag('cPais'  , '1058'                                               )
                    .AdicionarTag('xPais'  , 'BRASIL'                                             )
                    .AdicionarTag('fone'   , oQueryEnderDest.FieldByName('TELEFONE').AsString     );

      oJsonEmit := TGeradorJSON.Create;
      oJsonEmit.AdicionarTag    ('CNPJ'     , oQueryEmit.FieldByName('CNPJ').AsString              )
                .AdicionarTag   ('xNome'    , oQueryEmit.FieldByName('RAZAO_SOCIAL').AsString      )
                .AdicionarTag   ('xFant'    , oQueryEmit.FieldByName('NOME_FANTASIA').AsString     )
                .AdicionarObjeto('enderEmit', oJsonEnderEmit                                       )
                .AdicionarTag   ('IE'       , oQueryEmit.FieldByName('INSCRICAO_ESTADUAL').AsString)
                .AdicionarTag   ('CRT'      , oQueryEmit.FieldByName('CRT').AsString               );

      oGeradorJSON.AdicionarObjeto('emit', oJsonEmit);
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
    if oQueryEmit.Active      then oQueryEmit.Close;

    if TFile.Exists(cCaminhoJSONTemp) then TFile.Delete(cCaminhoJSONTemp);

    FreeAndNil(oQueryDest);
    FreeAndNil(oQueryEnderDest);
    FreeAndNil(oQueryEmit);
  end;
end;

end.
