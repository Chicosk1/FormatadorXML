unit Interfaces.PythonBridge;

interface

type
  IPythonBridge = interface
    ['{8A5E2E21-7B1A-4D78-9F6D-3B5E8D2A1C94}']
    function ValidarXML(const AcCaminhoXML: string): Boolean;
    function FormatarXML(const AcCaminhoXMLEntrada, AcCaminhoJSON, AcCaminhoXMLSaida: string): Boolean;
  end;

implementation

end.
