<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	$failure = array("code"=>"no");
	$notExist = array("code"=>"none");

	if(isset($_GET['user_name']) && isset($_GET['bigType'])){//1

		$user_name = $_GET['user_name'];
		$bigType = $_GET['bigType'];
		$connect = new connectDatabase();
		$link = $connect ->connectTo();

		if($link == "no") {//2
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}

		$query = "SELECT * FROM table_details where user_name= '$user_name' and bigType= '$bigType' ";
		$result = mysql_query($query,$link);
		$row = mysql_num_rows($result);

		if($row < 1) {
			echo json_encode($notExist,JSON_UNESCAPED_UNICODE);
			exit();
		}
		$details = array();
		while($row=mysql_fetch_array($result)){
			$startProvince = $row['startProvince'];
			$startCity = $row['startCity'];
			$startStrict = $row['startStrict'];
			$endProvince = $row['endProvince'];
			$endCity = $row['endCity'];
			$endStrict = $row['endStrict'];
			$weigh = $row['weigh'];
			$volume = $row['volume'];
			$kind = $row['kind'];
			$detail = $row['detail'];
			$newEle = array("detail" => $detail,"startProvince" => $startProvince,"startCity" => $startCity,"startStrict" => $startStrict,"endProvince" => $endProvince,"endCity" => $endCity,"endStrict" => $endStrict,"weigh" => $weigh,"volume" => $volume,"kind" => $kind);
			array_push($details, $newEle);
		}

		echo json_encode($details,JSON_UNESCAPED_UNICODE);



    }
?>