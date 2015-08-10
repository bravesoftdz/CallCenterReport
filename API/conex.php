<?php
include_once ("clase.php");// incluyo las clases a ser usadas
require "JSON.php";
$json = new JSON;

//$action='select_all';
//$class='rep_dbsel';

if(isset($_POST['action']))
{$action=$_POST['action'];}

if(isset($_POST['clase']))
{$class=$_POST['clase'];}

//$valor=';
if(isset($_POST['valor']))
{$valor=$_POST['valor'];}

//$query = "SELECT UPDATE_TIME FROM  information_schema.tables WHERE TABLE_SCHEMA = 'qstats' AND TABLE_NAME = 'queue_stats'";
//$query ="SELECT count(ev.event) AS num, ev.event AS action FROM queue_stats AS qs, qname AS q, qevent AS ev WHERE qs.qname = q.qname_id and qs.qevent = ev.event_id and qs.datetime BETWEEN '2015-04-01' and '2015-04-06 23:59:59' and q.queue IN ('7301','7302','7303','7304','7305','7307','7308','7309','7310','7312','7314','7317','7319','7320','7330','7331','7335','NONE') and ev.event IN ('COMPLETECALLER', 'COMPLETEAGENT') GROUP BY ev.event ORDER BY ev.event limit 0, 74999";
//$query="SELECT ag.agent AS agent, qs.info1 AS info1,  qs.info2 AS info2 FROM  queue_stats AS qs, qevent AS ac, qagent as ag, qname As q WHERE qs.qevent = ac.event_id AND qs.qname = q.qname_id AND ag.agent_id = qs.qagent AND qs.datetime BETWEEN '2015-04-01' AND '2015-04-10 23:59:59' AND  q.queue IN ('7301','7302','7303','7304','7305','7306','7307','7308','7309','7310','7312','7314','7317','7319','7320','7330','7331','7335','NONE')  AND ag.agent in ('ACR CALL01','ACR CALL02','ACR CALL03','ACR CALL04','ACR CALL05','ACR CALL06','Alberto G','Ana Valme','Antonio P','CALL01','CALL02','CALL03','CALL04','CALL05','CALL06','Canovas','Carolina','Conchi C','David Glez','Desire','Esther','Esther Baeza','Guarda','Jaime M','Jessica R','Jualian P','Juan A M','Juan AM','Julian P','Local/2101@from','Local/2102@from','Local/2103@from','Local/3016@from','Local/5660@from','Local/5806@from','Local/5810@from','Local/663074862@from','Local/7104@from','Local/7120@from','Local/7319@from','Local/8290@from','Local/955047748@from','Manuel F','Mariano M','Marilo G','NONE','Rafael M','Ramon C','Rocio de la Prada','Sandra P','Teresa Guerrero') AND  ac.event in ('TRANSFER') limit 0, 74999";
//$query = "select * from qagent"
//$query = "SELECT ag.agent AS agent, qs.info1 AS info1,  qs.info2 AS info2 ";
//$query.= "FROM  queue_stats AS qs, qevent AS ac, qagent as ag, qname As q WHERE qs.qevent = ac.event_id ";
//$query.= "AND qs.qname = q.qname_id AND ag.agent_id = qs.qagent AND qs.datetime BETWEEN '2015-04-01' AND '2015-04-30 23:59:59' ";
//$query.= "AND  q.queue IN ('7301','7302','7303','7304','7305','7306','7307','7308','7309','7310','7312','7314','7317','7319','7320','7330','7331','7335','NONE')  AND ag.agent in ('ACR CALL01','ACR CALL02','ACR CALL03','ACR CALL04','ACR CALL05','ACR CALL06','Alberto G','Ana Valme','Antonio P','CALL01','CALL02','CALL03','CALL04','CALL05','CALL06','Canovas','Carolina','Conchi C','David Glez','Desire','Esther','Esther Baeza','Guarda','Jaime M','Jessica R','Jualian P','Juan A M','Juan AM','Julian P','Local/2101@from','Local/2102@from','Local/2103@from','Local/3016@from','Local/5660@from','Local/5806@from','Local/5810@from','Local/663074862@from','Local/7104@from','Local/7120@from','Local/7319@from','Local/8290@from','Local/955047748@from','Manuel F','Mariano M','Marilo G','NONE','Rafael M','Ramon C','Rocio de la Prada','Sandra P','Teresa Guerrero') AND  ac.event = 'TRANSFER'";
//$query = "SELECT qs.datetime AS datetime, q.queue AS qname, ag.agent AS qagent, ac.event AS qevent, qs.info1 AS info1, qs.info2 AS info2,  qs.info3 AS info3 FROM queue_stats AS qs, qname AS q, qagent AS ag, qevent AS ac WHERE qs.qname = q.qname_id AND qs.qagent = ag.agent_id AND qs.qevent = ac.event_id AND qs.datetime BETWEEN '2015-04-01' AND '2015-04-06 23:59:59' AND q.queue IN ('7301','7302','7303','7304','7305','7307','7308','7309','7310','7312','7314','7317','7319','7320','7330','7331','7335','NONE') AND ag.agent IN ('ACR CALL01','ACR CALL02','ACR CALL03','ACR CALL04','ACR CALL05','ACR CALL06','Alberto G','Ana Valme','Antonio P','CALL01','CALL02','CALL03','CALL04','CALL05','CALL06','Canovas','Carolina','Conchi C','David Glez','Desire','Esther','Esther Baeza','Guarda','Jaime M','Jessica R','Jualian P','Juan A M','Juan AM','Julian P','Local/2101@from','Local/2102@from','Local/2103@from','Local/3016@from','Local/5660@from','Local/5806@from','Local/5810@from','Local/663074862@from','Local/7104@from','Local/7120@from','Local/7319@from','Local/8290@from','Local/955047748@from','Manuel F','Mariano M','Marilo G','NONE','Rafael M','Ramon C','Rocio de la Prada','Sandra P','Teresa Guerrero') AND ac.event IN ('COMPLETECALLER', 'COMPLETEAGENT', 'TRANSFER', 'CONNECT') ORDER BY qs.datetime";
//$valor=$query;


switch ($action)
{
    case 'select_all':
		$res = $class::getClientesJson($valor);
		//$num = $class::getAfected();
		//echo trim($class::getJSON($valor));
		
		//if ($res != false) {
			//$response[] = "'Result':[(";
			///foreach($res as $nombre=>$campo) {$response[]=$campo;} // $response1[]=$nombre;}
			//echo json->serialize($response);
			///echo json_encode($response);
			echo ($res);
			//echo "$campo[0]^$campo[1]@$campo[2]";
		//} else {
			// user not found
			// echo json with error = 1
			//$response["error"] = 1;
			//$response=Array(0);
			//$response[] = "Error Select BD o no existen registros.";        //"Incorrect email or password!";
			//echo json_encode($response);
			
			//echo mysqli_error($this->mysql_link);
			//echo SetError();
	
		//}
		break;

	case 'prueba':
		echo json_encode($valor);
		break;
	
}



?>