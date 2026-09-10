import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admin/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admin/core/widgets/app_loading_indicator.dart';
import 'package:alwaleed_admin/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admin/core/widgets/custom_delete_confirmation_bottom_sheet.dart';
import 'package:alwaleed_admin/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admin/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_question_draft_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_questions_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_questions_state.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_questions_screen_widgets/exam_questions_actions.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_questions_screen_widgets/exam_questions_list_view.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_questions_screen_widgets/exam_total_degrees_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamQuestionsContent extends StatefulWidget {
  const ExamQuestionsContent({super.key, this.examId, this.examDraft});

  final String? examId;

  final ExamDraftEntity? examDraft;

  @override
  State<ExamQuestionsContent> createState() {
    return _ExamQuestionsContentState();
  }
}

class _ExamQuestionsContentState extends State<ExamQuestionsContent> {
  bool _isQuestionRouteOpen = false;

  bool _isResultDialogOpen = false;

  bool _isConfirmationOpen = false;

  bool _hasNavigatedAfterSave = false;

  bool get _canInteract {
    if (!mounted ||
        _isQuestionRouteOpen ||
        _isResultDialogOpen ||
        _isConfirmationOpen ||
        _hasNavigatedAfterSave) {
      return false;
    }

    final ExamQuestionsState state = context.read<ExamQuestionsCubit>().state;

    if (state is ExamQuestionsEmpty) {
      return widget.examDraft != null;
    }

    return state is ExamQuestionsSuccess &&
        state.canEdit &&
        !state.isOperating &&
        state.savedExamId == null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamQuestionsCubit, ExamQuestionsState>(
      listenWhen: _shouldListen,
      listener: _handleState,
      builder: (BuildContext context, ExamQuestionsState state) {
        final bool isOperating =
            state is ExamQuestionsSuccess && state.isOperating;

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
                            title: 'أسئلة الاختبار',
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

  bool _shouldListen(ExamQuestionsState previous, ExamQuestionsState current) {
    if (previous is! ExamQuestionsSuccess || current is! ExamQuestionsSuccess) {
      return false;
    }

    final bool operationFinished =
        previous.isOperating &&
        !current.isOperating &&
        current.operation != null;

    final bool hasResult =
        current.operationSucceeded || current.operationError != null;

    return operationFinished && hasResult;
  }

  Future<void> _handleState(
    BuildContext context,
    ExamQuestionsState state,
  ) async {
    if (state is! ExamQuestionsSuccess ||
        state.operation == null ||
        state.isOperating ||
        _isResultDialogOpen ||
        _hasNavigatedAfterSave) {
      return;
    }

    final ExamQuestionsOperation operation = state.operation!;

    final bool succeeded = state.operationSucceeded;

    final AppErrorModel? error = state.operationError;

    if (!succeeded && error == null) {
      return;
    }

    _isResultDialogOpen = true;

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
              title: succeeded
                  ? _getSuccessTitle(operation)
                  : _getFailureTitle(operation),
              message: succeeded
                  ? _getSuccessMessage(operation)
                  : error!.message,
              actionText:
                  operation == ExamQuestionsOperation.createExam && succeeded
                  ? 'العودة للاختبارات'
                  : 'حسنًا',
              successIcon: Icons.check_circle_outline_rounded,
              failureIcon: Icons.error_outline_rounded,
              onActionPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          );
        },
      );

      if (!mounted || confirmed != true) {
        return;
      }

      if (operation == ExamQuestionsOperation.createExam && succeeded) {
        _hasNavigatedAfterSave = true;

        Navigator.of(context).popUntil((Route<dynamic> route) {
          return route.settings.name == RouteNames.viewExamsScreen ||
              route.isFirst;
        });

        return;
      }

      final ExamQuestionsCubit cubit = context.read<ExamQuestionsCubit>();

      if (!cubit.isClosed) {
        cubit.clearOperationResult();
      }
    } finally {
      _isResultDialogOpen = false;
    }
  }

  String _getSuccessTitle(ExamQuestionsOperation operation) {
    return switch (operation) {
      ExamQuestionsOperation.createExam => 'تم إنشاء الاختبار',
      ExamQuestionsOperation.updateQuestion => 'تم تعديل السؤال',
      ExamQuestionsOperation.deleteQuestion => 'تم حذف السؤال',
      ExamQuestionsOperation.saveQuestionChanges => 'تم حفظ التعديلات',
    };
  }

  String _getFailureTitle(ExamQuestionsOperation operation) {
    return switch (operation) {
      ExamQuestionsOperation.createExam => 'تعذر إنشاء الاختبار',
      ExamQuestionsOperation.updateQuestion => 'تعذر تعديل السؤال',
      ExamQuestionsOperation.deleteQuestion => 'تعذر حذف السؤال',
      ExamQuestionsOperation.saveQuestionChanges => 'تعذر حفظ التعديلات',
    };
  }

  String _getSuccessMessage(ExamQuestionsOperation operation) {
    return switch (operation) {
      ExamQuestionsOperation.createExam => 'تم حفظ الاختبار وأسئلته بنجاح.',
      ExamQuestionsOperation.updateQuestion => 'تم حفظ تعديلات السؤال بنجاح.',
      ExamQuestionsOperation.deleteQuestion =>
        'تم حذف السؤال وتحديث بيانات الاختبار بنجاح.',
      ExamQuestionsOperation.saveQuestionChanges =>
        'تم حفظ الإجابات الصحيحة للأسئلة بنجاح.',
    };
  }

  Widget _buildState(BuildContext context, ExamQuestionsState state) {
    return switch (state) {
      ExamQuestionsLoading() => const Center(
        child: AppLoadingIndicator(
          color: ColorPalette.primary,
          size: 32,
          strokeWidth: 3,
        ),
      ),
      ExamQuestionsEmpty() => _buildEmptyContent(),
      ExamQuestionsError(:final error) => AppErrorWidget(
        message: error.message,
        onRetry: context.read<ExamQuestionsCubit>().retry,
      ),
      ExamQuestionsSuccess() => _buildSuccessContent(state),
    };
  }

  Widget _buildEmptyContent() {
    final bool canAddQuestion =
        widget.examDraft != null &&
        !_isQuestionRouteOpen &&
        !_isResultDialogOpen &&
        !_isConfirmationOpen &&
        !_hasNavigatedAfterSave;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.screenSection(
          delay: 120,
          child: const ExamTotalDegreesCard(totalDegrees: 0),
        ),
        verticalSpace(20),
        Expanded(
          child: AppEmptyWidget(
            title: 'لا توجد أسئلة',
            message: 'لم تتم إضافة أي أسئلة إلى الاختبار حتى الآن.',
            actionText: canAddQuestion ? 'إضافة سؤال' : null,
            icon: Icons.help_outline_rounded,
            onActionPressed: canAddQuestion ? _openAddQuestionScreen : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(ExamQuestionsSuccess state) {
    final bool isEnabled =
        state.canEdit &&
        !state.isOperating &&
        state.savedExamId == null &&
        !_isQuestionRouteOpen &&
        !_isResultDialogOpen &&
        !_isConfirmationOpen &&
        !_hasNavigatedAfterSave;

    final bool isSaving = state.isSavingExam || state.isSavingChanges;

    final bool isSaveEnabled = state.isCreatingExam
        ? state.canSaveExam && isEnabled
        : state.canSaveChanges && isEnabled;

    final String saveButtonText = state.isCreatingExam
        ? 'حفظ الاختبار'
        : 'حفظ التعديلات';

    final String? deletingQuestionId = state.isDeletingQuestion
        ? state.operatingQuestionId
        : null;

    if (state.questions.isEmpty) {
      return _buildEmptySuccessContent(state: state);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppAnimations.screenSection(
            delay: 120,
            child: ExamTotalDegreesCard(totalDegrees: state.totalDegrees),
          ),
          verticalSpace(20),
          AppAnimations.screenSection(
            delay: 240,
            child: ExamQuestionsListView(
              questions: state.questions,
              selectedChoiceIndexes: state.selectedChoiceIndexes,
              questionImages: state.questionImages,
              showActions: state.canEdit,
              isEnabled: isEnabled,
              deletingQuestionId: deletingQuestionId,
              onChoiceSelected: _selectCorrectChoice,
              onEditQuestion: _editQuestion,
              onDeleteQuestion: _deleteQuestion,
            ),
          ),
          if (state.canEdit) ...[
            verticalSpace(24),
            AppAnimations.screenSection(
              delay: 360,
              child: ExamQuestionsActions(
                saveButtonText: saveButtonText,
                isSaving: isSaving,
                isSaveEnabled: isSaveEnabled,
                isAddQuestionEnabled: state.canAddQuestion && isEnabled,
                onSavePressed: _saveChanges,
                onAddQuestionPressed: _openAddQuestionScreen,
              ),
            ),
          ],
          verticalSpace(20),
        ],
      ),
    );
  }

  Widget _buildEmptySuccessContent({required ExamQuestionsSuccess state}) {
    final bool canAddQuestion =
        state.canAddQuestion &&
        !state.isOperating &&
        !_isQuestionRouteOpen &&
        !_isResultDialogOpen &&
        !_isConfirmationOpen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.screenSection(
          delay: 120,
          child: const ExamTotalDegreesCard(totalDegrees: 0),
        ),
        verticalSpace(20),
        Expanded(
          child: AppEmptyWidget(
            title: 'لا توجد أسئلة',
            message: 'لم تتم إضافة أي أسئلة إلى الاختبار حتى الآن.',
            actionText: canAddQuestion ? 'إضافة سؤال' : null,
            icon: Icons.help_outline_rounded,
            onActionPressed: canAddQuestion ? _openAddQuestionScreen : null,
          ),
        ),
      ],
    );
  }

  void _selectCorrectChoice(ExamQuestionEntity question, int choiceIndex) {
    if (!_canInteract) {
      return;
    }

    context.read<ExamQuestionsCubit>().selectCorrectChoice(
      questionId: question.questionId,
      choiceIndex: choiceIndex,
    );
  }

  Future<void> _editQuestion(ExamQuestionEntity question) async {
    if (!_canInteract) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final ExamQuestionsCubit cubit = context.read<ExamQuestionsCubit>();

    final ExamQuestionDraftEntity questionDraft = ExamQuestionDraftEntity(
      question: question,
      image: cubit.questionImages[question.questionId],
    );

    _setQuestionRouteOpen(true);

    try {
      final ExamQuestionDraftEntity? updatedQuestionDraft =
          await Navigator.of(context).pushNamed<ExamQuestionDraftEntity>(
            RouteNames.editExamQuestionScreen,
            arguments: questionDraft,
          );

      if (!mounted || cubit.isClosed || updatedQuestionDraft == null) {
        return;
      }

      if (updatedQuestionDraft.question.questionId != question.questionId) {
        return;
      }

      final bool hadCurrentImage =
          _hasRemoteImage(question) || questionDraft.image != null;

      final bool hasUpdatedRemoteImage = _hasRemoteImage(
        updatedQuestionDraft.question,
      );

      final bool removeCurrentImage =
          hadCurrentImage &&
          updatedQuestionDraft.image == null &&
          !hasUpdatedRemoteImage;

      await cubit.updateQuestion(
        question: updatedQuestionDraft.question,
        image: updatedQuestionDraft.image,
        removeCurrentImage: removeCurrentImage,
      );
    } finally {
      _setQuestionRouteOpen(false);
    }
  }

  bool _hasRemoteImage(ExamQuestionEntity question) {
    final String imageUrl = question.imageUrl?.trim() ?? '';

    final String imageStoragePath = question.imageStoragePath?.trim() ?? '';

    return imageUrl.isNotEmpty || imageStoragePath.isNotEmpty;
  }

  Future<void> _deleteQuestion(ExamQuestionEntity question) async {
    if (!_canInteract || _isConfirmationOpen) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    _isConfirmationOpen = true;

    bool confirmed = false;

    try {
      confirmed = await showCustomDeleteConfirmationBottomSheet(
        context,
        title: 'حذف السؤال',
        message:
            'سيتم حذف هذا السؤال وصورته نهائيًا، '
            'كما سيتم تحديث عدد الأسئلة والدرجة الكلية للاختبار. '
            'هل تريد المتابعة؟',
        confirmText: 'حذف السؤال',
        cancelText: 'إلغاء',
      );
    } finally {
      _isConfirmationOpen = false;
    }

    if (!mounted || !confirmed || !_canInteract) {
      return;
    }

    await context.read<ExamQuestionsCubit>().deleteQuestion(
      questionId: question.questionId,
    );
  }

  Future<void> _saveChanges() async {
    if (!_canInteract) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    await context.read<ExamQuestionsCubit>().saveChanges();
  }

  Future<void> _openAddQuestionScreen() async {
    if (!_canInteract) {
      return;
    }

    final ExamQuestionsCubit cubit = context.read<ExamQuestionsCubit>();

    final ExamDraftEntity? currentExamDraft = cubit.currentExamDraft;

    if (currentExamDraft == null) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    _setQuestionRouteOpen(true);

    try {
      final ExamQuestionDraftEntity? questionDraft = await Navigator.of(context)
          .pushNamed<ExamQuestionDraftEntity>(
            RouteNames.addExamQuestionsScreen,
            arguments: currentExamDraft,
          );

      if (!mounted || cubit.isClosed || questionDraft == null) {
        return;
      }

      cubit.addQuestion(
        question: questionDraft.question,
        image: questionDraft.image,
      );
    } finally {
      _setQuestionRouteOpen(false);
    }
  }

  void _setQuestionRouteOpen(bool value) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isQuestionRouteOpen = value;
    });
  }
}
