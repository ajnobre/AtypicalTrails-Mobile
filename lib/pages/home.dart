import 'package:atypical/pages/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
  }

  getToken(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
