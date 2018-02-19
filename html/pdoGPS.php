<?php
try
{
	$bdd = new PDO('mysql:host=localhost;dbname=gps;charset=utf8','root','garage');
	
}
catch (Exception $e)
	{
		die("Erreur : " . $e->getMessage());
	}
$reponse =$bdd->query('SELECT * FROM data');
while($donnees = $reponse->fetch())
{
?>	
	<p>
	<strong>Position</strong> : 
	longi :   <?php echo $donnees['longitude']; ?> , lat :  <?php echo $donnees['latitude']; ?> . <br />

	
	</p>
<?php
}	
$reponse ->closeCursor();
?>
