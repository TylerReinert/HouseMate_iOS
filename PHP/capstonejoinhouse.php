<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
     
    $houseUser = $_POST['a'];
    $housePassword = $_POST['b'];
 
    if(!$connection){
        die('Connection Failed');
    }
    
    else{
        $dbconnect = @mysql_select_db('caps16_team54', $connection);
         
        if(!$dbconnect){
            die('Could not connect to Database');
        }
        else{
            $query1 = "SELECT HousePassword, Salt FROM houses WHERE houseUsername = '$houseUser';";
            $result = mysql_query($query1, $connection);
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
	        	echo json_encode($passes);
	        	session_start();
        		$email = $_SESSION["email"];
        		$query2 = "INSERT INTO belongs_house VALUES('$email','$houseUser')";
        		mysql_query($query2, $connection) or die(mysql_error());
        	}
        	
        	
        }
	
    }
?>