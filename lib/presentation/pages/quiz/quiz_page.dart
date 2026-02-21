import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/quiz/quiz_bloc.dart';
import '../../blocs/quiz/quiz_event.dart';
import '../../blocs/quiz/quiz_state.dart';

/// Displays the quiz interface with a question and multiple-choice answers.
class QuizPage extends StatelessWidget {
  /// The quiz ID loaded from route arguments.
  final String quizId;

  const QuizPage({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    final userId = _currentUserId(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizInitial) {
            return _buildStartScreen(context);
          }
          if (state is QuizLoading || state is QuizSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuizInProgress) {
            return _buildQuizScreen(context, state, userId);
          }
          if (state is QuizCompleted) {
            return _buildResultScreen(context, state);
          }
          if (state is QuizError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _currentUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) return authState.user.id;
    return '';
  }

  Widget _buildStartScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 72, color: Color(0xFF1565C0)),
            const SizedBox(height: 16),
            Text(
              'Ready to start?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  context.read<QuizBloc>().add(LoadQuestions(quizId)),
              child: const Text(AppStrings.startQuiz),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizScreen(
    BuildContext context,
    QuizInProgress state,
    String userId,
  ) {
    final question = state.currentQuestion;
    final selectedAnswer = state.answers[question.id];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (state.currentIndex + 1) / state.questions.length,
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${state.currentIndex + 1} of ${state.questions.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(question.options.length, (i) {
            final isSelected = selectedAnswer == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? const Color(0xFF1565C0).withAlpha(25)
                      : null,
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF1565C0)
                        : Colors.grey.shade400,
                    width: isSelected ? 2 : 1,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () => context.read<QuizBloc>().add(
                      AnswerSelected(
                        questionId: question.id,
                        optionIndex: i,
                      ),
                    ),
                child: Text(question.options[i]),
              ),
            );
          }),
          const Spacer(),
          if (state.isLastQuestion)
            ElevatedButton(
              onPressed: selectedAnswer != null
                  ? () => context.read<QuizBloc>().add(
                        SubmitQuiz(userId: userId, quizId: quizId),
                      )
                  : null,
              child: const Text(AppStrings.submitQuiz),
            )
          else
            ElevatedButton(
              onPressed: selectedAnswer != null
                  ? () => context.read<QuizBloc>().add(const NextQuestion())
                  : null,
              child: const Text(AppStrings.nextQuestion),
            ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, QuizCompleted state) {
    final result = state.result;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 72, color: Color(0xFF388E3C)),
            const SizedBox(height: 16),
            Text(
              AppStrings.quizCompleted,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${AppStrings.yourScore}: ${result.score}/${result.totalQuestions}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Classification: ${result.classification}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
