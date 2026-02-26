unit Model.Conexao;

interface

type
  TModelConexao = class
  strict private
    FNomeConexao: string;
    FDatabase: string;
    FUserName: string;
    FPasswordCriptografada: string;
  public
    property NomeConexao          : string read FNomeConexao           write FNomeConexao          ;
    property Database             : string read FDatabase              write FDatabase             ;
    property UserName             : string read FUserName              write FUserName             ;
    property PasswordCriptografada: string read FPasswordCriptografada write FPasswordCriptografada;
  end;

implementation

end.
