import 'package:alwaleed_admin/features/exams/domain/entities/exam_question_entity.dart';

enum ExamStatus { unpublished, published, ended }

class ExamEntity {
  const ExamEntity({
    required this.examId,
    required this.gradeId,
    required this.examName,
    required this.durationMinutes,
    required this.questionCount,
    required this.totalScore,
    required this.status,
    required this.questions,
    this.participantsCount = 0,
    this.firstAttemptAt,
    this.closedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String examId;
  final String gradeId;
  final String examName;

  final int durationMinutes;
  final int questionCount;
  final int totalScore;
  final int participantsCount;

  final ExamStatus status;

  final List<ExamQuestionEntity> questions;

  final DateTime? firstAttemptAt;
  final DateTime? closedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasQuestions {
    return questionCount > 0 || questions.isNotEmpty;
  }

  bool get hasParticipants {
    return participantsCount > 0;
  }

  bool get isUnpublished {
    return status == ExamStatus.unpublished;
  }

  bool get isPublished {
    return status == ExamStatus.published;
  }

  bool get isEnded {
    return status == ExamStatus.ended;
  }

  bool get hasStartedAttempts {
    return firstAttemptAt != null || participantsCount > 0;
  }

  bool get canEditSettings {
    return !isEnded && !hasStartedAttempts;
  }

  bool get canEditQuestions {
    return !isEnded && !hasStartedAttempts;
  }

  bool get canEditDuration {
    return canEditSettings;
  }

  bool get canEditGrade {
    return canEditSettings;
  }

  bool get canEditName {
    return canEditSettings;
  }

  bool get canChangePublicationStatus {
    return !isEnded && !hasStartedAttempts;
  }

  bool get canDelete {
    return !isEnded && !hasStartedAttempts;
  }

  bool get canViewResults {
    return isEnded;
  }

  bool get hasQuestionsWithoutCorrectAnswer {
    return questions.any((ExamQuestionEntity question) {
      return !question.hasCorrectChoice;
    });
  }

  bool get allQuestionsHaveCorrectAnswers {
    return questions.isNotEmpty &&
        questions.every((ExamQuestionEntity question) {
          return question.hasCorrectChoice;
        });
  }

  bool get canPublish {
    return isUnpublished &&
        !hasStartedAttempts &&
        questions.isNotEmpty &&
        allQuestionsHaveCorrectAnswers;
  }

  bool get canEnd {
    return isPublished;
  }

  ExamEntity copyWith({
    String? examId,
    String? gradeId,
    String? examName,
    int? durationMinutes,
    int? questionCount,
    int? totalScore,
    int? participantsCount,
    ExamStatus? status,
    List<ExamQuestionEntity>? questions,
    DateTime? firstAttemptAt,
    DateTime? closedAt,
    bool clearFirstAttemptAt = false,
    bool clearClosedAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExamEntity(
      examId: examId ?? this.examId,
      gradeId: gradeId ?? this.gradeId,
      examName: examName ?? this.examName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      questionCount: questionCount ?? this.questionCount,
      totalScore: totalScore ?? this.totalScore,
      participantsCount: participantsCount ?? this.participantsCount,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      firstAttemptAt: clearFirstAttemptAt
          ? null
          : firstAttemptAt ?? this.firstAttemptAt,
      closedAt: clearClosedAt ? null : closedAt ?? this.closedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ExamEntity.empty({required String examId}) {
    return ExamEntity(
      examId: examId,
      gradeId: '',
      examName: '',
      durationMinutes: 0,
      questionCount: 0,
      totalScore: 0,
      participantsCount: 0,
      status: ExamStatus.unpublished,
      questions: const <ExamQuestionEntity>[],
    );
  }
}
