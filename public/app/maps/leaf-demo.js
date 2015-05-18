var map = L.map( 'map', {
    center: [20.0, 5.0],
    minZoom: 2,
    zoom: 2
});

L.tileLayer( 'http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright" title="OpenStreetMap" target="_blank">OpenStreetMap</a> contributors | Tiles Courtesy of <a href="http://www.mapquest.com/" title="MapQuest" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png" width="16" height="16">',
    subdomains: ['otile1','otile2','otile3','otile4']
}).addTo( map );

var myURL = jQuery( 'script[src$="leaf-demo.js"]' ).attr( 'src' ).replace( 'leaf-demo.js', '' );
var myIcon = L.icon({
    iconUrl: myURL + 'images/pin24.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});

var myButtonOptions = {
    'text': 'MyButton',  // string
    'iconUrl': myURL + 'images/myButton.png',  // string
    'onClick': my_button_onClick,  // callback function
    'hideText': true,  // bool
    'maxWidth': 30,  // number
    'doToggle': false,  // bool
    'toggleStatus': false  // bool
};

// button (used as a UNDO button atm)
var myButton = new L.Control.Button(myButtonOptions).addTo(map);

// layer for holding the route (markers and lines)
var waypointLayer = L.layerGroup();

// array for holding the coordinates
var latlngs = Array();

//array for holding markers
var markers = Array();

// var to hold popup
var popup = L.popup();


function drawMap() {
    // clear old waypoint layer
    waypointLayer.clearLayers();

    // adds all makers to waypoint layer
    for(var i = 0; i < markers.length; i++) {
        markers[i].addTo(waypointLayer);
    }

    // adds all latlngs to the waypoint layer
    L.polyline(latlngs, {color: 'red'})
        .addTo(waypointLayer);

    // draw waypoint layer to map
    waypointLayer.addTo(map);

}


// function to be called on mouse click
function onMapClick(e)
{
    console.log("someone clicked my map");

    popup
        .setLatLng(e.latlng)
        .setContent("waypoint #"+latlngs.length.toString())
        .openOn(map);

    // push coordinates to latlngs
    latlngs.push(
        L.marker(e.latlng, {icon: myIcon})
            .bindPopup(' <a href="/trips">'+ e.latlng +'</a> ')
            .getLatLng()
    );
    markers.push(
        L.marker(e.latlng, {icon: myIcon})
            .bindPopup(' <a href="/trips">'+ e.latlng +'</a> ')
    );


    drawMap();

}

// handle button clicks, button is atm a UNDO button
function my_button_onClick() {
    console.log("someone clicked my button");

    latlngs.pop();
    markers.pop();

    popup
        .setLatLng(latlngs[latlngs.length-1])
        .setContent("waypoint removed.")
        .openOn(map);

    drawMap();
}

// Event handler for mouse clicks
map.on('click', onMapClick);



// zoom the map to the polyline when a route is loaded on start-up
//map.fitBounds(polyline.getBounds());
