import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentContactFields extends StatelessWidget {
  const StudentContactFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: AppValidator.phoneNumber,
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
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            validator: AppValidator.email,
          ),
        ),
      ],
    );
  }
}
