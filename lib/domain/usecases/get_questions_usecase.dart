import '../entities/question.dart';
import '../repositories/quiz_repository.dart';

class GetQuestionsUseCase {
  final QuizRepository _repository;

  const GetQuestionsUseCase(this._repository);

  Future<List<Question>> call(String quizId) =>
      _repository.getQuestions(quizId);
}
