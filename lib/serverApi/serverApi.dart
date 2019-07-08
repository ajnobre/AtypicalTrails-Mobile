import 'package:atypical/requests/trail.dart';
import 'package:atypical/requests/user.dart';
import 'package:dio/dio.dart';

class ServerApi {
  Dio dio = new Dio();
  Response response;
  String url = 'https://androidservertester2.appspot.com/rest/';
  String url2 = 'https://atypicaltrailsweb.appspot.com/rest/';

  Future post(String endpoint, Map<String, dynamic> req) async {
    try {
      response = await dio.post(url2 + endpoint, data: req);
    } on DioError catch (e) {
      response = e.response;
    }
    return response;
  }

  Future loginUser(User user) async {
    return post("login/user", user.toJson());
  }

  Future getUserInfo(User user) async {
    return post("login/getInfo", user.toJson());
  }

  Future signUpUser(User user) async {
    return await post("register/android", user.toJson());
  }

  Future getAllTrails(int offset) async {
    Map<String, dynamic> r = {"offset": offset};
    return await post("trails/getAllTrails", r);
  }

  Future addToFinished(Trail trail) async {
    return await post("user/addToFinished", trail.toJson());
  }

  Future getRanking(int offset) async {
    Map<String, dynamic> r = {"offset": offset};
    return await post("user/getRanking", r);
  }

  Future<Response> logout(User user) async {
    return await post("login/logout", user.toJson());
  }
}
