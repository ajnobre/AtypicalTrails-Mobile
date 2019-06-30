import 'package:flutter/material.dart';

class TrailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  TrailPage({this.data});

  @override
  _TrailPageState createState() => _TrailPageState();
}

class _TrailPageState extends State<TrailPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Container();
  }
  
}
