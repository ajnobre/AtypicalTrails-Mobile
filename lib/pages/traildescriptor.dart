import 'dart:async';

import 'dart:convert';

import 'package:atypical/pages/trail.dart';
import 'package:atypical/serverApi/serverApi.dart';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:atypical/utils/points.dart';

import 'comments.dart';

class TrailDesc extends StatefulWidget {
  final Map<String, dynamic> data;
  final String username;
  TrailDesc({this.data, this.username});
  @override
  _TrailDescState createState() => _TrailDescState();
}

class _TrailDescState extends State<TrailDesc> {
  static LocationData currentLocation;
  Set<Marker> markers;
  Set<Polyline> polylines;
  var location = new Location();
  LatLng startPosition;
  LatLng finishPosition;
  ServerApi serverApi = new ServerApi();
  List<dynamic> comments;

/*   void initState() async {
    super.initState();
    Response response =
        await serverApi.getTrailComments(0, widget.data['CodeName']);
    setState(() {
      comments = response.data;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: createPage(context),
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
    finishPosition = LatLng(markerArr[markerArr.length - 1]['lat'],
        markerArr[markerArr.length - 1]['lng']);

    for (int i = 0; i < markerArr.length - 1; i++) {
      polylineSet.add(_createPolyline(i, markerArr));
    }

    setState(() {
      markers = markersSet;
      polylines = polylineSet;
    });
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
    for (int i = 1; i < categories.length; i++) {
      res += ', ' + categories[1].toString();
    }

    return res;
  }

  Future<void> startButtonHandler() async {
    location.getLocation().then((curLoc) {
      setState(() {
        currentLocation = curLoc;
      });
      var dist = calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          startPosition.latitude,
          startPosition.longitude);
      if (dist < 0.035) {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapSample(
              trailKey: widget.data['CodeName'],
              markers: markers,
              polylines: polylines,
            ),
          ),
        );
      } else {
        _showDialog(context, dist);
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
      curLoc = null;
    }
    return curLoc;
  }

  Widget createPage(BuildContext context) {
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
                      color: Colors.amber[500],
                    ),
                    Text(widget.data['Rating'].toString()),
                  ],
                ),
                Text(
                  'Difficulty: ' +
                      getDifficulty(widget.data['Level'].toString()),
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
          SizedBox(
            width: 5,
          ),
          FlatButton(
            child: _buildButtonColumn(color, Icons.comment, 'COMMENTS'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentsPage(
                    trailKey: widget.data['CodeName'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      /*       child: Text(
                          "COMEMTARIOS",
                          softWrap: true,
                        ), */
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
              flex: 3,
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

  String getDifficulty(String difficulty) {
    switch (difficulty) {
      case "1":
        return 'Easy';
        break;
      case "2":
        return 'Medium';
        break;
      case "3":
        return 'Hard';
        break;
      case "4":
        return 'Chuck Norris';
        break;
      default:
        return 'error';
    }
  }
}

void _showDialog(context, double dist) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Can't start trail"),
        content: new Text("You are " +
            (dist * 1000).round().toString() +
            " meters away from the starting point."),
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
      myLocationEnabled: true,
      initialCameraPosition:
          CameraPosition(target: markers.elementAt(0).position, zoom: 17),
      markers: markers,
      polylines: polylines,
    );
  }
}
