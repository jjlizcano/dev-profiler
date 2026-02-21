import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  const QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Quiz>> getQuizzes() async {
    try {
      return await remoteDataSource.getQuizzes();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<Question>> getQuestions(String quizId) async {
    try {
      return await remoteDataSource.getQuestions(quizId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<QuizResult> submitQuiz({
    required String userId,
    required String quizId,
    required Map<String, int> answers,
  }) async {
    try {
      return await remoteDataSource.submitQuiz(
        userId: userId,
        quizId: quizId,
        answers: answers,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<QuizResult>> getAllResults() async {
    try {
      return await remoteDataSource.getAllResults();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<QuizResult>> getResultsByUser(String userId) async {
    try {
      return await remoteDataSource.getResultsByUser(userId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
