import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/edit_lesson_exam_question_cubit.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/edit_lesson_exam_question_state.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/edit_lesson_exam_question_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLessonExamQuestionScreen extends StatelessWidget {
  const EditLessonExamQuestionScreen({super.key, required this.question});

  final LessonExamQuestionEntity question;

  void _handleState(BuildContext context, EditLessonExamQuestionState state) {
    if (state is EditLessonExamQuestionSuccess) {
      _showSuccessDialog(context);
      return;
    }

    if (state is EditLessonExamQuestionFailure) {
      _showFailureDialog(context, message: state.error.message);
    }
  }

  Future<void> _showSuccessDialog(BuildContext screenContext) {
    return showDialog<void>(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.success,
          title: 'تم تعديل السؤال',
          message: 'تم حفظ تعديلات السؤال بنجاح.',
          actionText: 'العودة إلى الاختبار',
          onActionPressed: () {
            Navigator.of(dialogContext).pop();

            Navigator.of(screenContext).pop(true);
          },
        );
      },
    );
  }

  Future<void> _showFailureDialog(
    BuildContext screenContext, {
    required String message,
  }) {
    return showDialog<void>(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: 'تعذر تعديل السؤال',
          message: message,
          actionText: 'حاول مرة أخرى',
          onActionPressed: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        body: ContentManagementBackground(
          child: SafeArea(
            child: AppNetworkAwareContent(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppAnimations.screenSection(
                      delay: 0,
                      child: const SecondaryCustomHeaderBar(
                        title: 'تعديل السؤال',
                      ),
                    ),

                    verticalSpace(30),

                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 120,
                        child:
                            BlocConsumer<
                              EditLessonExamQuestionCubit,
                              EditLessonExamQuestionState
                            >(
                              listener: _handleState,
                              builder: (context, state) {
                                final isLoading =
                                    state is EditLessonExamQuestionLoading;

                                return EditLessonExamQuestionContent(
                                  question: question,
                                  isUpdatingQuestion: isLoading,
                                  onUpdateQuestionPressed:
                                      ({
                                        required questionText,
                                        required degree,
                                        required choices,
                                        newImage,
                                        required removeCurrentImage,
                                      }) {
                                        return context
                                            .read<EditLessonExamQuestionCubit>()
                                            .updateQuestion(
                                              lessonId: question.lessonId,
                                              questionId: question.questionId,
                                              questionText: questionText,
                                              degree: degree,
                                              choices: choices,
                                              newImage: newImage,
                                              removeCurrentImage:
                                                  removeCurrentImage,
                                            );
                                      },
                                );
                              },
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
