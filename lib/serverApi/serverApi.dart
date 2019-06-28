import 'package:atypical/requests/requests.dart';
import 'package:dio/dio.dart';

class ServerApi {
  Dio dio = new Dio();
  Response response;
  String url = 'https://androidservertester2.appspot.com/rest/';
  String url2 = 'https://atypicaltrailsweb.appspot.com/rest/';

  Future post(String endpoint, Map<String, dynamic> req) async {
    try {
      response = await dio.post(url2 + endpoint, data: {"offset": 0});
    } on DioError catch (e) {
      response = e.response;
    }
    return response;
  }

  Future loginUser(User user) async {
    return post("login/user", user.toJson());
  }

  Future signUpUser(User user) async {
    return await post("register/v2", user.toJson());
  }

  Future getAllTrails(int offset) async {
    Map<String, dynamic> r = {"offset": offset};
    return await post("trails/getAllTrails", r);
  }
}
