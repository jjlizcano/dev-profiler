import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestions extends QuizEvent {
  final String quizId;

  const LoadQuestions(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class AnswerSelected extends QuizEvent {
  final String questionId;
  final int optionIndex;

  const AnswerSelected({
    required this.questionId,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [questionId, optionIndex];
}

class NextQuestion extends QuizEvent {
  const NextQuestion();
}

class SubmitQuiz extends QuizEvent {
  final String userId;
  final String quizId;

  const SubmitQuiz({required this.userId, required this.quizId});

  @override
  List<Object?> get props => [userId, quizId];
}
