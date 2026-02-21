import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_questions_usecase.dart';
import '../../../domain/usecases/submit_quiz_usecase.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuestionsUseCase getQuestionsUseCase;
  final SubmitQuizUseCase submitQuizUseCase;

  QuizBloc({
    required this.getQuestionsUseCase,
    required this.submitQuizUseCase,
  }) : super(const QuizInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<AnswerSelected>(_onAnswerSelected);
    on<NextQuestion>(_onNextQuestion);
    on<SubmitQuiz>(_onSubmitQuiz);
  }

  Future<void> _onLoadQuestions(
    LoadQuestions event,
    Emitter<QuizState> emit,
  ) async {
    emit(const QuizLoading());
    try {
      final questions = await getQuestionsUseCase(event.quizId);
      emit(QuizInProgress(
        questions: questions,
        currentIndex: 0,
        answers: {},
      ));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _onAnswerSelected(
    AnswerSelected event,
    Emitter<QuizState> emit,
  ) {
    final current = state;
    if (current is QuizInProgress) {
      final updatedAnswers =
          Map<String, int>.from(current.answers)
            ..[event.questionId] = event.optionIndex;
      emit(QuizInProgress(
        questions: current.questions,
        currentIndex: current.currentIndex,
        answers: updatedAnswers,
      ));
    }
  }

  void _onNextQuestion(
    NextQuestion event,
    Emitter<QuizState> emit,
  ) {
    final current = state;
    if (current is QuizInProgress && !current.isLastQuestion) {
      emit(QuizInProgress(
        questions: current.questions,
        currentIndex: current.currentIndex + 1,
        answers: current.answers,
      ));
    }
  }

  Future<void> _onSubmitQuiz(
    SubmitQuiz event,
    Emitter<QuizState> emit,
  ) async {
    final current = state;
    if (current is! QuizInProgress) return;

    emit(const QuizSubmitting());
    try {
      final result = await submitQuizUseCase(
        userId: event.userId,
        quizId: event.quizId,
        answers: current.answers,
      );
      emit(QuizCompleted(result));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
