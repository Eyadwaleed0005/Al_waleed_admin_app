import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_button.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_state.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_description_field.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_options_section.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_title_field.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/edit_note_pdf_picker.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/note_last_update_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditNoteContent extends StatefulWidget {
  const EditNoteContent({
    super.key,
    required this.state,
    required this.onDeletePressed,
  });

  final EditNoteState state;
  final VoidCallback onDeletePressed;

  @override
  State<EditNoteContent> createState() {
    return _EditNoteContentState();
  }
}

class _EditNoteContentState extends State<EditNoteContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.state.title);

    _descriptionController = TextEditingController(
      text: widget.state.description,
    );
  }

  @override
  void didUpdateWidget(covariant EditNoteContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldNoteId = oldWidget.state.note?.noteId;
    final newNoteId = widget.state.note?.noteId;

    if (oldNoteId != newNoteId) {
      _titleController.text = widget.state.title;
      _descriptionController.text = widget.state.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<EditNoteCubit>();
    final note = state.note;

    if (note == null) {
      return const SizedBox.shrink();
    }

    final lastUpdatedAt = note.updatedAt ?? note.createdAt;

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
                  if (lastUpdatedAt != null) ...[
                    AppAnimations.screenSection(
                      delay: 0,
                      child: NoteLastUpdateCard(
                        lastUpdatedAt: lastUpdatedAt,
                        label: 'تم رفع الملف الحالي في',
                      ),
                    ),
                    verticalSpace(24),
                  ],
                  AppAnimations.formFieldEntrance(
                    order: 0,
                    child: AddNoteTitleField(
                      controller: _titleController,
                      onChanged: cubit.changeTitle,
                    ),
                  ),
                  verticalSpace(18),
                  AppAnimations.formFieldEntrance(
                    order: 1,
                    child: AddNoteDescriptionField(
                      controller: _descriptionController,
                      onChanged: cubit.changeDescription,
                    ),
                  ),
                  verticalSpace(20),
                  AppAnimations.formFieldEntrance(
                    order: 2,
                    child: AddNoteOptionsSection(
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
                    child: EditNotePdfPicker(
                      existingFileName: note.pdfFileName,
                      existingFileSize: note.pdfFileSize,
                      replacementPdf: state.replacementPdf,
                      onReplacementSelected: cubit.selectReplacementPdf,
                      onReplacementRemoved: cubit.removeReplacementPdf,
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
                      cubit.updateNote();
                    },
                  ),
                ),
                verticalSpace(12),
                AppAnimations.screenSection(
                  delay: 420,
                  child: CustomDeleteButton(
                    text: 'حذف المذكرة',
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
