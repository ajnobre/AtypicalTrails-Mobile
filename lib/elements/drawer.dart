import 'dart:io';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/profile.dart';
import 'package:atypical/pages/ranking.dart';
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
              onPressed: () => setToken(context).then((onValue) {
                    return pop();
                  }),
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

  Future setToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");
  }
}
