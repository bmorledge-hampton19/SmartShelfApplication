<?php

// Get the connection string.
include 'Connect.php';

// Get the food id from the JSON object.
$obj = json_decode($json);

// The query
$sql = "DELETE FROM `Food Item`
		WHERE ID = " . $obj->{'ID'};
		
// Run the query, and check for errors.
$stmt = $conn->query($sql) or die($conn->error);

// Close the connection to the database.
mysql_close($conn);

?>