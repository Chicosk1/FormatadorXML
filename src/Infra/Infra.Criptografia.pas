unit Infra.Criptografia;

interface

uses
  System.SysUtils, System.StrUtils, System.Character;

type
  ECriptografiaException = class(Exception);

  TCryptoUtils = record
  public
    class function Descriptografar(const AcSenhaCriptografada: string): string; static;
    class function TratarSenha(const AcSenha: string): string; static;
  end;

implementation

{ TCryptoUtils }

class function TCryptoUtils.Descriptografar(const AcSenhaCriptografada: string): string;
var
  cTexto, cTextoDescript, cCAsc1, cCAsc2: string;
  nTamanhoTotal, nTamanhoDeRetorno, nCaracteresPares, nIndice: Integer;
begin
cTexto := AcSenhaCriptografada.Trim;

  if cTexto.IsEmpty or
     (not cTexto.Chars[0].IsDigit) or
     ((cTexto.Length mod 3) <> 0) then
    Exit(cTexto);

  try
    nTamanhoTotal := cTexto.Length div 3;

    // 1. Volta os bytes para as posições corretas
    for nIndice := nTamanhoTotal downto 2 do
    begin
      cCAsc1 := Copy(cTexto, (nIndice * 3) - 2, 3);
      cCAsc2 := Copy(cTexto, (nIndice * 3) - 5, 3);

      if Odd(nTamanhoTotal) then
      begin
        cTexto[(nIndice * 3) - 2] := cCAsc2[1];
        cTexto[(nIndice * 3) - 5] := cCAsc1[1];
        cTexto[nIndice * 3]       := cCAsc2[3];
        cTexto[(nIndice * 3) - 3] := cCAsc1[3];
      end
      else
      begin
        cTexto[(nIndice * 3) - 2] := cCAsc2[3];
        cTexto[(nIndice * 3) - 5] := cCAsc1[3];
        cTexto[nIndice * 3]       := cCAsc2[1];
        cTexto[(nIndice * 3) - 3] := cCAsc1[1];
      end;
    end;

    // 2. Extrai metadados do tamanho
    nTamanhoDeRetorno := StrToIntDef(Copy(cTexto, cTexto.Length - 2, 3), 0) - (nTamanhoTotal - 2);
    nCaracteresPares  := StrToIntDef(Copy(cTexto, 1, 3), 0) - nTamanhoDeRetorno;

    // 3. Monta a string preliminar convertendo de ASCII
    cTextoDescript := '';
    for nIndice := 2 to nTamanhoTotal - 1 do
    begin
      cTextoDescript := cTextoDescript + Chr(StrToIntDef(Copy(cTexto, (nIndice * 3) - 2, 3), 0));
    end;

    // 4. Coloca caracteres pares após ímpares
    cTexto := cTextoDescript;
    cTextoDescript := '';

    for nIndice := nCaracteresPares + 1 to cTexto.Length do
    begin
      cTextoDescript := cTextoDescript + cTexto[nIndice];

      if (nIndice - nCaracteresPares) <= nCaracteresPares then
        cTextoDescript := cTextoDescript + cTexto[nIndice - nCaracteresPares];
    end;

    // 5. Retorna cortando no tamanho exato
    Result := Copy(cTextoDescript, 1, nTamanhoDeRetorno);

  except
    on E: Exception do
      raise ECriptografiaException.Create('Falha ao descriptografar a senha do Oracle: ' + E.Message);
  end;
end;

class function TCryptoUtils.TratarSenha(const AcSenha: string): string;
begin
  if AcSenha.Trim.IsEmpty or
     (AcSenha = '153')    or
     SameText(AcSenha, 'VIASOFT') then
    Exit(AcSenha);

  Result := Descriptografar(AcSenha);
end;

end.
