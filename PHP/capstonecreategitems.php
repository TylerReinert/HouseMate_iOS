<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
     
    $itemName = $_POST['a'];
    $listID = $_POST['b'];
    
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
        	$email = $_SESSION["email"];
        	$houseUser = $_SESSION["houseUser"];
        	
    		$query = "INSERT INTO grocery_items (itemName, listID) VALUES('$itemName', $listID);";
        	mysql_query($query, $connection) or die(mysql_error());
        	
        	/*
        	$query2 = "SELECT choreID, choreText, status FROM chores WHERE houseUsername = '$houseUser';";
            $result = mysql_query($query2, $connection);
            
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
        	*/
        }
    }
?>