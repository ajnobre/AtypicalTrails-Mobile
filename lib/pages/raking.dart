import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyRankingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyRankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<MyRankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        title: Text('Ranking'),
        expandedHeight: 200.0,
        pinned: true,
        backgroundColor: Colors.green,
        flexibleSpace: new FlexibleSpaceBar(
          background: Image.network(
            'https://scontent.flis8-2.fna.fbcdn.net/v/t1.0-9/13510840_1389635067736401_2668166223219640284_n.jpg?_nc_cat=107&_nc_oc=AQnq9-5s4uPyalUXTpzYYcQ44yVvajIFlyYRyJah4eEdxOGfJgOD0aZfdPngAh3R5A311IH-qJ8GdYBQ1TcPjwm7&_nc_ht=scontent.flis8-2.fna&oh=e525eb681e323be3155f0ffd226f463a&oe=5DC74C8A',
            fit: BoxFit.fill,
          ),
        ),
      ),
      new SliverList(
        delegate: new SliverChildBuilderDelegate(
          (context, index) => new Card(
                child: new Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: new NetworkImage(
                                  'https://i.kym-cdn.com/photos/images/original/000/787/356/d6f.jpg'),
                            ),
                            SizedBox(
                              width: 10.0,
                              height: 2.0,
                            ),
                            Text('@username'),
                          ],
                        ),
                        Row(children: <Widget>[
                          Text('Points'),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('200')
                        ]),
                      ],
                    )),
              ),
          childCount: 20,
        ),
      )
    ]));
  }
}
