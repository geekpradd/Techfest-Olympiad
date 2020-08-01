import 'dart:async';

import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  final ended;
  final submit;
  QuizTimer(this.submit, this.ended);
  @override
  _QuizTimerState createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  var timer = Duration(hours: 1);
  _QuizTimerState() {
    starttimer();
  }

  @override
  void setState(fn){
    if (mounted){
      super.setState(fn);
    }
  }
  void starttimer() async {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timer < Duration(seconds: 1)) {
          widget.submit();
          t.cancel();
        } else if (widget.ended())
          t.cancel();
        else {
          timer = timer - Duration(seconds: 1);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(timer.toString().substring(0, 7));
  }
}
