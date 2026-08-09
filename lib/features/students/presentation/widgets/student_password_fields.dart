import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentPasswordFields extends StatelessWidget {
  const StudentPasswordFields({super.key, required this.state});

  final AddStudentState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    final hasGeneratedPassword = state.hasGeneratedPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.formFieldEntrance(
          order: 4,
          child: CustomTextFormField(
            controller: cubit.passwordController,
            labelText: 'كلمة المرور',
            hintText: 'اكتب كلمة مرور قوية',
            isPassword: true,
            showPasswordCopyIcon: true,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            autofillHints: const [AutofillHints.newPassword],
            validator: AppValidator.strongPassword,
            onChanged: cubit.onPasswordChanged,
            suffixIcon: Icon(
              hasGeneratedPassword
                  ? Icons.copy_rounded
                  : Icons.auto_awesome_rounded,
              color: ColorPalette.primary,
              size: 23.sp,
            ),
            suffixTooltip: hasGeneratedPassword
                ? 'نسخ كلمة المرور'
                : 'إنشاء كلمة مرور قوية',
            onSuffixTap: hasGeneratedPassword
                ? null
                : cubit.generateStrongPassword,
          ),
        ),

        verticalSpace(18),

        AppAnimations.formFieldEntrance(
          order: 5,
          child: CustomTextFormField(
            controller: cubit.confirmPasswordController,
            labelText: 'تأكيد كلمة المرور',
            hintText: 'أعد كتابة كلمة المرور',
            isPassword: true,
            showPasswordCopyIcon: false,
            textInputAction: TextInputAction.done,
            textDirection: TextDirection.ltr,
            validator: (value) {
              return AppValidator.confirmPassword(
                value: value,
                password: cubit.passwordController.text,
              );
            },
          ),
        ),
      ],
    );
  }
}
