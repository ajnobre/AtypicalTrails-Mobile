import 'package:atypical/pages/explore.dart';
import 'package:atypical/requests/trail.dart';
import 'package:atypical/serverApi/serverApi.dart';

import 'package:atypical/utils/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class FinishTrailPage extends StatefulWidget {
  final int time;
  final String trailKey;
  final String username;
  FinishTrailPage({this.time, this.trailKey, this.username});

  @override
  _FinishTrailPageState createState() => _FinishTrailPageState();
}

class _FinishTrailPageState extends State<FinishTrailPage> {
  var rating = 0.0;
  Response response;
  var _formKey = GlobalKey<FormState>();
  ServerApi serverApi = new ServerApi();
  final commentController = TextEditingController();
  SharedPrefs sharedPrefs = new SharedPrefs();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Rate this trail'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                Center(
                  child: SmoothStarRating(
                      allowHalfRating: false,
                      onRatingChanged: (v) {
                        setState(() {
                          rating = v;
                        });
                      },
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      color: Colors.green,
                      borderColor: Colors.green,
                      spacing: 0.0),
                ),
                Form(
                  key: _formKey,
                  child: TextField(
                    controller: commentController,
                    autofocus: true,
                    maxLines: 15,
                    decoration: InputDecoration(
                        helperText: 'Comment', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: _submit,
                  child: const Text('Send', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _submit() async {
    String username = await sharedPrefs.getUsername();
    String tokenID = await sharedPrefs.getToken();
    Trail trail = new Trail(widget.trailKey, username, rating.round(),
        commentController.text, widget.time, tokenID);
    //Isto tem de passar para assincrono.
    response = await serverApi.addToFinished(trail);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExplorePage(),
        ),
      );
    } else if (response.statusCode == 403) {}
  }
}
