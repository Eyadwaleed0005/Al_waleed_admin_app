import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';

class ExamDraftEntity {
  const ExamDraftEntity({
    required this.examName,
    required this.gradeId,
    required this.durationMinutes,
    required this.status,
  }) : assert(
         status != ExamStatus.ended,
         'A new exam draft cannot have an ended status.',
       );

  final String examName;
  final String gradeId;
  final int durationMinutes;
  final ExamStatus status;

  bool get isPublished {
    return status == ExamStatus.published;
  }

  bool get isUnpublished {
    return status == ExamStatus.unpublished;
  }

  ExamDraftEntity copyWith({
    String? examName,
    String? gradeId,
    int? durationMinutes,
    ExamStatus? status,
  }) {
    return ExamDraftEntity(
      examName: examName ?? this.examName,
      gradeId: gradeId ?? this.gradeId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
    );
  }
}
