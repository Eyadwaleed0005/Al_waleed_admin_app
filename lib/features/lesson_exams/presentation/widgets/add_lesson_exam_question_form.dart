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

class AddLessonExamQuestionForm extends StatelessWidget {
  const AddLessonExamQuestionForm({
    super.key,
    required this.questionController,
    required this.degreeController,
    required this.choiceControllers,
    required this.selectedImage,
    required this.onImageSelected,
    required this.onImageRemoved,
    required this.onAddQuestionPressed,
    this.isAddingQuestion = false,
  });

  final TextEditingController questionController;

  final TextEditingController degreeController;

  final List<TextEditingController> choiceControllers;

  final LessonExamQuestionImageFile? selectedImage;

  final ValueChanged<LessonExamQuestionImageFile> onImageSelected;

  final VoidCallback onImageRemoved;

  final VoidCallback onAddQuestionPressed;

  final bool isAddingQuestion;

  @override
  Widget build(BuildContext context) {
    final fieldsEnabled = !isAddingQuestion;

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
          child: LessonExamQuestionImagePicker(
            selectedImage: selectedImage,
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
          child: LessonExamQuestionChoicesFields(
            choiceControllers: choiceControllers,
            enabled: fieldsEnabled,
          ),
        ),
        verticalSpace(24),
        AppAnimations.screenSection(
          delay: 420,
          child: CustomButton(
            text: 'إضافة السؤال',
            isLoading: isAddingQuestion,
            isEnabled: fieldsEnabled,
            onPressed: onAddQuestionPressed,
          ),
        ),
        verticalSpace(8),
      ],
    );
  }
}
