import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class CreateExamUseCase {
  const CreateExamUseCase({
    required ExamsRepository examsRepository,
  }) : _examsRepository = examsRepository;

  final ExamsRepository _examsRepository;

  Future<Either<AppErrorModel, String>> call({
    required ExamDraftEntity examDraft,
    required List<ExamQuestionEntity> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) {
    return _examsRepository.createExam(
      examDraft: examDraft,
      questions: List<ExamQuestionEntity>.unmodifiable(
        questions,
      ),
      questionImages:
          Map<String, ExamQuestionImageFile>.unmodifiable(
            questionImages,
          ),
    );
  }
}