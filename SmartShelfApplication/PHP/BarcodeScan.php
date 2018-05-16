<?php
// Get the connection string.
include 'Connect.php';

// Get information from incoming json variable.
$json = file_get_contents('php://input');
$obj = json_decode($json);

// Gimme an array for the data!  Also, set the check for food to false.
$data = array();
$data['FoodFound'] = false;
$data['FoodItem'] = array();

// The query to check for food items with the given barcode.
$sql = "SELECT count(*) as FoodCount
		FROM `Food Item`
		WHERE BarcodeID = " . $obj->{'BarcodeID'};

// Execute the query
$result = $conn->query($sql) or die($conn->error);

// Determine how many food items were found.
$row = $result->fetch_assoc();
$foodCount = $row['FoodCount'];

// If no food items were found, output the JSON as is to show that.
if ($foodCount == 0) {
	echo json_encode($data);
	mysql_close($conn);
}
// If food items were found, create a query to get information on that food item and export it as JSON.
else {
	
	$data['FoodFound'] = true;
	
	$sql = "SELECT FI.Name as FoodName, FI.BarcodeID, FI.ID as FID,
				FC.Name as CategoryName, FC.ID as FCID
			FROM `Food Item` FI left outer join `Food Items to Categories` on FID = ID
				left outer join `Food Category` FC on FC.ID = FCID
			WHERE BarcodeID = " . $obj->{'BarcodeID'};
		
	$result = $conn->query($sql) or die($conn->error);
	$row = $result->fetch_assoc();
	
	// Create a temporary array to be pushed into the FoodItem Array of the JSON variable
	$temp = array();
		
	$temp['FoodName'] = $row['FoodName'];
	$temp['BarcodeID'] = $row['BarcodeID'];
	$temp['FoodID'] = $row['FID'];
	$temp['CategoryName'] = $row['CategoryName'];
	$temp['FoodCategoryID'] = $row['FCID'];
		
	array_push($data['FoodItem'],$temp);
	
	// Echo the results and close the connection
	echo json_encode($data);
	mysql_close($conn);
	
}

?>