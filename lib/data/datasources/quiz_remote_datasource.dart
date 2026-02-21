import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../models/quiz_result_model.dart';

/// Handles quiz-related API calls.
abstract class QuizRemoteDataSource {
  Future<List<QuizModel>> getQuizzes();
  Future<List<QuestionModel>> getQuestions(String quizId);
  Future<QuizResultModel> submitQuiz({
    required String userId,
    required String quizId,
    required Map<String, int> answers,
  });
  Future<List<QuizResultModel>> getAllResults();
  Future<List<QuizResultModel>> getResultsByUser(String userId);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  const QuizRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<QuizModel>> getQuizzes() async {
    final response = await client.get(Uri.parse('$baseUrl/quizzes'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException();
  }

  @override
  Future<List<QuestionModel>> getQuestions(String quizId) async {
    final response =
        await client.get(Uri.parse('$baseUrl/quizzes/$quizId/questions'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException();
  }

  @override
  Future<QuizResultModel> submitQuiz({
    required String userId,
    required String quizId,
    required Map<String, int> answers,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/results'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'quiz_id': quizId,
        'answers': answers,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return QuizResultModel.fromJson(data);
    }
    throw const ServerException();
  }

  @override
  Future<List<QuizResultModel>> getAllResults() async {
    final response = await client.get(Uri.parse('$baseUrl/results'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => QuizResultModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException();
  }

  @override
  Future<List<QuizResultModel>> getResultsByUser(String userId) async {
    final response =
        await client.get(Uri.parse('$baseUrl/results?user_id=$userId'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => QuizResultModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException();
  }
}
