import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/use_case/create_lesson_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/add_lesson_exam_question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLessonExamQuestionCubit extends Cubit<AddLessonExamQuestionState> {
  AddLessonExamQuestionCubit({
    required CreateLessonExamQuestionUseCase createLessonExamQuestionUseCase,
  }) : _createLessonExamQuestionUseCase = createLessonExamQuestionUseCase,
       super(const AddLessonExamQuestionInitial());

  final CreateLessonExamQuestionUseCase _createLessonExamQuestionUseCase;

  bool get isSubmitting {
    return state is AddLessonExamQuestionLoading;
  }

  Future<void> addQuestion({
    required String lessonId,
    required String questionText,
    required int degree,
    required List<String> choices,
    LessonExamQuestionImageFile? image,
  }) async {
    if (isSubmitting) {
      return;
    }

    emit(const AddLessonExamQuestionLoading());

    final result = await _createLessonExamQuestionUseCase(
      lessonId: lessonId,
      questionText: questionText,
      degree: degree,
      choices: choices,
      image: image,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(AddLessonExamQuestionFailure(error: error));
      },
      (_) {
        emit(const AddLessonExamQuestionSuccess());
      },
    );
  }

  void reset() {
    if (isClosed || isSubmitting) {
      return;
    }

    emit(const AddLessonExamQuestionInitial());
  }
}
