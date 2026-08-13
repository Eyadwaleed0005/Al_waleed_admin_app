import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLessonFeedbackListener extends StatelessWidget {
  const AddLessonFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddLessonCubit, AddLessonState>(
      listenWhen: (previous, current) {
        final submissionChanged =
            previous.submissionStatus != current.submissionStatus;

        final hasResult =
            current.submissionStatus == AddLessonSubmissionStatus.success ||
            current.submissionStatus == AddLessonSubmissionStatus.failure;

        return submissionChanged && hasResult;
      },
      listener: (context, state) async {
        final cubit = context.read<AddLessonCubit>();

        if (state.submissionSucceeded) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CustomOperationResultDialog(
                type: CustomOperationResultType.success,
                title: 'تمت الإضافة بنجاح',
                message: 'تمت إضافة الدرس بنجاح.',
                actionText: 'حسنًا',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (!context.mounted) return;

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
                title: 'تعذر إضافة الدرس',
                message: error.message,
                actionText: 'حاول مرة أخرى',
                onActionPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          );

          if (!context.mounted) return;

          cubit.consumeSubmissionResult();
        }
      },
      child: child,
    );
  }
}
