/* import 'package:flutter/material.dart';
import 'package:myapp/CustomShapeClipper.dart';

void main() => runApp(MaterialApp(
      title: "Atypical Trails",
      home: MyApp(),
    ));

Color firstColor = Color(0x64B768);
Color secondColor = Color(0x356237);

//APP
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//TUDOAQUI
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }
}

_body() {
  return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          //AQUI TROCAR ENTRE (BackgroundLogin(), Login()) ou (BackgroundRegister(), Register()
          BackgroundLogin(),
          Login(),
        ],
      ));
}

//BACKGROUND LOGIN
class BackgroundLogin extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
}

//BACKGROUND REGISTER
class BackgroundRegister extends StatelessWidget {
  Widget build(BuildContext context) {
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
}

//REGISTER
class Register extends StatelessWidget {
  Widget build(BuildContext context) {
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

//LOGIN
class Login extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.6),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 50,
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
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
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password'),
              ),
            ),
            FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16, right: 70, bottom: 20),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ))),
            ),
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
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () {},
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
                    color: Colors.white,
                    child: new Text('Create an Account'.toUpperCase(),
                        style:
                            new TextStyle(fontSize: 14.0, color: Colors.green)),
                    onPressed: () {},
                  ),
                )),
          ]),
        ),
      ],
    );
  }
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
} */






