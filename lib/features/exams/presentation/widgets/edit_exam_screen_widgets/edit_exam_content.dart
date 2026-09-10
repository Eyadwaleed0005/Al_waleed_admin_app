import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admin/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admin/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admin/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admin/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/edit_exam_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/edit_exam_state.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/edit_exam_screen_widgets/edit_exam_form.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/edit_exam_screen_widgets/edit_exam_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditExamContent extends StatefulWidget {
  const EditExamContent({super.key});

  @override
  State<EditExamContent> createState() {
    return _EditExamContentState();
  }
}

class _EditExamContentState extends State<EditExamContent> {
  bool _isDialogOpen = false;
  bool _isQuestionsRouteOpen = false;
  bool _hasFinished = false;

  bool get _canAct {
    if (!mounted || _isDialogOpen || _isQuestionsRouteOpen || _hasFinished) {
      return false;
    }

    final EditExamState state = context.read<EditExamCubit>().state;

    return state is EditExamReady &&
        !state.isOperating &&
        !state.operationSucceeded;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditExamCubit, EditExamState>(
      listenWhen: _shouldListen,
      listener: _showOperationResult,
      builder: (BuildContext context, EditExamState state) {
        final bool isOperating = state is EditExamReady && state.isOperating;

        return PopScope(
          canPop: !isOperating,
          child: AbsorbPointer(
            absorbing: isOperating,
            child: Scaffold(
              body: ContentManagementBackground(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppAnimations.screenSection(
                          delay: 0,
                          child: const SecondaryCustomHeaderBar(
                            title: 'تعديل الاختبار',
                          ),
                        ),
                        verticalSpace(30),
                        Expanded(child: _buildState(context, state)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _shouldListen(EditExamState previous, EditExamState current) {
    return previous is EditExamReady &&
        previous.isOperating &&
        current is EditExamReady &&
        !current.isOperating &&
        (current.operationSucceeded || current.operationError != null);
  }

  Widget _buildState(BuildContext context, EditExamState state) {
    return switch (state) {
      EditExamLoading() => const EditExamLoadingSkeleton(),

      EditExamError(:final error) => AppErrorWidget(
        message: error.message,
        onRetry: context.read<EditExamCubit>().retry,
      ),

      EditExamReady() => AppAnimations.screenSection(
        delay: 120,
        child: EditExamForm(
          key: ValueKey<String>(state.exam.examId),
          exam: state.exam,
          grades: state.grades,
          canCloseExam: state.canClose,
          isSavingChanges:
              state.isOperating && state.operation == EditExamOperation.save,
          isClosingExam:
              state.isOperating && state.operation == EditExamOperation.close,
          isDeletingExam:
              state.isOperating && state.operation == EditExamOperation.delete,
          onSaveChangesPressed:
              ({
                required String examName,
                required String gradeId,
                required int durationMinutes,
                required bool isPublished,
              }) {
                if (!_canAct) {
                  return;
                }

                context.read<EditExamCubit>().saveChanges(
                  examName: examName,
                  gradeId: gradeId,
                  durationMinutes: durationMinutes,
                  isPublished: isPublished,
                );
              },
          onOpenQuestionsPressed: _openQuestions,
          onCloseExamPressed: _confirmClose,
          onDeleteExamPressed: _confirmDelete,
        ),
      ),
    };
  }

  Future<void> _showOperationResult(
    BuildContext context,
    EditExamState state,
  ) async {
    if (state is! EditExamReady ||
        state.operation == null ||
        _isDialogOpen ||
        _hasFinished) {
      return;
    }

    final bool succeeded = state.operationSucceeded;
    final error = state.operationError;

    if (!succeeded && error == null) {
      return;
    }

    final String successMessage = switch (state.operation!) {
      EditExamOperation.save => 'تم حفظ تعديلات الاختبار بنجاح.',
      EditExamOperation.close => 'تم إغلاق الاختبار بنجاح.',
      EditExamOperation.delete =>
        'تم حذف الاختبار وأسئلته وصوره ومحاولات الطلاب ونتائجهم بنجاح.',
    };

    _isDialogOpen = true;

    try {
      await WidgetsBinding.instance.endOfFrame;

      if (!mounted) {
        return;
      }

      final bool? confirmed = await showDialog<bool>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return PopScope(
            canPop: false,
            child: CustomOperationResultDialog(
              type: succeeded
                  ? CustomOperationResultType.success
                  : CustomOperationResultType.failure,
              title: succeeded ? 'تمت العملية بنجاح' : 'تعذر إتمام العملية',
              message: succeeded ? successMessage : error!.message,
              actionText: succeeded ? 'العودة' : 'العودة للتعديل',
              onActionPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          );
        },
      );

      if (!mounted || !succeeded || confirmed != true) {
        return;
      }

      _hasFinished = true;

      Navigator.of(context).pop();
    } finally {
      _isDialogOpen = false;
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String actionText,
  }) async {
    if (!mounted || _isDialogOpen) {
      return false;
    }

    _isDialogOpen = true;

    try {
      return await showCustomDeleteConfirmationBottomSheet(
        context,
        title: title,
        message: message,
        confirmText: actionText,
        cancelText: 'إلغاء',
      );
    } finally {
      _isDialogOpen = false;
    }
  }

  Future<void> _confirmClose() async {
    if (!_canAct) {
      return;
    }

    final EditExamCubit cubit = context.read<EditExamCubit>();
    final EditExamState currentState = cubit.state;

    if (currentState is! EditExamReady || !currentState.canClose) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool confirmed = await _confirm(
      title: 'إغلاق الاختبار',
      message:
          'هل تريد إغلاق الاختبار؟ '
          'لن يتمكن طلاب جدد من بدء الاختبار، '
          'وسيتمكن الطلاب الذين بدأوه بالفعل '
          'من إكمال محاولاتهم.',
      actionText: 'إغلاق الاختبار',
    );

    if (!mounted || !confirmed || cubit.isClosed || !_canAct) {
      return;
    }

    await cubit.closeExam();
  }

  Future<void> _confirmDelete() async {
    if (!_canAct) {
      return;
    }

    final EditExamCubit cubit = context.read<EditExamCubit>();
    final EditExamState currentState = cubit.state;

    if (currentState is! EditExamReady) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool confirmed = await _confirm(
      title: 'حذف الاختبار',
      message: currentState.exam.isEnded
          ? 'سيتم حذف الاختبار وأسئلته وصوره ومحاولات الطلاب '
                'ونتائجهم نهائيًا، ولا يمكن التراجع عن هذه العملية. '
                'هل تريد المتابعة؟'
          : 'سيتم حذف الاختبار وأسئلته وصوره نهائيًا. '
                'إذا بدأ طالب واحد على الأقل الاختبار، '
                'فلن يُسمح بحذفه قبل إغلاقه. '
                'هل تريد المتابعة؟',
      actionText: 'حذف الاختبار',
    );

    if (!mounted || !confirmed || cubit.isClosed || !_canAct) {
      return;
    }

    await cubit.deleteExam();
  }

  Future<void> _openQuestions() async {
    if (!_canAct) {
      return;
    }

    final EditExamCubit cubit = context.read<EditExamCubit>();
    final EditExamState currentState = cubit.state;

    if (currentState is! EditExamReady) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    _isQuestionsRouteOpen = true;

    try {
      await Navigator.of(context).pushNamed(
        RouteNames.examQuestionsScreen,
        arguments: currentState.exam.examId,
      );
    } finally {
      _isQuestionsRouteOpen = false;
    }
  }
}
