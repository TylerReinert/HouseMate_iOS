
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
$houseUser = mysqli_real_escape_string($con,$_POST['d']);


$sql1 = "INSERT INTO houses (HousePassword, Salt, HouseName, houseUsername)
VALUES ('$pass','$salt', '$name', '$houseUser')";

if(!mysqli_query($con,$sql1))
	{
	die('Error:' .mysqli_error());
	}
echo "1 record added";
echo ($sql1);

session_start();
$email = $_SESSION["email"];


$sql2 = "INSERT INTO belongs_house (email, houseUsername)
VALUES ('$email','$houseUser')";

if(!mysqli_query($con,$sql2))
	{
	die('Error:' .mysqli_error());
	}
echo "1 record added";
echo ($sql2);




mysqli_close($con);
?>