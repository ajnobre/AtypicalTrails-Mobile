import 'package:atypical/pages/login.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Logout {
  SharedPrefs sharedPrefs = new SharedPrefs();

  Future<Response> logout() async {
    ServerApi serverApi = new ServerApi();
    Response response;
    int startTime = await sharedPrefs.getStartTime();
    String token = await sharedPrefs.getToken();

    int time = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 600000;
    User user = new User("", "", "", token, time);
    response = await serverApi.logout(user);
    return response;
  }

  Future logoutHandler() async {
    Response response;

    response = await logout();
    if (response.statusCode == 200) {
      sharedPrefs.setToken();
      return true;
    }
  }

  void showDialogLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Loging Out"),
          content: new Text("Are you sure you want to log out?"),
          actions: <Widget>[
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
}
