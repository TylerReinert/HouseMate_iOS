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
        	$query1 = "SELECT fname FROM users WHERE email = '$email';";
            $result1 = mysql_query($query1, $connection);
            $row1 = mysql_fetch_row($result1);
            $fname = $row1[0];
        	
        	$query2 = "SELECT h.HouseName, h.houseUsername FROM houses as h, belongs_house as b WHERE h.houseUsername = b.houseUsername AND b.email='$email';";
        	$result2 = mysql_query($query2, $connection);
        	$row2 = mysql_fetch_row($result2);
        	$houseName = $row2[0];
        	$houseUser = $row2[1];
        	
        	session_start();
        	$_SESSION["houseUser"] = $houseUser;
        	        	
        	$info = array();
        	array_push($info, $fname, $houseName);
        	
        	echo json_encode($info);
        }
    }
?>