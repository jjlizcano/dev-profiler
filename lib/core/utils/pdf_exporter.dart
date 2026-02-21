import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/entities/quiz_result.dart';

/// Utility class to generate and share a PDF report of quiz results.
class PdfExporter {
  PdfExporter._();

  /// Generates a PDF document listing all [results] and opens the share/print
  /// dialog via the [printing] package.
  static Future<void> exportResults(List<QuizResult> results) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Text(
          'Dev Profiler – Results Report',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        footer: (context) => pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 10),
        ),
        build: (context) => [
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: [
              'User ID',
              'Quiz ID',
              'Score',
              'Total',
              'Percentage',
              'Classification',
              'Date',
            ],
            data: results
                .map(
                  (r) => [
                    r.userId,
                    r.quizId,
                    r.score.toString(),
                    r.totalQuestions.toString(),
                    '${r.percentage.toStringAsFixed(0)}%',
                    r.classification,
                    '${r.completedAt.day.toString().padLeft(2, '0')}/'
                        '${r.completedAt.month.toString().padLeft(2, '0')}/'
                        '${r.completedAt.year}',
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellPadding: const pw.EdgeInsets.all(6),
            border: pw.TableBorder.all(),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'dev_profiler_results.pdf',
    );
  }
}
