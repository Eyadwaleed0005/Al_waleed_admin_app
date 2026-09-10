import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admin/core/widgets/custom_secondary_button.dart';
import 'package:alwaleed_admin/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admin/features/exams/presentation/validation/add_exam_validation.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_screen_widgets/exam_duration_field.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_screen_widgets/exam_publication_switch.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/edit_exam_screen_widgets/edit_exam_actions.dart';
import 'package:alwaleed_admin/features/grades/domain/entities/grade_entity.dart';
import 'package:flutter/material.dart';

typedef EditExamSubmit =
    void Function({
      required String examName,
      required String gradeId,
      required int durationMinutes,
      required bool isPublished,
    });

class EditExamForm extends StatefulWidget {
  const EditExamForm({
    super.key,
    required this.exam,
    required this.grades,
    required this.onSaveChangesPressed,
    required this.onOpenQuestionsPressed,
    required this.onCloseExamPressed,
    required this.onDeleteExamPressed,
    this.canCloseExam = true,
    this.isSavingChanges = false,
    this.isClosingExam = false,
    this.isDeletingExam = false,
  });

  final ExamEntity exam;
  final List<GradeEntity> grades;

  final EditExamSubmit onSaveChangesPressed;
  final VoidCallback onOpenQuestionsPressed;
  final VoidCallback onCloseExamPressed;
  final VoidCallback onDeleteExamPressed;

  final bool canCloseExam;

  final bool isSavingChanges;
  final bool isClosingExam;
  final bool isDeletingExam;

  @override
  State<EditExamForm> createState() {
    return _EditExamFormState();
  }
}

class _EditExamFormState extends State<EditExamForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _examNameController;
  late final TextEditingController _examDurationController;
  late final AddExamValidation _editExamValidation;

  late String _selectedGradeId;
  late bool _isPublished;

  bool _isSyncingForm = false;

  bool get _isActionInProgress {
    return widget.isSavingChanges ||
        widget.isClosingExam ||
        widget.isDeletingExam;
  }

  bool get _isExamEnded {
    return widget.exam.isEnded;
  }

  bool get _fieldsEnabled {
    return !_isExamEnded && !_isActionInProgress;
  }

  bool get _hasChanges {
    return _hasChangesComparedTo(widget.exam);
  }

  bool _hasChangesComparedTo(ExamEntity exam) {
    final int? currentDuration = int.tryParse(
      _examDurationController.text.trim(),
    );

    return _examNameController.text.trim() != exam.examName.trim() ||
        currentDuration != exam.durationMinutes ||
        _selectedGradeId != exam.gradeId ||
        _isPublished != exam.isPublished;
  }

  @override
  void initState() {
    super.initState();

    _editExamValidation = AddExamValidation();

    _examNameController = TextEditingController(text: widget.exam.examName);

    _examDurationController = TextEditingController(
      text: widget.exam.durationMinutes.toString(),
    );

    _selectedGradeId = widget.exam.gradeId;
    _isPublished = widget.exam.isPublished;

    _examNameController.addListener(_onFormValueChanged);

    _examDurationController.addListener(_onFormValueChanged);
  }

  @override
  void didUpdateWidget(covariant EditExamForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isDifferentExam = oldWidget.exam.examId != widget.exam.examId;

    final bool settingsChanged =
        oldWidget.exam.examName != widget.exam.examName ||
        oldWidget.exam.gradeId != widget.exam.gradeId ||
        oldWidget.exam.durationMinutes != widget.exam.durationMinutes ||
        oldWidget.exam.status != widget.exam.status;

    final bool hadLocalChanges = _hasChangesComparedTo(oldWidget.exam);

    if (isDifferentExam || (settingsChanged && !hadLocalChanges)) {
      _syncFormFromExam();
    }
  }

  void _syncFormFromExam() {
    _isSyncingForm = true;

    try {
      _examNameController.text = widget.exam.examName;

      _examDurationController.text = widget.exam.durationMinutes.toString();

      _selectedGradeId = widget.exam.gradeId;
      _isPublished = widget.exam.isPublished;
    } finally {
      _isSyncingForm = false;
    }
  }

  @override
  void dispose() {
    _examNameController.removeListener(_onFormValueChanged);

    _examDurationController.removeListener(_onFormValueChanged);

    _examNameController.dispose();
    _examDurationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupSelectionItem<String>> gradeItems = widget.grades
        .map((GradeEntity grade) {
          return PopupSelectionItem<String>(
            value: grade.gradeId,
            label: grade.name,
          );
        })
        .toList(growable: false);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppAnimations.formFieldEntrance(
              order: 0,
              child: CustomTextFormField(
                controller: _examNameController,
                labelText: 'اسم الاختبار',
                hintText: 'أدخل اسم الاختبار',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                enabled: _fieldsEnabled,
                validator: _editExamValidation.validateExamName,
              ),
            ),
            verticalSpace(24),
            AppAnimations.formFieldEntrance(
              order: 1,
              child: _buildGradeField(gradeItems),
            ),
            verticalSpace(24),
            AppAnimations.formFieldEntrance(
              order: 2,
              child: ExcludeFocus(
                excluding: !_fieldsEnabled,
                child: AbsorbPointer(
                  absorbing: !_fieldsEnabled,
                  child: ExamDurationField(
                    controller: _examDurationController,
                    validator: _editExamValidation.validateDuration,
                  ),
                ),
              ),
            ),
            verticalSpace(24),
            AppAnimations.formFieldEntrance(
              order: 3,
              child: ExcludeFocus(
                excluding: !_fieldsEnabled,
                child: AbsorbPointer(
                  absorbing: !_fieldsEnabled,
                  child: ExamPublicationSwitch(
                    isPublished: _isPublished,
                    onChanged: _changePublicationStatus,
                  ),
                ),
              ),
            ),
            verticalSpace(24),
            AppAnimations.formFieldEntrance(
              order: 4,
              child: CustomSecondaryButton(
                text: 'إدارة أسئلة الاختبار',
                isEnabled: !_isActionInProgress,
                onPressed: _openQuestions,
              ),
            ),
            verticalSpace(28),
            AppAnimations.screenSection(
              delay: 360,
              child: EditExamActions(
                isExamEnded: _isExamEnded,
                isSavingChanges: widget.isSavingChanges,
                isClosingExam: widget.isClosingExam,
                isDeletingExam: widget.isDeletingExam,
                isSaveChangesEnabled: _fieldsEnabled && _hasChanges,
                isCloseExamEnabled: widget.canCloseExam,
                isDeleteExamEnabled: true,
                onSaveChangesPressed: _saveChanges,
                onCloseExamPressed: _closeExam,
                onDeleteExamPressed: _deleteExam,
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeField(List<PopupSelectionItem<String>> gradeItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'اختر الصف',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font15TextPrimaryMediumTajawal(),
        ),
        verticalSpace(10),
        FormField<String>(
          key: ValueKey<String>('${widget.exam.examId}:$_selectedGradeId'),
          initialValue: _selectedGradeId,
          enabled: _fieldsEnabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validateGrade,
          builder: (gradeField) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomPopupMenuField<String>(
                  items: gradeItems,
                  value: _selectedGradeId,
                  selectedText: _selectedGradeText,
                  filterValue: _selectedGradeId,
                  tooltip: 'اختر الصف الدراسي',
                  emptyTooltip: 'لا توجد صفوف متاحة',
                  enabled: widget.grades.isNotEmpty && _fieldsEnabled,
                  onSelected: (String gradeId) {
                    if (!_fieldsEnabled) {
                      return;
                    }

                    gradeField.didChange(gradeId);

                    setState(() {
                      _selectedGradeId = gradeId;
                    });
                  },
                ),
                if (gradeField.hasError) ...[
                  verticalSpace(8),
                  Text(
                    gradeField.errorText ?? '',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyle.font12ErrorRegularTajawal(),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  String? _validateGrade(String? value) {
    final String? validationError = _editExamValidation.validateGrade(value);

    if (validationError != null) {
      return validationError;
    }

    final bool exists = widget.grades.any((grade) {
      return grade.gradeId == value;
    });

    if (!exists) {
      return 'الصف المحدد غير متاح. اختر صفًا دراسيًا آخر.';
    }

    return null;
  }

  String get _selectedGradeText {
    for (final GradeEntity grade in widget.grades) {
      if (grade.gradeId == _selectedGradeId) {
        return grade.name;
      }
    }

    return _selectedGradeId.isEmpty
        ? 'حدد الصف الدراسي'
        : 'الصف المحدد غير متاح';
  }

  void _onFormValueChanged() {
    if (!mounted || _isSyncingForm || _isActionInProgress) {
      return;
    }

    setState(() {});
  }

  void _changePublicationStatus(bool isPublished) {
    if (!_fieldsEnabled) {
      return;
    }

    setState(() {
      _isPublished = isPublished;
    });
  }

  void _openQuestions() {
    if (_isActionInProgress) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    widget.onOpenQuestionsPressed();
  }

  void _closeExam() {
    if (_isActionInProgress || !widget.canCloseExam) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    widget.onCloseExamPressed();
  }

  void _deleteExam() {
    if (_isActionInProgress) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    widget.onDeleteExamPressed();
  }

  void _saveChanges() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_fieldsEnabled || !_hasChanges) {
      return;
    }

    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final int? durationMinutes = int.tryParse(
      _examDurationController.text.trim(),
    );

    if (durationMinutes == null) {
      return;
    }

    widget.onSaveChangesPressed(
      examName: _examNameController.text.trim(),
      gradeId: _selectedGradeId,
      durationMinutes: durationMinutes,
      isPublished: _isPublished,
    );
  }
}
