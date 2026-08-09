import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_filter_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_form_field_error_text.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentIdentityFields extends StatelessWidget {
  const StudentIdentityFields({super.key, required this.state});

  final AddStudentState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.formFieldEntrance(
          order: 0,
          child: CustomTextFormField(
            controller: cubit.studentNameController,
            labelText: 'اسم الطالب',
            hintText: 'اكتب الاسم الثلاثي',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            validator: AppValidator.studentName,
          ),
        ),

        verticalSpace(18),

        AppAnimations.formFieldEntrance(
          order: 1,
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: cubit.studentAgeController,
                  labelText: 'عمر الطالب',
                  hintText: 'اكتب العمر',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: AppValidator.studentAge,
                ),
              ),

              horizontalSpace(12),

              Expanded(child: StudentGradeSelectionField(state: state)),
            ],
          ),
        ),
      ],
    );
  }
}

class StudentGradeSelectionField extends StatelessWidget {
  const StudentGradeSelectionField({super.key, required this.state});

  final AddStudentState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    return FormField<String>(
      key: ValueKey(
        'grade-'
        '${state.selectedGradeId}-'
        '${state.grades.length}',
      ),
      initialValue: state.selectedGradeId,
      validator: AppValidator.grade,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StudentGradePopupMenu(
              grades: state.grades,
              selectedGradeId: state.selectedGradeId,
              selectedGradeName: state.selectedGradeName,
              onGradeSelected: (gradeId) {
                field.didChange(gradeId);
                cubit.selectGrade(gradeId);
              },
            ),

            CustomFormFieldErrorText(errorText: field.errorText),
          ],
        );
      },
    );
  }
}

class _StudentGradePopupMenu extends StatelessWidget {
  const _StudentGradePopupMenu({
    required this.grades,
    required this.selectedGradeId,
    required this.selectedGradeName,
    required this.onGradeSelected,
  });

  final List<GradeEntity> grades;
  final String? selectedGradeId;
  final String selectedGradeName;
  final ValueChanged<String> onGradeSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      enabled: grades.isNotEmpty,
      tooltip: grades.isEmpty
          ? 'لا توجد صفوف متاحة حاليًا'
          : 'اختيار الصف الدراسي',
      position: PopupMenuPosition.under,
      color: ColorPalette.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      offset: Offset(0, 4.h),
      initialValue: selectedGradeId,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: ColorPalette.border, width: 1.w),
      ),
      onSelected: onGradeSelected,
      itemBuilder: (context) {
        return grades.map((grade) {
          return CheckedPopupMenuItem<String>(
            value: grade.gradeId,
            checked: selectedGradeId == grade.gradeId,
            child: Text(
              grade.name,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font15TextPrimaryMediumTajawal(),
            ),
          );
        }).toList();
      },
      child: IgnorePointer(
        child: CustomFilterButton(
          labelText: 'الصف الدراسي',
          text: selectedGradeName,
          value: selectedGradeId,
        ),
      ),
    );
  }
}
