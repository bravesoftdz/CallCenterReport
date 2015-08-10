unit FmDB;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IniFiles,
  System.Win.Registry;

type
  TOKRightDlg2 = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKRightDlg2: TOKRightDlg2;

implementation

uses
  func, Main;
{$R *.dfm}

procedure TOKRightDlg2.FormCreate(Sender: TObject);
begin
  SettingsFile := TRegistryIniFile.Create('Software\' + Application.Title);
  //try
    BaseDeDatos:=SettingsFile.ReadString('Form1', 'BaseDeDatos', '');
    //Parser:=SettingsFile.ReadString('Form1', 'Parser', '');
    Theme:=SettingsFile.ReadString('Form1', 'Theme', '');
    //CargarRegistroSistema(Form1);
    If BasedeDatos <> '' then
        Application.CreateForm(TForm1, Form1);
        //Form1.Show;
  {
  finally
    FreeAndNil(SettingsFile);
    Close;
  end;
  }
end;

procedure TOKRightDlg2.OKBtnClick(Sender: TObject);
var
  SettingsFile: TCustomIniFile;
begin
  SettingsFile := TRegistryIniFile.Create('Software\' + Application.Title);
  try
    SettingsFile.WriteString('Form1', 'BaseDeDatos', Edit1.Text+'/conex.php' );
    SettingsFile.WriteString('Form1', 'Parser', Edit1.Text+'/parselog/parselog.php' );
    //BaseDeDatos:=SettingsFile.ReadString('Form1', 'BaseDeDatos', Edit1.Text);
  finally
    FreeAndNil(SettingsFile);
    Close;
  end;
  //Form1.Close;
end;

end.
