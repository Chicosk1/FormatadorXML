unit Model.ArquivoXML;

interface

uses
  System.SysUtils;

type
  TStatusProcessamento = (stAguardando, stProcessando, stFormatado, stErro);

  TModelArquivoXML = class
  strict private
    FNomeArquivo: string;
    FCaminhoCompleto: string;
    FStatus: TStatusProcessamento;
  public
    property NomeArquivo          : string read FNomeArquivo     write FNomeArquivo    ;
    property CaminhoCompleto      : string read FCaminhoCompleto write FCaminhoCompleto;
    property Status : TStatusProcessamento read FStatus          write FStatus         ;

    function StatusParaTexto: string;
  end;

implementation

{ TModelArquivoXML }

function TModelArquivoXML.StatusParaTexto: string;
begin
  case FStatus of
    stAguardando:  Result := 'Aguardando';
    stProcessando: Result := 'Processando...';
    stFormatado:   Result := 'Formatado com Sucesso';
    stErro:        Result := 'Erro na Validação';
    else           Result := 'Desconhecido';
  end;
end;

end.
