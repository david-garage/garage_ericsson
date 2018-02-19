<?php
try
{
	$bdd = new PDO('mysql:host=localhost;dbname=pollu_bike;charset=utf8','root','garage');
	
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
	<strong>Pollution</strong> : 
	latitude : <?php echo $donnees['latitude']; ?> , longitude : <?php echo $donnees['longitude']; ?> , CO :   <?php echo $donnees['CO']; ?> , CO2 :  <?php echo $donnees['CO2']; ?> , NO2 : <?php echo $donnees['NO2']; ?> , AP : <?php echo $donnees['AP']; ?> . <br />

	
	</p>
<?php
}	
$reponse ->closeCursor();
?>
