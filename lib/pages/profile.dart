import 'package:atypical/elements/drawer.dart';
import 'package:atypical/pages/trailsdone.dart';

import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProfileContent());
  }
}

class ProfileContent extends StatefulWidget {
  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  Dio dio = new Dio();
  Response response;

  Map<String, dynamic> receivedList;
  ServerApi serverApi = new ServerApi();
  SharedPrefs sharedPrefs = new SharedPrefs();

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
/*     return WillPopScope(
      onWillPop: () async {
        return false;
      }, */
    return new Scaffold(
      body: futureBuilder,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Profile'),
      ),
    );
  }

  Future _fetchData() async {
    String username = await sharedPrefs.getUsername();
    String tokenID = await sharedPrefs.getToken();
    ServerApi serverApi = new ServerApi();
    User user = new User(username, "", "", tokenID, 0);

    Response response = await serverApi.getUserInfo(user);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    Map<String, dynamic> receivedMap = snapshot.data['propertyMap'];
    return Scaffold(
      appBar: CustomAppBar(
        receivedMap: receivedMap,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name", style: _style()),
            SizedBox(
              height: 4,
            ),
            Text(buildText(receivedMap['Name'])),
            SizedBox(
              height: 16,
            ),
            Text(
              "Mobile",
              style: _style(),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              buildText(receivedMap['Mobile']),
              style: _style2(),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Email",
              style: _style(),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              buildText(receivedMap['Email']),
              style: _style2(),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Address",
              style: _style(),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              buildText(receivedMap['Address']),
              style: _style2(),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }

  TextStyle _style() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0);
  }

  TextStyle _style2() {
    return TextStyle(fontSize: 16.0);
  }

  String buildText(data) {
    if (data == null) {
      return 'undefined';
    } else {
      return data;
    }
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Map<String, dynamic> receivedMap;
  CustomAppBar({this.receivedMap});
  @override
  Size get preferredSize => Size(double.infinity, 300);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: SafeArea(
        child: Container(
            padding: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: Color(0xFF4CAF50), boxShadow: [
              BoxShadow(
                color: Colors.black54, //black45
                blurRadius: 15, //10
              )
            ]),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          print("//TODO: button clicked");
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround, //moises na vertical dos principis
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      getImage(receivedMap['Photo'])))),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          receivedMap['Username'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  "Executed Trails",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  buildInt(receivedMap['numTrailsDone'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                )
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: <Widget>[
                                Text(
                                  "Total Hours",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(getTime(receivedMap['TotalTime']),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  "Points",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  receivedMap['Points'].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              ],
                            ),
                            SizedBox(width: 32),
                            Column(
                              children: <Widget>[
                                Text(
                                  "Created Trails",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  receivedMap['numTrails'].toString(),
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrailsDone(),
                                  ),
                                );
                              },
                              child: Text(
                                "Trails Done",
                              ),
                            )
                          ],
                        ),
                        //SizedBox(width: 16,)
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  String getImage(receivedMap) {
    if (receivedMap == null) {
      return "https://lh3.googleusercontent.com/6cFAhsyW9uDLFHFM-zLc2mqtOQp-bS42ywO3CWq9-V-3760Fwju-J3HCoe7vXbxSLQjj56U9ZVQfcRohKVtDxrMAszwZJw";
    } else {
      return receivedMap;
    }
  }

  String getTime(receivedMap) {
    int hours, minutes;
    if (receivedMap == null) {
      hours = 0;
      minutes = 0;
    } else {
      hours = receivedMap ~/ 60;
      minutes = receivedMap % 60;
    }

    return '$hours:$minutes';
  }

  int buildInt(receivedMap) {
    if (receivedMap == null) {
      return 0;
    } else
      return receivedMap;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height - 10); //left

    var firstEndPoint = Offset(size.width * .5, size.height - 30);
    var firstControlPoint = Offset(size.width * .25, size.height - 50);
    p.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 65); //right
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    p.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
//TotalTime , numTrailsDone
    p.lineTo(size.width, 0);
    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
