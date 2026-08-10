import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_state.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_form.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_loading_skeleton.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_saved_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionBody extends StatelessWidget {
  const LiveSessionBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      LiveSessionCubit,
      LiveSessionState
    >(
      builder: (context, state) {
        final isInitialLoading =
            state.status == LiveSessionStatus.initial ||
            state.status == LiveSessionStatus.loading;

        if (isInitialLoading &&
            !state.hasLiveSession) {
          return const LiveSessionLoadingSkeleton();
        }

        if (state.hasLiveSession) {
          return LiveSessionSavedContent(
            liveSession: state.liveSession!,
            isDeleting: state.isDeleting,
          );
        }

        return LiveSessionForm(
          state: state,
        );
      },
    );
  }
}