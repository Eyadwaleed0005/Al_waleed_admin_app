import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_result_entity.dart';

class ExamResultsReportEntity {
  const ExamResultsReportEntity({
    required this.exam,
    required this.results,
  });

  final ExamEntity exam;
  final List<ExamResultEntity> results;

  List<ExamResultEntity> get submittedResults {
    return List<ExamResultEntity>.unmodifiable(
      results.where(
        (result) {
          return result.isSubmitted && result.hasValidScore;
        },
      ),
    );
  }

  List<ExamResultEntity> get inProgressResults {
    return List<ExamResultEntity>.unmodifiable(
      results.where(
        (result) {
          return result.isInProgress;
        },
      ),
    );
  }

  int get totalAttemptsCount {
    return results.length;
  }

  int get submittedCount {
    return results.where(
      (result) {
        return result.isSubmitted;
      },
    ).length;
  }

  int get inProgressCount {
    return inProgressResults.length;
  }

  int get passedStudentsCount {
    return submittedResults.where(
      (result) {
        return result.isPassed;
      },
    ).length;
  }

  int get failedStudentsCount {
    return submittedResults.where(
      (result) {
        return result.isFailed;
      },
    ).length;
  }

  double get averagePercentage {
    final validResults = submittedResults;

    if (validResults.isEmpty) {
      return 0;
    }

    final percentagesTotal = validResults.fold<double>(
      0,
      (total, result) {
        return total + result.percentage;
      },
    );

    return percentagesTotal / validResults.length;
  }

  bool get isEmpty {
    return results.isEmpty;
  }

  bool get hasSubmittedResults {
    return submittedResults.isNotEmpty;
  }

  bool get hasInProgressResults {
    return inProgressResults.isNotEmpty;
  }
}