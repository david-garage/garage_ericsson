<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
file_put_contents("coord.js", "");
$db = new mysqli('localhost', 'root', 'Garage!2018', 'pollu_bike');

if($db->connect_errno > 0){
    die('Unable to connect to database [' . $db->connect_error . ']');
}
else
//echo connecté;
$sql = <<<SQL
    SELECT `latitude` , `longitude` , `CO` , `CO2` , `NO2` ,  `AP` , `IdUser`
    FROM `data`
SQL;

if(!$result = $db->query($sql)){
    die('There was an error running the query [' . $db->error . ']');
}
//echo 'Total results: ' . $result->num_rows . '<br />';
$planelatlong  = array();



while($row = $result->fetch_assoc()){
	$planelatlong[] = $row;


}
echo "var planelatlong =[  <br />";

for($i=0;$i<($result->num_rows);$i++)
{
	echo "[".$planelatlong[$i]['longitude'].",".$planelatlong[$i]['longitude'].",".$planelatlong[$i]['CO'].",".$planelatlong[$i]['CO2'].",".$planelatlong[$i]['NO2'].",".$planelatlong[$i]['AP'],"]";
if ($i <= ($result->num_rows-2) ) {
echo ",<br />";
}


}
echo "];";
//return $data;
print_r($planelatlong);
//echo json_encode($data);
$test = "var planelatlong = [";
 $myfile = file_put_contents('coord.js',$test.PHP_EOL , FILE_APPEND | LOCK_EX);

for($i=0;$i<($result->num_rows);$i++)
{

  $text =  "[".$planelatlong[$i]['longitude'].",".$planelatlong[$i]['longitude'].",".$planelatlong[$i]['CO'].",".$planelatlong[$i]['CO2'].",".$planelatlong[$i]['NO2'].",".$planelatlong[$i]['AP'].",".$planelatlong[$i]['IdUser'],"]";
	$myfile = file_put_contents('coord.js', $text.PHP_EOL , FILE_APPEND | LOCK_EX);
	if ($i <= ($result->num_rows-2) ) {
	$text =  ",";
	$myfile = file_put_contents('coord.js', $text.PHP_EOL , FILE_APPEND | LOCK_EX);
}
}
$text = "];";
$myfile = file_put_contents('coord.js', $text.PHP_EOL , FILE_APPEND | LOCK_EX);
?>
