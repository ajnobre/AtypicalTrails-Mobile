import 'package:atypical/elements/drawer.dart';
import 'package:atypical/pages/traildescriptor.dart';

import 'package:atypical/serverApi/serverApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class ExplorePage extends StatefulWidget {
  final String username;
  ExplorePage({this.username});
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ExploreContent());
  }
}

class ExploreContent extends StatefulWidget {
  @override
  _ExploreContentState createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {
  Dio dio = new Dio();
  Response response;
  final _suggestions = <Text>[];
  final _contents = <Map<String, dynamic>>[];
  List<dynamic> receivedList;
  ServerApi serverApi = new ServerApi();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: new Scaffold(
        body: pagewise(context),
        drawer: NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Explore'),
          actions: <Widget>[],
        ),
      ),
    );
  }

  Widget _itemBuilder(context, dynamic entry, _) {
    Map<String, dynamic> map = entry['propertyMap'];
    return FlatButton(
      padding: EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: new BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                      image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.amber.withOpacity(0.16),
                              BlendMode.srcATop),
                          image: imageBuilder(map['Photo']),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                          height: 30.0,
                          child: SingleChildScrollView(
                              child: Text(map['Name'],
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold))))),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    map['Description'],
                    /* style: TextStyle(fontWeight: FontWeight.bold), */
                  ),
                ),
                SizedBox(height: 8.0)
              ])),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TrailDesc(data: map)));
      },
    );
  }

  static const int PAGE_SIZE = 12;
  Widget pagewise(BuildContext context) {
    return PagewiseGridView.count(
      pageSize: PAGE_SIZE,
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 0.0,
      childAspectRatio: 0.555,
      padding: EdgeInsets.all(0.0),
      itemBuilder: this._itemBuilder,
      pageFuture: (pageIndex) => _fetchData(pageIndex * PAGE_SIZE),
    );
  }

  Future<Response> getData(int offset) async {
    ServerApi serverApi = new ServerApi();
    return await serverApi.getAllTrails(offset);
  }

  Future<List> _fetchData(int offset) async {
    Response response = await getData(offset);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Widget createGridView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> trailList = snapshot.data;
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 0.85),
      itemCount: trailList.length,
      itemBuilder: (context, i) {
        if (i >= _suggestions.length) {
          if (i < trailList.length) {
            _contents.add(trailList[i]['propertyMap']);
          }
        }
        if (i < trailList.length) {
          return _buildButton(_contents[i]);
        }
        return null;
      },
    );
  }

  Widget _buildButton(Map<String, dynamic> trail) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Stack(
        children: <Widget>[
          imageBuilder(trail['Photo']),
          ListTile(
            title: Text(
              trail['Name'],
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TrailDesc(data: trail)));
      },
    );
  }

  imageBuilder(String url) {
    ImageProvider<dynamic> image = AssetImage('images/trailStock.png');
    if (url != null) {
      image = NetworkImage(url);
    }
    return image;
  }
}
