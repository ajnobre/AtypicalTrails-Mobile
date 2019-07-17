import 'package:atypical/elements/drawer.dart';
import 'package:atypical/requests/user.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class TrailsDone extends StatefulWidget {
  @override
  _TrailsDoneState createState() => _TrailsDoneState();
}

class _TrailsDoneState extends State<TrailsDone> {
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

    return new Scaffold(
      body: futureBuilder,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Trails Done'),
      ),
    );
  }

  Future _fetchData() async {
    String username = await sharedPrefs.getUsername();
    String tokenID = await sharedPrefs.getToken();
    ServerApi serverApi = new ServerApi();
    User user = new User(username, "", "", tokenID, 0);

    Response response = await serverApi.getTrailsDone(user);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> trailList = snapshot.data;
    if (trailList.isEmpty) {
      return Container(
        child: Center(child: Text("You haven't made any trail yet")),
      );
    } else
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: trailList.length,
        itemBuilder: (context, i) {
          if (i < trailList.length) {
            return _buildRow(trailList[i]['propertyMap']);
          }
          return null;
        },
      );
  }

  Widget _buildRow(Map<String, dynamic> trail) {
    return Wrap(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(color: Colors.amber[600]),
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Trail: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(trail['Name']),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Row(children: <Widget>[
                Text('Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5.0,
                ),
                Text(trail['Feedback'].toString())
              ]),
              SizedBox(
                width: 20,
              ),
              Row(children: <Widget>[
                Text(
                  'Completed in ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(trail['TimeToComplete'].toString() + ' min'),
              ]),
            ],
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
