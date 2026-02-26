unit Infra.LeitorConexoes;

interface

uses
  System.Classes, System.SysUtils, System.IniFiles, System.Generics.Collections,
  Model.Conexao, Interfaces.LeitorConexoes;

type
  TLeitorConexoes = class(TInterfacedObject, ILeitorConexoes)
  public
    function CarregarConexoes(const ACaminhoArquivo: string): TObjectList<TModelConexao>;
  end;

implementation

{ TLeitorConexoes }

function TLeitorConexoes.CarregarConexoes(const ACaminhoArquivo: string): TObjectList<TModelConexao>;
var
  LIniFile: TMemIniFile;
  LSessoes: TStringList;
  LSessaoAtual: string;
  LNovaConexao: TModelConexao;
begin
  if not FileExists(ACaminhoArquivo) then
    raise Exception.CreateFmt('Arquivo de conexões não encontrado no caminho: %s', [ACaminhoArquivo]);

  Result := TObjectList<TModelConexao>.Create(True);

  LIniFile := TMemIniFile.Create(ACaminhoArquivo);
  LSessoes := TStringList.Create;
  try
    LIniFile.ReadSections(LSessoes);

    for LSessaoAtual in LSessoes do
    begin
      if LIniFile.ReadString(LSessaoAtual, 'Database', '') = '' then
        Continue;

      LNovaConexao := TModelConexao.Create;
      LNovaConexao.NomeConexao          := LSessaoAtual;
      LNovaConexao.Database             := LIniFile.ReadString(LSessaoAtual, 'Database', '');
      LNovaConexao.UserName             := LIniFile.ReadString(LSessaoAtual, 'User_Name', '');
      LNovaConexao.PasswordCriptografada:= LIniFile.ReadString(LSessaoAtual, 'Password', '');

      Result.Add(LNovaConexao);
    end;
  finally
    LSessoes.Free;
    LIniFile.Free;
  end;
end;

end.
