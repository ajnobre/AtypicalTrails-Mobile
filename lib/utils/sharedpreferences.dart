import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
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

  Future saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
  }

  Future saveStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("strTime", DateTime.now().millisecondsSinceEpoch);
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }
}
