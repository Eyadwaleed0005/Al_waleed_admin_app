import 'package:alwaleed_admain/core/widgets/custom_operation_result_dialog.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionFeedbackListener extends StatelessWidget {
  const LiveSessionFeedbackListener({super.key, required this.child});

  final Widget child;

  Future<void> _showDeleteFailureDialog(
    BuildContext context,
    LiveSessionState state,
  ) async {
    final errorModel = state.errorModel;

    if (errorModel == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: 'تعذر حذف الرابط',
          message: errorModel.message,
          actionText: 'حسنًا',
        );
      },
    );

    if (!context.mounted) {
      return;
    }

    context.read<LiveSessionCubit>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LiveSessionCubit, LiveSessionState>(
      listenWhen: (previous, current) {
        return previous.status == LiveSessionStatus.deleting &&
            current.status == LiveSessionStatus.failure &&
            current.errorModel != null;
      },
      listener: (context, state) {
        _showDeleteFailureDialog(context, state);
      },
      child: child,
    );
  }
}
