<?php
try
{
$bdd = new PDO('mysql:host=localhost;dbname=test;charset=utf8','root','garage');
}
catch (Exception $e)
{
	die('Erreur : ' .$e->getMessage());
}

$req = $bdd->prepare('INSERT INTO jeux_video(nom,possesseur,prix) Values(:nom,:possesseur,:prix)');
$req->execute(array(
	'nom' => $_GET['nom'],
	'possesseur' => $_GET['possesseur'],
	'prix' => $_GET['prix']));

echo 'ajouté';
?>
