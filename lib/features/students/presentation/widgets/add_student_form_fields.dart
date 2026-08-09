import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_state.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_contact_fields.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_identity_fields.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_password_fields.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/student_subscription_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStudentFormFields extends StatelessWidget {
  const AddStudentFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStudentCubit>();

    return BlocBuilder<AddStudentCubit, AddStudentState>(
      builder: (context, state) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StudentIdentityFields(state: state),
                verticalSpace(18),
                const StudentContactFields(),
                verticalSpace(18),
                StudentPasswordFields(state: state),
                verticalSpace(18),
                StudentSubscriptionFields(state: state),
                verticalSpace(28),
                AppAnimations.formFieldEntrance(
                  order: 7,
                  child: CustomButton(
                    text: 'إنشاء حساب طالب',
                    onPressed: cubit.submit,
                    isLoading: state.isSubmitting,
                  ),
                ),
                verticalSpace(16),
              ],
            ),
          ),
        );
      },
    );
  }
}
