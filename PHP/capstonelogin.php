<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
     
    $email = $_POST['a'];
    $password = $_POST['b'];
 
    if(!$connection){
        die('Connection Failed');
    }
    else{
        $dbconnect = @mysql_select_db('caps16_team54', $connection);
         
        if(!$dbconnect){
            die('Could not connect to Database');
        }
        else{
            $query = "SELECT password, salt FROM users WHERE email = '$email';";
            $result = mysql_query($query, $connection);
            $row = mysql_fetch_row($result);
            $pass = $row[0];
	    	$salt = $row[1];
	    	$passes = array();
	    
	    	if($pass == ""){
                array_push($passes, $pass);
                echo json_encode($passes);
	    	}
	    	else{
            	array_push($passes, $pass, $salt);
            	session_start();
            	$_SESSION["email"] = $email;
	        	echo json_encode($passes);
        	}
        }
	
    }
?>
