import 'dart:convert';
import 'package:atypical/elements/drawer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:convert/convert.dart';

class ExplorePage extends StatefulWidget {
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
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<dynamic> receivedList;

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
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
        title: Text('Explore'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> trail) {
    return FlatButton(
      child: ListTile(
        title: Text(
          trail['Name'],
          style: _biggerFont,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget buildText(String s) {
    return Text(s);
  }

  Future<dynamic> _getData() async {
    List<dynamic> values;
    values = await _submit(0);
    values.addAll(await _submit(1));
    return values;
  }

  Future getAllTrails(int offset) async {
    String url =
        'https://atypicaltrailsweb.appspot.com/rest/trails/getAllTrails';

    try {
      response = await dio.post(url, data: {"offset": offset});
    } on DioError catch (e) {
      response = e.response;
    }

    return response;
  }

  Future _submit(int offset) async {
    response = await getAllTrails(offset);
    if (response.statusCode == 200) {
      receivedList = response.data;
      return receivedList;
    }

  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> trailList = snapshot.data;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: trailList.length,
      itemBuilder: (context, i) {

        if (i >= _suggestions.length) {
          if (i < trailList.length) {
            _contents.add(trailList[i]['propertyMap']);
          }
        }
        if (i < trailList.length) {
          return _buildRow(_contents[i]);
        }
        return null;
      },
    );
  }
}

