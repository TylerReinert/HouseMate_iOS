<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
     
    $glist = $_POST['a'];
    
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
        	
    		$query = "INSERT INTO grocery_lists (listName, houseUsername) VALUES('$glist', '$houseUser');";
        	mysql_query($query, $connection) or die(mysql_error());
        	
        	$query2 = "SELECT listName, listID FROM grocery_lists WHERE houseUsername = '$houseUser';";
            $result = mysql_query($query2, $connection);
            
            $glists = array();
            while ($row = mysql_fetch_assoc($result)) {
            	$listName = $row["listName"];
            	$listID = $row["listID"];
            	$subglist = array();
            	array_push($subglist, $listName, $listID);
            	array_push($glists, $subglist);
			}
			echo json_encode($glists);
        	
        }
    }
?>