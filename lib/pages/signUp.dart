import 'package:atypical/pages/login.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  Response response;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfController = TextEditingController();

  bool _isInvalidAsyncUser = false;
  bool _isInvalidAsyncEmail = false;

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  Future _submit(String username, String email, String password,
      String passwordConf, BuildContext context) async {
    if (validInfo(username, email, password, passwordConf)) {
      User user = new User(username, email, password, "",0);
      response = await ServerApi().signUpUser(user);
      if (response.statusCode == 200) {
        var alertDialog = AlertDialog(
          title: Text("User successfully registered"),
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog;
            });
        _isInvalidAsyncUser = false;
        _isInvalidAsyncEmail = false;
      } else if (response.statusCode == 403) {
        _isInvalidAsyncUser = true;
      } else if (response.statusCode == 400) {
        _isInvalidAsyncEmail = true;
      }
    }

    setState(() {
      if (_formKey.currentState.validate()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
  }

  bool validInfo(
      String username, String email, String password, String passwordConf) {
    return (!(username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        !isEmail(email) ||
        password.length < 7 ||
        (password.compareTo(passwordConf) != 0) ||
        passwordConf.isEmpty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 40, right: 40),
          child: ListView(
            children: <Widget>[
              Text(
                'Create User',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 380,
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
                        if (_isInvalidAsyncUser) {
                          _isInvalidAsyncUser = false;
                          return "Username already in use.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Email",
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
                          return 'Please enter your email';
                        }
                        if (!isEmail(value)) {
                          return "Please enter a valid email";
                        }
                        if (_isInvalidAsyncEmail) {
                          _isInvalidAsyncEmail = false;
                          return "Email already in use.";
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
                        if (value.length < 8) {
                          return 'Password should be longer than 7 characters';
                        }
                      },
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordConfController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Confirm Password",
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
                          return 'Please confirm your password';
                        }
                        if (passwordController.text.compareTo(value) != 0) {
                          return "Passwords don't match";
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
                          "SignUp",
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
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                          passwordConfController.text,
                          context);

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
                    "Cancel",
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
