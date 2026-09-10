import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/widgets/custom_button.dart';
import 'package:alwaleed_admin/core/widgets/custom_delete_button.dart';
import 'package:alwaleed_admin/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';

class EditExamActions extends StatelessWidget {
  const EditExamActions({
    super.key,
    required this.isExamEnded,
    required this.onSaveChangesPressed,
    required this.onCloseExamPressed,
    required this.onDeleteExamPressed,
    this.isSavingChanges = false,
    this.isClosingExam = false,
    this.isDeletingExam = false,
    this.isSaveChangesEnabled = true,
    this.isCloseExamEnabled = true,
    this.isDeleteExamEnabled = true,
  });

  final bool isExamEnded;

  final VoidCallback onSaveChangesPressed;
  final VoidCallback onCloseExamPressed;
  final VoidCallback onDeleteExamPressed;

  final bool isSavingChanges;
  final bool isClosingExam;
  final bool isDeletingExam;

  final bool isSaveChangesEnabled;
  final bool isCloseExamEnabled;
  final bool isDeleteExamEnabled;

  bool get _isActionInProgress {
    return isSavingChanges || isClosingExam || isDeletingExam;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isExamEnded) ...[
          CustomButton(
            text: 'حفظ التعديلات',
            isLoading: isSavingChanges,
            isEnabled: isSaveChangesEnabled && !_isActionInProgress,
            onPressed: onSaveChangesPressed,
          ),

          verticalSpace(12),

          CustomSecondaryButton(
            text: 'إغلاق الاختبار',
            isLoading: isClosingExam,
            isEnabled: isCloseExamEnabled && !_isActionInProgress,
            onPressed: onCloseExamPressed,
          ),

          verticalSpace(12),
        ],

        CustomDeleteButton(
          text: 'حذف الاختبار',
          icon: Icons.delete_outline_rounded,
          isLoading: isDeletingExam,
          isEnabled: isDeleteExamEnabled && !_isActionInProgress,
          onPressed: onDeleteExamPressed,
        ),
      ],
    );
  }
}
