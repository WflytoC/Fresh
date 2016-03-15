<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	$failure = array("code"=>"no");
	$carUser = array("code"=>"car");
	$goodsUser = array("code"=>"goods");

	if(isset($_GET['user_name']) && isset($_GET['user_password'])){//1

		$user_name = $_GET['user_name'];
		$user_password = $_GET['user_password'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();

		if($link == "no") {//2
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}

		$query = "SELECT * FROM table_user where user_name= '$user_name' and user_password= '$user_password' ";
		$result = mysql_query($query,$link);
		$row = mysql_num_rows($result);


		if($row > 0) {
			$query = "SELECT * FROM table_user where user_name= '$user_name' and user_password= '$user_password' and user_kind = 1 ";
			$result = mysql_query($query,$link);
			$row = mysql_num_rows($result);
			if ($row > 0) {
				echo json_encode($goodsUser,JSON_UNESCAPED_UNICODE);
				exit();
			} else {
				echo json_encode($carUser,JSON_UNESCAPED_UNICODE);
				exit();
			}
			
		}else {
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
		}
    }
?>