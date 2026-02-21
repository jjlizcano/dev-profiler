import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final String id;
  final String userId;
  final String quizId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  const QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  double get percentage =>
      totalQuestions == 0 ? 0 : (score / totalQuestions) * 100;

  String get classification {
    if (percentage >= 80) return 'Senior';
    if (percentage >= 60) return 'Mid-level';
    if (percentage >= 40) return 'Junior';
    return 'Beginner';
  }

  @override
  List<Object?> get props =>
      [id, userId, quizId, score, totalQuestions, completedAt];
}
