unit Infra.GeradorJSON;

interface

uses
  System.JSON, System.SysUtils, System.Classes, System.IOUtils, Interfaces.GeradorJSON;

type
  TGeradorJSON = class(TInterfacedObject, IGeradorJSON)
  private
    FoJSONObject: TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;

    function AdicionarTag(const AcNomeTag, AcValor: string): IGeradorJSON;
    function AdicionarTagLista(const AcNomeTag: string; const AoValores: TArray<string>): IGeradorJSON;

    function SalvarEmArquivo(const AcCaminhoArquivo: string): Boolean;
    function ObterJSONString: string;
  end;

implementation

{ TGeradorJSON }

constructor TGeradorJSON.Create;
begin
  inherited;
  FoJSONObject := TJSONObject.Create;
end;

destructor TGeradorJSON.Destroy;
begin
  if Assigned(FoJSONObject) then
    FoJSONObject.Free;

  inherited;
end;

function TGeradorJSON.AdicionarTag(const AcNomeTag, AcValor: string): IGeradorJSON;
begin
  FoJSONObject.AddPair(AcNomeTag, AcValor);

  Result := Self;
end;

function TGeradorJSON.AdicionarTagLista(const AcNomeTag: string; const AoValores: TArray<string>): IGeradorJSON;
var
  oJSONArray: TJSONArray;
  cValor: string;
begin
  oJSONArray := TJSONArray.Create;

  for cValor in AoValores do
  begin
    oJSONArray.Add(cValor);
  end;

  FoJSONObject.AddPair(AcNomeTag, oJSONArray);

  Result := Self;
end;

function TGeradorJSON.ObterJSONString: string;
begin
  Result := FoJSONObject.ToString;
end;

function TGeradorJSON.SalvarEmArquivo(const AcCaminhoArquivo: string): Boolean;
var
  cConteudoJSON: string;
begin
  Result := False;
  try
    cConteudoJSON := ObterJSONString;

    TFile.WriteAllText(AcCaminhoArquivo, cConteudoJSON, TEncoding.UTF8);

    Result := True;
  except
    on oErro: Exception do
    begin
      Result := False;
    end;
  end;
end;

end.
