import 'package:atypical/elements/drawer.dart';
import 'package:atypical/serverApi/serverApi.dart';
import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  final String trailKey;
  CommentsPage({this.trailKey});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
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

    return Scaffold(
      body: futureBuilder,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Comments'),
      ),
    );
  }

  Future _fetchData() async {
    ServerApi serverApi = new ServerApi();

    Response response = await serverApi.getTrailComments(0, widget.trailKey);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> trailList = snapshot.data;
    if (trailList == null) {
      return Container(
        height: 0,
        width: 0,
      );
    } else
      return Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: trailList.length,
              itemBuilder: (context, i) {
                if (i < trailList.length) {
                  return _buildRow(trailList[i]['propertyMap']);
                }
                return null;
              },
            ),
          ),
        ],
      );
  }

  Widget _buildRow(Map<String, dynamic> trail) {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.amber[600]),
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                trail['Creator'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),


          Wrap(children: <Widget>[getText(trail['Comment'])]),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  getText(String comment) {
    if (comment == null) {
      return Text('');
    } else
      return Text(comment);
  }
}
