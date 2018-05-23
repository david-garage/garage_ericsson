<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="dropdown.css">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;


      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 00px;
        padding: 00px;
      }
    </style>
<body>
  <div id="container">
   <div class="dropDownControl" id="ddControl" title="Selection affichage gaz" onclick="(document.getElementById('myddOptsDiv').style.display == 'block') ? document.getElementById('myddOptsDiv').style.display = 'none' : document.getElementById('myddOptsDiv').style.display = 'block';"">
    Selection Gaz
    <img class="dropDownArrow" src="http://maps.gstatic.com/mapfiles/arrow-down.png" />
   </div>
   <div class = "dropDownOptionsDiv" id="myddOptsDiv">
    <div class = "dropDownItemDiv" id="mapOpt"  title="CO" onClick="alert('CO séléctionné')">
     CO
    </div>
    <div class = "dropDownItemDiv" id="satelliteOpt" title="CO2" onClick="alert('CO2 selectionné')">
     CO2
    </div>
    <div class = "dropDownItemDiv" id="NO2Opt" title="NO2" onClick="alert('NO2 selectionné')">
     NO2
    </div>
    <div class = "dropDownItemDiv" id="APOpt" title="AP" onClick="alert('AP selectionné')">
     AP
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

    <div id="map"></div>

    <?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
 include "planelatlong.php"; ?>

<script src ="coord.js"></script>

    <script>
      var map;
      var ericsson  = {lat: 48.726772  , lng: 2.263562};

      function CenterControl(controlDiv, map) {

              // Set CSS for the control border.
              var controlUI = document.createElement('div');
              controlUI.style.backgroundColor = '#fff';
              controlUI.style.border = '2px solid #fff';
              controlUI.style.borderRadius = '3px';
              controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
              controlUI.style.cursor = 'pointer';
              controlUI.style.marginBottom = '22px';
              controlUI.style.textAlign = 'center';
              controlUI.title = 'Click to recenter the map';
              controlDiv.appendChild(controlUI);

              // Set CSS for the control interior.
              var controlText = document.createElement('div');
              controlText.style.color = 'rgb(25,25,25)';
              controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
              controlText.style.fontSize = '16px';
              controlText.style.lineHeight = '38px';
              controlText.style.paddingLeft = '5px';
              controlText.style.paddingRight = '5px';
              controlText.innerHTML = 'Center Map';
              controlUI.appendChild(controlText);

              // Setup the click event listeners: simply set the map to Chicago.
              controlUI.addEventListener('click', function() {
                map.setCenter(chicago);
              });

            }

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
                radius:  20
              });
}

}


    </script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCLQrU0gUCI5rXEAFaKGYD0wy44Y7O_mnQ&callback=initMap">
    </script>

  </body>
</html>
