<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Google Map v3 Demo</title>
<!-- JavaScript -->
<!-- JavaScript - Google Map -->
<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCzqXSTgP6c8QOjBmzB6Q4OLTIC-67NtKo&sensor=false"></script>
<!-- JavaScript - jQuery -->
<script src="${pageContext.request.contextPath}/resources/jquery.1.9.1.min.js"></script>
<!-- JavaScript - Code highlight -->
<script src="${pageContext.request.contextPath}/resources/codemirror.js"></script>
<script src="${pageContext.request.contextPath}/resources/codemirror_highlight.js"></script>
<!-- CSS - Code highlight -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/3024-day.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/3024-night.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/ambiance.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/base16-dark.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/base16-light.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/blackboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/cobalt.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/eclipse.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/elegant.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/erlang-dark.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/lesser-dark.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/mbo.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/mdn-like.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/midnight.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/monokai.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/neat.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/night.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/paraiso-dark.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/paraiso-light.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/pastel-on-dark.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/rubyblue.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/solarized.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/the-matrix.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/tomorrow-night-eighties.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/twilight.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/vibrant-ink.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/xq-dark.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/codemirror_theme/xq-light.css">
<script type="text/javascript">
// ---------------------------variables---------------------------
// default value
var lat = 1.2836561280940793;
var lng = 103.85144233703613;
var myLatLng = new google.maps.LatLng(lat, lng);
var myMapTypeId = google.maps.MapTypeId.ROADMAP;
var myZoom = 17;
var myZoomIn = 20;
// value to keep the object
var map;
var markers = new Array();
var markerInfos = new Array();
var restaurantMark;
var myLocationMark;
var isMarkerInfoOn = false;
var myPolyline;
var myTrafficLayer;
// travel service	
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
// variables [End]

// ---------------------------initialization--------------------------- 
function initialize() {
	var mapProp = {
		center : myLatLng,
		zoom : myZoom,
		mapTypeId : google.maps.MapTypeId.ROADMAP
	};
	map = new google.maps.Map($("#map_canvas")[0], mapProp);
	// add event when click the map display marker	
	google.maps.event.addListener(map, 'click', function(event) {
		addMyLocationMarker(event.latLng);
	});
	// travel service
	directionsDisplay = new google.maps.DirectionsRenderer();
	directionsDisplay.setMap(map);
}
// load google map
google.maps.event.addDomListener(window, 'load', initialize);

function addMyLocationMarker(location) {
	if (myLocationMark != null) {
		myLocationMark.setMap(null);
	}

	var marker = new google.maps.Marker({
		position : location,
		map : map
	});
	var infowindow = new google.maps.InfoWindow({
		content : 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng(),
		maxWidth : 300
	});
	infowindow.open(map, marker);

	myLocationMark = marker;
	markers.push(marker);
}

// ---------------------------HTML event--------------------------- 
$(document).ready(function() {
	// test button
	//$('#test').on('click', function() {
	//	cleanAllMarkers();
	//});
	// reset page
	$('#reset').on('click', function() {
		$('#mapType').val(1);
		$('#zoomin').attr('checked', false);
		$('#polyline').attr('checked', false);
		$('#trafficLayer').attr('checked', false);
		$('#travelMode').val(1);
		location.reload();
	});
	// search function
	$('#search').on('click',function() {
		initialize();
		$('#mapType').val(1);

		$.ajax({
			url : '/ntu-is-ip-googlemap3/ajax',
			type : 'POST',
			data : 'restaurantName='+ $('#restaurantName').val() + '&action=search',
			dataType : 'json',
			success : function(data) {
			$('#result').html('');
				if (data.length > 0) {
					$('#result')
							.append("<select id='restResult' name='restResult' onChange='onChangeRestResult()'></select>");
					for ( var i in data) {
						$("#restResult")
						.append("<option value='" 
						+ data[i].lat + "-"
						+ data[i].lng +"'>"
						+ data[i].name
						+ " ("
						+ data[i].formattedAddress
						+ ")"
						+ "</option>");
					}
					updateMapAfterSelected(
							$("#restResult").val(),
							data[0]);
				}
			}
		});
			return false;
		});
	// map type
	$('#mapType').on('change',function() {
		var value = $(this).val();
		if (value == 1) {
			map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
		} else if (value == 2) {
			map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
		} else if (value == 3) {
			map.setMapTypeId(google.maps.MapTypeId.HYBRID);
		} else if (value == 4) {
			map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
		} else {
			map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
		}
		return false;
	});
	// zoom in
	$('#zoomin').on('change', function() {
		if (this.checked) {
			map.setZoom(myZoomIn);
			moveCenter(myLatLng);
		} else {
			map.setZoom(myZoom);
			moveCenter(myLatLng);
		}
	});
	// polyline
	$('#polyline').on('change', function() {
		if(myLocationMark == null || restaurantMark == null){
			alert("Please click map to get your location and select restaurant first.");
			return false;
		}
		if (this.checked) {
			addPolyline();
		} else {
			removePolyline();
		}
	});
	// traffic layer
	$('#trafficLayer').on('change', function() {
		if (this.checked) {
			addTrafficLayer();
		} else {
			removeTrafficLayer();
		}
	});
	// travel modes in directions, call google cloud service
	$('#go').on('click',function() {
		if(myLocationMark == null || restaurantMark == null){
			alert("Please click map to get your location and select restaurant first.");
			return false;
		}
		var value = $('#travelMode').val();
		var request = {
			origin: myLocationMark.getPosition(),
			destination: restaurantMark.getPosition(),
			// Note that Javascript allows us to access the constant
			// using square brackets and a string value as its
			// "property."
			travelMode: google.maps.TravelMode[value]
		};
		directionsService.route(request, function(response, status) {
						if (status == google.maps.DirectionsStatus.OK) {
						    directionsDisplay.setDirections(response);
						}
		});
	});
});

// ---------------------------method after search--------------------------- 
function updateMapAfterSelected(locationValue, restaurant) {
	var ss = locationValue.split("-");
	var myLatLng = new google.maps.LatLng(ss[0], ss[1]);
	moveCenter(myLatLng);
	addMarker(myLatLng, restaurant);
}

function moveCenter(currentLatLng) {
	myLatLng = currentLatLng;
	map.setCenter(currentLatLng);
}

function addMarker(myLatLng, restaurant) {
	// construct marker
	var marker = new google.maps.Marker({
		position : myLatLng,
		draggable : false,
		animation : google.maps.Animation.DROP,
		title : restaurant.name,
		icon : '${pageContext.request.contextPath}/resources/restaurant-icon.png'
	});
	marker.setMap(map);
	restaurantMark = marker;
	
	// construct information window
	var info = '<div id="content">' + '<h4>' + restaurant.name + '</h4>'
			+ '<div id="bodyContent">' + '<p>'
			+ '<a target="_blank" href="'+ restaurant.url + '">'
			+ restaurant.url + '</a>' + '</p>' + '<p>'
			+ restaurant.description + '</p>' + '</div>' + '</div>';
	var infowindow = new google.maps.InfoWindow({
		content : info,
		maxWidth : 200
	});

	// onclick event on mark (zoom in/out, show information window)
	google.maps.event.addListener(marker, 'click', function() {
		map.setCenter(marker.getPosition());
		if (isMarkerInfoOn) {
			isMarkerInfoOn = false;
			infowindow.close(map, marker);
			map.setZoom(myZoom);
		} else {
			isMarkerInfoOn = true;
			infowindow.open(map, marker);
			map.setZoom(myZoomIn);
		}
		toggleBounce(marker);
	});

	// just for demo, disable on application:
	// 3 seconds after the center of the map has changed, pan back to the marker.
	// [Start]
	//google.maps.event.addListener(map, 'center_changed', function() {
	//	window.setTimeout(function() {
	//		map.panTo(marker.getPosition());
	//	}, 3000);
	//});
	// [End]

	// keep object in array to batch operation
	markers.push(marker);
	markerInfos.push(infowindow);
}

function toggleBounce(marker) {
	if (marker.getAnimation() != null) {
		marker.setAnimation(null);
	} else {
		marker.setAnimation(google.maps.Animation.BOUNCE);
	}
}

// ---------------------------method after select restaurant--------------------------- 
function onChangeRestResult() {
	cleanAllMarkers();
	map.setZoom(myZoom);
	$.ajax({
		url : '/ntu-is-ip-googlemap3/ajax',
		type : 'POST',
		data : 'location=' + $('#restResult').val() + '&action=changeRest',
		dataType : 'json',
		success : function(data) {
			updateMapAfterSelected($("#restResult").val(), data[0]);
		}
	});
}

function cleanAllMarkers() {
	for ( var i in markers) {
		markers[i].setMap(null);
	}
}

// ---------------------------method for polyline--------------------------- 
function addPolyline(){
	// can more than 2
	var points=[restaurantMark.getPosition(), myLocationMark.getPosition()];
	var polyline=new google.maps.Polyline({
	  path:points,
	  strokeColor:"#0000FF",
	  strokeOpacity:0.8,
	  strokeWeight:2
	  });
	polyline.setMap(map);
	myPolyline = polyline;
}

function removePolyline(){
	myPolyline.setMap(null);
	myPolyline = null;
}

// ---------------------------method for traffic layer---------------------------
function addTrafficLayer(){
	var trafficLayer = new google.maps.TrafficLayer();
	trafficLayer.setMap(map);
	myTrafficLayer = trafficLayer;
}

function removeTrafficLayer(){
	myTrafficLayer.setMap(null);
	myTrafficLayer = null;
}
</script>
</head>
<body>
 <table>
  <tr>
   <td>
   <h3><img src="${pageContext.request.contextPath}/resources/icon.png" >Google Map v3 Demo</h3>
    <div>
     <form>
      <p>
       Restaurant Name:
       <input id="restaurantName" name="restaurantName" type="text" value="Restaurant">
      </p>
      <input id="search" type="button" value="Search">
      <input id="reset" type="button" value="Reset">
     </form>
    </div>
    <div id="result"></div>
    <div>
     Map Type:
     <select id="mapType" name="mapType">
      <option value="1">Road Map</option>
      <option value="2">Satellite</option>
      <option value="3">Hybrid</option>
      <option value="4">Terrain Road</option>
     </select>
    </div>
    <div>
     Zoom In:
     <input id="zoomin" value="zoomin" type="checkbox">
    </div>
    <div>
     Polyline:
     <input id="polyline" value="polyline" type="checkbox">
    </div>
    <div>
     Traffice Layer:
     <input id="trafficLayer" value="trafficLayer" type="checkbox">
    </div>
    <div>
     Mode of Travel:
    <select id="travelMode">
      <option value="DRIVING">Driving</option>
      <option value="WALKING">Walking</option>
      <option value="BICYCLING">Bicycling</option>
      <option value="TRANSIT">Transit</option>
    </select>
    <input id="go" type="button" value="Go">
    </div>
    <!--
    <div>
     <input id="test" type="button" value="Test">
    </div>
     -->
    <div id="map_canvas" style="width: 750px; height: 500px;"></div>
    <div>
     <h3>Resources</h3>
     <div>
      <a target="_blank" href="http://www.w3schools.com/googleAPI/google_maps_api_key.asp">How to Get Google API Key</a>
     </div>
     <div>
      <a target="_blank" href="https://code.google.com/apis/console">Google API Key Entry Link</a>
     </div>
     <div>
      <a target="_blank" href="https://developers.google.com/maps/documentation/javascript/tutorial">Google Maps JavaScript API v3</a>
     </div>
     <div>
      <a target="_blank" href="http://www.w3schools.com/googleapi/default.asp">W3Schools Google Maps API Tutorial</a>
     </div>
     <div>
      <a target="_blank" href="http://maps.googleapis.com/maps/api/geocode/json?address=195%20Serangoon%20Road,%20Singapore%20218067&sensor=false">GEO Code (EN Address) Sample</a>
     </div>
     <div>
      <a target="_blank" href="http://maps.googleapis.com/maps/api/geocode/json?address=%E5%8F%B0%E5%8C%97%E5%B7%BF%E5%85%89%E5%BE%A9%E5%8D%97%E8%B7%AF100%E8%99%9F&sensor=false">GEO Code (CN Address) Sample</a>
     </div>
    </div>
   </td>
   <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
   <!-- Source Code -->
   <!-- TODO move JavaScript to other files -->
   <td>
   <textarea id="code" name="code">
// ---------------------------variables---------------------------
// default value
var lat = 1.2836561280940793;
var lng = 103.85144233703613;
var myLatLng = new google.maps.LatLng(lat, lng);
var myMapTypeId = google.maps.MapTypeId.ROADMAP;
var myZoom = 17;
var myZoomIn = 20;
// value to keep the object
var map;
var markers = new Array();
var markerInfos = new Array();
var restaurantMark;
var myLocationMark;
var isMarkerInfoOn = false;
var myPolyline;
var myTrafficLayer;
// travel service	
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
// variables [End]

// ---------------------------initialization--------------------------- 
function initialize() {
	var mapProp = {
		center : myLatLng,
		zoom : myZoom,
		mapTypeId : google.maps.MapTypeId.ROADMAP
	};
	map = new google.maps.Map($("#map_canvas")[0], mapProp);
	// add event when click the map display marker	
	google.maps.event.addListener(map, 'click', function(event) {
		addMyLocationMarker(event.latLng);
	});
	// travel service
	directionsDisplay = new google.maps.DirectionsRenderer();
	directionsDisplay.setMap(map);
}
// load google map
google.maps.event.addDomListener(window, 'load', initialize);

function addMyLocationMarker(location) {
	if (myLocationMark != null) {
		myLocationMark.setMap(null);
	}

	var marker = new google.maps.Marker({
		position : location,
		map : map
	});
	var infowindow = new google.maps.InfoWindow({
		content : 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng(),
		maxWidth : 300
	});
	infowindow.open(map, marker);

	myLocationMark = marker;
	markers.push(marker);
}

// ---------------------------HTML event--------------------------- 
$(document).ready(function() {
	// test button
	//$('#test').on('click', function() {
	//	cleanAllMarkers();
	//});
	// reset page
	$('#reset').on('click', function() {
		$('#mapType').val(1);
		$('#zoomin').attr('checked', false);
		$('#polyline').attr('checked', false);
		$('#trafficLayer').attr('checked', false);
		$('#travelMode').val(1);
		location.reload();
	});
	// search function
	$('#search').on('click',function() {
		initialize();
		$('#mapType').val(1);

		$.ajax({
			url : '/ntu-is-ip-googlemap3/ajax',
			type : 'POST',
			data : 'restaurantName='+ $('#restaurantName').val() + '&action=search',
			dataType : 'json',
			success : function(data) {
			$('#result').html('');
				if (data.length > 0) {
					$('#result')
							.append("<select id='restResult' name='restResult' onChange='onChangeRestResult()'></select>");
					for ( var i in data) {
						$("#restResult")
						.append("<option value='" 
						+ data[i].lat + "-"
						+ data[i].lng +"'>"
						+ data[i].name
						+ " ("
						+ data[i].formattedAddress
						+ ")"
						+ "</option>");
					}
					updateMapAfterSelected(
							$("#restResult").val(),
							data[0]);
				}
			}
		});
			return false;
		});
	// map type
	$('#mapType').on('change',function() {
		var value = $(this).val();
		if (value == 1) {
			map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
		} else if (value == 2) {
			map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
		} else if (value == 3) {
			map.setMapTypeId(google.maps.MapTypeId.HYBRID);
		} else if (value == 4) {
			map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
		} else {
			map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
		}
		return false;
	});
	// zoom in
	$('#zoomin').on('change', function() {
		if (this.checked) {
			map.setZoom(myZoomIn);
			moveCenter(myLatLng);
		} else {
			map.setZoom(myZoom);
			moveCenter(myLatLng);
		}
	});
	// polyline
	$('#polyline').on('change', function() {
		if(myLocationMark == null || restaurantMark == null){
			alert("Please click map to get your location and select restaurant first.");
			return false;
		}
		if (this.checked) {
			addPolyline();
		} else {
			removePolyline();
		}
	});
	// traffic layer
	$('#trafficLayer').on('change', function() {
		if (this.checked) {
			addTrafficLayer();
		} else {
			removeTrafficLayer();
		}
	});
	// travel modes in directions, call google cloud service
	$('#go').on('click',function() {
		if(myLocationMark == null || restaurantMark == null){
			alert("Please click map to get your location and select restaurant first.");
			return false;
		}
		var value = $('#travelMode').val();
		var request = {
			origin: myLocationMark.getPosition(),
			destination: restaurantMark.getPosition(),
			// Note that Javascript allows us to access the constant
			// using square brackets and a string value as its
			// "property."
			travelMode: google.maps.TravelMode[value]
		};
		directionsService.route(request, function(response, status) {
						if (status == google.maps.DirectionsStatus.OK) {
						    directionsDisplay.setDirections(response);
						}
		});
	});
});

// ---------------------------method after search--------------------------- 
function updateMapAfterSelected(locationValue, restaurant) {
	var ss = locationValue.split("-");
	var myLatLng = new google.maps.LatLng(ss[0], ss[1]);
	moveCenter(myLatLng);
	addMarker(myLatLng, restaurant);
}

function moveCenter(currentLatLng) {
	myLatLng = currentLatLng;
	map.setCenter(currentLatLng);
}

function addMarker(myLatLng, restaurant) {
	// construct marker
	var marker = new google.maps.Marker({
		position : myLatLng,
		draggable : false,
		animation : google.maps.Animation.DROP,
		title : restaurant.name,
		icon : '${pageContext.request.contextPath}/resources/restaurant-icon.png'
	});
	marker.setMap(map);
	restaurantMark = marker;
	
	// construct information window
	var info = '<div id="content">' + '<h4>' + restaurant.name + '</h4>'
			+ '<div id="bodyContent">' + '<p>'
			+ '<a target="_blank" href="'+ restaurant.url + '">'
			+ restaurant.url + '</a>' + '</p>' + '<p>'
			+ restaurant.description + '</p>' + '</div>' + '</div>';
	var infowindow = new google.maps.InfoWindow({
		content : info,
		maxWidth : 200
	});

	// onclick event on mark (zoom in/out, show information window)
	google.maps.event.addListener(marker, 'click', function() {
		map.setCenter(marker.getPosition());
		if (isMarkerInfoOn) {
			isMarkerInfoOn = false;
			infowindow.close(map, marker);
			map.setZoom(myZoom);
		} else {
			isMarkerInfoOn = true;
			infowindow.open(map, marker);
			map.setZoom(myZoomIn);
		}
		toggleBounce(marker);
	});

	// just for demo, disable on application:
	// 3 seconds after the center of the map has changed, pan back to the marker.
	// [Start]
	//google.maps.event.addListener(map, 'center_changed', function() {
	//	window.setTimeout(function() {
	//		map.panTo(marker.getPosition());
	//	}, 3000);
	//});
	// [End]

	// keep object in array to batch operation
	markers.push(marker);
	markerInfos.push(infowindow);
}

function toggleBounce(marker) {
	if (marker.getAnimation() != null) {
		marker.setAnimation(null);
	} else {
		marker.setAnimation(google.maps.Animation.BOUNCE);
	}
}

// ---------------------------method after select restaurant--------------------------- 
function onChangeRestResult() {
	cleanAllMarkers();
	map.setZoom(myZoom);
	$.ajax({
		url : '/ntu-is-ip-googlemap3/ajax',
		type : 'POST',
		data : 'location=' + $('#restResult').val() + '&action=changeRest',
		dataType : 'json',
		success : function(data) {
			updateMapAfterSelected($("#restResult").val(), data[0]);
		}
	});
}

function cleanAllMarkers() {
	for ( var i in markers) {
		markers[i].setMap(null);
	}
}

// ---------------------------method for polyline--------------------------- 
function addPolyline(){
	// can more than 2
	var points=[restaurantMark.getPosition(), myLocationMark.getPosition()];
	var polyline=new google.maps.Polyline({
	  path:points,
	  strokeColor:"#0000FF",
	  strokeOpacity:0.8,
	  strokeWeight:2
	  });
	polyline.setMap(map);
	myPolyline = polyline;
}

function removePolyline(){
	myPolyline.setMap(null);
	myPolyline = null;
}

// ---------------------------method for traffic layer---------------------------
function addTrafficLayer(){
	var trafficLayer = new google.maps.TrafficLayer();
	trafficLayer.setMap(map);
	myTrafficLayer = trafficLayer;
}

function removeTrafficLayer(){
	myTrafficLayer.setMap(null);
	myTrafficLayer = null;
}
   </textarea>
    <p>
     Select a theme:
     <select onchange="selectTheme()" id=select>
      <option selected>default</option>
      <option>3024-day</option>
      <option>3024-night</option>
      <option>ambiance</option>
      <option>base16-dark</option>
      <option>base16-light</option>
      <option>blackboard</option>
      <option>cobalt</option>
      <option>eclipse</option>
      <option>elegant</option>
      <option>erlang-dark</option>
      <option>lesser-dark</option>
      <option>mbo</option>
      <option>mdn-like</option>
      <option>midnight</option>
      <option>monokai</option>
      <option>neat</option>
      <option>night</option>
      <option>paraiso-dark</option>
      <option>paraiso-light</option>
      <option>pastel-on-dark</option>
      <option>rubyblue</option>
      <option>solarized dark</option>
      <option>solarized light</option>
      <option>the-matrix</option>
      <option>tomorrow-night-eighties</option>
      <option>twilight</option>
      <option>vibrant-ink</option>
      <option>xq-dark</option>
      <option>xq-light</option>
     </select>
    </p></td>
  </tr>
 </table>
 <script>
	var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
		lineNumbers : true,
		styleActiveLine : true,
		matchBrackets : true
	});
	editor.setSize(800, 600);
	var input = document.getElementById("select");
	function selectTheme() {
		var theme = input.options[input.selectedIndex].innerHTML;
		editor.setOption("theme", theme);
	}
 </script>
</body>
</html>
