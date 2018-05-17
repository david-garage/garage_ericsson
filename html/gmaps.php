<!DOCTYPE html>
<html>
  <head>
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 50%;
        margin: 100px;
        padding: 100px;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 100px;
        padding: 100px;
      }
    </style>

  <div class="container">
   <div class="dropDownControl" id="ddControl" title="A custom drop down select with mixed elements" onclick="(document.getElementById('myddOptsDiv').style.display == 'block') ? document.getElementById('myddOptsDiv').style.display = 'none' : document.getElementById('myddOptsDiv').style.display = 'block';"">
    My Box
    <img class="dropDownArrow" src="http://maps.gstatic.com/mapfiles/arrow-down.png" />
   </div>
   <div class = "dropDownOptionsDiv" id="myddOptsDiv">
    <div class = "dropDownItemDiv" id="mapOpt"  title="This acts like a button or click event" onClick="alert('dav1')">
     Option 1
    </div>
    <div class = "dropDownItemDiv" id="satelliteOpt" title="This acts like a button or click event" onClick="alert('option2')">
     Option 2
    </div>
    <div class="separatorDiv"></div>
    <div class="checkboxContainer" title="This allows for multiple selection/toggling on/off" onclick="(document.getElementById('terrainCheck').style.display == 'block') ? document.getElementById('terrainCheck').style.display = 'none' : document.getElementById('terrainCheck').style.display = 'block';">
     <span role="checkbox" class="checkboxSpan ">
      <div class="blankDiv" id="terrainCheck">
       <img class="blankImg" src="http://maps.gstatic.com/mapfiles/mv/imgs8.png" />
      </div>
     </span>
     <label class="checkboxLabel">On/Off</label>
    </div>
   </div>
  </div>
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
