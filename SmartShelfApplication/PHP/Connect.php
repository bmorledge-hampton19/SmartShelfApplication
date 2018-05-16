<?php
// Store information about the database.
$serverName = "smartshelfdb.cxrhey6dit8l.us-east-1.rds.amazonaws.com";
$dbName = "SmartShelf";
$username = "brotherbenben";
$password = "Benmon123";

// Use the database information to create a connection string to be used by other PHP codes.
$conn = new mysqli($serverName, $username, $password, $dbName);

// Test the connection.
if ($conn->connect_errno) {
     die("Connection failed: " . $conn->connect_error);
     exit();
  }
?>