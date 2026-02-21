import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_all_results_usecase.dart';
import 'results_event.dart';
import 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  final GetAllResultsUseCase getAllResultsUseCase;

  ResultsBloc({required this.getAllResultsUseCase})
      : super(const ResultsInitial()) {
    on<LoadAllResults>(_onLoadAllResults);
  }

  Future<void> _onLoadAllResults(
    LoadAllResults event,
    Emitter<ResultsState> emit,
  ) async {
    emit(const ResultsLoading());
    try {
      final results = await getAllResultsUseCase();
      emit(ResultsLoaded(results));
    } catch (e) {
      emit(ResultsError(e.toString()));
    }
  }
}
