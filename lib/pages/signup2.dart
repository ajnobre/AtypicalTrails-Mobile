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
      User user = new User(username, email, password, "", 0);
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

  backgroudRegister() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
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
    return ListView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.6),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ]),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.account_circle),
                      hintText: 'Username'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                margin: EdgeInsets.only(top: 25),
                padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ]),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.email),
                      hintText: 'Email'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                margin: EdgeInsets.only(top: 25),
                padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ]),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Password'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                margin: EdgeInsets.only(top: 25),
                padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ]),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Confirm Password'),
                ),
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
                    height: 50,
                    color: Color(0xFF4CAF50),
                    child: new Text('Register'.toUpperCase(),
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white)),
                    onPressed: () {},
                  ),
                ),
              ),
            ]),
          ),
        ]);
  }
}
