program DelphiApp;

uses
  Vcl.Forms,
  MainForm in 'View\MainForm.pas' {Form1},
  ConnectionService in 'Services\ConnectionService.pas',
  MainController in 'Controllers\MainController.pas',
  ConfigService in 'Services\ConfigService.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TFormatadorXML, FormatadorXML);
  Application.Run;
end.
