import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_question_choices_fields.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_question_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditLessonExamQuestionForm extends StatelessWidget {
  const EditLessonExamQuestionForm({
    super.key,
    required this.questionController,
    required this.degreeController,
    required this.choiceControllers,
    required this.selectedImage,
    required this.currentImageUrl,
    required this.isCurrentImageRemoved,
    required this.onImageSelected,
    required this.onImageRemoved,
    required this.onUpdateQuestionPressed,
    required this.hasChanges,
    this.onQuestionChanged,
    this.onDegreeChanged,
    this.onChoiceChanged,
    this.isUpdatingQuestion = false,
    this.enabled = true,
  });

  final TextEditingController questionController;

  final TextEditingController degreeController;

  final List<TextEditingController> choiceControllers;

  final LessonExamQuestionImageFile? selectedImage;

  final String? currentImageUrl;

  final bool isCurrentImageRemoved;

  final ValueChanged<LessonExamQuestionImageFile> onImageSelected;

  final VoidCallback onImageRemoved;

  final VoidCallback onUpdateQuestionPressed;

  final ValueChanged<String>? onQuestionChanged;

  final ValueChanged<String>? onDegreeChanged;

  final LessonExamChoiceChanged? onChoiceChanged;

  final bool hasChanges;

  final bool isUpdatingQuestion;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final fieldsEnabled = enabled && !isUpdatingQuestion;

    final canSave =
        enabled &&
        hasChanges &&
        !isUpdatingQuestion;

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
            onChanged: onQuestionChanged,
          ),
        ),

        verticalSpace(20),

        AppAnimations.formFieldEntrance(
          order: 1,
          child: LessonExamQuestionImagePicker(
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            enabled: fieldsEnabled,
            validator: AppValidator.lessonExamQuestionDegree,
            onChanged: onDegreeChanged,
          ),
        ),

        verticalSpace(20),

        AppAnimations.formFieldEntrance(
          order: 3,
          child: LessonExamQuestionChoicesFields(
            choiceControllers: choiceControllers,
            onChoiceChanged: onChoiceChanged,
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

        verticalSpace(8),
      ],
    );
  }
}