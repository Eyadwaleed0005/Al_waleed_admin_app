import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditNoteFeedbackListener extends StatelessWidget {
  const EditNoteFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNoteCubit, EditNoteState>(
      listenWhen: (previous, current) {
        if (previous.actionStatus == current.actionStatus) {
          return false;
        }

        return current.updateSucceeded ||
            current.updateFailed ||
            current.deleteSucceeded ||
            current.deleteFailed;
      },
      listener: (context, state) async {
        final cubit = context.read<EditNoteCubit>();

        if (state.updateSucceeded) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم حفظ التعديلات',
                message: 'تم تعديل بيانات المذكرة بنجاح.',
                actionText: 'حسنًا',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();

                  Navigator.of(context).pop(true);
                },
              );
            },
          );

          return;
        }

        if (state.deleteSucceeded) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تم حذف المذكرة',
                message: 'تم حذف المذكرة وملف PDF الخاص بها بنجاح.',
                actionText: 'حسنًا',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();

                  Navigator.of(context).pop(true);
                },
              );
            },
          );

          return;
        }

        if (state.updateFailed) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.failure,
                title: 'تعذر حفظ التعديلات',
                message: state.actionError?.message ?? 'تعذر تعديل المذكرة.',
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
                type: CustomOperationResultType.failure,
                title: 'تعذر حذف المذكرة',
                message: state.actionError?.message ?? 'تعذر حذف المذكرة.',
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
