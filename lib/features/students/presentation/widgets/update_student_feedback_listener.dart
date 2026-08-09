import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStudentFeedbackListener extends StatelessWidget {
  const UpdateStudentFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateStudentCubit, UpdateStudentState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) async {
        if (state.status == UpdateStudentStatus.updateFailure) {
          await _showFailureDialog(
            context,
            title: 'تعذر حفظ التعديلات',
            message:
                state.error?.message ?? 'حدث خطأ أثناء تعديل بيانات الطالب.',
          );

          if (!context.mounted) {
            return;
          }

          context.read<UpdateStudentCubit>().dismissFailure();

          return;
        }

        if (state.status == UpdateStudentStatus.renewalFailure) {
          await _showFailureDialog(
            context,
            title: 'تعذر تجديد الاشتراك',
            message:
                state.error?.message ?? 'حدث خطأ أثناء تجديد اشتراك الطالب.',
          );

          if (!context.mounted) {
            return;
          }
          context.read<UpdateStudentCubit>().dismissFailure();
          return;
        }

        if (state.status == UpdateStudentStatus.disconnectDeviceFailure) {
          await _showFailureDialog(
            context,
            title: 'تعذر فصل الجهاز',
            message: state.error?.message ?? 'تعذر فصل جهاز الطالب.',
          );

          if (!context.mounted) {
            return;
          }

          context.read<UpdateStudentCubit>().dismissFailure();

          return;
        }

        if (state.status == UpdateStudentStatus.deleteFailure) {
          await _showFailureDialog(
            context,
            title: 'تعذر حذف الطالب',
            message: state.error?.message ?? 'تعذر حذف حساب الطالب.',
          );

          if (!context.mounted) {
            return;
          }

          context.read<UpdateStudentCubit>().dismissFailure();

          return;
        }

        if (state.status == UpdateStudentStatus.renewalSuccess) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return const CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم تجديد الاشتراك',
                message: 'تم تجديد اشتراك الطالب لمدة شهر وتفعيل الحساب بنجاح.',
                actionText: 'تم',
                successIcon: Icons.autorenew_rounded,
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          context.read<UpdateStudentCubit>().finishSecondaryOperationFeedback();

          return;
        }

        if (state.status == UpdateStudentStatus.disconnectDeviceSuccess) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return const CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم فصل الجهاز',
                message: 'تم فصل الجهاز المرتبط بحساب الطالب بنجاح.',
                actionText: 'تم',
                successIcon: Icons.phonelink_erase_rounded,
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          context.read<UpdateStudentCubit>().finishSecondaryOperationFeedback();

          return;
        }

        if (state.status == UpdateStudentStatus.updateSuccess &&
            state.student != null) {
          final cubit = context.read<UpdateStudentCubit>();

          final email = cubit.emailController.text.trim().toLowerCase();

          final password = cubit.passwordController.text;

          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم حفظ التعديلات',
                message: password.isNotEmpty
                    ? 'تم تعديل بيانات الطالب. احتفظ ببيانات تسجيل الدخول الجديدة.'
                    : 'تم تعديل بيانات الطالب بنجاح.',
                actionText: 'تم',
                email: email,
                password: password.isEmpty ? null : password,
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop(state.student);

          return;
        }

        if (state.status == UpdateStudentStatus.deleteSuccess) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return const CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم حذف الطالب',
                message: 'تم حذف حساب الطالب وبياناته بنجاح.',
                actionText: 'تم',
                successIcon: Icons.delete_outline_rounded,
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop(true);
        }
      },
      child: child,
    );
  }

  Future<void> _showFailureDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: title,
          message: message,
          actionText: 'المحاولة مرة أخرى',
        );
      },
    );
  }
}
