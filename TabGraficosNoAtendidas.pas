unit TabGraficosNoAtendidas;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VCLTee.Series, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart;

type
  TPagesDlg1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    OKBtn: TButton;
    Button1: TButton;
    Panel4: TPanel;
    Chart2: TChart;
    BarSeries1: TBarSeries;
    PieSeries1: TPieSeries;
    Panel5: TPanel;
    Button2: TButton;
    Chart1: TChart;
    BarSeries2: TBarSeries;
    PieSeries2: TPieSeries;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PagesDlg1: TPagesDlg1;

implementation

uses Main, Generics.Collections, TDictionary, func, datamodule;

{$R *.dfm}

procedure TPagesDlg1.Button1Click(Sender: TObject);
begin

  Chart2.Series[0].Active := not Chart2.Series[0].Active;
  Chart2.Series[1].Active := not Chart2.Series[1].Active;

  Chart1.Series[0].Active := not Chart1.Series[0].Active;
  Chart1.Series[1].Active := not Chart1.Series[1].Active;
  {
  Chart4.Series[0].Active := not Chart4.Series[0].Active;
  Chart4.Series[1].Active := not Chart4.Series[1].Active;

  Chart5.Series[0].Active := not Chart5.Series[0].Active;
  Chart5.Series[1].Active := not Chart5.Series[1].Active;
  }
end;

procedure TPagesDlg1.Button2Click(Sender: TObject);
begin
  //Path := ExtractfilePath(Application.ExeName);
  Chart2.SaveToBitmapFile(Path+'\Desconexion.bmp');
  Chart1.SaveToBitmapFile(Path+'\NoResp.bmp');
end;

procedure TPagesDlg1.FormCreate(Sender: TObject);
var
  Enum: TPair<Variant, TAssoc>;
begin
  PageControl1.ActivePage:=TabSheet2;

  with datamodule2 do
  begin

    With Chart2.Series[0] do
    begin
      AddXY(0, abandoned, 'Abandonada');
      AddXY(1, timeout, 'No Contestada');
    end;

    With Chart2.Series[1] do
    begin
      AddXY(0, abandoned, 'Abandonada');
      AddXY(1, timeout, 'No Contestada');
    end;

    for Enum in abandon_calls_queue.All do
    begin

      With Barseries2 do
      begin
        AddXY(Enum.Key, Enum.Value.Val, Enum.Key);
      end;

      With PieSeries2 do
      begin
        AddXY(Enum.Key, Enum.Value.Val, Enum.Key);
      end;

    end;


  end;

end;

procedure TPagesDlg1.OKBtnClick(Sender: TObject);
begin
  Close;
end;

end.

