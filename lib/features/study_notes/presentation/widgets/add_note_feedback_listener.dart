import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteFeedbackListener extends StatelessWidget {
  const AddNoteFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNoteCubit, AddNoteState>(
      listenWhen: (previous, current) {
        final submissionChanged =
            previous.submissionStatus != current.submissionStatus;

        final hasResult =
            current.submissionStatus == AddNoteSubmissionStatus.success ||
            current.submissionStatus == AddNoteSubmissionStatus.failure;

        return submissionChanged && hasResult;
      },
      listener: (context, state) async {
        final cubit = context.read<AddNoteCubit>();

        if (state.submissionSucceeded) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تمت الإضافة بنجاح',
                message: 'تمت إضافة المذكرة بنجاح.',
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

        final error = state.error;

        if (state.submissionFailed && error != null) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.failure,
                title: 'تعذر إضافة المذكرة',
                message: error.message,
                actionText: 'حاول مرة أخرى',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (!context.mounted) {
            return;
          }
          cubit.consumeSubmissionResult();
        }
      },
      child: child,
    );
  }
}
