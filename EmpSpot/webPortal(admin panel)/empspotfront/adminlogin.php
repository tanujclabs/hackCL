<?php
ob_start();
include("http://67.202.34.113/nodeTraining/empspotfront/config.php");
session_start();
//if(isset($_POST['username'])
//   {

if($_SERVER["REQUEST_METHOD"] == "POST")
{

//echo "1212";
// username and password sent from Form 
$myusername=$_POST['username']; 
$mypassword=$_POST['password']; 
//
//print_r($myusername);
//print_r($mypassword);

$sql="SELECT `username` FROM `admin` WHERE `username`='".$myusername."' and `password`='".$mypassword."' LIMIT 1";
print_r($sql);

$result=mysql_query($sql);


print_r("result");
print_r($result);
$row=mysql_fetch_array($result);
print_r("row");
print_r($row);
//$active=$row['active'];
$count=mysql_num_rows($result);


// If result matched $myusername and $mypassword, table row must be 1 row
if($count==1)
{
session_register("myusername");
$_SESSION['login_user']=$myusername;

header("location: http://67.202.34.113/nodeTraining/empspotfront/newuser.php");
}
else 
{
$error="Your Login Name or Password is invalid";
echo $error;
}
}
?>
<html>
	<head>

		<link rel="stylesheet" href="css/bootstrap.css">
		<link rel="stylesheet" href="css/style.css">

		<script src="js/bootstrap.js"></script>
	</head>
	<body>
			<div class="container">

      <form class="form-signin" role="form" method="post" action="adminlogin.php">
        
        <input type="text" class="form-control" placeholder="Username" name="username">
        <input type="password" class="form-control" placeholder="******" style="margin-top: 5px;" name="password" >
       
        <input class="btn btn-lg btn-primary btn-block" type="submit" value="" id="login_btn">
        
      </form>

    </div> <!-- /container -->


	
	</body>
</html>