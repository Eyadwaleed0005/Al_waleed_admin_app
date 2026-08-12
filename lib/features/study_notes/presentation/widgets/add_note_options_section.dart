import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/grade_popup_menu_field.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/note_publication_switch.dart';
import 'package:flutter/material.dart';

class AddNoteOptionsSection extends StatelessWidget {
  const AddNoteOptionsSection({
    super.key,
    required this.grades,
    required this.selectedGradeId,
    required this.isPublished,
    required this.onGradeSelected,
    required this.onPublicationChanged,
  });

  final List<GradeEntity> grades;
  final String selectedGradeId;
  final bool isPublished;

  final ValueChanged<String> onGradeSelected;
  final ValueChanged<bool> onPublicationChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: NotePublicationSwitch(
            isPublished: isPublished,
            onChanged: onPublicationChanged,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          flex: 5,
          child: GradePopupMenuField(
            grades: grades,
            selectedGradeId: selectedGradeId,
            placeholderText: 'الصف الدراسي',
            tooltip: 'اختيار الصف الدراسي',
            emptyTooltip: 'لا توجد صفوف متاحة حاليًا',
            includeAllOption: false,
            onGradeSelected: onGradeSelected,
          ),
        ),
      ],
    );
  }
}
