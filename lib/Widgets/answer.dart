import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function changer;
  final String ansText;

  Answer(this.changer, this.ansText);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.black,
      color: Colors.grey[50],
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          ansText,
          textAlign: TextAlign.center,
        ),
      ),
      onPressed: changer,
    );
  }
}
