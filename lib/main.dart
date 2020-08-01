import 'package:flutter/material.dart';
import './qna.dart';

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
          title: Text('Techfest Olympiad'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Begin Test'),
            onPressed: () {
              // Navigate to second route when tapped.
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => QnA()),
              );
            },
          ),
        ),
    );
  }
}



//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Olympiad',
//      theme: ThemeData(),
//      home: QnA(),
//    );
//  }
//}
