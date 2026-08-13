import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/lesson_publication_switch.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/grade_popup_menu_field.dart';
import 'package:flutter/material.dart';

class AddLessonOptionsSection extends StatelessWidget {
  const AddLessonOptionsSection({
    super.key,
    required this.grades,
    required this.selectedGradeId,
    required this.isPublished,
    required this.onGradeSelected,
    required this.onPublicationChanged,
    this.enabled = true,
  });

  final List<GradeEntity> grades;
  final String selectedGradeId;
  final bool isPublished;
  final ValueChanged<String> onGradeSelected;
  final ValueChanged<bool> onPublicationChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : 0.55,
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LessonPublicationSwitch(
                isPublished: isPublished,
                onChanged: onPublicationChanged,
              ),
            ),
            horizontalSpace(16),
            Expanded(
              child: GradePopupMenuField(
                grades: grades,
                selectedGradeId: selectedGradeId,
                placeholderText: 'اختر الصف',
                tooltip: 'اختيار الصف الدراسي',
                emptyTooltip: 'لا توجد صفوف متاحة حاليًا',
                includeAllOption: false,
                allGradesText: 'كل الصفوف',
                onGradeSelected: onGradeSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
