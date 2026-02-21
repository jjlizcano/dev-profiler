import 'package:flutter_test/flutter_test.dart';

import 'package:dev_profiler/data/models/quiz_result_model.dart';

void main() {
  group('QuizResultModel', () {
    final json = {
      'id': 'r1',
      'user_id': 'u1',
      'quiz_id': 'q1',
      'score': 7,
      'total_questions': 10,
      'completed_at': '2024-06-01T10:00:00.000Z',
    };

    test('fromJson parses correctly', () {
      final model = QuizResultModel.fromJson(json);
      expect(model.id, 'r1');
      expect(model.userId, 'u1');
      expect(model.quizId, 'q1');
      expect(model.score, 7);
      expect(model.totalQuestions, 10);
    });

    test('toJson round-trips correctly', () {
      final model = QuizResultModel.fromJson(json);
      final output = model.toJson();
      expect(output['score'], 7);
      expect(output['total_questions'], 10);
    });
  });
}
