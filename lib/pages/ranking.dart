import 'package:atypical/elements/drawer.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class MyRankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<MyRankingPage> {
  List<dynamic> receivedList;
  SharedPrefs sharedPrefs = new SharedPrefs();
  String username = "";

  @override
  Widget build(BuildContext context) {
/*     var futureBuilder = new FutureBuilder(
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
    ); */
    return /* WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: */
        new Scaffold(
      body: pagewise(context),
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Ranking'),
      ),
    );
/*     ); */
  }

  static const int PAGE_SIZE = 12;

  Widget pagewise(BuildContext context) {
    return PagewiseListView(
        pageSize: PAGE_SIZE,
        itemBuilder: this._buildRow,
        pageFuture: (pageIndex) => _fetchData(pageIndex * PAGE_SIZE));
  }

  Widget _itemBuilder(context, dynamic entry, _) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.brown[200],
          ),
          title: Text("cena"),
          subtitle: Text("cena"),
        ),
        Divider()
      ],
    );
  }

  Future<Response> getData(int offset) async {
    ServerApi serverApi = new ServerApi();
    return await serverApi.getRanking(offset);
  }

  Future<List> _fetchData(int offset) async {
    Response response = await getData(offset);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Widget _buildRow(context, dynamic entry, _) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
/* s */
              SizedBox(
                width: 10.0,
                height: 2.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: getImage(entry),
              ),
              SizedBox(
                width: 10.0,
                height: 2.0,
              ),
              Text(entry['name']),
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
            Text(entry['points'].toString())
          ]),
        ],
      ),
      onPressed: () {},
      /* color: getColor(user['name']), */
    );
  }
/* 
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> rankingList = snapshot.data;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: rankingList.length,
      itemBuilder: (context, i) {
        if (i < rankingList.length) {
          return _buildRow(rankingList[i], i);
        }
        return null;
      },
    );
  } */

  Future<String> getUsername() async {
    if (username == "") {
      String usr = await sharedPrefs.getUsername();
      setState(() {
        username = usr;
      });
    }
    return username;
  }

  ImageProvider getImage(Map<String, dynamic> trail) {
    if (trail['photo'] != null) {
      return NetworkImage(trail['photo']);
    } else {
      return AssetImage('images/trailStock.png');
    }
  }

  getColor(String username) {
    Color color = Colors.white10;
    getUsername().then((usr) {
      if (username == usr) {
        color = Colors.amber[200];
      }
    });
    return color;
  }
}
