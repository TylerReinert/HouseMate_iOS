
 <?php
$con=mysqli_connect("db.soic.indiana.edu",'caps16_team54','my+sql=caps16_team54','caps16_team54');
//check connection
if (mysqli_connect_errno())
	{
	echo "Failed to connect to MySQL:" .mysqli_connect_error();
	}
//escape variables for security sql injection
$pass = mysqli_real_escape_string($con,$_POST['a']);
$salt = mysqli_real_escape_string($con,$_POST['b']);
$name = mysqli_real_escape_string($con,$_POST['c']);


$sql = "INSERT INTO Houses1 (HousePassword, Salt, HouseName)
VALUES ('$pass','$salt', '$name')";

if(!mysqli_query($con,$sql))
	{
	die('Error:' .mysqli_error());
	}
echo "1 record added";
echo ($sql);


mysqli_close($con);
?>