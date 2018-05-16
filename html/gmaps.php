<!DOCTYPE html>
<html>
  <head>
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>

    <?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
 include "planelatlong.php"; ?>

<script src ="../coord.js"></script>

    <script>
      var map;
      var ericsson  = {lat: 48.726772  , lng: 2.263562};




      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 16,
          center: ericsson,
          mapTypeId: 'terrain',
	zoomControl : true,
	scaleControl : true
        });


for (var i = 0; i < planelatlong.length; i++) {
    var point = planelatlong[i];
	var red;
	var a =point[2];
	var green ;
	var max = 255;
	if(a<142)
	{
	var red = Math.floor(point[2]*2*255/283);
	var green = 255;
	var couleur = '#'+ red.toString(16)+'ff00' ;
	}
	else
	{
	var red = 255;
	 var green =255-Math.floor( point[2] * (255 / 283));
	var couleur =  '#ff'+green.toString() +'00';
	}


    var cityCircle = new google.maps.Circle({
                strokeColor: couleur,
                strokeOpacity: 1,
                strokeWeight: 2,
                fillColor: couleur,
                fillOpacity: 1,
                map: map,
                center: {lat: point[0], lng: point[1]},
                radius:  30
              });
   }






             }



    </script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCLQrU0gUCI5rXEAFaKGYD0wy44Y7O_mnQ&callback=initMap">
    </script>
  </body>
</html>
