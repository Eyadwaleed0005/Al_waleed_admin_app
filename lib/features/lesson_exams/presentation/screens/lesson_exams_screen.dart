import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/lesson_exams_cubit.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/lesson_exams_state.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exams_content.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exams_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonExamsScreen extends StatelessWidget {
  const LessonExamsScreen({super.key, required this.lessonId});

  final String lessonId;

  void _openAddQuestionScreen(BuildContext context) {
    if (context.read<LessonExamsCubit>().state.isActionInProgress) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamed(RouteNames.addLessonExamQuestionScreen, arguments: lessonId);
  }

  Future<void> _openEditQuestionScreen({
    required BuildContext context,
    required LessonExamQuestionEntity question,
  }) async {
    final cubit = context.read<LessonExamsCubit>();

    if (cubit.state.isActionInProgress) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isUpdated = await Navigator.of(context).pushNamed<bool>(
      RouteNames.editLessonExamQuestionScreen,
      arguments: question,
    );

    if (!context.mounted || isUpdated != true) {
      return;
    }

    context.read<LessonExamsCubit>().retry();
  }

  Future<void> _confirmDeleteQuestion({
    required BuildContext context,
    required LessonExamQuestionEntity question,
  }) async {
    final cubit = context.read<LessonExamsCubit>();

    if (cubit.state.isActionInProgress) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final questionText = question.questionText.trim();

    final message = questionText.isNotEmpty
        ? 'هل أنت متأكد من حذف السؤال "$questionText"؟ '
              'سيتم حذف السؤال وصورته إن وجدت، '
              'ولا يمكن التراجع عن هذه العملية.'
        : 'هل أنت متأكد من حذف هذا السؤال؟ '
              'سيتم حذف السؤال وصورته إن وجدت، '
              'ولا يمكن التراجع عن هذه العملية.';

    final confirmed = await showCustomDeleteConfirmationBottomSheet(
      context,
      title: 'حذف السؤال',
      message: message,
      confirmText: 'حذف السؤال',
      cancelText: 'إلغاء',
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    context.read<LessonExamsCubit>().deleteQuestion(
      questionId: question.questionId,
    );
  }

  void _handleActionState(BuildContext context, LessonExamsState state) {
    if (state.hasActionSuccess) {
      _showSuccessDialog(context, actionType: state.actionType);

      return;
    }

    if (state.hasActionFailure) {
      final error = state.actionError;

      if (error == null) {
        return;
      }

      _showFailureDialog(
        context,
        actionType: state.actionType,
        message: error.message,
      );
    }
  }

  Future<void> _showSuccessDialog(
    BuildContext screenContext, {
    required LessonExamsActionType actionType,
  }) {
    final isDeleting = actionType == LessonExamsActionType.deleteQuestion;

    return showDialog<void>(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.success,
          title: isDeleting ? 'تم حذف السؤال' : 'تم حفظ التعديلات',
          message: isDeleting
              ? 'تم حذف السؤال من اختبار الدرس بنجاح.'
              : 'تم حفظ الإجابات الصحيحة بنجاح.',
          actionText: 'حسنًا',
          onActionPressed: () {
            Navigator.of(dialogContext).pop();

            if (screenContext.mounted) {
              screenContext.read<LessonExamsCubit>().clearActionFeedback();
            }
          },
        );
      },
    );
  }

  Future<void> _showFailureDialog(
    BuildContext screenContext, {
    required LessonExamsActionType actionType,
    required String message,
  }) {
    final isDeleting = actionType == LessonExamsActionType.deleteQuestion;

    return showDialog<void>(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: isDeleting ? 'تعذر حذف السؤال' : 'تعذر حفظ التعديلات',
          message: message,
          actionText: 'حسنًا',
          onActionPressed: () {
            Navigator.of(dialogContext).pop();

            if (screenContext.mounted) {
              screenContext.read<LessonExamsCubit>().clearActionFeedback();
            }
          },
        );
      },
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required LessonExamsState state,
  }) {
    if (state.isInitial || state.isPageLoading) {
      return const LessonExamsLoadingSkeleton();
    }

    if (state.hasPageFailure) {
      final error = state.pageError;

      if (error == null) {
        return const SizedBox.shrink();
      }

      return AppErrorWidget(
        message: error.message,
        onRetry: () {
          context.read<LessonExamsCubit>().retry();
        },
      );
    }

    if (state.isPageReady && !state.hasQuestions) {
      return AppEmptyWidget(
        title: 'لا توجد أسئلة',
        message: 'لم تتم إضافة أي أسئلة لاختبار هذا الدرس حتى الآن.',
        actionText: 'إضافة سؤال',
        icon: Icons.quiz_outlined,
        onActionPressed: () {
          _openAddQuestionScreen(context);
        },
      );
    }

    if (state.isPageReady) {
      return LessonExamsContent(
        state: state,

        onChoiceSelected: (question, choiceIndex) {
          context.read<LessonExamsCubit>().selectCorrectChoice(
            questionId: question.questionId,
            choiceIndex: choiceIndex,
          );
        },

        onEditQuestion: (question) {
          _openEditQuestionScreen(context: context, question: question);
        },

        onDeleteQuestion: (question) {
          _confirmDeleteQuestion(context: context, question: question);
        },

        onSaveExamPressed: () {
          context.read<LessonExamsCubit>().saveAnswers();
        },

        onAddQuestionPressed: () {
          _openAddQuestionScreen(context);
        },
      );
    }

    return const SizedBox.shrink();
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
                        title: 'اختبارات الدرس',
                      ),
                    ),

                    verticalSpace(30),

                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 120,
                        child: BlocConsumer<LessonExamsCubit, LessonExamsState>(
                          listenWhen: (previous, current) {
                            return previous.actionStatus !=
                                    current.actionStatus &&
                                (current.hasActionSuccess ||
                                    current.hasActionFailure);
                          },
                          listener: _handleActionState,
                          builder: (context, state) {
                            return _buildBody(context: context, state: state);
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
