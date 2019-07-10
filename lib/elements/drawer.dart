import 'package:atypical/pages/explore.dart';

import 'package:atypical/pages/logout.dart';
import 'package:atypical/pages/profile.dart';
import 'package:atypical/pages/ranking.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:flutter/material.dart';

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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
