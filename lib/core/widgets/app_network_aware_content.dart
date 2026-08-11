import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_state.dart';
import 'package:alwaleed_admain/core/widgets/app_offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNetworkAwareContent extends StatelessWidget {
  const AppNetworkAwareContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NetworkStatusCubit, NetworkStatusState, bool>(
      selector: (state) {
        return state is NetworkStatusDisconnected && state.showOfflineBanner;
      },
      builder: (context, shouldShowOfflineBanner) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (shouldShowOfflineBanner)
              AppOfflineBanner(
                key: const ValueKey('app-offline-banner'),
                onHidden: () {
                  context.read<NetworkStatusCubit>().hideOfflineBanner();
                },
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
