unit Interfaces.ExtratorDados;

interface

type
  IExtratorDados = interface
    ['{D7A2B4F1-8E3C-49D5-A1F6-C5B2E8D9A4C3}']

    function ProcessarNotaFiscal(const AcCaminhoXMLEntrada, AcCaminhoXMLSaida, AcChaveBuscaOracle: string): Boolean;
  end;

implementation

end.
