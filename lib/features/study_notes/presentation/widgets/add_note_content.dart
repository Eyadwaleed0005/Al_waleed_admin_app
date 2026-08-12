import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_description_field.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_hint_card.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_options_section.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_pdf_picker.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_title_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteContent extends StatelessWidget {
  const AddNoteContent({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.grades,
    required this.selectedGradeId,
    required this.isPublished,
    required this.onGradeSelected,
    required this.onPublicationChanged,
    required this.onPdfSelected,
    required this.onPdfRemoved,
    required this.onAddNotePressed,
    this.isLoading = false,
    this.isButtonEnabled = true,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final List<GradeEntity> grades;
  final String selectedGradeId;
  final bool isPublished;

  final ValueChanged<String> onGradeSelected;
  final ValueChanged<bool> onPublicationChanged;

  final ValueChanged<PlatformFile> onPdfSelected;
  final VoidCallback onPdfRemoved;

  final VoidCallback onAddNotePressed;

  final bool isLoading;
  final bool isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                const AddNoteHintCard(),

                verticalSpace(24),

                AddNoteTitleField(controller: titleController),

                verticalSpace(18),

                AddNoteDescriptionField(controller: descriptionController),

                verticalSpace(20),

                AddNoteOptionsSection(
                  grades: grades,
                  selectedGradeId: selectedGradeId,
                  isPublished: isPublished,
                  onGradeSelected: onGradeSelected,
                  onPublicationChanged: onPublicationChanged,
                ),

                verticalSpace(20),

                AddNotePdfPicker(
                  onFileSelected: onPdfSelected,
                  onFileRemoved: onPdfRemoved,
                ),
              ],
            ),
          ),
        ),

        verticalSpace(16),

        SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 4.h),
          child: CustomButton(
            text: 'حفظ المذكرة',
            isLoading: isLoading,
            isEnabled: isButtonEnabled,
            onPressed: onAddNotePressed,
          ),
        ),
      ],
    );
  }
}
