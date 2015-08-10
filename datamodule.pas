unit datamodule;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Client, IniFiles, Vcl.Forms, Vcl.Dialogs,
  System.JSON, Vcl.CheckLst, Generics.Collections, System.AnsiStrings,
  System.Math, TDictionary, System.Variants, Vcl.Graphics;

type
  TDataModule2 = class(TDataModule)
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    RESTRequest1: TRESTRequest;
    RESTRequest2: TRESTRequest;
    RESTRequest3: TRESTRequest;
    RESTRequest4: TRESTRequest;
    RESTRequest5: TRESTRequest;
    RESTRequest6: TRESTRequest;
    RESTRequest7: TRESTRequest;
    RESTRequest8: TRESTRequest;
    RESTRequest9: TRESTRequest;
    RESTRequest0: TRESTRequest;
    RESTClient2: TRESTClient;
    RESTRequest00: TRESTRequest;
    procedure RESTRequest1AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest2AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest3AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest4AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest5AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest6AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest7AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest8AfterExecute(Sender: TCustomRESTRequest);
    procedure Abandonado(Sender: TObject);
    procedure DistribucionHora(Sender: TObject);
    procedure DistribucionDia(Sender: TObject);
    procedure selects(Sender: TObject);
    procedure selectagentes(Sender: TObject);
    procedure selectcolas(Sender: TObject);
    procedure crea(Sender: TObject);
    procedure RESTRequest9AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest0AfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequest00AfterExecute(Sender: TCustomRESTRequest);
  private
    { Private declarations }
    query: string;
  public
    { Public declarations }
    info2: string;
    array_result, array_llamadas: TJSONArray;
    //BaseDeDatos: String;
    total_time2: TAssoc;
    total_calls2: TAssoc;
    answer: TAssoc;
    partial_total: double;
    total_calls_queue: TAssoc;
    percent: double;
    hangup_cause: TAssoc;
    total_hold: integer;
    total_duration: integer;
    total_calls: integer;
    transferidas: integer;
    colas, agentes: array of string;
    average_hold: double;
    average_duration: double;
    total_duration_print: string;
    total_hold2: TAssoc;
    grandtotal_hold: integer;
    grandtotal_time: integer;
    grandtotal_calls: integer;
    total_hangup: integer;
    transfers: TAssoc;
    totaltransfers: integer;
    abandoned: integer;
    abandon_end_pos: integer;
    abandon_start_pos: integer;
    total_hold_abandon: integer;
    op: string;
    timeout: integer;
    abandon_calls_queue: TAssoc;
    //fil: string;
    abandon_average_hold: double;
    abandon_average_start: integer;
    abandon_average_end: double;
    total_abandon: integer;
    ab, nc: integer;
    answer30: integer;
    answer45: integer;
    answer60: integer;
    answer75: integer;
    answer90: integer;
    answer91: integer;
    unanswered: integer;
    answered: integer;
    login: integer;
    logoff: integer;
    ans_by_hour,  unans_by_hour: TAssoc;
    total_time_by_hour, total_hold_by_hour: TAssoc;
    login_by_hour, logout_by_hour: TAssoc;
    unans_by_dw, ans_by_dw, total_time_by_dw, total_hold_by_dw, login_by_dw, logout_by_dw: TAssoc;
    average_call_duration, average_hold_duration: Double;
  end;

var
  DataModule2: TDataModule2;


implementation

uses
  Main, func;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule2.selects(Sender: TObject);
begin
  with Form1 do
  begin
    //try
      total_calls_queue := TAssoc.Create(False);
      answer := TAssoc.Create(False);

      hangup_cause := TAssoc.Create(False);
      hangup_cause['COMPLETECALLER'].Val:=0;
      hangup_cause['COMPLETEAGENT'].Val:=0;

      transfers := TAssoc.Create(False);

      total_calls2 := TAssoc.Create(False);
      total_hold2 := TAssoc.Create(False);
      total_time2 := TAssoc.Create(False);

      totaltransfers:=0;
      total_hold:=0;
      total_calls:=0;
      total_hangup:=0;
      transferidas:=0;
      average_duration:=0;
      total_duration:=0;
      total_duration_print:='';
      average_hold:=0;
      grandtotal_hold:=0;
      grandtotal_time:=0;
      grandtotal_calls:=0;
      partial_total:=0;


      query := 'SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent, qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3';
      query := query+' FROM queue_stats AS qs, qname AS q, qagent AS ag, qevent AS ac';
      query := query+' WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND qs.qevent = ac.event_id';
      query := query+' AND qs.datetime BETWEEN '+start+' AND '+end_;
      query := query+' AND q.queue IN ('+queue+')';
      query := query+' AND ag.agent IN ('+agent+')';
      query := query+' AND ac.event IN ("COMPLETECALLER", "COMPLETEAGENT", "TRANSFER", "CONNECT") ORDER BY qs.datetime';
      //query := query+' limit 0, 74999';

      RestRequest3.Params.ParameterByName('action').Value := 'select_all';
      RestRequest3.Params.ParameterByName('clase').Value := 'rep_dbsel';
      RestRequest3.Params.ParameterByName('valor').Value := query;
      //try
        RestRequest3.Execute;
      //finally
        query := 'SELECT count(ev.event) AS num, ev.event AS action';
        query := query+' FROM queue_stats AS qs, qname AS q, qevent AS ev';
        query := query+' WHERE qs.qname = q.qname_id and qs.qevent = ev.event_id';
        query := query+' and qs.datetime BETWEEN '+start+' and '+end_;
        query := query+' and q.queue IN ('+queue+')';
        query := query+' and ev.event IN ("COMPLETECALLER", "COMPLETEAGENT")';
        query := query+' GROUP BY ev.event ORDER BY ev.event';
        query := query+' limit 0, 74999';

        RestRequest5.Params.ParameterByName('action').Value := 'select_all';
        RestRequest5.Params.ParameterByName('clase').Value := 'rep_dbsel';
        RestRequest5.Params.ParameterByName('desde').Value := start;
        RestRequest5.Params.ParameterByName('hasta').Value := end_;
        RestRequest5.Params.ParameterByName('queue').Value := queue;
        RestRequest5.Params.ParameterByName('valor').Value := query;
        //try
          RestRequest5.Execute;
        //finally
          query := 'SELECT ag.agent AS agent, qs.info1 AS info1,  qs.info2 AS info2';
          query := query+' FROM  queue_stats AS qs, qevent AS ac, qagent as ag, qname As q';
          query := query+' WHERE qs.qevent = ac.event_id AND qs.qname = q.qname_id AND ag.agent_id = qs.qagent';
          query := query+' AND qs.datetime BETWEEN '+start+' AND '+end_;
          query := query+' AND  q.queue IN ('+queue+')  AND ag.agent in ('+agent+') AND  ac.event in ("TRANSFER")';
          query := query+' limit 0, 74999';

          RestRequest6.Params.ParameterByName('action').Value := 'select_all';
          RestRequest6.Params.ParameterByName('clase').Value := 'rep_dbsel';
          RestRequest6.Params.ParameterByName('desde').Value := start;
          RestRequest6.Params.ParameterByName('hasta').Value := end_;
          RestRequest6.Params.ParameterByName('queue').Value := queue;
          RestRequest6.Params.ParameterByName('agent').Value := agent;
          RestRequest6.Params.ParameterByName('valor').Value := query;
          //try
            RestRequest6.Execute;
          //finally
            query := 'SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent, qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3';
            query := query+' FROM queue_stats AS qs, qname AS q, qagent AS ag, qevent AS ac';
            query := query+' WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND qs.qevent = ac.event_id';
            query := query+' AND qs.datetime BETWEEN '+start+' AND '+end_;
            query := query+' AND q.queue IN ('+queue+')';
            query := query+' AND ag.agent IN ('+agent+')';
            query := query+' AND ac.event IN ("COMPLETECALLER", "COMPLETEAGENT") ORDER BY qs.datetime';
            query := query+' limit 0, 74999';
            //Memo2.Lines.Text:=query;

            RestRequest4.Params.ParameterByName('action').Value := 'select_all';
            RestRequest4.Params.ParameterByName('clase').Value := 'rep_dbsel';
            RestRequest4.Params.ParameterByName('desde').Value := start;
            RestRequest4.Params.ParameterByName('hasta').Value := end_;
            RestRequest4.Params.ParameterByName('queue').Value := queue;
            RestRequest4.Params.ParameterByName('agent').Value := agent;
            RestRequest4.Params.ParameterByName('valor').Value := query;
            //try
              RestRequest4.Execute;
            //finally
              query := 'SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent,';
              query := query+' qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3, qs.uniqueid AS uniqueid, qs.qevent AS qev';
              query := query+' FROM queue_stats AS qs, qname AS q, qagent AS ag, qevent AS ac WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND';
              query := query+' qs.qevent = ac.event_id AND qs.datetime BETWEEN '+start+' AND '+end_;
              query := query+' AND q.queue IN ('+queue+') AND ac.event IN ("ABANDON", "EXITWITHTIMEOUT", "ENTERQUEUE") ORDER BY qs.datetime';
              query := query+' limit 0, 74999';

              RestRequest7.Params.ParameterByName('action').Value := 'select_all';
              RestRequest7.Params.ParameterByName('clase').Value := 'rep_dbsel';
              //RestRequest7.Params.ParameterByName('desde').Value := start;
              //RestRequest7.Params.ParameterByName('hasta').Value := end_;
              //RestRequest7.Params.ParameterByName('queue').Value := queue;
              //RestRequest7.Params.ParameterByName('agent').Value := agent;
              RestRequest7.Params.ParameterByName('valor').Value := query;
              //try
                RestRequest7.Execute;
              //finally
                RestRequest8.Params.ParameterByName('action').Value := 'select_all';
                RestRequest8.Params.ParameterByName('clase').Value := 'rep_dbsel';
                //RestRequest7.Params.ParameterByName('desde').Value := start;
                //RestRequest7.Params.ParameterByName('hasta').Value := end_;
                //RestRequest7.Params.ParameterByName('queue').Value := queue;
                //RestRequest7.Params.ParameterByName('agent').Value := agent;
                RestRequest8.Params.ParameterByName('valor').Value := query;
                //try
                  RestRequest8.Execute;
                //finally
                  //try
                    Abandonado(Sender);
                  //finally
                    query := 'SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent,';
                    query := query+' qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3 FROM queue_stats AS qs, qname AS q,';
                    query := query+' qagent AS ag, qevent AS ac';
                    query := query+' WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND';
                    query := query+' qs.qevent = ac.event_id AND qs.datetime BETWEEN '+start+' AND '+end_;
                    query := query+' AND q.queue IN ('+queue+',"NONE") AND ac.event IN ("ABANDON", "EXITWITHTIMEOUT","COMPLETECALLER","COMPLETEAGENT","AGENTLOGIN","AGENTLOGOFF","AGENTCALLBACKLOGIN","AGENTCALLBACKLOGOFF")';
                    query := query+' ORDER BY qs.datetime';
                    query := query+' limit 0, 74999';

                    RestRequest9.Params.ParameterByName('action').Value := 'select_all';
                    RestRequest9.Params.ParameterByName('clase').Value := 'rep_dbsel';
                    //RestRequest7.Params.ParameterByName('desde').Value := start;
                    //RestRequest7.Params.ParameterByName('hasta').Value := end_;
                    //RestRequest7.Params.ParameterByName('queue').Value := queue;
                    //RestRequest7.Params.ParameterByName('agent').Value := agent;
                    RestRequest9.Params.ParameterByName('valor').Value := query;
                    //try
                      RestRequest9.Execute;
                    //finally
                      //try
                        DistribucionHora(Sender);
                      //finally
                        DistribucionDia(Sender);
                      //end;
                    //end;
                  //end;
                //end;
              //end;
            //end;
          //end;
        //end;
      //end;
    //except
    //  Abort;
    //  ShowMessage('No existen datos con este rango de consulta en algunos reportes');
    //end;

  end;

end;

procedure TDataModule2.DistribucionHora(Sender: TObject);
var
  i, iRowCount, g: integer;
  percent_unans, percent_ans: Double;
  key: string;
begin
  with Form1 do
  begin
    Gauge1.Progress := 0;

    iRowCount := StringGrid10.RowCount-1;

    Gauge1.MaxValue := 23;
    g:=0;

    for i := 0 to 23 do
    begin
      Gauge1.Progress := g;

      if i < 10 then key := '0'+inttostr(i) else key := inttostr(i);


      if NOT (ans_by_hour[key].Val > 0) then
      begin
        ans_by_hour[key].Val:=0;
        average_call_duration := 0;
        average_hold_duration := 0;
      end else begin
        average_call_duration := Double(total_time_by_hour[key].Val / ans_by_hour[key].Val);
        average_hold_duration := Double(total_hold_by_hour[key].Val / ans_by_hour[key].Val);
      end;

      if NOT (unans_by_hour[key].Val > 0) then
        unans_by_hour[key].Val:=0;

			if answered > 0 then
        percent_ans   := ans_by_hour[key].Val   * 100 / answered
      else
        percent_ans := 0;

      if unanswered > 0 then
        percent_unans := unans_by_hour[key].Val * 100 / unanswered
      else
        percent_unans := 0;

      if NOT (login_by_hour[key].Val > 0) then
        login_by_hour[key].Val := 0;

      if NOT (logout_by_hour[key].Val > 0) then
        logout_by_hour[key].Val := 0;

      StringGrid10.Cells[0,iRowCount] := FloatToStrF(strtoint(key), ffNumber, 2, 0);
      StringGrid10.Cells[1,iRowCount] := ans_by_hour[key].Val;
      StringGrid10.Cells[2,iRowCount] := FloatToStrF(percent_ans, ffNumber, 10, 2);
      StringGrid10.Cells[3,iRowCount] := unans_by_hour[key].Val;
      StringGrid10.Cells[4,iRowCount] := FloatToStrF(percent_unans, ffNumber, 10, 2);
      StringGrid10.Cells[5,iRowCount] := SegToFormatHour(round(average_call_duration));
      //StringGrid10.Cells[6,iRowCount] := FloatToStrF(average_hold_duration, ffNumber, 10, 0);
      StringGrid10.Cells[6,iRowCount] := SegToFormatHour(round(average_hold_duration));
      StringGrid10.Cells[7,iRowCount] := login_by_hour[key].Val;
      StringGrid10.Cells[8,iRowCount] := logout_by_hour[key].Val;

      inc(iRowCount);

      inc(g);

      With Series8 do
      begin
        AddXY(strtoint(key), unans_by_hour[key].Val, '' , clRed);
      end;

      With Series9 do
      begin
        AddXY(strtoint(key), ans_by_hour[key].Val, '' , clBlue);
      end;

      With Series10 do
      begin
        AddXY(strtoint(key), round(average_call_duration));
      end;

      With Series11 do
      begin
        AddXY(strtoint(key), round(average_hold_duration));
      end;
    end;

    StringGrid10.RowCount:=iRowCount;

  end;
end;

procedure TDataModule2.DistribucionDia(Sender: TObject);
var
  iRowCount, g: integer;
  percent_unans, percent_ans: Double;
  dia: integer;
  key: string;
begin
  with Form1 do
  begin
    Gauge1.Progress := 0;

    iRowCount := StringGrid11.RowCount-1;

    Gauge1.MaxValue := 7;
    g:=0;

    for dia := 0 to 6 do
    begin

      Gauge1.Progress := g;

      case dia of
           0: key:='lunes';
           1: key:='martes';
           2: key:='mi�rcoles';
           3: key:='jueves';
           4: key:='viernes';
           5: key:='s�bado';
           6: key:='domingo';
      end;

      if NOT (total_time_by_dw[key].Val > 0) then
        total_time_by_dw[key].Val := 0;

      if NOT (total_hold_by_dw[key].Val > 0) then
        total_hold_by_dw[key].Val := 0;


      if NOT (ans_by_dw[key].Val > 0) then
      begin
        ans_by_dw[key].Val:=0;
        average_call_duration := 0;
        average_hold_duration := 0;
      end else begin
        average_call_duration := Double(total_time_by_dw[key].Val / ans_by_dw[key].Val);
        average_hold_duration := Double(total_hold_by_dw[key].Val / ans_by_dw[key].Val);
      end;

      if NOT (unans_by_dw[key].Val > 0) then
        unans_by_dw[key].Val:=0;

			if answered > 0 then
        percent_ans   := ans_by_dw[key].Val   * 100 / answered
      else
        percent_ans := 0;

      if unanswered > 0 then
        percent_unans := unans_by_dw[key].Val * 100 / unanswered
      else
        percent_unans := 0;

      if NOT (login_by_dw[key].Val > 0) then
        login_by_dw[key].Val := 0;

      if NOT (logout_by_dw[key].Val > 0) then
        logout_by_dw[key].Val := 0;

      StringGrid11.Cells[0,iRowCount] := key;
      StringGrid11.Cells[1,iRowCount] := ans_by_dw[key].Val;
      StringGrid11.Cells[2,iRowCount] := FloatToStrF(percent_ans, ffNumber, 10, 2);
      StringGrid11.Cells[3,iRowCount] := unans_by_dw[key].Val;
      StringGrid11.Cells[4,iRowCount] := FloatToStrF(percent_unans, ffNumber, 10, 2);
      StringGrid11.Cells[5,iRowCount] := SegToFormatHour(round(average_call_duration));
      //StringGrid11.Cells[6,iRowCount] := FloatToStrF(average_hold_duration, ffNumber, 10, 0);
      StringGrid11.Cells[6,iRowCount] := SegToFormatHour(round(average_hold_duration));
      StringGrid11.Cells[7,iRowCount] := login_by_dw[key].Val;
      StringGrid11.Cells[8,iRowCount] := logout_by_dw[key].Val;

      inc(iRowCount);

      inc(g);

      With Series12 do
      begin
        AddXY(dia, ans_by_dw[key].Val, key+' '+IntToStr(ans_by_dw[key].Val));
      end;

      With Series13 do
      begin
        AddXY(dia, unans_by_dw[key].Val, key+' '+IntToStr(unans_by_dw[key].Val));
      end;

      With Series14 do
      begin
        AddXY(dia, round(average_call_duration), key+' '+SegToFormatHour(round(average_call_duration)));
      end;

      With Series15 do
      begin
        AddXY(dia, round(average_hold_duration), key+' '+SegToFormatHour(round(average_hold_duration)));
      end;

    end;

    StringGrid11.RowCount:=iRowCount;

  end;
end;


procedure TDataModule2.selectcolas(Sender: TObject);
begin
  with Form1 do
  begin
    query := 'SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent, qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3';
    query := query+' FROM queue_stats AS qs, qname AS q, qagent AS ag, qevent AS ac';
    query := query+' WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND qs.qevent = ac.event_id';
  //	query := query+' AND qs.datetime BETWEEN '+start+' AND '+end_;
  //	query := query+' AND q.queue IN ('+queue+')';
    query := query+' AND ag.agent IN ('+agent+')';
    query := query+' AND ac.event IN ("COMPLETECALLER", "COMPLETEAGENT", "TRANSFER", "CONNECT") ORDER BY qs.datetime';
    query := query+' limit 0, 74999';

    RestRequest3.Params.ParameterByName('action').Value := 'select_all';
    RestRequest3.Params.ParameterByName('clase').Value := 'rep_dbsel';
    RestRequest3.Params.ParameterByName('valor').Value := query;
    RestRequest3.Execute;

  end;

end;


procedure TDataModule2.selectagentes(Sender: TObject);
begin

  with Form1 do
  begin
    {
    query := 'SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent, qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3';
    query := query+' FROM queue_stats AS qs, qname AS q, qagent AS ag, qevent AS ac';
    query := query+' WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND qs.qevent = ac.event_id';
  //	query := query+' AND qs.datetime BETWEEN '+start+' AND '+end_;
    query := query+' AND q.queue IN ('+queue+')';
  //  query := query+' AND ag.agent IN ('+agent+')';
    query := query+' AND ac.event IN ("COMPLETECALLER", "COMPLETEAGENT", "TRANSFER", "CONNECT") ORDER BY qs.datetime';
    query := query+' limit 0, 74999';
    }

    query := 'SELECT q.queue AS qname, ag.agent AS qagent FROM qname AS q, qagent AS ag WHERE q.queue IN ('+queue+') limit 0, 74999';

      RestRequest2.Params.ParameterByName('action').Value := 'select_all';
      RestRequest2.Params.ParameterByName('clase').Value := 'rep_dbsel';
    //  RestRequest3.Params.ParameterByName('desde').Value := start;
    //  RestRequest3.Params.ParameterByName('hasta').Value := end_;
    //  RestRequest2.Params.ParameterByName('queue').Value := queue;
    //  RestRequest3.Params.ParameterByName('agent').Value := agent;
      RestRequest2.Params.ParameterByName('valor').Value := query;
      RestRequest2.Execute;

  end;

end;


procedure TDataModule2.Crea(Sender: TObject);
begin
  with Form1 do
  begin
    abandoned:=0;
    timeout:=0;
    abandon_average_hold:=0;
    abandon_average_start:=0;
    abandon_average_end:=0;
    total_abandon:=0;
    transferidas:=0;
    totaltransfers:=0;
    total_hangup:=0;
    //total_calls:=0;
    //SetLength(total_calls2, 1);
    total_duration:=0;
    //SetLength(total_calls_queue, 1);

    RestRequest1.Params.ParameterByName('action').Value := 'select_all';
    RestRequest1.Params.ParameterByName('clase').Value := 'rep_dbsel';
    RestRequest1.Params.ParameterByName('valor').Value := 'select * from qname';
    //campo:=2;
    //compo:='Form1.CheckListBox1';
    //try
      RestRequest1.Execute;
    //except
      //Abort;
    //end;
  end;

end;


procedure TDataModule2.RESTRequest00AfterExecute(Sender: TCustomRESTRequest);
begin
    Form1.Memo4.Lines.Add(RESTResponse1.Content);
end;

procedure TDataModule2.RESTRequest0AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
begin
    jv := RESTResponse1.JSONValue as TJSONObject;
    try

      data := jv.GetValue('data');

      jo := data as TJSONArray;

      for LMessage in jo do
      begin

        LLine := TJSONObject(LMessage);
        LData := LLine.get(0);
            Form1.StatusBar1.Panels[2].Text:='Ultimo Parser DB (queue_stats)......: '+LData.JsonValue.Value; //+' - '+LData1.JsonValue.Value;

      end;

    except
      raise;
    end;
end;

procedure TDataModule2.RESTRequest1AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
begin

  jv := RESTResponse1.JSONValue as TJSONObject;
  try

    data := jv.GetValue('data');

    jo := data as TJSONArray;

    for LMessage in jo do
    begin

      LLine := TJSONObject(LMessage);
      LData := LLine.get(1);
      Form1.CheckListBox1.Items.Add(LData.JsonValue.Value);

    end;

  except
    raise;
  end;
end;

procedure TDataModule2.RESTRequest2AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
    i, j: integer;
    g: integer;
begin

  jv:=RESTResponse1.JSONValue as TJSONObject;
  try


    g:= 0;
    i:= 0;

    data := jv.GetValue('data');
    jo := data as TJSONArray;

    Form1.Gauge1.MaxValue := jo.Size;

    for LMessage in jo do
    begin

      Form1.Gauge1.Progress := g;
      LLine := TJSONObject(LMessage);

      LData := LLine.get(1);

      j := AScan(Form1.agentes, LData.JsonValue.Value);
      if j = -1 then
      begin
        SetLength(Form1.agentes, i+1);
        Form1.agentes[i]:= LData.JsonValue.Value;
        inc(i);
      end;

      inc(g);
    end;

  except
    raise;
  end;
end;

procedure TDataModule2.RESTRequest3AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
    g: integer;
    //total_calls: integer;
begin

  with Form1 do
  begin

    jv:=RESTResponse1.JSONValue as TJSONObject;
    try

      g:= 0;

      data := jv.GetValue('data');
      jo := data as TJSONArray;

      Gauge1.MaxValue := jo.Size;

      for LMessage in jo do
      begin

        Gauge1.Progress := g;
        LLine := TJSONObject(LMessage);

        LData := LLine.get(3);
        if (LData.JsonValue.Value <> 'TRANSFER') AND (LData.JsonValue.Value <> 'CONNECT') then
        begin

          LData := LLine.get(4);
          total_hold:=total_hold+StrToInt(LData.JsonValue.Value);

          LData := LLine.get(5);
          total_duration:=total_duration+StrToInt(LData.JsonValue.Value);
          //total_calls:=total_calls+1;
          inc(total_calls);

          LData := LLine.get(1);
          total_calls_queue[StrToInt(LData.JsonValue.Value)].Val:=total_calls_queue[StrToInt(LData.JsonValue.Value)].Val+1;
        end else

        LData := LLine.get(3);
        if (LData.JsonValue.Value) = 'TRANSFER' then
          transferidas:=transferidas+1;

        if (LData.JsonValue.Value) = 'CONNECT' then
        begin

          LData := LLine.get(4);
          if (StrToInt(LData.JsonValue.Value) >= 0) AND (StrToInt(LData.JsonValue.Value) <= 15) then
            answer['15'].Val:=answer['15'].Val+1;

          if (StrToInt(LData.JsonValue.Value) >= 16) AND (StrToInt(LData.JsonValue.Value) <= 30) then
            answer['30'].Val:=answer['30'].Val+1;

          if (StrToInt(LData.JsonValue.Value) >= 31) AND (StrToInt(LData.JsonValue.Value) <= 45) then
            answer['45'].Val:=answer['45'].Val+1;

          if (StrToInt(LData.JsonValue.Value) >= 46) AND (StrToInt(LData.JsonValue.Value) <= 60) then
            answer['60'].Val:=answer['60'].Val+1;

          if (StrToInt(LData.JsonValue.Value) >= 61) AND (StrToInt(LData.JsonValue.Value) <= 75) then
            answer['75'].Val:=answer['75'].Val+1;

          if (StrToInt(LData.JsonValue.Value) >= 76) AND (StrToInt(LData.JsonValue.Value) <= 90) then
            answer['90'].Val:=answer['90'].Val+1;


          if (StrToInt(LData.JsonValue.Value) >= 91) then
            answer['91'].Val:=answer['91'].Val+1;
        end;
        inc(g);
      end;

      if total_calls > 0 then
      begin
        average_hold     := total_hold     / total_calls;
        average_duration := total_duration / total_calls;
        average_hold := strtofloat(format('%n', [average_hold]));
        average_duration := strtofloat(format('%n', [average_duration]));
      end else
      begin
        average_hold     := 0;
        average_duration := 0;
      end;
      total_duration_print := SegToFormatHour(total_duration);

    except
      raise;
    end;

  end;

end;


procedure TDataModule2.RESTRequest4AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
    LData1      : TJSONPair;
    Enum: TPair<Variant, TAssoc>;
    i : integer;
    percentage_calls: double;
    percentage_time: double;
    avg_time: integer;
    avg_hold: integer;
    tmp: string;
    total_y_transfer: double;
    partes: Tarrayofstring;
    agent, extension: string;
    g: integer;
    iRowCount   : Integer;
    //total_calls: integer;
begin
    with Form1 do
    begin
      Gauge1.Progress := 0;
      total_y_transfer:= 0;

      jv:=RESTResponse1.JSONValue as TJSONObject;
      try

        g:= 0;

        data := jv.GetValue('data');
        jo := data as TJSONArray;

        Gauge1.MaxValue := jo.Size;

        for LMessage in jo do
        begin

          Gauge1.Progress := g;
          LLine := TJSONObject(LMessage);

          LData := LLine.get(2);

          total_calls2[LData.JsonValue.Value].Val:=total_calls2[LData.JsonValue.Value].Val+1;


          LData1:= LLine.get(4);
          total_hold2[LData.JsonValue.Value].Val:=total_hold2[LData.JsonValue.Value].Val+StrToInt(LData1.JsonValue.Value);

          LData1:= LLine.get(5);
          total_time2[LData.JsonValue.Value].Val:=total_time2[LData.JsonValue.Value].Val+StrToInt(LData1.JsonValue.Value);

          LData:= LLine.get(4);
          grandtotal_hold:=grandtotal_hold+StrToInt(LData.JsonValue.Value);

          LData:= LLine.get(5);
          grandtotal_time:=grandtotal_time+StrToInt(LData.JsonValue.Value);
          grandtotal_calls:=grandtotal_calls+1;


          inc(g);

        end;

        iRowCount   := StringGrid1.RowCount-1;

        if total_calls2.All<>nil then
        begin
          for Enum in total_calls2.All do
          begin

            if ((Enum.Key<>'') and (Enum.Key<>' ')) then begin

              StringGrid1.Cells[0,iRowCount] := Enum.Key;
              StringGrid1.Cells[1,iRowCount] := Enum.Value.Val;

              if grandtotal_calls > 0 then
                percentage_calls := StrTofloat(Enum.Value.Val) * 100 / grandtotal_calls
              else
                percentage_calls := 0;
              StringGrid1.Cells[2,iRowCount] := Formatfloat('0.##',percentage_calls);

              StringGrid1.Cells[3,iRowCount] := SegToFormatHour(StrToInt(total_time2[Enum.Key].Val));
              //DateTimeToString(tmp, 'mm:ss', SegToFormatHour(StrToInt(total_time2[Enum.Key].Val)));
              //StringGrid1.Cells[3,iRowCount]:=tmp;

              if grandtotal_time > 0 then
                percentage_time := StrTofloat(total_time2[Enum.Key].Val) * 100 / grandtotal_time
              else
                percentage_time := 0;
              StringGrid1.Cells[4,iRowCount] := Formatfloat('0.##',percentage_time);

              avg_time := round(total_time2[Enum.Key].Val / Enum.Value.Val);
              StringGrid1.Cells[5,iRowCount] := SegToFormatHour(avg_time);
              //DateTimeToString(tmp, 'mm:ss', SegToFormatHour(avg_time));
              //StringGrid1.Cells[5,iRowCount]:=tmp;

              StringGrid1.Cells[6,iRowCount] := SegToFormatHour(StrToInt(total_hold2[Enum.Key].Val));
              //DateTimeToString(tmp, 'mm:ss', SegToFormatHour(StrToInt(total_hold2[Enum.Key].Val)));
              //StringGrid1.Cells[6,iRowCount]:=tmp;

              avg_hold := round(total_hold2[Enum.Key].Val / Enum.Value.Val);
              StringGrid1.Cells[7,iRowCount] := SegToFormatHour(avg_hold);
              //DateTimeToString(tmp, 'mm:ss', SegToFormatHour(avg_hold));
              //StringGrid1.Cells[7,iRowCount]:=tmp;

              { set our X array }
              With Series1 do
              begin
                tmp:=SegToFormatHour(StrToInt(total_time2[Enum.Key].Val));
                AddXY(iRowCount, total_time2[Enum.Key].Val, Enum.Key+' - '+tmp);
                //AddXY(iRowCount, total_time2[Enum.Key].Val, Enum.Key);
              end;

              With Series2 do
              begin
                AddXY(iRowCount, Enum.Value.Val, Enum.Key);
              end;


              inc(iRowCount);

            end;

          end;

        end;

        StringGrid1.RowCount:=iRowCount;


        iRowCount   := StringGrid2.RowCount-1;

        if answer.All <> nil then
        begin
          for Enum in answer.All do
          begin
            total_y_transfer:=total_y_transfer+StrTofloat(Enum.Value.Val);

            StringGrid2.Cells[0,iRowCount] := IntToStr(Enum.Key);

            partial_total := partial_total+StrTofloat(Enum.Value.Val);
            StringGrid2.Cells[1,iRowCount] := FloatToStr(partial_total);

            if Enum.Value.Val > 0 then StringGrid2.Cells[2,iRowCount] := IntToStr(Enum.Value.Val);

            percent:=partial_total*100/total_y_transfer;
            StringGrid2.Cells[3,iRowCount] := Formatfloat('0.##',percent);

            With Series3 do
            begin
              AddXY(iRowCount, partial_total, IntToStr(Enum.Key)+' Segs.');
            end;

            inc(iRowCount);
          end;

        end;

        StringGrid2.RowCount:=iRowCount;

        iRowCount   := StringGrid3.RowCount-1;

        if total_calls_queue.All <> nil then
        begin
          for Enum in total_calls_queue.All do
          begin

            if total_calls>0 then percent := Enum.Value.Val * 100 / total_calls else percent := 0;

            StringGrid3.Cells[0,iRowCount] := IntToStr(Enum.Key);
            StringGrid3.Cells[1,iRowCount] := IntToStr(Enum.Value.Val);
            StringGrid3.Cells[2,iRowCount] := Formatfloat('0.##',percent);

            With Series4 do
            begin
              AddXY(iRowCount, Enum.Value.Val, IntToStr(Enum.Key)+' - '+Formatfloat('0.##',percent)+' %');
            end;

            inc(iRowCount);
          end;

        end;

        StringGrid3.RowCount:=iRowCount;

        iRowCount   := StringGrid4.RowCount-1;

        StringGrid4.Cells[0,iRowCount] := 'Agente Cuelga';
        StringGrid4.Cells[1,iRowCount] := IntToStr(hangup_cause['COMPLETEAGENT'].Val);

        if total_hangup>0 then percent := hangup_cause['COMPLETEAGENT'].Val * 100 / total_hangup else percent := 0;
        StringGrid4.Cells[2,iRowCount] := Formatfloat('0.##',percent);

        inc(iRowCount);

        StringGrid4.Cells[0,iRowCount] := 'Llamante Cuelga';
        StringGrid4.Cells[1,iRowCount] := IntToStr(hangup_cause['COMPLETECALLER'].Val);

        if total_hangup>0 then percent := hangup_cause['COMPLETECALLER'].Val * 100 / total_hangup else percent := 0;
        StringGrid4.Cells[2,iRowCount] := Formatfloat('0.##',percent);

        With Series5 do
        begin
          AddXY(0, hangup_cause['COMPLETEAGENT'].Val, 'Agente', clBlue);
          AddXY(1, hangup_cause['COMPLETECALLER'].Val, 'Llamante', clRed);
        end;

        inc(iRowCount);
        StringGrid4.RowCount:=iRowCount;

        iRowCount   := StringGrid5.RowCount-1;

        if transfers.All <> nil then
        begin

          for Enum in transfers.All do
          begin
            partes := SplitString('^', Enum.Key);
            agent := partes[0];
            //partes := SplitString('@', Enum.Key);
            extension := partes[1];

            StringGrid5.Cells[0,iRowCount] := agent;
            StringGrid5.Cells[1,iRowCount] := extension;
            StringGrid5.Cells[2,iRowCount] := Enum.Value.Val;

            inc(iRowCount);
          end;

        end;

        StringGrid5.RowCount:=iRowCount;

      except
        raise;
      end;
    end;

end;

procedure TDataModule2.RESTRequest5AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
    LData1       : TJSONPair;
    g: integer;
begin
    with Form1 do
    begin
      Gauge1.Progress := 0;
      g:=0;

      jv:=RESTResponse1.JSONValue as TJSONObject;
      try

        data := jv.GetValue('data');
        jo := data as TJSONArray;

        Gauge1.MaxValue := jo.Size;

        for LMessage in jo do
        begin

          Gauge1.Progress := g;
          LLine := TJSONObject(LMessage);

          LData := LLine.get(1);
          LData1 := LLine.get(0);
          //label45.Caption:=LData.JsonValue.Value;
          hangup_cause[LData.JsonValue.Value].Val:=StrToInt(LData1.JsonValue.Value);
          total_hangup:=total_hangup+StrToInt(LData1.JsonValue.Value);

          inc(g);

        end;

      except
        raise;
      end;
    end;


end;

procedure TDataModule2.RESTRequest6AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData       : TJSONPair;
    LData1      : TJSONPair;
    LData2      : TJSONPair;
    keytra : string;
    g: integer;
begin
  with Form1 do
  begin
    Gauge1.Progress := 0;
    g:=0;

    jv:=RESTResponse1.JSONValue as TJSONObject;
    try

      data := jv.GetValue('data');
      jo := data as TJSONArray;
      Gauge1.MaxValue := jo.Size;

      for LMessage in jo do
      begin

        Gauge1.Progress := g;
        LLine := TJSONObject(LMessage);

        LData1 := LLine.get(1);
        LData := LLine.get(0);
        LData2 := LLine.get(2);

        keytra := LData.JsonValue.Value+'^'+LData1.JsonValue.Value+'@'+LData2.JsonValue.Value;
        transfers[keytra].Val:=transfers[keytra].Val+1;
        totaltransfers:=totaltransfers+1;

        inc(g);
      end;

    except
      raise;
    end;
  end;

end;

procedure TDataModule2.RESTRequest7AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    data    : TJSONValue;
    jo: TJSONArray;
begin
  with Form1 do
  begin

    jv:=RESTResponse1.JSONValue as TJSONObject;
    try

      data := jv.GetValue('data');
      jo := data as TJSONArray;

      array_llamadas:= TJSONObject.ParseJSONValue(jo.ToString) as TJSONArray;

    except
      raise;
    end;
  end;
end;


procedure TDataModule2.RESTRequest8AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    data    : TJSONValue;
    jo: TJSONArray;
begin
  with Form1 do
  begin

    jv:=RESTResponse1.JSONValue as TJSONObject;
    try

      data := jv.GetValue('data');
      jo := data as TJSONArray;

      array_result:= TJSONObject.ParseJSONValue(jo.ToString) as TJSONArray;

    except
      raise;
    end;
  end;
end;

procedure TDataModule2.RESTRequest9AfterExecute(Sender: TCustomRESTRequest);
var
    jv: TJSONObject;
    jo: TJSONArray;
    LMessage, data    : TJSONValue;
    LLine       : TJSONObject;
    LData, LData1 : TJSONPair;
    g, i, iRowCount: integer;

    partes_fecha: TArrayofString;
    partes_hora: TArrayofString;
    day_of_week: string;
    dias, horas: TArrayofstring;
    unans_by_day: TAssoc;
    ans_by_day: TAssoc;
    total_time_by_day, total_hold_by_day: TAssoc;
    login_by_day: TAssoc;
    logout_by_day: TAssoc;
    key: string;
    percent_unans, average_hold_duration, percent_ans, average_call_duration: Double;
    total_calls: integer;
begin

  with Form1 do
  begin
    Gauge1.Progress := 0;

    jv:=RESTResponse1.JSONValue as TJSONObject;
    try

      i:=0;
      g:=0;
      unanswered:=0;
      answered:=0;
      login:=0;
      logoff:=0;
      total_calls:=0;
      unans_by_day := TAssoc.Create(false);
      unans_by_hour := TAssoc.Create(false);
      unans_by_dw := TAssoc.Create(False);
      ans_by_day := TAssoc.Create(false);
      ans_by_hour := TAssoc.Create(false);
      ans_by_dw := TAssoc.Create(False);
      total_time_by_day := TAssoc.Create(False);
      total_hold_by_day := TAssoc.Create(False);
      total_time_by_dw := TAssoc.Create(False);
      total_time_by_hour := TAssoc.Create(False);
      total_hold_by_dw := TAssoc.Create(False);
      total_hold_by_hour := TAssoc.Create(False);
      login_by_day := TAssoc.Create(False);
      login_by_hour := TAssoc.Create(False);
      login_by_dw := TAssoc.Create(False);
      logout_by_day := TAssoc.Create(False);
      logout_by_hour := TAssoc.Create(False);
      logout_by_dw := TAssoc.Create(False);

      data := jv.GetValue('data');
      jo := data as TJSONArray;

      Gauge1.MaxValue := jo.Size;

      for LMessage in jo do
      begin

        Gauge1.Progress := g;
        LLine := TJSONObject(LMessage);

        LData := LLine.get(0);

        partes_fecha := SplitString(' ', Ldata.JsonValue.Value);
        partes_hora  := SplitString(':', partes_fecha[1]);

        DateTimeToString(day_of_week, 'dd/MM/yyyy', VarToDateTime(LData.JsonValue.Value));
        day_of_week := FormatDateTime('dddd', StrToDateTime(day_of_week));

        SetLength(dias, i+1);
        dias[i] := partes_fecha[0];
        SetLength(horas, i+1);
        horas[i] := partes_hora[0];
        inc(i);

        LData1 := LLine.get(3);
        if (LData1.JsonValue.Value = 'ABANDON') OR (LData1.JsonValue.Value = 'EXITWITHTIMEOUT') then
        begin
          inc(unanswered);
          unans_by_day[partes_fecha[0]].Val := unans_by_day[partes_fecha[0]].Val + 1;
          unans_by_hour[partes_hora[0]].Val := unans_by_hour[partes_hora[0]].Val + 1;
          unans_by_dw[day_of_week].Val := unans_by_dw[day_of_week].Val + 1;
        end;

        if (LData1.JsonValue.Value = 'COMPLETECALLER') OR (LData1.JsonValue.Value = 'COMPLETEAGENT') then
        begin
          inc(answered);
          ans_by_day[partes_fecha[0]].Val := ans_by_day[partes_fecha[0]].Val + 1;
          ans_by_hour[partes_hora[0]].Val := ans_by_hour[partes_hora[0]].Val + 1;
          ans_by_dw[day_of_week].Val := ans_by_dw[day_of_week].Val + 1;

          LData := LLine.get(5);
          total_time_by_day[partes_fecha[0]].Val := total_time_by_day[partes_fecha[0]].Val + StrToInt(LData.JsonValue.Value);
          total_time_by_dw[day_of_week].Val := total_time_by_dw[day_of_week].Val + StrToInt(LData.JsonValue.Value);
          total_time_by_hour[partes_hora[0]].Val := total_time_by_hour[partes_hora[0]].Val + StrToInt(LData.JsonValue.Value);

          LData := LLine.get(4);
          total_hold_by_day[partes_fecha[0]].Val := total_hold_by_day[partes_fecha[0]].Val + StrToInt(LData.JsonValue.Value);
          total_hold_by_dw[day_of_week].Val := total_hold_by_dw[day_of_week].Val + StrToInt(LData.JsonValue.Value);
          total_hold_by_hour[partes_hora[0]].Val := total_hold_by_hour[partes_hora[0]].Val + StrToInt(LData.JsonValue.Value);
        end;

        if (LData1.JsonValue.Value = 'AGENTLOGIN') OR (LData1.JsonValue.Value = 'AGENTCALLBACKLOGIN') then
        begin
          inc(login);
          login_by_day[partes_fecha[0]].Val := login_by_day[partes_fecha[0]].Val + 1;
          login_by_hour[partes_hora[0]].Val := login_by_hour[partes_hora[0]].Val + 1;
          login_by_dw[day_of_week].Val := login_by_dw[day_of_week].Val + 1;
        end;

        if (LData1.JsonValue.Value = 'AGENTLOGOFF') OR (LData1.JsonValue.Value = 'AGENTCALLBACKLOGOFF') then
        begin
          inc(logoff);
          logout_by_day[partes_fecha[0]].Val := logout_by_day[partes_fecha[0]].Val + 1;
          logout_by_hour[partes_hora[0]].Val := logout_by_hour[partes_hora[0]].Val + 1;
          logout_by_dw[day_of_week].Val := logout_by_dw[day_of_week].Val + 1;
        end;

        total_calls := answered + unanswered;
        dias := arrayunicostr(dias);
        horas := arrayunicostr(horas);
        //TArray.Sort<string>(dias);
        //TArray.Sort<string>(horas);

        inc(g);

      end;

      iRowCount := StringGrid9.RowCount-1;

      for key in dias do
      begin

        if NOT (ans_by_day[key].Val > 0) then
          ans_by_day[key].Val := 0;

        if NOT (unans_by_day[key].Val > 0) then
          unans_by_day[key].Val := 0;

        if answered > 0 then
          percent_ans := Double(ans_by_day[key].Val   * 100 / answered)
        else
          percent_ans := 0;

        if ans_by_day[key].Val > 0 then
        begin
          average_call_duration := Double(total_time_by_day[key].Val / ans_by_day[key].Val);
          average_hold_duration := Double(total_hold_by_day[key].Val / ans_by_day[key].Val);
        end else begin
          average_call_duration := 0;
          average_hold_duration := 0;
        end;

        if unanswered > 0 then
          percent_unans := Double(unans_by_day[key].Val * 100 / unanswered)
        else
          percent_unans := 0;

        StringGrid9.Cells[0,iRowCount] := key;
        StringGrid9.Cells[1,iRowCount] := ans_by_day[key].Val;
        StringGrid9.Cells[2,iRowCount] := FloatToStrF(percent_ans, ffNumber, 10, 2);
        StringGrid9.Cells[3,iRowCount] := unans_by_day[key].Val;
        StringGrid9.Cells[4,iRowCount] := FloatToStrF(percent_unans, ffNumber, 10, 2);
        StringGrid9.Cells[5,iRowCount] := SegToFormatHour(round(average_call_duration));
        //StringGrid9.Cells[6,iRowCount] := FloatToStrF(average_hold_duration, ffNumber, 10, 0);
        StringGrid9.Cells[6,iRowCount] := SegToFormatHour(round(average_hold_duration));
        StringGrid9.Cells[7,iRowCount] := login_by_day[key].Val;
        StringGrid9.Cells[8,iRowCount] := logout_by_day[key].Val;

        inc(iRowCount);

      end;

      StringGrid9.RowCount:=iRowCount;

    except
      raise;
    end;
  end;


end;

procedure TDataModule2.Abandonado(Sender: TObject);
var
    LMessage, LMessage1    : TJSONValue;
    LLine, LLine1       : TJSONObject;
    LData, LData_, LData1       : TJSONPair;
    iRowCount, g   : Integer;
    Enum: TPair<Variant, TAssoc>;
begin
  with Form1 do
  begin
    Gauge1.MaxValue := array_result.Size;

    iRowCount := StringGrid6.RowCount-1;

    Gauge1.Progress := 0;
    g:=0;
    ab:=0;
    nc:=0;

    abandon_calls_queue:= TAssoc.Create(false);

    for LMessage in array_result do
    begin
      Gauge1.Progress := g;
      LLine := TJSONObject(LMessage);

      LData := LLine.Get(3);
      if LData.JsonValue.Value = 'ABANDON' then
      begin

        abandoned:= abandoned+1;
        LData := LLine.Get(4);
        abandon_end_pos:=abandon_end_pos+StrToInt(LData.JsonValue.Value);
        LData := LLine.Get(5);
        abandon_start_pos:=abandon_start_pos+StrToInt(LData.JsonValue.Value);
        LData := LLine.Get(6);
        total_hold_abandon:=total_hold_abandon+StrToInt(LData.JsonValue.Value);

        op:='Abandonado por usuario';
        inc(ab);

        LData := LLine.Get(1);
        abandon_calls_queue[LData.JsonValue.Value].Val := abandon_calls_queue[LData.JsonValue.Value].Val + 1;

        for LMessage1 in array_llamadas do
        begin
          LLine1 := TJSONObject(LMessage1);

          LData_ := LLine1.Get(7);
          LData  := LLine.Get(7);
          LData1 := LLine1.Get(3);
          if (LData_.JsonValue.Value = LData.JsonValue.Value) and (LData1.JsonValue.Value = 'ENTERQUEUE') then
          begin

            LData := LLine.Get(1);
            StringGrid6.Cells[0,iRowCount] := LData.JsonValue.Value;
            LData := LLine1.Get(5);
            StringGrid6.Cells[1,iRowCount] := LData.JsonValue.Value;
            LData := LLine.Get(5);
            StringGrid6.Cells[2,iRowCount] := LData.JsonValue.Value;
            LData := LLine.Get(4);
            StringGrid6.Cells[3,iRowCount] := LData.JsonValue.Value;
            LData := LLine.Get(6);
            StringGrid6.Cells[4,iRowCount] := LData.JsonValue.Value;
            LData := LLine1.Get(0);
            StringGrid6.Cells[5,iRowCount] := LData.JsonValue.Value;
            StringGrid6.Cells[6,iRowCount] := op;

            inc(iRowCount);

          end;

        end;


      end;

      LData := LLine.Get(3);
      if LData.JsonValue.Value = 'EXITWITHTIMEOUT' then
      begin

        timeout := timeout+1;
        op :='No contestada';
        inc(nc);

        LData := LLine.Get(1);
        abandon_calls_queue[LData.JsonValue.Value].Val := abandon_calls_queue[LData.JsonValue.Value].Val + 1;

        for LMessage1 in array_llamadas do
        begin
          LLine1 := TJSONObject(LMessage1);

          LData_ := LLine1.Get(7);
          LData  := LLine.Get(7);
          LData1 := LLine1.Get(3);
          if (LData_.JsonValue.Value = LData.JsonValue.Value) and (LData1.JsonValue.Value = 'ENTERQUEUE') then
          begin

            LData := LLine.Get(1);
            StringGrid6.Cells[0,iRowCount] := LData.JsonValue.Value;
            LData := LLine1.Get(5);
            StringGrid6.Cells[1,iRowCount] := LData.JsonValue.Value;
            LData := LLine.Get(5);
            StringGrid6.Cells[2,iRowCount] := LData.JsonValue.Value;
            LData := LLine.Get(4);
            StringGrid6.Cells[3,iRowCount] := LData.JsonValue.Value;
            LData := LLine.Get(6);
            StringGrid6.Cells[4,iRowCount] := LData.JsonValue.Value;
            LData := LLine1.Get(0);
            StringGrid6.Cells[5,iRowCount] := LData.JsonValue.Value;
            StringGrid6.Cells[6,iRowCount] := op;

            inc(iRowCount);

          end;

        end;

      end;

      inc(g);

    end;

    StringGrid6.RowCount:=iRowCount;

    if (abandoned > 0) then
      abandon_average_hold := total_hold_abandon / abandoned
    else
      abandon_average_hold := 0;

    if (abandoned > 0) then
      abandon_average_start := round(abandon_start_pos / abandoned)
    else
      abandon_average_start := 0;

    if (abandoned > 0) then
      abandon_average_end := floor(abandon_end_pos / abandoned)
    else
      abandon_average_end := 0;

    total_abandon := abandoned + timeout;


    iRowCount := StringGrid7.RowCount-1;

    StringGrid7.Cells[0,iRowCount] := 'Abandonadas Usuario';
    StringGrid7.Cells[1,iRowCount] := IntToStr(abandoned);
    if total_abandon > 0 then
      percent:=abandoned*100/total_abandon
    else
      percent:=0;
    StringGrid7.Cells[2,iRowCount] := FloatToStrF(percent, ffNumber, 10, 2);

    inc(iRowCount);

    StringGrid7.Cells[0,iRowCount] := 'No Contestada';
    StringGrid7.Cells[1,iRowCount] := IntToStr(timeout);
    if total_abandon > 0 then
      percent:=timeout*100/total_abandon
    else
      percent:=0;
    StringGrid7.Cells[2,iRowCount] := FloatToStrF(percent, ffNumber, 10, 2);

    inc(iRowCount);

    StringGrid7.RowCount:=iRowCount;

    With Series6 do
    begin
      AddXY(0, abandoned, 'Abandonada');
      AddXY(1, timeout, 'No Contestada');
    end;

    iRowCount := StringGrid8.RowCount-1;

    for Enum in abandon_calls_queue.All do
    begin

      if total_abandon > 0 then
        percent := Enum.Value.Val * 100 / total_abandon
      else
        percent := 0;

      StringGrid8.Cells[0,iRowCount] := Enum.Key;
      StringGrid8.Cells[1,iRowCount] := Enum.Value.Val;
      StringGrid8.Cells[2,iRowCount] := FloatToStrF(percent, ffNumber, 10, 2);

      inc(iRowCount);

      With Series7 do
      begin
        AddXY(Enum.Key, Enum.Value.Val, Enum.Key);
      end;

    end;

    StringGrid8.RowCount:=iRowCount;


  end;

end;

end.
