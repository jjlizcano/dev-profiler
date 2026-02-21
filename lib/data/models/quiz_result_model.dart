import '../../domain/entities/quiz_result.dart';

class QuizResultModel extends QuizResult {
  const QuizResultModel({
    required super.id,
    required super.userId,
    required super.quizId,
    required super.score,
    required super.totalQuestions,
    required super.completedAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      quizId: json['quiz_id'] as String,
      score: json['score'] as int,
      totalQuestions: json['total_questions'] as int,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'quiz_id': quizId,
        'score': score,
        'total_questions': totalQuestions,
        'completed_at': completedAt.toIso8601String(),
      };
}
