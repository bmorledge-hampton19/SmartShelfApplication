<?php

// Get information from incoming json variable.
$json = file_get_contents('php://input');
$obj = json_decode($json);

// Get the connection string.
include 'Connect.php';

// The query
$sql = "INSERT INTO `Food Item`
		(BarcodeID, Name, DRID)
		VALUES (" . $obj->{'BarcodeID'} . ", \"" . $obj->{'Name'} . "\", NULL)";
		
// Run the query, and check for errors.
$stmt = $conn->query($sql) or die($conn->error);	

// Close the connection to the database.
mysql_close($conn);

?>