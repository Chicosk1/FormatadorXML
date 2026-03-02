unit Controller.Principal;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  Model.Conexao, Interfaces.LeitorConexoes,
  Model.ArquivoXML, Service.GerenciadorDiretorio;

type
  TControllerPrincipal = class
  strict private
    FLeitor       : ILeitorConexoes;
    FListaConexoes: TObjectList<TModelConexao>;
    FListaXMLs    : TObjectList<TModelArquivoXML>;
  public
    constructor Create(ALeitor: ILeitorConexoes);
    destructor Destroy; override;

    procedure CarregarArquivosXML(const AcCaminhoPasta: string);
    procedure CarregarConexoesParaComboBox(const AcCaminhoArquivo: string; AItems: TStrings);

    function ObterConexaoSelecionada(const AcNomeConexao: string): TModelConexao;

    property ListaXMLs: TObjectList<TModelArquivoXML> read FListaXMLs;
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

  if Assigned(FListaXMLs) then
    FListaXMLs.Free;

  inherited;
end;

procedure TControllerPrincipal.CarregarArquivosXML(const AcCaminhoPasta: string);
begin
  if Assigned(FListaXMLs) then
    FreeAndNil(FListaXMLs);

  FListaXMLs := TGerenciadorDiretorio.ListarArquivosXML(AcCaminhoPasta);
end;

procedure TControllerPrincipal.CarregarConexoesParaComboBox(const AcCaminhoArquivo: string; AItems: TStrings);
var
  LConexao: TModelConexao;
begin
  AItems.Clear;

  if Assigned(FListaConexoes) then
    FreeAndNil(FListaConexoes);

  FListaConexoes := FLeitor.CarregarConexoes(AcCaminhoArquivo);

  for LConexao in FListaConexoes do
  begin
    AItems.Add(LConexao.NomeConexao);
  end;
end;

function TControllerPrincipal.ObterConexaoSelecionada(const AcNomeConexao: string): TModelConexao;
var
  LConexao: TModelConexao;
begin
  Result := nil;

  if not Assigned(FListaConexoes) then
    Exit;

  for LConexao in FListaConexoes do
  begin
    if LConexao.NomeConexao.Equals(AcNomeConexao) then
      Exit(LConexao);
  end;
end;

end.
