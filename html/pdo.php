<?php
try
{
	$bdd = new PDO('mysql:host=localhost;dbname=test;charset=utf8','root','garage');
	
}
catch (Exception $e)
	{
		die("Erreur : " . $e->getMessage());
	}
$reponse =$bdd->query('SELECT * FROM jeux_video');
while($donnees = $reponse->fetch())
{
?>	
	<p>
	<strong>Position</strong> : 
	nom :   <?php echo $donnees['nom']; ?> , possesseur :  <?php echo $donnees['possesseur']; ?> . <br />

	
	</p>
<?php
}	
$reponse ->closeCursor();
?>
