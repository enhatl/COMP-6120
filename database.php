<?php

//connect to db
$dbhost = "sysmysql8.auburn.edu";
$dbname = 'enh0019db';
$dbuser = "enh0019";
$dbpass = "*********";

function getConnection() {
	global $dbhost, $dbuser, $dbpass, $dbname;
	$con = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
	if(!$con) {
		die('Could not connect: ' . mysqli_error(con));
	}
	return $con;
}

function executeQuery($con, $query) {
	$result = mysqli_query($con, $query);
	return $result;
}

function countAffectedRows($con) {
	return mysqli_affected_rows($con);
}

function getError($con) {
	return mysqli_error($con);
}

?>
