import 'package:equatable/equatable.dart';

import '../../../domain/entities/question.dart';
import '../../../domain/entities/quiz_result.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizInProgress extends QuizState {
  final List<Question> questions;
  final int currentIndex;
  final Map<String, int> answers;

  const QuizInProgress({
    required this.questions,
    required this.currentIndex,
    required this.answers,
  });

  Question get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;

  @override
  List<Object?> get props => [questions, currentIndex, answers];
}

class QuizSubmitting extends QuizState {
  const QuizSubmitting();
}

class QuizCompleted extends QuizState {
  final QuizResult result;

  const QuizCompleted(this.result);

  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
