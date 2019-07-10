import 'dart:async';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/finishedTrail.dart';
import 'package:atypical/utils/points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class MapSample extends StatefulWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final String trailKey;
  final String username;
  MapSample({this.markers, this.polylines, this.trailKey, this.username});
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
  var startTime = new DateTime.now().millisecondsSinceEpoch;
  var location = new Location();
  var dist;
  void initState() {
    super.initState();

    _getLocationRequest();
    startPosition = widget.markers.elementAt(0).position;
    finishPosition =
        widget.markers.elementAt(widget.markers.length - 1).position;
  }

  Future _getLocationRequest() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: new Scaffold(
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

      ),
    );
  }

  Future<void> _goToTheLake() async {
    dist = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        finishPosition.latitude,
        finishPosition.longitude);
    location.getLocation().then((recLoc) {
      setState(() {
        currentLocation = recLoc;
      });
    });
    if (dist < 0.035) {
      _showDialogSuccess(context);
    } else {
      _showDialogQuit(context, dist);
    }
  }

  void onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  void _showDialogQuit(context, dist) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Not there yet"),
          content: new Text("You are " +
              (dist * 1000).round().toString() +
              " meters away from the finish point, are you sure you want to give up?"),
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

        return AlertDialog(
          title: new Text("Well done"),
          content: new Text("You have reached your destination."),
          actions: <Widget>[


            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinishTrailPage(
                              time: getTime(),
                              trailKey: widget.trailKey,

                            )));

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

  int getTime() {
    var finishTime = DateTime.now().millisecondsSinceEpoch;
    var subtract = finishTime - startTime;
    var time = subtract ~/ 60000;
    return time;
  }
}
