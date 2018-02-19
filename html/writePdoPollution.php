<?php
try
{
$bdd = new PDO('mysql:host=localhost;dbname=pollu_bike;charset=utf8','root','garage');
}
catch (Exception $e)
{
	die('Erreur : ' .$e->getMessage());
}

$req = $bdd->prepare('INSERT INTO data(latitude,longitude,CO,CO2,NO2,AP) Values(:latitude,:longitude,:CO,:CO2,:NO2,:AP)');
$req->execute(array(
	'latitude' => $_GET['latitude'],
	'longitude' => $_GET['longitude'],
	'CO' => $_GET['CO'],
	'CO2' => $_GET['CO2'],
	'NO2' => $_GET['NO2'],
	'AP' => $_GET['AP']));

echo 'ajouté pollution';
?>
