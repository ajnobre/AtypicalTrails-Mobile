import 'dart:io';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/login.dart';
import 'package:atypical/pages/logout.dart';
import 'package:atypical/pages/profile.dart';
import 'package:atypical/pages/ranking.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatelessWidget {
  SharedPrefs sharedPrefs = new SharedPrefs();
  Logout logout = new Logout();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
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
              logout.showDialogLogOut(context);
            },
          ),
        ],
      ),
    );
  }



}
