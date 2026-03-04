unit Interfaces.GeradorJSON;

interface

type
  IGeradorJSON = interface
    ['{C3F4B182-9E7D-41A5-B892-D34F71C6A9E2}']

    function AdicionarTag(const AcNomeTag, AcValor: string): IGeradorJSON;
    function AdicionarTagLista(const AcNomeTag: string; const AoValores: TArray<string>): IGeradorJSON;
    function SalvarEmArquivo(const AcCaminhoArquivo: string): Boolean;
    function ObterJSONString: string;
  end;

implementation

end.
