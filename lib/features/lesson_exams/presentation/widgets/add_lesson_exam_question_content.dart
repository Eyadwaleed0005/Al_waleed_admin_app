import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/add_lesson_exam_question_form.dart';
import 'package:flutter/material.dart';

typedef AddLessonExamQuestionSubmit =
    Future<void> Function({
      required String questionText,
      required int degree,
      required List<String> choices,
      LessonExamQuestionImageFile? image,
    });

class AddLessonExamQuestionContent extends StatefulWidget {
  const AddLessonExamQuestionContent({
    super.key,
    required this.onAddQuestionPressed,
    this.isAddingQuestion = false,
  });

  final AddLessonExamQuestionSubmit onAddQuestionPressed;

  final bool isAddingQuestion;

  @override
  State<AddLessonExamQuestionContent> createState() {
    return _AddLessonExamQuestionContentState();
  }
}

class _AddLessonExamQuestionContentState
    extends State<AddLessonExamQuestionContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _questionController;

  late final TextEditingController _degreeController;

  late final List<TextEditingController> _choiceControllers;

  LessonExamQuestionImageFile? _selectedImage;

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController();

    _degreeController = TextEditingController();

    _choiceControllers = List.generate(4, (_) => TextEditingController());
  }

  void _selectImage(LessonExamQuestionImageFile image) {
    if (widget.isAddingQuestion) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });
  }

  void _removeImage() {
    if (widget.isAddingQuestion) {
      return;
    }

    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _addQuestion() async {
    if (widget.isAddingQuestion) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final degree = int.tryParse(_degreeController.text.trim());

    if (degree == null) {
      return;
    }

    final choices = _choiceControllers
        .map((controller) => controller.text.trim())
        .toList(growable: false);

    await widget.onAddQuestionPressed(
      questionText: _questionController.text.trim(),
      degree: degree,
      choices: choices,
      image: _selectedImage,
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _degreeController.dispose();

    for (final controller in _choiceControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        child: AddLessonExamQuestionForm(
          questionController: _questionController,
          degreeController: _degreeController,
          choiceControllers: _choiceControllers,
          selectedImage: _selectedImage,
          isAddingQuestion: widget.isAddingQuestion,
          onImageSelected: _selectImage,
          onImageRemoved: _removeImage,
          onAddQuestionPressed: _addQuestion,
        ),
      ),
    );
  }
}
