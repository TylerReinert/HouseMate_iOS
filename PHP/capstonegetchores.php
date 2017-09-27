<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
    session_start();
    $email = $_SESSION["email"];
 
    if(!$connection){
        die('Connection Failed');
    }
    else{
    	$dbconnect = @mysql_select_db('caps16_team54', $connection);
         
        if(!$dbconnect){
            die('Could not connect to Database');
        }
        else{
        	session_start();
        	$houseUser = $_SESSION["houseUser"];
        	$query = "SELECT choreID, choreText, status FROM chores WHERE houseUsername = '$houseUser';";
            $result = mysql_query($query, $connection);
            
            $chores = array();
            while ($row = mysql_fetch_assoc($result)) {
            	$text = $row["choreText"];
            	$status = $row["status"];
            	$id = $row["choreID"];
            	$subchores = array();
            	array_push($subchores, $text, $status, $id);
            	array_push($chores, $subchores);
			}
			echo json_encode($chores);
        
        }
    }
?>