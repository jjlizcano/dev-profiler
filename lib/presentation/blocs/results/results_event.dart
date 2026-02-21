import 'package:equatable/equatable.dart';

abstract class ResultsEvent extends Equatable {
  const ResultsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllResults extends ResultsEvent {
  const LoadAllResults();
}
