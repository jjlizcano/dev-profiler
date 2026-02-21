import '../entities/quiz_result.dart';
import '../repositories/quiz_repository.dart';

class GetAllResultsUseCase {
  final QuizRepository _repository;

  const GetAllResultsUseCase(this._repository);

  Future<List<QuizResult>> call() => _repository.getAllResults();
}
