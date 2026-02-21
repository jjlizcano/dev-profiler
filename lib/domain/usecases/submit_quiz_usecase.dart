import '../entities/quiz_result.dart';
import '../repositories/quiz_repository.dart';

class SubmitQuizUseCase {
  final QuizRepository _repository;

  const SubmitQuizUseCase(this._repository);

  Future<QuizResult> call({
    required String userId,
    required String quizId,
    required Map<String, int> answers,
  }) =>
      _repository.submitQuiz(
        userId: userId,
        quizId: quizId,
        answers: answers,
      );
}
