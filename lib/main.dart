import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './qna.dart';
import './models/ques.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var baseUrl = "http://django-env.eba-am2ftkcp.us-east-1.elasticbeanstalk.com/api/";

Future<List<dynamic>> fetch(String quizId) async {
  final response = await http.get(baseUrl + quizId + "/?format=json");

  if (response.statusCode == 200) {
    return json.decode(response.body)[0]["questions"];
  } else {
    throw Exception('Failed to Fetch Quiz Data');
  }
}

Future<List<dynamic>> fetchQuizzes() async {
  final response = await http.get(baseUrl + "quiz/?format=json");
  if (response.statusCode == 200) {
    return json.decode(response.body);
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
        home: QuizList()
    );
  }
}
class QuizList extends StatefulWidget {
  @override
  _QuizList createState() => _QuizList();
}
Widget _buildCard(data, BuildContext context) => SizedBox(
  child: Card(
    child: Column(
      children: [
        ListTile(
          title: Center(child:Text(data["name"],
              style: TextStyle(fontWeight: FontWeight.w500)),),
//          subtitle: Text('The final round of the best competition there is'),
        ),
        Divider(),
        ListTile(
          title: Center(child:Text('Duration: ${data["hours"]} Hours')),
        ),
        ListTile(
          title: FlatButton(
            child: Text("Download and Begin Test"),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeRoute(data["id"])),
              );
            },
          ),
        ),
      ],
    ),
  ),
);

class _QuizList extends State<QuizList>{
  Future< List<dynamic> > quiz_data;
  List<dynamic> decoded_data;

  @override
  void initState() {
    super.initState();
    quiz_data = fetchQuizzes();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Available Quizzes"),
            ),
          body: FutureBuilder<dynamic>(
              future: quiz_data,
              builder: (context, snapshot){
                if (snapshot.hasData){
                  decoded_data = snapshot.data;
                  return getMainContainer(context);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return CircularProgressIndicator();
              }
          ),
    )
    );
  }

  Container getMainContainer(BuildContext context) {
    return Container(
        child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    itemCount: decoded_data.length,
                    itemBuilder: (context, index) {
                      return _buildCard(decoded_data[index], context);
                    },
                  ))
            ])
    );
  }


}


class HomeRoute extends StatefulWidget {
  final int id;
  const HomeRoute(this.id);
  @override
  _HomeRoute createState() => _HomeRoute();
}

class _HomeRoute extends State<HomeRoute> {
  Future< List<dynamic> > question_data;
  List<dynamic> decoded_data;
  int id;
  @override
  void initState() {
    id = widget.id;
    super.initState();
    question_data = fetch(id.toString());
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



