<?php
// Get the connection string.
include 'Connect.php';

// Get information from incoming json variable.
$json = file_get_contents('php://input');
$obj = json_decode($json);

// The query
$sql = "SELECT R.ID, Name
		FROM Recipe R JOIN `Recipe Ingredients` RI on 
			(R.ID = RI.RID)
		WHERE RI.FIID = " . $obj->{'ID'};

// Execute the query
$result = $conn->query($sql) or die($conn->error);

// Gimme an array for the data!
$data = array();
$data['Recipes'] = array();

// Store the results of the query in the $result array.
	while ($row = $result->fetch_assoc()){
		$temp = array();
		
		$temp['ID'] = $row['ID'];
		$temp['Name'] = $row['Name'];
		
		array_push($data['Recipes'],$temp);
	}

// Write the results in JSON!
echo json_encode($data);
		
// Close the connection to the database.
mysql_close($conn);

?>