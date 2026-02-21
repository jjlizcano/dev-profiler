import '../entities/question.dart';
import '../entities/quiz.dart';
import '../entities/quiz_result.dart';

abstract class QuizRepository {
  /// Returns all available quizzes.
  Future<List<Quiz>> getQuizzes();

  /// Returns the questions for a given [quizId].
  Future<List<Question>> getQuestions(String quizId);

  /// Submits a completed quiz and returns the persisted [QuizResult].
  Future<QuizResult> submitQuiz({
    required String userId,
    required String quizId,
    required Map<String, int> answers,
  });

  /// Returns all quiz results (admin view).
  Future<List<QuizResult>> getAllResults();

  /// Returns quiz results for a specific [userId].
  Future<List<QuizResult>> getResultsByUser(String userId);
}
