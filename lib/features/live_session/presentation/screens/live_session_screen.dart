import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/app_refresh_indicator.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/live_session_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_body.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_feedback_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LiveSessionCubit>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        body: LiveSessionBackground(
          child: SafeArea(
            child: AppNetworkAwareContent(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppAnimations.screenSection(
                      delay: 0,
                      child: CustomHeaderBar(
                        title: 'رابط الحصة المباشرة',
                        iconPath: AppImage().profileIcon,
                      ),
                    ),
                    verticalSpace(35),
                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 100,
                        child: LiveSessionFeedbackListener(
                          child: AppRefreshIndicator(
                            onRefresh: cubit.refreshLiveSession,
                            child: const LiveSessionBody(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
