import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/custom_date_picker_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_state.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/grade_popup_menu_field.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/update_student_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateStudentFormFields extends StatelessWidget {
  const UpdateStudentFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateStudentCubit>();

    return BlocBuilder<UpdateStudentCubit, UpdateStudentState>(
      builder: (context, state) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: cubit.formKey,
            child: Column(
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
                          validator: AppValidator.studentAge,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ),
                      horizontalSpace(12),
                      Expanded(
                        child: GradePopupMenuField(
                          grades: state.grades,
                          selectedGradeId: state.selectedGradeId,
                          labelText: 'الصف الدراسي',
                          placeholderText: 'اختر الصف',
                          tooltip: 'اختيار الصف الدراسي',
                          emptyTooltip: 'لا توجد صفوف متاحة حاليًا',
                          validator: AppValidator.grade,
                          onGradeSelected: cubit.selectGrade,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(18),
                AppAnimations.formFieldEntrance(
                  order: 2,
                  child: CustomTextFormField(
                    controller: cubit.phoneController,
                    labelText: 'رقم الهاتف',
                    hintText: '01xxxxxxxxx',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    textDirection: TextDirection.ltr,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    validator: AppValidator.phoneNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                ),
                verticalSpace(18),
                AppAnimations.formFieldEntrance(
                  order: 3,
                  child: CustomTextFormField(
                    controller: cubit.emailController,
                    labelText: 'البريد الإلكتروني',
                    hintText: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textDirection: TextDirection.ltr,
                    autofillHints: const [AutofillHints.email],
                    validator: AppValidator.email,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                  ),
                ),
                verticalSpace(18),
                AppAnimations.formFieldEntrance(
                  order: 4,
                  child: CustomTextFormField(
                    controller: cubit.passwordController,
                    labelText: 'كلمة مرور جديدة - اختياري',
                    hintText: 'اتركها فارغة دون تغيير',
                    isPassword: true,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) {
                      final password = value ?? '';

                      if (password.isEmpty) {
                        return null;
                      }

                      return AppValidator.strongPassword(password);
                    },
                    onChanged: cubit.onPasswordChanged,
                    suffixIcon: Icon(
                      state.hasGeneratedPassword
                          ? Icons.copy_rounded
                          : Icons.auto_awesome_rounded,
                      color: ColorPalette.primary,
                      size: 23.sp,
                    ),
                    onSuffixTap: state.hasGeneratedPassword
                        ? null
                        : cubit.generateStrongPassword,
                  ),
                ),
                verticalSpace(18),
                AppAnimations.formFieldEntrance(
                  order: 5,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomDatePickerField(
                          controller: cubit.subscriptionStartDateController,
                          labelText: 'بداية الاشتراك',
                          hintText: 'اختر التاريخ',
                          selectedDate: state.subscriptionStartDate,
                          initialDate: state.subscriptionStartDate,
                          firstDate: DateTime(2000),
                          validator: (_) {
                            if (state.subscriptionStartDate == null) {
                              return 'اختر تاريخ بداية الاشتراك';
                            }

                            return null;
                          },
                          onDateSelected: cubit.selectSubscriptionStartDate,
                        ),
                      ),
                      horizontalSpace(12),
                      Expanded(
                        child: CustomDatePickerField(
                          controller: cubit.subscriptionEndDateController,
                          labelText: 'نهاية الاشتراك',
                          hintText: 'اختر التاريخ',
                          selectedDate: state.subscriptionEndDate,
                          initialDate: state.subscriptionEndDate,
                          firstDate: cubit.subscriptionEndFirstDate,
                          validator: (_) {
                            return AppValidator.subscriptionEndDate(
                              startDate: state.subscriptionStartDate,
                              endDate: state.subscriptionEndDate,
                            );
                          },
                          onDateSelected: cubit.selectSubscriptionEndDate,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(28),
                const UpdateStudentActions(),
                verticalSpace(16),
              ],
            ),
          ),
        );
      },
    );
  }
}
