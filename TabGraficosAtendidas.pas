unit TabGraficosAtendidas;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VCLTee.Series, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart;

type
  TPagesDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    OKBtn: TButton;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Panel3: TPanel;
    Chart1: TChart;
    Series1: TBarSeries;
    Series2: TPieSeries;
    Button1: TButton;
    Panel4: TPanel;
    Chart2: TChart;
    BarSeries1: TBarSeries;
    PieSeries1: TPieSeries;
    Panel5: TPanel;
    Chart3: TChart;
    BarSeries2: TBarSeries;
    PieSeries2: TPieSeries;
    Panel6: TPanel;
    Chart4: TChart;
    BarSeries3: TBarSeries;
    PieSeries3: TPieSeries;
    Panel7: TPanel;
    Chart5: TChart;
    BarSeries4: TBarSeries;
    PieSeries4: TPieSeries;
    Button2: TButton;
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
  PagesDlg: TPagesDlg;

implementation

uses Main, Generics.Collections, TDictionary, func, datamodule;

{$R *.dfm}

procedure TPagesDlg.Button1Click(Sender: TObject);
begin
  Chart1.Series[0].Active := not Chart1.Series[0].Active;
  Chart1.Series[1].Active := not Chart1.Series[1].Active;

  Chart2.Series[0].Active := not Chart2.Series[0].Active;
  Chart2.Series[1].Active := not Chart2.Series[1].Active;

  Chart3.Series[0].Active := not Chart3.Series[0].Active;
  Chart3.Series[1].Active := not Chart3.Series[1].Active;

  Chart4.Series[0].Active := not Chart4.Series[0].Active;
  Chart4.Series[1].Active := not Chart4.Series[1].Active;

  Chart5.Series[0].Active := not Chart5.Series[0].Active;
  Chart5.Series[1].Active := not Chart5.Series[1].Active;
end;

procedure TPagesDlg.Button2Click(Sender: TObject);
begin
  //Path := ExtractfilePath(Application.ExeName);
  Chart1.SaveToBitmapFile(Path+'\GraficoTiempo.bmp');
  Chart2.SaveToBitmapFile(Path+'\GraficoNumero.bmp');
  Chart3.SaveToBitmapFile(Path+'\GraficoServicio.bmp');
  Chart4.SaveToBitmapFile(Path+'\GraficoRespondidas.bmp');
  Chart5.SaveToBitmapFile(Path+'\GraficoDesconexion.bmp');
end;

procedure TPagesDlg.FormCreate(Sender: TObject);
var
  Enum: TPair<Variant, TAssoc>;
  iRowCount   : Integer;
  tmp: string;
  partial_total: integer;
begin
    PageControl1.ActivePage:=TabSheet1;

    iRowCount := 1;

    with datamodule2 do
    begin

      for Enum in total_calls2.All do
      begin

        tmp:=SegToFormatHour(StrToInt(total_time2[Enum.Key].Val));

        Chart1.Series[0].AddXY(iRowCount, total_time2[Enum.Key].Val, Enum.Key+' - '+tmp);
        Chart1.Series[1].AddXY(iRowCount, total_time2[Enum.Key].Val, Enum.Key+' - '+tmp);

        Chart2.Series[0].AddXY(iRowCount, Enum.Value.Val, Enum.Key);
        Chart2.Series[1].AddXY(iRowCount, Enum.Value.Val, Enum.Key);

        inc(iRowCount);

      end;

      iRowCount := 1;
      for Enum in answer.All do
      begin

        partial_total := partial_total+StrTofloat(Enum.Value.Val);

        Chart3.Series[0].AddXY(iRowCount, partial_total, IntToStr(Enum.Key)+' Segs.');
        Chart3.Series[1].AddXY(iRowCount, partial_total, IntToStr(Enum.Key)+' Segs.');

        inc(iRowCount);
      end;

      iRowCount := 1;
      for Enum in total_calls_queue.All do
      begin
        if total_calls>0 then percent := Enum.Value.Val * 100 / total_calls else percent := 0;

        Chart4.Series[0].AddXY(iRowCount, Enum.Value.Val, IntToStr(Enum.Key)+' - '+Formatfloat('0.##',percent)+' %');
        Chart4.Series[1].AddXY(iRowCount, Enum.Value.Val, IntToStr(Enum.Key)+' - '+Formatfloat('0.##',percent)+' %');

        inc(iRowCount);
      end;

      Chart5.Series[0].AddXY(0, hangup_cause['COMPLETEAGENT'].Val, 'Agente', clBlue);
      Chart5.Series[0].AddXY(1, hangup_cause['COMPLETECALLER'].Val, 'Llamante', clRed);
      Chart5.Series[1].AddXY(0, hangup_cause['COMPLETEAGENT'].Val, 'Agente', clBlue);
      Chart5.Series[1].AddXY(1, hangup_cause['COMPLETECALLER'].Val, 'Llamante', clRed);

    end;

end;

procedure TPagesDlg.OKBtnClick(Sender: TObject);
begin
  Close;
end;

end.

