import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './qna.dart';
import './models/ques.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetch() async {
  final response = await http.get("https://raw.githubusercontent.com/geekpradd/Techfest-Olympiad/master/lib/models/data.json");

  if (response.statusCode == 200) {
    return json.decode(response.body)["quiz"];
  } else {
    throw Exception('Failed to Fetch Quiz Data');
  }
}

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeRoute()
    );
  }
}

class HomeRoute extends StatefulWidget {
  @override
  _HomeRoute createState() => _HomeRoute();
}

class _HomeRoute extends State<HomeRoute> {
  Future< List<dynamic> > quiz_data;
  List<dynamic> decoded_data;
  final String id = "quizA";
  @override
  void initState() {
    super.initState();
    quiz_data = fetch();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buil
    return  Scaffold(
        appBar: AppBar(
          title: Text("Main Interface"),
        ),
        body: Center(
          child: FutureBuilder<dynamic>(
            future: quiz_data,
            builder: (context, snapshot){
              if (snapshot.hasData){
                decoded_data = snapshot.data;
                return startTestButton();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            }
          ),
          ),
    );
  }

  RaisedButton startTestButton() {
    return RaisedButton(
        child: Text('Begin Test'),
        onPressed: () {
          // Navigate to second route when tapped.
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => QnA(decoded_data, id)),
          );
        }
        );
  }
}



