<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	$success = array("code"=>"ok");
	$failure = array("code"=>"no");
	$repeat = array("code"=>"repeat");
	$goods = array("code"=>"goods");
	$car = array("code"=>"car");
	$forbiddenGoods = array("code"=>"forbiddenGoods");
	$forbiddenCar = array("code"=>"forbiddenCar");
	if(isset($_GET['user_name']) && isset($_GET['user_password']) && isset($_GET['user_kind'])){
		$user_name = $_GET['user_name'];
		$user_password = $_GET['user_password'];
		$user_kind = $_GET['user_kind'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();
		if($link == "no") {
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}
		$query = "SELECT * FROM table_user where user_name = '$user_name' ";
		$result = mysql_query($query,$link);
		$row = mysql_num_rows($result);
		if($row > 0) {
			echo json_encode($repeat,JSON_UNESCAPED_UNICODE);
			exit();
		}
		if ($user_kind == 1) {
			$query = "SELECT * FROM user_allow where allow_phone = '$user_name' ";
			$result = mysql_query($query,$link);
			$row = mysql_num_rows($result);
			if($row > 0) {
				echo json_encode($forbiddenGoods,JSON_UNESCAPED_UNICODE);
				exit();
			}
			$sql = "INSERT INTO table_user (user_name,user_password,user_kind) VALUES ('$user_name','$user_password','$user_kind')";
			if (!mysql_query($sql,$link)) {
				echo json_encode($failure,JSON_UNESCAPED_UNICODE);
				exit();
			}
			echo json_encode($goods,JSON_UNESCAPED_UNICODE);

		} elseif ($user_kind == 2) {
			$query = "SELECT * FROM user_allow where allow_phone = '$user_name' ";
			$result = mysql_query($query,$link);
			$row = mysql_num_rows($result);
			if($row < 1) {
				echo json_encode($forbiddenCar,JSON_UNESCAPED_UNICODE);
				exit();
			}
			$sql = "INSERT INTO table_user (user_name,user_password,user_kind) VALUES ('$user_name','$user_password','$user_kind')";
			if (!mysql_query($sql,$link)) {
				echo json_encode($failure,JSON_UNESCAPED_UNICODE);
				exit();
			}
			echo json_encode($car,JSON_UNESCAPED_UNICODE);
		}

    }
?>