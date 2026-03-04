unit Controller.Processamento;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.IOUtils,
  Model.ArquivoXML, Model.Conexao,
  Interfaces.PythonBridge, Infra.PythonBridge,
  Interfaces.ExtratorDados, Service.ExtratorDados,
  Infra.Database.Oracle;

type
  TNotificacaoProgresso = reference to procedure(AnIndiceLinha: Integer; AcStatusTexto: string);

  TControllerProcessamento = class
  public
    procedure ProcessarLote(
      AoListaXML: TObjectList<TModelArquivoXML>;
      AoConexaoOracle: TModelConexao;
      AOnProgresso: TNotificacaoProgresso);
  end;

implementation

{ TControllerProcessamento }

procedure TControllerProcessamento.ProcessarLote(
  AoListaXML: TObjectList<TModelArquivoXML>;
  AoConexaoOracle: TModelConexao;
  AOnProgresso: TNotificacaoProgresso);
var
  oPythonBridge: IPythonBridge;
  oExtrator: IExtratorDados;
  nIndice: Integer;
  oXMLAtual: TModelArquivoXML;
  cCaminhoDestino: string;
  cChaveOracle: string;
  bSucesso: Boolean;
  cCaminhoPythonExe, cCaminhoScripts: string;
begin
  cCaminhoScripts   := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\python\');
  cCaminhoPythonExe := TPath.Combine(cCaminhoScripts, 'venv\Scripts\python.exe');

  oPythonBridge := TPythonBridge.Create(cCaminhoPythonExe, cCaminhoScripts);
  oExtrator     := TExtratorDados.Create(oPythonBridge);

  DmOracle.Conectar(AoConexaoOracle);

  try
    for nIndice := 0 to AoListaXML.Count - 1 do
    begin
      oXMLAtual := AoListaXML[nIndice];

      oXMLAtual.Status := stProcessando;
      if Assigned(AOnProgresso) then
        AOnProgresso(nIndice, oXMLAtual.StatusParaTexto);

      cCaminhoDestino := TPath.Combine(ExtractFilePath(oXMLAtual.CaminhoCompleto), 'Formatados');
      ForceDirectories(cCaminhoDestino);
      cCaminhoDestino := TPath.Combine(cCaminhoDestino, oXMLAtual.NomeArquivo);

      cChaveOracle := TPath.GetFileNameWithoutExtension(oXMLAtual.NomeArquivo);

      bSucesso := oExtrator.ProcessarNotaFiscal(oXMLAtual.CaminhoCompleto, cCaminhoDestino, cChaveOracle);

      if bSucesso then
        oXMLAtual.Status := stFormatado
      else
        oXMLAtual.Status := stErro;

      if Assigned(AOnProgresso) then
        AOnProgresso(nIndice, oXMLAtual.StatusParaTexto);
    end;
  finally
    DmOracle.Desconectar;
  end;
end;

end.
