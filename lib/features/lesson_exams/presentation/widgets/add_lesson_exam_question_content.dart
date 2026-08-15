import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/add_lesson_exam_question_form.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_question_choices_fields.dart';
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
    this.onQuestionChanged,
    this.onDegreeChanged,
    this.onChoiceChanged,
    this.onImageChanged,
    this.isAddingQuestion = false,
  });

  final AddLessonExamQuestionSubmit onAddQuestionPressed;

  final ValueChanged<String>? onQuestionChanged;
  final ValueChanged<String>? onDegreeChanged;

  final LessonExamChoiceChanged? onChoiceChanged;

  final ValueChanged<LessonExamQuestionImageFile?>? onImageChanged;

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

  bool _isSubmitting = false;

  bool get _isActionInProgress {
    return _isSubmitting || widget.isAddingQuestion;
  }

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController();

    _degreeController = TextEditingController();

    _choiceControllers = List.generate(4, (_) => TextEditingController());
  }

  void _selectImage(LessonExamQuestionImageFile image) {
    if (_isActionInProgress) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });

    widget.onImageChanged?.call(image);
  }

  void _removeImage() {
    if (_isActionInProgress) {
      return;
    }

    setState(() {
      _selectedImage = null;
    });

    widget.onImageChanged?.call(null);
  }

  Future<void> _addQuestion() async {
    if (_isActionInProgress) {
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

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onAddQuestionPressed(
        questionText: _questionController.text.trim(),
        degree: degree,
        choices: choices,
        image: _selectedImage,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
          enabled: !_isActionInProgress,
          isAddingQuestion: _isActionInProgress,
          onQuestionChanged: (value) {
            widget.onQuestionChanged?.call(value);
          },
          onDegreeChanged: (value) {
            widget.onDegreeChanged?.call(value);
          },
          onChoiceChanged: (index, value) {
            widget.onChoiceChanged?.call(index, value);
          },
          onImageSelected: _selectImage,
          onImageRemoved: _removeImage,
          onAddQuestionPressed: _addQuestion,
        ),
      ),
    );
  }
}
