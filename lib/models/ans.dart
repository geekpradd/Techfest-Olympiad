import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Answer {
  final ansList;
  Answer(this.ansList) {
    print(ansList);
  }
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return Answer(json['ansList']);
}

Map<String, dynamic> _$AnswerToJson(Answer instance) => instance.ansList;
