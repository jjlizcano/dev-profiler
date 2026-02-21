import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.options,
    required super.correctOptionIndex,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correct_option_index'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'options': options,
        'correct_option_index': correctOptionIndex,
      };
}
