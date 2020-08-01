import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import './Widgets/timer.dart';
import './Widgets/fillInBlank.dart';
import './models/ques.dart';
import './Widgets/answerList.dart';
import './Widgets/drawer.dart';
import './Widgets/question.dart';

class QnA extends StatefulWidget {
  @override
  _QnAstate createState() => _QnAstate();
}

class _QnAstate extends State<QnA> with SingleTickerProviderStateMixin {
  var timer = Duration(hours: 1);
  bool submit = false;
  BuildContext baseContext;
  TextEditingController _textcontroller = new TextEditingController();
  AnimationController _controller;
  Animation _animation;
  final ques = dummyQues;
  final quesWidgetKey = GlobalKey();
  final bottomNavKey = GlobalKey();
  var ans = {};
  var qid = 0;
  var gesture = 0;
  var extraHeight = 100.0;
  void submitRequest() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You clicked the Submit Button!'),
          content: Text('Do you really want to submit?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                sendans();
              },
            )
          ],
        );
      },
    );
  }

  void quit() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You clicked the Quit Button!'),
          content: Text('Do you really want to quit?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                ans = {};
                Navigator.pop(context);
                sendans();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void sendans() {
    submit = true;
    print(ans);
    print('Bye');
    Navigator.pop(baseContext);
  }

  void fillBlank(String s) {
    ans[ques[qid]['id']] = s;
  }

  void clickAns(var index) {
    setState(() {
      if (ans[ques[qid]['id']] == index)
        ans[ques[qid]['id']] = -1;
      else
        ans[ques[qid]['id']] = index;
    });
  }

  void gotoQuestion(var quesno) {
    if (quesno >= 0 && quesno < ques.length) {
      _controller.reset();
      setState(() {
        qid = quesno;
        _textcontroller.text = (qid + 1).toString();
      });
    } else if (quesno == ques.length) {
      submitRequest();
    } else if (quesno == -10) quit();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    ques.shuffle();
    for (var q = 0; q < ques.length; q++) {
      ans[ques[q]['id']] = -1;
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
    _textcontroller.text = (qid + 1).toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _afterLayout(_) {
    _getSizes();
  }

  _getSizes() {
    final RenderBox renderBottom =
        bottomNavKey.currentContext.findRenderObject();
    final RenderBox renderQues =
        quesWidgetKey.currentContext.findRenderObject();
    setState(() {
      extraHeight = renderBottom.size.height + renderQues.size.height;
    });
  }

  getsubmit() {
    return submit;
  }

  @override
  Widget build(BuildContext context) {
    baseContext = context;
    final dropdownItem =
        List<String>.generate(ques.length, (index) => (index + 1).toString());
    _controller.forward();
    final bottomNav = Container(
      key: bottomNavKey,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // if (qid != 0)
          FlatButton(
            child: Text(
              'Previous',
            ),
            onPressed: qid == 0 ? null : () => gotoQuestion(qid - 1),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      'Q .',
                      style: GoogleFonts.pacifico(),
                    ),
                  ),
                  Expanded(
                      child: DropdownButton<String>(
                    value: (qid + 1).toString(),
                    icon: Icon(null),
                    elevation: 16,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String value) {
                      var quesid = int.parse(value) - 1;
                      if (quesid < ques.length && quesid >= 0)
                        gotoQuestion(quesid);
                      else {
                        Fluttertoast.showToast(
                          msg: "Invalid Question Number",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.grey[800],
                          textColor: Colors.white,
                        );
                      }
                    },
                    items: dropdownItem.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                  )),
                ],
              ),
            ),
          ),
          FlatButton(
            child: qid == ques.length - 1 ? Text('Submit') : Text('Next'),
            onPressed: () => gotoQuestion(qid + 1),
          )
        ],
      ),
    );
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      title: QuizTimer(sendans, getsubmit),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          onPressed: submitRequest,
        )
      ],
    );

    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "TechFest Olympiad",
                  ),
                  content: Text("You Can't Go Back At This Stage."),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                      ),
                    )
                  ],
                ));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        appBar: appBar,
        drawer: MainDrawer(ques.length, gotoQuestion),
        body: Column(children: [
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: GestureDetector(
                onHorizontalDragUpdate: gesture == 0
                    ? (details) {
                        if (details.delta.dx > 10)
                          gesture = -1;
                        else if (details.delta.dx < -10) {
                          gesture = 1;
                        }
                        // setState(() => gesture = false);
                        // Timer(Duration(milliseconds: 1),
                        //     () => setState(() => gesture = true));
                      }
                    : null,
                onHorizontalDragEnd: (details) {
                  if (qid == ques.length - 1 && gesture == 1)
                    Fluttertoast.showToast(
                      msg: "You have reached the last question",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.grey[800],
                      textColor: Colors.white,
                    );
                  else if (gesture != 0) gotoQuestion(qid + gesture);
                  gesture = 0;
                },
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Question(
                            quesWidgetKey, '${qid + 1}. ' + ques[qid]['ques']),
                        Container(
                          height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              extraHeight),
                          child: ques[qid]['questype'] == 'mcq'
                              ? AnswerList(clickAns, ques[qid]['options'],
                                  ans[ques[qid]['id']])
                              : FillInBlank(fillBlank, ans[ques[qid]['id']]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNav,
        ]),
        // bottomNavigationBar: ,

        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
