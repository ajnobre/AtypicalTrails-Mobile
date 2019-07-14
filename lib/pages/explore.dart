import 'package:atypical/elements/drawer.dart';
import 'package:atypical/pages/traildescriptor.dart';

import 'package:atypical/serverApi/serverApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.white);
  List<dynamic> receivedList;
  ServerApi serverApi = new ServerApi();

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
              return createGridView(
                  context, snapshot) /* createListView(context, snapshot) */;
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
          title: Text('Explore'),
          actions: <Widget>[],
        ),
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
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TrailDesc(data: trail)));
      },
    );
  }

  Future<dynamic> _getData() async {
    List<dynamic> values, values1, values2;
    values = await _submit(0);
    values1 = await _submit(12);
    values2 = await _submit(24);
    values.addAll(values1);
    values.addAll(values2);
    return values;
  }

  Future _submit(int offset) async {
    response = await serverApi.getAllTrails(offset);
    if (response.statusCode == 200) {
      receivedList = response.data;
      return receivedList;
    }
  }

/*   Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
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
  } */

  Widget createGridView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> trailList = snapshot.data;
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
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
          return _buildButton(_contents[i]) /* _buildRow(_contents[i]) */;
        }
        return null;
      },
    );
  }

  Widget _buildButton(Map<String, dynamic> trail) {
    return FlatButton(
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

    return Container(
      foregroundDecoration: new BoxDecoration(
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
/*       decoration: const BoxDecoration(
        image: DecorationImage(
            alignment: Alignment(-.2, 0),
            image: NetworkImage(
                'http://www.naturerights.com/blog/wp-content/uploads/2017/12/Taranaki-NR-post-1170x550.png'),
            fit: BoxFit.cover),
      ), */
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 20),
    );
  }
}
