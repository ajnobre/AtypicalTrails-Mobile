import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/finishedTrail.dart';
import 'package:atypical/pages/home.dart';
import 'package:atypical/pages/login.dart';
import 'package:atypical/pages/signUp.dart';
import 'package:atypical/pages/trail.dart';
import 'package:atypical/pages/traildescriptor.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atypical Trails',
      routes: {
        "/login/": (_) => new LoginPage(),
        "/signUp/": (_) => new SignUp(),
        "/explore/": (_) => new ExplorePage(),
        "/traildescriptor/": (_) => new TrailDesc(),
        "/trail/": (_) => new MapSample(),
        "/finishedTrail/": (_) => new FinishTrailPage(),
      },
      home: Home(),
    );
  }
}
