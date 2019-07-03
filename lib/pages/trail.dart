/* import 'dart:async';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/utils/points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class MapTrail extends StatefulWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  MapTrail({this.markers, this.polylines});
  @override
  _MapTrailState createState() => _MapTrailState();
}

class _MapTrailState extends State<MapTrail> {
  Completer<GoogleMapController> _controller = Completer();
  double _sliderValue = 12.0;
  static double zoomCons = 30.0;
  MapType _currentMapType = MapType.normal;

  /* GoogleMapController _mapController; */

  static LocationData currentLocation;
  static LatLng startPosition, finishPostion;
  var startTime, finishTime;
  var location = new Location();
  void initState() {
    super.initState();

    _getLocationRequest();
    startPosition = widget.markers.elementAt(0).position;
    finishPostion =
        widget.markers.elementAt(widget.markers.length - 1).position;
    startTime = new DateTime.now();
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.green,
      child: Icon(icon, size: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(target: startPosition),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraIdle: _animateToUser2,
            markers: widget.markers,
            polylines: widget.polylines,
          ),
          Positioned(
            bottom: 50,
            left: 10,
            child: Slider(
              min: 12,
              max: 19,
              divisions: 4,
              onChanged: (newRating) {
                setState(() => _sliderValue = newRating);
              },
              value: _sliderValue,
            ),
          ),
          Positioned(
              bottom: 45,
              right: 10,
              child: Container(
                width: 130,
                height: 53.0,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  label: Text('Finish'),
                  onPressed: finishButtonHandler(),
                ),
              )),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[button(onMapTypeButtonPressed, Icons.map)],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _getLocationRequest() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }
      currentLocation = null;
    }
  }

  void _animateToUser2() {
    GoogleMapController controller;
    _controller.future.then((recControler) {
      controller = recControler;
    });
    var pos;
    location.getLocation().then((recLocation) {
      pos = recLocation;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: zoomCons - _sliderValue)));
    });
  }

  void onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  finishButtonHandler() {
    location.getLocation().then((curLoc) {
      setState(() {
        currentLocation = curLoc;
      });
    });
    var dist = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        finishPostion.latitude,
        finishPostion.longitude);
    if (dist < 0.025) {
      _showDialogQuit(context);
    } else {
      finishTime = new DateTime.now();
      _showDialogSuccess(context);
    }
  }

  void _showDialogQuit(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Not there yet"),
          content: new Text(
              "You haven't reached the finish point, are you sure you want to give up?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplorePage(),
                  ),
                );
              },
            ),
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

  void _showDialogSuccess(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Well done"),
          content: new Text("You have reached your destination."),
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
}
 */

import 'dart:async';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/utils/points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class MapSample extends StatefulWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  MapSample({this.markers, this.polylines});
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  double _sliderValue = 12.0;
  static double zoomCons = 30.0;
  MapType _currentMapType = MapType.normal;

  /* GoogleMapController _mapController; */

  static LocationData currentLocation;
  static LatLng startPosition, finishPosition;
  var startTime, finishTime;
  var location = new Location();
  void initState() {
    super.initState();

    _getLocationRequest();
    startPosition = widget.markers.elementAt(0).position;
    finishPosition =
        widget.markers.elementAt(widget.markers.length - 1).position;
    startTime = new DateTime.now();
  }

  Future _getLocationRequest() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }
      currentLocation = null;
    }
  }

  void _animateToUser2() {
    GoogleMapController controller;
    _controller.future.then((recControler) {
      controller = recControler;
    });
    var pos;
    location.getLocation().then((recLocation) {
      pos = recLocation;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: zoomCons - _sliderValue)));
    });
  }

  static final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(startPosition.latitude, startPosition.longitude),
    zoom: 17,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onCameraIdle: _animateToUser2,
            markers: widget.markers,
            polylines: widget.polylines,
          ),
          Positioned(
            bottom: 50,
            left: 10,
            child: Slider(
              min: 12,
              max: 19,
              divisions: 4,
              onChanged: changeValue,
              value: _sliderValue,
            ),
          ),
          Positioned(
              bottom: 45,
              right: 10,
              child: Container(
                width: 130,
                height: 53.0,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  label: Text('Finish'),
                  onPressed: _goToTheLake,
                ),
              )),
        ],
      ),
/*       floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ), */
    );
  }

  Future<void> _goToTheLake() async {
    var dist = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        finishPosition.latitude,
        finishPosition.longitude);
    if (dist < 0.025) {
      _showDialogSuccess(context);
    } else {
      finishTime = new DateTime.now();

      _showDialogQuit(context);
    }
  }

  void onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  void _showDialogQuit(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Not there yet"),
          content: new Text(
              "You haven't reached the finish point, are you sure you want to give up?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplorePage(),
                  ),
                );
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogSuccess(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Well done"),
          content: new Text("You have reached your destination."),
          actions: <Widget>[
            //FinishedTrailPage
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

  Future<void> changeValue(double value) async {
    setState(() => _sliderValue = value);
  }
}
