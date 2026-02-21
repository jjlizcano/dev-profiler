import 'package:equatable/equatable.dart';

import '../../../domain/entities/quiz_result.dart';

abstract class ResultsState extends Equatable {
  const ResultsState();

  @override
  List<Object?> get props => [];
}

class ResultsInitial extends ResultsState {
  const ResultsInitial();
}

class ResultsLoading extends ResultsState {
  const ResultsLoading();
}

class ResultsLoaded extends ResultsState {
  final List<QuizResult> results;

  const ResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class ResultsError extends ResultsState {
  final String message;

  const ResultsError(this.message);

  @override
  List<Object?> get props => [message];
}
