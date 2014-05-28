<?php
include('http://67.202.34.113/nodeTraining/empspotfront/config.php');
session_start();
$user_check=$_SESSION['login_user'];

$ses_sql=mysql_query("select username from admin where username='$user_check' ");

$row=mysql_fetch_array($ses_sql);

$login_session=$row['username'];

if(!isset($login_session))
{
header("Location: http://67.202.34.113/nodeTraining/empspotfront/adminlogin.php");
}
?>