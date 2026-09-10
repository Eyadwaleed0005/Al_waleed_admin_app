import 'package:alwaleed_admin/features/exams/domain/entities/exam_attempt_status.dart';

class ExamResultEntity {
  const ExamResultEntity({
    required this.resultId,
    required this.examId,
    required this.studentId,
    required this.studentName,
    required this.gradeId,
    required this.gradeName,
    required this.totalScore,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    this.score,
    this.submittedAt,
  });

  static const double minimumPassingPercentage = 50;

  final String resultId;
  final String examId;
  final String studentId;
  final String studentName;
  final String gradeId;
  final String gradeName;

  final int? score;
  final int totalScore;

  final ExamAttemptStatus status;

  final DateTime startedAt;
  final DateTime expiresAt;
  final DateTime? submittedAt;

  bool get isInProgress {
    return status == ExamAttemptStatus.inProgress;
  }

  bool get isSubmitted {
    return status == ExamAttemptStatus.submitted;
  }

  bool get hasScore {
    return score != null;
  }

  bool get hasValidScore {
    final int? currentScore = score;

    return currentScore != null &&
        currentScore >= 0 &&
        totalScore > 0 &&
        currentScore <= totalScore;
  }

  bool get isExpired {
    return !DateTime.now().isBefore(expiresAt);
  }

  bool get shouldAutoSubmit {
    return isInProgress && isExpired;
  }

  Duration get remainingDuration {
    if (isSubmitted || isExpired) {
      return Duration.zero;
    }

    return expiresAt.difference(DateTime.now());
  }

  double get percentage {
    if (!isSubmitted || !hasValidScore) {
      return 0;
    }

    return (score! / totalScore) * 100;
  }

  bool get isPassed {
    return isSubmitted &&
        hasValidScore &&
        percentage >= minimumPassingPercentage;
  }

  bool get isFailed {
    return isSubmitted &&
        hasValidScore &&
        percentage < minimumPassingPercentage;
  }

  ExamResultEntity copyWith({
    String? resultId,
    String? examId,
    String? studentId,
    String? studentName,
    String? gradeId,
    String? gradeName,
    int? score,
    int? totalScore,
    ExamAttemptStatus? status,
    DateTime? startedAt,
    DateTime? expiresAt,
    DateTime? submittedAt,
    bool clearScore = false,
    bool clearSubmittedAt = false,
  }) {
    return ExamResultEntity(
      resultId: resultId ?? this.resultId,
      examId: examId ?? this.examId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      gradeId: gradeId ?? this.gradeId,
      gradeName: gradeName ?? this.gradeName,
      score: clearScore ? null : score ?? this.score,
      totalScore: totalScore ?? this.totalScore,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      submittedAt: clearSubmittedAt ? null : submittedAt ?? this.submittedAt,
    );
  }
}
