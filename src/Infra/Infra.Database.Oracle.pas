unit Infra.Database.Oracle;

interface

uses
  System.SysUtils, System.Classes, Data.DBXOracle, Data.DB, Data.SqlExpr,
  Model.Conexao, Infra.Criptografia, DBXDevartOracle;

type
  TDmOracle = class(TDataModule)
    DmConexaoOracle: TSQLConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Conectar(const AModelConexao: TModelConexao);
    procedure Desconectar;
  end;

var
  DmOracle: TDmOracle;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmOracle }

procedure TDmOracle.Conectar(const AModelConexao: TModelConexao);
var
  cSenhaReal: string;
begin
  if not Assigned(AModelConexao) then
    raise Exception.Create('Modelo de conexão não informado para o Oracle.');

  try
    Desconectar;

    cSenhaReal := TCryptoUtils.TratarSenha(AModelConexao.PasswordCriptografada);

    DmConexaoOracle.Params.Values['Database']  := AModelConexao.Database;
    DmConexaoOracle.Params.Values['User_Name'] := AModelConexao.UserName;
    DmConexaoOracle.Params.Values['Password']  := cSenhaReal;

    DmConexaoOracle.Connected := True;

  except
    on E: Exception do
      raise Exception.Create('Falha ao conectar no banco de dados Oracle: ' + sLineBreak + E.Message);
  end;
end;

procedure TDmOracle.Desconectar;
begin
  if DmConexaoOracle.Connected then
    DmConexaoOracle.Connected := False;
end;

end.
