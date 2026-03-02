program FormatadorXML;

uses
  Vcl.Forms,
  View.Principal in 'Views\View.Principal.pas' {ViewPrincipal},
  Infra.Database.Oracle in 'Infra\Infra.Database.Oracle.pas' {DataModule1: TDataModule},
  Controller.Principal in 'Controllers\Controller.Principal.pas',
  Model.Conexao in 'Models\Model.Conexao.pas',
  Model.ArquivoXML in 'Models\Model.ArquivoXML.pas',
  Infra.LeitorConexoes in 'Infra\Infra.LeitorConexoes.pas',
  Infra.PythonBridge in 'Infra\Infra.PythonBridge.pas',
  Service.GerenciadorDiretorio in 'Services\Service.GerenciadorDiretorio.pas',
  Service.ExtratorDados in 'Services\Service.ExtratorDados.pas',
  Interfaces.LeitorConexoes in 'Interfaces\Interfaces.LeitorConexoes.pas',
  FormatadorXML.dxSettings in 'FormatadorXML.dxSettings.pas',
  Infra.Criptografia in 'Infra\Infra.Criptografia.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
