import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/core/widgets/custom_button.dart';
import 'package:alwaleed_admin/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admin/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/add_exam_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/validation/add_exam_validation.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_screen_widgets/exam_duration_field.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/add_exam_screen_widgets/exam_publication_switch.dart';
import 'package:alwaleed_admin/features/grades/domain/entities/grade_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamForm extends StatefulWidget {
  const AddExamForm({super.key, required this.grades});

  final List<GradeEntity> grades;

  @override
  State<AddExamForm> createState() {
    return _AddExamFormState();
  }
}

class _AddExamFormState extends State<AddExamForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _examNameController = TextEditingController();

  final TextEditingController _examDurationController = TextEditingController();

  late final AddExamValidation _addExamValidation;

  String _selectedGradeId = '';

  bool _isPublished = false;

  @override
  void initState() {
    super.initState();

    _addExamValidation = AddExamValidation();
  }

  @override
  void dispose() {
    _examNameController.dispose();
    _examDurationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupSelectionItem<String>> gradeItems = widget.grades
        .map((grade) {
          return PopupSelectionItem<String>(
            value: grade.gradeId,
            label: grade.name,
          );
        })
        .toList(growable: false);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _examNameController,
            labelText: 'اسم الاختبار',
            hintText: 'أدخل اسم الاختبار',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 100,
            validator: _addExamValidation.validateExamName,
          ),
          verticalSpace(24),
          _buildGradeField(gradeItems),
          verticalSpace(24),
          ExamDurationField(
            controller: _examDurationController,
            validator: _addExamValidation.validateDuration,
          ),
          verticalSpace(24),
          ExamPublicationSwitch(
            isPublished: _isPublished,
            onChanged: _changePublicationStatus,
          ),
          verticalSpace(32),
          CustomButton(
            text: 'التالي: إضافة الأسئلة',
            onPressed: _handleNextPressed,
          ),
          verticalSpace(24),
        ],
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
          initialValue: _selectedGradeId,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _addExamValidation.validateGrade,
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
                  enabled: widget.grades.isNotEmpty,
                  onSelected: (gradeId) {
                    _selectGrade(gradeId);

                    gradeField.didChange(gradeId);
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

  String get _selectedGradeText {
    if (_selectedGradeId.isEmpty) {
      return 'حدد الصف الدراسي';
    }

    for (final GradeEntity grade in widget.grades) {
      if (grade.gradeId == _selectedGradeId) {
        return grade.name;
      }
    }

    return 'حدد الصف الدراسي';
  }

  void _selectGrade(String gradeId) {
    setState(() {
      _selectedGradeId = gradeId;
    });
  }

  void _changePublicationStatus(bool isPublished) {
    setState(() {
      _isPublished = isPublished;
    });
  }

  void _handleNextPressed() {
    FocusScope.of(context).unfocus();

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

    final examDraft = context.read<AddExamCubit>().createDraft(
      examName: _examNameController.text.trim(),
      gradeId: _selectedGradeId,
      durationMinutes: durationMinutes,
      isPublished: _isPublished,
    );

    Navigator.of(
      context,
    ).pushNamed(RouteNames.examQuestionsScreen, arguments: examDraft);
  }
}
