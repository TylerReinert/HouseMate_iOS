<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
    
    $gListID = $_POST['a'];
    
     
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
        	
        	$query = "SELECT itemID, itemName FROM grocery_items WHERE listID = '$gListID';";
            $result = mysql_query($query, $connection);
            
            $lists = array();
            while ($row = mysql_fetch_assoc($result)) {
            	$itemName = $row["itemName"];
            	$itemID = $row["itemID"];
            	$sublists = array();
            	array_push($sublists, $itemName, $itemID);
            	array_push($lists, $sublists);
			}
			echo json_encode($lists);
        
        }
    }
?>