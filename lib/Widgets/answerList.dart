import 'package:flutter/material.dart';

class AnswerList extends StatelessWidget {
  final answer;
  final click;
  final isSelected;
  AnswerList(this.click, this.answer, this.isSelected);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          padding: EdgeInsets.all(0),
          decoration: isSelected != -1 && isSelected == index
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                )
              : BoxDecoration(
                  border: Border.all(
                  color: Colors.grey,
                )),
          child: FlatButton(
            padding: EdgeInsets.all(0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    margin: EdgeInsets.all(0),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: isSelected != -1 && isSelected == index
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      child: Text(
                        answer[index],
                      ),
                    ),
                  )
                ],
              ),
            ),
            onPressed: () => click(index),
          ),
        );
      },
      itemCount: answer.length,
    );
  }
}
