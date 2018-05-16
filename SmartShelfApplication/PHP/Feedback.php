<html>
<head>

<title>Feedback Form</title>

</head>

<body>

	<?php
		if (isset($_REQUEST["Name"])) {
		
		ob_start();
		echo "Name: " . $_REQUEST["Name"] . "\r\n\r\n";

		echo "Gender: " . $_REQUEST["gender"] . ".\r\n\r\n";

		echo "Preferred Features:\r\n";
		echo "    " . $_REQUEST["inventory_management"] . "\r\n";
		echo "    " . $_REQUEST["recipes"] . "\r\n";
		echo "    " . $_REQUEST["expiration"] . "\r\n";
		echo "    " . $_REQUEST["grocery_list"] . "\r\n";
		echo "    " . $_REQUEST["social"] . "\r\n\r\n";

		echo "Suggested Features:\n";
		echo $_REQUEST["additional_features"] . "\r\n\r\n";	

		echo "Additional Comments: \r\n";
		echo $_REQUEST["comments"] . "\r\n\r\n";	

		$htmlStr = ob_get_contents();
		ob_end_clean();
		
		$fileName = getcwd() . "\\User_" . $_REQUEST["Name"] . "_Feedback.txt";
		file_put_contents($fileName, $htmlStr);
		
		echo "<h1> Thank you for your feedback! </h1>";	

		} else {
	?>
	
	<h1> Feedback Form: </h1>
	<form action = "Feedback.php" method = "GET">
	Name: <br/>
	<input type = "text" name = "Name"> <br/>
	<br/>
	Gender: <br/>
	<input type = "radio" name = "gender" value = "male"> Male<br/>
	<input type = "radio" name = "gender" value = "female"> Female<br/>
	<input type = "radio" name = "gender" value = "other"> Other<br/>
	<br/>
	Of the following features, which are you most likely to use? (Check all that apply) <br/>
	<input type = "checkbox" name = "inventory_management" value = "inventory_management"> Using the app to manage your food inventory <br/>
	<input type = "checkbox" name = "recipes" value = "recipes"> Using the app to record and use recipes <br/>
	<input type = "checkbox" name = "expiration" value = "expiration"> Using the app to keep track of expiration dates <br/>
	<input type = "checkbox" name = "grocery_list" value = "grocery_list"> Using the app to create grocery lists <br/>
	<input type = "checkbox" name = "social" value = "social"> Using the app to share recipes with friends/family <br/>
	<br/>
	Are there any additional features you would like to see implemented? <br/>
	<textarea rows="10" cols="30" name = "additional_features"> </textarea>
	<br/>
	Are there any other comments you have on the app? <br/>
	<textarea rows="10" cols="30" name = "comments"> </textarea>
	<br/>
	<input type="submit" value = "submit">
	</form>
	<?php
		}
	?>

</body>
</html>