import 'package:atypical/elements/drawer.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyRankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<MyRankingPage> {
  List<dynamic> receivedList;
  final _biggerFont = const TextStyle(fontSize: 18.0);
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: new Scaffold(
        body: futureBuilder,
        drawer: NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Ranking'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Future<Response> getData(int offset) async {
    ServerApi serverApi = new ServerApi();
    return await serverApi.getRanking(0);
  }

  Future _fetchData() async {
    Response response = await getData(0);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Widget _buildRow(Map<String, dynamic> trail) {
    return FlatButton(
      child: Row(
        children: /* <Widget>[
          Text(
            trail['name'],
            style: _biggerFont,
          ),
          Text(
            trail['points'].toString(),
            style: _biggerFont,
          ),
        ], */
            <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: getImage(trail),
              ),
              SizedBox(
                width: 10.0,
                height: 2.0,
              ),
              Text(trail['name']),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Row(children: <Widget>[
            Text('Points'),
            SizedBox(
              width: 5.0,
            ),
            Text(trail['points'].toString())
          ]),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> rankingList = snapshot.data;
    final _contents = <Map<String, dynamic>>[];
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: rankingList.length,
      itemBuilder: (context, i) {
        /*         if (i < rankingList.length) {
                          _contents.add(rankingList[i]);
                        } */

        if (i < rankingList.length) {
          return _buildRow(rankingList[i]);
        }
        return null;
      },
    );
  }

  ImageProvider getImage(Map<String, dynamic> trail) {
    if (trail['photo'] != null) {
      return NetworkImage(trail['photo']);
    } else {
      return AssetImage('images/applogo.png');
    }
  }
  
}
