<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	$failure = array("code"=>"no");
	$notExist = array("code"=>"none");

	if(isset($_GET['startProvince']) && isset($_GET['startCity']) && isset($_GET['startStrict']) && isset($_GET['endProvince']) && isset($_GET['endCity']) && isset($_GET['endStrict']) && isset($_GET['weigh']) && isset($_GET['volume']) && isset($_GET['bigType']) && isset($_GET['kind'])){

		$startProvince = $_GET['startProvince'];
		$startCity = $_GET['startCity'];
		$startStrict = $_GET['startStrict'];
		$endProvince = $_GET['endProvince'];
		$endCity = $_GET['endCity'];
		$endStrict = $_GET['endStrict'];
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



		$sql = "SELECT * FROM table_details where startProvince = '$startProvince' and endProvince = '$endProvince' and weigh >= $weigh and volume >= $volume and bigType = $bigType and kind = $kind";
		$result = mysql_query($sql,$link);
		$row = mysql_num_rows($result);
		if($row < 1) {
			echo json_encode($notExist,JSON_UNESCAPED_UNICODE);
			exit();
		}
		$details = array();
		while($row=mysql_fetch_array($result)){
			$user_name = $row['user_name'];
			$startProvince = $row['startProvince'];
			$startCity = $row['startCity'];
			$startStrict = $row['startStrict'];
			$endProvince = $row['endProvince'];
			$endCity = $row['endCity'];
			$endStrict = $row['endStrict'];
			$weigh = $row['weigh'];
			$volume = $row['volume'];
			$bigType = $row['bigType'];
			$kind = $row['kind'];
			$detail = $row['detail'];
			$newEle = array("detail" => $detail,"user_name" => $user_name,"startProvince" => $startProvince,"startCity" => $startCity,"startStrict" => $startStrict,"endProvince" => $endProvince,"endCity" => $endCity,"endStrict" => $endStrict,"weigh" => $weigh,"volume" => $volume,"bigType" => $bigType,"kind" => $kind);
			array_push($details, $newEle);
		}

		echo json_encode($details,JSON_UNESCAPED_UNICODE);

    }
?>