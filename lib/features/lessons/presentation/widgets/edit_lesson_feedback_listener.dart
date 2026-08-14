import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLessonFeedbackListener
    extends StatelessWidget {
  const EditLessonFeedbackListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        EditLessonCubit,
        EditLessonState>(
      listenWhen: (previous, current) {
        if (previous.actionStatus ==
            current.actionStatus) {
          return false;
        }

        return current.updateSucceeded ||
            current.updateFailed ||
            current.deleteSucceeded ||
            current.deleteFailed;
      },
      listener: (context, state) async {
        final cubit =
            context.read<EditLessonCubit>();

        if (state.updateSucceeded) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type:
                    CustomOperationResultType.success,
                title: 'تم حفظ التعديلات',
                message:
                    'تم تعديل بيانات الدرس بنجاح.',
                actionText: 'حسنًا',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop(true);
          return;
        }

        if (state.deleteSucceeded) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type:
                    CustomOperationResultType.success,
                title: 'تم حذف الدرس',
                message:
                    'تم حذف الدرس وملف PDF الخاص به بنجاح.',
                actionText: 'حسنًا',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop(true);
          return;
        }

        final actionError = state.actionError;

        if (actionError == null) {
          cubit.consumeActionResult();
          return;
        }

        if (state.updateFailed) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type:
                    CustomOperationResultType.failure,
                title: 'تعذر حفظ التعديلات',
                message: actionError.message,
                actionText: 'حاول مرة أخرى',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (context.mounted) {
            cubit.consumeActionResult();
          }

          return;
        }

        if (state.deleteFailed) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type:
                    CustomOperationResultType.failure,
                title: 'تعذر حذف الدرس',
                message: actionError.message,
                actionText: 'حاول مرة أخرى',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (context.mounted) {
            cubit.consumeActionResult();
          }
        }
      },
      child: child,
    );
  }
}