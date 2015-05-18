var map = L.map( 'map', {
    center: [20.0, 5.0],
    minZoom: 2,
    zoom: 2
});

L.tileLayer( 'http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright" title="OpenStreetMap" target="_blank">OpenStreetMap</a> contributors | Tiles Courtesy of <a href="http://www.mapquest.com/" title="MapQuest" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png" width="16" height="16">',
    subdomains: ['otile1','otile2','otile3','otile4']
}).addTo( map );

var myURL = jQuery( 'script[src$="leaf-demo-index.js"]' ).attr( 'src' ).replace( 'leaf-demo-index.js', '' );

var wayPointIcon = L.icon({
    iconUrl: myURL + 'images/Waypoint.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});

var startIcon = L.icon({
    iconUrl: myURL + 'images/Start.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});

var endIcon = L.icon({
    iconUrl: myURL + 'images/End.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});


var waypointLayer = L.layerGroup();
var marks = Array();

for ( var i=0; i < markers.length; ++i )
{
    var mark = L.marker( [markers[i].lat, markers[i].lng], {icon: wayPointIcon} )
        .bindPopup( '<a href="' + markers[i].url + '" target="_blank">' + markers[i].name + '</a>' )
        .addTo( map );

    marks.push(mark);


}

for(var i = 0; i < marks.length; i++) {



        marks[i].addTo(waypointLayer);

        if (i != 0) {
            // adds all lines to the waypoint layer
            L.polyline([marks[i - 1].getLatLng(), marks[i].getLatLng()], {color: 'red'})
                .addTo(waypointLayer);
        }
    }

waypointLayer.addTo(map)



//function drawMap() {
//    // clear old waypoint layer
//    waypointLayer.clearLayers();
//
//
//    if (markers.length != 0) {
//        markers[0].setIcon(startIcon);
//    }
//
//
//    // adds all makers to waypoint layer
//    for(var i = 0; i < markers.length; i++) {
//
//
//
//        markers[i].addTo(waypointLayer);
//
//        if (i != 0) {
//            // adds all lines to the waypoint layer
//            L.polyline([markers[i - 1].getLatLng(), markers[i].getLatLng()], {color: 'red'})
//                .addTo(waypointLayer);
//        }
//    }
//
//
//
//
//    // draw waypoint layer to map
//    waypointLayer.addTo(map);
//
//}


//// function to be called on mouse click
//function onMapClick(e)
//{
//    console.log("someone clicked my map");
//
//    popup
//        .setLatLng(e.latlng)
//        .setContent("waypoint #"+markers.length.toString())
//        .openOn(map);
//
//
//    var temp = L.marker(e.latlng, {icon: wayPointIcon})
//        .bindPopup("waypoint #"+markers.length.toString());
//
//    temp.title = "waypoint #"+markers.length.toString();
//
//
//
//    //addInputFieldForWaypoint(temp);
//
//    $('#waypoint-form')
//        .append('My waypoint: ' + markers.length.toString() +
//        ':leaf-demo.js> ' +
//        ': <input type="text" value="' + temp.getLatLng().lat  + '" name="lat"/> ' +
//        ': <input type="text" value="' + temp.getLatLng().lng  + '" name="lng"/> ' +
//        ': <input type="text" value="' + temp.title  + '" name="type"/> ' +
//        '<br/>')
//
//    markers.push(temp);
//
//    drawMap();
//
//}
//
//
//function resetOnClick() {
//
//    if (markers.length > 0) {
//        var temp = markers[0].getLatLng();
//
//        //while (latlngs.length > 0) {
//        //    latlngs.pop();
//        //}
//        while (markers.length > 0) {
//            markers.pop();
//        }
//
//        popup
//            .setLatLng(temp)
//            .setContent("route removed.")
//            .openOn(map);
//
//        drawMap();
//    } else {
//        console.log("nothing to reset");
//    }
//}
//
//
//// handle button clicks, button is atm a UNDO button
//function undoOnClick() {
//    console.log("someone clicked my button");
//
//    if (markers.length > 0) {
//        popup
//            .setLatLng(markers[markers.length - 1].getLatLng())
//            .setContent("waypoint removed.")
//            .openOn(map);
//        //latlngs.pop();
//        markers.pop();
//
//        drawMap();
//    } else {
//        console.log("nothing to undo");
//    }
//}
//
//function doneOnClick() {
//
//    //{desc, lat, lng, type}
//
//    var route = Array();
//    var type;
//
//
//    for(var i = 0; i < markers.length; i++) {
//        var waypoint = {};
//
//        if (i == 0) {
//            type = "START";
//            markers[i].title = "Start Location";
//        } else if (i==markers.length-1) {
//            type = "END";
//            markers[i].title = "End Location";
//        } else {
//            type = "WP";
//        }
//        waypoint["lat"] = markers[i].getLatLng().lat;
//        waypoint["lng"] = markers[i].getLatLng().lng;
//        waypoint["desc"] = markers[i].title;
//        waypoint["type"] = type;
//        waypoint["index"] = i;
//
//        route.push(waypoint);
//    }
//
//
//
//    //var geojson = waypointLayer.toGeoJSON();
//    //
//    //waypointLayer.clearLayers();
//    //
//    //L.geoJson(geojson).addTo(map);
//
//    markers[markers.length-1].setIcon(endIcon);
//    drawMap();
//
//    POST(route);
//
//    console.log(JSON.stringify(route));
//}
//
//function POST (route) {
//    var dat = JSON.stringify(route);
//
//    console.log("I am about to POST this: \n\n" + dat);
//
//    $.post( "ajax/test.html", function( dat ) {
//        //$( ".result" ).html( data );
//    });
//
//
//}
//
//
//// Event handler for mouse clicks
//map.on('click', onMapClick);
//
//
//
//// zoom the map to the polyline when a route is loaded on start-up

