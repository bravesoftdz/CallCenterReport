<?php
ini_set("display_errors",1);
error_reporting(E_ALL);

class Conexion  // se declara una clase para hacer la conexion con la base de datos
{
	var $con;
	function Conexion()
	{

		require_once("configuracion.php");
		// se definen los datos del servidor de base de datos
		//$conection['server']=$conx->db($conection['server']);  //host
		//$conection['user']=$conx->db($conection['user']);         //  usuario
		//$conection['pass']=$conx->db($conection['pass']);             //password
		//$conection['base']=$conx->db($conection['base']);           //base de datos

		// crea la conexion pasandole el servidor , usuario y clave
		$conect= mysql_connect(server,user,pass);

		if ($conect) // si la conexion fue exitosa , selecciona la base
		{
			mysql_select_db(base);
			$this->con=$conect;
		}
	}
	function getConexion() // devuelve la conexion
	{
		return $this->con;
	}
	function Close()  // cierra la conexion
	{
		mysql_close($this->con);
	}

}
class sQuery   // se declara una clase para poder ejecutar las consultas, esta clase llama a la clase anterior
{

	var $coneccion;
	var $consulta;
	var $resultados;
	function sQuery()  // constructor, solo crea una conexion usando la clase "Conexion"
	{
		$this->coneccion= new Conexion();
	}
	function executeQuery($cons)  // metodo que ejecuta una consulta y la guarda en el atributo $pconsulta
	{
		$this->consulta= mysql_query($cons,$this->coneccion->getConexion());
		return $this->consulta;
	}
	function getResults()   // retorna la consulta en forma de result.
	{return $this->consulta;}

	function Close()		// cierra la conexion
	{$this->coneccion->Close();}

	function Clean() // libera la consulta
	{mysql_free_result($this->consulta);}

	function getResultados() // debuelve la cantidad de registros encontrados
	{return mysql_affected_rows($this->coneccion->getConexion()) ;}

	function getAffect() // devuelve las cantidad de filas afectadas
	{return mysql_affected_rows($this->coneccion->getConexion()) ;}

    function fetchAll()
    {
        $rows=array();
		if ($this->consulta)
		{
			while($row= mysql_fetch_array($this->consulta))
			{
				$rows[]=$row;
			}
		}
		if (sizeof ($rows) == 0) { return (FALSE); }
        return $rows;
	}
	
	function getJSON(){  //($resultSet,$affectedRecords){
	$resultSet = $this->consulta;
	$affectedRecords = mysql_affected_rows($this->coneccion->getConexion()) ;
	 $numberRows=0;
	 $arrfieldName=array();
	 $i=0;
	 $json="";
		//print("Test");
		while ($i < mysql_num_fields($resultSet))  {
			$meta = mysql_fetch_field($resultSet, $i);
			if (!$meta) {
			}else{
			$arrfieldName[$i]=$meta->name;
			}
			$i++;
		}
		 $i=0;
		  $json="{\n\"data\": [\n";
		while($row=mysql_fetch_array($resultSet, MYSQL_NUM)) {
			$i++;
			//print("Ind ".$i."-$affectedRecords<br>");
			$json.="{\n";
			for($r=0;$r < count($arrfieldName);$r++) {
				$json.="\"$arrfieldName[$r]\" :	\"$row[$r]\"";
				if($r < count($arrfieldName)-1){
					$json.=",\n";
				}else{
					$json.="\n";
				}
			}
			
			
			 if($i!=$affectedRecords){
				$json.="\n},\n";
			 }else{
				$json.="\n}\n";
			 }
			 
			 
			
		}
		//$json.="]\n};";
		$json.="]\n}";
		
		return $json;
	 }
		

}

class rep_dbsel
{
	var $qname_id;     //se declaran los atributos de la clase, que son los atributos del cliente
	var $queue;

    public static function getClientes($query)
		{
			$obj_cliente=new sQuery();
			$obj_cliente->executeQuery($query); // ejecuta la consulta para traer al cliente
			
			return $obj_cliente->fetchAll(); // retorna todos los clientes
		}
	
	public static function getClientesJson($query)
		{
			$obj_cliente=new sQuery();
			$obj_cliente->executeQuery($query); // ejecuta la consulta para traer al cliente
			return $obj_cliente->getJSON();
		}

	function rep_qname($nro=0) // declara el constructor, si trae el numero de cliente lo busca , si no, trae todos los clientes
	{
		if ($nro!=0)
		{
			$obj_cliente=new sQuery();
			$result=$obj_cliente->executeQuery("select * from qname where qname_id = $nro"); // ejecuta la consulta para traer al cliente
			$row=mysql_fetch_array($result);
			$this->qname_id=$row['qname_id'];
			$this->queue=$row['queue'];
		}
	}
	
	public static function getAffected()
	{
		return $obj_cliente->getAffect();
	}
	

		// metodos que devuelven valores
	function getID()
	 { return $this->qname_id;}
	function getQueue()
	 { return $this->queue;}

		// metodos que setean los valores
	function setQueue($val)
	 { $this->queue=$val;}

    function save()
    {
        if($this->id)
        {$this->updateCliente();}
        else
        {$this->insertCliente();}
    }
	private function updateCliente()	// actualiza el cliente cargado en los atributos
	{
			$obj_cliente=new sQuery();
            echo $this->qname_id;
            echo $this->queue;
			$query="update qname set queue='$this->queue' where qname_id = '$this->qname_id'";
			$obj_cliente->executeQuery($query); // ejecuta la consulta para traer al cliente
			return $obj_cliente->getAffect(); // retorna todos los registros afectados

	}
	private function insertCliente()	// inserta el cliente cargado en los atributos
	{
			$obj_cliente=new sQuery();
			$query="insert into qname ( qname) values ('$this->qname')";

			$obj_cliente->executeQuery($query); // ejecuta la consulta para traer al cliente
			return $obj_cliente->getAffect(); // retorna todos los registros afectados

	}
	function delete()	// elimina el cliente
	{
			$obj_cliente=new sQuery();
			$query="delete from qname where qname_id=$this->qname_id";
			$obj_cliente->executeQuery($query); // ejecuta la consulta para  borrar el cliente
			return $obj_cliente->getAffect(); // retorna todos los registros afectados

	}

}

function cleanString($string)
{
    $string=trim($string);
    $string=mysql_escape_string($string);
	$string=htmlspecialchars($string);

    return $string;
}

function getUserByEmailAndPassword($email, $password, $encr=0) {
    $obj_cliente=new sQuery();
	$result = $obj_cliente->executeQuery("SELECT * FROM abr_usuarios WHERE email = '$email'");
	// check for result
	$no_of_rows = mysql_num_rows($result);
	if ($no_of_rows > 0) {
        $result = mysql_fetch_array($result);
		$salt = $result['salt'];
		$encrypted_password = $result['encrypted_password'];
		if ($encr==0) {
		    $hash = checkhashSSHA($salt, $password);
			//$result = $hash
			// check for password equality
        } else {
            $hash = $password;
        }
		if ($encrypted_password == $hash) {
		    // user authentication details are correct
			return $result;
		}
	} else {
	    // user not found
		return false;
	}
}

function isUserExisted($email) {
			$obj_cliente=new sQuery();
			$result = $obj_cliente->executeQuery("SELECT email from abr_usuarios WHERE email = '$email'"); // ejecuta la consulta para traer al cliente

            //$result = mysql_query("SELECT email from abr_usuarios WHERE email = '$email'");
			$no_of_rows = mysql_num_rows($result);
			if ($no_of_rows > 0) {
				// user existed
				return true;
			} else {
				// user not existed
				return false;
			}
}

function forgotPassword($forgotpassword, $newpassword, $salt) {
			$obj_cliente=new sQuery();
			$result = $obj_cliente->executeQuery("UPDATE abr_usuarios SET encrypted_password = '$newpassword',salt = '$salt' WHERE email = '$forgotpassword'"); // ejecuta la consulta para traer al cliente

			//$result = mysql_query("UPDATE ofe_users SET encrypted_password = '$newpassword',salt = '$salt' WHERE email = '$forgotpassword'");

			if ($result) {
				return true;
			} else {
				return false;
			}

}


function random_string() {
			$character_set_array = array();
			$character_set_array[] = array('count' => 7, 'characters' => 'abcdefghijklmnopqrstuvwxyz');
			$character_set_array[] = array('count' => 1, 'characters' => '0123456789');
			$temp_array = array();
			foreach ($character_set_array as $character_set) {
				for ($i = 0; $i < $character_set['count']; $i++) {
					$temp_array[] = $character_set['characters'][rand(0, strlen($character_set['characters']) - 1)];
				}
			}
			shuffle($temp_array);
			return implode('', $temp_array);
}

function hashSSHA($password) {

	    $salt = sha1(rand());
		$salt = substr($salt, 0, 10);
		$encrypted = base64_encode(sha1($password . $salt, true) . $salt);
		$hash = array("salt" => $salt, "encrypted" => $encrypted);
		return $hash;
}

	/**
	* Decrypting password
	* returns hash string
	*/
function checkhashSSHA($salt, $password) {

	    $hash = base64_encode(sha1($password . $salt, true) . $salt);

		return $hash;
}

function validEmail($email) {
		   $isValid = true;
		   $atIndex = strrpos($email, "@");
		   if (is_bool($atIndex) && !$atIndex) {
			  $isValid = false;
		   } else {
			  $domain = substr($email, $atIndex+1);
			  $local = substr($email, 0, $atIndex);
			  $localLen = strlen($local);
			  $domainLen = strlen($domain);
			  if ($localLen < 1 || $localLen > 64) {
				 // local part length exceeded
				 $isValid = false;
			  } else if ($domainLen < 1 || $domainLen > 255) {
				 // domain part length exceeded
				 $isValid = false;
			  } else if ($local[0] == '.' || $local[$localLen-1] == '.') {
				 // local part starts or ends with '.'
				 $isValid = false;
			  } else if (preg_match('/\\.\\./', $local)) {
				 // local part has two consecutive dots
				 $isValid = false;
			  } else if (!preg_match('/^[A-Za-z0-9\\-\\.]+$/', $domain)) {
				 // character not valid in domain part
				 $isValid = false;
			  } else if (preg_match('/\\.\\./', $domain)) {
				 // domain part has two consecutive dots
				 $isValid = false;
			  } else if (!preg_match('/^(\\\\.|[A-Za-z0-9!#%&`_=\\/$\'*+?^{}|~.-])+$/', str_replace("\\\\","",$local))) {
				 // character not valid in local part unless
				 // local part is quoted
				 if (!preg_match('/^"(\\\\"|[^"])+"$/', str_replace("\\\\","",$local))) {
					$isValid = false;
				 }
			  }
			  if ($isValid && !(checkdnsrr($domain,"MX") || checkdnsrr($domain,"A"))) {
				 // domain not found in DNS
				 $isValid = false;
			  }
		   }
		   return $isValid;
}

function multidimensional_search($parents, $searched) {
  if (empty($searched) || empty($parents)) {
    return false;
  }

  foreach ($parents as $key => $value) {
    $exists = true;
    foreach ($searched as $skey => $svalue) {
      $exists = ($exists && IsSet($parents[$key][$skey]) && $parents[$key][$skey] == $svalue);
    }
    if($exists){ return $svalue; }
  }

  return false;
}

function alr($msg) {
    echo '<script type="text/javascript">alert("'. $msg .'")</script>';
}

function largo($movil) {
    $obj=new sQuery();

	$result = $obj->executeQuery("SELECT * FROM abr_abreviados WHERE n_largo = '$movil'");
	// check for result
	$no_of_rows = mysql_num_rows($result);
	//echo $movil;
	if ($no_of_rows > 0) {
		$result = mysql_fetch_array($result);
		return $result;
	} else {
		return false;
	}
}

function corto($movil) {
    $obj=new sQuery();

	$result = $obj->executeQuery("SELECT * FROM abr_abreviados WHERE n_corto = '$movil'");
	// check for result
	$no_of_rows = mysql_num_rows($result);
	//echo $movil;
	if ($no_of_rows > 0) {
		$result = mysql_fetch_array($result);
		return $result;
	} else {
		return false;
	}
}

function send_mail($email,$subject,$message,$headers) {
	//include("class.smtp.php"); // optional, gets called from within class.phpmailer.php if not already loaded
	require("class.phpmailer.php");

	$mail             = new PHPMailer();

	//$body             = file_get_contents('contents.html');
	$body			  = $message;
	//$body             = eregi_replace("[\]",'',$body);

	$mail->IsSMTP(); // telling the class to use SMTP
	$mail->Host       = "send.one.com"; // SMTP server
	//$mail->SMTPDebug  = 2;                     // enables SMTP debug information (for testing)
											   // 1 = errors and messages
											   // 2 = messages only
	$mail->SMTPAuth   = true;                  // enable SMTP authentication
    //$mail->SMTPSecure = "ssl";
	//$mail->Host       = "mail.yourdomain.com"; // sets the SMTP server
	$mail->Port       = 25;                    // set the SMTP port for the GMAIL server
	$mail->Username   = "send@macronukes.com"; // SMTP account username
	$mail->Password   = "jgp2165";        // SMTP account password

	$mail->SetFrom('send@macronukes.com', 'admin@unocomaseis.com');

	//$mail->AddReplyTo("name@yourdomain.com","First Last");

	$mail->Subject    = $subject;

	//$mail->AltBody    = "To view the message, please use an HTML compatible email viewer!"; // optional, comment out and test

	$mail->MsgHTML($body);

	$address = $email;
	$mail->AddAddress($address, $address);

	//$mail->AddAttachment("images/phpmailer.gif");      // attachment
	//$mail->AddAttachment("images/phpmailer_mini.gif"); // attachment

	if(!$mail->Send()) {
	  alr("Mailer Error: " . $mail->ErrorInfo);
	} else {
	  alr("Mensaje enviado!");
	}

}

function recibe_fila($fila){ 
    echo "Recibe<br>"; 
   	foreach($fila as $nombre_campo => $valor){ 
      	if (gettype($nombre_campo)!="integer"){ 
         	$asignacion = "\$GLOBALS[\"" . $nombre_campo . "\"]='" . $valor . "';"; 
			eval($asignacion); 
      	} 
   	} 
	return $asignacion;
}

?>

