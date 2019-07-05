import 'package:shared_preferences/shared_preferences.dart';

class Tokens {
  Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("token", token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) {
      return "";
    } else
      return token;
  }
}
