<?php

    $db_name = 'zombie';
    $db_username = 'root';
    $db_password = '';
    $db_host = 'localhost';
	
    $link = mysqli_connect($db_host, $db_username, $db_password, $db_name);
    if (mysqli_connect_errno()) {
        die('Failed to connect to the server : '.mysqli_connect_error());
    }

  

?>