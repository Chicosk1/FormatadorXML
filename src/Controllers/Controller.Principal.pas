unit Controller.Principal;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  Model.Conexao, Interfaces.LeitorConexoes;

type
  TControllerPrincipal = class
  strict private
    FLeitor: ILeitorConexoes;
    FListaConexoes: TObjectList<TModelConexao>;
  public
    constructor Create(ALeitor: ILeitorConexoes);
    destructor Destroy; override;
    procedure CarregarConexoesParaComboBox(const ACaminhoArquivo: string; AItems: TStrings);
    function ObterConexaoSelecionada(const ANomeConexao: string): TModelConexao;
  end;

implementation

{ TControllerPrincipal }

constructor TControllerPrincipal.Create(ALeitor: ILeitorConexoes);
begin
  FLeitor := ALeitor;
  FListaConexoes := nil;
end;

destructor TControllerPrincipal.Destroy;
begin
  if Assigned(FListaConexoes) then
    FListaConexoes.Free;

  inherited;
end;

procedure TControllerPrincipal.CarregarConexoesParaComboBox(const ACaminhoArquivo: string; AItems: TStrings);
var
  LConexao: TModelConexao;
begin
  AItems.Clear;

  if Assigned(FListaConexoes) then
    FreeAndNil(FListaConexoes);

  FListaConexoes := FLeitor.CarregarConexoes(ACaminhoArquivo);

  for LConexao in FListaConexoes do
  begin
    AItems.Add(LConexao.NomeConexao);
  end;
end;

function TControllerPrincipal.ObterConexaoSelecionada(const ANomeConexao: string): TModelConexao;
var
  LConexao: TModelConexao;
begin
  Result := nil;

  if not Assigned(FListaConexoes) then
    Exit;

  for LConexao in FListaConexoes do
  begin
    if LConexao.NomeConexao.Equals(ANomeConexao) then
      Exit(LConexao);
  end;
end;

end.
