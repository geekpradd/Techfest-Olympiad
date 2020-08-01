import 'package:flutter/material.dart';

class FillInBlank extends StatefulWidget {
  final handler;
  var ans;
  FillInBlank(this.handler, ans) {
    if (ans is String)
      this.ans = ans;
    else
      ans = '';
  }

  @override
  _FillInBlankState createState() => _FillInBlankState();
}

class _FillInBlankState extends State<FillInBlank> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.ans;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Type your Answer here',
        ),
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          widget.handler(_controller.text);
        },
      ),
    );
  }
}
