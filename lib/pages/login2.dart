import 'dart:async';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/signUp.dart';
import 'package:atypical/requests/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atypical/serverApi/serverApi.dart';

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
      User user = new User(username, "", password, "", 0);
      response = await ServerApi().loginUser(user);
      if (response.statusCode == 200) {
        await saveToken(response.data['msg']);
        await saveUsername(username);
        await saveStartTime();
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

  Future saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
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
            padding: EdgeInsets.only(top: 120, left: 40, right: 40),
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
                  height: 220,
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

  Future saveStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("strTime", DateTime.now().millisecondsSinceEpoch);
  }
}
