import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> questionIds;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questionIds,
  });

  @override
  List<Object?> get props => [id, title, description, questionIds];
}
