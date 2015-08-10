program CallCenterReport;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  datamodule in 'datamodule.pas' {DataModule2: TDataModule},
  TDictionary in 'TDictionary.pas',
  FmDB in 'FmDB.pas' {OKRightDlg2},
  func in 'func.pas',
  Find in 'Find.pas' {OKRightDlg},
  Vcl.Themes,
  Vcl.Styles,
  TabGraficosDistribuidas in 'TabGraficosDistribuidas.pas' {PagesDlg2},
  TabGraficosAtendidas in 'TabGraficosAtendidas.pas' {PagesDlg},
  TabGraficosNoAtendidas in 'TabGraficosNoAtendidas.pas' {PagesDlg1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //TStyleManager.TrySetStyle('Luna');
  Application.Title := 'Call Center Report';
  TStyleManager.TrySetStyle('Luna');
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TOKRightDlg2, OKRightDlg2);
  //Application.CreateForm(TPagesDlg2, PagesDlg2);
  //Application.CreateForm(TPagesDlg, PagesDlg);
  //Application.CreateForm(TPagesDlg1, PagesDlg1);
  //FmDB
  //Application.CreateForm(TForm1, Form1);
  //Application.CreateForm(TOKRightDlg, OKRightDlg);
  Application.Run;
end.
