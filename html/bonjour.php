<!doctype html>
	<html>
		<head>
			<title> test bonjour</title>
		</head>
		<body>
			<?php
			if(isset($_POST['prenom']))
				{
				  echo 'bonjour' .' ' .  $_POST['prenom']; d
				}
			else
				{
				echo 'renseigner nom et prenom';
				}
			?>
		</body>
</html>
