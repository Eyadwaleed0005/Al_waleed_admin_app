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
      selector: (NetworkStatusState state) {
        return state is NetworkStatusDisconnected && state.showOfflineBanner;
      },
      builder: (BuildContext context, bool shouldShowOfflineBanner) {
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            child,
            if (shouldShowOfflineBanner)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: AppOfflineBanner(
                  key: const ValueKey<String>('app-offline-banner'),
                  onHidden: () {
                    context.read<NetworkStatusCubit>().hideOfflineBanner();
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
