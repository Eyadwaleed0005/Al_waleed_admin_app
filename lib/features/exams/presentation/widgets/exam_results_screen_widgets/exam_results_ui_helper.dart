import 'package:alwaleed_admain/core/helper/app_date_time_formatter.dart';
import 'package:alwaleed_admain/core/helper/arabic_numbers_helper.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_result_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_results_report_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_result_card.dart';

abstract final class ExamResultsUiHelper {
  const ExamResultsUiHelper._();

  static List<StudentExamResultViewData> mapResultsToViewData(
    ExamResultsReportEntity report,
  ) {
    return report.submittedResults
        .map(mapResultToViewData)
        .toList();
  }

  static StudentExamResultViewData mapResultToViewData(
    ExamResultEntity result,
  ) {
    return StudentExamResultViewData(
      studentId: result.studentId,
      studentName: result.studentName,
      gradeName: result.gradeName,
      studentScoreText: formatNumber(result.score ?? 0),
      totalScoreText: formatNumber(result.totalScore),
      status: result.isPassed
          ? StudentExamResultStatus.passed
          : StudentExamResultStatus.failed,
    );
  }

  static String formatAverageScore(
    ExamResultsReportEntity report,
  ) {
    final roundedAverage = report.averagePercentage.round();

    return '${toArabicNumbers(roundedAverage)}٪';
  }

  static String formatParticipantsCount(
    ExamResultsReportEntity report,
  ) {
    return toArabicNumbers(report.totalAttemptsCount);
  }

  static String buildExamDetailsText(
    ExamEntity exam,
  ) {
    final totalScore = formatNumber(
      exam.totalScore,
    );

    final closedAt = exam.closedAt;

    if (closedAt == null) {
      return '$totalScore درجة';
    }

    final formattedDate = AppDateTimeFormatter.formatDate(
      closedAt,
    );

    return 'انتهى في $formattedDate · $totalScore درجة';
  }

  static String formatNumber(num number) {
    if (number % 1 == 0) {
      return toArabicNumbers(
        number.toInt(),
      );
    }

    final formattedNumber = double.parse(
      number.toStringAsFixed(1),
    );

    return toArabicNumbers(
      formattedNumber,
    );
  }
}