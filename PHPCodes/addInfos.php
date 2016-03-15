<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	$success = array("code"=>"ok");
	$failure = array("code"=>"no");

	if(isset($_GET['user_name']) && isset($_GET['startProvince']) && isset($_GET['startCity']) && isset($_GET['startStrict']) && isset($_GET['endProvince']) && isset($_GET['endCity']) && isset($_GET['endStrict']) && isset($_GET['weigh']) && isset($_GET['volume']) && isset($_GET['detail']) && isset($_GET['bigType']) && isset($_GET['kind'])){//1

		$user_name = $_GET['user_name'];
		$startProvince = $_GET['startProvince'];
		$startCity = $_GET['startCity'];
		$startStrict = $_GET['startStrict'];
		$endProvince = $_GET['endProvince'];
		$endCity = $_GET['endCity'];
		$endStrict = $_GET['endStrict'];
		$detail = $_GET['detail'];
		$weigh = $_GET['weigh'];
		$volume = $_GET['volume'];
		$bigType = $_GET['bigType'];
		$kind = $_GET['kind'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();

		if($link == "no") {//2
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}

		$sql = "INSERT INTO table_details (user_name,startProvince,startCity,StartStrict,endProvince,endCity,endStrict,weigh,volume,detail,bigType,kind) VALUES ('$user_name','$startProvince','$startCity','$startStrict','$endProvince','$endCity','$endStrict','$weigh','$volume','$detail','$bigType','$kind')";
		if (!mysql_query($sql,$link)) {
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}

		echo json_encode($success,JSON_UNESCAPED_UNICODE);
    }
?>