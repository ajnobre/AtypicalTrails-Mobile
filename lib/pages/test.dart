import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Test extends StatelessWidget {
  final Map<String, dynamic> data;

  Test({this.data});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
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
                    'Nome do percurso',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Categoria',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Popularidade',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Criador',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('Avaliação'),
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
              child: StoreMap(markers: _getMarkers()),
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

  Set<Marker> _getMarkers() {
    Set<Marker> set = Set();
    List markerArr = json.decode('[' + data['Path']['value']['value'] + ']');
    for (int i = 0; i < markerArr.length; i++) {
      set.add(new Marker(
        markerId: new MarkerId(
          i.toString(),
        ),
        position: LatLng(markerArr[i]['lat'], markerArr[i]['lng']),
      ));
    }
    return set;
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    key,
    @required this.markers,
  }) : super(key: key);
  final Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target: markers.elementAt(markers.length ~/ 2).position, zoom: 15),
      markers: markers,
    );
  }
}
