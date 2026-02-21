import 'package:flutter/material.dart';

import '../../domain/entities/quiz_result.dart';

class ResultCard extends StatelessWidget {
  final QuizResult result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _classificationColor(result.classification),
          child: Text(
            result.classification[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text('User: ${result.userId}'),
        subtitle: Text(
          'Score: ${result.score}/${result.totalQuestions} '
          '(${result.percentage.toStringAsFixed(0)}%) '
          '• ${result.classification}',
        ),
        trailing: Text(
          _formatDate(result.completedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Color _classificationColor(String classification) {
    switch (classification) {
      case 'Senior':
        return const Color(0xFF388E3C);
      case 'Mid-level':
        return const Color(0xFF1565C0);
      case 'Junior':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF757575);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
