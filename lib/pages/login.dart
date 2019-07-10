import 'dart:async';

import 'package:atypical/pages/explore.dart';
import 'package:atypical/pages/signUp.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/utils/customshapecliper.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:atypical/pages/logout.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();
  SharedPrefs sharedPrefs = new SharedPrefs();
  Logout logout = new Logout();

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
      response = await logout.logout();
      User user = new User(username, "", password, "", 0);
      response = await ServerApi().loginUser(user);

      if (response.statusCode == 200) {
        await sharedPrefs.saveToken(response.data['msg']);
        await sharedPrefs.saveUsername(username);
        await sharedPrefs.saveStartTime();
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
            //AQUI TROCAR ENTRE (BackgroundLogin(), Login()) ou (BackgroundRegister(), Register()
            backgroundLogin(),
            login(),
          ],
        ));
  }

  login() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.6,
                left: 40,
                right: 40,
                bottom: 0),
            /* padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.6), */
          ),
          Container(
/*             height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width, */
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                height: 240,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Username",
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
                      height: 20,
                    ),
                    TextFormField(
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        /* labelText: "Password", */
                        hintText: 'Password',
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

              /*  Container(
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
                    child:
                        /* TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.account_circle),
                          hintText: 'Username'),
                    ), */
                        TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        filled: true,
                        labelText: "Username",
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
                  ), */

              /* Container(
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
                    child:
                        /* TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.vpn_key),
                          hintText: 'Password'),
                    ), */
                        TextFormField(
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        filled: true,
                        /* labelText: "Password", */
                        hintText: 'Password',
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
                  ), */

              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 18.0,
                color: Color(0xFF4CAF50),
                clipBehavior: Clip.antiAlias,
                child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    color: Color(0xFF4CAF50),
                    child: new Text('Login'.toUpperCase(),
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white)),
                    onPressed: () {
                      _submit(usernameController.text, passwordController.text);
                    }),
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
                      color: Colors.white,
                      child: new Text('Create an Account'.toUpperCase(),
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.green)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                    ),
                  )),
            ]),
          ),
        ],
      ),
    );
  }

  backgroundLogin() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
          Expanded(
            child: Container(),
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              WavyFooter(),
            ],
          )
        ],
      ),
    );
  }

/*   @override
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
  } */

}

class HomeScreenTopPart extends StatefulWidget {
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

const List<Color> orangeGradients = [
  Color(0xFF4CAF50),
  Color(0xFF81C784),
];

const List<Color> aquaGradients = [
  Color(0xFF4CAF50),
  Color(0xFF81C784),
];

class WavyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: aquaGradients,
              begin: Alignment.center,
              end: Alignment.bottomRight),
        ),
        height: MediaQuery.of(context).size.height / 4.5,
      ),
    );
  }
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: orangeGradients,
                    begin: Alignment.topLeft,
                    end: Alignment.center),
              ),
            ))
      ],
    );
  }
}
