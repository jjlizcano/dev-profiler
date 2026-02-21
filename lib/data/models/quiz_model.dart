import '../../domain/entities/quiz.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required super.id,
    required super.title,
    required super.description,
    required super.questionIds,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      questionIds: List<String>.from(json['question_ids'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'question_ids': questionIds,
      };
}
