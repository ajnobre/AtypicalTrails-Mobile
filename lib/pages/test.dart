import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Test extends StatelessWidget {
  final Map<String, dynamic> data;

  Test({this.data});

  @override
  Widget build(BuildContext context) {
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
                    data['Name'],
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
                  data['NumPeople'].toString() + ' people did this trail.',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Created by ' + data['Creator'],
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
                    Text(data['Rating'].toString()),
                  ],
                ),
                Text(
                  'Difficulty: ' + data['Level'].toString(),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Distance: ' + data['Distance'].toString() + ' meters',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Expected Time: ' + data['DMinutes'].toString() + ' minutes',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Advices: ' + data['Advices'],
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
          _buildButtonColumn(color, Icons.send, 'START'),
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
        /*         appBar: AppBar(
                          title: Text('Flutter layout demo'),
                        ), */
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: StoreMap(points: _getMarkers()),
            ),

            /*             Image.asset(
                              'images/mountain.jpeg',
                              width: 300,
                              height: 240,
                              fit: BoxFit.cover,
                            ), */
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
            /*             titleSection,
                            buttonSection,
                            textSection, */
          ],
        ),
      ),
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
    List markerArr = json.decode('[' + data['Path']['value']['value'] + ']');
    markersSet.add(_createMarker(0, markerArr, BitmapDescriptor.hueGreen));
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
        color: Colors.red,
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
    List categories = json.decode(data['Category']);
    String res = categories[0];
    for (int i = 1; i < categories.length - 1; i++) {
      res += ', ' + categories[1].toString();
    }

    return res;
  }
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
