import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/cubit/app_startup_state.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/widgets/blurred_oval_shadow.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/widgets/splash_loading_bar.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/widgets/splash_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartupCubit, AppStartupState>(
      listenWhen: (previous, current) {
        return current is AppStartupCompleted;
      },
      listener: (context, state) {
        if (state is AppStartupCompleted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.mainNavigationScreen, (route) => false);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: Scaffold(
          backgroundColor: ColorPalette.deepSurface,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppAnimations.logoEntrance(
                            child: AppAnimations.logoFloating(
                              child: Image.asset(
                                AppImage().alwaleedImg,
                                width: 280.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          AppAnimations.shadowEntrance(
                            child: AppAnimations.shadowPulse(
                              child: const BlurredOvalShadow(translateY: -35),
                            ),
                          ),

                          verticalSpace(18),

                          AppAnimations.primaryTitle(
                            child: SplashTitleText(
                              text: 'منصة الوليد للكيمياء',
                              style: AppTextStyle.font20HighlightSemiBoldKufam(),
                            ),
                          ),

                          verticalSpace(35),

                          AppAnimations.secondaryTitle(
                            child: SplashTitleText(
                              text: 'كيمياء بوضوح... من أول ذرة',
                              style: AppTextStyle.font14AccentRegularTajawal(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppAnimations.loadingBar(
                    child: SplashLoadingBar(
                      onCompleted: () {
                        context.read<AppStartupCubit>().completeStartup();
                      },
                    ),
                  ),

                  verticalSpace(16),

                  AppAnimations.loadingText(
                    child: SplashTitleText(
                      text: 'جاري تجهيز لوحة المعلم',
                      style: AppTextStyle.font14AccentRegularTajawal(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
