<?php
try
{
$bdd = new PDO('mysql:host=localhost;dbname=gps;charset=utf8','root','garage');
}
catch (Exception $e)
{
	die('Erreur : ' .$e->getMessage());
}

$req = $bdd->prepare('INSERT INTO data(longitude,latitude) Values(:longitude,:latitude)');
$req->execute(array(
	'longitude' => $_GET['longitude'],
	'latitude' => $_GET['latitude']));

echo 'ajouté';
?>
