<?php

class connectDatabase {

	function connectTo() {
		/*替换为你自己的数据库名*/

$dbname = 'YhrffPdJBVreNaOXFnvd';
/*填入数据库连接信息*/
$host = 'sqld.duapp.com';
$port = 4050;
$user = '2adf3a3863d04233ab6c93259ec0b3b6';//用户AK
$pwd = '3bb3bc9ed80a407ca6c896ddb5a2a9be';//用户SK

$link = mysql_connect("{$host}:{$port}",$user,$pwd,true);

	if(!$link) {
    	return "no";
	}
/*连接成功后立即调用mysql_select_db()选中需要连接的数据库*/
	if(!mysql_select_db($dbname,$link)) {
		return "no";
	}

	return $link;

  }
	}





?>