<?php
    $host='db.soic.indiana.edu';
    $user='caps16_team54';
    $password='my+sql=caps16_team54';
     
    $connection = mysql_connect($host,$user,$password);
     
    $email = $_POST['a'];
    $fname = $_POST['b'];
    $lname = $_POST['c'];
    $password = $_POST['d'];
    $salt = $_POST['e'];
 
     
    if(!$connection){
        die('Connection Failed');
    }
    else{
        $dbconnect = @mysql_select_db('caps16_team54', $connection);
         
        if(!$dbconnect){
            die('Could not connect to Database');
        }
        else{
			$query1 = "SELECT password FROM users WHERE email='$email';";
            $result = mysql_query($query1, $connection);
            $row = mysql_fetch_row($result);
            $answer = $row[0];
			
            if(strlen($answer)==0){
                $found = "false";
            }
            else{
                $found = "true";
            }
			
			if($found == "false"){
				$query2 = "INSERT INTO `caps16_team54`.`users` (`email`, `fname`, `lname`, 							`password`,`salt`) VALUES ('$email','$fname', '$lname', '$password', '$salt');";
            	mysql_query($query2, $connection) or die(mysql_error());
            	session_start();
            	$_SESSION["email"] = $email;
			}
			
			echo $found;
            
        }
    }
?>