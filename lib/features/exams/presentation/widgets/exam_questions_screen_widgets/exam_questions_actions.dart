import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/widgets/custom_button.dart';
import 'package:alwaleed_admin/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';

class ExamQuestionsActions extends StatelessWidget {
  const ExamQuestionsActions({
    super.key,
    required this.onSavePressed,
    required this.onAddQuestionPressed,
    required this.saveButtonText,
    this.isSaving = false,
    this.isSaveEnabled = true,
    this.isAddQuestionEnabled = true,
  });

  final VoidCallback onSavePressed;

  final VoidCallback onAddQuestionPressed;

  final String saveButtonText;

  final bool isSaving;

  final bool isSaveEnabled;

  final bool isAddQuestionEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: CustomButton(
            text: saveButtonText,
            isLoading: isSaving,
            isEnabled: isSaveEnabled && !isSaving,
            onPressed: onSavePressed,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: CustomSecondaryButton(
            text: 'إضافة سؤال جديد',
            isEnabled: isAddQuestionEnabled && !isSaving,
            onPressed: onAddQuestionPressed,
          ),
        ),
      ],
    );
  }
}
