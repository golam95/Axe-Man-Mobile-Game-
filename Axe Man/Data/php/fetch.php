<?php

 
   include_once ('connect.php');

   
    if ($_POST['systemCall'] == 'process'){
       
        $query = mysqli_query($link, "SELECT * FROM score");
        
        if ($data =  mysqli_fetch_assoc($query)) {
			$findscore = $data['highscore'];
            print "result=$findscore";
        } else {
			
            print 'result=Something wrong.';
			
        }
    }

?>