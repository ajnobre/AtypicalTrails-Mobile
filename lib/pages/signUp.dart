import 'package:atypical/pages/login.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:flutter/material.dart';
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
      User user = new User(username, email, password, "", 0);
      response = await ServerApi().signUpUser(user);
      if (response.statusCode == 200) {
        _isInvalidAsyncUser = false;
        _isInvalidAsyncEmail = false;
      } else if (response.statusCode == 403) {
        _isInvalidAsyncEmail = true;
      } else if (response.statusCode == 400) {
        _isInvalidAsyncUser = true;
      }
    }

    setState(() {
      if (_formKey.currentState.validate()) {
        _showDialog(context);
      }
    });
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("User registered successfully"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  _body() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            backgroudRegister(),
            register(),
          ],
        ));
  }

  backgroudRegister() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset(
                'images/applogo.png',
                width: MediaQuery.of(context).size.width / 2.4,
              ),
              HomeScreenTopPart(),
            ],
          ),
        ],
      ),
    );
  }

  register() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
                left: 40,
                right: 40,
                bottom: 0),
          ),
          Container(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                height: MediaQuery.of(context).size.height,
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
                      height: 20,
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
                      height: 20,
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
                      },
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
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
                        if (value.length < 8) {
                          return 'Password should be longer than 7 characters';
                        }
                      },
                      style: TextStyle(fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 18.0,
                        color: Color(0xFF4CAF50),
                        clipBehavior: Clip.antiAlias,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 1.5,
                          height: 40,
                          color: Color(0xFF4CAF50),
                          child: new Text('Register'.toUpperCase(),
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: () {
                            _submit(
                                usernameController.text,
                                emailController.text,
                                passwordController.text,
                                passwordConfController.text,
                                context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
