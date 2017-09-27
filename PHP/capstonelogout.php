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
        	session_destroy();
        }
    }
?>