import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Question extends StatelessWidget {
  final qText;
  final widgetKey;
  Question(this.widgetKey, this.qText);
  @override
  Widget build(BuildContext context) {
    return Card(
      key: widgetKey,
      margin: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Center(
                  child: Text('Q',
                      style: GoogleFonts.pacifico(
                        fontSize: 50,
                      )),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(qText),
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      elevation: 5,
    );
  }
}
