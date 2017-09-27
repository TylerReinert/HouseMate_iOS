<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
    session_start();
    $email = $_SESSION["email"];
	$houseUser = $_SESSION["houseUser"]; 
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
        	$query = "SELECT listID, listName FROM grocery_lists WHERE houseUsername = '$houseUser';";
            $result = mysql_query($query, $connection);
            
            $lists = array();
            while ($row = mysql_fetch_assoc($result)) {
            	$name = $row["listName"];
            	$id = $row["listID"];
            	$sublists = array();
            	array_push($sublists, $name, $id);
            	array_push($lists, $sublists);
			}
			echo json_encode($lists);
        
        }
    }
?>