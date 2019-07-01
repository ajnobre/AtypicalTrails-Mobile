import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:atypical/pages/explore.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:atypical/utils/points.dart';

class Trail extends StatefulWidget {
  final Map<String, dynamic> data;
  Trail({this.data});
  @override
  _TrailState createState() => _TrailState();
}

class _TrailState extends State<Trail> {
  static LocationData currentLocation;

  var location = new Location();
  LatLng startPosition;
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: getLocation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createPage(context, snapshot);
        }
      },
    );
    return new Scaffold(
      body: futureBuilder,
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  List _getMarkers() {
    Set<Marker> markersSet = Set();
    Set<Polyline> polylineSet = Set();
    List markerArr =
        json.decode('[' + widget.data['Path']['value']['value'] + ']');
    markersSet.add(_createMarker(0, markerArr, BitmapDescriptor.hueGreen));
    startPosition = LatLng(markerArr[0]['lat'], markerArr[0]['lng']);
    markersSet.add(_createMarker(
        markerArr.length - 1, markerArr, BitmapDescriptor.hueRed));
    for (int i = 0; i < markerArr.length - 1; i++) {
      polylineSet.add(_createPolyline(i, markerArr));
    }
    return [markersSet, polylineSet];
  }

  Polyline _createPolyline(int i, List markerArr) {
    return new Polyline(
        polylineId: new PolylineId(i.toString()),
        color: Colors.red[600],
        points: [
          LatLng(markerArr[i]['lat'], markerArr[i]['lng']),
          LatLng(markerArr[i + 1]['lat'], markerArr[i + 1]['lng'])
        ]);
  }

  Marker _createMarker(int i, List markerArr, double hue) {
    return new Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      markerId: new MarkerId(
        i.toString(),
      ),
      position: LatLng(markerArr[i]['lat'], markerArr[i]['lng']),
    );
  }

  String _getCategory() {
    List categories = json.decode(widget.data['Category']);
    String res = categories[0];
    for (int i = 1; i < categories.length - 1; i++) {
      res += ', ' + categories[1].toString();
    }

    return res;
  }

  void startButtonHandler() {
    location.getLocation().then((curLoc) {
      setState(() {
        currentLocation = curLoc;
      });
      var dist = calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          startPosition.latitude,
          startPosition.longitude);
      if (dist < 0.05) {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExplorePage(),
          ),
        );
      } else {
        _showDialog(context);
      }
    });
  }

  Future getLocation() async {
    location.hasPermission().then((hasPer) {
      if (!hasPer) {
        location.requestPermission().then((reqPer) {
          if (reqPer) {
            _getLocationRequest();
          }
        });
      }
      _getLocationRequest();
    });
  }

  Future _getLocationRequest() async {
    var curLoc;
    try {
      curLoc = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }
      curLoc = null;
    }
    return curLoc;
  }

  Widget createPage(BuildContext context, AsyncSnapshot snapshot) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.data['Name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _getCategory(),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  widget.data['NumPeople'].toString() +
                      ' people did this trail.',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Created by ' + widget.data['Creator'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.red[500],
                    ),
                    Text(widget.data['Rating'].toString()),
                  ],
                ),
                Text(
                  'Difficulty: ' + widget.data['Level'].toString(),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Distance: ' + widget.data['Distance'].toString() + ' meters',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Expected Time: ' +
                      widget.data['DMinutes'].toString() +
                      ' minutes',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Advices: ' + widget.data['Advices'],
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton(
            child: _buildButtonColumn(color, Icons.send, 'START'),
            onPressed: startButtonHandler,
          ),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'COMENTÁRIOS',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: StoreMap(points: _getMarkers()),
            ),
            Flexible(
              child: ListView(
                children: <Widget>[
                  titleSection,
                  buttonSection,
                  textSection,
                ],
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}

void _showDialog(context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Can't initialize trail"),
        content: new Text("You are too far away from the starting point."),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    key,
    @required this.points,
  }) : super(key: key);
  final List points;

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = points[0];
    Set<Polyline> polylines = points[1];
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: markers.elementAt(0).position, zoom: 13),
      markers: markers,
      polylines: polylines,
    );
  }
}
