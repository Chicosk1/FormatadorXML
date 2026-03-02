unit Service.GerenciadorDiretorio;

interface

uses
  System.SysUtils, System.IOUtils, System.Generics.Collections, System.Types,
  Model.ArquivoXML;

type
  TGerenciadorDiretorio = record
  public
    class function ListarArquivosXML(const AcCaminhoPasta: string): TObjectList<TModelArquivoXML>; static;
  end;

implementation

{ TGerenciadorDiretorio }

class function TGerenciadorDiretorio.ListarArquivosXML(const AcCaminhoPasta: string): TObjectList<TModelArquivoXML>;
var
  AListaArquivos: TStringDynArray;
  cArquivoFisico: string;
  oNovoModel: TModelArquivoXML;
begin
  Result := TObjectList<TModelArquivoXML>.Create(True);

  if AcCaminhoPasta.Trim.IsEmpty or (not TDirectory.Exists(AcCaminhoPasta)) then
    Exit;

  try
    AListaArquivos := TDirectory.GetFiles(AcCaminhoPasta, '*.xml', TSearchOption.soTopDirectoryOnly);

    for cArquivoFisico in AListaArquivos do
    begin
      oNovoModel := TModelArquivoXML.Create;
      oNovoModel.NomeArquivo     := ExtractFileName(cArquivoFisico);
      oNovoModel.CaminhoCompleto := cArquivoFisico;
      oNovoModel.Status          := stAguardando;

      Result.Add(oNovoModel);
    end;
  except
    on E: Exception do
      raise Exception.Create('Falha ao tentar ler os arquivos do diretório: ' + E.Message);
  end;
end;

end.
