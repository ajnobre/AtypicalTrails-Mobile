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

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> rankingList = snapshot.data;
    return Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            snap: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            flexibleSpace: new FlexibleSpaceBar(
                background: Image(
              image: AssetImage("images/hiking-buddy.jpg"),
              fit: BoxFit.fill,
            ) /* Image.network(
                'http://hike-anchorage-alaska.com/portals/7/images/hiking-buddy.jpg',
                fit: BoxFit.fill,
              ), */
                ),
          ),
        ],
      ),
    );
  }
}
