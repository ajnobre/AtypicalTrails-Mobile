import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String token = "";
  getToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      token = prefs.getString("token");
    } catch (e) {
      token = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExplorePage();
    /*
    getToken(context);
    print(token);
    if (token.compareTo("") == 0) {
      return LoginPage();
    } else {
      return ExplorePage();
    }
  }
  */
  }
}
/*
class Home extends StatelessWidget {
  getToken(BuildContext context) async {
    String token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      token = prefs.getString("token");
    } catch (e) {
      token = "";
    }
    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          //  builder: (context) => SignUp(), PAGINA DA SESSAO
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      print(token);
      Navigator.push(
        context,
        MaterialPageRoute(
              builder: (context) => ExplorePage(),
            //sbuilder: (context) => LoginPage(),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getToken(context);
    return new Container();
  }
}
*/
