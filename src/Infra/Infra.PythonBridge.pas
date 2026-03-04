unit Infra.PythonBridge;

interface

uses
  System.SysUtils, Winapi.Windows, Interfaces.PythonBridge;

type
  TPythonBridge = class(TInterfacedObject, IPythonBridge)
  private
    FcCaminhoPythonExe: string;
    FcCaminhoScripts: string;
    function ExecutarProcessoEmBackground(const AcComando: string): Boolean;

  public
    constructor Create(const AcCaminhoPythonExe, AcCaminhoScripts: string);

    function ValidarXML(const AcCaminhoXML: string): Boolean;
    function FormatarXML(const AcCaminhoXMLEntrada, AcCaminhoJSON, AcCaminhoXMLSaida: string): Boolean;
  end;

implementation

{ TPythonBridge }

constructor TPythonBridge.Create(const AcCaminhoPythonExe, AcCaminhoScripts: string);
begin
  FcCaminhoPythonExe := AcCaminhoPythonExe;
  FcCaminhoScripts   := AcCaminhoScripts;
end;

function TPythonBridge.ExecutarProcessoEmBackground(const AcComando: string): Boolean;
var
  oStartupInfo: TStartupInfo;
  oProcessInfo: TProcessInformation;
  bCriouProcesso: Boolean;
  nExitCode: Cardinal;
  cComandoExecucao: string;
begin
  ZeroMemory(@oStartupInfo, SizeOf(oStartupInfo));
  oStartupInfo.cb := SizeOf(oStartupInfo);

  oStartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  oStartupInfo.wShowWindow := SW_HIDE;

  cComandoExecucao := AcComando;

  bCriouProcesso := CreateProcess(
    nil,
    PChar(cComandoExecucao),
    nil,
    nil,
    False,
    CREATE_NO_WINDOW or NORMAL_PRIORITY_CLASS,
    nil,
    nil,
    oStartupInfo,
    oProcessInfo
  );

  if bCriouProcesso then
  begin
    WaitForSingleObject(oProcessInfo.hProcess, INFINITE);

    GetExitCodeProcess(oProcessInfo.hProcess, nExitCode);

    CloseHandle(oProcessInfo.hProcess);
    CloseHandle(oProcessInfo.hThread);

    Result := (nExitCode = 0);
  end
  else
  begin
    Result := False;
  end;
end;

function TPythonBridge.ValidarXML(const AcCaminhoXML: string): Boolean;
var
  cComando: string;
begin
  cComando := Format('"%s" "%sxml_validator.py" "%s"',
    [FcCaminhoPythonExe, FcCaminhoScripts, AcCaminhoXML]);

  Result := ExecutarProcessoEmBackground(cComando);
end;

function TPythonBridge.FormatarXML(const AcCaminhoXMLEntrada, AcCaminhoJSON, AcCaminhoXMLSaida: string): Boolean;
var
  cComando: string;
begin
  cComando := Format('"%s" "%smain_formatter.py" "%s" "%s" "%s"',
    [FcCaminhoPythonExe, FcCaminhoScripts, AcCaminhoXMLEntrada, AcCaminhoJSON, AcCaminhoXMLSaida]);

  Result := ExecutarProcessoEmBackground(cComando);
end;

end.
