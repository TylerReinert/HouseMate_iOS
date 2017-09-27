<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
    $status = $_POST['a'];
    $id = $_POST['b'];
 
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
        	$query = "UPDATE chores SET status = '$status' WHERE choreID = '$id';";
            mysql_query($query, $connection) or die(mysql_error());
        }
    }
?>