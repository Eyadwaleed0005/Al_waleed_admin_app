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

typedef AddExamQuestionPressed =
    void Function({
      required String questionText,
      required int questionDegree,
      required List<String> choices,
      ExamQuestionImageFile? image,
    });

class AddExamQuestionForm extends StatefulWidget {
  const AddExamQuestionForm({
    super.key,
    required this.onAddQuestionPressed,
    this.isAddingQuestion = false,
  });

  final AddExamQuestionPressed onAddQuestionPressed;

  final bool isAddingQuestion;

  @override
  State<AddExamQuestionForm> createState() {
    return _AddExamQuestionFormState();
  }
}

class _AddExamQuestionFormState extends State<AddExamQuestionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _questionController = TextEditingController();

  final TextEditingController _questionDegreeController =
      TextEditingController();

  final List<TextEditingController> _choiceControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  ExamQuestionImageFile? _selectedImage;

  bool get _fieldsEnabled {
    return !widget.isAddingQuestion;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _questionDegreeController.dispose();

    for (final TextEditingController controller in _choiceControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppAnimations.formFieldEntrance(
            order: 0,
            child: CustomTextFormField(
              controller: _questionController,
              labelText: 'نص السؤال',
              hintText: 'اكتب نص السؤال هنا',
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 3,
              maxLines: 5,
              maxLength: 500,
              enabled: _fieldsEnabled,
              validator: AppValidator.lessonExamQuestionText,
            ),
          ),
          verticalSpace(20),
          AppAnimations.formFieldEntrance(
            order: 1,
            child: ExamQuestionImagePicker(
              selectedImage: _selectedImage,
              isEnabled: _fieldsEnabled,
              onImageSelected: _selectImage,
              onImageRemoved: _removeImage,
            ),
          ),
          verticalSpace(20),
          AppAnimations.formFieldEntrance(
            order: 2,
            child: CustomTextFormField(
              controller: _questionDegreeController,
              labelText: 'درجة السؤال',
              hintText: 'اكتب درجة السؤال',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: _fieldsEnabled,
              validator: AppValidator.lessonExamQuestionDegree,
            ),
          ),
          verticalSpace(20),
          AppAnimations.formFieldEntrance(
            order: 3,
            child: ExamQuestionChoicesFields(
              choiceControllers: _choiceControllers,
              enabled: _fieldsEnabled,
            ),
          ),
          verticalSpace(24),
          AppAnimations.screenSection(
            delay: 420,
            child: CustomButton(
              text: 'إضافة السؤال',
              isLoading: widget.isAddingQuestion,
              isEnabled: _fieldsEnabled,
              onPressed: _handleAddQuestionPressed,
            ),
          ),
          verticalSpace(20),
        ],
      ),
    );
  }

  void _selectImage(ExamQuestionImageFile selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _handleAddQuestionPressed() {
    FocusScope.of(context).unfocus();

    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final int? questionDegree = int.tryParse(
      _questionDegreeController.text.trim(),
    );

    if (questionDegree == null) {
      return;
    }

    final List<String> choices = _choiceControllers.map((
      TextEditingController controller,
    ) {
      return controller.text.trim();
    }).toList();

    widget.onAddQuestionPressed(
      questionText: _questionController.text.trim(),
      questionDegree: questionDegree,
      choices: choices,
      image: _selectedImage,
    );
  }
}
