import 'package:flutter_test/flutter_test.dart';

import 'package:dev_profiler/domain/entities/quiz_result.dart';

void main() {
  group('QuizResult', () {
    QuizResult makeResult({required int score, required int total}) {
      return QuizResult(
        id: '1',
        userId: 'u1',
        quizId: 'q1',
        score: score,
        totalQuestions: total,
        completedAt: DateTime(2024, 1, 1),
      );
    }

    test('percentage is calculated correctly', () {
      expect(makeResult(score: 8, total: 10).percentage, equals(80.0));
      expect(makeResult(score: 0, total: 10).percentage, equals(0.0));
      expect(makeResult(score: 10, total: 10).percentage, equals(100.0));
    });

    test('percentage is 0 when totalQuestions is 0', () {
      expect(makeResult(score: 0, total: 0).percentage, equals(0.0));
    });

    group('classification', () {
      test('Senior for >= 80%', () {
        expect(makeResult(score: 8, total: 10).classification, equals('Senior'));
      });

      test('Mid-level for >= 60%', () {
        expect(
          makeResult(score: 6, total: 10).classification,
          equals('Mid-level'),
        );
      });

      test('Junior for >= 40%', () {
        expect(
          makeResult(score: 4, total: 10).classification,
          equals('Junior'),
        );
      });

      test('Beginner for < 40%', () {
        expect(
          makeResult(score: 3, total: 10).classification,
          equals('Beginner'),
        );
      });
    });
  });
}
