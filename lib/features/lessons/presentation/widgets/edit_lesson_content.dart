import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_button.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_card.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_state.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_fields.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/add_lesson_options_section.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/edit_lesson_pdf_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLessonContent extends StatefulWidget {
  const EditLessonContent({
    super.key,
    required this.state,
    required this.onDeletePressed,
    required this.onCreateExamPressed,
    required this.onEditExamPressed,
  });

  final EditLessonState state;
  final VoidCallback onDeletePressed;
  final ValueChanged<String> onCreateExamPressed;
  final ValueChanged<String> onEditExamPressed;

  @override
  State<EditLessonContent> createState() {
    return _EditLessonContentState();
  }
}

class _EditLessonContentState extends State<EditLessonContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _youtubeUrlController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.state.title);

    _subtitleController = TextEditingController(text: widget.state.subtitle);

    _youtubeUrlController = TextEditingController(
      text: widget.state.youtubeUrl,
    );
  }

  @override
  void didUpdateWidget(covariant EditLessonContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldLessonId = oldWidget.state.lesson?.lessonId;
    final newLessonId = widget.state.lesson?.lessonId;

    if (oldLessonId != newLessonId) {
      _titleController.text = widget.state.title;
      _subtitleController.text = widget.state.subtitle;
      _youtubeUrlController.text = widget.state.youtubeUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _youtubeUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final lesson = state.lesson;

    if (lesson == null) {
      return const SizedBox.shrink();
    }

    final cubit = context.read<EditLessonCubit>();
    final fieldsEnabled = !state.isActionInProgress;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppAnimations.formFieldEntrance(
                    order: 0,
                    child: AddLessonTitleField(
                      controller: _titleController,
                      onChanged: cubit.changeTitle,
                      enabled: fieldsEnabled,
                    ),
                  ),

                  verticalSpace(18),

                  AppAnimations.formFieldEntrance(
                    order: 1,
                    child: AddLessonSubtitleField(
                      controller: _subtitleController,
                      onChanged: cubit.changeSubtitle,
                      enabled: fieldsEnabled,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 2,
                    child: AddLessonOptionsSection(
                      grades: state.grades,
                      selectedGradeId: state.selectedGradeId,
                      isPublished: state.isPublished,
                      onGradeSelected: cubit.selectGrade,
                      onPublicationChanged: cubit.changePublicationStatus,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 3,
                    child: AddLessonYoutubeUrlField(
                      controller: _youtubeUrlController,
                      onChanged: cubit.changeYoutubeUrl,
                      enabled: fieldsEnabled,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 4,
                    child: EditLessonPdfPicker(
                      existingFileName: lesson.pdfFileName?.trim() ?? '',
                      existingFileSize: lesson.pdfFileSize ?? 0,
                      replacementPdf: state.replacementPdf,
                      onReplacementSelected: cubit.selectReplacementPdf,
                      onReplacementRemoved: cubit.removeReplacementPdf,
                    ),
                  ),

                  verticalSpace(20),

                  AppAnimations.formFieldEntrance(
                    order: 5,
                    child: LessonExamCard(
                      hasExam: false,
                      isEnabled: fieldsEnabled,
                      onCreateExam: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        widget.onCreateExamPressed(lesson.lessonId);
                      },
                      onEditExam: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        widget.onEditExamPressed(lesson.lessonId);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          verticalSpace(16),

          SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppAnimations.screenSection(
                  delay: 360,
                  child: CustomButton(
                    text: 'حفظ التعديلات',
                    isLoading: state.isUpdating,
                    isEnabled: state.canUpdate,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      final isFormValid =
                          _formKey.currentState?.validate() ?? false;

                      if (!isFormValid) {
                        return;
                      }

                      cubit.updateLesson();
                    },
                  ),
                ),

                verticalSpace(12),

                AppAnimations.screenSection(
                  delay: 420,
                  child: CustomDeleteButton(
                    text: 'حذف الدرس',
                    icon: Icons.delete_outline_rounded,
                    isLoading: state.isDeleting,
                    isEnabled: state.canDelete,
                    onPressed: widget.onDeletePressed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
