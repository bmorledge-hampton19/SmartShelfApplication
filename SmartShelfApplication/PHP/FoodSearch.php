<?php

// Get the connection string.
include 'Connect.php';

// Get information from incoming json variable.
$json = file_get_contents('php://input');
$obj = json_decode($json);

// The query
$sql = "select *
		from `Food Item`
		where Name LIKE CONCAT(\"%\", \"" . $obj->{'Search'} . "\", \"%\" )" . $obj->{'ID'};

// Execute the query
$result = $conn->query($sql) or die($conn->error);

// Gimme an array for the data!
$data = array();
$data['FoodItem'] = array();

// Store the results of the query in the $result array.
	while ($row = $result->fetch_assoc()){
		$temp = array();
		
		$temp['FoodName'] = $row['Name'];
		$temp['BarcodeID'] = $row['BarcodeID'];
		$temp['DRID'] = $row['DRID'];
		$temp['FoodID'] = $row['ID'];
		
		array_push($data['FoodItem'],$temp);
	}

// Write the results in JSON!
echo json_encode($data);
		
// Close the connection to the database.
mysql_close($conn);

?>