import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/finishedTrail.dart';
import 'package:atypical/pages/login.dart';
import 'package:atypical/utils/tokens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
    // getToken(context);
  }

  getToken(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
/*     var token = "";
    Tokens().getToken().then((value) {
      setState(() {
        token = value;
      });
    });
    if (token.compareTo("") == 1) {
      return LoginPage();
    } else
      return ExplorePage();
  } */
    return ExplorePage();
  }
}
