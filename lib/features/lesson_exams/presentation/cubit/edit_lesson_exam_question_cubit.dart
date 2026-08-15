import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/use_case/update_lesson_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/edit_lesson_exam_question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLessonExamQuestionCubit extends Cubit<EditLessonExamQuestionState> {
  EditLessonExamQuestionCubit(this._updateLessonExamQuestionUseCase)
    : super(const EditLessonExamQuestionInitial());

  final UpdateLessonExamQuestionUseCase _updateLessonExamQuestionUseCase;

  Future<void> updateQuestion({
    required String lessonId,
    required String questionId,
    required String questionText,
    required int degree,
    required List<String> choices,
    LessonExamQuestionImageFile? newImage,
    bool removeCurrentImage = false,
  }) async {
    if (state is EditLessonExamQuestionLoading) {
      return;
    }

    emit(const EditLessonExamQuestionLoading());

    final result = await _updateLessonExamQuestionUseCase(
      lessonId: lessonId,
      questionId: questionId,
      questionText: questionText,
      degree: degree,
      choices: choices,
      newImage: newImage,
      removeCurrentImage: removeCurrentImage,
    );

    result.fold(
      (error) {
        emit(EditLessonExamQuestionFailure(error: error));
      },
      (_) {
        emit(const EditLessonExamQuestionSuccess());
      },
    );
  }
}
