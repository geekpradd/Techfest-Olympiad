import 'package:flutter/material.dart';
import './qna.dart';
import './models/ques.dart';

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

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement buil
    return  Scaffold(
        appBar: AppBar(
          title: Text("Main Interface"),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Begin Test'),
            onPressed: () {
              // Navigate to second route when tapped.
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => QnA(dummyQues)),
              );
            },
          ),
        ),
    );
  }
}



