import 'dart:async';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/signUp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login.g.dart';

@JsonSerializable()
class User {
  User(this.username, this.password);

  String username;
  String password;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  Dio dio = new Dio();
  Response response;
  bool _isInvalidAsyncPass = false;

  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future _submit(String username, String password) async {
    if (!(username.isEmpty || password.isEmpty)) {
      User user = new User(username, password);
      response = await loginUser(user);
      if (response.statusCode == 200) {
        saveToken(response.data['msg']);

        _isInvalidAsyncPass = false;
      } else if (response.statusCode == 403) {
        _isInvalidAsyncPass = true;
      }
    }

    setState(() {
      if (_formKey.currentState.validate()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExplorePage()
              // builder: (context) => HomePage(),
              ),
        );
      }
    });
  }

  saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString("token");
  }

  Future loginUser(User user) async {
    String url = 'https://atypicaltrailsweb.appspot.com/rest/login/user';

    try {
      response = await dio.post(url, data: user.toJson());
    } on DioError catch (e) {
      response = e.response;
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.green[200],
        body: Form(
          key: _formKey,
          //padding: EdgeInsets.only(top: 100, left: 40, right: 40),
          //color: Colors.green[200],
          child: Padding(
            padding: EdgeInsets.only(top: 100, left: 40, right: 40),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 148,
                  height: 148,
                  child: Image.asset("images/applogo.png"),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Username",
                          labelStyle: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(13.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        style: TextStyle(fontSize: 15),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autofocus: true,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(13.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (_isInvalidAsyncPass) {
                            // disable message until after next async call
                            _isInvalidAsyncPass = false;
                            return 'Incorrect username or password';
                          }
                        },
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1],
                      colors: [
                        Color(0xAAFE5F55),
                        Color(0xAAFFF847),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      onPressed: () {
                        _submit(
                            usernameController.text, passwordController.text);

                        /*
                        loginUser(username, password);
                        setState(() {
                          if (_formKey.currentState.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  // builder: (context) => HomePage(),
                                  ),
                            );
                          }
                        });*/
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: FlatButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
