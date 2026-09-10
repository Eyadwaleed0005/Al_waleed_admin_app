import 'package:alwaleed_admin/core/helper/app_validator.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/widgets/custom_button.dart';
import 'package:alwaleed_admin/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_questions_screen_widgets/exam_question_choices_fields.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_questions_screen_widgets/exam_question_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditExamQuestionForm extends StatelessWidget {
  const EditExamQuestionForm({
    super.key,
    required this.questionController,
    required this.degreeController,
    required this.choiceControllers,
    required this.selectedImage,
    required this.currentImageUrl,
    required this.isCurrentImageRemoved,
    required this.hasChanges,
    required this.onImageSelected,
    required this.onImageRemoved,
    required this.onUpdateQuestionPressed,
    this.isUpdatingQuestion = false,
  });

  final TextEditingController questionController;

  final TextEditingController degreeController;

  final List<TextEditingController> choiceControllers;

  final ExamQuestionImageFile? selectedImage;

  final String? currentImageUrl;

  final bool isCurrentImageRemoved;

  final bool hasChanges;

  final bool isUpdatingQuestion;

  final ValueChanged<ExamQuestionImageFile> onImageSelected;

  final VoidCallback onImageRemoved;

  final VoidCallback onUpdateQuestionPressed;

  @override
  Widget build(BuildContext context) {
    final bool fieldsEnabled = !isUpdatingQuestion;

    final bool canSave = hasChanges && !isUpdatingQuestion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.formFieldEntrance(
          order: 0,
          child: CustomTextFormField(
            controller: questionController,
            labelText: 'نص السؤال',
            hintText: 'اكتب نص السؤال هنا',
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 3,
            maxLines: 5,
            maxLength: 500,
            enabled: fieldsEnabled,
            validator: AppValidator.lessonExamQuestionText,
          ),
        ),
        verticalSpace(20),
        AppAnimations.formFieldEntrance(
          order: 1,
          child: ExamQuestionImagePicker(
            selectedImage: selectedImage,
            currentImageUrl: currentImageUrl,
            isCurrentImageRemoved: isCurrentImageRemoved,
            isEnabled: fieldsEnabled,
            onImageSelected: onImageSelected,
            onImageRemoved: onImageRemoved,
          ),
        ),
        verticalSpace(20),
        AppAnimations.formFieldEntrance(
          order: 2,
          child: CustomTextFormField(
            controller: degreeController,
            labelText: 'درجة السؤال',
            hintText: 'اكتب درجة السؤال',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            enabled: fieldsEnabled,
            validator: AppValidator.lessonExamQuestionDegree,
          ),
        ),
        verticalSpace(20),
        AppAnimations.formFieldEntrance(
          order: 3,
          child: ExamQuestionChoicesFields(
            choiceControllers: choiceControllers,
            enabled: fieldsEnabled,
          ),
        ),
        verticalSpace(24),
        AppAnimations.screenSection(
          delay: 420,
          child: CustomButton(
            text: 'حفظ التعديلات',
            isLoading: isUpdatingQuestion,
            isEnabled: canSave,
            onPressed: onUpdateQuestionPressed,
          ),
        ),
        verticalSpace(20),
      ],
    );
  }
}
