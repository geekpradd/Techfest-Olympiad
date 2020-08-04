import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './qna.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var baseUrl =
    "http://django-env.eba-am2ftkcp.us-east-1.elasticbeanstalk.com/api/";

Future<List<dynamic>> fetch(String quizId) async {
  final response = await http.get(baseUrl + 'quiz/' + quizId + "/?format=json");
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
    return MaterialApp(home: QuizList());
  }
}

class QuizList extends StatefulWidget {
  @override
  _QuizList createState() => _QuizList();
}

class _QuizList extends State<QuizList> {
  Future<List<dynamic>> quiz_data;
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
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              decoded_data = snapshot.data;
              return getMainContainer(context);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(child: CircularProgressIndicator());
          }),
    ));
  }

  Container getMainContainer(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
        itemCount: decoded_data.length,
        itemBuilder: (context, index) {
          return _buildCard(decoded_data[index], context);
        },
      ))
    ]));
  }
}

Widget _buildCard(data, BuildContext context) => SizedBox(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 10,
        ),
        child: Card(
          elevation: 3,
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 15),
            child: Column(
              children: [
                ListTile(
                  title: Center(
                    child: Text(data["name"],
                        style: GoogleFonts.aBeeZee(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  trailing: Text('${data["hours"]} Hours',
                      style: GoogleFonts.cabin(fontSize: 15)),
//          subtitle: Text('The final round of the best competition there is'),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[800],
                ),
                Text(
                  data["description"],
                  style: GoogleFonts.mukta(
                    fontSize: 17,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Download and Begin Test",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeRoute(data["id"])),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

class HomeRoute extends StatefulWidget {
  final int id;
  const HomeRoute(this.id);
  @override
  _HomeRoute createState() => _HomeRoute();
}

class _HomeRoute extends State<HomeRoute> {
  Future<List<dynamic>> question_data;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Interface"),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
            future: question_data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                decoded_data = snapshot.data;
                return startTestButton();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            }),
      ),
    );
  }

  convert(var fetch) {
    List s = [];
    for (var fetchedDict in fetch) {
      var SendDict = {};
      SendDict['id'] = fetchedDict['id'];
      SendDict['ques'] = fetchedDict['text'];
      SendDict['questype'] = fetchedDict['ques_type'];
      if (fetchedDict['ques_type'] == 'mcq')
        SendDict['options'] = [
          fetchedDict['option_a'],
          fetchedDict['option_b'],
          fetchedDict['option_c'],
          fetchedDict['option_d'],
        ];
      s.add(SendDict);
    }
    return s;
  }

  RaisedButton startTestButton() {
    return RaisedButton(
        child: Text('Begin Test'),
        onPressed: () {
          // Navigate to second route when tapped.
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QnA(convert(decoded_data), id)),
          );
        });
  }
}
