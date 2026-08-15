import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/edit_lesson_exam_question_form.dart';
import 'package:flutter/material.dart';

typedef EditLessonExamQuestionSubmit =
    Future<void> Function({
      required String questionText,
      required int degree,
      required List<String> choices,
      LessonExamQuestionImageFile? newImage,
      required bool removeCurrentImage,
    });

class EditLessonExamQuestionContent extends StatefulWidget {
  const EditLessonExamQuestionContent({
    super.key,
    required this.question,
    required this.onUpdateQuestionPressed,
    this.isUpdatingQuestion = false,
  });

  final LessonExamQuestionEntity question;

  final EditLessonExamQuestionSubmit onUpdateQuestionPressed;

  final bool isUpdatingQuestion;

  @override
  State<EditLessonExamQuestionContent> createState() {
    return _EditLessonExamQuestionContentState();
  }
}

class _EditLessonExamQuestionContentState
    extends State<EditLessonExamQuestionContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _questionController;

  late final TextEditingController _degreeController;

  late final List<TextEditingController> _choiceControllers;

  LessonExamQuestionImageFile? _selectedImage;

  bool _removeCurrentImage = false;

  bool _isSubmitting = false;

  bool get _isActionInProgress {
    return _isSubmitting || widget.isUpdatingQuestion;
  }

  bool get _hasChanges {
    final currentQuestionText = _questionController.text.trim();

    final originalQuestionText = widget.question.questionText.trim();

    if (currentQuestionText != originalQuestionText) {
      return true;
    }

    final currentDegree = int.tryParse(_degreeController.text.trim());

    if (currentDegree != widget.question.degree) {
      return true;
    }

    final currentChoices = _choiceControllers
        .map((controller) => controller.text.trim())
        .toList(growable: false);

    final originalChoices = List<String>.generate(4, (index) {
      if (index < widget.question.choices.length) {
        return widget.question.choices[index].trim();
      }

      return '';
    }, growable: false);

    for (var index = 0; index < 4; index++) {
      if (currentChoices[index] != originalChoices[index]) {
        return true;
      }
    }

    if (_selectedImage != null) {
      return true;
    }

    if (_removeCurrentImage) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController(
      text: widget.question.questionText,
    );

    _degreeController = TextEditingController(
      text: widget.question.degree.toString(),
    );

    _choiceControllers = List.generate(4, (index) {
      final choice = index < widget.question.choices.length
          ? widget.question.choices[index]
          : '';

      return TextEditingController(text: choice);
    });
  }

  void _onFormValueChanged() {
    if (!mounted || _isActionInProgress) {
      return;
    }

    setState(() {});
  }

  void _selectImage(LessonExamQuestionImageFile image) {
    if (_isActionInProgress) {
      return;
    }

    setState(() {
      _selectedImage = image;
      _removeCurrentImage = false;
    });
  }

  void _removeImage() {
    if (_isActionInProgress) {
      return;
    }

    setState(() {
      if (_selectedImage != null) {
        _selectedImage = null;
        _removeCurrentImage = false;
        return;
      }

      final currentImageUrl = widget.question.imageUrl?.trim();

      if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
        _removeCurrentImage = true;
      }
    });
  }

  Future<void> _updateQuestion() async {
    if (_isActionInProgress) {
      return;
    }

    if (!_hasChanges) {
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
      await widget.onUpdateQuestionPressed(
        questionText: _questionController.text.trim(),
        degree: degree,
        choices: choices,
        newImage: _selectedImage,
        removeCurrentImage: _removeCurrentImage,
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
        child: EditLessonExamQuestionForm(
          questionController: _questionController,
          degreeController: _degreeController,
          choiceControllers: _choiceControllers,
          selectedImage: _selectedImage,
          currentImageUrl: widget.question.imageUrl,
          isCurrentImageRemoved: _removeCurrentImage,
          hasChanges: _hasChanges,
          enabled: !_isActionInProgress,
          isUpdatingQuestion: _isActionInProgress,
          onQuestionChanged: (_) {
            _onFormValueChanged();
          },
          onDegreeChanged: (_) {
            _onFormValueChanged();
          },
          onChoiceChanged: (_, __) {
            _onFormValueChanged();
          },
          onImageSelected: _selectImage,
          onImageRemoved: _removeImage,
          onUpdateQuestionPressed: _updateQuestion,
        ),
      ),
    );
  }
}
