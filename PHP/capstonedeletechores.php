<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
    $id = $_POST['a'];
 
    if(!$connection){
        die('Connection Failed');
    }
    else{
    	session_start();
    	$dbconnect = @mysql_select_db('caps16_team54', $connection);
         
        if(!$dbconnect){
            die('Could not connect to Database');
        }
        else{
        	$query = "DELETE FROM chores WHERE choreID = '$id';";
            mysql_query($query, $connection) or die(mysql_error());
        }
    }
?>