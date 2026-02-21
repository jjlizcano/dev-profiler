import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/quiz_result.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/results/results_bloc.dart';
import '../../blocs/results/results_event.dart';
import '../../blocs/results/results_state.dart';
import '../../widgets/result_card.dart';
import '../../../core/utils/pdf_exporter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ResultsBloc>().add(const LoadAllResults());
  }

  Future<void> _exportPdf(List<QuizResult> results) async {
    try {
      await PdfExporter.exportResults(results);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF exported successfully.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export PDF.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.dashboard),
          actions: [
            BlocBuilder<ResultsBloc, ResultsState>(
              builder: (context, state) {
                final results =
                    state is ResultsLoaded ? state.results : <QuizResult>[];
                return IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: AppStrings.exportPdf,
                  onPressed:
                      results.isNotEmpty ? () => _exportPdf(results) : null,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: AppStrings.logout,
              onPressed: () =>
                  context.read<AuthBloc>().add(const LogoutRequested()),
            ),
          ],
        ),
        body: BlocBuilder<ResultsBloc, ResultsState>(
          builder: (context, state) {
            if (state is ResultsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ResultsError) {
              return Center(child: Text(state.message));
            }
            if (state is ResultsLoaded) {
              if (state.results.isEmpty) {
                return const Center(
                  child: Text('No results yet.'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    ResultCard(result: state.results[index]),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
