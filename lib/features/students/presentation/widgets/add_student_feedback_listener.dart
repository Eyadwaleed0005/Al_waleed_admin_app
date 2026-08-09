import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStudentFeedbackListener extends StatelessWidget {
  const AddStudentFeedbackListener({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddStudentCubit, AddStudentState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) async {
        if (state.status == AddStudentStatus.failure) {
          await showDialog<void>(
            context: context,
            builder: (_) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.failure,
                title: 'تعذر إنشاء الحساب',
                message:
                    state.error?.message ?? 'حدث خطأ أثناء إنشاء حساب الطالب.',
                actionText: 'العودة والمحاولة مرة أخرى',
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          context.read<AddStudentCubit>().dismissFailure();

          return;
        }

        if (state.status == AddStudentStatus.success &&
            state.createdStudent != null) {
          final cubit = context.read<AddStudentCubit>();

          final email = cubit.emailController.text.trim().toLowerCase();

          final password = cubit.passwordController.text;

          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم إنشاء الحساب',
                message: 'احتفظ ببيانات تسجيل الدخول وأرسلها للطالب.',
                actionText: 'تم',
                email: email,
                password: password,
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop(state.createdStudent);
        }
      },
      child: child,
    );
  }
}
