unit Interfaces.LeitorConexoes;

interface

uses
  System.Generics.Collections, Model.Conexao;

type
  ILeitorConexoes = interface
    ['{8A5E7B2A-3D9F-4E1C-A2F5-6B8C9D4E1F3A}']
    function CarregarConexoes(const ACaminhoArquivo: string): TObjectList<TModelConexao>;
  end;

implementation

end.
