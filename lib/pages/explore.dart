import 'dart:convert';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        backgroundColor: Colors.green,
      ),
      body: MainContent(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('Explore'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Favorites'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Rankings'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            )
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  Dio dio = new Dio();
  Response response;
  List<dynamic> list;
  Future getAllTrails() async {
    String url =
        'https://atypicaltrailsweb.appspot.com/rest/trails/getAllTrails';
    try {
      response = await dio.post(url, data: {"offset": 0});
    } on DioError catch (e) {
      response = e.response;
    }

    return response;
  }

  Future _submit() async {
    response = await getAllTrails();
    if (response.statusCode == 200) {
      list = response.data;
      print(list[1]['key']);
    }
    print(response.statusCode);
  }

  FlatButton buildButtons() {
    for (int i = 0; i < 12; i++) {
      return new FlatButton(
        child: Text("Get Trails"),
        onPressed: () {
          _submit();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _submit();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        FlatButton(
          child: Text("Get Trails"),
          onPressed: () {},
        ),
      ],
    );
  }
}
