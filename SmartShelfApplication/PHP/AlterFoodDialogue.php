<html>
<head>

<title>Food DB Alterererer</title>

</head>

<body>

	<?php
		if (isset($_REQUEST["Task"])) {

		
		
		$infoArray = array("ID" => $_REQUEST["ID"],
						   "Name" => $_REQUEST["Name"],
						   "FCID" => $_REQUEST["FCID"]);
		
		$json = json_encode($infoArray);
		
		if ($_REQUEST["Task"] == "Add") {
			include "AddFoodItem.php";
		}
		else if ($_REQUEST["Task"] == "Remove") {
			include "RemoveFoodItem.php";
		}
		
		echo "<h1>All done!</h1>";	

		} else {
	?>
	
	<h1> Feedback Form: </h1>
	<form action = "AlterFoodDialogue.php" method = "GET">
	
	Task: <br/>
	<input type = "radio" name = "Task" value = "Add"> Add<br/>
	<input type = "radio" name = "Task" value = "Remove"> Remove<br/>
	<br/>
	Name: <br/>
	<input type = "text" name = "Name"> <br/>
	<br/>
	ID: <br/>
	<input type = "text" name = "ID"> <br/>
	<br/>
	FCID: <br/>
	<input type = "text" name = "FCID"> <br/>
	<br/>
	<input type="submit" value = "submit">
	</form>
	<?php
		}
	?>

</body>
</html>