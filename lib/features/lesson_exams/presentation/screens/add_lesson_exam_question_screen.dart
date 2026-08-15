import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/add_lesson_exam_question_cubit.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/add_lesson_exam_question_state.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/add_lesson_exam_question_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLessonExamQuestionScreen extends StatelessWidget {
  const AddLessonExamQuestionScreen({super.key, required this.lessonId});

  final String lessonId;

  void _handleState(BuildContext context, AddLessonExamQuestionState state) {
    if (state is AddLessonExamQuestionSuccess) {
      _showSuccessDialog(context);
      return;
    }

    if (state is AddLessonExamQuestionFailure) {
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
          title: 'تمت إضافة السؤال',
          message: 'تمت إضافة السؤال إلى اختبار الدرس بنجاح.',
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
          title: 'تعذر إضافة السؤال',
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
                        title: 'إضافة سؤال',
                      ),
                    ),
                    verticalSpace(30),
                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 120,
                        child:
                            BlocConsumer<
                              AddLessonExamQuestionCubit,
                              AddLessonExamQuestionState
                            >(
                              listener: _handleState,
                              builder: (context, state) {
                                final isLoading =
                                    state is AddLessonExamQuestionLoading;

                                return AddLessonExamQuestionContent(
                                  isAddingQuestion: isLoading,
                                  onAddQuestionPressed:
                                      ({
                                        required questionText,
                                        required degree,
                                        required choices,
                                        image,
                                      }) {
                                        return context
                                            .read<AddLessonExamQuestionCubit>()
                                            .addQuestion(
                                              lessonId: lessonId,
                                              questionText: questionText,
                                              degree: degree,
                                              choices: choices,
                                              image: image,
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
