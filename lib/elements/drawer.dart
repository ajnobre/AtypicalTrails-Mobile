import 'dart:io';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/login.dart';
import 'package:atypical/pages/profile.dart';
import 'package:atypical/pages/ranking.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            title: Text('Explore'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExplorePage(),
                ),
              );
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Rankings'),
            onTap: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyRankingPage(),
                ),
              );

              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('LogOut'),
            onTap: () {
              _showDialogLogOut(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDialogLogOut(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Loging Out"),
          content: new Text("Are you sure you want to log out?"),
          actions: <Widget>[
            //FinishedTrailPage
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                logoutHandler().then((onValue) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                });
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

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  Future setToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");
  }

  Future<int> getStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("strTime");
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<Response> logout() async {
    ServerApi serverApi = new ServerApi();
    Response response;
    int startTime = await getStartTime();
    String token = await getToken();

    int time = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 60000;
    User user = new User("", "", "", token, time);
    response = await serverApi.logout(user);
    return response;
  }

  Future logoutHandler() async {
    Response response;

    response = await logout();
    if (response.statusCode == 200) {
      setToken();
      return true;
    }
  }
}
