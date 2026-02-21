import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/utils/app_theme.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/quiz_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'domain/usecases/get_all_results_usecase.dart';
import 'domain/usecases/get_questions_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/submit_quiz_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/quiz/quiz_bloc.dart';
import 'presentation/blocs/results/results_bloc.dart';
import 'presentation/pages/dashboard/dashboard_page.dart';
import 'presentation/pages/login/login_page.dart';
import 'presentation/pages/quiz/quiz_page.dart';

/// Base URL of the backend REST API.
///
/// Update this constant to point to your deployed API server.
const String _baseUrl = 'https://api.dev-profiler.example.com';

class DevProfilerApp extends StatelessWidget {
  const DevProfilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();

    final authRemoteDs = AuthRemoteDataSourceImpl(
      client: httpClient,
      baseUrl: _baseUrl,
    );
    final quizRemoteDs = QuizRemoteDataSourceImpl(
      client: httpClient,
      baseUrl: _baseUrl,
    );

    final authRepo = AuthRepositoryImpl(remoteDataSource: authRemoteDs);
    final quizRepo = QuizRepositoryImpl(remoteDataSource: quizRemoteDs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
          ),
        ),
        BlocProvider(
          create: (_) => QuizBloc(
            getQuestionsUseCase: GetQuestionsUseCase(quizRepo),
            submitQuizUseCase: SubmitQuizUseCase(quizRepo),
          ),
        ),
        BlocProvider(
          create: (_) => ResultsBloc(
            getAllResultsUseCase: GetAllResultsUseCase(quizRepo),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        initialRoute: AppRoutes.login,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.login:
              return MaterialPageRoute(
                builder: (_) => const LoginPage(),
              );
            case AppRoutes.dashboard:
              return MaterialPageRoute(
                builder: (_) => const DashboardPage(),
              );
            case AppRoutes.quiz:
              final quizId = (settings.arguments as String?) ?? 'default';
              return MaterialPageRoute(
                builder: (_) => QuizPage(quizId: quizId),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const LoginPage(),
              );
          }
        },
      ),
    );
  }
}
