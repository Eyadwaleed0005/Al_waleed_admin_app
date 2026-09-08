import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/update_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/edit_exam_question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExamQuestionCubit
    extends Cubit<EditExamQuestionState> {
  EditExamQuestionCubit({
    required ExamQuestionDraftEntity questionDraft,
    required UpdateExamQuestionUseCase
    updateExamQuestionUseCase,
  }) : _originalQuestionDraft = questionDraft,
       _updateExamQuestionUseCase =
           updateExamQuestionUseCase,
       super(const EditExamQuestionInitial());

  final ExamQuestionDraftEntity
  _originalQuestionDraft;

  final UpdateExamQuestionUseCase
  _updateExamQuestionUseCase;

  bool get _isSavedQuestion {
    return _originalQuestionDraft
        .question
        .examId
        .trim()
        .isNotEmpty;
  }

  Future<void> updateQuestion({
    required String questionText,
    required int degree,
    required List<String> choices,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) async {
    if (isClosed ||
        state is EditExamQuestionLoading) {
      return;
    }

    final String normalizedQuestionText =
        questionText.trim();

    final List<String> normalizedChoices =
        choices.map(
      (String choice) {
        return choice.trim();
      },
    ).toList(growable: false);

    if (normalizedQuestionText.isEmpty ||
        degree <= 0 ||
        normalizedChoices.length != 4 ||
        normalizedChoices.any(
          (String choice) => choice.isEmpty,
        )) {
      return;
    }

    emit(const EditExamQuestionLoading());

    ExamQuestionEntity updatedQuestion =
        _originalQuestionDraft.question.copyWith(
      questionText: normalizedQuestionText,
      degree: degree,
      choices: List<String>.unmodifiable(
        normalizedChoices,
      ),
    );

    if (removeCurrentImage || newImage != null) {
      updatedQuestion = updatedQuestion.copyWith(
        clearImage: true,
      );
    }

    final ExamQuestionImageFile? updatedImage =
        removeCurrentImage
            ? null
            : newImage ??
                _originalQuestionDraft.image;

    final ExamQuestionDraftEntity updatedDraft =
        ExamQuestionDraftEntity(
      question: updatedQuestion,
      image: updatedImage,
    );

    if (!_isSavedQuestion) {
      if (!isClosed) {
        emit(
          EditExamQuestionSuccess(
            questionDraft: updatedDraft,
          ),
        );
      }

      return;
    }

    try {
      final result =
          await _updateExamQuestionUseCase(
        question: updatedQuestion,
        newImage: newImage,
        removeCurrentImage:
            removeCurrentImage,
      );

      if (isClosed) {
        return;
      }

      result.fold(
        (AppErrorModel error) {
          emit(
            EditExamQuestionFailure(
              error: error,
            ),
          );
        },
        (_) {
          emit(
            EditExamQuestionSuccess(
              questionDraft: updatedDraft,
            ),
          );
        },
      );
    } catch (error) {
      if (!isClosed) {
        emit(
          EditExamQuestionFailure(
            error:
                FirebaseErrorHandler.handle(error),
          ),
        );
      }
    }
  }
}